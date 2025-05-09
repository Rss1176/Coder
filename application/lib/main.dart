import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coder_application/continue_as_guest.dart';
import 'package:coder_application/medals.dart';
import 'package:coder_application/questions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_animation.dart';
import 'account_page.dart';
import 'my_progress.dart';
import 'settings.dart';
import 'leaderboard.dart';
import 'feature_not_avaliable.dart';


// App should be run from the splash screen not main

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
  String cAward = "c1"; // variables that denote what award should be displayed as a medal for language efficiency
  String pAward = "p1"; // default to the bronze shield so that if firebase fails to be fetched and update it has a default value
  String jAward = "j1";

  // same function block as used in all other firebase calls, fetches the user data, ensure the ID matches and gets the userdocument
  @override
  void initState() {
    data = getFirebaseData(); // Fetch data of user
    _loadData();
     super.initState(); // load data to set awards on screen
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

  // function to get the firebase data, used in the dialog box
  Future<void> _loadData() async { // loads the data from the medals.dart function for the home page
  DocumentSnapshot data = await getFirebaseData(); // Fetch data of user
    setState(() {
      cAward = getMedalString("csharp", data); 
      pAward = getMedalString("python", data); 
      jAward = getMedalString("java", data); 
    });
  }

  // function to show the daily quiz banner, if the user has not answered the quiz yet, show the button to take the quiz
  Expanded buildDailyQuesionContainer(DocumentSnapshot userDoc){
    if (userDoc["dailyAnswered"] < 6){

      // Daily Quiz container and widget, if the user has yet to take the daily quiz
      return Expanded(
        child:Container(
          height: 231,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(120, 105, 190, 255),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                Text(
                  "DAILY QUIZ",
                  style: GoogleFonts.luckiestGuy(
                    color: Colors.white,
                    fontSize: 40,
                    ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Todays Coder Quiz is to answer\n5 Python programming questions!\n\nThis quiz will award double progress,\ngood luck!",
                      style: GoogleFonts.anton(
                        color: Colors.white,
                        fontSize: 16,
                        ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(createPageRoute2(Questions()));
                      },
                      
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 85, 155),
                        minimumSize: Size(40, 140),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "TAKE\nTHE QUIZ", 
                          textAlign: TextAlign.center,
                          style: GoogleFonts.anton(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),

                  ],
                )

              ],
            )
          ),
        ),
      );
    } else {

      // Daily Quiz container and widget, if the user has already taken the daily quiz
      return Expanded(
        child:Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(120, 105, 190, 255),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  "DAILY QUIZ",
                  style: GoogleFonts.luckiestGuy(
                    color: Colors.white,
                    fontSize: 40,
                    ),
                ),

                Text(
                  "Nice! You have answered all 5 questions!\nYou can come back tomorrow for a new quiz!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.anton(
                    color: Colors.white,
                    fontSize: 16,
                    ),
                ),

                SizedBox(height: 10),

              ],
            )
          ),
        ),
      );
    }
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
                  image: AssetImage("assets/images/background_simple.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Set scrolling widget with padding 
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child:Column(
                children:[

                  // Adding whitespace
                  SizedBox(
                    height: 135,
                    width: 100,
                  ),

                  // Adding a loading indicator while the data is being fetched re daily quiz
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: data, 
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // Show a loading when data not ready
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            // Handle errors
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            // Once the data is available, build the daily banner
                            return buildDailyQuesionContainer(snapshot.data!);
                          } else {
                            // Handle case where data is not available
                            return Text('No data available');
                          }
                        },
                      ),
                    ],
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // FIRST COLUMN
                      Expanded(
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            // Adding whitespace
                            SizedBox(
                              height: 10,
                            ),

                            // Adding template container for Leaderboard
                            Container(
                              height: 375,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(120, 105, 190, 255),
                              ),
                              child:Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                      "GLOBAL LEADERBOARDS",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.luckiestGuy(
                                        color: Colors.white,
                                        fontSize: 25,
                                        ),
                                    ),
                                    ),

                                    // Functinality to get the leaderboard data from firebase
                                    FutureBuilder<QuerySnapshot>(
                                      future: _firestore.collection('users').where('isAnonymous',isEqualTo: false).get(), // only get users with full accounts)
                                      builder: (context, snapshot){
                                        if (snapshot.connectionState == ConnectionState.waiting){ // show a loading symbol when users are coming from firebase
                                          return CircularProgressIndicator();
                                        }
                                        if (snapshot.hasError){
                                          return Text('${snapshot.error}');
                                        }
                                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty){ // logic for no data/failed fetch
                                          return Text("No data");
                                        }

                                      final users = snapshot.data!.docs;
                                      final leaderboard = users.map((user){ // create a dictionary with key user and value a total score
                                        final data = user.data() as Map<String, dynamic>;
                                        int score1 = data['pythonLevel'] ?? 0; // individual score, default value of 0 to stop crashes
                                        int score2 = data['c#Level'] ?? 0;
                                        int score3 = data['javaLevel'] ?? 0;
                                        int totalScore = score1 + score2 + score3;
                                        String name = "${data['firstName']} ${data['lastName']}";

                                        return {
                                          'username': name, // set dictionary with 2 fields username, and calculated score
                                          'totalScore': totalScore,
                                        };
                                      }).toList(); // list of dictionaries
                                    
                                    // sort the data
                                    leaderboard.sort((a, b) {
                                      final int scoreA = a['totalScore'] as int; // Ensure totalScore is an integer
                                      final int scoreB = b['totalScore'] as int; // Ensure totalScore is an integer
                                      return scoreB.compareTo(scoreA); // Sort in descending order
                                    });

                                    // Formatting leaderboard data, limited to 10 users
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 235,
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: AlwaysScrollableScrollPhysics(),
                                              reverse: false,
                                              itemCount: leaderboard.length,
                                              itemBuilder: (context, index) {
                                                final user = leaderboard[index];
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    ListTile(
                                                      leading: 
                                                      Container(
                                                        width: 25,
                                                        height: 25,
                                                        decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius: BorderRadius.circular(25),
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "#${index + 1}",
                                                          textAlign: TextAlign.center,
                                                          style: GoogleFonts.anton(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        user['username'] as String,
                                                        style: GoogleFonts.anton(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          )
                                        ),
                                      ],
                                    );
                                  },
                                  ),

                                    // Button to view the leaderboard in the Leaderboard page
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(createPageRoute2(Leaderboard()));
                                      },
                                      
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 0, 85, 155),
                                        minimumSize: Size(20, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          side: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:[

                                          Text("VIEW", 
                                            style: GoogleFonts.anton(
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
                            ),

                            // Adding whitespace
                            SizedBox(
                              height:10
                            ),

                            // adding template container for C# progress
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(120, 105, 190, 255),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Align(
                                      alignment: Alignment.topCenter,
                                        child:Text(
                                        "PROGRESS",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.luckiestGuy(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.center,
                                      child:Image(
                                        image: AssetImage("assets/images/csharp-logo.png"),
                                        width: 70.0,
                                        height: 70.0,
                                      ),
                                    ),
                                    
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(createPageRoute2(Progress()));
                                      },
                                      
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 0, 85, 155),
                                        minimumSize: Size(20, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          side: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:[

                                          Text("C#", 
                                            style: GoogleFonts.anton(
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
                                )
                              )
                            ),

                            // adding white space
                            SizedBox(
                              height:10
                            ),

                            // adding template container for Java progress
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(120, 105, 190, 255),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Align(
                                      alignment: Alignment.topCenter,
                                        child:Text(
                                        "PROGRESS",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.luckiestGuy(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.center,
                                      child:Image(
                                        image: AssetImage("assets/images/java-logo-simple.png"),
                                        width: 70.0,
                                        height: 70.0,
                                      ),
                                    ),
                                    
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(createPageRoute2(Progress()));
                                      },
                                      
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 0, 85, 155),
                                        minimumSize: Size(20, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          side: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:[

                                          Text("JAVA", 
                                            style: GoogleFonts.anton(
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
                                )
                              )
                            ),

                            // adding white space
                            SizedBox(
                              height:10
                            ),
                            
                            // adding template container for the add widget button
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(0, 105, 190, 255),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Align(
                                      alignment: Alignment.topCenter,
                                        child:Text(
                                        "ADD WIDGET",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.luckiestGuy(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.center,
                                      child:IconButton(
                                        onPressed: () {
                                          showFeatureNotAvailableDialog(context);
                                         },
                                        icon: Icon(Icons.add, size: 70.0), color: Colors.white,
                                      ),  
                                    ),
                                  ],
                                )
                              )
                            ),

                            // Container to seperate from Nav Bar
                            Container(
                              height: 150,
                            ),
                          ],
                        ),
                      ),


                      // adding white space between columns
                      SizedBox(
                        width: 10
                        ),


                      // SECOND COLUMN
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // adding white space
                            SizedBox(
                              height:10,
                            ),

                            // adding template container for Programming Language Questions
                            Container(
                              height: 225,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(120, 105, 190, 255),
                              ),
                              child:Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Align(
                                      alignment: Alignment.topCenter,
                                        child:Text(
                                        "LANGUAGE QUESTIONS",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.luckiestGuy(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  
                                    // Button to start the questions/push to questions page
                                    Align(
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(createPageRoute2(Questions()));
                                        },
                                        icon: Icon(
                                          Icons.question_answer,
                                          size: 70.0,
                                          color: Colors.white,
                                        )
                                      ),
                                    ),

                                    Text("Tap to Start!"
                                      , style: GoogleFonts.anton(
                                        color: Colors.white,
                                        fontSize: 16,
                                        ),
                                    ),

                                    SizedBox(height: 10),

                                  ],
                                ),
                              ),
                            ),

                            // adding whitespace
                            SizedBox(
                              height: 10.0
                            ),

                            // adding template container for Top Profile Awards
                            Container(
                              height: 350,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(120, 105, 190, 255),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Align(
                                      alignment: Alignment.topCenter,
                                        child:Text(
                                        "TOP PROFILE AWARDS",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.luckiestGuy(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    
                                    // Adding first award image
                                    Align(
                                    alignment: Alignment.center,
                                    child: Image(
                                      image: AssetImage("assets/images/$pAward.png"),
                                      width: 75.0,
                                      height: 75.0),
                                    ),

                                    // Adding second award image  
                                    Align(
                                    alignment: Alignment.center,
                                    child: Image(
                                      image: AssetImage("assets/images/$jAward.png"),
                                      width: 75.0,
                                      height: 75.0),
                                    ),

                                    // Adding third award imageh
                                    Align(
                                    alignment: Alignment.center,
                                    child: Image(
                                      image: AssetImage("assets/images/$cAward.png"),
                                      width: 75.0,
                                      height: 75.0),
                                    ),

                                  ],
                                )
                              )
                            ),

                            // adding white space
                            SizedBox(
                              height:10
                            ),

                            // adding template container for Python progress
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(120, 105, 190, 255),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Align(
                                      alignment: Alignment.topCenter,
                                        child:Text(
                                        "PROGRESS",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.luckiestGuy(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),

                                    // Adding python logo
                                    Align(
                                      alignment: Alignment.center,
                                      child:Image(
                                        image: AssetImage("assets/images/python-logo.png"),
                                        width: 70.0,
                                        height: 70.0,
                                      ),
                                    ),
                                    
                                    // Button to push to progress page
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(createPageRoute2(Progress()));
                                      },
                                      
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 0, 85, 155),
                                        minimumSize: Size(20, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          side: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:[

                                          Text("PYTHON", 
                                            style: GoogleFonts.anton(
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
                                )
                              )
                            ),

                            // adding white space
                            SizedBox(
                              height:10
                            ),

                            // adding template container for Settings Page
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(0, 105, 190, 255),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Align(
                                      alignment: Alignment.topCenter,
                                        child:Text(
                                        "APP SETTINGS",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.luckiestGuy(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(createPageRoute2(AppSettings()));
                                        },
                                        icon: Icon(
                                          Icons.settings,
                                          size: 70.0,
                                          color: Colors.white,
                                        )
                                      ),
                                    ),

                                  ],
                                )
                              )
                            ),

                            // adding white space
                            SizedBox(
                              height:10
                            ),

                            // Container to seperate from Nav Bar
                            Container(
                              height: 150,
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
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
              backgroundColor: Color.fromARGB(255, 0, 85, 155),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Dashboard",
                    style: GoogleFonts.anton(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),

                  // Button for showing account detials
                  IconButton( 
                    icon: Icon(
                      Icons.account_circle,
                      size: 35,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      DocumentSnapshot userDoc = await data; // awaits the function call at the top of the class for the firebase data
                      if (userDoc["isAnonymous"] == false){
                        showMyAccountDialog(context);// passes the firebase data into the dialog box constructor
                      }
                      else {
                        guestContinueDialog(context, true); // shows the sign in feature to access the account features
                      }
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
                      Navigator.of(context).push(createPageRoute2(Leaderboard()));
                    },
                  ),

                  // Button for Settings Page
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