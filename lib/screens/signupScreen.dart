import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({Key? key}) : super(key: key);

  @override
  _signUpPageState createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final List<String> _genderItem = <String>["Male", "Female"];
  String? _selectedGender;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  String? imageUrl;

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // UserImage(context)
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  splashColor: Colors.amber,
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    showUserImageFilePicker(FileType.image);
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(143, 204, 220, 57),
                    radius: 50,
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 35,
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  width: 300,
                  child: TextFormField(
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
                    decoration: const InputDecoration(
                      label: Text("Enter Email"),
                      prefixIcon: Icon(Icons.mail),
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
                    decoration: const InputDecoration(
                      label: Text("Enter password"),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  width: 300,
                  child: TextFormField(
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

                ElevatedButton(onPressed: () {}, child: Text('Sign Up'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  showUserImageFilePicker(FileType filetype) async {
    final picker = ImagePicker();
    File _imageFile;
    final pickFile = await picker.getImage(source: ImageSource.gallery);
    _imageFile = File(pickFile!.path);
    UploadTask uploadTask =
        firebaseStorage.ref('userProfileImage').putFile(_imageFile);
    var pictureUrl = await (await uploadTask).ref.getDownloadURL();
    setState(() {
      imageUrl = pictureUrl.toString();
    });
    print("uploaded $imageUrl");
  }
}
