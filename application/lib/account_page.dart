import 'package:flutter/material.dart';

Future<void> showMyAccountDialog(BuildContext context) async {
  return showDialog(
    context: context,
    useSafeArea: false,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        alignment: Alignment.topCenter,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 600,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 77, 175, 255),
            borderRadius: BorderRadius.circular(15),
            /* border: Border(
              top: BorderSide(
                width: 0,
              ),
              left: BorderSide(
                color: Colors.white,
                width: 6,
              ),
              right: BorderSide(
                color: Colors.white,
                width: 6,
              ),
              bottom: BorderSide(
                color: Colors.white,
                width: 6,
              ),
            ), */ // This, for some unknown reason breaks the dialogue box
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 65),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "My Coder Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 25,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "TestName",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Email:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}