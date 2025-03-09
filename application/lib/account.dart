import 'package:flutter/material.dart';

void main() {
  runApp(const Account());
}

class Account extends StatelessWidget {
  const Account({super.key});

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
            const LoginPage(),
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
  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height:20.0),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: CircleBorder(
                    side: BorderSide(color: const Color.fromARGB(255, 56, 62, 65), width: 1.0),
                  ),
                  elevation: 0.0,
                  backgroundColor: const Color.fromARGB(45, 255, 255, 255),
                  child: const Icon(Icons.close, color: Color.fromARGB(255, 56, 62, 65)))))),
          SizedBox(
            height:20),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: " ",
                labelText: "Username or Email",
                filled: true,
                fillColor: const Color.fromARGB(45, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0))))),
          SizedBox(height: 15.0),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: " ",
                labelText: "Password",
                filled: true,
                fillColor: const Color.fromARGB(45, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0))))),
          SizedBox(height:15.0),
          ElevatedButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const Create()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 77, 175, 255),
                minimumSize: Size(350, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: Text("Sign in", style: TextStyle(color: Colors.white))),
          SizedBox(
            height:300.0),
        ],
      ),
    );
  }
}
