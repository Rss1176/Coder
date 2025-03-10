import 'package:coder_application/account.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                "assets/images/Background Main_Dark Mode_No Scroll.png",
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
              backgroundColor: const Color.fromARGB(45, 255, 255, 255),
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
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        labelText: "Email",
                        filled: true,
                        fillColor: const Color.fromARGB(45, 225, 225, 225),
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
                        hintText: "Set Password",
                        labelText: "Password",
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
                    await _auth.createUserWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Account()));
                } catch (e) {
                  print (e); 
                }
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 77, 175, 255),
                minimumSize: Size(350, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: Text("Create Account", style: TextStyle(color: Colors.white))),
              SizedBox(height: 300),
            ]
          )
          )
        ]

      )
    );
  }
}