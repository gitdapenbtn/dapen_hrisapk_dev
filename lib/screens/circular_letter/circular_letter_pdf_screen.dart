import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CircularLetterPdfScreen extends StatefulWidget {
  final String title;
  final String url;

  const CircularLetterPdfScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<CircularLetterPdfScreen> createState() =>
      _CircularLetterPdfScreenState();
}

class _CircularLetterPdfScreenState extends State<CircularLetterPdfScreen> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LayoutColor.primary,
        foregroundColor: LayoutColor.textPrimary,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_up,
            ),
            onPressed: () {
              _pdfViewerController.previousPage();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down,
            ),
            onPressed: () {
              _pdfViewerController.nextPage();
            },
          )
        ],
      ),
      body: SafeArea(
        child: SfPdfViewer.network(
          widget.url,
          canShowScrollStatus: true,
          canShowScrollHead: true,
          controller: _pdfViewerController,
        ),
      ),
    );
  }
}
