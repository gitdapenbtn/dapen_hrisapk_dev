import 'package:dpbtn_absen/screens/approval/approval_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/range_date_input.dart';
import 'package:dpbtn_absen/extensions/datetime_locale_id.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/models/approval_model.dart';
import 'package:dpbtn_absen/providers/approval_provider.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({ super.key });

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  late ApprovalProvider _approvalProvider;
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
    _approvalProvider = Provider.of<ApprovalProvider>(context);
  }

  Future _onRefresh() {
    setState(() {
      _isLoading = true;
    });
    
    return Future.delayed(const Duration(seconds: 1), () async {
      Map<String, dynamic> params = {
        "start_date": _period.start.toLocalId("yyyy-MM-dd"),
        "end_date": _period.end.toLocalId("yyyy-MM-dd"),
      };
      
      _approvalProvider.getApprovals(params: params)
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
        title: 'Approval',
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
      child: _listView(_approvalProvider.approvals),
    );
  }

  Widget _listView(List<ApprovalModel> approvals) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: approvals.length,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (ctx, i) {
        late Color color;
        late String title;
        late String status;
        late Color statusColor;
        late IconData statusIcon;

        switch (approvals[i].type) {
          case 'attendance':
            title = 'Pengajuan Absen';
            color = TypeColor.attendance;
            break;
          case 'leave':
            title = 'Cuti';
            color = TypeColor.leave;
            break;
          case 'permit':
            title = 'Izin';
            color = TypeColor.permit;
            break;
          default:
            title = '';
        }

        switch (approvals[i].isApproved) {
          case 1:
            status = 'Telah Disetujui';
            statusColor = LayoutColor.success;
            statusIcon = UniconsLine.check_circle;
            break;
          case 0:
            status = 'Tidak Disetujui';
            statusColor = LayoutColor.danger;
            statusIcon = UniconsLine.times_circle;
            break;
          default:
            status = 'Menunggu Persetujuan';
            statusColor = LayoutColor.secondary;
            statusIcon = UniconsLine.info_circle;
        }

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApprovalDetailScreen(approval: approvals[i])
              )
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 5,
                  offset: const Offset(0,2),
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: const EdgeInsets.only(bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Text('$title ( ${approvals[i].employee!.name} )', style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    approvals[i].typeDetail ?? title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: LayoutColor.textSecondary,
                      fontSize: 12,
                    )
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    approvals[i].date,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: LayoutColor.textPrimary,
                      fontSize: 15
                    )
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            statusIcon,
                            color: statusColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            status,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: statusColor,
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
                  )
                ),
              ],
            ),
          )
        );
      },
    );
 }
}

class TypeColor {
  static const Color leave = Color.fromARGB(255, 255, 191, 191);
  static const Color attendance = Color.fromARGB(255, 243, 253, 232);
  static const Color permit = Color.fromARGB(255, 245, 243, 159);
}