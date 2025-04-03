import 'package:cloud_firestore/cloud_firestore.dart';
// short function used on the progress screen and on the account drop down
// sets the medals to based on the ranks of the firebase accounts
String getMedalString(String pLanguage,DocumentSnapshot user){
  if (pLanguage == "python"){
    if (user["pythonLevel"] > 5 && user["pythonLevel"] <= 10){
      return "p2";
    }
    else if (user["pythonLevel"] > 10){
      return "p3";
    }
    else{
      return "p1";
    }
  }
  else if (pLanguage == "java"){
    if (user["javaLevel"] > 5 && user["javaLevel"] <= 10){
      return "j2";
    }
    else if (user["pythonLevel"] > 10){
      return "j3";
    }
    else{
      return "j1";
    }
  }
  else{
        if (user["c#Level"] > 5 && user["c#Level"] <= 10){
      return "c2";
    }
    else if (user["pythonLevel"] > 10){
      return "c3";
    }
    else{
      return "c1";
    }
  }
}
  