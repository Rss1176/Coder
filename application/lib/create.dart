import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'page_animation.dart';


void main() {
  runApp(const Create());
}

class Create extends StatelessWidget {
  const Create({super.key});

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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedPronoun;
  String? _selectedLocation;

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
      });
    } catch (e) {
      print("Error creating user document: $e");
    };
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
                  color: Color.fromARGB(255, 56, 62, 70),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Adding 'Close' Button
              FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                mini:true,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: const Color.fromARGB(255, 56, 62, 65), width: 1.0)
                ),
                elevation: 0.0,
                backgroundColor: const Color.fromARGB(11, 255, 255, 255),
                child: const Icon(Icons.close, color: Color.fromARGB(255, 56, 62, 65)),
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
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              prefixIcon: Visibility(
                                child: Icon(Icons.account_box, color: const Color.fromARGB(255, 213, 213, 213))),
                              hintText: "First Name",
                              hintStyle: TextStyle(color: Color.fromARGB(255, 168, 168, 168)),
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
                        ),

                        // Adding Whitespace
                        SizedBox(
                          width: 15.0
                          ),

                        // Using expanded to fill avaliable space 
                        Expanded(

                          // Adding Dropdown Button for Pronouns
                          child: DropdownButtonFormField<String>(
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
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please make a selection'; //requires user enter a value for middle name
                              }
                              return null; // ensures the form is not inputed if invalid
                            },
                          ),
                        ),
                      ],
                    ),

                    // Adding Whitespace
                    SizedBox(
                      height: 15.0
                    ),

                    // Adding Last Name Form Field
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        prefixIcon: Visibility(
                          child: Icon(Icons.account_box, color: const Color.fromARGB(255, 213, 213, 213))),
                        hintText: "Last Name",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 168, 168, 168)),
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
                          return 'Please enter a last name'; //requires user enter a value for email
                        }
                        return null; // ensures the form is not inputed if invalid
                      },
                    ),

                    // Adding Whitespace
                    SizedBox(
                      height: 15.0
                    ),

                    // Adding Location Dropdown Button
                    DropdownButtonFormField<String>(
                      value: _selectedLocation,
                      decoration: InputDecoration(
                        prefixIcon: Visibility(
                          child: Icon(Icons.place, color: Color.fromARGB(255, 213, 213, 213)),
                        ),
                        
                        hintText: "Location",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 168, 168, 168)),
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
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please make a selection'; //requires user enter a value for middle name
                        }
                        return null; // ensures the form is not inputed if invalid
                      },
                    ),

                    // Adding Whitespace
                    SizedBox(
                      height: 80.0
                    ),

                    // Adding Email Form Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Visibility(
                          child: Icon(Icons.mail, color: const Color.fromARGB(255, 213, 213, 213)),
                        ),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 168, 168, 168)),
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
                    ),

                    // Adding Whitespace
                    SizedBox(
                      height: 15.0
                    ),

                    // Adding Password Form Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Visibility(
                          child: Icon(Icons.lock, color: const Color.fromARGB(255, 213, 213, 213)),
                        ),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 168, 168, 168)),
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
                    ),

                    // Adding Whitespace
                    SizedBox(
                      height: 15.0
                    ),

                    // Adding Confirm Password Form Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Visibility(
                          child: Icon(Icons.verified_user, color: const Color.fromARGB(255, 213, 213, 213)),
                        ),
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 168, 168, 168)),
                        labelText: "",
                        floatingLabelBehavior: FloatingLabelBehavior.always, 
                        floatingLabelStyle: TextStyle(fontSize: 20),
                        filled: true,
                        fillColor: const Color.fromARGB(45, 255, 255, 255),
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
                    ),

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
                    style: TextStyle(color: Color.fromARGB(180, 56, 62, 70))
                  ),

                  // Adding Whitespace
                  SizedBox(
                    width:1.0
                  ),

                  // Adding 'Login' Button, which redirects to Login Page
                  TextButton(
                    child: Text("Login", 
                      style: TextStyle(
                        color: Color.fromARGB(180, 56, 62, 70),
                        fontWeight: FontWeight.bold)),
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
                onPressed: () async {
                  try {
                      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    await _createUserDocument(userCredential.user!);

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                  } catch (e) {
                    print (e)
                    ; 
                  }
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 77, 175, 255),
                  minimumSize: Size(350, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text("Create Account", style: TextStyle(color: Colors.white)),
              ),

              // Adding Whitespace, Currently set to 0.0, however likely to change based on Firebase Service
              SizedBox(
                height: 0.0
                ),

              ]
            )
          )
        ]
      )
    );
  }
}