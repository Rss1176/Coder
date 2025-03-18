import 'package:coder_application/create.dart';
import 'package:flutter/material.dart';
import 'page_animation.dart';
import 'account_page.dart';
import 'my_progress.dart';


void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 77, 175, 255)),
      useMaterial3: true,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), 
            side: BorderSide.none
          )
        )
      )
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Background Main_Dark Mode_No Scroll.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 135),
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 77, 175, 255),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(81, 255, 255, 255),
                    ),
                  ),
                  SizedBox(
                    height:10
                    ),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 77, 175, 255),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(81, 255, 255, 255),
                    ),
                  ),
                  SizedBox(
                    height:10
                    ),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 77, 175, 255),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(81, 255, 255, 255),
                    ),
                  ),
                  SizedBox(
                    height:10
                  ),
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 77, 175, 255),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(81, 255, 255, 255),
                    ),
                  ),
                  SizedBox(
                    height:10
                  ),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 77, 175, 255),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(81, 255, 255, 255),
                    ),
                  ),
                  Container(
                    height: 150,
                  ),
                ],
              ),
            )
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 77, 175, 255),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "My Dashboard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'LuckiestGuy',
                    ),
                  ),
                  SizedBox(width: 110),
                  IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      size: 35,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showMyAccountDialog(context);
                    },
                  ),
            ],
            ),
            )
          ),
          Positioned(
            bottom: 50,
            left: 60,
            right: 60,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 77, 175, 255),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(createPageRoute3(Home()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.timeline, color: const Color.fromARGB(75, 255, 255, 255)),
                    onPressed: () {
                      Navigator.of(context).push(createPageRoute3(Progress()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.leaderboard, color: Color.fromARGB(75, 255, 255, 255)),
                    onPressed: () {
                      //Navigator.of(context).push(createPageRoute3(Leaderboard()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Color.fromARGB(75, 255, 255, 255)),
                    onPressed: () {
                      //Navigator.of(context).push(createPageRoute3(Settings()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

