import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_ease/screens/admin/admin_menu.dart';
import 'package:hostel_ease/screens/common/choose_role.dart';
import 'package:hostel_ease/firebase_options.dart';
import 'package:hostel_ease/screens/student/student_menu.dart';
import 'package:hostel_ease/screens/warden/warden_menu.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request external storage permission

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.05),
            centerTitle: false,
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          primaryColor: Colors.blue,
          colorScheme: const ColorScheme.light(),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData) {
              if (snapshot.data!.uid == "uxkzVEE1UfRshLIZuYQnuHLB7qR2") {
                return const Adminmenu();
              } else if (FirebaseAuth.instance.currentUser!.email!
                  .contains('warden')) {
                return const WardenMenu();
              } else if (FirebaseAuth.instance.currentUser!.email!
                  .contains('student')) {
                return const Studentmenu();
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              } else {
                return const ChooseRole(
                  isLogin: true,
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const ChooseRole(
              isLogin: true,
            );
          },
        ));
  }
}
