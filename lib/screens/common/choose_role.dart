// ignore_for_file: avoid_print, unnecessary_const

import 'package:flutter/material.dart';
import 'package:hostel_ease/screens/auth/login_screen.dart';

class ChooseRole extends StatelessWidget {
  final bool isLogin;
  const ChooseRole({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    List<String> list = <String>['Student', 'Warden', 'Admin'];
    return Scaffold(
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
          const Text(
            'Choose Role',
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                        if (isLogin) {
                          print('login');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen(role: list[index])));
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
