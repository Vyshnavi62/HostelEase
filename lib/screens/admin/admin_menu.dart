// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_ease/screens/admin/View_hostels.dart';
import 'package:hostel_ease/screens/admin/create_hostel.dart';
import 'package:hostel_ease/screens/admin/create_student_screen.dart';
import 'package:hostel_ease/screens/admin/create_warden.dart';
import 'package:hostel_ease/screens/common/choose_role.dart';

class Adminmenu extends StatefulWidget {
  const Adminmenu({super.key});

  @override
  State<Adminmenu> createState() => _AdminmenuState();
}

class _AdminmenuState extends State<Adminmenu> {
  List<String> list = <String>[
    'Add Hostel',
    'View Hostels',
    'Add Student',
    'Logout'
  ];
  @override
  Widget build(BuildContext context) {
    void logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ChooseRole(
                    isLogin: true,
                  )));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back arrow
        centerTitle: true, // Centers the title
        title: const Text('Hostel Ease'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/img.jpeg'),
          ),
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
          ),
          itemCount: list.length,
          padding:
              const EdgeInsets.only(top: 140, left: 20, right: 20, bottom: 15),
          itemBuilder: (context, index) {
            return Container(
              height: 1500, // Adjust the height as needed
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: Center(
                  child: Text(
                    list[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                leading: index == 0
                    // ignore: prefer_const_constructors
                    ? Icon(
                        Icons.add_business, // Hostel icon
                        color: Colors.white,
                        size: 25,
                      )
                    : index == 1
                        // ignore: prefer_const_constructors
                        ? Icon(
                            Icons.apartment, // Hostel icon
                            color: Colors.white,
                            size: 25,
                          )
                        : index == 2
                            // ignore: prefer_const_constructors
                            ? Icon(
                                Icons.person_add, // Hostel icon
                                color: Colors.white,
                                size: 20,
                              )
                            : index == 3
                                // ignore: prefer_const_constructors
                                ? Icon(
                                    Icons.logout, // Logout icon
                                    color: Colors.white,
                                    size: 30,
                                  )
                                : null,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 30), // Adjust the padding

                onTap: () {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateHostel()),
                    );
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ViewHostels()),
                    );
                  } else if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateStudent()),
                    );
                  } else if (index == 3) {
                    logout();
                  }
                },
              ),
            );
          },
        ),
      ),
    );

    /*return Scaffold(
        appBar: AppBar(
          title: const Text('Hostel Ease'),
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    'assets/images/img.jpeg',
                  ))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          title: Center(
                              child: Text(
                            list[index],
                            style: const TextStyle(color: Colors.white),
                          )),
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateHostel()));
                            } else if (index == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ViewHostels()));
                            } else if (index == 2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateStudent()));
                            } else if (index == 3) {
                              logout();
                            }
                          },
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ));*/
  }
}
