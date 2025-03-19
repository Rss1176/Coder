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
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
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
                              "Fname Lname",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),

                            SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  "They/Them",
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
                                  "City, Country",
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
                              "Column",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white

                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              "something", 
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white
                              ),
                            ),

                            Text(
                              "somthing else",
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