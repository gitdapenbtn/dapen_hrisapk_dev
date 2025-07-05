import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/range_date_input.dart';
import 'package:dpbtn_absen/extensions/datetime_locale_id.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/models/attendance_model.dart';
import 'package:dpbtn_absen/providers/attendance_provider.dart';
import 'package:dpbtn_absen/screens/attendance/attendance_detail_screen.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({ super.key });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {  
  late AttendanceProvider _attendanceProvider;
  DateTimeRange _period = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );
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
      Map<String, dynamic> params = {
        "mine": true.toString(),
        "start_date": _period.start.toLocalId("yyyy-MM-dd"),
        "end_date": _period.end.toLocalId("yyyy-MM-dd"),
      };

      _attendanceProvider.getAttendances(params: params)
        .whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      hasNavigationBottom: true,
      isLoading: _isLoading,
      onRefresh: _onRefresh,
      appBar: LayoutAppBar(
        title: 'Absensi',
        bottom: LayoutAppBarBottom(
          child: RangeDateInput(
            fillColor: Colors.white60,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            style: const TextStyle(
              fontSize: 13,
            ),
            onChange: (period) {
              setState(() {
                _period = period;
              });
              _onRefresh();
            },
          ),
        ),
      ),
      child: _listView(_attendanceProvider.attendances),
    );
  }
  
  Widget _listView(List<AttendanceModel> attendances) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: attendances.length,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    itemBuilder: (ctx, i) {
      String day = attendances[i].date.toLocalId('EEEE').toString();
      String date = attendances[i].date.toLocalId('dd').toString();
      String month = attendances[i].date.toLocalId('MMM').toString();
      String nullTime = '__:__';
      String scheduleIn = attendances[i].scheduleIn ?? nullTime;
      String scheduleOut = attendances[i].scheduleOut ?? nullTime;
      String timeIn = attendances[i].timeIn ?? nullTime;
      String timeOut = attendances[i].timeOut ?? nullTime;

      return InkWell(
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (ctx) => AttendanceDetailScreen(
              attendance: attendances[i],
            ))
          );
        },
        child: Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          shadowColor: Colors.black38,
          elevation: 3,
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: const Size.fromHeight(90).height,
                width: const Size.fromWidth(100).width,
                decoration: BoxDecoration(
                  color: LayoutColor.primary.withOpacity(.4),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(day),
                    Text(
                      date, 
                      style: const TextStyle( 
                        fontSize: 18, 
                        fontWeight: FontWeight.bold 
                      ),
                    ),
                    Text(month),
                  ],
                ),
              ),

              Flexible(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const { 
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(6)
                    },
                    children: [
                      TableRow(
                        children: [
                          const TableCell(
                            child: SizedBox(
                              height: 30,
                              child: Text('Jadwal'),
                            )
                          ),
                          const TableCell(
                            child: SizedBox(
                              height: 30,
                              child: Text(':'),
                            )
                          ),
                          TableCell(
                            child: SizedBox(
                              height: 30,
                              child: Text('$scheduleIn - $scheduleOut'),
                            )
                          ),
                        ]
                      ),
                      TableRow(
                        children: [
                          const TableCell(child: Text('Aktual')),
                          const TableCell(child: Text(':')),
                          TableCell(child: Text('$timeIn - $timeOut')),
                        ]
                      ),
                    ],
                  )
                ),
              ),
            ],
          ),
        )
      );
    },
  );
 }
}