import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coder_application/questions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'page_animation.dart';
import 'account_page.dart';
import 'my_progress.dart';
import 'settings.dart';


void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // set material app here rather than inheriting such that app bar settings can be changed 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 77, 175, 255)),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), 
              side: BorderSide.none
            )
          )
        )
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          
          // Sets background and fill the screen
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Background Main_Dark Mode_No Scroll.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // set scrolling widget with padding 
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    // adding template container for daily question pop-up
                    SizedBox(height: 135),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 77, 175, 255),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromARGB(81, 255, 255, 255),
                      ),
                    ),

                    // adding white space
                    SizedBox(
                      height:10
                    ),

                    // adding template container for ----
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                        color: const Color.fromARGB(255, 77, 175, 255),
                        width: 2,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromARGB(81, 255, 255, 255),
                      ),
                      child: Column(children: <Widget>[
                        ElevatedButton(
                          onPressed: (){ 
                             Navigator.push(context, MaterialPageRoute(builder: (context) => const Questions()));
                          },
                          child: Text("Generate")
                        ),
                        ],
                      )
                    ),

                    // adding white space
                    SizedBox(
                      height:10
                    ),

                    // adding template container for ----
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 77, 175, 255),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromARGB(81, 255, 255, 255),
                      ),
                    ),

                    // adding white space
                    SizedBox(
                      height:10
                    ),

                    // adding template container for ----
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 77, 175, 255),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromARGB(81, 255, 255, 255),
                      ),
                    ),

                    // adding white space
                    SizedBox(
                      height:10
                    ),
                    
                    // adding template container for ----
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 77, 175, 255),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromARGB(81, 255, 255, 255),
                      ),
                    ),

                    // Container to seperate from Nav Bar
                    Container(
                      height: 150,
                    ),
                ],
              ),
            )
          ),

          // App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar( // AppBar variables set
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 77, 175, 255),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "My Dashboard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'LuckiestGuy',
                    ),
                  ),
                  SizedBox(width: 110),

                  // Button for showing account detials
                  IconButton( 
                    icon: Icon(
                      Icons.account_circle,
                      size: 35,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      DocumentSnapshot userDoc = await data; // awaits the function call at the top of the class for the firebase data
                      showMyAccountDialog(context, userDoc); // passes the firebase data into the dialog box constructor
                    },
                  ),
                ],
              ),
            )
          ),

          // Navigation Bar
          Positioned(
            bottom: 50,
            left: 60,
            right: 60,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 77, 175, 255),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  // Button for Home Page
                  IconButton(
                    icon: Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(createPageRoute2(Home()));
                    },
                  ),

                  // Button for Progress Page
                  IconButton(
                    icon: Icon(Icons.timeline, color: const Color.fromARGB(75, 255, 255, 255)),
                    onPressed: () {
                      Navigator.of(context).push(createPageRoute2(Progress()));
                    },
                  ),

                  // Button for Leaderboards Page
                  IconButton(
                    icon: Icon(Icons.leaderboard, color: Color.fromARGB(75, 255, 255, 255)),
                    onPressed: () {
                      //Navigator.of(context).push(createPageRoute2(Leaderboard()));
                    },
                  ),

                  // Button for Settings Page
                  IconButton(
                    icon: Icon(Icons.settings, color: Color.fromARGB(75, 255, 255, 255)),
                    onPressed: () {
                      Navigator.of(context).push(createPageRoute2(SettingsPage()));
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

