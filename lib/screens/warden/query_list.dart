import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:hostel_ease/screens/warden/query_screen.dart';

class QueryList extends StatefulWidget {
  const QueryList({super.key});

  @override
  State<QueryList> createState() => _QueryListState();
}

class _QueryListState extends State<QueryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Queries'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('queries').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No Query'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QueryScreen(
                                        title: snapshot.data!.docs[index]
                                            .get('title'),
                                        description: snapshot.data!.docs[index]
                                            .get('query'),
                                        studentEmail: snapshot.data!.docs[index]
                                            .get('student email'),
                                      )));
                        },
                        title: Text(
                          "${snapshot.data!.docs[index].get('title')}\n",
                          style: const TextStyle(color: Colors.white),
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
        },
      ),
    );
  }
}
