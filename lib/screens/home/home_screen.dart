import 'dart:async';

import 'package:dpbtn_absen/components/upgrader.dart';
import 'package:dpbtn_absen/providers/article_provider.dart';
import 'package:dpbtn_absen/screens/home/parts/article_section.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/providers/attendance_provider.dart';
import 'package:dpbtn_absen/providers/profile_provider.dart';
import 'package:dpbtn_absen/screens/home/parts/attendance_section.dart';
import 'package:dpbtn_absen/screens/home/parts/feature_section.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProfileProvider _profileProvider;
  late AttendanceProvider _attendanceProvider;
  late ArticleProvider _articleProvider;

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
    _attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);
    _articleProvider = Provider.of<ArticleProvider>(context, listen: false);
  }

  Future _onRefresh() {
    return Future.delayed(const Duration(seconds: 1), () async {
      await _profileProvider.getLocalProfile();
      await _getData();
    });
  }

  _getData() async {
    await _attendanceProvider.sync();
    await _profileProvider.getAttendanceToday();
    await _getAttendanceSummary();
    await _getArticles();
  }

  _getAttendanceSummary() async {
    var now = DateTime.now();
    var beginningNextMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1);
    var firstDayOfMonth = DateTime(now.year, now.month, 1);
    var lastDayOfMonth = beginningNextMonth.subtract(const Duration(days: 1));

    await _profileProvider.getAttendanceSummary(params: {
      'mine': true.toString(),
      'start_date': DateFormat('yyyy-MM-dd').format(firstDayOfMonth),
      'end_date': DateFormat('yyyy-MM-dd').format(lastDayOfMonth),
    });
  }

  _getArticles() async {
    await _articleProvider.getArticles(params: {
      'limit': '3',
    });
  }

  @override
  Widget build(BuildContext context) {
    return UpgraderWidget(
      child: Layout(
        onRefresh: _onRefresh,
        hasNavigationBottom: true,
        padding: EdgeInsets.zero,
        safeAreaTop: false,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.only(
              right: 20,
              left: 20,
              bottom: 20,
              top: MediaQuery.of(context).padding.top + 20,
            ),
            decoration: const BoxDecoration(
              color: LayoutColor.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hello',
                                style: TextStyle(
                                  color: LayoutColor.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                _profileProvider.profile?.name ?? '',
                                style: const TextStyle(
                                    color: LayoutColor.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    height: 1.2),
                              ),
                            ]),
                        InkWell(
                            onTap: () {
                              // showSnackBarAnywhere('Fitur ')
                            },
                            child: const Icon(
                              Icons.notifications_on_outlined,
                              size: 25,
                            )),
                      ]),
                ),
                const AttendanceSection()
              ],
            ),
          ),
          FeatureSection(
            approvalAccess: _profileProvider.profile?.approvalAccess ?? false,
            guidelineAccess: _profileProvider.profile?.guidelineAccess ?? false,
            circularLetterAccess: _profileProvider.profile?.circularLetterAccess ?? false,
          ),
          const ArticleSection(),
        ],
      ),
    );
  }
}
