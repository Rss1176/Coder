import 'package:flutter/material.dart';
import 'page_animation.dart';
import 'main.dart';
import 'splash.dart';


void main() {
  runApp(const Loading());
}

class Loading extends StatelessWidget {
  const Loading({super.key});

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
          LoadingPage(),
        ],
      ),
    );
  }
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPage();
}

class _LoadingPage extends State<LoadingPage>{
  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height:180
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 350,
                      width: 350,
                      child: CircularProgressIndicator(
                        semanticsLabel: "Welcome Back!",
                        valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 77, 175, 255)),
                        backgroundColor: const Color.fromARGB(25, 0, 0, 0),
                        strokeWidth: 6.0,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'LuckiestGuy',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          ),
          SizedBox(
            height: 180
          ),
          ElevatedButton(
              onPressed: () {
              Navigator.of(context).push(createPageRoute1(Home()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 77, 175, 255),
                minimumSize: Size(250, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text("Lets Go!", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(
            height: 20.0
          ),
          TextButton(
                  child: Text("Return to Sign In", 
                  style: TextStyle(
                  color: Color.fromARGB(180, 56, 62, 70))),
                  onPressed: (){
                    Navigator.of(context).push(createPageRoute1(Splash()));
                  },
          )
        ]
      )
    );
  }
}