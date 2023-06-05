import 'dart:convert';

import 'package:geproye/router_generator.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:geproye/models/project.dart';
import 'package:geproye/pages/add_project.dart';
import 'package:geproye/pages/edit_project.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  int lastId = 0;

  Future<List<Project>> getProjects() async {
    try {
      final response =
          await http.get(Uri.parse('${const String.fromEnvironment('API_URL')}/project'));
      final body = json.decode(response.body);
      final projects = List<Project>.from(body['data'].map((pj) {
        return Project.fromJson(pj);
      }).toList());
      lastId = projects.last.id;
      return projects;
    } catch (e) {
      print('error fetch: ${e.toString()}');
    }

    return [];
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GEPROYE'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                  .pushNamed('/chat');
              },
              icon: const Icon(Icons.chat),
              tooltip: 'Chat'),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () async {
                      await supabase.auth.signOut();
                    },
                    child: const Text('Cerrar sesión'),
                  ),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Proyectos',
              textScaleFactor: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: FutureBuilder<List<Project>>(
                future: getProjects(),
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
                          title: Text(
                              '[ID: ${data[index].id}] ${data[index].nombre}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  tooltip: 'Ver',
                                  color: Colors.blue,
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushNamed('/project',
                                            arguments: data[index]);
                                  },
                                  icon: const Icon(Icons.open_in_new)),
                              IconButton(
                                  tooltip: 'Editar',
                                  color: Colors.blue,
                                  onPressed: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            Dialog(
                                          child: EditProjectDialog(
                                              project: data[index],
                                              refresh: refresh),
                                        ),
                                      ),
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  tooltip: 'Eliminar',
                                  color: Colors.red,
                                  onPressed: () async {
                                    try {
                                      final response = await http.delete(Uri.parse(
                                          '${const String.fromEnvironment('API_URL')}/project/${data[index].id}'));
                                      refresh();
                                    } catch (e) {
                                      print('error fetch: ${e.toString()}');
                                    }
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      );
                    }

                    return Text("1.- Error: ${snapshot.error.toString()}");
                  }

                  return Text("2.- Error: ${snapshot.error.toString()}");
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: AddProjectDialog(lastId: lastId, refresh: refresh),
          ),
        ),
        tooltip: 'Añadir proyecto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
