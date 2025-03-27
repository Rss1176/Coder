import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> showMyAccountDialog(BuildContext context, DocumentSnapshot userData) async {
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
            color: const Color.fromARGB(255, 0, 85, 155),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 65),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                SizedBox(
                  height: 20
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    SizedBox(
                      height: 30
                    ),

                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage("assets/images/profile_image_placeholder.png"),
                      backgroundColor: const Color.fromARGB(255, 205, 205, 205),
                    ),
                    SizedBox(
                      height: 20
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${userData["firstName"]} ${userData["lastName"]}", // used interpolation to add space between names
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),

                            SizedBox(
                              height: 10
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  userData["pronoun"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  userData["location"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Streaks",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white

                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              "Daily Task: 50", 
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white
                              ),
                            ),

                            Text(
                              "Login: 64",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 30
                    ),

                    Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),

                    SizedBox(
                      height: 10
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Awards",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ],
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