import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

class AddMemberDialog extends StatefulWidget {
  final int projectId;
  final int lastId;
  final Function refresh;

  const AddMemberDialog(
      {super.key, required this.projectId, required this.lastId, required this.refresh});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  
  final TextEditingController _tecNombre = TextEditingController();
  final TextEditingController _tecCargo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 15),
          const Text('Nombre:'),
          TextField(
            controller: _tecNombre,
          ),
          const SizedBox(height: 15),
          const Text('Cargo:'),
          TextField(
            controller: _tecCargo,
          ),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:
                    const Text('Cancelar', style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () {
                  try {
                    client.from('integrante').insert({
                      'id': widget.lastId + 1,
                      'fk_proyecto': widget.projectId,
                      'nombre': _tecNombre.text,
                      'cargo': _tecCargo.text,
                    }).then((element) {
                      Navigator.pop(context);
                      widget.refresh();
                    });
                  } catch (e) {
                    print('error: ${e.toString()}');
                  }
                },
                child: const Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}