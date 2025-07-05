import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/custom_input_decoration.dart';
import 'package:dpbtn_absen/extensions/datetime_locale_id.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:unicons/unicons.dart';

class RangeDateInput extends StatefulWidget {
  final DateTimeRange? initial;
  final String? label;
  final String? hint;
  final double? height;
  final EdgeInsets? contentPadding;
  final Color? fillColor;
  final TextStyle? style;
  final ValueChanged? onChange;

  const RangeDateInput({
    super.key,
    this.initial,
    this.label,
    this.hint,
    this.height,
    this.contentPadding,
    this.fillColor,
    this.style,
    this.onChange,
  });
  
  @override
  State<RangeDateInput> createState() => _RangeDateInputState();
}

class _RangeDateInputState extends State<RangeDateInput> {
  final TextEditingController _controller = TextEditingController();
  late DateTimeRange _period;

  @override
  void initState() {
    super.initState();
    
    _setPeriod(
      widget.initial ??
      DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now(),
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _selecteRangeDate,
      child: SizedBox(
        height: widget.height,
        child: TextFormField(
          controller: _controller,
          decoration: CustomInputDecoration(
            suffixIcon: const Icon(UniconsLine.calendar_alt),
            contentPadding: widget.contentPadding,
            fillColor: widget.fillColor,
          ),
          enabled: false,
          style: widget.style,
        ),
      ),
    );
  }

  _setPeriod(DateTimeRange period) {
    var start = period.start.toLocalId('d MMM yyyy').toString();
    var end = period.end.toLocalId('dd MMM yyyy').toString();

    setState(() {
      _period = period;
      _controller.text = '$start - $end';
    });
  }
  
  _selecteRangeDate() async {
    final DateTimeRange? period = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _period,
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
      }
    );

    if (period != null) {
      _setPeriod(period);
      if (widget.onChange != null) {
        widget.onChange!(period);
      }
    }
  }
}