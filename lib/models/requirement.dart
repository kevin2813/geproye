class Requirement {
  final int id;
  final int projectId;
  final String? tipo;
  final String? descripcion;

  Requirement(
      {required this.id,
      required this.projectId,
      this.tipo,
      this.descripcion,
      });

  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      id: json['id'],
      projectId: json['projectId'],
      tipo: json['tipo'],
      descripcion: json['descripcion'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'tipo': tipo,
      'descripcion': descripcion,
    };
  }
}
