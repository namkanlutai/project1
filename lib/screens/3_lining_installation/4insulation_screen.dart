import 'package:flutter/material.dart';

class insulationscreen extends StatefulWidget {
  const insulationscreen({super.key});

  @override
  State<insulationscreen> createState() => _insulationscreenState();
}

class _insulationscreenState extends State<insulationscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('insulations'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(),
    );
  }
}
