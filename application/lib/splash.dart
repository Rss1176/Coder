import 'package:coder_application/create.dart';
import 'package:coder_application/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'page_animation.dart';
import 'continue_as_guest.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(Splash());
} 

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: true,
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
      // Adding Page Background Image
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                "assets/images/background_simple.png",
                fit: BoxFit.cover,
              ),
            ),
            const SplashScreen(),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>{
  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          // Adding Whitespace
          SizedBox(
            height:180.0
          ),

          // Adding 'Welcome to' Image
          Semantics (label: "Welcome to image",
          image: true,
          child: Image(
            image: AssetImage("assets/images/image_welcometo.png"),
            width: 375.0, 
            height: 50.0,
          )),
          
          // Adding 'Coder' Image
          Image(
            image: AssetImage("assets/images/logo_darkmode.png"), 
            width: 375.0, 
            height: 125.0,
          ),
          
          // Adding Whitespace
          SizedBox(
            height:250.0
          ),

          // Adding 'Sign in' Button
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(createPageRoute2(Login()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 85, 155),
              minimumSize: Size(350, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Semantics(child: Text("Sign in", 
              style: TextStyle(
                color: Colors.white,
              ),
            ),),
          ),

          // Adding Whitespace
          SizedBox(
            height:8.0
          ),

          // Adding 'Create an Account' Button
          ElevatedButton(
            onPressed: () {
            Navigator.of(context).push(createPageRoute2(Create()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 85, 155),
              minimumSize: Size(350, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

            ),
            child: Semantics(child: Text("Create an Account", 
              style: TextStyle(
                color: Colors.white,
              ),
            ),)
          ),

          // Adding Whitespace
          SizedBox(
            height:25.0
          ),

          // Adding 'Continue as Guest' Button, which opens a pop-up menu
          TextButton(
            child: Semantics(
            button: true,
            child: Text("Continue as Guest",
              style: TextStyle(
                color: const Color.fromARGB(255, 208, 208, 208),
              ),
            ),),
            onPressed: (){
              guestContinueDialog(context, false);
            },             
          ),

          // Adding Whitespace
          SizedBox(
            height:20.0
          ),
          
        ],
      ),
    );
  }
}
