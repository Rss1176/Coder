import 'package:flutter/material.dart';
import 'loading_welcome.dart';
import 'create.dart';
import 'page_animation.dart';

Future<void> guestContinueDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        children: [

          // Adding Whitespace
          SizedBox(
            height: 20
          ),

          // Adding Padding for the Title of Pop-up Menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text("Continue without Account?",
              style: TextStyle(
                color: Color.fromARGB(255, 56, 62, 70),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Adding Whitespace
          SizedBox(
            height:20
          ),

          // Adding Padding for the Description of 'Continue as Guest'
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("To use all of Coders features as intended, we recommend creating an account"),
                SizedBox(
                  height:10
                  ),
                Text("But if now isn't the right time, you can continue as a guest"),

                // Adding Whitespace
                SizedBox(
                  height:32.0
                ),

                // Adding 'Create an Account' Button after description
                ElevatedButton(
                  onPressed: () {
                  Navigator.of(context).push(createPageRoute2(Create()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 85, 155),
                    minimumSize: Size(350, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text("Create an Account", style: TextStyle(color: Colors.white)),
                ),

                // Adding Whitespace
                SizedBox(
                  height:25.0
                ),  

                // Adding 'Continue as Guest' Button after description
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    // First Dialog Option, Cancel
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.of(context).pop('Cancel');
                      },
                      child: const Text('Cancel'),
                    ),

                    // Second Dialog Option, Continue as Guest
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.of(context).push(createPageRoute2(Loading(fromGuest: true,)));
                      },
                      child: const Text('Continue as Guest'),
                    ),

                  ]
                ),

              // Adding Whitespace
              SizedBox(
                height:10.0
              )

              ]
            ),
          ),
        ],
      );
    }
  );
}