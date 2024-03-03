// ignore_for_file: file_names, use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:hostel_ease/screens/student/student_menu.dart';

class ChooseRoom extends StatefulWidget {
  final List<dynamic> rooms;

  final String hid;

  final String name;

  const ChooseRoom(
      {super.key, required this.rooms, required this.hid, required this.name});

  @override
  State<ChooseRoom> createState() => _ChooseRoomState();
}

class _ChooseRoomState extends State<ChooseRoom> {
  @override
  void initState() {
    super.initState();

    print(widget.rooms.length);

    print(widget.rooms.isEmpty);
  }

  _confirmBook(
    String room,
    String floor,
    String name,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Confirm Booking'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(10),
                child: const Text(''),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(15),
                child: RichText(
                    text: TextSpan(
                  text: 'Room No: ',
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  children: [
                    TextSpan(
                      text: room,
                      style: const TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    const TextSpan(
                      text: '\nFloor No: ',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    TextSpan(
                      text: floor,
                      style: const TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    const TextSpan(
                      text: '\nHostel Name: ',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    TextSpan(
                      text: name,
                      style: const TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    const TextSpan(
                      text: '\nPayment:',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    TextSpan(
                      text: 'Rs. 5000',
                      style: const TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  ],
                )),
                onPressed: () async {},
              ),
              Row(
                children: [
                  const Spacer(),
                  SimpleDialogOption(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      }),
                  SimpleDialogOption(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Pay & Confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      /* onPressed: () async {
                        await bookRoom();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Payment successful and Room Booked')));
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Studentmenu()));
                      }),*/

                      onPressed: () async {
                        // Store the context in a variable

                        BuildContext scaffoldContext = context;

                        await bookRoom(room, floor, name);

                        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Payment successful and Room Booked')),
                        );

                        Navigator.of(scaffoldContext).pop();

                        Navigator.push(
                          scaffoldContext,
                          MaterialPageRoute(
                              builder: (context) => const Studentmenu()),
                        );
                      }),
                  const Spacer(),
                ],
              ),
            ],
          );
        });
  }

  Future<void> bookRoom(String room, String floor, String name) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('hostels').doc(widget.hid).update({
      'available rooms': FieldValue.arrayRemove([room]),
    });

    await firestore
        .collection('students')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'room no': room,
      'hid': widget.hid,
      'floor no': floor,
    });

    await firestore.collection('hostels').doc(widget.hid).update({
      'student count': FieldValue.increment(1),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Room')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.rooms.isNotEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        kBottomNavigationBarHeight,
                    child: ListView.builder(
                      itemCount: widget.rooms.length,
                      shrinkWrap: true,
                      physics:
                          AlwaysScrollableScrollPhysics(), // Make it scrollable
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: const Text('Room No:'),
                              subtitle: Text(widget.rooms[index]),
                              trailing: Text('Floor:${widget.rooms[index][0]}'),
                              onTap: () {
                                _confirmBook(widget.rooms[index],
                                    widget.rooms[index][0], widget.name);
                              },
                            ),
                            Divider(), // Inserting a horizontal line (Divider)
                          ],
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2 - 100),
                    child: const Center(
                      child: Text(
                        'No Rooms Available',
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
