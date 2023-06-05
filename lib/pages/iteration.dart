import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:geproye/models/iteration.dart';
import 'package:geproye/models/activity.dart';
import 'package:geproye/pages/add_iteration.dart';
import 'package:geproye/pages/edit_iteration.dart';
import 'package:http/http.dart' as http;

class ActivityPage extends StatefulWidget {
  final Iteration iteration;

  const ActivityPage({super.key, required this.iteration});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}


class _ActivityPageState extends State<ActivityPage> {
  int lastId = 0;

  Future<List<Iteration>> getIterations() async {
    try {
      final response = await http.get(Uri.parse('${const String.fromEnvironment('API_URL')}/v1/project'));
      final body = json.decode(response.body);
      final projects = List<Iteration>.from(body['data'].map((pj) {
        return Iteration.fromJson(pj);
      }).toList());
      lastId = projects.last.id;
      return projects;
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
          actions: [
            IconButton(
              onPressed: () {
                /* Navigator.of(context, rootNavigator: true)
                    .pushNamed('/requirements', arguments: widget.Activity); */
              },
              tooltip: 'Requisitos',
              icon: const Icon(Icons.notes),
            ),
            IconButton(
              onPressed: () {
                /* Navigator.of(context, rootNavigator: true)
                    .pushNamed('/members', arguments: widget.activity); */
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
                                              tooltip: 'Ver Actividades',
                                              color: Colors.blue,
                                              onPressed: () {
                                                /* Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pushNamed('/activities',
                                                        arguments:
                                                            widget.Activity); */
                                              },
                                              icon: const Icon(Icons.list)),
                                          IconButton(
                                              tooltip: 'Editar',
                                              color: Colors.blue,
                                              onPressed: () {},
                                              icon: const Icon(Icons.edit)),
                                          IconButton(
                                              tooltip: 'Eliminar',
                                              color: Colors.red,
                                              onPressed: () {
                                                
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
        /*floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: AddIterationDialog(
                  ActivityId: widget.Activity.id,
                  lastId: lastId,
                  refresh: refresh),
            ),
          ),
          tooltip: 'Añadir Iteracion',
          child: const Icon(Icons.add),
        ),*/
      ),
    );
  }
}
