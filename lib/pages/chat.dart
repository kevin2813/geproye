import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:peerdart/peerdart.dart';

class Message {
  String sender;
  String date;
  String message;
  Message(this.sender, this.date, this.message);
}

final supabase = Supabase.instance.client;
final email = supabase.auth.currentUser!.email!;
String emailSender = "";

extension on List<Message>{
  void addIf(Message msg) {
    if(any((element) => element.sender == msg.sender && element.message == msg.message && DateTime.parse(msg.date).difference(DateTime.parse(element.date)).inSeconds < 2)) return;
    add(msg);
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final host = const String.fromEnvironment('PEER_HOST')!.replaceFirst('https://', '');
  final path = '/peer';
  late Peer peer;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _chatController = TextEditingController();
  String? peerId;
  late DataConnection conn;
  bool connected = false;
  List<Message> messages = [];

   @override
  void dispose() {
    peer.close();
    peer.dispose();
    _controller.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    peer = Peer(options: PeerOptions(host: host, path: path, debug: LogLevel.Errors, secure: true));
    //peer = Peer(options: PeerOptions(host: 'geproyepeer.azurewebsites.net', path: '/peer', debug: LogLevel.All));

    peer.on("open").listen((id) {
      print('data open1');
      setState(() {
        peerId = peer.id;
      });
    });
    /*
    peer.on<DataConnection>("connection").listen((event) {
      conn = event;

      conn.on("data").listen((data) {
        print('data recibida1');
        setState(() {
          if(emailSender != data['sender']) {emailSender = data['sender'];}
          messages.addIf(Message(data['sender'], DateTime.now().toString(), data['message']));
        });
      });

      conn.on("binary").listen((data) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Got binary")));
      });

      conn.on("close").listen((event) {
        print('data close1');
        setState(() {
          connected = false;
        });
      });

      setState(() {
        connected = true;
      });
      
    }); */
  }

  void connect() {
    final connection = peer.connect(_controller.text);
    conn = connection;

    conn.on("open").listen((event) {
      print('data open2');
      setState(() {
        peerId = peer.id;
        connected = true;
      });

      conn.on("close").listen((event) {
        print('data close2');
        setState(() {
          connected = false;
        });
      });

      conn.on("data").listen((data) {
        print('data recibida2');
        if(emailSender != data['sender']) {emailSender = data['sender'];}
        setState(() {
          messages.addIf(Message(data['sender'], DateTime.now().toString(), data['message']));
        });
      });
      conn.on("binary").listen((data) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Got binary!")));
      });
    });
  }

  void sendHelloWorld() {
    final now = DateTime.now().toString();
    conn.send({ 'sender': supabase.auth.currentUser!.email!, 'date': now, 'message': _chatController.text });
    setState(() {
      messages.addIf(Message(email, now, _chatController.text));
      _chatController.text = '';
    });
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
            ],
          ),
        ));
    } else {
      return Scaffold(
        appBar: AppBar(title: Text(emailSender),),
        body: SafeArea(
          child: Center(
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
                    final isSender = messages[index].sender == email;
                    final bg = isSender ? Colors.white : Colors.lightBlue.shade100;
        
                    return ListTile(
                      title: Text(messages[index].message),
                      subtitle: Text(messages[index].date),
                      tileColor: bg,
                    );
                  })),
                TextField(
                  controller: _chatController,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                  ),
                ),
                ElevatedButton(
                    onPressed: sendHelloWorld,
                    child: const Text("Send Text")),
                ElevatedButton(
                    onPressed: sendBinary,
                    child: const Text("Send binary to peer")),
              ],
            ),
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
