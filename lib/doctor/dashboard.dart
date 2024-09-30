import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:physio/doctor/patient_list.dart';
import 'package:physio/nav/bar.dart';
import 'package:physio/utils.dart';

class DoctorDashboard extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DoctorDashboard> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: createAppBar(context, showProfile: true),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              Text(
                'Hi, Dr.Ajith Kumar Pitchai',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
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
                    sections: [
                      PieChartSectionData(
                        color: Colors.orange,
                        value: 45.5,
                        title: touchedIndex == 0 ? 'Day 1\n45.5%' : '',
                        radius: touchedIndex == 0 ? 60 : 50,
                        titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Colors.blue,
                        value: 25.1,
                        title: touchedIndex == 1 ? 'Day 2\n25.1%' : '',
                        radius: touchedIndex == 1 ? 60 : 50,
                        titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Colors.green,
                        value: 25.6,
                        title: touchedIndex == 2 ? 'Day 3\n25.6%' : '',
                        radius: touchedIndex == 2 ? 60 : 50,
                        titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Colors.red,
                        value: 13.6,
                        title: touchedIndex == 3 ? 'Day 4\n13.6%' : '',
                        radius: touchedIndex == 3 ? 60 : 50,
                        titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 60),
              ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 10),
                    Text('Patients'),
                    SizedBox(width: 10),
                    Text('230'),
                    Spacer(),
                    Icon(Icons.chevron_right),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  // primary: Colors.blue,
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
                  SizedBox(width: 20),
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
                      onPressed: () {},
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
