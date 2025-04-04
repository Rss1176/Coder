import 'package:flutter/material.dart';

String convertStringForC(pLanguage){
  // bandaid fix for poor planning, the image asset is "Csharp", but we want the string to read C#
  // function creates a seperate variable to make this easy
  // full file is this one function
  String formattedString;
  if (pLanguage == "CSharp"){ 
    formattedString = "C#";
    // save a variable with 2 versions of c#, saved in firebase as c# but images cannot be called this, therefore 2 differnt string variables are needed
  }
  else{
    formattedString = pLanguage;
  }
  return formattedString;
}

Future<void>showRankDialog(BuildContext context, String pLanguage, num pRank, pDescription){
  // create a dialog of user aptitude with each language
  String lowerCaseLanguage = pLanguage.toLowerCase();
  String formattedString = convertStringForC(pLanguage);
  return showDialog(
    context: context,
    useSafeArea: false,
    builder: (context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
    ),
    children: [
      
      // adding padding round full dialog
      Padding(
        padding: const EdgeInsets.all(15),
        child:Column(
          children: [
            
            //show the image based on the language seleceted
            Image(
              image: AssetImage("assets/images/$lowerCaseLanguage-logo.png"),
              width: 50.0,
              height: 50.0,
            ),

            // adding white space
            SizedBox(
              height: 10
            ),

            // row to show the proficiency level for the language
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text("$formattedString Profficiency",
                  style: TextStyle(
                    color: Color.fromARGB(255, 56, 62, 70),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // button to get out of the dialog box
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  mini: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: const Color.fromARGB(255, 56, 62, 65), 
                      width: 1.0
                    )
                  ),
                  elevation: 0.0,
                  backgroundColor: const Color.fromARGB(11, 255, 255, 255),
                  child: Icon(
                    Icons.close, 
                    color: Color.fromARGB(255, 56, 62, 65)
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20
            ),

            Text("Here you can find an overview of your current $pLanguage progress!",
              style: TextStyle(
                color: Color.fromARGB(255, 56, 62, 70),
                fontSize: 15,
              ),
            ),
            
            SizedBox(
              height: 20
            ),

            Text(pDescription == "Expert" ? "You are already an expert!" : "",   // if statement to show only if expert
            style: TextStyle(fontSize: 15)), 
            Text(pDescription == "Expert" ? "You have completed $pRank questions!"  : "",   // if statement to show only if expert
            style: TextStyle(fontSize: 15)),
            Text(pDescription != "Expert" ? "$pRank questions till next rank!" : "",   // if statement to show only if intermediate or beginner rank
            style: TextStyle(fontSize: 15)),
            

            SizedBox(
              height: 20
            ),

            Text(
              "Keep coding to improve your proficiency!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 56, 62, 70),
              ),
            ),

          ],
        )
      ),

      SizedBox(
        height: 20
      ),
    ]
  );
}
);
}