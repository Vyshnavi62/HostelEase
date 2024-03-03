// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously
// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hostel_ease/resources/DBmethods.dart';
import 'package:hostel_ease/screens/admin/admin_menu.dart';
import 'package:hostel_ease/widgets/textfiled.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent({
    super.key,
  });

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  TextEditingController studentMail = TextEditingController();
  TextEditingController studentName = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> create() async {
    if (studentName.text.isNotEmpty &&
        studentMail.text.isNotEmpty &&
        department.text.isNotEmpty &&
        password.text.isNotEmpty) {
      String result = await DBmethods().createStudent(
        studentName: studentName.text,
        studentEmail: studentMail.text,
        studentDepartment: department.text,
        password: password.text,
      );

      // Show the student added message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result),
      ));

      // If the student is added successfully, navigate to the admin home screen
      if (result == 'Student Added') {
        Navigator.pushReplacement(
          context,
          // ignore: prefer_const_constructors
          MaterialPageRoute(builder: (context) => Adminmenu()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the fields'),
      ));
    }
  }

  @override
  void dispose() {
    studentMail.dispose();
    studentName.dispose();
    department.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Hostel Ease'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              const Text(
                'Add Student',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInput(hint: 'Student Name', controller: studentName),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInput(hint: 'Student Mail', controller: studentMail),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInput(hint: 'Department', controller: department),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInput(
                  hint: 'Password',
                  controller: password,
                  isPassword: true,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    create();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[900])),
                  child: const Text(
                    'Add Student',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ],
          ),
        ));
  }
}


















/*
import 'package:flutter/material.dart';
import 'package:hostel_ease/resources/DBmethods.dart';
import 'package:hostel_ease/screens/admin/admin_menu.dart';
import 'package:hostel_ease/widgets/textfiled.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent({
    super.key,
  });

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  TextEditingController studentMail = TextEditingController();
  TextEditingController studentName = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController password = TextEditingController();

  /* Future<void> create() async {
    if (studentName.text.isNotEmpty &&
        studentMail.text.isNotEmpty &&
        department.text.isNotEmpty &&
        password.text.isNotEmpty) {
      String result = await DBmethods().createStudent(
        studentName: studentName.text,
        studentEmail: studentMail.text,
        studentDepartment: department.text,
        password: password.text,
      );

      // Show the student added message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result),
      ));

      // If the student is added successfully, navigate to the admin home screen
      if (result == 'Student Added') {
        Navigator.pushReplacement(
          context,
          // ignore: prefer_const_constructors
          MaterialPageRoute(builder: (context) => Adminmenu()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the fields'),
      ));
    }
  }*/

  Future<void> create() async {
    if (studentName.text.isNotEmpty &&
        studentMail.text.isNotEmpty &&
        department.text.isNotEmpty &&
        password.text.isNotEmpty) {
      String result = await DBmethods().createStudent(
        studentName: studentName.text,
        studentEmail: studentMail.text,
        studentDepartment: department.text,
        password: password.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the fields'),
      ));
    }
  }

  @override
  void dispose() {
    studentMail.dispose();
    studentName.dispose();
    department.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Hostel Ease'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Add Student',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 85,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInput(hint: 'Student Name', controller: studentName),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInput(hint: 'Student Mail', controller: studentMail),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInput(hint: 'Department', controller: department),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInput(
                  hint: 'Password',
                  controller: password,
                  isPassword: true,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    create();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[900])),
                  child: const Text(
                    'Add Student',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ],
          ),
        ));
  }
}
*/