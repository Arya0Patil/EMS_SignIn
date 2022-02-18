import 'dart:io';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:login_ui/models/userModels.dart';
import 'homeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({Key? key}) : super(key: key);

  @override
  _signUpPageState createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  final List<String> _genderItem = <String>["Male", "Female"];
  String? _selectedGender;

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _isUploaded = false;
  String? imageUrl;
  String? errorMessage;

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  hidePassword() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  String? get selectedGender => _selectedGender;
  set selectedGender(String? item) {
    setState(() {
      _selectedGender = item;
      print(selectedGender);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // UserImage(context)
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    splashColor: Color.fromARGB(200, 255, 193, 7),
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      showUserImageFilePicker(FileType.image);
                    },
                    child: CircleAvatar(
                      backgroundColor: Color.fromARGB(143, 204, 220, 57),
                      radius: 50,
                      child: _isUploaded
                          ? CircleAvatar(
                              radius: 60,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl!,
                                fit: BoxFit.fill,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  size: 70,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : const CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.camera_alt_rounded,
                              )),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    width: 300,
                    child: TextFormField(
                      controller: _nameController,
                      onSaved: (value) {},
                      decoration: const InputDecoration(
                        label: Text("Enter Name"),
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                      ),
                    ),
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
                      keyboardType: TextInputType.number,
                      controller: _numberController,
                      decoration: const InputDecoration(
                        label: Text("Enter number"),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                  ),
                  Container(
                      width: 300,
                      child: DropdownButton(
                          isExpanded: true,
                          onChanged: (dynamic value) => selectedGender = value,
                          items: _genderItem
                              .map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e),
                                      ))
                              .toList(),
                          value: selectedGender,
                          hint: Text('Select Gender'))),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    width: 300,
                    child: TextFormField(
                      controller: _passwordController,
                      validator: ((value) {
                        if (value == null) {
                          return "check";
                        }
                      }),
                      decoration: InputDecoration(
                        label: Text("Enter password"),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(_obscureText1
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    width: 300,
                    child: TextFormField(
                      controller: _confirmController,
                      obscureText: _obscureText1,
                      decoration: InputDecoration(
                        label: Text("Confirm password"),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            hidePassword();
                          },
                          icon: Icon(_obscureText1
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                    ),
                  ),

                  ElevatedButton(
                      onPressed: () {
                        signUpUser();
                        Get.to(() => homePage());
                      },
                      child: Text('Sign Up'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  toFirestore() async {
    FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;
    User? user = firebaseAuth.currentUser;

    UserModel userModel = UserModel();
    userModel.name = _nameController.text;
    userModel.email = _emailController.text;
    userModel.userId = user!.uid;
    userModel.gender = _selectedGender;
    userModel.imageUrl = imageUrl;
    userModel.number = _numberController.text;

    firebasefirestore
        .collection("userProfile")
        .doc(user.uid)
        .set(userModel.toMap());
  }

  void signUpUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await firebaseAuth
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
            .then((value) => {toFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Email is invalid";
            break;

          case "wrong-password":
            errorMessage = "Password is Wrong";
            break;

          case "user-not-found":
            errorMessage = "User does not exist";
            break;

          default:
            errorMessage = "Undefined error";
        }

        Fluttertoast.showToast(msg: errorMessage!);
      }
    }
  }

  showUserImageFilePicker(FileType filetype) async {
    final picker = ImagePicker();
    File _imageFile;
    final pickFile = await picker.getImage(source: ImageSource.gallery);
    _imageFile = File(pickFile!.path);
    UploadTask uploadTask = firebaseStorage
        .ref('userProfileImage')
        .child(DateTime.now().toString())
        .putFile(_imageFile);
    var pictureUrl = await (await uploadTask).ref.getDownloadURL();
    setState(() {
      imageUrl = pictureUrl.toString();
    });
    print("uploaded $imageUrl");
    setState(() {
      _isUploaded = !_isUploaded;
    });
  }
}
