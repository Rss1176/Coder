import 'package:coder_application/create.dart';
import 'package:coder_application/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'page_animation.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 77, 175, 255)),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none)
          ),
        )
      ),
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                "assets/images/Background Main_Dark Mode_No Scroll.png",
                fit: BoxFit.cover,
              ),
            ),
            const HomePage(),
          ],
        ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height:180.0),
          Image(
            image: AssetImage("assets/images/image_welcometo.png"),
            width: 375, 
            height: 50),
          Image(
            image: AssetImage("assets/images/logo_darkmode.png"), 
            width: 375, 
            height: 125),
            SizedBox(height:250.0),
            ElevatedButton(
              onPressed: () {
              Navigator.of(context).push(createPageRoute1(Login()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 77, 175, 255),
                minimumSize: Size(350, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text("Sign in", 
                style: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height:8),
            ElevatedButton(
              onPressed: () {
              Navigator.of(context).push(createPageRoute1(Create()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 77, 175, 255),
                minimumSize: Size(350, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text("Create an Account", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height:25.0),
            TextButton(
              onPressed: null, 
              child: Text("Continue as Guest")),
            SizedBox(
              height:2.0),
        ],
      ),
    );
  }
}
