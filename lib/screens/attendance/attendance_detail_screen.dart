import 'package:flutter/material.dart';
import 'package:dpbtn_absen/extensions/datetime_locale_id.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/models/attendance_model.dart';
import 'package:dpbtn_absen/providers/attendance_provider.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class AttendanceDetailScreen extends StatefulWidget {
  final AttendanceModel attendance;
  const AttendanceDetailScreen({
    super.key,
    required this.attendance,
  });

  @override
  State<AttendanceDetailScreen> createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen> {
  late AttendanceProvider _attendanceProvider;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  @protected
  @mustCallSuper 
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attendanceProvider = Provider.of<AttendanceProvider>(context);
  }

  Future _onRefresh() {
    setState(() {
      _isLoading = true;
    });
    
    return Future.delayed(const Duration(seconds: 1), () async {
      await _attendanceProvider.findAttendanceById(id: widget.attendance.id);

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      isLoading: _isLoading,
      onRefresh: _onRefresh,
      appBar: const LayoutAppBar(
        title: 'Detail Absensi',
      ),
      padding: const EdgeInsets.all(20),
      child: _body(),
    );
  }

  Widget _body() {
    Widget body;
    if(_attendanceProvider.attendance != null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text(
            title: 'Nik Karyawan',
            value: widget.attendance.employee!.registrationNumber
          ),
          _text(
            title: 'Nama Karyawan',
            value: widget.attendance.employee!.name
          ),
          _text(
            title: 'Tanggal Absensi',
            value: widget.attendance.date.toLocalId('dd MMM yyyy').toString(),
          ),

          ExpansionTile(
            initiallyExpanded: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: _title('Absen Masuk'),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            iconColor: Colors.black12,
            textColor: Colors.black,
            expandedAlignment: Alignment.centerLeft,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      constraints: const BoxConstraints(
                        minHeight: 100,                          
                      ),
                      color: Colors.grey,
                      child: widget.attendance.imageIn != null 
                        ? Image.network(widget.attendance.imageIn!)
                        : const Icon(UniconsLine.image, color: Colors.white,),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _text(
                        title: 'Jam Masuk',
                        value: widget.attendance.timeIn,
                      ),
                      _text(
                        title: 'Catatan',
                        value: widget.attendance.noteIn,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),

          const SizedBox(height: 20,),

          ExpansionTile(
            initiallyExpanded: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: _title('Absen Pulang'),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            iconColor: Colors.black12,
            textColor: Colors.black,
            expandedAlignment: Alignment.centerLeft,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      constraints: const BoxConstraints(
                        minHeight: 100,                          
                      ),
                      color: Colors.grey,
                      child: widget.attendance.imageOut != null 
                        ? Image.network(widget.attendance.imageOut!)
                        : const Icon(UniconsLine.image, color: Colors.white,),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _text(
                        title: 'Jam Pulang',
                        value: widget.attendance.timeOut,
                      ),
                      _text(
                        title: 'Catatan',
                        value: widget.attendance.noteOut,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),

        ],
      );
    } else {
      body = Container();
    }

    return body;
  }

  Widget _title(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: LayoutColor.textSecondary
      ),
    );
  }

  Widget _text({
    required String title,
    String? value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: LayoutColor.textSecondary
            ),
          ),
          Text(
            value ?? '-',
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  Widget badge(
    String label,
    {
      Color? color,
      Color? textColor,
    }
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? LayoutColor.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 12,
        ),
      )
    );
  }
}