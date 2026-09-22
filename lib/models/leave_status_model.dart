class LeaveStatusModel {
  final int id;
  final String name;
  final String? description;

  LeaveStatusModel({required this.id, required this.name, this.description});

  factory LeaveStatusModel.fromJson(Map<String, dynamic> data) {
    return LeaveStatusModel(
      id: data['id'],
      name: data['status_name'],
      description: data['status_description'],
    );
  }
}
