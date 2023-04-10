import 'package:flutter/material.dart';
import 'package:pmanager/models/member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

class EditMemberDialog extends StatefulWidget {
  final Member member;
  final Function refresh;

  const EditMemberDialog(
      {super.key, required this.member, required this.refresh});

  @override
  State<EditMemberDialog> createState() => _EditMemberDialogState();
}

class _EditMemberDialogState extends State<EditMemberDialog> {

  final TextEditingController _tecNombre = TextEditingController();
  final TextEditingController _tecCargo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _tecNombre.text = widget.member.nombre as String;
    _tecCargo.text = widget.member.cargo as String;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 15),
          Text('ID: [${widget.member.id}]'),
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
                    client.from('integrante')
                    .update({
                      'nombre': _tecNombre.text,
                      'cargo': _tecCargo.text,
                    })
                    .eq('id', widget.member.id)
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