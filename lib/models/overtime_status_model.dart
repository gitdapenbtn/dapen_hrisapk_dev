class OvertimeStatusModel {
  final int id;
  final String name;
  final String? description;

  OvertimeStatusModel({required this.id, required this.name, this.description});

  factory OvertimeStatusModel.fromJson(Map<String, dynamic> data) {
    return OvertimeStatusModel(
      id: data['id'],
      name: data['status_name'],
      description: data['status_description'],
    );
  }
}
