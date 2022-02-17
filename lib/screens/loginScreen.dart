import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/screens/signupScreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class signInPage extends StatefulWidget {
  const signInPage({Key? key}) : super(key: key);

  @override
  _signInPageState createState() => _signInPageState();
}

class _signInPageState extends State<signInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
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
                  width: 300,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text("Enter Email"),
                      prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  width: 300,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return "incorrect format";
                      }
                    },
                    controller: _passwordController,
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
            width: 300,
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
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            width: 300,
            child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    register();
                  }
                },
                child: const Text("LOGIN")),
          ),
          Container(
            width: 300,
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

  void register() async {
    final UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
  }
}
