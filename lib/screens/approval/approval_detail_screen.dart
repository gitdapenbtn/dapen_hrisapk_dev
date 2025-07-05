import 'package:dpbtn_absen/components/danger_button.dart';
import 'package:dpbtn_absen/components/primary_button.dart';
import 'package:dpbtn_absen/helpers/snackbar.dart';
import 'package:dpbtn_absen/models/approver_model.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/models/attachment_model.dart';
import 'package:dpbtn_absen/models/approval_model.dart';
import 'package:dpbtn_absen/providers/approval_provider.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class ApprovalDetailScreen extends StatefulWidget {
  final ApprovalModel approval;
  const ApprovalDetailScreen({
    super.key,
    required this.approval,
  });

  @override
  State<ApprovalDetailScreen> createState() => _ApprovalDetailScreenState();
}

class _ApprovalDetailScreenState extends State<ApprovalDetailScreen> {
  late ApprovalProvider _approvalProvider;

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
      await _approvalProvider.findApprovalById(widget.approval);
      
      setState(() {
        _isLoading = false;
      });
    });
  }

  _rejectHandler() async {
    setState(() {
      _isLoading = true;
    });

    _approvalProvider.reject(widget.approval)
      .then((resp) {
        Navigator.pop(context);
        showSnackBarAnywhere('${resp.message}');
      })
      .catchError((err) {
        setState(() {
          _isLoading = false;
        });
        showSnackBarAnywhere(err.toString());
      });
  }

  _approveHandler() async {
    setState(() {
      _isLoading = true;
    });

    _approvalProvider.approve(widget.approval)
      .then((resp) {
        Navigator.pop(context);
        showSnackBarAnywhere('${resp.message}');
      })
      .catchError((err) {
        setState(() {
          _isLoading = false;
        });
        showSnackBarAnywhere(err.toString());
      });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      isLoading: _isLoading,
      onRefresh: _onRefresh,
      appBar: const LayoutAppBar(
        title: 'Detail Permohonan',
      ),
      padding: const EdgeInsets.all(20),
      bottomSheet: widget.approval.isApproved == null 
        ? Container(
            color: LayoutColor.background,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Flexible(
                  child: DangerButton(
                    onPressed: _rejectHandler,
                    child: const Text('Tolak'),
                  ),
                ),
                const SizedBox(width: 20),
                Flexible(
                  child: PrimaryButton(
                    onPressed: _approveHandler,
                    child: const Text('Setujui'),
                  ),
                ),
              ]
            ),
          )
        : null,
      child: _body(),
    );
  }

  Widget _body() {
    Widget body;

    late String type;
    if(_approvalProvider.approval != null) {
      switch (widget.approval.type) {
        case 'attendance':
          type = 'Pengajuan Absen';
          break;
        case 'leave':
          type = 'Cuti';
          break;
        case 'permit':
          type = 'Izin';
          break;
        default:
          type = '';
      }

      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text(
            title: 'Nama Karyawan',
            value: widget.approval.employee!.name
          ),
          _text(
            title: 'Tipe Permohonan',
            value: type,
          ),
          _text(
            title: 'Tanggal',
            value: widget.approval.date,
          ),
          _text(
            title: 'Alasan',
            value: widget.approval.reason,
          ),
          _text(
            title: 'Status',
            value: widget.approval.status,
          ),

          _title('Lampiran'),
          _attachmentList(_approvalProvider.approval!.attachments),

          const SizedBox(height: 20),

          _title('Pemberi Persetujuan'),
          _approvalList(_approvalProvider.approval!.approvers),
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