import 'package:flutter/material.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/api/common.dart';
import 'package:physio/doctor/api.dart';
import 'package:physio/doctor/patient_detail.dart';
import 'package:physio/nav/bar.dart';
import 'package:physio/utils.dart';

class PatientsListScreen extends StatefulWidget {
  @override
  _PatientsListScreenState createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  List<Patient> patients = [];
  List<Patient> filteredPatients = [];
  final api = locator.get<DoctorApi>();

  @override
  void initState() {
    super.initState();
    filteredPatients = patients;
    fillState();
  }

  void fillState() async {
    final res = await api.getPatients();
    setState(() {
      patients = res;
      filteredPatients = res;
    });
  }

  void filterPatients(String query) {
    setState(() {
      filteredPatients = patients
          .where((patient) =>
              (patient.name ?? "")
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              patient.id.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search with ID or Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: filterPatients,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: PatientCard(patient: filteredPatients[index]),
                  onTap: () {
                    navigate(context,
                        PatientDetail(patientId: filteredPatients[index].id));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final Patient patient;

  const PatientCard({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.blue, width: 1),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(patient.name ?? "missing"),
        subtitle: Text('ID: ${patient.id}'),
        trailing: Text('Age: ${patient.age}'),
      ),
    );
  }
}
