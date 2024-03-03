// change_password_dialog.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePassword extends StatefulWidget {
  //const ChangePassword({Key? key}) : super(key: key); // Added 'Key' parameter

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _newPasswordController,
            decoration: InputDecoration(labelText: 'New Password'),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            await updatePassword(_newPasswordController.text, context);
            Navigator.of(context).pop();
          },
          child: Text('Update Password'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> updatePassword(String newPassword, BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
    } catch (error) {
      print('Error updating password: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update password')),
      );
    }
  }
}
