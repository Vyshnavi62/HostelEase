// Add necessary import statements

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_ease/screens/admin/create_hostel.dart';
import 'package:hostel_ease/screens/common/choose_role.dart';
import 'package:hostel_ease/screens/student/applyLeave_pass.dart';
import 'package:hostel_ease/screens/student/book_Room.dart';
import 'package:hostel_ease/screens/student/my_queries.dart';
import 'package:hostel_ease/screens/student/query_screen.dart';
import 'package:hostel_ease/screens/student/viewLeacePass.dart';
import 'package:hostel_ease/screens/student/stud_profile_screen.dart';
import 'package:hostel_ease/screens/student/change_password.dart';

class Studentmenu extends StatefulWidget {
  const Studentmenu({Key? key}) : super(key: key);

  @override
  State<Studentmenu> createState() => _StudentmenuState();
}

class _StudentmenuState extends State<Studentmenu> {
  int _pageIndex = 0;
  final List<Widget> _children = [
    const BookRoomScreen(),
    const QuesryScreenStudent(),
    const MyQueries(),
    const ApplyLeave(),
    const ViewLeavePass(),
    const StuProfileScreen(),
    //ChangePassword(),
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }
  // User user = UserProvider().getUser as User;

  void onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ChooseRole(isLogin: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel Ease'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            // backgroundColor: Colors.black,
            icon: Icon(
              Icons.apartment,
              color: _pageIndex == 0 ? Colors.purple : Colors.grey,
            ),
            label: "Book Room",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.question_answer,
              color: _pageIndex == 1 ? Colors.purple : Colors.grey,
            ),
            label: "Raise Query",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: _pageIndex == 2 ? Colors.purple : Colors.grey,
            ),
            label: "View Query",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.hail,
              color: _pageIndex == 3 ? Colors.purple : Colors.grey,
            ),
            label: "Apply E-Pass",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              color: _pageIndex == 4 ? Colors.purple : Colors.grey,
            ),
            label: "View E-Pass",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _pageIndex == 5 ? Colors.purple : Colors.grey,
            ),
            label: "View Profile",
          ),
          /* BottomNavigationBarItem(
            icon: Icon(
              Icons.key,
              color: _pageIndex == 6 ? Colors.purple : Colors.grey,
            ),
            label: "Edit Password",
          ),*/
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout,
              //_pageIndex = 6,
              color: Colors.grey,
            ),
            label: 'Logout',
          ),
        ],
        currentIndex: _pageIndex,
        // onTap: navigationTapped,
        onTap: (index) {
          if (index <= _children.length - 1) {
            navigationTapped(index);
          } else {
            _logout();
          }
        },
      ),
    );
  }
}























/*



// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_ease/screens/admin/create_hostel.dart';
import 'package:hostel_ease/screens/common/choose_role.dart';
import 'package:hostel_ease/screens/student/applyLeave_pass.dart';
import 'package:hostel_ease/screens/student/book_Room.dart';
import 'package:hostel_ease/screens/student/my_queries.dart';
import 'package:hostel_ease/screens/student/query_screen.dart';
import 'package:hostel_ease/screens/student/viewLeacePass.dart';
import 'package:hostel_ease/screens/student/stud_profile_screen.dart';
import 'package:hostel_ease/screens/warden/query_screen.dart';
import 'package:hostel_ease/screens/student/change_password.dart';

class Studentmenu extends StatefulWidget {
  const Studentmenu({super.key});

  @override
  State<Studentmenu> createState() => _StudentmenuState();
}

// ... (imports and other code)

class _StudentmenuState extends State<Studentmenu> {
  List<String> list = <String>[
    'Book Room',
    'Raise Query',
    'View queries',
    'Apply E-Pass',
    'View E-Pass',
    'View Profile',
    'Edit Password',
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
          ),
        ),
      );
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
          // ignore: prefer_const_constructors
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
          ),
          itemCount: list.length,
          padding:
              const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 15),
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
                onTap: () {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookRoomScreen(),
                      ),
                    );
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuesryScreenStudent(),
                      ),
                    );
                  } else if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyQueries(),
                      ),
                    );
                  } else if (index == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ApplyLeave(),
                      ),
                    );
                  } else if (index == 4) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewLeavePass(),
                      ),
                    );
                  } else if (index == 5) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  } else if (index == 6) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePassword(),
                      ),
                    );
                  } else if (index == 7) {
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
*/
















 /*       child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      child: Container(
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
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BookRoomScreen(),
                                ),
                              );
                            } else if (index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const QuesryScreenStudent(),
                                ),
                              );
                            } else if (index == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyQueries(),
                                ),
                              );
                            } else if (index == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ApplyLeave(),
                                ),
                              );
                            } else if (index == 4) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ViewLeavePass(),
                                ),
                              );
                            } else if (index == 5) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePassword(),
                                ),
                              );
                            } else if (index == 6) {
                              logout();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}*/



/*class _StudentmenuState extends State<Studentmenu> {
  List<String> list = <String>[
    'Book Room',
    'Raise Query',
    'View queries',
    'Apply E-Pass',
    'View E-Pass',
    'Edit Password',
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
                                          const BookRoomScreen()));
                            } else if (index == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const QuesryScreenStudent()));
                            } else if (index == 2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyQueries()));
                            } else if (index == 3) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ApplyLeave()));
                            } else if (index == 4) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ViewLeavePass()));
                            } else if (index == 5) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePassword(),
                                ),
                              );
                            } else if (index == 6) {
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