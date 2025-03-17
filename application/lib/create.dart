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
  String? _selectedPronoun;
  String? _selectedLocation;

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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,        
        children: <Widget>[
          SizedBox(
            height:80.0),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Let's Get Started.",
                style: TextStyle(
                  color: Color.fromARGB(255, 56, 62, 70),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 40,
                width: 40,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: const Color.fromARGB(255, 56, 62, 65), width: 1.0)
                ),
                elevation: 0.0,
                backgroundColor: const Color.fromARGB(11, 255, 255, 255),
                child: const Icon(Icons.close, color: Color.fromARGB(255, 56, 62, 65)),
              ),
              ),
            ],
          ),
        ),
          SizedBox(
            height: 50
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
                        SizedBox(width: 15.0),
                        Expanded(
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
                            items: [
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
                    SizedBox(
                      height: 15.0
                    ),
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
                    SizedBox(
                      height: 15.0
                    ),
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
                    SizedBox(
                      height: 80.0
                    ),
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
                    SizedBox(height: 15.0),
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
                    SizedBox(
                      height: 15.0
                    ),
                    TextFormField(
                      controller: _passwordController,
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
                          return "please set a password"; //same logic as above
                      }
                      return null;
                      },
                    ),
                    SizedBox(height: 30.0)
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("Already have an account?",
                  style: TextStyle(color: Color.fromARGB(180, 56, 62, 70))),
                SizedBox(
                  width:1.0
                  ),
                TextButton(
                  child: Text("Login", 
                  style: TextStyle(
                  color: Color.fromARGB(180, 56, 62, 70),
                  fontWeight: FontWeight.bold)),
                  onPressed: (){
                    Navigator.of(context).push(createPageRoute2(Login()));
                  },
                )
                ]
                ),
              SizedBox(height: 20),
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
                height: 0
                ),
              ]
            )
          )
        ]
      )
    );
  }
}