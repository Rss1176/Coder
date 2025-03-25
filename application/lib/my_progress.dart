import 'package:flutter/material.dart';
import 'page_animation.dart';
import 'account_page.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() {
  runApp(const Progress());
}

class Progress extends StatelessWidget {
  const Progress({super.key});

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
            ProgressPage(),
          ],
        ),
      );
  }
}

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
   
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(
                    height: 135.0
                  ),

                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 77, 175, 255),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(81, 255, 255, 255),
                    ),
                    child:Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                              children: [

                                Image(
                                  image: AssetImage("assets/images/python-logo.png"),
                                  width: 50.0,
                                  height: 50.0,
                                ),

                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "Python Rank",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'LuckiestGuy',
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                        decorationThickness: 0.8,
                                      ),
                                    ),
                                    
                                    Text(
                                      "Basic",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: 'LuckiestGuy',
                                      ),
                                    ),
                                  ],
                                ),

                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      useSafeArea: false,
                                      builder: (context) {
                                        return SimpleDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.all(15),
                                              child:Column(
                                                children: [

                                                  Image(
                                                    image: AssetImage("assets/images/python-logo.png"),
                                                    width: 50.0,
                                                    height: 50.0,
                                                  ),

                                                  SizedBox(
                                                    height: 10
                                                  ),

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [

                                                      Text("Python Profficiency",
                                                        style: TextStyle(
                                                          color: Color.fromARGB(255, 56, 62, 70),
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),

                                                      FloatingActionButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        mini: true,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15),
                                                          side: BorderSide(
                                                            color: const Color.fromARGB(255, 56, 62, 65), 
                                                            width: 1.0
                                                          )
                                                        ),
                                                        elevation: 0.0,
                                                        backgroundColor: const Color.fromARGB(11, 255, 255, 255),
                                                        child: Icon(
                                                          Icons.close, 
                                                          color: Color.fromARGB(255, 56, 62, 65)
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(
                                                    height: 20
                                                  ),

                                                  Text("Here you can find an overview of your current Python progress!",
                                                    style: TextStyle(
                                                      color: Color.fromARGB(255, 56, 62, 70),
                                                      fontSize: 15,
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    height: 100
                                                  ),

                                                  Text(
                                                    "Keep coding to improve your proficiency!",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(255, 56, 62, 70),
                                                    ),
                                                  ),

                                                ],
                                              )
                                            ),

                                            SizedBox(
                                              height: 20
                                            ),
                                          ]
                                        );
                                      },
                                    );
                                  },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 77, 175, 255),
                                  minimumSize: Size(50, 100),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                child: Row(
                                  children:[

                                    Text("View", 
                                      style: TextStyle(
                                        color: Colors.white)
                                    ),

                                    SizedBox(
                                      width: 5.0
                                    ),

                                    Icon(Icons.arrow_forward_ios, 
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                ),
                              
                            ],
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10.0
                  ),

                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 77, 175, 255),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(81, 255, 255, 255),
                    ),
                    child:Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                              children: [

                                Image(
                                  image: AssetImage("assets/images/java-logo.png"),
                                  width: 50,
                                  height: 50,
                                ),

                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "Java Rank",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'LuckiestGuy',
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                        decorationThickness: 0.8,
                                      ),
                                    ),
                                    
                                    Text(
                                      "Intermediate",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: 'LuckiestGuy',
                                      ),
                                    ),
                                  ],
                                ),

                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      useSafeArea: false,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            height: 400.0,
                                            width: 150.0,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 77, 175, 255),
                                  minimumSize: Size(50, 100),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                child: Row(
                                  children:[

                                    Text("View", 
                                      style: TextStyle(
                                        color: Colors.white)
                                    ),

                                    SizedBox(
                                      width: 5.0
                                    ),

                                    Icon(Icons.arrow_forward_ios, 
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                ),
                              
                            ],
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10.0
                  ),

                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 77, 175, 255),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(81, 255, 255, 255),
                    ),
                    child:Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                              children: [

                                Image(
                                  image: AssetImage("assets/images/csharp-logo.png"),
                                  width: 50.0,
                                  height: 50.0,
                                ),

                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "C# Rank",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'LuckiestGuy',
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                        decorationThickness: 0.8,
                                      ),
                                    ),
                                    
                                    Text(
                                      "Advanced",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: 'LuckiestGuy',
                                      ),
                                    ),
                                  ],
                                ),

                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      useSafeArea: false,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            height: 400.0,
                                            width: 150.0,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 77, 175, 255),
                                  minimumSize: Size(50, 100),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                child: Row(
                                  children:[

                                    Text("View", 
                                      style: TextStyle(
                                        color: Colors.white)
                                    ),

                                    SizedBox(
                                      width: 5.0
                                    ),

                                    Icon(Icons.arrow_forward_ios, 
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                ),
                              
                            ],
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 450.0
                  ),
                ],
              ),
            )
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
              backgroundColor: Color.fromARGB(255, 77, 175, 255),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Text(
                    "Progress",
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
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 77, 175, 255),
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
                    icon: Icon(Icons.timeline, color: Colors.white),
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
                    icon: Icon(Icons.settings, color: Color.fromARGB(75, 255, 255, 255)),
                    onPressed: () {
                      //Navigator.of(context).push(createPageRoute2(Settings()));
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