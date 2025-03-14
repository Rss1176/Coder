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
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedPronoun;

  // Function to create user document in Firestore
  Future<void> _createUserDocument(User user) async {
    final _firestore = FirebaseFirestore.instance;
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'uid': user.uid,
      });
    } catch (e) {
      print("Error creating user document: $e");
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20.0
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: FloatingActionButton(onPressed: (){
                Navigator.pop(context);
              },
              shape: CircleBorder(
                side: BorderSide(color: const Color.fromARGB(255, 56, 62, 65), width: 1.0)
              ),
              elevation: 0.0,
              backgroundColor: const Color.fromARGB(11, 255, 255, 255),
              child: const Icon(Icons.close, color: Color.fromARGB(255, 56, 62, 65)),
              ),
              )
            ),
          ),
          SizedBox(
            height: 20
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children:[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(  
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              hintText: "",
                              labelText: "First Name",
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
                                return 'Please enter a valid email'; //requires user enter a value for email
                              }
                              return null; // ensures the form is not inputed if invalid
                            },
                          ),
                        ),
                        SizedBox(width: 15.0),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedPronoun,
                            decoration: InputDecoration(
                              hintText: "",
                              labelText: "Pronouns",
                              floatingLabelBehavior: FloatingLabelBehavior.always, 
                              floatingLabelStyle: TextStyle(fontSize: 20),
                              filled: true,
                              fillColor: const Color.fromARGB(11, 225, 225, 225),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            items: [
                              DropdownMenuItem(value: 'He/Him', child: Text('He/Him')),
                              DropdownMenuItem(value: 'She/Her', child: Text('She/Her')),
                              DropdownMenuItem(value: 'They/Them', child: Text('They/Them')),
                              DropdownMenuItem(value: 'Non-Bindary', child: Text('Non-binary')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedPronoun = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid middle name'; //requires user enter a value for middle name
                              }
                              return null; // ensures the form is not inputed if invalid
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        hintText: "",
                        labelText: "Last Name",
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
                    SizedBox(
                      height: 15.0
                    ),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: "",
                        labelText: "Location",
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
                    SizedBox(
                      height: 80.0
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "",
                        labelText: "Email",
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
                    SizedBox(height: 15.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "",
                        labelText: "Password",
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
                    SizedBox(
                      height: 15.0
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "",
                        labelText: "Confirm Password",
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
                          return "please set a password"; //same logic as above
                      }
                      return null;
                      },
                    ),
                    SizedBox(height: 15.0)
                  ],
                ),
              ),

              ElevatedButton(onPressed: () async {
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
              child: Text("Create Account", style: TextStyle(color: Colors.white))),
              SizedBox(
                height: 30
                ),
              TextButton(
                child: Text('Already got an account?'),
                onPressed: (){
                  Navigator.of(context).push(createPageRoute1(Login()));
                },
              ),
            ]
          )
          )
        ]
      )
    );
  }
}