import 'package:dpbtn_absen/screens/approval/approval_screen.dart';
import 'package:dpbtn_absen/screens/circular_letter/circular_letter_screen.dart';
import 'package:dpbtn_absen/screens/guideline/guideline_screen.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/section.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/screens/attendance_request/attendance_request_screen.dart';
import 'package:dpbtn_absen/screens/leave/leave_screen.dart';
import 'package:dpbtn_absen/screens/permit/permit_screen.dart';
// import 'package:dpbtn_absen/screens/overtime/overtime_screen.dart';
import 'package:unicons/unicons.dart';

class FeatureSection extends StatelessWidget {
  final bool approvalAccess;
  final bool guidelineAccess;
  final bool circularLetterAccess;

  const FeatureSection(
      {super.key,
      this.approvalAccess = false,
      this.guidelineAccess = false,
      this.circularLetterAccess = false});

  @override
  Widget build(BuildContext context) {
    List<Feature> featureList = [
      Feature(
        label: 'Pengajuan',
        label2: 'Absensi',
        icon: const Icon(
          UniconsLine.calendar_alt,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AttendanceRequestScreen()));
        },
      ),
      Feature(
        label: 'Pengajuan',
        label2: 'Cuti',
        icon: const Icon(
          UniconsLine.file_alt,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LeaveScreen()));
        },
      ),
      Feature(
        label: 'Pengajuan',
        label2: 'Izin',
        icon: const Icon(
          UniconsLine.clipboard_notes,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PermitScreen()));
        },
      ),
      Feature(
        label: 'Konfirmasi',
        label2: 'Pengajuan',
        icon: const Icon(
          UniconsLine.file_check_alt,
          color: Colors.black,
        ),
        access: approvalAccess,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ApprovalScreen()));
        },
      ),
      Feature(
        label: 'Dokumen',
        label2: 'Pedoman',
        icon: const Icon(
          UniconsLine.folder_open,
          color: Colors.black,
        ),
        access: guidelineAccess,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GuidelineScreen()));
        },
      ),
      Feature(
        label: 'Dokumen',
        label2: 'Surat Edaran',
        icon: const Icon(
          Icons.folder_copy_outlined,
          color: Colors.black,
        ),
        access: circularLetterAccess,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CircularLetterScreen()));
        },
      ),
      // Feature(
      //   label: 'Pengajuan Lembur',
      //   icon: const Icon(
      //     UniconsLine.clock_five,
      //     color: Colors.black,
      //   ),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const OvertimeScreen())
      //     );
      //   },
      // ),
    ];

    final List<Feature> features =
        featureList.where((feature) => feature.access).toList();

    return Section(
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 0),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            childAspectRatio: 1 / 1,
          ),
          itemCount: features.length,
          itemBuilder: (ctx, index) {
            return InkWell(
                onTap: () {
                  if (features[index].onPressed != null) {
                    features[index].onPressed!();
                  }
                },
                child: Column(children: [
                  Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0, 2)),
                        ]),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            LayoutColor.primary.withOpacity(.6),
                            LayoutColor.primary.withOpacity(.3),
                          ],
                        ),
                      ),
                      child: features[index].icon,
                    ),
                  ),
                  Text(
                    '${features[index].label}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, letterSpacing: 1),
                  ),
                  Text(
                    '${features[index].label2}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, letterSpacing: 1),
                  ),
                ]));
          }),
    );
  }
}

class Feature {
  final String? label;
  final String? label2;
  final Widget? icon;
  final Function? onPressed;
  final bool access;

  Feature(
      {this.label, this.label2, this.icon, this.onPressed, this.access = true});
}
