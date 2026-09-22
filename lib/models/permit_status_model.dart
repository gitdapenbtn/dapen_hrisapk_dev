class PermitStatusModel {
  final int id;
  final String name;
  final String? description;

  PermitStatusModel({required this.id, required this.name, this.description});

  factory PermitStatusModel.fromJson(Map<String, dynamic> data) {
    return PermitStatusModel(
      id: data['id'],
      name: data['status_name'],
      description: data['status_description'],
    );
  }
}
