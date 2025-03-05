import 'package:flutter/material.dart';

void main() {
  runApp(const Account());
}

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccountPage(title: 'Login');
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.title});
  final String title;
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
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