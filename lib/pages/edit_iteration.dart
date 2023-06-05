import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:geproye/models/iteration.dart';

class EditIterationDialog extends StatefulWidget {
  final int projectId;
  final Iteration iteration;
  final Function refresh;

  const EditIterationDialog(
      {super.key, required this.projectId, required this.iteration, required this.refresh});

  @override
  State<EditIterationDialog> createState() => _EditIterationDialogState();
}

class _EditIterationDialogState extends State<EditIterationDialog> {
  DateTime? _dtFechaInicio;
  DateTime? _dtFechaTermino;

  @override
  void initState() {
    super.initState();

    if(widget.iteration.fechaInicio != null){
      _dtFechaInicio = DateTime.parse(widget.iteration.fechaInicio as String);
    }
    if(widget.iteration.fechaTermino != null){
      _dtFechaTermino = DateTime.parse(widget.iteration.fechaTermino as String);
    }
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
          Text('ID: [${widget.iteration.id}]'),
          const SizedBox(height: 15),
          const Text('Fecha de inicio:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100))
                    .then((pickedDate) {
                  // Check if no date is selected
                  if (pickedDate == null) {
                    return;
                  }
                  setState(() {
                    // using state so that the UI will be rerendered when date is picked
                    _dtFechaInicio = pickedDate;
                  });
                }),
                icon: const Icon(Icons.date_range),
              ),
              Text(_dtFechaInicio != null ? _dtFechaInicio.toString() : 'Sin definir'),
            ],
          ),
          const SizedBox(height: 15),
          const Text('Fecha de termino:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2050))
                    .then((pickedDate) {
                  if (pickedDate == null) {
                    return;
                  }
                  setState(() {
                    _dtFechaTermino = pickedDate;
                  });
                }),
                icon: const Icon(Icons.date_range),
              ),
              Text(_dtFechaTermino != null ? _dtFechaTermino.toString() : 'Sin definir'),
            ],
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
                  final f = DateFormat('yyyy-MM-dd');
                  try {
                    var res = await http.patch(Uri.parse('${const String.fromEnvironment('API_URL')}/project/${widget.projectId}/iteration/${widget.iteration.id}'), body: <String, String>{
                      'fecha_inicio': f.format(_dtFechaInicio??DateTime.now()).toString(),
                      'fecha_termino': f.format(_dtFechaTermino??DateTime.now()).toString(),
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