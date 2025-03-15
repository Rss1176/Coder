import 'package:coder_application/create.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'page_animation.dart';


void main() {
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({super.key});

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
            LoginPage(),
          ],
        ),
      );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
  Widget build(BuildContext context){
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
                "Let's Sign you in.",
                style: TextStyle(
                  color: Color.fromARGB(255, 56, 62, 70),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FloatingActionButton(
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
            ],
          ),
        ),
          SizedBox(
            height:50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
             child: Column(
              children: [
                Form(
                key: _formKey, 
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "",
                          labelText: "Email or Username",
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
                            return 'Please enter a valid email';// tells user that their inputed value is not a valid email
                            }
                              return null;  // ensures that the form is not valid as the email is wrong
                        },
                      ),
                      SizedBox(
                        height: 15.0
                        ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: " ",
                          labelText: "Password",
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
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height:380.0
                ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:[
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("Don't have an account?",
                  style: TextStyle(color: Color.fromARGB(180, 56, 62, 70))),
                SizedBox(
                  width:1.0
                  ),
                TextButton(
                  child: Text("Register", 
                  style: TextStyle(
                  color: Color.fromARGB(180, 56, 62, 70),
                  fontWeight: FontWeight.bold)),
                  onPressed: (){
                    Navigator.of(context).push(createPageRoute1(Create()));
                  },
                )
                ]
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try{ // Try to sign in
                      await _auth.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      final userDoc = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
                      if (!userDoc.exists){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Create()));
                      } else {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                      }
                    } on FirebaseAuthException catch (e) { // catches the error for incorrect sign in
                      String errorMessage = "";

                      if (e.code == 'user-not-found'){
                        errorMessage = "Incorrect Email.";
                      } else if (e.code == 'wrong-password'){
                        errorMessage = "Incorrect Password";
                      } else if (e.code == 'invalid-email'){
                        errorMessage = "Invalid Email";
                      } else if (e.code == 'too-many-requests'){
                        errorMessage = "too many sign in attempts";
                      }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                    print(errorMessage);

                    } catch(e){ // catches all other errors to prevent crashes (this also catches firebase not being initialised - dont ask me why i know)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${e.toString()}")));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    backgroundColor: const Color.fromARGB(255, 77, 175, 255),
                    minimumSize: Size(350, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: Text("Sign in", style: TextStyle(color: Colors.white))),
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