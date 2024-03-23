import 'package:flutter/material.dart';
import 'package:note_hub/config/constants/assets_constants.dart';

SnackBar defaultSnackBar(String text) {
  return SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 2), // Optional duration
  );
}

Image defaultImage() {
  return Image.asset(
    defaultProfileImagePath,
    width: 45,
    height: 45,
    errorBuilder: (context, e, error) => Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.person)),
  );
}

Center emptyAnimation() {
  return Center(
      child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset("assets/animations/output-onlinegiftools.gif"),
      Text(
        "Nothing There!",
        style: TextStyle(
            color: Colors.blue.shade600,
            fontWeight: FontWeight.w600,
            fontSize: 18),
      ),
    ],
  ));
}

String getCurrentTime() {
  String period = DateTime.now().hour < 12 ? 'AM' : 'PM';
  return "${DateTime.now().hour}:${DateTime.now().minute} $period";
}
