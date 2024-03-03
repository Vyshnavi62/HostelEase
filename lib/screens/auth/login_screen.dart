// ignore_for_file: use_build_context_synchronously


import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:hostel_ease/resources/authmethods.dart';

import 'package:hostel_ease/screens/admin/admin_menu.dart';

import 'package:hostel_ease/screens/admin/create_warden.dart';

import 'package:hostel_ease/screens/common/choose_role.dart';

import 'package:hostel_ease/screens/student/student_menu.dart';

import 'package:hostel_ease/screens/warden/warden_menu.dart';

import 'package:hostel_ease/widgets/textfiled.dart';


class LoginScreen extends StatefulWidget {

  final String role;

  const LoginScreen({super.key, required this.role});


  @override

  State<LoginScreen> createState() => _LoginScreenState();

}


class _LoginScreenState extends State<LoginScreen> {

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();


  void login() async {

    Authmethods authmethods = Authmethods();

    String res =

        await authmethods.login(email: email.text, password: password.text);

    if (res == "success") {

      if (FirebaseAuth.instance.currentUser!.uid ==

          "dMUHtBMdpDOVfsuzbyoykYZmCuL2") {

        Navigator.push(context,

            MaterialPageRoute(builder: (context) => const Adminmenu()));

      } else if (FirebaseAuth.instance.currentUser!.email!.contains('warden')) {

        Navigator.push(context, MaterialPageRoute(builder: (context) {

          return const WardenMenu();

        }));

      } else if (FirebaseAuth.instance.currentUser!.email!

          .contains('student')) {

        Navigator.push(context, MaterialPageRoute(builder: (context) {

          return const Studentmenu();

        }));

      }

    } else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));

    }

  }


  @override

  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(

          automaticallyImplyLeading: false, // Removes the back arrow

          centerTitle: true, // Centers the title

          title: const Text('Hostel Ease'),

        ),

        body: Container(

          decoration: const BoxDecoration(

              image: DecorationImage(

                  image: AssetImage('assets/images/img.jpeg'),

                  fit: BoxFit.cover)),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Flexible(

                flex: 20,

                child: Container(),

              ),

              const Padding(

                padding: EdgeInsets.only(left: 24),

                child: Text(

                  'Login',

                  textAlign: TextAlign.left,

                  style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold),

                ),

              ),

              const SizedBox(

                height: 40,

              ),

              const SizedBox(

                height: 10,

              ),

              Padding(

                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: TextInput(hint: 'email address', controller: email),

              ),

              const SizedBox(

                height: 10,

              ),

              Padding(

                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: TextInput(

                  hint: 'Password',

                  controller: password,

                  isPassword: true,

                ),

              ),

              const SizedBox(

                height: 20,

              ),

              Padding(

                padding: const EdgeInsets.symmetric(horizontal: 90),

                child: InkWell(

                  onTap: () => login(),

                  child: Container(

                    padding: const EdgeInsets.symmetric(

                      vertical: 12,

                    ),

                    decoration: BoxDecoration(

                        color: Colors.blue[900],

                        borderRadius: BorderRadius.circular(20)),

                    child: const Center(

                        child: Text(

                      'Login',

                      style: TextStyle(color: Colors.white),

                    )),

                  ),

                ),

              ),

              const SizedBox(

                height: 32,

              ),

              Row(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  TextButton(

                    onPressed: () {

                      Navigator.pushReplacement(

                          context,

                          MaterialPageRoute(

                              builder: (context) =>

                                  const ChooseRole(isLogin: true)));

                    },

                    // ignore: prefer_const_constructors

                    child: Text(

                      "Choose your role",

                      style: const TextStyle(

                          color: Colors.white,

                          fontWeight: FontWeight.bold,

                          decoration: TextDecoration.underline,

                          decorationColor: Colors.white,

                          fontSize: 25),

                    ),

                  ),

                ],

              ),

              Flexible(

                flex: 24,

                child: Container(),

              )

            ],

          ),

        ));

  }

}

