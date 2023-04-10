import 'package:flutter/material.dart';
import 'package:pmanager/models/project.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

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
  final TextEditingController _tecEstado = TextEditingController();
  DateTime? _dtFechaInicio;
  DateTime? _dtFechaTermino;

  @override
  Widget build(BuildContext context) {

    _tecNombre.text = widget.project.nombre??'';
    _tecEstado.text = widget.project.estado??'';
    if(widget.project.fechaInicio != null){
      _dtFechaInicio = DateTime.parse(widget.project.fechaInicio as String);
    }
    if(widget.project.fechaTermino != null){
      _dtFechaTermino = DateTime.parse(widget.project.fechaTermino as String);
    }

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
          TextField(
            textAlign: TextAlign.center,
            controller: _tecEstado,
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
                  if (_tecNombre.text.isEmpty) {
                    Navigator.pop(context);
                    return;
                  }
                  try {
                    client.from('proyecto')
                    .update({
                      'nombre': _tecNombre.text,
                      'fecha_inicio': _dtFechaInicio?.toString(),
                      'fecha_termino': _dtFechaTermino?.toString(),
                      'estado': _tecEstado.text,
                    })
                    .eq('id', widget.project.id)
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