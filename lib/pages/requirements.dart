import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:geproye/models/project.dart';
import 'package:geproye/models/requirement.dart';
import 'package:geproye/pages/add_requirement.dart';
import 'package:geproye/pages/edit_requirement.dart';

class RequirementsPage extends StatefulWidget {
  final Project project;

  const RequirementsPage({super.key, required this.project});

  @override
  State<RequirementsPage> createState() => _RequirementsPageState();
}

class _RequirementsPageState extends State<RequirementsPage> {
  int lastId = 0;

  Future<List<Requirement>> getRequirements() async {
    try {
      final response = await http.get(Uri.parse('${const String.fromEnvironment('API_URL')}/project/${widget.project.id}/requirement'));
      final body = json.decode(response.body);
      final requirements = List<Requirement>.from(body['data'].map((pj) {
        return Requirement.fromJson(pj);
      }).toList());
      lastId = requirements.last.id;
      return requirements;
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
          title: Text('[${widget.project.nombre}] Requisitos'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder<List<Requirement>>(
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
                          itemBuilder: (context, index) => ExpansionTile(
                            title: Text('[ID: ${data[index].id}]'),
                            subtitle: Text('${data[index].tipo}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Editar',
                                  color: Colors.blue,
                                  onPressed: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                      child: EditRequirementDialog(projectId: widget.project.id, requirement: data[index], refresh: refresh),
                                    ),
                                  ),
                                  icon: const Icon(Icons.edit)
                                ),
                                IconButton(
                                  tooltip: 'Eliminar',
                                  color: Colors.red,
                                  onPressed: () async {
                                    try {
                                      final response = await http.delete(Uri.parse('${const String.fromEnvironment('API_URL')}/project/${widget.project.id}/requirement/${data[index].id}'));
                                      refresh();
                                    } catch (e) {
                                      print('error fetch: ${e.toString()}');
                                    }
                                  },
                                  icon: const Icon(Icons.delete)
                                ),
                              ],
                            ),
                            children: [
                              Text(data[index].descripcion ?? 'Sin descripcion'),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: AddRequirementDialog(projectId: widget.project.id, lastId: lastId, refresh: refresh),
            ),
          ),
          tooltip: 'Añadir Requisito',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
