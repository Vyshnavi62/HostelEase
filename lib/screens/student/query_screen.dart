// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_ease/resources/DBmethods.dart';
import 'package:hostel_ease/screens/student/my_queries.dart';
import 'package:hostel_ease/widgets/textfiled.dart';

class QuesryScreenStudent extends StatefulWidget {
  const QuesryScreenStudent({super.key});

  @override
  State<QuesryScreenStudent> createState() => _QuesryScreenStudentState();
}

class _QuesryScreenStudentState extends State<QuesryScreenStudent> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  String hid = '';
  @override
  void initState() {
    super.initState();
    getHid();
  }

  Future<void> getHid() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('students')
          .doc(uid)
          .get();
      setState(() {
        hid = doc['hid']; /**/
      });
    } catch (e, stackTrace) {
      Text('Book a room first');
      // Handle the error gracefully, e.g., set hid to a default value
      setState(() {
        hid =
            'default'; // Replace 'default' with whatever default value you want
      });
    }
  }

  Future<void> upload() async {
    if (title.text.isNotEmpty && description.text.isNotEmpty) {
      String res = await DBmethods()
          .addQuery(query: description.text, hid: hid, title: title.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Fill all fields')));
    }
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: const Text('Raise Query'),
        centerTitle: true,
        backgroundColor: Colors.white,
       
      ),*/
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              "Raise Query",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
            ),
            TextInput(hint: 'Title', controller: title),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            TextInput(
                hint: "Describe your problem here...",
                maxlines: 15,
                controller: description),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await upload();
              },
              child: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(
                    255, 164, 72, 180), // Set the background color to purple
                onPrimary: const Color.fromARGB(
                    255, 241, 241, 241), // Set the text color to light pink
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
