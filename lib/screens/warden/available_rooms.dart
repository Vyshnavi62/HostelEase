import 'package:flutter/material.dart';

class AvailableRooms extends StatefulWidget {
  const AvailableRooms({super.key});

  @override
  State<AvailableRooms> createState() => _AvailableRoomsState();
}

class _AvailableRoomsState extends State<AvailableRooms> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text('Available Rooms'),
    ));
  }
}
