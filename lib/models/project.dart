class Project {
  final int id;
  final String? nombre;
  final String? fechaInicio;
  final String? fechaTermino;
  final String? estado;

  Project(
      {required this.id,
      this.nombre,
      this.fechaInicio,
      this.fechaTermino,
      this.estado});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      nombre: json['nombre'],
      fechaInicio: json['fecha_inicio'],
      fechaTermino: json['fecha_termino'],
      estado: json['estado'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'fecha_inicio': fechaInicio,
      'fecha_termino': fechaTermino,
      'estado': estado,
    };
  }
}
