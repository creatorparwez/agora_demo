import 'package:flutter/material.dart';

class AgoraHomeScreen extends StatelessWidget {
  const AgoraHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF132440),
        centerTitle: true,
      ),
    );
  }
}
