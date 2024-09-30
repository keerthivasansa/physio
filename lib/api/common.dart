class Patient {
  final String? name;
  final String id, doctorId;
  final int age, totalDays;
  final DateTime startDate;

  Patient({
    required this.age,
    this.name,
    required this.id,
    required this.totalDays,
    required this.doctorId,
    required this.startDate,
  });

  // fromJson constructor
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      age: json['age'] as int,
      name: json['name'] as String?, // Nullable field
      id: json['id'] as String,
      totalDays: json['totalDays'] as int,
      doctorId: json['doctorId'] as String,
      startDate: DateTime.parse(json['startDate'] as String), // Date parsing
    );
  }
}

class Parameters {
  final int heart, lung, oxygen;
  Parameters({required this.heart, required this.lung, required this.oxygen});

  factory Parameters.fromJson(Map<String, dynamic> json) {
    return Parameters(
        heart: json['heart'], lung: json['lung'], oxygen: json['oxygen']);
  }
}

class PatientEntry {
  final DateTime date;
  final Parameters params;
  final String patientId, remarks;

  PatientEntry({
    required this.params,
    required this.date,
    required this.patientId,
    required this.remarks,
  });

  factory PatientEntry.fromJson(Map<String, dynamic> json) {
    return PatientEntry(
      date: DateTime.parse(json['date'] as String), // Date parsing
      patientId: json['patientId'],
      remarks: json['remarks'],
      params: Parameters.fromJson(json['parameters']),
    );
  }
}

class Exercise {
  int day, exerciseNo;
  String patientId, doctorId, videoName;

  Exercise({
    required this.day,
    required this.exerciseNo,
    required this.patientId,
    required this.doctorId,
    required this.videoName,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
        day: json['day'],
        exerciseNo: json['exerciseNo'],
        patientId: json['patientId'],
        doctorId: json['doctorId'],
        videoName: json['videoName']);
  }
}
