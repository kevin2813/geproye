import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:peerdart/peerdart.dart';

final supabase = Supabase.instance.client;
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final host = dotenv.env['PEER_HOST']!.replaceFirst('http://', '');
  final port = int.parse(dotenv.env['PEER_PORT']!);
  final path = dotenv.env['PEER_PATH'];
  late Peer peer;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _chatController = TextEditingController();
  String? peerId;
  late DataConnection conn;
  bool connected = false;
  List<String> messages = [];

   @override
  void dispose() {
    peer.dispose();
    _controller.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    try{
    peer = Peer(options: PeerOptions(host: host, port: port, path: path, debug: LogLevel.All, secure: false));
    //peer = Peer(options: PeerOptions(host: 'geproyepeer.azurewebsites.net', path: '/peer', debug: LogLevel.All));

    peer.on("open").listen((id) {
      setState(() {
        peerId = peer.id;
      });
    });

    peer.on<DataConnection>("connection").listen((event) {
      conn = event;

      conn.on("data").listen((data) {
        setState(() {
          messages.add(data);
        });
      });

      conn.on("binary").listen((data) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Got binary")));
      });

      conn.on("close").listen((event) {
        setState(() {
          connected = false;
        });
      });

      setState(() {
        connected = true;
      });
      
    });
    } catch (e) {
      print('ERROR PEER: ' + e.toString());
    }
  }

  void connect() {
    final connection = peer.connect(_controller.text);
    conn = connection;

    conn.on("open").listen((event) {
      setState(() {
        connected = true;
      });

      connection.on("close").listen((event) {
        setState(() {
          connected = false;
        });
      });

      conn.on("data").listen((data) {
        setState(() {
          messages.add(data);
        });
      });
      conn.on("binary").listen((data) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Got binary!")));
      });
    });
  }

  void sendHelloWorld() {
    conn.send(_chatController.text);
    messages.add(_chatController.text);
  }

  void sendBinary() {
    final bytes = Uint8List(30);
    conn.sendBinary(bytes);
  }

  @override
  Widget build(BuildContext context) {
    if(!connected){
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _renderState(),
              const Text(
                'Connection ID:',
              ),
              SelectableText(peerId ?? ""),
              TextField(
                controller: _controller,
              ),
              ElevatedButton(onPressed: connect, child: const Text("connect")),
              ElevatedButton(
                  onPressed: sendHelloWorld,
                  child: const Text("Send Hello World to peer")),
              ElevatedButton(
                  onPressed: sendBinary,
                  child: const Text("Send binary to peer")),
            ],
          ),
        ));
    } else {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _renderState(),
              const Text(
                'CHAT:',
              ),
              Expanded(child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index])
                  );
                })),
              TextField(
                controller: _chatController,
              ),
              ElevatedButton(
                  onPressed: sendHelloWorld,
                  child: const Text("Send Text")),
              ElevatedButton(
                  onPressed: sendBinary,
                  child: const Text("Send binary to peer")),
            ],
          ),
        ));
    }
  }

  Widget _renderState() {
    Color bgColor = connected ? Colors.green : Colors.grey;
    Color txtColor = Colors.white;
    String txt = connected ? "Connected" : "Standby";
    return Container(
      decoration: BoxDecoration(color: bgColor),
      child: Text(
        txt,
        style:
            Theme.of(context).textTheme.titleLarge?.copyWith(color: txtColor),
      ),
    );
  }
}



/* import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geproye/models/chat_user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

final supabase = Supabase.instance.client;

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  String ip = "";

  Future<List<ChatUser>> getChatUsers() async {
    try {
      final response = await http.get(Uri.parse('${dotenv.env['API_URL']}/discover'));
      final body = json.decode(response.body);
      final chatUsers = List<ChatUser>.from(body.map((pj) {
        final user = ChatUser.fromJson(pj);
        return user.ip != ip ? user : null;
      }).where((user) => user != null).toList());
      
      return chatUsers;
    } catch (e) {
      print('error[chat]: ${e.toString()}');
    }

    return [];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Ingreso')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 180.0,
              child: Center(
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
          ),
          const SizedBox(height: 60,),
          Text('Bienvenido!', style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold, fontSize: 42),),
          const SizedBox(height: 30,),
          Expanded(
            child: FutureBuilder<List<ChatUser>>(
              future: getChatUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState ==
                    ConnectionState.done) {
                  final data = snapshot.data;
                  if (data != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20.0),
                      child: Table(
                        border: const TableBorder(
                          horizontalInside: BorderSide(
                              width: 1,
                              color: Color.fromARGB(79, 33, 149, 243),
                              style: BorderStyle.solid),
                          verticalInside: BorderSide(
                              width: 1,
                              color: Color.fromARGB(79, 33, 149, 243),
                              style: BorderStyle.solid)
                          ),
                        columnWidths: const {
                          0: FractionColumnWidth(0.5),
                          1: FractionColumnWidth(0.5),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          const TableRow(
                            children: [
                              Center(
                                child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              Center(
                                child: Text('Ip', style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                          for (var it in data)
                            TableRow(
                              children: [
                                Center(
                                    child: Text(
                                        it.email ?? 'Sin definir')),
                                Center(
                                    child: Text(
                                        it.ip ?? 'Sin definir')),
                              ],
                            ),
                        ],
                      ),
                    );
                  }

                  return const Text("No found");
                }

                return const Text("Error");
              }),
          ),
        ],
      ),
    );
  }
} */