import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String humanReadableDate(DateTime date) {
  initializeDateFormatting('en', null).then((_) async {});
  return DateFormat('MM/dd/yyyy  kk:mm').format(date).toString();
}
