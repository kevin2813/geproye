import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:geproye/models/member.dart';

class EditMemberDialog extends StatefulWidget {
  final int projectId;
  final Member member;
  final Function refresh;

  const EditMemberDialog(
      {super.key, required this.projectId, required this.member, required this.refresh});

  @override
  State<EditMemberDialog> createState() => _EditMemberDialogState();
}

class _EditMemberDialogState extends State<EditMemberDialog> {

  final TextEditingController _tecNombre = TextEditingController();
  final TextEditingController _tecCargo = TextEditingController();

  @override
  void initState() {
    super.initState();

    _tecNombre.text = widget.member.nombre??'';
    _tecCargo.text = widget.member.cargo??'';
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () async {
                  try {
                    var res = await http.patch(Uri.parse('${const String.fromEnvironment('API_URL')}/project/${widget.projectId}/member/${widget.member.id}'), body: <String, String>{
                      'nombre': _tecNombre.text,
                      'cargo': _tecCargo.text,
                    });
                    
                    if(context.mounted) Navigator.pop(context);
                    widget.refresh();

                  } catch (e) {
                    print('error rq: ${e.toString()}');
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