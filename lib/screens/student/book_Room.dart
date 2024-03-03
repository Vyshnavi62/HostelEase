// ignore_for_file: avoid_print, sort_child_properties_last, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:hostel_ease/screens/student/selectRoom.dart';

class BookRoomScreen extends StatefulWidget {
  const BookRoomScreen({super.key});

  @override
  State<BookRoomScreen> createState() => _BookRoomScreenState();
}

class _BookRoomScreenState extends State<BookRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Choose Hostel'),
          centerTitle: true,
          titleTextStyle: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: Center(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('hostels')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 13, 158, 161),
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  title: Text(
                                    "${"Hostel Name: " + snapshot.data!.docs[index]['name']}\n",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  // subtitle: Text(
                                  //   "${"Warden:" + snapshot.data!.docs[index]['warden name']}\n",
                                  //   style: const TextStyle(color: Colors.white),
                                  // ),
                                  trailing: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChooseRoom(
                                                    rooms: snapshot
                                                            .data!.docs[index]
                                                        ['available rooms'],
                                                    hid: snapshot.data!
                                                        .docs[index]['hId'],
                                                    name: snapshot.data!
                                                        .docs[index]['name'],
                                                  )));
                                    },
                                    child: const Text(
                                      'select',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })));
  }
}
