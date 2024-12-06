import 'package:flutter/material.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/doctor/api.dart';
import 'package:physio/doctor/patient_list.dart';
import 'package:physio/nav/bar.dart';
import 'package:physio/utils.dart';

class DocReplyForm extends StatefulWidget {
  final int day, heartRate, respiratoryRate, oxygen;
  final String feedback, patientId;

  DocReplyForm({
    required this.day,
    required this.heartRate,
    required this.respiratoryRate,
    required this.oxygen,
    required this.feedback,
    required this.patientId,
  });

  @override
  DocReplyFormState createState() => DocReplyFormState(
        day,
        heartRate,
        respiratoryRate,
        oxygen,
        feedback,
        patientId,
      );
}

class DocReplyFormState extends State<DocReplyForm> {
  final _formKey = GlobalKey<FormState>();
  DoctorApi api = locator.get();

  final int day, heartRate, respiratoryRate, oxygen;
  String feedback, patientId;
  String reply = "";

  DocReplyFormState(this.day, this.heartRate, this.respiratoryRate, this.oxygen,
      this.feedback, this.patientId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Day Feedback: $feedback',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Heart Rate: $heartRate',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Respiratory Rate: $respiratoryRate',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Oxygen: $oxygen',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildInputField(
                label: 'Reply',
                hint: 'Enter your feedback based on vitals and remarks',
                icon: Icons.chat,
                onSaved: (value) => reply = value,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () async {
                    _submitForm(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.blue),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey),
            border: UnderlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
          onSaved: (val) {
            if (val != null) {
              onSaved(val);
            }
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }

  void _submitForm(BuildContext ctx) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (reply != null && day != null && patientId != null) {
        await api.saveReply(day!, reply!, patientId!);
        navigate(ctx, PatientsListScreen());
      }
    }
  }
}
