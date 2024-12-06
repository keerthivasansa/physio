import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/api/client.dart';
import 'package:physio/colors.dart';
import 'package:physio/nav/bar.dart';
import 'package:physio/user/exercise.dart';
import 'package:physio/user/healthCard.dart';
import 'package:intl/intl.dart';
import 'package:physio/user/reply.dart';
import 'package:physio/utils.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalDays = 0, complete = 0;
  double heart = 0, lung = 0, oxygen = 0;
  String name = "John";
  final today = DateFormat('dd-MM-yyyy').format(DateTime.now());

  _DashboardState() {
    init();
  }

  void init() async {
    final client = locator.get<ApiClient>();
    final res = await client.get("/patient/dashboard", {});
    if (res.isError) return;

    setState(() {
      final info = res.data['info'];
      final avg = res.data['avg'];
      print(avg['heart']);
      print(info['totalDays']);
      setState(() {
        double zr = 0;
        heart = ((avg['heart'] ?? 0) + zr);
        oxygen = ((avg['oxygen'] ?? 0) + zr);
        lung = ((avg['lung'] ?? 0) + zr);
        name = info['name'];
        totalDays = info['totalDays'];
        complete = res.data['completed'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double percentage = complete / totalDays;
    int weeksLeft = totalDays - complete;

    return Scaffold(
        appBar: createAppBar(context, showProfile: true),
        body: totalDays == 0
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Hello, ",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: name,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const WidgetSpan(
                            child: Icon(Icons.waving_hand,
                                color: Colors.orange, size: 24),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: CircularPercentIndicator(
                          radius: 120.0,
                          lineWidth: 12.0,
                          percent: percentage,
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor: Colors.blue.shade100,
                          progressColor: bgPrimaryBlue,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$weeksLeft",
                                style: const TextStyle(
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.bold,
                                    color: bgPrimaryBlue),
                              ),
                              const Text(
                                "days",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const Text(
                                "to go",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        )),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        navigate(context, RepliesScreen());
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble),
                          SizedBox(width: 10),
                          Text('Replies'),
                          Spacer(),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExerciseScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Let's Go",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.fitness_center, color: Colors.white),
                        ],
                      ),
                    ),
                    HealthCard(
                      icon: Icons.favorite,
                      iconColor: Colors.red,
                      title: 'Heart Rate',
                      value: '${heart.toStringAsFixed(1)} BPM',
                      date: today,
                      valueColor: Colors.red,
                      progressBarColor: Colors.orange,
                      progressValue: heart,
                      minValue: 50,
                      maxValue: 100,
                      rangeValues: const [
                        "Light",
                        "Weight",
                        "Aerobic",
                        "Anaerobic",
                        "VO2 Max"
                      ],
                    ),
                    HealthCard(
                      icon: Icons.air,
                      iconColor: Colors.green,
                      title: 'Respiratory Rate',
                      value: '${lung.toStringAsFixed(1)} BPM',
                      date: today,
                      valueColor: Colors.green,
                      progressBarColor: Colors.green,
                      progressValue: lung,
                      minValue: 10,
                      maxValue: 30,
                      rangeValues: List.generate(
                          5, (index) => ((index * 6) + 10).toString()),
                    ),
                    HealthCard(
                      icon: Icons.water_drop,
                      iconColor: Colors.purple,
                      title: 'Oxygen Saturation',
                      value: '${oxygen.toStringAsFixed(1)}%',
                      date: today,
                      valueColor: Colors.purple,
                      progressBarColor: Colors.purple,
                      progressValue: oxygen,
                      minValue: 1,
                      maxValue: 100,
                      rangeValues: const ["Low", "Moderate", "Good"],
                    ),
                  ],
                ),
              )));
  }
}
