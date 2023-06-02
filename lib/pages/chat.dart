import 'dart:async';
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

  Future<List<ChatUser>> getChatUsers() async {
    try {
      final response = await http.get(Uri.parse('${dotenv.env['API_URL']}/discover'));
      final body = json.decode(response.body);
      final chatUsers = List<ChatUser>.from(body.map((pj) {
        print(pj);
        return ChatUser.fromJson(pj);
      }).toList());
      
      return chatUsers;
    } catch (e) {
      print('error[chat]: ${e.toString()}');
    }

    return [];
  }

  @override
  void initState() {
    super.initState();

    try {
      final email = supabase.auth.currentUser?.email;
      http.get(Uri.parse('https://api.ipify.org')).then((resIp) {
        final ip = resIp.body;
        http.post(
          Uri.parse('${dotenv.env['API_URL']}/discover'), 
          body: <String, String>{
            //'id': '${widget.lastId + 1}',
            'email': email ?? 'UNNAMED',
            'ip': ip
          }
        );
      },);
    } catch (e) {
      print('error: ${e.toString()}');
    }
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
}