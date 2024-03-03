import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyQueries extends StatefulWidget {
  const MyQueries({super.key});

  @override
  State<MyQueries> createState() => _MyQueriesState();
}

class _MyQueriesState extends State<MyQueries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Queries'),
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('queries')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data!.docs[index]['title']),
                        subtitle: Text(snapshot.data!.docs[index]['query']),
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
