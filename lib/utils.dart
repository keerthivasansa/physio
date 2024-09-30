import 'package:flutter/material.dart';

void navigate(BuildContext ctx, Widget wid) {
  Navigator.push(ctx, MaterialPageRoute(builder: (context) => wid));
}

abstract class JsonConvertible<T> {
  T fromJson(Map<String, dynamic> json);
}

// Convert JSON to a List of specific class.
List<T> convertJsonToList<T>(
    T Function(Map<String, dynamic>) fromJsonMethod, List<dynamic> json) {
  return List<T>.from((json as List).map((e) => fromJsonMethod(e)).toList());
}
