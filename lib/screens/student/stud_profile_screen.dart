import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_ease/screens/student/book_Room.dart';
import 'package:hostel_ease/screens/student/change_password.dart';
import 'package:hostel_ease/screens/student/student_menu.dart';

class StuProfileScreen extends StatelessWidget {
  const StuProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("My Account"),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('students')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          try {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text('No data available'),
              );
            }

            // var data = snapshot.data!.data() as Map<String, dynamic>;
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text('No data available'),
              );
            }

            var data = snapshot.data!.data() as Map<String, dynamic>;

            if (data == null) {
              return Center(
                child: Text('Data is null'),
              );
            }

// Rest of your code to display the profile data

            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileItem(label: "Mail", value: data['email']),
                  ProfileItem(label: "Name", value: data['name']),
                  ProfileItem(label: "Department", value: data['department']),
                  ProfileItem(label: "Room No", value: data['room no']),
                  ProfileItem(label: "floor", value: data['floor no']),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePassword(),
                            ),
                          );
                          // Implement action for the first button
                        },
                        child: Text('Edit Password'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } catch (e, stackTrace) {
            print('Error: $e\n$stackTrace');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No data available please book a room first'),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the book room screen or any other screen you desire
                      // You might need to replace 'BookRoomScreen()' with your actual screen class
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Studentmenu(),
                        ),
                      );
                    },
                    child: Text('Book Room'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String label;
  final String? value;

  const ProfileItem({required this.label, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(width: 20),
        Text(value?.isEmpty ?? true ? 'N/A' : value!,
            style: TextStyle(fontSize: 18)),
      ],
    );
  }
}















/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_ease/resources/DBmethods.dart';
import 'package:hostel_ease/screens/auth/login_screen.dart';

class StuProfileScreen extends StatelessWidget {
  const StuProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("My Account"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('students')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.data() as Map<String, dynamic>?;
            // var data = snapshot.data!.data();
            if (data != null && data.containsKey('email')) {
              var studentMail = data['email'];
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text("Mail"),
                      Text(studentMail ?? 'N/A'),
                    ],
                  ),
                ),
              );
              //}
              //if (data != null && data.containsKey('name')) {
              var name = data['name'];
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text("Name"),
                      Text(name ?? 'N/A'),
                    ],
                  ),
                ),
              );
              //}
              // if (data != null && data.containsKey('department')) {
              var dept = data['department'];
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text("Department"),
                      Text(dept ?? 'N/A'),
                    ],
                  ),
                ),
              );
            } else {
              // Handle case where 'student mail' field does not exist
              return Center(
                child: Text('Student mail field not found'),
              );
            }
          } else if (snapshot.hasError) {
            // Handle error case
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Still loading data
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
*/





     /* body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('students')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Student Mail"),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(snapshot.data!.get('student mail')),
                     Text(
                 "${" Name: ${snapshot.data['name'].toString()}"}\n",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                "${" Mail: ${snapshot.data['email'].toString()}"}\n",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
              Text(
                "${" Department: ${snapshot.data['department'].toString()}"}\n",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
                  ],
                ),
              ),
            );*/
            /*   return Column(
              children: [
                // const Spacer(),
                const Text("Name"),
                const SizedBox(
                  height: 20,
                ),
                const Text("Student Mail"),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Department"),
                const SizedBox(
                  height: 20,
                ),
                const Text("Hostel"),
                const SizedBox(
                  height: 20,
                ),
                const Text("")
              ],
            );*/
          

/*

// ignore_for_file: must_be_immutable

class StuProfileScreen extends StatefulWidget {
  const StuProfileScreen({super.key});
  
  @override
  State<StuProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<StuProfileScreen> {
  String name = "";
  String registeredEvents = "";
  Future<String> getName() async {
    String name = await DBmethods().getName();
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(155, 158, 158, 158),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 44,
              ),
              FutureBuilder(
                future: getName(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Name : ${snapshot.data} ',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    );
                  } else {
                    return const Text(
                      'Name : ',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                'Student Email : ${FirebaseAuth.instance.currentUser!.email}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              widget.isStudent
                  ? FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('events')
                          .where('requests',
                              arrayContains:
                                  FirebaseAuth.instance.currentUser!.email)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            'Registered Events : ${snapshot.data?.docs.length}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          );
                        } else {
                          return const Text(
                            'Institute : ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          );
                        }
                      },
                    )
                  : Container(),
              const SizedBox(
                height: 32,
              ),
              widget.isStudent
                  ? FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('events')
                          .where('requests',
                              arrayContains:
                                  FirebaseAuth.instance.currentUser!.email)
                          .where('date_time',
                              isLessThan: DateTime.now().toString())
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            'Participted Events : ${snapshot.data?.docs.length}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          );
                        } else {
                          return const Text(
                            'Participted Events : 0',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          );
                        }
                      },
                    )
                  : Container(),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}*/
