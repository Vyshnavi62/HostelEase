import 'package:flutter/material.dart';

// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hostel_ease/screens/common/choose_role.dart';
import 'package:hostel_ease/screens/warden/change_pass.dart';

import 'package:hostel_ease/screens/warden/profile_screen.dart';

import 'package:hostel_ease/screens/warden/leavePass_list.dart';

import 'package:hostel_ease/screens/warden/leave_pass_history.dart';

import 'package:hostel_ease/screens/warden/query_list.dart';

import 'package:hostel_ease/screens/warden/query_screen.dart';
import 'package:hostel_ease/screens/warden/download_outpass.dart';

class WardenMenu extends StatefulWidget {
  const WardenMenu({super.key});

  @override
  State<WardenMenu> createState() => _WardenMenuState();
}

class _WardenMenuState extends State<WardenMenu> {
  List<String> list = <String>[
    'Accept or Reject E-Pass',
    'View Queries',
    'E-Pass History',
    //'Search Student History',
    'Update Password',
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
                image: AssetImage(
                  'assets/images/img.jpeg',
                ))),
        child: GridView.builder(
          // ignore: prefer_const_constructors
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
          ),
          itemCount: list.length,
          padding:
              const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 15),
          itemBuilder: (context, index) {
            return Container(
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
                        Icons.directions_walk, // Hostel icon
                        color: Colors.white,
                        size: 30,
                      )
                    : index == 1
                        // ignore: prefer_const_constructors
                        ? Icon(
                            Icons.question_answer, // Hostel icon
                            color: Colors.white,
                            size: 25,
                          )
                        : index == 2
                            // ignore: prefer_const_constructors
                            ? Icon(
                                Icons.history, // Hostel icon
                                color: Colors.white,
                                size: 30,
                              )
                            : index == 3
                                // ignore: prefer_const_constructors
                                ? Icon(
                                    Icons.vpn_key, // Logout icon
                                    color: Colors.white,
                                    size: 25,
                                  )
                                : index == 4
                                    // ignore: prefer_const_constructors
                                    ? Icon(
                                        Icons.logout, // Logout icon
                                        color: Colors.white,
                                        size: 30,
                                      )
                                    : null,
                contentPadding: EdgeInsets.symmetric(horizontal: 30),
                onTap: () {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeavePassList(),
                      ),
                    );
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QueryList(),
                      ),
                    );
                  } else if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeavePassHistory(),
                      ),
                    );
                  } /*else if (index == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchStudent(),
                      ),
                    );
                  } */
                  else if (index == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePass(),
                      ),
                    );
                  } else if (index == 4) {
                    logout();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
         
         
         
         
         
         
         
         /* child: Column(
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
                                          const LeavePassList()));
                            } else if (index == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const QueryList()));
                            } else if (index == 2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LeavePassHistory()));
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
        ));
  }
}
*/