import 'package:flutter/material.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/nav/bar.dart';
import 'package:physio/user/api.dart';

class CardWithBorder extends StatelessWidget {
  final String text;

  const CardWithBorder({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(4),
      width: double.infinity,
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class RepliesScreen extends StatefulWidget {
  @override
  _RepliesScreenState createState() => _RepliesScreenState();
}

class _RepliesScreenState extends State<RepliesScreen> {
  List<String> replies = [];
  bool loaded = false;
  PatientApi api = locator.get();

  @override
  void initState() {
    super.initState();
    init(); // Fetch data when the widget is initialized
  }

  void init() async {
    final rep = await api.getReplies();
    setState(() {
      replies = rep
          .map((m) => "Day ${int.parse(m['day'] ?? "0") + 1} - ${m['reply']}")
          .toList();
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: createAppBar(context),
        body: loaded
            ? ListView.builder(
                itemCount: replies.length, // Provide the correct item count
                itemBuilder: (context, index) {
                  return CardWithBorder(
                      text: replies[index]); // Return the card
                },
              )
            : const Center(
                child: CircularProgressIndicator(), // Center the loader
              ),
      ),
    );
  }
}
