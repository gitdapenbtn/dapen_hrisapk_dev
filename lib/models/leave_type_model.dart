class LeaveTypeModel {
  final int id;
  final String name;
  final String? code;
  final String? description;
  final bool isContinues;
  final bool isMinus;
  final int quota;
  
  LeaveTypeModel({
    required this.id,
    required this.name,
    this.code,
    this.description,
    this.isContinues = false,
    this.isMinus = false,
    this.quota = 0,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> data) {
    return LeaveTypeModel(
      id: data['id'],
      name: data['type_name'],
      code: data['type_code'],
      description: data['type_description'],
      isContinues: data['is_continues'],
      isMinus: data['is_minus'],
      quota: (data['pivot'] != null) ? data['pivot']['quota'] : 0,
    );
  }
}