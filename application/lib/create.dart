import 'package:flutter/material.dart';

void main() {
  runApp(const Create());
}

class Create extends StatelessWidget {
  const Create({super.key});

  @override
  Widget build(BuildContext context) {
    return const CreatePage(title: 'Create Account');
  }
}

class CreatePage extends StatefulWidget {
  const CreatePage({super.key, required this.title});
  final String title;
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              "assets/images/Background Main_Dark Mode_No Scroll.png",
              //can be changed for diff background
              fit:BoxFit.cover
            ),
          )
        ],
      ),
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title),
        leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 20, onPressed: (){Navigator.pop(context);},)
      ),
      );
  }
}