
import 'package:flutter/material.dart';

class BodyLandscape extends StatelessWidget {
  const BodyLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        elevation: 10,
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text('Please turn to portrait view'),
        ),
      ),
    );
  }
}
