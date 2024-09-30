import 'package:flutter/material.dart';
import 'package:physio/nav/drawer.dart';

AppBar createAppBar(BuildContext ctx, {bool showProfile = false}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: showProfile
        ? IconButton(
            icon: const Icon(Icons.person, color: Colors.blue),
            onPressed: () {
              // Add your functionality here
            },
          )
        : IconButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.grey,
            )),
    actions: [
      IconButton(
        icon: const Icon(Icons.menu, color: Colors.grey),
        onPressed: () {
          showDrawer(ctx);
        },
      ),
    ],
  );
}
