import 'package:dpbtn_absen/models/decision_letter_model.dart';
import 'package:dpbtn_absen/providers/decision_letter_provider.dart';
import 'package:dpbtn_absen/screens/decision_letter/decision_letter_pdf_screen.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DecisionLetterListScreen extends StatefulWidget {
  final int organizationId;
  final String organizationName;

  const DecisionLetterListScreen({
    super.key,
    required this.organizationId,
    required this.organizationName,
  });

  @override
  State<DecisionLetterListScreen> createState() =>
      _DecisionLetterListScreenState();
}

class _DecisionLetterListScreenState extends State<DecisionLetterListScreen> {
  late DecisionLetterProvider _decisionLetterProvider;
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

    _decisionLetterProvider = Provider.of<DecisionLetterProvider>(context);
  }

  Future _onRefresh() {
    setState(() {
      _isLoading = true;
    });

    return Future.delayed(const Duration(seconds: 1), () async {
      Map<String, dynamic> params = {
        "employee_organization_id": widget.organizationId.toString(),
      };

      _decisionLetterProvider.getDecisionLetters(params: params).whenComplete(
        () {
          setState(() {
            _isLoading = false;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      onRefresh: _onRefresh,
      isLoading: _isLoading,
      appBar: const LayoutAppBar(title: 'Surat Keputusan'),
      child: Column(
        children: [_listView(_decisionLetterProvider.decisionLetters)],
      ),
    );
  }

  Widget _listView(List<DecisionLetterModel> decisionLetters) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: decisionLetters.length,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (ctx, i) {
        String lastReviewAt = DateFormat(
          'dd MMMM yyyy',
        ).format(decisionLetters[i].lastReviewAt).toString();

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DecisionLetterPdfScreen(
                  title: decisionLetters[i].title,
                  url: decisionLetters[i].file,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            decisionLetters[i].letterNumber,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            decisionLetters[i].title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                const Divider(),
                Text(
                  'Terakhir Di Review : $lastReviewAt',
                  style: const TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
