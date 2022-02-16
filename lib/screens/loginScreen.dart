import 'package:flutter/material.dart';
import 'package:login_ui/screens/signupScreen.dart';

class signInPage extends StatefulWidget {
  const signInPage({Key? key}) : super(key: key);

  @override
  _signInPageState createState() => _signInPageState();
}

class _signInPageState extends State<signInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "FACI",
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      "O",
                      style: TextStyle(fontSize: 25, color: Colors.green),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  width: 400,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Enter Email"),
                      prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  width: 400,
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      focusColor: Colors.lightGreenAccent,
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[300],
                    ),
                    Text("Remember Me"),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => signUpPage()));
                  },
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.green[300]),
                  ),
                )
              ],
            ),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("LOGIN")),
          Container(
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Don't have an account?"),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => signUpPage()));
                  },
                  child: const Text(
                    "Signup here",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
