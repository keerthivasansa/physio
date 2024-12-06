import 'package:flutter/material.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/auth.dart';
import 'package:physio/doctor/dashboard.dart';
import 'package:physio/doctor/patient_list.dart';
import 'package:physio/user/dashboard.dart';
import 'package:physio/utils.dart';

void showDrawer(BuildContext context, {bool isDoc = false}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Drawer",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5), // Overlay with 50% opacity
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, _, __) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.65, // 80% of the screen width
          child: DrawerWidget(
            isDoc: isDoc,
          ), // Custom Drawer widget
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(
          begin: Offset(1, 0),
          end: Offset(0, 0),
        ).animate(anim1),
        child: child,
      );
    },
  );
}

class DrawerWidget extends StatelessWidget {
  bool isDoc;

  DrawerWidget({required this.isDoc});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFF3b5998), // Your drawer background color
      child: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                Column(
                  children: isDoc ? docDrawer(context) : patientDrawer(context),
                ),
                Spacer(),
                const Text(
                  "Copyright 2024",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )),
      ),
    );
  }

  List<Widget> docDrawer(BuildContext context) {
    return [
      ListTile(
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        onTap: () {
          navigate(context, DoctorDashboard());
        },
      ),
      ListTile(
        title: const Text("Patients", style: TextStyle(color: Colors.white)),
        onTap: () {
          navigate(context, PatientsListScreen());
        },
      ),
      ListTile(
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        onTap: () {},
      ),
      ListTile(
        title: const Text("Help", style: TextStyle(color: Colors.white)),
        onTap: () {},
      ),
      ListTile(
        title: const Text("Logout", style: TextStyle(color: Colors.white)),
        leading: Icon(Icons.logout, color: Colors.white),
        onTap: () async {
          final auth = locator.get<AuthState>();
          await auth.logout();
          navigate(context, const AuthScreen());
        },
      ),
    ];
  }

  List<Widget> patientDrawer(BuildContext context) {
    return [
      ListTile(
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        onTap: () {
          navigate(context, Dashboard());
        },
      ),
      ListTile(
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        onTap: () {},
      ),
      ListTile(
        title: const Text("Help", style: TextStyle(color: Colors.white)),
        onTap: () {},
      ),
      ListTile(
        title: const Text("Logout", style: TextStyle(color: Colors.white)),
        leading: Icon(Icons.logout, color: Colors.white),
        onTap: () async {
          final auth = locator.get<AuthState>();
          await auth.logout();
          navigate(context, const AuthScreen());
        },
      ),
    ];
  }
}
