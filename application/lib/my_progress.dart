import 'package:flutter/material.dart';
import 'page_animation.dart';
import 'account_page.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings.dart';
import 'questions.dart';
import 'show_Rank_Dialog.dart';
import 'leaderboard.dart';

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
    getFirebaseDataAndUpdateRank();// Fetch data of user
  }

  // set language ranks based on integer values
  String? pythonDescription = "Basic";
  String? csharpDescription = "Basic";
  String? javaDescription = "Basic";
  num pythonXP = 0;
  num csharpXP = 0;
  num javaXP = 0;

    void getFirebaseDataAndUpdateRank() async{
      String? iD = _auth.currentUser?.uid;
      if (iD == null){
        throw Exception("You are not logged in");
      }
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(iD).get();

      if (!userDoc.exists){
        throw Exception("failed to find user document");
      }
      setState(() {
        updateRanks(userDoc);
      });
    }

  // function to update users rank based on questions answered - pass in document snapshot of user
  void updateRanks(DocumentSnapshot userDoc) async{
    // update the users python rank
    if (userDoc["pythonLevel"] > 5 && userDoc["pythonLevel"] <= 10){
      pythonDescription = "Intermediate";
      pythonXP = 11 - userDoc["pythonLevel"]; // questions need to reach for rank
    }
    else if (userDoc["pythonLevel"] > 10){
      pythonDescription = "Expert";
      pythonXP = 0; // questions no longer needed as already an expert
    }
    else{
      pythonDescription = "Beginner";
      pythonXP = 6 - userDoc["pythonLevel"]; // questions needed to reach for next rank
    }

    // update the users C# rank
    if (userDoc["c#Level"] > 5 && userDoc["c#Level"] <= 10){
      csharpDescription = "Intermediate";
      csharpXP = 11 - userDoc["c#Level"];  // questions needed to reach for next rank
    }
    else if (userDoc["c#Level"] > 10){
      csharpDescription = "Expert";
      csharpXP = 0; // questions no longer needed as already an expert
    }
    else{
      csharpDescription = "Beginner";
      csharpXP = 6 - userDoc["c#Level"]; 
    }

    //update the users java rank
    if (userDoc["javaLevel"] > 5 && userDoc["javaLevel"] <= 10){
      javaDescription = "Intermediate";
      javaXP = 11 - userDoc["javaLevel"]; // questions no longer needed as already an expert
    }
    else if (userDoc["javaLevel"] > 10){
      javaDescription = "Expert"; // questions needed to reach for next rank
      javaXP = 0;
    }
    else{
      javaDescription = "Beginner";
      javaXP = 6 - userDoc["javaLevel"]; // questions no longer needed as already an expert
    }
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
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Adding Whitespace
                  SizedBox(
                    height: 135.0
                  ),

                  // Python Widget
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(120, 105, 190, 255),
                    ),
                    child:Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                              children: [

                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(125, 198, 230, 255),
                                  ),
                                  child:Padding(
                                    padding: const EdgeInsets.all(5.0),
                                  child: Image(
                                  image: AssetImage("assets/images/python-logo.png"),
                                  width: 40.0,
                                  height: 40.0,
                                ),
                                  ),
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
                                      "$pythonDescription",
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
                                    showRankDialog(context, "Python", pythonXP,pythonDescription);
                                  },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 0, 85, 155),
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

                  // Adding Whitespace
                  SizedBox(
                    height: 10.0
                  ),

                  // Java Widget
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(120, 105, 190, 255),
                    ),
                    child:Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(125, 198, 230, 255),
                                  ),
                                  child:Padding(
                                    padding: const EdgeInsets.all(5.0),
                                  child: Image(
                                  image: AssetImage("assets/images/java-logo.png"),
                                  width: 40.0,
                                  height: 40.0,
                                ),
                                  ),
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
                                      "$javaDescription",
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
                                    showRankDialog(context, "Java", javaXP, javaDescription);
                                  },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 0, 85, 155),
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

                  // Adding Whitespace
                  SizedBox(
                    height: 10.0
                  ),

                  // C# Widget
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(120, 105, 190, 255),
                    ),
                    child:Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                              children: [

                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(125, 198, 230, 255),
                                  ),
                                  child:Padding(
                                    padding: const EdgeInsets.all(5.0),
                                  child: Image(
                                  image: AssetImage("assets/images/csharp-logo.png"),
                                  width: 40.0,
                                  height: 40.0,
                                ),
                                  ),
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
                                      "$csharpDescription",
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
                                    showRankDialog(context, "CSharp", csharpXP, csharpDescription);
                                  },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 0, 85, 155),
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
                    height: 175.0
                  ),

                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(120, 105, 190, 255),
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
                                  image: AssetImage("assets/images/questions_light.png"),
                                  width: 50.0,
                                  height: 50.0,
                                ),

                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Question Portal",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'LuckiestGuy',
                                        decorationThickness: 0.8,
                                      ),
                                    ),
                                    
                                    Text(
                                      "Let's Practice!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'LuckiestGuy',
                                      ),
                                    ),
                                  ],
                                ),

                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Questions()));
                                  },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 0, 85, 155),
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
                    height: 250.0
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
              backgroundColor: Color.fromARGB(255, 0, 85, 155),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(
                    "My Progress",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'LuckiestGuy',
                    ),
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      size: 35,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      DocumentSnapshot userDoc = await data; // awaits the function call at the top of the class for the firebase data
                      showMyAccountDialog(context); // passes the firebase data into the dialog box constructor;
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
                    icon: Icon(Icons.timeline, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(createPageRoute2(Progress()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.leaderboard, color: Color.fromARGB(75, 255, 255, 255)),
                    onPressed: () {
                      Navigator.of(context).push(createPageRoute2(Leaderboard()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Color.fromARGB(75, 255, 255, 255)),
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