import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String username= "";
String password = "";
final log = Logger(printer: PrettyPrinter(),);
void setUsername(String s) {
  username = s;

}
void setPassword(String s) {
  password = s;

}
class Body extends StatelessWidget {

  const Body({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                setUsername(value);
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                  setPassword(value);
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                  signIn(username, password);
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                sign_out();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
void signIn(String username, String password) async {
  try {
    Firebase.initializeApp();
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: username, password: password);
    log.v("signed in");


  }

  on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      log.e('No user found for that email.');


    } else if (e.code == 'wrong-password') {
      //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageApp(),),);
      log.e('Wrong password provided for that user.');

    }
    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageApp(),),);
  }
}
void sign_out() async {
  try {
    await FirebaseAuth.instance.signOut();
    log.v("signed out");
  }
  catch (e) {
    log.e("sign out error");
    print(e);
  }
}