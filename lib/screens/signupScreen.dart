import 'package:flutter/material.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({Key? key}) : super(key: key);

  @override
  _signUpPageState createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final List<String> _genderItem = <String>["Male", "Female"];
  String? _selectedGender;

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // UserImage(context)
          CircleAvatar(
            radius: 50,
            child: InkWell(onTap: () {}, child: Icon(Icons.camera_alt_rounded)),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            width: 400,
            child: TextFormField(
              decoration: const InputDecoration(
                label: Text("Enter Name"),
                prefixIcon: Icon(Icons.person),
              ),
            ),
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
              width: 400,
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
            width: 400,
            child: TextFormField(
              decoration: const InputDecoration(
                label: Text("Enter password"),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container UserImage(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        child: Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: theme.primaryColor,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(60),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.accentColor.withOpacity(0.5)),
              child: Icon(Icons.camera_alt_rounded),
            ),
          ),
        ],
      ),
    ));
  }
}
