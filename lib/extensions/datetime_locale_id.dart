import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

extension DatetimeLocaleId on DateTime {
  String? toLocalId(String format) {
    initializeDateFormatting('id_ID');
    try {
      return DateFormat(format, 'id_ID').format(this);
    } catch (e) {
      return null;
    }
  }
}
