import 'package:flutter/material.dart';
import 'package:dpbtn_absen/extensions/datetime_locale_id.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/models/approver_model.dart';
import 'package:dpbtn_absen/models/attachment_model.dart';
import 'package:dpbtn_absen/models/overtime_model.dart';
import 'package:dpbtn_absen/providers/overtime_provider.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class OvertimeDetailScreen extends StatefulWidget {
  final OvertimeModel overtime;
  const OvertimeDetailScreen({
    super.key,
    required this.overtime,
  });

  @override
  State<OvertimeDetailScreen> createState() => _OvertimeDetailScreenState();
}

class _OvertimeDetailScreenState extends State<OvertimeDetailScreen> {
  late OvertimeProvider _overtimeProvider;

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
    _overtimeProvider = Provider.of<OvertimeProvider>(context);
  }

  Future _onRefresh() {
    setState(() {
      _isLoading = true;
    });
    
    return Future.delayed(const Duration(seconds: 1), () async {
      await _overtimeProvider.findOvertimeById(id: widget.overtime.id);

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      isLoading: _isLoading,
      onRefresh: _onRefresh,
      appBar: const LayoutAppBar(
        title: 'Detail Lembur',
      ),
      padding: const EdgeInsets.all(20),
      child: _body(),
    );
  }

  Widget _body() {
    Widget body;
    if(_overtimeProvider.overtime != null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text(
            title: 'Nama Karyawan',
            value: widget.overtime.employee!.name
          ),
          _text(
            title: 'Tipe Lembur',
            value: widget.overtime.type.name
          ),
          _text(
            title: 'Mulai',
            value: widget.overtime.startDate.toLocalId('dd MMM yyyy, HH:mm').toString(),
          ),
          _text(
            title: 'Berakhir',
            value: widget.overtime.endDate.toLocalId('dd MMM yyyy, HH:mm').toString(),
          ),
          _text(
            title: 'Alasan',
            value: widget.overtime.reason,
          ),
          _text(
            title: 'Status',
            value: widget.overtime.status.name,
          ),

          _title('Lampiran'),
          _attachmentList(_overtimeProvider.overtime!.attachments),

          const SizedBox(height: 20),

          _title('Pemberi Persetujuan'),
          _approvalList(_overtimeProvider.overtime!.approvers),
        ],
      );
    } else {
      body = Container();
    }

    return body;
  }

  Widget _title(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: LayoutColor.textSecondary
      ),
    );
  }

  Widget _text({
    required String title,
    String? value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: LayoutColor.textSecondary
            ),
          ),
          Text(
            value ?? '-',
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentList(List<AttachmentModel>? attachments) {
    Widget attahcmentList = const Text('Tidak ada lampiran.');
    if(attachments != null) {
      if(attachments.isNotEmpty) {
        attahcmentList = Container(
          margin: const EdgeInsets.only(top: 10),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: attachments.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, i) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1
                    )
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        attachments[i].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    InkWell(
                      onTap: () {},
                      child: const Icon(UniconsLine.download_alt),
                    ),
                  ],
                ),
              );
            }
          )
        );
      }
    }

    return attahcmentList;
  }

  Widget _approvalList(List<ApproverModel>? approvers) {
    Widget approvalList = const Text('Tidak ada pemberi persetujuan.');
    if(approvers != null) {
      if(approvers.isNotEmpty) {
        approvalList = Container(
          margin: const EdgeInsets.only(top: 10),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: approvers.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, i) {
              Widget status;
              if(approvers[i].isApproved != null) {
                if(approvers[i].isApproved == true) {
                  status = badge(
                    'Disetujui', 
                    color: LayoutColor.success,
                  );
                } else {
                  status = badge(
                    'Ditolak', 
                    color: LayoutColor.danger,
                  );
                }
              } else {
                status = badge(
                  'Diproses', 
                  color: LayoutColor.disabled,
                  textColor: LayoutColor.textPrimary
                );
              }

              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1
                    )
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        approvers[i].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    status,
                  ],
                ),
              );
            }
          )
        );
      }
    }

    return approvalList;
  }

  Widget badge(
    String label,
    {
      Color? color,
      Color? textColor,
    }
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? LayoutColor.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 12,
        ),
      )
    );
  }
}