class Member {
  final int id;
  final int projectId;
  final String? nombre;
  final String? cargo;

  Member(
      {required this.id,
      required this.projectId,
      this.nombre,
      this.cargo,
      });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      projectId: json['projectId'],
      nombre: json['nombre'],
      cargo: json['cargo'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'nombre': nombre,
      'cargo': cargo,
    };
  }
}
