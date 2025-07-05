import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/custom_input_decoration.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';

class TimeInput extends StatefulWidget {
  final TimeOfDay? initialTime;
  final CustomInputDecoration? decoration; 
  final ValueChanged? onChange;

  const TimeInput({
    this.initialTime,
    this.decoration,
    this.onChange,
    super.key,
  });
  
  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  final TextEditingController _controller = TextEditingController();
  late TimeOfDay _initialTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  @protected
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initialTime = widget.initialTime ?? TimeOfDay.now();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: () => _selectTime(context, _initialTime),
      controller: _controller,
      readOnly: true,
      decoration: widget.decoration,
    );
  }

  _setTime(TimeOfDay time) {
    final List<String> timeSplit = time.format(context).split(':');
    final hour = timeSplit[0];
    final minute = timeSplit[1];
    setState(() {
      _initialTime = time;
      _controller.text = '$hour:$minute';
    });
  }

  Future<void> _selectTime(BuildContext context, initialTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context, 
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (ctx, child) {
        return Theme(
          data: ThemeData.from(
            colorScheme: const ColorScheme.light(
              primary: LayoutColor.primary,
              onPrimary: LayoutColor.textPrimary,
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        );
      }
    );

    if(picked != null) {
      _setTime(picked);
      if(widget.onChange != null) {
        widget.onChange!(picked);
      }
    }
  }
}