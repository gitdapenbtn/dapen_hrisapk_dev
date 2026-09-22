import 'package:dpbtn_absen/screens/guideline/guideline_screen.dart';
import 'package:dpbtn_absen/screens/circular_letter/circular_letter_screen.dart';
import 'package:dpbtn_absen/screens/founder_decree/founder_decree_screen.dart';
import 'package:dpbtn_absen/screens/decision_letter/decision_letter_screen.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:unicons/unicons.dart';

class InternalPolicyScreen extends StatelessWidget {
  final bool guidelineAccess;
  final bool circularLetterAccess;
  final bool founderDecreeAccess;
  final bool decisionLetterAccess;

  const InternalPolicyScreen({
    super.key,
    this.guidelineAccess = false,
    this.circularLetterAccess = false,
    this.founderDecreeAccess = false,
    this.decisionLetterAccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: const LayoutAppBar(
        title: 'Kebijakan Internal',
      ),
      child: Column(
        children: [
          // 1. Ketetapan Pendiri
          _documentMenu(
            context,
            title: 'Ketetapan Pendiri',
            icon: UniconsLine.folder_open,
            access: founderDecreeAccess,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FounderDecreeScreen(),
                ),
              );
            },
          ),

          // 2. Pedoman
          _documentMenu(
            context,
            title: 'Pedoman',
            icon: UniconsLine.folder_open,
            access: guidelineAccess,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GuidelineScreen(),
                ),
              );
            },
          ),

          // 3. Surat Edaran
          _documentMenu(
            context,
            title: 'Surat Edaran',
            icon: UniconsLine.folder_open,
            access: circularLetterAccess,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CircularLetterScreen(),
                ),
              );
            },
          ),

          // 4. Surat Keputusan
          _documentMenu(
            context,
            title: 'Surat Keputusan',
            icon: UniconsLine.folder_open,
            access: decisionLetterAccess,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DecisionLetterScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _documentMenu(
      BuildContext context, {
        required String title,
        required IconData icon,
        required bool access,
        required VoidCallback onTap,
      }) {
    if (!access) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
        left: 10,
        right: 10,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
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
          child: Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.yellow.withOpacity(.6),
                        Colors.yellow.withOpacity(.3),
                      ],
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}