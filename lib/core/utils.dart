import 'dart:math';

String generateId() {
  const int min = 1000000;
  const int max = 9999999;
  String random7Digits() => (min + Random().nextInt(max - min)).toString();

  final DateTime now = DateTime.now();
  final String year = (now.year % 100).toString();
  final String month = (now.month).toString().padLeft(2, '0');
  final String day = (now.day).toString().padLeft(2, '0');
  final String hour = (now.hour).toString().padLeft(2, '0');
  final String minute = (now.minute).toString().padLeft(2, '0');
  final String second = (now.second).toString().padLeft(2, '0');
  final String randomSequence = random7Digits().toString();
  return '$year$month$day$hour$minute$second$randomSequence';
}
