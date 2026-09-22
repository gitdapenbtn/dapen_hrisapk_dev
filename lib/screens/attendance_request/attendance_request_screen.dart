import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/range_date_input.dart';
import 'package:dpbtn_absen/extensions/datetime_locale_id.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/models/attendance_request_model.dart';
import 'package:dpbtn_absen/providers/attendance_request_provider.dart';
import 'package:dpbtn_absen/screens/attendance_request/attendance_request_detail_screen.dart';
import 'package:dpbtn_absen/screens/attendance_request/attendance_request_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class AttendanceRequestScreen extends StatefulWidget {
  const AttendanceRequestScreen({super.key});

  @override
  State<AttendanceRequestScreen> createState() =>
      _AttendanceRequestScreenState();
}

class _AttendanceRequestScreenState extends State<AttendanceRequestScreen> {
  late AttendanceRequestProvider _attendanceRequestProvider;
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
    _attendanceRequestProvider = Provider.of<AttendanceRequestProvider>(
      context,
    );
  }

  Future _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    return Future.delayed(const Duration(milliseconds: 500), () async {
      Map<String, dynamic> params = {
        "mine": true.toString(),
        "start_date": _period.start.toLocalId("yyyy-MM-dd"),
        "end_date": _period.end.toLocalId("yyyy-MM-dd"),
      };

      _attendanceRequestProvider
          .getAttendanceRequests(params: params)
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
      onRefresh: _onRefresh,
      isLoading: _isLoading,
      appBar: LayoutAppBar(
        title: 'Pengajuan Absensi',
        bottom: LayoutAppBarBottom(
          child: RangeDateInput(
            fillColor: Colors.white60,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            style: const TextStyle(fontSize: 13),
            onChange: (period) {
              setState(() {
                _period = period;
              });
              _onRefresh();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AttendanceRequestFormScreen(),
            ),
          );
        },
        label: const Text('Buat'),
        icon: const Icon(UniconsLine.plus),
        backgroundColor: LayoutColor.primary,
        foregroundColor: LayoutColor.textPrimary,
      ),
      child: _listView(_attendanceRequestProvider.attendanceRequests),
    );
  }

  Widget _listView(List<AttendanceRequestModel> attendanceRequests) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: attendanceRequests.length,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (ctx, i) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AttendanceRequestDetailScreen(
                  attendanceRequest: attendanceRequests[i],
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attendanceRequests[i].date.toLocalId('EEEE').toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: LayoutColor.secondary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  attendanceRequests[i].date
                      .toLocalId('dd MMM yyyy')
                      .toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: LayoutColor.textPrimary,
                    fontSize: 15,
                  ),
                ),

                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Icon(UniconsLine.check_circle),
                        const SizedBox(width: 10),
                        Text(
                          attendanceRequests[i].status.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: LayoutColor.secondary,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: LayoutColor.secondary.withOpacity(.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(UniconsLine.angle_right),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
