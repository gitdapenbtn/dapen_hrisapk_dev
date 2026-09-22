class FounderDecreeModel {
  final int id;
  final String title;
  final String letterNumber;
  final DateTime lastReviewAt;
  final String file;
  final int organizationId;

  FounderDecreeModel({
    required this.id,
    required this.title,
    required this.letterNumber,
    required this.lastReviewAt,
    required this.file,
    required this.organizationId,
  });

  factory FounderDecreeModel.fromJson(Map<String, dynamic> data) {
    return FounderDecreeModel(
      id: data['id'],
      title: data['title'],
      letterNumber: data['letter_number'],
      lastReviewAt: DateTime.parse(data['last_review_at']),
      file: data['file'],
      organizationId: data['employee_organization_id'],
    );
  }
}
