import 'package:flutter/material.dart';
import 'package:dpbtn_absen/extensions/string_casing.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/models/leave_type_model.dart';
import 'package:dpbtn_absen/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class LeaveQuotaScreen extends StatefulWidget {
  const LeaveQuotaScreen({ super.key });

  @override
  State<LeaveQuotaScreen> createState() => _LeaveQuotaScreenState();
}

class _LeaveQuotaScreenState extends State<LeaveQuotaScreen> {
  late ProfileProvider _profileProvider;
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
    _profileProvider = Provider.of<ProfileProvider>(context);
  }

  Future _onRefresh() {
    setState(() {
      _isLoading = true;
    });
    
    return Future.delayed(const Duration(seconds: 1), () async {
      _profileProvider.getLeaveQuotas()
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
      appBar: const LayoutAppBar(
        title: 'Saldo Cuti',
      ),
      child: _listView(_profileProvider.leaveQuotas),
    );
  }

  Widget _listView(List<LeaveTypeModel> leaveQuotas) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: leaveQuotas.length,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (ctx, i) {
        return InkWell(
          onTap: () {
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
                  offset: const Offset(0,2),
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leaveQuotas[i].name.toTitleCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: LayoutColor.secondary
                  ),
                ),

                Text(
                  leaveQuotas[i].description ?? '-',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: LayoutColor.textSecondary,
                    fontSize: 12,
                  )
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text(
                        'Sisa Saldo : ${leaveQuotas[i].quota}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: LayoutColor.secondary
                        ),
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
              ],
            ),
          )
        );
      },
    );
 }
}