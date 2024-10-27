import 'package:firebase_app/screens/loading.dart';
import 'package:firebase_app/utils/auth.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  Signin({super.key, required this.toggleView});
  void Function() toggleView;
  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
//   final AuthService _authService = AuthService();
// bool isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     return  isLoading? Loading() : Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue[500],
//           title: Text("Sign in"),
//         ),
//         body: Container(
//           alignment: Alignment.center,
//           child: ElevatedButton(
//               onPressed: () async {
//                 setState(() => isLoading = true);
//                 final user = await _authService.signInAnonymus();
//                 setState(()=> isLoading =false);
//                 print(user);
//               },
//               child: Text("Sign in")),
//         ));
//   }
// }
 String email = "";
  String password = "";
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue[500],
              title: Text("Sign In"),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  label: Text("Sign up"),
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
                        child: Text("Sign In"))
                  ],
                ),
              ),
            ));
  }
}
