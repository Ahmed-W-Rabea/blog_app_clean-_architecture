import 'package:intl/intl.dart';

String formatDAteBydMMMYYYY(DateTime dateTime) {
  return DateFormat("d MMM, yyyy").format(dateTime);
}
