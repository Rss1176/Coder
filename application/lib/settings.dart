import 'package:coder_application/splash.dart';
import 'package:flutter/material.dart';
import 'page_animation.dart';
import 'account_page.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_progress.dart';
import 'package:url_launcher/url_launcher.dart';
import 'leaderboard.dart';
import 'package:google_fonts/google_fonts.dart';



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
  bool _isNotificationsEnabled = false;

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

  void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}

  Future<void> _deleteAccount(String password) async {
  try {
    // Reauthenticate the user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      // Delete the account after reauthentication
      String userId = user.uid;
      await _firestore.collection('users').doc(userId).delete(); // delete user database data
      await user.delete(); // delete user account
      
      // Close all open dialogs
      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // push to splash (first) page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Splash()),
      );
    } else {
      throw Exception("No user is currently signed in");
    }
  } catch (e) {
      _showErrorDialog("Failed to delete account: $e");
  }
}

void _showDeleteAccountDialog() {
  TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Delete Account"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Please enter your password to confirm account deletion."),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteAccount(passwordController.text);
            },
            child: Text("Delete"),
          ),
        ],
      );
    },
  );
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
                          "Account",
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

                  ElevatedButton(
                    onPressed: () async {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(120, 0, 77, 193),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                        Icon(Icons.mail, color: Colors.white, size: 25),

                        SizedBox(
                          width: 10
                        ),
                    
                        Text("Change Account Email",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 3.0
                  ),

                  ElevatedButton(
                    onPressed: () async {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(120, 0, 77, 193),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                        Icon(Icons.verified_user, color: Colors.white, size: 25),

                        SizedBox(
                          width: 10
                        ),
                    
                        Text("Change Account Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20.0
                  ),

                  Row(
                    children: [

                      SizedBox(
                        width: 25
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "App settings",
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

                  ElevatedButton(
                    onPressed: () async {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(120, 0, 77, 193),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                        Icon(Icons.dark_mode, color: Colors.white, size: 25),

                        SizedBox(
                          width: 10
                        ),
                    
                        Text("Change App Theme",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 3.0
                  ),

                  ElevatedButton(
                    onPressed: () async {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(120, 0, 77, 193),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                        Icon(Icons.edit_square, color: Colors.white, size: 25),

                        SizedBox(
                          width: 10
                        ),
                    
                        Text("Change App Icon",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 3.0
                  ),

                  ElevatedButton(
                    onPressed: () async {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(120, 0, 77, 193),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                        Icon(Icons.verified_user, color: Colors.white, size: 25),

                        SizedBox(
                          width: 10
                        ),
                    
                        Text("Notifications",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),

                        SizedBox(
                          width: 159
                        ),

                        Switch(
                          value: _isNotificationsEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              _isNotificationsEnabled = value;
                            });
                          },
                          activeColor: const Color.fromARGB(255, 57, 255, 143),
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20.0
                  ),

                  Row(
                    children: [

                      SizedBox(
                        width: 25
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Contact",
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

                  ElevatedButton(
                    onPressed: () async {
                      print("Button pressed");
                      const url = "https://classes.myplace.strath.ac.uk/";
                      final Uri uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        print("Launching URL: $url");
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        print("Cannot launch URL: $url");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Could not launch $url")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(120, 0, 77, 193),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                        Icon(Icons.contact_support, color: Colors.white, size: 25),

                        SizedBox(
                          width: 10
                        ),
                    
                        Text("Help",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 3.0
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      print("Button pressed");
                      const url = "https://classes.myplace.strath.ac.uk/";
                      final Uri uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        print("Launching URL: $url");
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        print("Cannot launch URL: $url");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Could not launch $url")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(120, 0, 77, 193),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                        Icon(Icons.article, color: Colors.white, size: 25),

                        SizedBox(
                          width: 10
                        ),
                    
                        Text("Terms & Conditions",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 3.0
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      print("Button pressed");
                      const url = "https://classes.myplace.strath.ac.uk/";
                      final Uri uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        print("Launching URL: $url");
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        print("Cannot launch URL: $url");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Could not launch $url")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(120, 0, 77, 193),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                        Icon(Icons.lock, color: Colors.white, size: 25),

                        SizedBox(
                          width: 10
                        ),
                    
                        Text("Privacy Policy",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20.0
                  ),

                  Row(
                    children: [

                      SizedBox(
                        width: 25
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Danger zone",
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

                  ElevatedButton(
                    onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("This will delete your account"),
                          content: Text("Pressing 'Yes' delete your account permanently"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("No"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop(); // close dialog
                                _showDeleteAccountDialog(); // show delete dialog
                              },
                              child: Text("Yes",
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(120, 0, 77, 193),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                        Icon(Icons.delete_outlined, color: Colors.white, size: 25),

                        SizedBox(
                          width: 10
                        ),
                    
                        Text("Delete Account",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 30.0
                  ),

                  ElevatedButton(
                    onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("This will sign you out"),
                          content: Text("Pressing 'Yes' will log you out and return you to the Login Screen"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("No"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await _signOut();
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Splash()));
                              },
                              child: Text("Yes",
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(204, 255, 79, 79),
                      minimumSize: Size(320, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text("LOG OUT", 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 30.0
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Coder Version 0.0.1\n© 2025 Coder. All rights reserved.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 160.0
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
                    "Settings",
                    style: GoogleFonts.anton(
                      color: Colors.white,
                      fontSize: 25,
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
                    icon: Icon(Icons.leaderboard, color: Color.fromARGB(75, 255, 255, 255)),
                    onPressed: () {
                      Navigator.of(context).push(createPageRoute2(Leaderboard()));
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