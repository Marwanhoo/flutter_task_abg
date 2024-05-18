import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text("Hello"),
          ElevatedButton(onPressed: (){}, child: const Text("Logout"),),
        ],
      ),
    );
  }
}
