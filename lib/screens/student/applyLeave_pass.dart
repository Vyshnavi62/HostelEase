// ignore_for_file: use_build_context_synchronously, unused_element

// Ignore these warnings
// ignore_for_file: use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:hostel_ease/resources/DBmethods.dart';
import 'package:hostel_ease/screens/student/viewLeacePass.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({Key? key}) : super(key: key);

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  TextEditingController reason = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();

  DateTime selectedTodate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime selectedFromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  TimeOfDay selectedFromTime = TimeOfDay.now();
  late TimeOfDay selectedToTime;

  @override
  void initState() {
    super.initState();

    // Initialize selectedToTime to be 1 hour more than selectedFromTime
    selectedToTime = TimeOfDay(
      hour: (selectedFromTime.hour + 1) % 24,
      minute: selectedFromTime.minute,
    );
    if (selectedToTime.hour < selectedFromTime.hour ||
        (selectedToTime.hour == selectedFromTime.hour &&
            selectedToTime.minute < selectedFromTime.minute)) {
      // If not, increment the hour by 1
      selectedToTime = TimeOfDay(
        hour: (selectedToTime.hour + 1) % 24,
        minute: selectedFromTime.minute,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        initialDate: DateTime.now());

    Future<TimeOfDay?> pickTime() =>
        showTimePicker(context: context, initialTime: TimeOfDay.now());

    Future<void> upload() async {
      if (reason.text.isNotEmpty &&
          contact.text.isNotEmpty &&
          address.text.isNotEmpty) {
        String res = await DBmethods().applyLeavePass(
          reason: reason.text,
          contact: contact.text,
          address: address.text,
          Fromdate:
              "${selectedFromDate.year}-${selectedFromDate.month}-${selectedFromDate.day} ${selectedFromTime.hour}:${selectedFromTime.minute}",
          Todate:
              "${selectedTodate.year}-${selectedTodate.month}-${selectedTodate.day} ${selectedToTime.hour}:${selectedToTime.minute}",
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res)));

        // ignore: use_build_context_synchronously
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Fill all fields')));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Apply E-Out Pass'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleTextStyle: TextStyle(
            fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: reason,
                decoration: InputDecoration(
                  hintText: 'Reason',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Text(
                    'From :',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final date = await pickDate();
                      final time = await pickTime();
                      if (date == null || time == null) return;

                      setState(() {
                        selectedFromDate = date;
                        selectedFromTime = time;
                      });
                    },
                    child: Text(
                      "${selectedFromDate.year}/${selectedFromDate.month}/${selectedFromDate.day} ${selectedFromTime.format(context)}",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Text(
                    'To :',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final date = await pickDate();
                      final time = await pickTime();
                      if (date == null || time == null) return;

                      setState(() {
                        selectedTodate = date;
                        selectedToTime = time;
                      });
                    },
                    child: Text(
                      "${selectedTodate.year}/${selectedTodate.month}/${selectedTodate.day} ${selectedToTime.format(context)}",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: contact,
                decoration: InputDecoration(
                  hintText: 'Contact Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: address,
                decoration: InputDecoration(
                  hintText: 'Stay Address or visiting place ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                upload();
              },
              child: const Text('Apply Leave'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(
                    255, 164, 72, 180), // Set the background color to purple
                onPrimary: const Color.fromARGB(
                    255, 241, 241, 241), // Set the text color to light pink
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:hostel_ease/resources/DBmethods.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  TextEditingController reason = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();

  DateTime selectedTodate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime selectedFromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  @override
  Widget build(BuildContext context) {
    Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        initialDate: DateTime.now());

    Future<TimeOfDay?> pickTime() =>
        showTimePicker(context: context, initialTime: TimeOfDay.now());

    Future<void> upload() async {
      if (reason.text.isNotEmpty &&
          contact.text.isNotEmpty &&
          address.text.isNotEmpty) {
        String res = await DBmethods().applyLeavePass(
            reason: reason.text,
            contact: contact.text,
            address: address.text,
            Fromdate: selectedFromDate.toString(),
            Todate: selectedTodate.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Fill all fields')));
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Apply Leave',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: reason,
                decoration: InputDecoration(
                  hintText: 'Reason',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Text(
                    'From :',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () async {
                        final date = await pickDate();
                        // final time = await pickTime();
                        if (date == null) return;
                        // if (time == null) return;

                        setState(() {
                          selectedFromDate = date;
                          selectedFromDate = DateTime(
                            selectedFromDate.year,
                            selectedFromDate.month,
                            selectedFromDate.day,
                          );
                          // time.hour,
                          // time.minute);
                        });
                      },
                      child: Text(
                          "${selectedFromDate.year}/${selectedFromDate.month}/${selectedFromDate.day}")),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Text(
                    'To :',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () async {
                        final date = await pickDate();
                        // final time = await pickTime();
                        if (date == null) return;
                        // if (time == null) return;

                        setState(() {
                          selectedTodate = date;
                          selectedTodate = DateTime(
                            selectedTodate.year,
                            selectedTodate.month,
                            selectedTodate.day,
                          );
                          // time.hour,
                          // time.minute);
                        });
                      },
                      child: Text(
                          "${selectedTodate.year}/${selectedTodate.month}/${selectedTodate.day}")),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: contact,
                decoration: InputDecoration(
                  hintText: 'Contact Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: address,
                decoration: InputDecoration(
                  hintText: 'Stay Address or visiting place ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                upload();
              },
              child: const Text('Apply Leave'),
            ),
          ],
        ),
      ),
    );
  }
}
*/