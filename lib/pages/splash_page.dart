import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../helper/helper_function.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    nextScreen();
  }
void nextScreen()async{
    await getUserLoggedInStatus();
    if(_isSignedIn==false)
      {
        nextScreenReplace(context,const LoginPage());
      }
    else
        {
          nextScreenReplace(context,const HomePage());
        }
}
  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.deepOrangeAccent,
      ),
    );
  }
}
