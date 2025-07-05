class AttendanceSummaryModel {
  final int come;
  final int absent;
  final int permit;
  final int leave;
  final int comeOnTime;
  final int comeLate;
  final int outOnTime;
  final int outEarly;
  final int total;

  AttendanceSummaryModel({
    this.come = 0,
    this.absent = 0,
    this.permit = 0,
    this.leave = 0,
    this.comeOnTime = 0,
    this.comeLate = 0,
    this.outOnTime = 0,
    this.outEarly = 0,
    this.total = 0,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> data) {
    return AttendanceSummaryModel(
      come: data['come'],
      absent: data['absent'],
      permit: data['permit'],
      leave: data['leave'],
      comeOnTime: data['come_on_time'],
      comeLate: data['come_late'],
      outOnTime: data['out_on_time'],
      outEarly: data['out_early'],
      total: data['total'],
    );
  }
}