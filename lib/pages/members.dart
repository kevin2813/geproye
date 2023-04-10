import 'package:flutter/material.dart';
import 'package:pmanager/models/member.dart';
import 'package:pmanager/models/project.dart';
import 'package:pmanager/pages/add_member.dart';
import 'package:pmanager/pages/edit_member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MembersPage extends StatefulWidget {
  final Project project;

  const MembersPage({super.key, required this.project});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

final client = Supabase.instance.client;

class _MembersPageState extends State<MembersPage> {
  int lastId = 0;

  Future<List<Member>> getRequirements() async {
    final response = await client
      .from('integrante')
      .select('*')
      .eq('fk_proyecto', widget.project.id)
      .order('id', ascending: true);

    if(response.length <= 0) {
      return [];
    }

    try {
      final members = List<Member>.from(response.map((pj) {
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
                                      child: EditMemberDialog(member: data[index], refresh: refresh),
                                    ),
                                  ),
                                  icon: const Icon(Icons.edit)
                                ),
                                IconButton(
                                  tooltip: 'Eliminar',
                                  color: Colors.red,
                                  onPressed: () {
                                    client.from('integrante')
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
