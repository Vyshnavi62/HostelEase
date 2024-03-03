import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewStudents extends StatefulWidget {
  final String hid;
  const ViewStudents({super.key,required this.hid});

  @override
  State<ViewStudents> createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Students'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('hostels')
            .where('hId', isEqualTo: 'hid')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return ListTile(
                    title: Text(ds['studentName']),
                    subtitle: Text(ds['studentEmail']),
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
