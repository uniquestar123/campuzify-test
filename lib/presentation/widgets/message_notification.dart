import 'package:flutter/material.dart';

class MessageNotification extends StatelessWidget {
  const MessageNotification(this.title, this.body, {required this.onReplay});

  final VoidCallback onReplay;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        child: ListTile(
          title: Text(title),
          subtitle: Text(body),
          trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              onReplay();
            },
          ),
        ),
      ),
    );
  }
}
