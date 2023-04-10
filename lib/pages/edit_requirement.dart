import 'package:flutter/material.dart';
import 'package:pmanager/models/requirement.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

class EditRequirementDialog extends StatefulWidget {
  final Requirement requirement;
  final Function refresh;

  const EditRequirementDialog(
      {super.key, required this.requirement, required this.refresh});

  @override
  State<EditRequirementDialog> createState() => _EditRequirementDialogState();
}

class _EditRequirementDialogState extends State<EditRequirementDialog> {

  final TextEditingController _tecTipo = TextEditingController();
  final TextEditingController _tecDescripcion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _tecTipo.text = widget.requirement.tipo as String;
    _tecDescripcion.text = widget.requirement.descripcion as String;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 15),
          Text('ID: [${widget.requirement.id}]'),
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
                    client.from('requisito')
                    .update({
                      'tipo': _tecTipo.text,
                      'descripcion': _tecDescripcion.text,
                    })
                    .eq('id', widget.requirement.id)
                    .then((element) {
                      widget.refresh();
                      Navigator.pop(context);
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