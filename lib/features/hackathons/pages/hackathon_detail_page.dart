import 'package:flutter/material.dart';

class HackathonDetailPage extends StatelessWidget {
  final String hackathonId;

  const HackathonDetailPage({
    super.key,
    required this.hackathonId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hackathon Detail: $hackathonId'),
      ),
      body: Center(
        child: Text('Hackathon Detail for ID: $hackathonId - Coming Soon'),
      ),
    );
  }
}
