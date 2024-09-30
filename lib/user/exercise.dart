import 'package:flutter/material.dart';
import 'package:physio/nav/bar.dart';
import 'package:physio/user/postExerciseForm.dart';
import 'package:physio/utils.dart';
import 'package:physio/video_player.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final String videoUri =
      "https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_20mb.mp4";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Exercise 4',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300, // You can adjust the height as needed
              width: 300, // Adjust width if necessary
              child: ChewiePlayer(videoUrl: videoUri),
            ),
            Text("hello"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                navigate(context, HealthInfoForm());
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('NEXT', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
