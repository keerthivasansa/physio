import 'package:flutter/material.dart';
import 'package:physio/nav/bar.dart';

class HealthInfoForm extends StatefulWidget {
  @override
  _HealthInfoFormState createState() => _HealthInfoFormState();
}

class _HealthInfoFormState extends State<HealthInfoForm> {
  final _formKey = GlobalKey<FormState>();
  String? heartRate;
  String? respiratoryRate;
  String? oxygenSaturation;
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
                onSaved: (value) => heartRate = value,
              ),
              _buildInputField(
                label: 'Respiratory Rate',
                hint: 'Enter your Respiratory rate',
                icon: Icons.person,
                onSaved: (value) => respiratoryRate = value,
              ),
              _buildInputField(
                label: 'Oxygen Saturation',
                hint: 'Enter your Oxygen saturation',
                icon: Icons.lock,
                onSaved: (value) => oxygenSaturation = value,
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
                  onPressed: _submitForm,
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
    required Function(String?) onSaved,
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
          onSaved: onSaved,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Process the form data (e.g., send to a server)
      print('Heart Rate: $heartRate');
      print('Respiratory Rate: $respiratoryRate');
      print('Oxygen Saturation: $oxygenSaturation');
      print('Feedback: $feedback');
    }
  }
}
