import 'package:flutter/material.dart';
import 'package:pmanager/models/project.dart';
import 'package:pmanager/models/requirement.dart';
import 'package:pmanager/pages/add_requirement.dart';
import 'package:pmanager/pages/edit_requirement.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequirementsPage extends StatefulWidget {
  final Project project;

  const RequirementsPage({super.key, required this.project});

  @override
  State<RequirementsPage> createState() => _RequirementsPageState();
}

final client = Supabase.instance.client;

class _RequirementsPageState extends State<RequirementsPage> {
  int lastId = 0;

  Future<List<Requirement>> getRequirements() async {
    final response = await client
      .from('requisito')
      .select('*')
      .eq('fk_proyecto', widget.project.id)
      .order('id', ascending: true);

    if(response.length <= 0) {
      return [];
    }

    try {
      final requirements = List<Requirement>.from(response.map((pj) {
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
                                      child: EditRequirementDialog(requirement: data[index], refresh: refresh),
                                    ),
                                  ),
                                  icon: const Icon(Icons.edit)
                                ),
                                IconButton(
                                  tooltip: 'Eliminar',
                                  color: Colors.red,
                                  onPressed: () {
                                    client.from('requisito')
                                    .delete()
                                    .eq('id', data[index].id)
                                    .then((val) {
                                      refresh();
                                    },);
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
