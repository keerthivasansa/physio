import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/api/client.dart';
import 'package:physio/doctor/addPatient.dart';
import 'package:physio/doctor/patient_list.dart';
import 'package:physio/nav/bar.dart';
import 'package:physio/utils.dart';

class DoctorDashboard extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DoctorDashboard> {
  int touchedIndex = -1;
  String name = "";
  Map<int, int> dayCounts = {};
  int patientCount = 0;
  List<Color> colors = [];
  ApiClient api = locator.get();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final resp = await api.get("/doctor/dashboard", {});
    final data = resp.data;

    Map<String, dynamic> json = data['dayCount'];
    Map<int, int> count = {};
    final random = Random();
    for (String key in json.keys) {
      count[int.parse(key)] = json[key];
      final color = Color.fromARGB(
        255, // Full opacity
        random.nextInt(200), // Red (0-255)
        random.nextInt(200), // Green (0-255)
        random.nextInt(200), // Blue (0-255)
      );
      colors.add(color);
    }

    setState(() {
      name = data['info'][0]['name'];
      patientCount = data['patientCount'];
      dayCounts = count;
    });
    ;
  }

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> pieSections = [];

    int totalCount = 0;

    for (int value in dayCounts.values) {
      totalCount += value;
    }

    int idx = 0;
    for (int day in dayCounts.keys) {
      double percent = ((dayCounts[day]! + 0) / totalCount) * 100;
      String percMsg = percent.toStringAsFixed(1);
      final section = PieChartSectionData(
        color: colors[idx],
        value: percent,
        title: touchedIndex != -1 ? 'Day $day\n$percMsg%' : '',
        radius: touchedIndex != -1 ? 60 : 50,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
      pieSections.add(section);
      idx += 1;
    }

    return Scaffold(
        appBar: createAppBar(context, showProfile: true, isDoc: true),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              Text(
                'Hi, $name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 300,
                height: 300,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: pieSections,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 10),
                    Text('Patients'),
                    SizedBox(width: 10),
                    Text(patientCount.toString()),
                    Spacer(),
                    Icon(Icons.chevron_right),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  navigate(context, PatientsListScreen());
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.upload),
                      label: Text('Upload'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.all(20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.all(24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        navigate(context, SignUp());
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ));
  }
}
