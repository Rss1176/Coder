import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'page_animation.dart';
import 'main.dart';
import 'splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Loading extends StatelessWidget {
  final bool fromGuest;

  const Loading({super.key, required this.fromGuest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              "assets/images/background_simple.png",
              fit: BoxFit.cover,
            ),
          ),
          LoadingPage(fromGuest: fromGuest),
        ],
      ),
    );
  }
}

class LoadingPage extends StatefulWidget {
  final bool fromGuest;

  const LoadingPage({super.key, required this.fromGuest});

  @override
  State<LoadingPage> createState() => _LoadingPage();
}

class _LoadingPage extends State<LoadingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<DocumentSnapshot> data;

  @override
  void initState() {
    super.initState();
    data = getFirebaseData(); // Fetch data of user
  }

  Future<DocumentSnapshot> getFirebaseData() async{//could add a "try" later for better error checking
      String? iD = _auth.currentUser?.uid;
      if (iD == null){
        throw Exception("You are not logged in");
      }
        DocumentReference userDocRef = _firestore.collection('users').doc(iD);
      DocumentSnapshot userDoc = await userDocRef.get();

      if (!userDoc.exists){
        if (_auth.currentUser?.isAnonymous == true) {
          // If the user is anonymous, create a new document
          await userDocRef.set({
            'firstName': 'Guest',
            'lastName': '',
            'location': 'United Kingdom', // as a default value is required to match the dropdwon for this field use UK as that is where the app is based
            'pronoun': 'They/Them',
            'isAnonymous': true,
            'pythonLevel': 0,
            'c#Level': 0,
            'javaLevel': 0,
          });
          userDoc = await userDocRef.get();
        } else {
         // If the user is not anonymous, throw an error
        throw Exception("failed to find user document");
      }
      }
      return userDoc;
    }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 180),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 350,
                  width: 350,
                  child: CircularProgressIndicator(
                    semanticsLabel: "A Welcome Message with the Users Name!",
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 0, 85, 155)),
                    backgroundColor: const Color.fromARGB(12, 238, 238, 238),
                    strokeWidth: 8.0,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'LuckiestGuy',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 208, 208, 208),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.fromGuest == false)
                        FutureBuilder<DocumentSnapshot>(
                          future: data,
                          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            var userData = snapshot.data?.data() as Map<String, dynamic>?;//save all user data in dictionary
                            var firstName = userData?['firstName'] ?? 'Guest';//get the first name out of the dict/map

                            return SizedBox(
                              child:
                              Text(firstName+'!', 
                                style: TextStyle(color: Color.fromARGB(255, 208, 208, 208), fontSize: 30),),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 180),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(createPageRoute1(Home()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 85, 155),
              minimumSize: Size(250, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text("Lets Go!", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 20.0),
          TextButton(
            child: Text("Return to Sign In",
                style: TextStyle(color: Color.fromARGB(255, 208, 208, 208))),
            onPressed: () {
              Navigator.of(context).push(createPageRoute2(Splash()));
            },
          )
        ],
      ),
    );
  }
}