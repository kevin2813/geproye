class Iteration {
  final int id;
  final int projectId;
  final String? fechaInicio;
  final String? fechaTermino;

  Iteration(
      {required this.id,
      required this.projectId,
      this.fechaInicio,
      this.fechaTermino,
      });

  factory Iteration.fromJson(Map<String, dynamic> json) {
    return Iteration(
      id: json['id'],
      projectId: json['projectId'],
      fechaInicio: json['fechaInicio'],
      fechaTermino: json['fechaTermino'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'fechaInicio': fechaInicio,
      'fechaTermino': fechaTermino,
    };
  }
}
