class ApproverModel {
  final int id;
  final String name;
  final String email;
  final bool isRequired;
  final bool? isApproved;

  ApproverModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isRequired,
    this.isApproved,
  });

  factory ApproverModel.fromJson(Map<String, dynamic> data) {
    return ApproverModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      isRequired: data['pivot']['is_required'],
      isApproved: data['pivot']['is_approved'],
    );
  }
}
