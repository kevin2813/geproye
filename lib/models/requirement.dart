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
      projectId: json['fk_proyecto'],
      tipo: json['tipo'],
      descripcion: json['descripcion'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'fk_proyecto': projectId,
      'tipo': tipo,
      'descripcion': descripcion,
    };
  }
}
