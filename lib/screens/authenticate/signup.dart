import 'package:firebase_app/screens/authenticate/user.dart';
import 'package:firebase_app/screens/home/home.dart';
import 'package:firebase_app/screens/loading.dart';
import 'package:firebase_app/utils/auth.dart';
import 'package:firebase_app/utils/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Signup extends StatefulWidget {
  Signup({super.key, required this.toggleView});
  void Function() toggleView;

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email = "";
  String password = "";
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();
  FirestoreServices _firestoreServices = FirestoreServices();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue[500],
              title: Text("Sign Up"),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  label: Text("Sign in"),
                  icon: Icon(Icons.person),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _globalKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text("Email"),
                      ),
                      validator: (value) => (value ?? "").isEmpty
                          ? " Email id cannot be empty"
                          : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: Text("Password"),
                      ),
                      validator: (value) => (value ?? "").length < 6
                          ? "Password must contain min 6 char"
                          : null,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if ((_globalKey.currentState?.validate()) ?? false) {
                            setState(() => isLoading = true);
                            final user =
                                await _authService.signUpWithEmailAndPass(
                                    email: email, password: password);
                            setState(() => isLoading = false);
                          }
                        },
                        child: Text("Sign up")),
                    ElevatedButton(
                        onPressed: () async {
                          setState(() => isLoading = true);
                          final user = await _authService.signInWithGoogle();
                          print(user!.user!.uid);
                          final userStore =
                              await _firestoreServices.getUser(user!.user!.uid);
                          setState(() => isLoading = false);
                          print(userStore);
                          if (userStore?.exists ?? false) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Userdetails(isUser: false),
                              ),
                            );
                          }
                        },
                        child: Text("Sign in with google")),
                        ElevatedButton(
                        onPressed: () async {
                            setState(() => isLoading = true);
                            final user =
                                await _authService.signinwithGithub();
                            setState(() => isLoading = false);
                          },
                        child: Text("Sign in with Github")),
                  ],
                ),
              ),
            ),
          );
  }
}
