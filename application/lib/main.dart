import 'package:coder_application/account.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue ),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none)
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
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          const Image(image: AssetImage("assets/images/place_holder.png"),width: 100, height: 100),
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [ 
          Padding(padding: EdgeInsets.all(200)),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Account()));
          } , child: Text("Sign In"),),
          Padding(padding: EdgeInsets.all(10)),
          ElevatedButton(onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context) => const Account()));
          }, child: Text("Create Account")),
          Padding(padding: EdgeInsets.all(30)),
          TextButton(onPressed: null,child: Text("Continue as Guest"))
          ],)
          ]
        )
      )
    );
  }
}
