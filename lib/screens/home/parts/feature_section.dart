import 'package:dpbtn_absen/screens/approval/approval_screen.dart';
import 'package:dpbtn_absen/screens/internal_policy/internal_policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/section.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/screens/attendance_request/attendance_request_screen.dart';
import 'package:dpbtn_absen/screens/leave/leave_screen.dart';
import 'package:dpbtn_absen/screens/permit/permit_screen.dart';
import 'package:unicons/unicons.dart';

class FeatureSection extends StatelessWidget {
  final bool approvalAccess;
  final bool guidelineAccess;
  final bool circularLetterAccess;
  final bool founderDecreeAccess;
  final bool decisionLetterAccess;
  final bool internalPolicyAccess;

  const FeatureSection({
    super.key,
    this.approvalAccess = false,
    this.guidelineAccess = false,
    this.circularLetterAccess = false,
    this.founderDecreeAccess = false,
    this.decisionLetterAccess = false,
    this.internalPolicyAccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<Feature> featureList = [
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
              builder: (context) => const AttendanceRequestScreen(),
            ),
          );
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LeaveScreen(),
            ),
          );
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PermitScreen(),
            ),
          );
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ApprovalScreen(),
            ),
          );
        },
      ),

      Feature(
        label: 'Kebijakan',
        label2: 'Internal',
        icon: const Icon(
          UniconsLine.folder_open,
          color: Colors.black,
        ),
        access: internalPolicyAccess,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InternalPolicyScreen(
                guidelineAccess: guidelineAccess,
                circularLetterAccess: circularLetterAccess,
                founderDecreeAccess: founderDecreeAccess,
                decisionLetterAccess: decisionLetterAccess,
              ),
            ),
          );
        },
      ),
    ];

    final List<Feature> features = featureList
        .where((feature) => feature.access)
        .toList();

    return Section(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: features.map((feature) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 80) / 3,
            child: InkWell(
              onTap: () {
                if (feature.onPressed != null) {
                  feature.onPressed!();
                }
              },
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
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
                      child: feature.icon,
                    ),
                  ),
                  Text(
                    '${feature.label}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    '${feature.label2}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Feature {
  final String? label;
  final String? label2;
  final Widget? icon;
  final Function? onPressed;
  final bool access;

  Feature({
    this.label,
    this.label2,
    this.icon,
    this.onPressed,
    this.access = true,
  });
}