import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

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
                onPressed: () async {
                  try {
                    var res = await http.post(Uri.parse('${const String.fromEnvironment('API_URL')}/project/${widget.projectId}/requirement'), body: <String, String>{
                      //'id': '${widget.lastId + 1}',
                      'tipo': _tecTipo.text,
                      'descripcion': _tecDescripcion.text,
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