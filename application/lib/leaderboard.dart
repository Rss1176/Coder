import 'package:flutter/material.dart';
import 'page_animation.dart';
import 'account_page.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_progress.dart';
import 'settings.dart';


class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

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
            LeaderboardPage(),
          ],
        ),
      );
  }
}

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {

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
                  image: AssetImage("assets/images/background_simple.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Adding whitespace to the top of the page
                  SizedBox(
                    height: 135
                  ),

                  Row(
                    children: [

                      SizedBox(
                        width: 25
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Leaderboard",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 5.0
                  ),

                  // Leaderboard List
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

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: leaderboard.length,
                    itemBuilder: (context, index) {
                      final user = leaderboard[index];
                      return Column(
                        children: [
                          ListTile(
                            leading: Text(
                              "#${index + 1}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: Text(
                              user['username'] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              user['totalScore'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (index < leaderboard.length - 1) // Add Divider only if it's not the last item
                            Divider(
                              color: Colors.white,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                            ),
                        ],
                      );
                    },
                  );
                },
                ),

                SizedBox(
                  height: 700,
                )
                ], 
              ),
            ),
          ),

          // App Bar
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
                    "Leaderboards",
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
                    onPressed: (){// awaits the function call at the top of the class for the firebase data
                      showMyAccountDialog(context); // passes the firebase data into the dialog box constructor;
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Navigation Bar
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
                    icon: Icon(Icons.leaderboard, color: Colors.white),
                    onPressed: () {
                      //Navigator.of(context).push(createPageRoute2(Leaderboard()));
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