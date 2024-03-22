import 'package:flutter/material.dart';

class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("FLutter Chat") ,
      ),
      body: const Center(
        child: Text("loading"),
      ),
    );
}
}