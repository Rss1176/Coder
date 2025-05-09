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
import 'feature_not_avaliable.dart';


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
  bool _isDarkModeEnabled = true;

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

// Function to delete user account
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

  // Function to show the delete account dialog
  // It prompts the user to enter their password to confirm account deletion
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

// Function to update account details, firstname, lastname, pronoun and location
void _updateAccount(DocumentSnapshot user){
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    String firstName = user["firstName"];
    String lastName = user["lastName"];
    String pronoun = user["pronoun"] ?? "";
    String location = user["location"];

    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Change Account Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Please make your changes."),
            TextField(
              controller: firstNameController = TextEditingController(text: firstName),
              obscureText: false,
              decoration: InputDecoration(labelText: "First Name"),
            ),
            TextField(
              controller: lastNameController = TextEditingController(text: lastName),
              obscureText: false,
              decoration: InputDecoration(labelText: "Last Name"),
            ),
            DropdownButtonFormField<String>(
              value: pronoun,
              items: [ // Dropdown menu items
                      DropdownMenuItem(value: 'He/Him', child: Text('He/Him')),
                      DropdownMenuItem(value: 'She/Her', child: Text('She/Her')),
                      DropdownMenuItem(value: 'They/Them', child: Text('They/Them')),
                      DropdownMenuItem(value: 'Non-Bindary', child: Text('Non-binary')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
            onChanged: (value){
              pronoun = value ?? ""; // update pronoun in a null safe way
            }),
             DropdownButtonFormField<String>(
              value: location,
              items: [
                      DropdownMenuItem(value: 'United Kingdom', child: Text('United Kingdom')),
                      DropdownMenuItem(value: 'United States', child: Text('United States')),
                      DropdownMenuItem(value: 'Canada', child: Text('Canada')),
                      DropdownMenuItem(value: 'Australia', child: Text('Australia')),
                      DropdownMenuItem(value: 'Germany', child: Text('Germany')),
                      DropdownMenuItem(value: 'France', child: Text('France')),
                      DropdownMenuItem(value: 'India', child: Text('India')),
                      DropdownMenuItem(value: 'China', child: Text('China')),
                      DropdownMenuItem(value: 'Japan', child: Text('Japan')),
                      DropdownMenuItem(value: 'Brazil', child: Text('Brazil')),
                      DropdownMenuItem(value: 'South Africa', child: Text('South Africa')),
                      DropdownMenuItem(value: 'Mexico', child: Text('Mexico')),
                      DropdownMenuItem(value: 'Italy', child: Text('Italy')),
                      DropdownMenuItem(value: 'Spain', child: Text('Spain')),
                      ],
            onChanged: (value){
            location = value ?? "";
            }) 
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
              await _firestore.collection('users').doc(user.id).update({
                'firstName': firstNameController.text,
                'lastName': lastNameController.text,
                'pronoun': pronoun,
                'location': location,
              });
            },
            child: Text("Save Changes"),
          ),
        ],
      );
    },
  );
}

// Function for updating user password
void _updateEmail(DocumentSnapshot user){
    TextEditingController emailController = TextEditingController(text: user["email"]);
    TextEditingController passwordController = TextEditingController();
    bool _isLoading = false;
  
    // currently does not work properly as firebase is meant to send emails to users as authentication but we do not have email authentication

  // Dialogue box for updating users email address
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Update Email"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Please enter your new email adress."),
            TextField(
              controller: emailController,
              obscureText: false,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 10),
            Text("Please enter your password to continue"),
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
              String newEmail = emailController.text.trim();
              String password = passwordController.text.trim();

              if (newEmail.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Email and password cannot be empty")),
                );
                return;
              }

              setState(() {
                _isLoading = true; // Show loading indicator
              });

              try {
                User? firebaseUser = FirebaseAuth.instance.currentUser;
                if (firebaseUser != null) {
                  // Reauthenticate the user
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: firebaseUser.email!,
                    password: password,
                  );
                  await firebaseUser.reauthenticateWithCredential(credential);

                  // Update email in Firebase Authentication
                  await firebaseUser.updateEmail(newEmail);

                  // Update email in Firestore
                  await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).update({
                    "email": newEmail,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Email updated successfully")),
                  );

                  Navigator.of(context).pop(); // Close the dialog
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to update email: $e")),
                );
              } finally {
                setState(() {
                  _isLoading = false; // Hide loading indicator
                });
              }
            },
            child: _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text("Save"),
          ),
        ],
      );
    },
  );
}

