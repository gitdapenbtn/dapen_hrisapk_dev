import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/providers/profile_provider.dart';
import 'package:dpbtn_absen/screens/attendance/attendance_in_screen.dart';
import 'package:dpbtn_absen/screens/attendance/attendance_out_screen.dart';
import 'package:provider/provider.dart';

class AttendanceSection extends StatefulWidget {
  const AttendanceSection({ 
    super.key 
  });

  @override
  State<AttendanceSection> createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<AttendanceSection> {
  late ProfileProvider _profileProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  @protected
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profileProvider = Provider.of<ProfileProvider>(context);
  }

  bool _canCheckIn() {
    return (
      !_hasCheckIn() &&
      !_profileProvider.attendance.isDayOff &&
      !_profileProvider.attendance.isLeave &&
      !_profileProvider.attendance.isPermit
    );
  }

  bool _canCheckOut() {
    return (
      _hasCheckIn() &&
      !_hasCheckOut() &&
      !_profileProvider.attendance.isDayOff &&
      !_profileProvider.attendance.isLeave &&
      !_profileProvider.attendance.isPermit
    );
  }

  bool _hasCheckIn() {
    return (_profileProvider.attendance.timeIn != null);
  }

  bool _hasCheckOut() {
    return (_profileProvider.attendance.timeOut != null);
  }
  
  Widget _checkInStatus() {
    String label;
    Color color;
    if(_profileProvider.attendance.scheduleIn != null) {
      if(_profileProvider.attendance.timeIn != null) {
        if(_profileProvider.attendance.isComeOnTime) {
          label = 'Tepat Waktu';
          color = LayoutColor.success;
        } else {
          label = 'Telat';
          color = LayoutColor.danger;
        }
      } else {
        label = 'Belum Absen';
        color = LayoutColor.textSecondary;
      }
    } else {
      label = '-';
      color = LayoutColor.textSecondary;
    }
    return Text(
      label, 
      style: TextStyle(
        color: color,
        fontSize: 12,
      )
    );
  }
  
  Widget _checkOutStatus() {
    String label;
    Color color;
    if(_profileProvider.attendance.scheduleIn != null) {
      if(_profileProvider.attendance.timeOut != null) {
        if(_profileProvider.attendance.isOutOnTime) {
          label = 'Tepat Waktu';
          color = LayoutColor.success;
        } else {
          label = 'Pulang Cepat';
          color = LayoutColor.danger;
        }
      } else {
        label = 'Belum Absen';
        color = LayoutColor.textSecondary;
      }
    } else {
      label = '-';
      color = LayoutColor.textSecondary;
    }
    return Text(
      label, 
      style: TextStyle(
        color: color,
        fontSize: 12,
      )
    );
  }
  
  Widget _checkInTime() {
    String label = _profileProvider.attendance.timeIn ?? '__:__';

    return Text(
      label, 
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      )
    );
  }

  Widget _checkOutTime() {
    String label = _profileProvider.attendance.timeOut ?? '__:__';

    return Text(
      label, 
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      )
    );
  }

  int _strToSecond(int hour, int minute) {
    int hourToSecond = hour * 3600;
    int minuteToSecond = minute * 60;
    return (hourToSecond + minuteToSecond);
  }

  _checkIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AttendanceInScreen())
    );
  }

  _checkOut() async {
    final now = TimeOfDay.now();
    TimeOfDay scheduleTime = TimeOfDay.now();

    if(_profileProvider.attendance.scheduleOut != null) {
      List schedule = _profileProvider.attendance.scheduleOut!.split(':');
      scheduleTime = TimeOfDay(hour: int.parse(schedule[0]), minute: int.parse(schedule[1]));
    }

    int nowSecond = _strToSecond(now.hour, now.minute);
    int scheduleSecond = _strToSecond(scheduleTime.hour, scheduleTime.minute);

    if(nowSecond < scheduleSecond) {
      _showOutEarlyDialog();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AttendanceOutScreen())
      );
    }
  }

  _showOutEarlyDialog() {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    
    Widget continueButton = TextButton(
      child: const Text("Lanjutkan"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AttendanceOutScreen())
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Pulang Cepat"),
      content: const Text("Anda yakin ingin melanjutkan ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {    
    return Row(
      children: [
        Container(
          height: 200,
          margin: const EdgeInsets.only(right: 5),
          width: MediaQuery.of(context).size.width * .45,
          child: AttendanceCard(
            title: 'Ringkasan Bulan Ini',
            children: [

              SizedBox(
                width: MediaQuery.of(context).size.width / 2.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AttendanceSummaryItem(
                      label: 'Masuk',
                      value: _profileProvider.attendanceSummary.come,
                    ),
                    AttendanceSummaryItem(
                      label: 'Cuti',
                      value: _profileProvider.attendanceSummary.leave,
                    )
                  ]
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AttendanceSummaryItem(
                      label: 'Izin',
                      value: _profileProvider.attendanceSummary.permit,
                    ),
                    AttendanceSummaryItem(
                      label: 'Alpa',
                      value: _profileProvider.attendanceSummary.absent,
                    )
                  ]
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 5),
            child: Column(
              children: [
                SizedBox(
                  height: 95,
                  width: MediaQuery.of(context).size.width,
                  child: AttendanceCard(
                    title: 'Absen Masuk',
                    onPressed: _canCheckIn()
                      ? _checkIn
                      : null,
                    children: [
                      _checkInTime(),
                      _checkInStatus(),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 95,
                  width: MediaQuery.of(context).size.width,
                  child: AttendanceCard(
                    title: 'Absen Pulang',
                    onPressed: _canCheckOut()
                      ? _checkOut
                      : null,
                    children: [
                      _checkOutTime(),
                      _checkOutStatus(),
                    ],
                  ),
                ),
              ],
            )
          ),
        ),
      ],
    );
  }
}

class AttendanceCard extends StatelessWidget{
  final String? title;
  final List<Widget>? children;
  final Function? onPressed;

  const AttendanceCard({
    super.key,
    this.title,
    this.children,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(onPressed != null) {
          onPressed!();
        }
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: title != null,
                    child: Container(
                      margin: const EdgeInsets.only(bottom:10),
                      child: Text(
                        title ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  ...children ?? [],
                ],
              ),
              Visibility(
                visible: onPressed != null,
                child: const Flexible(
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.black38,
                  ),
                ),
              ),
           ]
          ),
        ),
      ),
    );
  }
}

class AttendanceSummaryItem extends StatelessWidget{
  final String label;
  final int value;

  const AttendanceSummaryItem({
    super.key,
    this.label = '',
    this.value = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 70,
      height: 65,
      decoration: BoxDecoration(
        color: LayoutColor.primary.withOpacity(.08),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: LayoutColor.primary.withOpacity(.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$value', 
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black45,
              letterSpacing: .5,
              fontWeight: FontWeight.bold,
              fontSize: 12
            ),
          ),
        ],
      ),
    );
  }
}