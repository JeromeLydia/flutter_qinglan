import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: Stack(
        children: const [Text("data")],
      ),
    );
  }
}
