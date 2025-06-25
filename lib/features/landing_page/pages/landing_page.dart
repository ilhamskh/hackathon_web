import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final String hackathonId;

  const LandingPage({
    super.key,
    required this.hackathonId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hackathon Landing Page: $hackathonId'),
      ),
      body: Center(
        child: Text('Landing Page for Hackathon ID: $hackathonId - Coming Soon'),
      ),
    );
  }
}
