import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showFeatureNotAvailableDialog(BuildContext context) {
  // placeholder dialog for features not yet implemented within the app, currently only used on the widget editer on the home screen
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 0, 85, 155),
        title: Text(
          "We're Working on it!",
          style: GoogleFonts.luckiestGuy(
            color: Colors.white,
          ),
        ),
        content: Text(
          "This feature is not yet available",
          style: GoogleFonts.anton(
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "OK",
              style: GoogleFonts.anton(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
}