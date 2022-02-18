import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/models/userModels.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login_ui/screens/loginScreen.dart';
import 'package:login_ui/screens/updateScreen.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  User? user = FirebaseAuth.instance.currentUser;

  UserModel userModel = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("userProfile")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.userModel = UserModel.fromMap(value.data());
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: userModel.imageUrl != null
                  ? CircleAvatar(
                      radius: 60,
                      child: CachedNetworkImage(
                        imageUrl: userModel.imageUrl!,
                        fit: BoxFit.fill,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fill),
                          ),
                        ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                          value: downloadProgress.progress,
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          size: 70,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : const CircleAvatar(child: Icon(Icons.person)),
            ),
            Container(
              child: Text(
                '${userModel.name}',
                style: theme.textTheme.bodyText1,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text(
                '${userModel.email}',
                style: theme.textTheme.bodyText1,
              ),
            ),
            Container(
              child: Text(
                '${userModel.gender}',
                style: theme.textTheme.bodyText1,
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await signOutUser();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: ((context) => signInPage())));
                },
                child: Text('sign out')),
            ElevatedButton(
                onPressed: () async {
                  await signOutUser();
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => updatePage())));
                },
                child: Text('Update')),
          ],
        ),
      ),
    );
  }

  signOutUser() {
    auth.signOut();
  }
}
