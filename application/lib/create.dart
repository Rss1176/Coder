import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'page_animation.dart';


class Create extends StatelessWidget {
  const Create({super.key});

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
            CreatePage(),
          ],
        ),
      );
  }
}

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firstNameController = TextEditingController(); // controllers to hold form fields
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool formFull = false; // boolean that activates create an account if the form is full
  String? _selectedPronoun;
  String? _selectedLocation;
  String? sharedEmail; // global variable for passing email to login screen

  // Function to create user document in Firestore
  Future<void> _createUserDocument(User user) async {
    final _firestore = FirebaseFirestore.instance;
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'uid': user.uid,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'pronoun': _selectedPronoun,
        'location': _selectedLocation,
        'pythonLevel': 0,
        'c#Level': 0,
        'javaLevel': 0,
        'isAnonymous': false, // this is true for guest users, not sure how it will be used yet but better to have it and not need it than need it and not have it
        'profileImage': '', // empty profile image for use later
        'dailyAnswered': 0,
      });
    } catch (e) {
      print("Error creating user document: $e"); // technically bad practice to keep as a print but users are shown errors in other places and allows debugging
    };
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

  String getFirebaseAuthErrorMessage(String errorCode) {
    // get more user friendly error codes for unsuccessful sign-ins
  switch (errorCode) {
    case "invalid-email":
      return "The email address is not valid.";
    case "user-disabled":
      return "This user account has been disabled.";
    case "invalid-credential":  // for CodeR invalid credentails will not distinguish between password or email for security
      return "Incorrect email or password. Please try again.";
    case "email-already-in-use":
      return "An account already exists for this email.";
    case "operation-not-allowed":
      return "Signing in with email/password is not enabled.";
    case "weak-password":
      return "Your password is too weak. Your password must be at least 6 characters";
    default:
      return "An unknown error occurred. Please try again.";
  }
}

  void setButtonActive(){
    // function to check if the button to create an account should be set to active
    // called after every form field is changed and only set to active once they are all not null
    setState(()
    {
      formFull = _firstNameController.text.isNotEmpty &&
               _lastNameController.text.isNotEmpty &&
               _emailController.text.isNotEmpty &&
               _passwordController.text.isNotEmpty &&
               _confirmPasswordController.text.isNotEmpty &&
               _selectedPronoun != null &&
               _selectedLocation != null;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,        
        children: <Widget>[

          // Adding Whitespace
          SizedBox(
            height:80.0
          ),


          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              // Adding 'Let's Get Started' Title Text
              Text("Let's Get Started.",
                style: TextStyle(
                  color: Color.fromARGB(255, 208, 208, 208),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Adding 'Close' Button
              FloatingActionButton(
                tooltip: "Press this button to go back to the home screen",
                onPressed: () {
                  Navigator.pop(context);
                },
                mini:true,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: const Color.fromARGB(255, 208, 208, 208), 
                width: 1.0)
                ),
                elevation: 0.0,
                backgroundColor: const Color.fromARGB(11, 255, 255, 255),
                child: const Icon(Icons.close, color: Color.fromARGB(255, 208, 208, 208)),
                ),
              ],
            ),
          ),

          // Adding Whitespace
          SizedBox(
            height: 50
          ),

          // Adding Padding for the Description of 'Create an Account'
          Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children:[
              Form(
                key: _formKey,
                child: Column(
                  children: [

                    // Adding First Name and Pronouns Form Fields in the same row to tidy up space
                    Row(
                      children: [

                        // Using expanded to fill avaliable space 
                        Expanded(  

                          // Adding First Name Form Field
                          child: Semantics(label: "Enter your first name here",
                            child: TextFormField(
                            onChanged: (value) => setButtonActive(),
                            style:TextStyle(color: Color.fromARGB(255, 208, 208, 208), fontSize:16),
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              prefixIcon: Visibility(
                                child: Icon(Icons.account_box, color: const Color.fromARGB(255, 208, 208, 208))),
                              hintText: "First Name",
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
                              if (value == null || value.isEmpty) {
                                return 'Please enter a first name'; //requires user enter a value for email
                              }
                              return null; // ensures the form is not inputed if invalid
                            },
                          ),
                        )),

                        // Adding Whitespace
                        SizedBox(
                          width: 15.0
                          ),

                        // Using expanded to fill avaliable space 
                        Expanded(child:

                          // Adding Dropdown Button for Pronouns
                          Semantics(label:"Dropdown to select your pronouns",
                          child: DropdownButtonFormField<String>(
                            dropdownColor: Colors.grey[850],
                            style:TextStyle(color: Color.fromARGB(255, 208, 208, 208), fontSize:16),
                            value: _selectedPronoun,
                            decoration: InputDecoration(
                              hintText: "",
                              labelText: "", 
                              floatingLabelBehavior: FloatingLabelBehavior.always, 
                              floatingLabelStyle: TextStyle(fontSize: 20),
                              filled: true,
                              fillColor: const Color.fromARGB(11, 225, 225, 225),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            items: [ // Dropdown menu items
                              DropdownMenuItem(value: 'He/Him', child: Text('He/Him')),
                              DropdownMenuItem(value: 'She/Her', child: Text('She/Her')),
                              DropdownMenuItem(value: 'They/Them', child: Text('They/Them')),
                              DropdownMenuItem(value: 'Non-Bindary', child: Text('Non-binary')),
                              DropdownMenuItem(value: 'Other', child: Text('Other')),
                            ],
                            hint: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Pronouns', style: TextStyle(color: Color.fromARGB(255, 168, 168, 168))),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _selectedPronoun = value;
                              });
                              setButtonActive();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please make a selection'; //requires user enter a value for pronoun name
                              }
                              return null; // ensures the form is not if no value is selected
                            },
                          ),
                        )),
                      ],
                    ),

                    // Adding Whitespace
                    SizedBox(
                      height: 15.0
                    ),

                    // Adding Last Name Form Field
                    Semantics (label: "Enter your last name here",
                      child: TextFormField(
                      onChanged: (value) => setButtonActive(),
                      style:TextStyle(color: Color.fromARGB(255, 208, 208, 208), fontSize:16),
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        prefixIcon: Visibility(
                          child: Icon(Icons.account_box, color: const Color.fromARGB(255, 208, 208, 208))),
                        hintText: "Last Name",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 208, 208, 208)),
                        labelText: "",
                        floatingLabelBehavior: FloatingLabelBehavior.always, 
                        floatingLabelStyle: TextStyle(fontSize: 20),
                        filled: true,
                        fillColor: const Color.fromARGB(11, 225, 225, 225),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        )
                      ),
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return 'Please enter a last name'; //requires user enter a value for last name
                        }
                        return null; // ensures the form is not inputed if invalid
                      },
                    )),

                    // Adding Whitespace
                    SizedBox(
                      height: 15.0
                    ),

                    // Adding Location Dropdown Button
                    Semantics(label: "Select your location from your the dropdown menu",
                    child: 
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.grey[850],
                      style:TextStyle(color: Color.fromARGB(255, 208, 208, 208), fontSize:16),
                      value: _selectedLocation,
                      decoration: InputDecoration(
                        prefixIcon: Visibility(
                          child: Icon(Icons.place, color: Color.fromARGB(255, 208, 208, 208)),
                        ),
                        
                        hintText: "Location",
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
                      hint: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Location', style: TextStyle(color: Color.fromARGB(255, 168, 168, 168))),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                        setButtonActive();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please make a selection'; //requires user enter a value for location
                        }
                        return null; // ensures the form is not inputed if invalid
                      },
                    )),

                    // Adding Whitespace
                    SizedBox(
                      height: 80.0
                    ),

                    // Adding Email Form Field
                    Semantics(label:"Please enter a valid email",
                      child:TextFormField(
                      onChanged: (value) => setButtonActive(),
                      style:TextStyle(color: Color.fromARGB(255, 208, 208, 208), fontSize:16),
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Visibility(
                          child: Icon(Icons.mail, color: const Color.fromARGB(255, 208, 208, 208)),
                        ),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 208, 208, 208)),
                        labelText: "",
                        floatingLabelBehavior: FloatingLabelBehavior.always, 
                        floatingLabelStyle: TextStyle(fontSize: 20),
                        filled: true,
                        fillColor: const Color.fromARGB(11, 225, 225, 225),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        )
                      ),
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return 'Please enter a valid email'; //requires user enter a value for email
                        }
                        return null; // ensures the form is not inputed if invalid
                      },
                    )),

                    // Adding Whitespace
                    SizedBox(
                      height: 15.0
                    ),

                    // Adding Password Form Field
                    Semantics(label: "Enter a password for your account. It must be at least 6 characters long",
                      child: TextFormField(
                      onChanged: (value) => setButtonActive(),
                      style:TextStyle(color: Color.fromARGB(255, 208, 208, 208), fontSize:16),
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Visibility(
                          child: Icon(Icons.lock, color: const Color.fromARGB(255, 208, 208, 208)),
                        ),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 208, 208, 208)),
                        labelText: "",
                        floatingLabelBehavior: FloatingLabelBehavior.always, 
                        floatingLabelStyle: TextStyle(fontSize: 20),
                        filled: true,
                        fillColor: const Color.fromARGB(11, 225, 225, 225),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )
                      ),
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return "please set a password"; //same logic as above
                      }
                      return null;
                      },
                    )),

                    // Adding Whitespace
                    SizedBox(
                      height: 15.0
                    ),

                    // Adding Confirm Password Form Field
                    Semantics(label: "Please re-enter your password to ensure that you have entered it correctly",
                      child: TextFormField(
                      onChanged: (value) => setButtonActive(),
                      style:TextStyle(color: Color.fromARGB(255, 208, 208, 208), fontSize:16),
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Visibility(
                          child: Icon(Icons.verified_user, color: const Color.fromARGB(255, 208, 208, 208)),
                        ),
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 208, 208, 208)),
                        labelText: "",
                        floatingLabelBehavior: FloatingLabelBehavior.always, 
                        floatingLabelStyle: TextStyle(fontSize: 20),
                        filled: true,
                        fillColor: const Color.fromARGB(11, 225, 225, 225),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )
                      ),
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return "please confirm your password"; //same logic as above
                      } else if (value != _passwordController.text){
                          return "Passwords do not match"; //ensure that the password matches the confirm password
                      }
                      return null;
                      },
                    )),

                    // Adding Whitespace
                    SizedBox(
                      height: 30.0
                    ),

                  ],
                ),
              ),

              // Adding 'Already have an account?' Text and 'Login' Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Adding leading text before Text button to Login
                  Text("Already have an account?",
                    style: TextStyle(color: Color.fromARGB(255, 208, 208, 208))
                  ),

                  // Adding Whitespace
                  SizedBox(
                    width:1.0
                  ),

                  // Adding 'Login' Button, which redirects to Login Page
                    TextButton(
                      child: Semantics(label: "Press this button to return to the login screen",
                      child: Text("Login", 
                      style: TextStyle(
                        color: Color.fromARGB(255, 208, 208, 208),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    onPressed: (){
                      Navigator.of(context).push(createPageRoute2(Login()));
                    },
                  ),
                ],
              ),

              // Adding Whitespace
              SizedBox(
                height: 20
              ),

              // Adding 'Create Account' Button, which forwards the form to Firebase Service
              ElevatedButton(
                onPressed: formFull ? () async {
                  try {
                      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    await _createUserDocument(userCredential.user!);

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(email: _emailController.text)));
                  } on FirebaseAuthException catch (e) {         
                    String errorMessage = getFirebaseAuthErrorMessage(e.code);
                    _showErrorDialog(context, errorMessage);
                  }
                } : null, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 85, 155),
                  minimumSize: Size(350, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: Semantics(label: "Press this button to save your options and create an account",
                  child: Text("Create Account", style: TextStyle(color: Colors.white),
                )),
              ),
              ]
            )
          )
        ]
      )
    );
  }
}