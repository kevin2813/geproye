import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:geproye/models/requirement.dart';

class EditRequirementDialog extends StatefulWidget {
  final int projectId;
  final Requirement requirement;
  final Function refresh;

  const EditRequirementDialog(
      {super.key, required this.projectId, required this.requirement, required this.refresh});

  @override
  State<EditRequirementDialog> createState() => _EditRequirementDialogState();
}

class _EditRequirementDialogState extends State<EditRequirementDialog> {

  final TextEditingController _tecTipo = TextEditingController();
  final TextEditingController _tecDescripcion = TextEditingController();

  @override
  void initState() {
    super.initState();

    _tecTipo.text = widget.requirement.tipo??'';
    _tecDescripcion.text = widget.requirement.descripcion??'';
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
                onPressed: () async {
                  try {
                    var res = await http.patch(Uri.parse('${const String.fromEnvironment('API_URL')}/project/${widget.projectId}/requirement/${widget.requirement.id}'), body: <String, String>{
                      'tipo': _tecTipo.text,
                      'descripcion': _tecDescripcion.text,
                    });
                    
                    if(context.mounted) Navigator.pop(context);
                    widget.refresh();

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