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
      projectId: json['fk_proyecto'],
      fechaInicio: json['fecha_inicio'],
      fechaTermino: json['fecha_termino'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'fk_proyecto': projectId,
      'fecha_inicio': fechaInicio,
      'fecha_termino': fechaTermino,
    };
  }
}
