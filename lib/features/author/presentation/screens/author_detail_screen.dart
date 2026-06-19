import 'package:flutter/material.dart';

class AuthorDetailScreen extends StatelessWidget {
  final String authorId;
  const AuthorDetailScreen({super.key, required this.authorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Author Detail')),
      body: Center(
        child: Text('Author Detail Screen for Author ID: $authorId (Placeholder)'),
      ),
    );
  }
}
