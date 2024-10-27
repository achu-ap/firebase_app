import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpinKitRotatingPlain(
        color: Colors.red,
        size: 50.0,
      ),
    );
  }
}
