import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:geproye/models/iteration.dart';
import 'package:geproye/models/project.dart';
import 'package:geproye/pages/add_iteration.dart';
import 'package:geproye/pages/edit_iteration.dart';

class ProjectPage extends StatefulWidget {
  final Project project;

  const ProjectPage({super.key, required this.project});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  int lastId = 0;

  Future<List<Iteration>> getIterations() async {
    try {
      final response = await http.get(Uri.parse('${const String.fromEnvironment('API_URL')}/project/${widget.project.id}/iteration'));
      final body = json.decode(response.body);
      final iterations = List<Iteration>.from(body['data'].map((pj) {
        return Iteration.fromJson(pj);
      }).toList());
      lastId = iterations.last.id;
      return iterations;
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
          title: Text(widget.project.nombre ?? 'Sin nombre'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed('/requirements', arguments: widget.project);
              },
              tooltip: 'Requisitos',
              icon: const Icon(Icons.notes),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed('/members', arguments: widget.project);
              },
              tooltip: 'Integrantes',
              icon: const Icon(Icons.group),
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            const Center(
              child: Text(
                'Iteraciones',
                textScaleFactor: 1.2,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder<List<Iteration>>(
                  future: getIterations(),
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
                                    style: BorderStyle.solid)),
                            columnWidths: const {
                              0: FractionColumnWidth(0.05),
                              1: FractionColumnWidth(0.25),
                              2: FractionColumnWidth(0.25),
                              3: FractionColumnWidth(0.45),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              const TableRow(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.0),
                                    child: Center(
                                      child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  Center(
                                    child: Text('Fecha de inicio', style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                  Center(
                                    child: Text('Fecha de termino', style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                  Center(
                                    child: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                ],
                              ),
                              for (var it in data)
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0),
                                      child: Center(child: Text('${it.id}')),
                                    ),
                                    Center(
                                        child: Text(
                                            it.fechaInicio ?? 'Sin definir')),
                                    Center(
                                        child: Text(
                                            it.fechaTermino ?? 'Sin definir')),
                                    Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              tooltip: 'Ver',
                                              color: Colors.blue,
                                              onPressed: () {
                                                Navigator.of(context, rootNavigator: true)
                                                  .pushNamed('/activity', arguments: it);
                                              },
                                              icon: const Icon(Icons.list)),
                                          IconButton(
                                              tooltip: 'Editar',
                                              color: Colors.blue,
                                              onPressed: () =>
                                                  showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        Dialog(
                                                      child:
                                                          EditIterationDialog(
                                                              projectId: widget.project.id,
                                                              iteration: it,
                                                              refresh: refresh),
                                                    ),
                                                  ),
                                              icon: const Icon(Icons.edit)),
                                          IconButton(
                                              tooltip: 'Eliminar',
                                              color: Colors.red,
                                              onPressed: () async {
                                                try {
                                                  final response = await http.delete(Uri.parse('${const String.fromEnvironment('API_URL')}/project/${widget.project.id}/iteration/${it.id}'));
                                                  refresh();
                                                } catch (e) {
                                                  print('error fetch: ${e.toString()}');
                                                }
                                              },
                                              icon: const Icon(Icons.delete)),
                                        ],
                                      ),
                                    ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: AddIterationDialog(
                  projectId: widget.project.id,
                  lastId: lastId,
                  refresh: refresh),
            ),
          ),
          tooltip: 'Añadir Iteracion',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
