import 'package:flutter/material.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/api/common.dart';
import 'package:physio/doctor/api.dart';
import 'package:physio/doctor/upload.dart';
import 'package:physio/nav/bar.dart';
import 'package:physio/utils.dart';

class PatientDetail extends StatefulWidget {
  final String patientId;

  PatientDetail({required this.patientId});

  @override
  PatientDetailsScreen createState() => PatientDetailsScreen();
}

class PatientDetailsScreen extends State<PatientDetail> {
  DoctorApi api = locator.get<DoctorApi>();

  Patient? patient;
  List<PatientEntry>? entries = [];
  Map<int, PatientEntry> entryMap = {};
  int completedDays = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final res = await api.getPatientInfo(widget.patientId);

    setState(() {
      patient = res.item1;
      entries = res.item2;

      completedDays = DateTime.now().difference(patient!.startDate).inDays + 1;
      if (completedDays > patient!.totalDays) {
        completedDays = patient!.totalDays;
      }

      for (final ent in entries!) {
        int diff = ent.date.difference(patient!.startDate).inDays;
        entryMap[diff] = ent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context, isDoc: true),
      body: patient == null
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient!.name ?? "missing name",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              completedDays.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(' / ${patient!.totalDays} Days',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('Age ${patient!.age}    ID: ${patient!.id}',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            print("nav");
                            navigate(
                                context,
                                UploadSection(
                                  totalDays: patient!.totalDays,
                                  patientId: patient!.id,
                                ));
                          },
                          icon: Icon(Icons.upload),
                          label: Text('Upload Videos'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: completedDays,
                    itemBuilder: (context, index) {
                      final ent = entryMap[index];
                      return HealthMetricCard(
                        date: patient!.startDate.add(Duration(days: index)),
                        heartRate: ent?.params.heart,
                        oxygenSaturation: ent?.params.oxygen,
                        breathsPerMinute: ent?.params.lung,
                        remarks: ent?.remarks,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

enum CardStatus { good, bad }

class HealthMetricCard extends StatelessWidget {
  final DateTime date;
  final int? heartRate;
  final int? oxygenSaturation;
  final int? breathsPerMinute;
  final String? remarks;

  const HealthMetricCard({
    Key? key,
    required this.date,
    this.heartRate,
    this.oxygenSaturation,
    this.breathsPerMinute,
    this.remarks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (heartRate != null &&
                oxygenSaturation != null &&
                breathsPerMinute != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMetric(Icons.favorite, '$heartRate BPM', Colors.red),
                  SizedBox(height: 4),
                  _buildMetric(
                      Icons.water_drop, '$oxygenSaturation %', Colors.blue),
                  SizedBox(height: 4),
                  _buildMetric(Icons.air, '$breathsPerMinute breaths p.m.',
                      Colors.deepOrange),
                  SizedBox(height: 4),
                  if (remarks != null) Text('Remarks: $remarks'),
                ],
              )
            else
              Text('Missing', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        SizedBox(width: 4),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
