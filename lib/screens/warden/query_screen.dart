import 'package:flutter/material.dart';

class QueryScreen extends StatefulWidget {
  final String title;
  final String studentEmail;
  final String description;
  const QueryScreen(
      {super.key,
      required this.title,
      required this.description,
      required this.studentEmail});

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "Title: ${widget.title}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Query:${widget.description}",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Student Email:${widget.studentEmail}",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
