
import 'package:firebase_app/screens/home/home.dart';
import 'package:firebase_app/utils/auth.dart';
import 'package:firebase_app/utils/firestore.dart';
import 'package:firebase_app/utils/models/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Userdetails extends StatefulWidget {
  bool isUser;
   Userdetails({super.key, required this.isUser});

  @override
  State<Userdetails> createState() => _UserdetailsState();
}

class _UserdetailsState extends State<Userdetails> {
  final _authService = AuthService();
  final _firestoreServices = FirestoreServices();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _usernameController.text = user.displayName ?? "";
      _firstNameController.text = user.displayName?.split(" ").first ?? "";
      _lastNameController.text = user.displayName?.split(" ").last ?? "";
      _emailController.text = user.email ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Text("Contact Info"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.cancel),
          ),
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Center(
                child: user?.photoURL != null
                    ? Container(
                        margin: EdgeInsets.all(5),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Image.network(user!.photoURL!),
                      )
                    : SizedBox(),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "User Name",
                          hintText: user?.displayName ?? "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: "First Name",
                          hintText: user?.displayName?.split(" ").first ?? "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          hintText: user?.displayName?.split(" ").last ?? "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: user?.email ?? "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          hintText: "Enter your phone number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          if (_usernameController.text.isNotEmpty) {
                            await _firestoreServices.writeuser(Usermodel(
                              userid: user!.uid,
                                username: _usernameController.text,
                                email: _emailController.text,
                                firstname: _firstNameController.text,
                                lastname: _lastNameController.text,
                                phonenumber: _phoneController.text));
                            // _firstNameController.text = "";
                            // _phoneController.text = "";
                            // _usernameController.text = "";
                            // _lastNameController.text = "";
                            // _emailController.text = "";
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue[100],
                        ),
                        child: Text("Save"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
