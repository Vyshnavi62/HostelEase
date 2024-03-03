import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('hostels')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            return Column(
              children: [
                const Spacer(),
                const Text("Warden Details"),
                const SizedBox(
                  height: 20,
                ),
                const Text("Name"),
                const SizedBox(
                  height: 20,
                ),
                Text(snapshot.data!.get('warden name')),
                const Text("Mail"),
                const SizedBox(
                  height: 20,
                ),
                Text(snapshot.data!.get('warden mail')),
                const SizedBox(
                  height: 20,
                ),
                const Text("Age"),
                const SizedBox(
                  height: 20,
                ),
                Text(snapshot.data!.get('warden age')),
                const SizedBox(
                  height: 20,
                ),
                const Text("Hostel"),
                const SizedBox(
                  height: 20,
                ),
                Text(snapshot.data!.get('hostelId')),
                const Text("")
              ],
            );
          }),
    );
  }
}
