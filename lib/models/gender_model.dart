class GenderModel {
  final int id;
  final String name;
  
  GenderModel({
    required this.id,
    required this.name,
  });

  factory GenderModel.fromJson(Map<String, dynamic> data) {
    return GenderModel(
      id: data['id'],
      name: data['gender_name'],
    );
  }
}