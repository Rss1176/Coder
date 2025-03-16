import 'package:coder_application/create.dart';
import 'package:coder_application/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'page_animation.dart';
import 'loading_welcome.dart';

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
              Navigator.of(context).push(createPageRoute2(Login()));
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
              Navigator.of(context).push(createPageRoute2(Create()));
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
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        children: [
                          SizedBox(
                            height: 20
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(children: [
                              Text(
                                "Continue without Account?",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 56, 62, 70),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],)
                          ),
                          SizedBox(
                            height:20
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("To use all of CodeRs features as intended, we recommend creating an account"),
                                SizedBox(
                                  height:10
                                  ),
                                Text("But if now isn't the right time, you can continue as a guest"),
                          SizedBox(
                            height:32
                          ),
                          ElevatedButton(
                            onPressed: () {
                            Navigator.of(context).push(createPageRoute2(Create()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 77, 175, 255),
                              minimumSize: Size(350, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Text("Create an Account", style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(
                            height:25
                          ),  
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.of(context).pop('Cancel');
                                },
                                child: const Text('Cancel'),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.of(context).push(createPageRoute2(Loading()));
                                },
                                child: const Text('Continue as Guest'),
                              ),
                          ]),
                          SizedBox(
                            height:20
                          ),
                             ]
                            ),
                          ),
                        ]
                      );
                    }
                );
              },
                            
              child: Text("Continue as Guest",
              style: TextStyle(color: const Color.fromARGB(180, 56, 62, 70)))),
            SizedBox(
              height:2.0),
        ],
      ),
    );
  }
}
