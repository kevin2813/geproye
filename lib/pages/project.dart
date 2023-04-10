import 'package:flutter/material.dart';
import 'package:pmanager/models/iteration.dart';
import 'package:pmanager/models/project.dart';
import 'package:pmanager/pages/add_iteration.dart';
import 'package:pmanager/pages/edit_iteration.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjectPage extends StatefulWidget {
  final Project project;

  const ProjectPage({super.key, required this.project});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

final client = Supabase.instance.client;

class _ProjectPageState extends State<ProjectPage> {
  int lastId = 0;

  Future<List<Iteration>> getIterations() async {
    final response = await client
        .from('iteracion')
        .select('*')
        .eq('fk_proyecto', widget.project.id)
        .order('id', ascending: true);

    if (response.length <= 0) {
      return [];
    }

    try {
      final iterations = List<Iteration>.from(response.map((pj) {
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
                              1: FractionColumnWidth(0.30),
                              2: FractionColumnWidth(0.30),
                              3: FractionColumnWidth(0.35),
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
                                                            widget.project); */
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
                                                              iteration: it,
                                                              refresh: refresh),
                                                    ),
                                                  ),
                                              icon: const Icon(Icons.edit)),
                                          IconButton(
                                              tooltip: 'Eliminar',
                                              color: Colors.red,
                                              onPressed: () {
                                                client
                                                    .from('iteracion')
                                                    .delete()
                                                    .eq('id', it.id)
                                                    .then(
                                                  (val) {
                                                    refresh();
                                                  },
                                                );
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
