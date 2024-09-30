import 'package:flutter/material.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/nav/bar.dart';
import 'package:physio/user/api.dart';
import 'package:physio/user/dashboard.dart';
import 'package:physio/utils.dart';

class HealthInfoForm extends StatefulWidget {
  @override
  _HealthInfoFormState createState() => _HealthInfoFormState();
}

class _HealthInfoFormState extends State<HealthInfoForm> {
  final _formKey = GlobalKey<FormState>();
  PatientApi api = locator.get();

  int? heartRate, respiratoryRate, oxygen;
  String? feedback;

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
                'Kindly Enter these Informations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildInputField(
                label: 'Heart Rate',
                hint: 'Enter Your Heart Rate',
                icon: Icons.favorite,
                onSaved: (value) => heartRate = int.parse(value),
              ),
              _buildInputField(
                label: 'Respiratory Rate',
                hint: 'Enter your Respiratory rate',
                icon: Icons.person,
                onSaved: (value) => respiratoryRate = int.parse(value),
              ),
              _buildInputField(
                label: 'Oxygen Saturation',
                hint: 'Enter your Oxygen saturation',
                icon: Icons.lock,
                onSaved: (value) => oxygen = int.parse(value),
              ),
              SizedBox(height: 20),
              Text(
                'Post Exercise Feedback',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter feedback / queries if any',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) => feedback = value,
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
          keyboardType: TextInputType.number,
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
      // TODO: Process the form data (e.g., send to a server)
      if (heartRate != null &&
          respiratoryRate != null &&
          oxygen != null &&
          feedback != null) {
        await api.saveEntry(heartRate!, respiratoryRate!, oxygen!, feedback!);
        navigate(ctx, Dashboard());
      }
    }
  }
}
