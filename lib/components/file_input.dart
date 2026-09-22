import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:path/path.dart';
import 'package:unicons/unicons.dart';

class FileInput extends StatefulWidget {
  final ValueChanged? onChanged;

  const FileInput({this.onChanged, super.key});

  @override
  State<FileInput> createState() => _FileInputState();
}

class _FileInputState extends State<FileInput> {
  final List<File> _files = [];

  _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _files.addAll(result.paths.map((path) => File(path!)).toList());
      });

      if (widget.onChanged != null) {
        widget.onChanged!(_files);
      }
    }
  }

  _removeFile(index) async {
    setState(() {
      _files.removeAt(index);
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lampiran'),
          const Divider(),

          InkWell(
            onTap: _selectFile,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: LayoutColor.primary.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const Column(
                      children: [
                        Icon(UniconsLine.paperclip),
                        Text('Lampirkan'),
                      ],
                    ),
                  ),

                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contoh file jpg, png, pdf, word, xls.',
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        'Maksimal ukuran file 4MB.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          ListView.builder(
            shrinkWrap: true,
            itemCount: _files.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              String filename = basename(_files[index].path);

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(child: Text(filename)),
                        SizedBox(
                          height: 35,
                          width: 35,
                          child: TextButton(
                            onPressed: () => _removeFile(index),
                            style: TextButton.styleFrom(
                              backgroundColor: LayoutColor.danger,
                              foregroundColor: LayoutColor.background,
                            ),
                            child: const Icon(UniconsLine.times, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
