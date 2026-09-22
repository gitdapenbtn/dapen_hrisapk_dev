import 'package:dpbtn_absen/models/employee_model.dart';

class AttendanceModel {
  final int id;
  final DateTime date;
  final String? scheduleIn;
  final String? scheduleOut;
  final String? timeIn;
  final String? timeOut;
  final String? imageIn;
  final String? imageOut;
  final bool isCome;
  final bool isComeLate;
  final bool isComeOnTime;
  final bool isDayOff;
  final bool isOutEarly;
  final bool isOutOnTime;
  final bool isPermit;
  final bool isLeave;
  final String? noteIn;
  final String? noteOut;
  final String? latitudeIn;
  final String? longitudeIn;
  final String? latitudeOut;
  final String? longitudeOut;
  final EmployeeModel? employee;

  AttendanceModel({
    required this.id,
    required this.date,
    this.isCome = false,
    this.isComeLate = false,
    this.isComeOnTime = false,
    this.isDayOff = false,
    this.isOutEarly = false,
    this.isOutOnTime = false,
    this.isPermit = false,
    this.isLeave = false,
    this.scheduleIn,
    this.scheduleOut,
    this.timeIn,
    this.timeOut,
    this.imageIn,
    this.imageOut,
    this.noteIn,
    this.noteOut,
    this.latitudeIn,
    this.latitudeOut,
    this.longitudeIn,
    this.longitudeOut,
    this.employee,
  });

  AttendanceModel updateWith({
    int? id,
    DateTime? date,
    String? scheduleIn,
    String? scheduleOut,
    String? timeIn,
    String? timeOut,
    String? imageIn,
    String? imageOut,
    bool? isCome,
    bool? isComeLate,
    bool? isComeOnTime,
    bool? isDayOff,
    bool? isOutEarly,
    bool? isOutOnTime,
    bool? isPermit,
    bool? isLeave,
    String? noteIn,
    String? noteOut,
    String? latitudeIn,
    String? longitudeIn,
    String? latitudeOut,
    String? longitudeOut,
    EmployeeModel? employee,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      date: date ?? this.date,
      timeIn: timeIn ?? this.timeIn,
      timeOut: timeOut ?? this.timeOut,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'attendance_date': date.toString(),
      'is_come': isCome,
      'is_come_late': isComeLate,
      'is_come_on_time': isComeOnTime,
      'is_dayoff': isDayOff,
      'is_out_early': isOutEarly,
      'is_out_on_time': isOutOnTime,
      'is_permit': isPermit,
      'is_leave': isLeave,
      'schedule_in': scheduleIn,
      'schedule_out': scheduleOut,
      'time_in': timeIn,
      'time_out': timeOut,
      'image_in': imageIn,
      'image_out': imageOut,
      'note_in': noteIn,
      'note_out': noteOut,
      'latitude_in': latitudeIn,
      'latitude_out': latitudeOut,
      'longitude_in': longitudeIn,
      'longitude_out': longitudeOut,
      'employee': employee,
    };
  }

  factory AttendanceModel.fromJson(Map<String, dynamic> data) {
    return AttendanceModel(
      id: data['id'],
      date: DateTime.parse(data['attendance_date']),
      isCome: data['is_come'],
      isComeLate: data['is_come_late'],
      isComeOnTime: data['is_come_on_time'],
      isDayOff: data['is_dayoff'],
      isOutEarly: data['is_out_early'],
      isOutOnTime: data['is_out_on_time'],
      isPermit: data['is_permit'],
      isLeave: data['is_leave'],
      timeIn: data['time_in'],
      timeOut: data['time_out'],
      scheduleIn: data['schedule_in'],
      scheduleOut: data['schedule_out'],
      imageIn: data['image_in'],
      imageOut: data['image_out'],
      latitudeIn: data['latitude_in'],
      latitudeOut: data['latitude_out'],
      longitudeIn: data['longitude_in'],
      longitudeOut: data['longitude_out'],
      noteIn: data['note_in'],
      noteOut: data['note_out'],
      employee: data['employee'] != null
          ? EmployeeModel.fromJson(data['employee'])
          : null,
    );
  }
}
