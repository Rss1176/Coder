import 'package:coder_application/create.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'page_animation.dart';
import 'loading_welcome.dart';

class Login extends StatelessWidget {
  final String? email;

  const Login({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                "assets/images/background_simple_fortext.png",
                fit: BoxFit.cover,
              ),
            ),
            LoginPage(email: email), // take in optional parameter from constructor
          ],
        ),
      );
  }
}

class LoginPage extends StatefulWidget {
  final String? email; // optional constructor param
  const LoginPage({super.key, this.email});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Prefill the email field if an email is provided
    if (widget.email != null) {
      _emailController.text = widget.email!;
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage){
    // dialog box shown on an unsucessfuly sign in
    showDialog(context: context, 
    builder: (errorBox) => AlertDialog(
      title: Text("Error", style: TextStyle(color: Colors.red,
                                            fontWeight: FontWeight.bold)),
      content: Text(errorMessage),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions:[
        TextButton(onPressed: () => Navigator.pop(errorBox), 
        child: Text("OK", style: TextStyle(color: Colors.red))),
      ]
    ));
  }

    void _showCreateDialog(BuildContext context){
    // dialog box shown on an unsucessfuly sign in
    showDialog(context: context, 
    builder: (errorBox) => AlertDialog(
      title: Text("Create Account", style: TextStyle(color: Colors.black,
                                            fontWeight: FontWeight.bold)),
      content: Text("No account found for this email. You can create one, try again, or continue as a Guest."),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions:[
        TextButton(onPressed: () => Navigator.pop(errorBox), 
        child: Text("Cancel", style: TextStyle(color: Colors.black))),
        TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Create())), 
        child: Text("Create Account", style: TextStyle(color: Colors.blue))),
      ]
    ));
  }

String getFirebaseAuthErrorMessage(String errorCode) {
  // sets more user friendly strings from firebase failure data, taken from documentation
  switch (errorCode) {
    case "invalid-email":
      return "The email address is not valid.";
    case "user-disabled":
      return "This user account has been disabled."; 
    case "invalid-credential":  // for CodeR invalid credentails will not distinguish between password or email for security
      return "Incorrect email or password. Please try again.";
    default:
      return "An unknown error occurred. Please try again.";
  }
}

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          // Adding Whitespace
          SizedBox(
            height:80.0
          ),

          // Adding Padding for widgets so they all line up with one another
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Adding a Text Title to the top left of the screen
                Text("Let's Sign you in.",
                  style: TextStyle(
                    color: Color.fromARGB(255, 208, 208, 208),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Adding a close button to the top right of the screen
                FloatingActionButton(
                  tooltip: "Return to splash screen", // built in semantic
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  mini: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: const Color.fromARGB(255, 208, 208, 208), 
                      width: 1.0
                    )
                  ),
                  elevation: 0.0,
                  backgroundColor: const Color.fromARGB(11, 255, 255, 255),
                  child: Icon(
                    Icons.close, 
                    color: Color.fromARGB(255, 208, 208, 208)
                  ),
                ),
              ],
            ),
          ),

          // Adding Whitespace
          SizedBox(
            height:50
          ),

          // Adding Padding for widgets so they all line up with one another
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
             child: Column(
              children: [

                // Creating a Form to send login information to Firebase for Verification
                Form(
                  key: _formKey, 
                  child: Column(
                    children: [

                      // The first text entry field, covering username for firebase verification
                      Semantics(label: "Please enter a valid email",
                      child: TextFormField(
                        style:TextStyle(color: Color.fromARGB(255, 208, 208, 208)),
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Visibility(
                            child: Icon(Icons.mail, color: const Color.fromARGB(255, 208, 208, 208))),
                          hintText: "Email",
                            hintStyle: TextStyle(color: Color.fromARGB(255, 208, 208, 208)),
                          labelText: "",
                          floatingLabelBehavior: FloatingLabelBehavior.always, 
                          floatingLabelStyle: TextStyle(fontSize: 20),
                          filled: true,
                          fillColor: const Color.fromARGB(11, 225, 225, 225),
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        validator: (value) {
                          // tells user that their inputed value is not a valid email
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid email';
                            }
                            // ensures that the form is not valid as the email is wrong
                            return null;
                        },
                      )),

                      // Adding Whitespace
                      SizedBox(
                        height: 15.0
                      ),

                      // The second text entry field, covering password for firebase verification
                      Semantics(label: "Please enter your password, must be at least 6 characters",
                      child: TextFormField(
                        style:TextStyle(color: Color.fromARGB(255, 208, 208, 208)),
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Visibility(
                            child: Icon(Icons.lock, color: const Color.fromARGB(255, 208, 208, 208))),
                          hintText: "Password",
                            hintStyle: TextStyle(color: Color.fromARGB(255, 208, 208, 208)),
                          labelText: "",
                          floatingLabelBehavior: FloatingLabelBehavior.always, 
                          floatingLabelStyle: TextStyle(fontSize: 20),
                          filled: true,
                          fillColor: const Color.fromARGB(11, 225, 225, 225),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return "please enter password"; //same logic as above but for passwords
                          }
                          return null;
                        },
                      )),
                    ],
                  ),
                ),

                // Adding Whitespace
                SizedBox(
                  height:380.0
                  ),

                // Adding Column for bottom widgets related to creating an account and Logging in
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:[

                    // Adding a Row for the buttons to create an account instead of logging in
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // Adding non-clickable text before the button
                        Text("Don't have an account?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 208, 208, 208),
                          )
                        ),
                        
                        // Adding whitespace
                        SizedBox(
                          width:1.0
                        ),

                        // Adding a button to push to create an account screen
                        TextButton(
                          onPressed: (){
                            Navigator.of(context).push(createPageRoute2(Create()));
                          },
                          child: Semantics(label:"Press this button to go to the create an account screen",
                          child: Text("Register", 
                          style: TextStyle(
                            color: Color.fromARGB(255, 208, 208, 208),
                            fontWeight: FontWeight.bold,
                            )
                          )),
                        )
                      ],
                    ),

                    // Adding Whitespace
                    SizedBox(
                      height: 20,
                    ),

                    // Adding a button to sign in after entering email and password
                    ElevatedButton(
                      onPressed: () async {
                        try{ // Try to sign in
                          await _auth.signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          final userDoc = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
                          if (!userDoc.exists){
                            _showCreateDialog(context);
                          } else {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loading(fromGuest: false,)));
                          }
                        } 
                        on FirebaseAuthException catch (e) { // catches the error for incorrect sign in
                        print("Firebase Auth Error Code: ${e.code}");
                        String errorMessage = getFirebaseAuthErrorMessage(e.code); // calls the function to set user friendly error message
                        _showErrorDialog(context, errorMessage); // displays user friendly error message
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.center,
                        backgroundColor: const Color.fromARGB(255, 0, 85, 155),
                        minimumSize: Size(350, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      child: Text("Sign in", 
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ),
                  ]
                )
              ]
            ),
          )
        ]
      )
    );
  }
}