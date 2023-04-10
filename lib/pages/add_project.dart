import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

class AddProjectDialog extends StatefulWidget {
  final int lastId;
  final Function refresh;

  const AddProjectDialog(
      {super.key, required this.lastId, required this.refresh});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final TextEditingController _tecNombre = TextEditingController();
  DateTime? _dtFechaInicio;
  DateTime? _dtFechaTermino;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Nombre:'),
          TextField(
            controller: _tecNombre,
          ),
          const SizedBox(height: 15),
          const Text('Fecha de inicio:'),
          Row(
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
                onPressed: () {
                  if (_tecNombre.text.isEmpty) {
                    Navigator.pop(context);
                    return;
                  }
                  try {
                    client.from('proyecto').insert({
                      'id': widget.lastId + 1,
                      'nombre': _tecNombre.text,
                      'fecha_inicio': _dtFechaInicio?.toString(),
                      'fecha_termino': _dtFechaTermino?.toString(),
                      'estado': '',
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