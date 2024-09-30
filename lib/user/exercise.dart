import 'package:flutter/material.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/nav/bar.dart';
import 'package:physio/user/api.dart';
import 'package:physio/user/postExerciseForm.dart';
import 'package:physio/utils.dart';
import 'package:physio/video_player.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int currIndex = -1;
  String currVideo = "";
  List<String> videos = [];
  PatientApi api = locator.get();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    final resp = await api.getVideos();
    print("videos:");
    print(resp);
    setState(() {
      videos = resp;
      currVideo = videos[0];
      currIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: currIndex == -1
              ? [CircularProgressIndicator()]
              : [
                  Text(
                    'Exercise ${currIndex + 1}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300, // You can adjust the height as needed
                    width: 300, // Adjust width if necessary
                    child:
                        ChewiePlayer(key: Key(currVideo), videoUrl: currVideo),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currIndex > 0)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currIndex -= 1;
                              currVideo = videos[currIndex];
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          child: const Text('Previous',
                              style: TextStyle(fontSize: 18)),
                        ),
                      SizedBox(width: 10),
                      currIndex < videos.length - 1
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currIndex += 1;
                                  currVideo = videos[currIndex];
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                              ),
                              child: const Text('Next',
                                  style: TextStyle(fontSize: 18)),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                navigate(context, HealthInfoForm());
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                              ),
                              child: const Text('Finish',
                                  style: TextStyle(fontSize: 18)),
                            ),
                    ],
                  ),
                ],
        ),
      ),
    );
  }
}
