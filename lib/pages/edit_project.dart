import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:geproye/models/project.dart';

const List<String> list = <String>['Creado', 'En Curso', 'Terminado'];

class EditProjectDialog extends StatefulWidget {
  final Project project;
  final Function refresh;

  const EditProjectDialog(
      {super.key, required this.project, required this.refresh});

  @override
  State<EditProjectDialog> createState() => _EditProjectDialogState();
}

class _EditProjectDialogState extends State<EditProjectDialog> {
  final TextEditingController _tecNombre = TextEditingController();
  DateTime? _dtFechaInicio;
  DateTime? _dtFechaTermino;
  String dropdownValue = list.first;

  @override
  void initState() {
    super.initState();

    _tecNombre.text = widget.project.nombre??'';
    dropdownValue = widget.project.estado??list.first;
    if(widget.project.fechaInicio != null){
      _dtFechaInicio = DateTime.parse(widget.project.fechaInicio as String);
    }
    if(widget.project.fechaTermino != null){
      _dtFechaTermino = DateTime.parse(widget.project.fechaTermino as String);
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
          Text('ID: [${widget.project.id}]'),
          const SizedBox(height: 15),
          const Text('Nombre:'),
          TextField(
            textAlign: TextAlign.center,
            controller: _tecNombre,
          ),
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
          const SizedBox(height: 15),
          const Text('Estado:'),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.blue),
            underline: Container(
              height: 2,
              color: Colors.blueAccent,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
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
                  if (_tecNombre.text.isEmpty) {
                    Navigator.pop(context);
                    return;
                  }
                  final f = DateFormat('yyyy-MM-dd');
                  try {
                    var res = await http.patch(Uri.parse('${const String.fromEnvironment('API_URL')}/project/${widget.project.id}'), body: <String, String>{
                      'nombre': _tecNombre.text,
                      'fechaInicio': f.format(_dtFechaInicio??DateTime.now()).toString(),
                      'fechaTermino': f.format(_dtFechaTermino??DateTime.now()).toString(),
                      'estado': dropdownValue,
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