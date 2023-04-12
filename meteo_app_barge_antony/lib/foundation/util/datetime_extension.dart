extension DateTimeExtension on DateTime {
  DateTime copy() {
    return DateTime(year, month, day, hour, minute, second, millisecond);
  }
}