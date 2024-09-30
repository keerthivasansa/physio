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
  int lastCompletedDay = 0;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context),
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
                              lastCompletedDay.toString(),
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
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return HealthMetricCard(
                        date: DateTime.now().subtract(Duration(days: index)),
                        heartRate: index == 2 ? null : (74 - index * 2),
                        oxygenSaturation: index == 2 ? null : (94 - index * 9),
                        breathsPerMinute: index == 2 ? null : (14 - index),
                        status:
                            index % 2 == 0 ? CardStatus.good : CardStatus.bad,
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
  final CardStatus status;

  const HealthMetricCard({
    Key? key,
    required this.date,
    this.heartRate,
    this.oxygenSaturation,
    this.breathsPerMinute,
    required this.status,
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
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        status == CardStatus.good ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (heartRate != null &&
                oxygenSaturation != null &&
                breathsPerMinute != null)
              Column(
                children: [
                  _buildMetric(Icons.favorite, '$heartRate BPM', Colors.red),
                  SizedBox(height: 4),
                  _buildMetric(
                      Icons.water_drop, '$oxygenSaturation %', Colors.blue),
                  SizedBox(height: 4),
                  _buildMetric(
                      Icons.air, '$breathsPerMinute breaths p.m.', Colors.grey),
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
