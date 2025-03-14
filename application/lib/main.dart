import 'package:coder_application/create.dart';
import 'package:coder_application/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'page_animation.dart';

void main() {
  runApp(const Login());
}

class Home extends StatelessWidget {
  const Home({super.key});

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
            HomePage(),
          ],
        ),
      );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  @override
  Widget build(BuildContext context){
    return Center(

    );
  }
}
