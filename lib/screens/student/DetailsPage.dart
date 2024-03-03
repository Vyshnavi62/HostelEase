import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_ease/resources/DBmethods.dart';

// Import statements

class DetailsPage extends StatelessWidget {
  final String reason;
  final String fromDate;
  final String toDate;
  final String status;

  DetailsPage({
    required this.reason,
    required this.fromDate,
    required this.toDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave-Pass Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Reason: ${reason.toUpperCase()}\n',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                'From Date: $fromDate\n',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
              Text(
                'To Date: $toDate\n',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
              Text(
                'Status: $status\n',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
