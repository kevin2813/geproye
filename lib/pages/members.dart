import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:geproye/models/member.dart';
import 'package:geproye/models/project.dart';
import 'package:geproye/pages/add_member.dart';
import 'package:geproye/pages/edit_member.dart';

class MembersPage extends StatefulWidget {
  final Project project;

  const MembersPage({super.key, required this.project});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  int lastId = 0;

  Future<List<Member>> getRequirements() async {
    try {
      final response = await http.get(Uri.parse('${const String.fromEnvironment('API_URL')}/project/${widget.project.id}/member'));
      final body = json.decode(response.body);
      final members = List<Member>.from(body['data'].map((pj) {
        return Member.fromJson(pj);
      }).toList());
      lastId = members.last.id;
      return members;
    } catch (e) {
      print('error: ${e.toString()}');
    }

    return [];
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text('[${widget.project.nombre}] Integrantes'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder<List<Member>>(
                  future: getRequirements(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      final data = snapshot.data;
                      if (data != null) {
                        return ListView.separated(
                          separatorBuilder: (constext, index) => const Divider(
                            color: Color.fromARGB(111, 33, 149, 243),
                          ),
                          itemCount: data.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text('[ID: ${data[index].id}] ${data[index].nombre}'),
                            subtitle: Text('${data[index].cargo}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Editar',
                                  color: Colors.blue,
                                  onPressed: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                      child: EditMemberDialog(projectId: widget.project.id, member: data[index], refresh: refresh),
                                    ),
                                  ),
                                  icon: const Icon(Icons.edit)
                                ),
                                IconButton(
                                  tooltip: 'Eliminar',
                                  color: Colors.red,
                                  onPressed: () async {
                                    try {
                                      final response = await http.delete(Uri.parse('${const String.fromEnvironment('API_URL')}/project/${widget.project.id}/member/${data[index].id}'));
                                      refresh();
                                    } catch (e) {
                                      print('error fetch: ${e.toString()}');
                                    }
                                  },
                                  icon: const Icon(Icons.delete)
                                ),
                              ],
                            ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: AddMemberDialog(projectId: widget.project.id, lastId: lastId, refresh: refresh),
            ),
          ),
          tooltip: 'Añadir Requisito',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
