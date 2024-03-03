// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_ease/resources/DBmethods.dart';
import 'package:hostel_ease/screens/student/DetailsPage.dart';

class ViewLeavePass extends StatefulWidget {
  const ViewLeavePass({super.key});

  @override
  State<ViewLeavePass> createState() => _ViewLeavePassState();
}

class _ViewLeavePassState extends State<ViewLeavePass> {
  List<String> list = [];
  @override
  void initState() {
    getlid();
    super.initState();
  }

  void getlid() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('students').doc(uid).get();
    try {
      List<dynamic> list1 = doc.get('history leave pass');

      /**/

      for (int i = 0; i < list1.length; i++) {
        list.add(list1[i].toString());
      }
    } catch (e, stackTrace) {
      print('No Out Pass');
    }
    setState(() {
      list = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    Color choose(String status) {
      if (status == 'accepted') {
        color = Colors.green;
      } else if (status == 'rejected') {
        color = Colors.red;
      } else {
        color = Color.fromARGB(255, 138, 125, 5);
      }
      return color;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Out Pass'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleTextStyle: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: list.isNotEmpty
            ? ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var doc = DBmethods().getLeavePassdetails(lid: list[index]);
                  return FutureBuilder(
                    future: doc,
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: choose(snapshot.data["status"]),
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              title: Text(
                                "${"Reason: " + snapshot.data['reason']}\n",
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "${"From Date: ${snapshot.data['from date'].toString()}"}\n"
                                "${"To Date: ${snapshot.data['to date'].toString()}"}\n"
                                "status:  ${snapshot.data['status']}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsPage(
                                        reason: snapshot.data['reason'],
                                        fromDate: snapshot.data['from date']
                                            .toString(),
                                        toDate:
                                            snapshot.data['to date'].toString(),
                                        status: snapshot.data['status'],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'View',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                })
            : const Center(
                child: Text(
                  'No Out Pass',
                  style: TextStyle(fontSize: 20),
                ),
              ));
  }
}
