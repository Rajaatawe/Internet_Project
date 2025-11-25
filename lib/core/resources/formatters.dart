import 'package:intl/intl.dart';

String formatWithCommas(String value) {
  final number = num.tryParse(value.replaceAll(RegExp(r'[^\d.-]'), ''));
  if (number == null) return value; // Fallback to original string if parsing fails

  final formatter = NumberFormat.decimalPattern();
  return formatter.format(number);
}
