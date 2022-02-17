import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/models/userModels.dart';
import 'package:cached_network_image/cached_network_image.dart';

class homePage extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("userProfile")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.userModel = UserModel.fromMap(value.data());
    });
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
              child: CachedNetworkImage(
                imageUrl: userModel.imageUrl!,
                fit: BoxFit.fill,
                imageBuilder: (context, imageProvider) => Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image:
                        DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, size: 50),
              ),
            ),
            Text(
              '($userModel.gender)',
              style: theme.textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
