import 'package:geocoding/geocoding.dart';

class Exam {
  final String courseName;
  final String locationName;
  final Location location;
  final DateTime examDateTime;

  const Exam({
    required this.courseName,
    required this.examDateTime,
    required this.location,
    required this.locationName,
  });
}
