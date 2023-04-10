import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

class AddRequirementDialog extends StatefulWidget {
  final int projectId;
  final int lastId;
  final Function refresh;

  const AddRequirementDialog(
      {super.key, required this.projectId, required this.lastId, required this.refresh});

  @override
  State<AddRequirementDialog> createState() => _AddRequirementDialogState();
}

class _AddRequirementDialogState extends State<AddRequirementDialog> {
  
  final TextEditingController _tecTipo = TextEditingController();
  final TextEditingController _tecDescripcion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 15),
          const Text('Tipo:'),
          TextField(
            controller: _tecTipo,
          ),
          const SizedBox(height: 15),
          const Text('Descripcion:'),
          TextField(
            controller: _tecDescripcion,
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
                    client.from('requisito').insert({
                      'id': widget.lastId + 1,
                      'fk_proyecto': widget.projectId,
                      'tipo': _tecTipo.text,
                      'descripcion': _tecDescripcion.text,
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