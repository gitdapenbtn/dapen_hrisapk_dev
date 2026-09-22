import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/custom_input_decoration.dart';
import 'package:dpbtn_absen/extensions/datetime_locale_id.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';

class DateInput extends StatefulWidget {
  final DateTime? initialDate;
  final CustomInputDecoration? decoration;
  final ValueChanged? onChange;

  const DateInput({
    this.initialDate,
    this.decoration,
    this.onChange,
    super.key,
  });

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  final TextEditingController _controller = TextEditingController();
  late DateTime _initialDate;

  @override
  void initState() {
    super.initState();
    _setDate(widget.initialDate ?? DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: () => _selectDate(context, _initialDate),
      controller: _controller,
      readOnly: true,
      decoration: widget.decoration,
    );
  }

  _setDate(date) {
    setState(() {
      _initialDate = date;
      _controller.text = _initialDate.toLocalId("d MMM yyyy").toString();
    });
  }

  Future<void> _selectDate(BuildContext context, initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (ctx, child) {
        return Theme(
          data: ThemeData.from(
            colorScheme: const ColorScheme.light(
              primary: LayoutColor.primary,
              onPrimary: LayoutColor.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _setDate(picked);
      if (widget.onChange != null) {
        widget.onChange!(picked);
      }
    }
  }
}
