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
              "assets/images/Background Main_Lighter_Dark Mode_No Scroll.png",
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

  Future<void> getFirebaseData() async {
    try {
      QuerySnapshot data = await _firestore.collection('users').get();
    } catch (e) {
      print(e); // Print actual error
    }
  }

  @override
  void initState() {
    super.initState();
    getFirebaseData(); // Fetch data on init
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
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 350,
                  width: 350,
                  child: CircularProgressIndicator(
                    semanticsLabel: "Welcome Back!",
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 77, 175, 255)),
                    backgroundColor: const Color.fromARGB(25, 0, 0, 0),
                    strokeWidth: 6.0,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'LuckiestGuy',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.fromGuest == false)
                        FutureBuilder(
                          future: _firestore.collection('users').get(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            var data = snapshot.data?.docs;

                            return Expanded(
                              child: ListView.builder(
                                itemCount: data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  var user = data?[index];
                                  return ListTile(
                                    title: Text(user?['firstName'] ?? 'name not found'),
                                  );
                                },
                              ),
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
              backgroundColor: const Color.fromARGB(255, 77, 175, 255),
              minimumSize: Size(250, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text("Lets Go!", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 20.0),
          TextButton(
            child: Text("Return to Sign In",
                style: TextStyle(color: Color.fromARGB(180, 56, 62, 70))),
            onPressed: () {
              Navigator.of(context).push(createPageRoute1(Splash()));
            },
          )
        ],
      ),
    );
  }
}