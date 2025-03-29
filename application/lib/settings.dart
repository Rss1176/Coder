import 'package:coder_application/splash.dart';
import 'package:flutter/material.dart';
import 'page_animation.dart';
import 'account_page.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_progress.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Color.fromARGB(255, 77, 175, 255),
              ),
            ),
            SettingsPage(),
          ],
        ),
      );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // variables for getting user details, used in dialog box
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<DocumentSnapshot> data;

  // same function block as used in all other firebase calls, fetches the user data, ensure the ID matches and gets the userdocument
  @override
  void initState() {
    super.initState();
    data = getFirebaseData(); // Fetch data of user
  }
  Future<DocumentSnapshot> getFirebaseData() async{
    String? iD = _auth.currentUser?.uid;
    if (iD == null){
      throw Exception("You are not logged in");
    }
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(iD).get();

    if (!userDoc.exists){
      throw Exception("failed to find user document");
    }
    return userDoc;
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background_simple.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(
                    height: 135
                  ),

                    Container(
                      height: 610,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 77, 175, 255),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromARGB(81, 255, 255, 255),
                      ),
                    ),
                  ElevatedButton(onPressed: () async {
                    await _signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Splash()));},
                    child: Text("Sign Out"),
                  ),

                  

                  // FOR JOHN: You should be able to add whatever you want here


                  SizedBox(
                    height: 650.0
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              automaticallyImplyLeading: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 0, 85, 155),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'LuckiestGuy',
                    ),
                  ),

                  SizedBox(
                    width: 175
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      size: 35,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      DocumentSnapshot userDoc = await data; // awaits the function call at the top of the class for the firebase data
                      showMyAccountDialog(context, userDoc); // passes the firebase data into the dialog box constructor;
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 60,
            right: 60,
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: 1,
                ),
                color: Color.fromARGB(255, 0, 85, 155),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.home, color: const Color.fromARGB(75, 255, 255, 255)),
                    onPressed: () {
                      Navigator.of(context).push(createPageRoute2(Home()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.timeline, color: const Color.fromARGB(75, 255, 255, 255)),
                    onPressed: () {
                      Navigator.of(context).push(createPageRoute2(Progress()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.leaderboard, color: Color.fromARGB(75, 255, 255, 255)),
                    onPressed: () {
                      //Navigator.of(context).push(createPageRoute2(Leaderboard()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(createPageRoute2(AppSettings()));
                    },
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}