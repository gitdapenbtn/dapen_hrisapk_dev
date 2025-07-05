import 'package:flutter/material.dart';
import 'package:dpbtn_absen/helpers/snackbar.dart';

class WillPopScopeExit extends StatefulWidget {
  final Widget child;
  const WillPopScopeExit({
    super.key,
    required this.child,
  });

  @override
  State<WillPopScopeExit> createState() => _WillPopScopeExitState();
}

class _WillPopScopeExitState extends State<WillPopScopeExit> {
  bool _shouldPop = false;

  Future<bool> _onWillPop() async {
    if(_shouldPop) {
      return true;
    } else {
      setState(() {
        _shouldPop = true;
      });
      showSnackBarAnywhere(
        'Tekan sekali lagi untuk keluar',
        onClosed: () {
          setState(() {
            _shouldPop = false;
          });
        }
      );
      return false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: widget.child
    );
  }
}