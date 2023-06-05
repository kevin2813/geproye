class Activity {
  final int id;
  final int projectId;
  final int iterationId;
  final String? nombre;
  final String? ejecutor;
  final String? fechaInicio;
  final String? fechaTermino;

  Activity(
      {required this.id,
      required this.projectId,
      required this.iterationId,
      this.nombre,
      this.ejecutor,
      this.fechaInicio,
      this.fechaTermino,
      });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      projectId: json['fk_proyecto'],
      iterationId: json['fk_iteracion'],
      nombre: json['nombre'],
      ejecutor: json['ejecutor'],
      fechaInicio: json['fechaInicio'],
      fechaTermino: json['fechaTermino'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'fk_proyecto': projectId,
      'fk_iteracion': iterationId,
      'nombre': nombre,
      'ejecutor': ejecutor,
      'fechaInicio': fechaInicio,
      'fechaTermino': fechaTermino,
    };
  }
}