// Function for updating user password
void _updatePassword(DocumentSnapshot user){
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    bool _isLoading = false;

    // currently does not work properly as firebase is meant to send emails to users as authentication but we do not have email authentication

  // Dialogue box for updating users password
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Update Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Please enter your old password."),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Old Password"),
            ),
            SizedBox(height: 10),
            Text("Please enter your new password to continue"),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "New Password"),
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
              String password = passwordController.text.trim();
              String newPassword = newPasswordController.text.trim();

              if (newPassword.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Password cannot be empty")),
                );
                return;
              }

              setState(() {
                _isLoading = true; // Show loading indicator
              });

              try {
                User? firebaseUser = FirebaseAuth.instance.currentUser;
                if (firebaseUser != null) {
                  // Reauthenticate the user
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: firebaseUser.email!,
                    password: password,
                  );
                  await firebaseUser.reauthenticateWithCredential(credential);

                  // Update email in Firebase Authentication
                  await firebaseUser.updatePassword(newPassword);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Password updated successfully")),
                  );

                  Navigator.of(context).pop(); // Close the dialog
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to update password: $e")),
                );
              } finally {
                setState(() {
                  _isLoading = false; // Hide loading indicator
                });
              }
            },
            child: _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text("Save"),
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
                    height: 200
                  ),

                  // Adding 'Sub-heading' for account options
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

                  // Adding whitespace
                  SizedBox(
                    height: 5.0
                  ),

                  // Adding buttons for account change/update options
                  ElevatedButton(
                    onPressed: () async {
                      DocumentSnapshot data = await getFirebaseData();
                      _updateAccount(data);
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
                        
                        Icon(Icons.manage_accounts, color: Colors.white, size: 25),

                        SizedBox(
                          width: 10
                        ),
                    
                        Text("Update Account Information",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Adding whitespace
                  SizedBox(
                    height: 3.0
                  ),

                  // Adding buttons for email change option
                  ElevatedButton(
                    onPressed: () async {
                      DocumentSnapshot data = await getFirebaseData();
                      _updateEmail(data);
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

                  // Adding whitespace
                  SizedBox(
                    height: 3.0
                  ),

                  // Adding buttons for password change option
                  ElevatedButton(
                    onPressed: () async {
                      DocumentSnapshot data = await getFirebaseData();
                      _updatePassword(data);

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

                  // Adding whitespace
                  SizedBox(
                    height: 20.0
                  ),

                  // Adding 'Sub-heading' for app settings
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

                  // Adding whitespace
                  SizedBox(
                    height: 5.0
                  ),

                  // Adding buttons for app icon settings  
                  ElevatedButton(
                    onPressed: () async {
                      showFeatureNotAvailableDialog(context);
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
                  
                  // Adding whitespace
                  SizedBox(
                    height: 3.0
                  ),

                  // Adding buttons for app theme settings
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
                        
                        Icon(Icons.contrast, color: Colors.white, size: 25),

                        SizedBox(
                          width: 10
                        ),
                    
                        Text("App Theme",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),

                        SizedBox(
                          width: 140
                        ),

                        Icon(
                          _isDarkModeEnabled ? Icons.dark_mode : Icons.wb_sunny,
                          color: Colors.white,
                          size: 25,
                        ),

                        Switch(
                          value: _isDarkModeEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              _isDarkModeEnabled = value;
                            });
                          },
                          activeColor: const Color.fromARGB(255, 57, 255, 143),
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),

                  // Adding whitespace
                  SizedBox(
                    height: 3.0
                  ),

                  // Adding buttons for app notification settings
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
                        
                        Icon(Icons.notifications, color: Colors.white, size: 25),

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
                          width: 130
                        ),

                        Icon(
                          _isNotificationsEnabled ? Icons.notifications : Icons.notifications_off,
                          color: Colors.white,
                          size: 25,
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

                  // Adding whitespace
                  SizedBox(
                    height: 20.0
                  ),

                  // Adding 'Sub-heading' for contact section
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

                  // Adding whitespace
                  SizedBox(
                    height: 5.0
                  ),

                  // Adding button for help option, which launches a URL
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

                  // Adding whitespace
                  SizedBox(
                    height: 3.0
                  ),

                  // Adding button for terms and conditions option, which launches a URL
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

                  // Adding whitespace
                  SizedBox(
                    height: 3.0
                  ),

                  // Adding button for privacy policy option, which launches a URL
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

                  // Adding whitespace
                  SizedBox(
                    height: 20.0
                  ),

                  // Adding 'Sub-heading' for account deletion and logout buttons
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

                  // Adding whitespace
                  SizedBox(
                    height: 5.0
                  ),

                  // Adding button for deleting account option
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

                  // Adding whitespace
                  SizedBox(
                    height: 30.0
                  ),

                  // Adding button for log out option
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

                  // Adding whitespace
                  SizedBox(
                    height: 30.0
                  ),

                  // Adding app version and rights reserved notice
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

                  // Adding whitespace
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