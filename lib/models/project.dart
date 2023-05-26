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
      fechaInicio: json['fechaInicio'],
      fechaTermino: json['fechaTermino'],
      estado: json['estado'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'fechaInicio': fechaInicio,
      'fechaTermino': fechaTermino,
      'estado': estado,
    };
  }
}
