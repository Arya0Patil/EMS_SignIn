import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:login_ui/models/userModels.dart';

class updatePage extends StatefulWidget {
  @override
  _updatePageState createState() => _updatePageState();
}

class _updatePageState extends State<updatePage> {
  final List<String> _genderItem = <String>["Male", "Female"];
  String? _selectedGender;
  bool _isUploaded = false;
  String? imageUrl;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  CollectionReference userRef =
      FirebaseFirestore.instance.collection('userProfile');

  UserModel userModel = UserModel();
  User? user = FirebaseAuth.instance.currentUser;

  String? get selectedGender => _selectedGender;
  set selectedGender(String? item) {
    setState(() {
      _selectedGender = item;
      print(selectedGender);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    FirebaseFirestore.instance
        .collection("userProfile")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.userModel = UserModel.fromMap(value.data());
    });
    super.initState();
    setState(() {
      prevName = userModel.name.toString();
      prevEmail = userModel.email;
      prevGender = userModel.gender;
      prevImgUrl = userModel.imageUrl;
    });
  }

  String? prevName;
  String? prevEmail;
  String? prevGender;
  String? prevImgUrl;

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
                      child: CircleAvatar(
                        radius: 50,
                        child: userModel.imageUrl != null
                            ? CircleAvatar(
                                radius: 60,
                                child: CachedNetworkImage(
                                  imageUrl: userModel.imageUrl!,
                                  fit: BoxFit.fill,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill),
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
                            : const CircleAvatar(child: Icon(Icons.person)),
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    width: 300,
                    child: TextFormField(
                      controller: _nameController,
                      onSaved: (value) {},
                      decoration: InputDecoration(
                        label: Text('${userModel.email}'),
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
                        // label: Text("Enter number"),

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

                  ElevatedButton(
                      onPressed: () {
                        updateUser(_nameController.text.toString(),
                            _emailController.text.toString());
                      },
                      child: Text('Update'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateUser(name, email) {
    return userRef.doc(userModel.userId).update({
      'name': _nameController.text.isEmpty ? prevName : name,
      'email': _emailController.text.isEmpty ? '${userModel.email}' : email,
      'gender': selectedGender == null ? '${userModel.gender}' : selectedGender,
      'imageUrl': imageUrl
    }).then((value) => Fluttertoast.showToast(msg: 'updated successfully'));
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
