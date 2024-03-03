import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:hostel_ease/screens/warden/download_outpass.dart';

import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;

import 'dart:typed_data';
import 'package:flutter/src/material/divider.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeavePassHistory extends StatefulWidget {
  const LeavePassHistory({Key? key}) : super(key: key);

  @override
  State<LeavePassHistory> createState() => _LeavePassHistoryState();
}

class _LeavePassHistoryState extends State<LeavePassHistory> {
  List<Map<String, dynamic>> outpasses = [];
  String _searchText = "";
  String _selectedField = "student email";

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    @override
    void dispose() {
      _searchController.dispose();
      super.dispose();
    }

    Future<void> DownloadOutPass() async {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => downloadOutPass()),
      );
    }

    Future<void> _pickField() async {
      // Check if there are accepted outpasses
      final QuerySnapshot acceptedOutpasses = await FirebaseFirestore.instance
          .collection('leavePass')
          .where('status', isEqualTo: 'accepted')
          .limit(1)
          .get();

      acceptedOutpasses.docs.forEach((DocumentSnapshot document) {
        final Map<String, dynamic> outpass = {
          'reason': document['reason'],
          'fromDate': document['from date'],
          'toDate': document['to date'],
          'email': document['student email'],
          'status': document['status'],
        };

        outpasses.add(outpass);
      });

      if (acceptedOutpasses.docs.isNotEmpty) {
        // If there are accepted outpasses, show the "Email" option
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Search by"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: const Text("Email"),
                      onTap: () {
                        setState(() {
                          _selectedField = "student email";
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // If there are no accepted outpasses, show a message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    Color color;

    Color choose(String status) {
      if (status == 'accepted') {
        color = Colors.green;
      } else if (status == 'rejected') {
        color = Colors.red;
      } else {
        color = Colors.yellow;
      }

      return color;
    }

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            icon: Icon(Icons.search, color: Colors.white),
            labelText: 'Search',
            labelStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          onFieldSubmitted: (val) {
            setState(() {
              _searchText = _searchController.text;
            });
            print(_searchText);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _searchText = "";
                _searchController.clear();
              });
            },
            icon: const Icon(Icons.clear),
          ),
          IconButton(
            onPressed: () {
              _pickField();
            },
            icon: const Icon(Icons.filter_alt_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          ElevatedButton(
            onPressed: DownloadOutPass,
            child: Text('Download Outpassess'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('leavePass')
                  .where('status', isNotEqualTo: 'pending')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final status = snapshot.data!.docs[index]['status'];
                      if (status == 'accepted') {
                        // Extract the value of the selected field
                        final fieldValue = snapshot
                            .data!.docs[index][_selectedField]
                            .toString();

                        // Check if the current item matches the search criteria
                        if (_searchText.isEmpty ||
                            fieldValue.contains(_searchText)) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: choose(status),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                title: Text(
                                  "${"Reason: " + snapshot.data!.docs[index]['reason']}\n",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  "${"From Date: ${snapshot.data!.docs[index]['from date'].toString()}"}\n"
                                  "${"To Date:  ${snapshot.data!.docs[index]['to date'].toString()}"}\n"
                                  "${"Email:  ${snapshot.data!.docs[index]['student email'].toString()}"}\n"
                                  "status:  $status",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}













/*
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:hostel_ease/screens/warden/download_outpass.dart';

import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;

import 'dart:typed_data';
import 'package:flutter/src/material/divider.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as path;

class LeavePassHistory extends StatefulWidget {
  const LeavePassHistory({Key? key}) : super(key: key);

  @override
  State<LeavePassHistory> createState() => _LeavePassHistoryState();
}

class _LeavePassHistoryState extends State<LeavePassHistory> {
  List<Map<String, dynamic>> outpasses = [];
  String _searchText = "";
  String _selectedField = "student email";

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    @override
    void dispose() {
      _searchController.dispose();
      super.dispose();
    }

    Future<void> DownloadOutPass() async {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => downloadOutPass()),
      );
    }

    Future<void> _pickField() async {
      // Check if there are accepted outpasses

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('leavePass')
          .where('status', isEqualTo: 'accepted')
          .where('student email', isEqualTo: _selectedField)
          .get();

      querySnapshot.docs.forEach((DocumentSnapshot document) {
        final Map<String, dynamic> outpass = {
          'reason': document['reason'],
          'fromDate': document['from date'],
          'toDate': document['to date'],
          'email': document['student email'],
          'status': document['status'],
        };

        outpasses.add(outpass);
      });

      if (querySnapshot.docs.isNotEmpty) {
        // If there are accepted outpasses, show the "Email" option
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Search by"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: const Text("Email"),
                      onTap: () {
                        setState(() {
                          _selectedField = "student email";
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // If there are no accepted outpasses, show a message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    Color color;

    Color choose(String status) {
      if (status == 'accepted') {
        color = Colors.green;
      } else if (status == 'rejected') {
        color = Colors.red;
      } else {
        color = Colors.yellow;
      }

      return color;
    }

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            icon: Icon(Icons.search, color: Colors.white),
            labelText: 'Search',
            labelStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          onFieldSubmitted: (val) {
            setState(() {
              _searchText = _searchController.text;
            });
            print(_searchText);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _searchText = "";
                _searchController.clear();
              });
            },
            icon: const Icon(Icons.clear),
          ),
          IconButton(
            onPressed: () {
              _pickField();
            },
            icon: const Icon(Icons.filter_alt_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          ElevatedButton(
            onPressed: DownloadOutPass,
            child: Text('Download Outpassess'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('leavePass')
                  .where('status', isNotEqualTo: 'pending')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final status = snapshot.data!.docs[index]['status'];

                      // Extract the value of the selected field
                      final fieldValue =
                          snapshot.data!.docs[index][_selectedField].toString();

                      // Check if the current item matches the search criteria
                      if (_searchText.isEmpty ||
                          fieldValue.contains(_searchText)) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: choose(status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              title: Text(
                                "${"Reason: " + snapshot.data!.docs[index]['reason']}\n",
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "${"From Date: ${snapshot.data!.docs[index]['from date'].toString()}"}\n"
                                "${"To Date:  ${snapshot.data!.docs[index]['to date'].toString()}"}\n"
                                "${"Email:  ${snapshot.data!.docs[index]['student email'].toString()}"}\n"
                                "status:  $status",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}



























import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;

import 'dart:typed_data';
import 'package:flutter/src/material/divider.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as path;

class LeavePassHistory extends StatefulWidget {
  const LeavePassHistory({Key? key}) : super(key: key);

  @override
  State<LeavePassHistory> createState() => _LeavePassHistoryState();
}

class _LeavePassHistoryState extends State<LeavePassHistory> {
  List<Map<String, dynamic>> outpasses = [];
  String _searchText = "";
  String _field = "student email";

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    // bool isShowUsers = false;

    @override
    void dispose() {
      _searchController.dispose();
      super.dispose();
    }

    _pickField() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Search by"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: const Text("Email"),
                      onTap: () {
                        setState(() {
                          _field = "student email";
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: const Text("Fromdate"),
                      onTap: () {
                        setState(() {
                          _field = "from date";
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                  ],
                ),
              ),
            );
          });
    }

    Color color;

    Color choose(String status) {
      if (status == 'accepted') {
        color = Colors.green;
      } else if (status == 'rejected') {
        color = Colors.red;
      } else {
        color = Colors.yellow;
      }

      return color;
    }

/*
    Future<Uint8List> _loadArialFontData() async {
      final ByteData data = await rootBundle.load('assets/arial.ttf');

      return data.buffer.asUint8List();
    }

    Future<void> _downloadPDF() async {
      final pw.Document pdf = pw.Document();

      final List<List<dynamic>> rows = [
        ['Reason', 'From Date', 'To Date', 'Email', 'Status']
      ];

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('leavePass')
          .where('status', isNotEqualTo: 'pending')
          .get();

      querySnapshot.docs.forEach((DocumentSnapshot document) {
        final status = document['status'];

        if (status == 'accepted') {
          rows.add([
            document['reason'],
            (document['from date'] != null &&
                    document['from date'].toString().isNotEmpty)
                ? document['from date'].toString().substring(0, 10)
                : 'N/A',
            (document['to date'] != null &&
                    document['to date'].toString().isNotEmpty)
                ? document['to date'].toString().substring(0, 10)
                : 'N/A',
            document['student email'].toString(),
            status,
          ]);
        }
      });

      Uint8List pdfBytes = Uint8List(0);

      try {
        if (rows.isEmpty) {
          print('No data available for PDF generation.');

          return;
        }

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Table.fromTextArray(
                context: context,
                data: rows,
              );
            },
          ),
        );

        final Uint8List fontData = await _loadArialFontData();

        final pw.Font ttfFont = pw.Font.ttf(fontData.buffer.asByteData());

        pdf.addPage(
          pw.Page(
            theme: pw.ThemeData.withFont(
              base: ttfFont,
            ),
            build: (pw.Context context) {
              return pw.Table.fromTextArray(
                context: context,
                data: rows,
              );
            },
          ),
        );

        pdfBytes = await pdf.save();
      } catch (e) {
        print('Exception while saving PDF: $e');
      }

      try {
        final directory = await getExternalStorageDirectory();

        if (directory != null) {
          final downloadsDirectory =
              Directory('${directory.path}/Downloads/Flutter');

          if (!(await downloadsDirectory.exists())) {
            await downloadsDirectory.create(recursive: true);
          }

          final File file =
              File(path.join(downloadsDirectory.path, 'leave_pass_data.pdf'));

          await file.writeAsBytes(pdfBytes);

          print('PDF saved at: ${file.path}');
        } else {
          print('Unable to get external storage directory');
        }
      } catch (e) {
        print('Exception while saving PDF: $e');
      }
    }
*/
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
            controller: _searchController,
            decoration: const InputDecoration(
              icon: Icon(Icons.search, color: Colors.white),
              labelText: 'Search',
              labelStyle: TextStyle(color: Colors.white),
              // backgroundColor: Colors.white,
            ),
            style: TextStyle(color: Colors.white),
            onFieldSubmitted: (val) {
              setState(() {
                _searchText = _searchController.text;
              });
              print(_searchText);
            }),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _searchText = "";
                _searchController.clear();
              });
            },
            icon: const Icon(Icons.clear),
          ),
          IconButton(
            onPressed: () {
              _pickField();
            },
            icon: const Icon(Icons.filter_alt_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          /* ElevatedButton(
            onPressed: _downloadPDF,
            child: Text('Download PDF'),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: outpasses.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> outpass = outpasses[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: choose(outpass['status']),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text(
                        "${"Reason: " + outpass['reason']}\n",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "${"From Date: ${outpass['fromDate']}"}\n"
                        "${"To:  ${outpass['toDate']}"}\n"
                        "${"Email:  ${outpass['email']}"}\n"
                        "Status:  ${outpass['status']}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          */
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('leavePass')
                  .where('status', isNotEqualTo: 'pending')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final status = snapshot.data!.docs[index]['status'];

                      if (status == 'accepted') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: choose(status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              title: Text(
                                "${"Reason: " + snapshot.data!.docs[index]['reason']}\n",
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "${"From Date: ${snapshot.data!.docs[index]['from date'].toString()}"}\n"
                                "${"To Date:  ${snapshot.data!.docs[index]['to date'].toString()}"}\n"
                                "${"Email:  ${snapshot.data!.docs[index]['student email'].toString()}"}\n"
                                "status:  $status",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/




























/*import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;

import 'dart:typed_data';
import 'package:flutter/src/material/divider.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as path;

class LeavePassHistory extends StatefulWidget {
  const LeavePassHistory({Key? key}) : super(key: key);

  @override
  State<LeavePassHistory> createState() => _LeavePassHistoryState();
}

class _LeavePassHistoryState extends State<LeavePassHistory> {
  List<Map<String, dynamic>> outpasses = [];

  @override
  Widget build(BuildContext context) {
    Color color;

    Color choose(String status) {
      if (status == 'accepted') {
        color = Colors.green;
      } else if (status == 'rejected') {
        color = Colors.red;
      } else {
        color = Colors.yellow;
      }

      return color;
    }

    Future<Uint8List> _loadArialFontData() async {
      final ByteData data = await rootBundle.load('assets/arial.ttf');

      return data.buffer.asUint8List();
    }

    Future<void> _downloadPDF() async {
      final pw.Document pdf = pw.Document();

      final List<List<dynamic>> rows = [
        ['Reason', 'From Date', 'To Date', 'Email', 'Status']
      ];

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('leavePass')
          .where('status', isNotEqualTo: 'pending')
          .get();

      querySnapshot.docs.forEach((DocumentSnapshot document) {
        final status = document['status'];

        if (status == 'accepted') {
          rows.add([
            document['reason'],
            (document['from date'] != null &&
                    document['from date'].toString().isNotEmpty)
                ? document['from date'].toString().substring(0, 10)
                : 'N/A',
            (document['to date'] != null &&
                    document['to date'].toString().isNotEmpty)
                ? document['to date'].toString().substring(0, 10)
                : 'N/A',
            document['student email'].toString(),
            status,
          ]);
        }
      });

      Uint8List pdfBytes = Uint8List(0);

      try {
        if (rows.isEmpty) {
          print('No data available for PDF generation.');

          return;
        }

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Table.fromTextArray(
                context: context,
                data: rows,
              );
            },
          ),
        );

        final Uint8List fontData = await _loadArialFontData();

        final pw.Font ttfFont = pw.Font.ttf(fontData.buffer.asByteData());

        pdf.addPage(
          pw.Page(
            theme: pw.ThemeData.withFont(
              base: ttfFont,
            ),
            build: (pw.Context context) {
              return pw.Table.fromTextArray(
                context: context,
                data: rows,
              );
            },
          ),
        );

        pdfBytes = await pdf.save();
      } catch (e) {
        print('Exception while saving PDF: $e');
      }

      try {
        final directory = await getExternalStorageDirectory();

        if (directory != null) {
          final downloadsDirectory =
              Directory('${directory.path}/Downloads/Flutter');

          if (!(await downloadsDirectory.exists())) {
            await downloadsDirectory.create(recursive: true);
          }

          final File file =
              File(path.join(downloadsDirectory.path, 'leave_pass_data.pdf'));

          await file.writeAsBytes(pdfBytes);

          print('PDF saved at: ${file.path}');
        } else {
          print('Unable to get external storage directory');
        }
      } catch (e) {
        print('Exception while saving PDF: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel Ease'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: TextEditingController(),
              decoration: InputDecoration(
                labelText: 'Enter Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Handle search logic here if needed
              },
              onSubmitted: (value) async {
                outpasses.clear();

                final QuerySnapshot querySnapshot = await FirebaseFirestore
                    .instance
                    .collection('leavePass')
                    .where('status', isEqualTo: 'accepted')
                    .where('student email', isEqualTo: value)
                    .get();

                querySnapshot.docs.forEach((DocumentSnapshot document) {
                  final Map<String, dynamic> outpass = {
                    'reason': document['reason'],
                    'fromDate': document['from date'],
                    'toDate': document['to date'],
                    'email': document['student email'],
                    'status': document['status'],
                  };

                  outpasses.add(outpass);
                });

                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: _downloadPDF,
            child: Text('Download PDF'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: outpasses.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> outpass = outpasses[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: choose(outpass['status']),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text(
                        "${"Reason: " + outpass['reason']}\n",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "${"From Date: ${outpass['fromDate']}"}\n"
                        "${"To:  ${outpass['toDate']}"}\n"
                        "${"Email:  ${outpass['email']}"}\n"
                        "Status:  ${outpass['status']}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(),
          Text('Others Outing History'),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('leavePass')
                  .where('status', isNotEqualTo: 'pending')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final status = snapshot.data!.docs[index]['status'];

                      if (status == 'accepted') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: choose(status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              title: Text(
                                "${"Reason: " + snapshot.data!.docs[index]['reason']}\n",
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "${"From Date: ${snapshot.data!.docs[index]['from date'].toString()}"}\n"
                                "${"To Date:  ${snapshot.data!.docs[index]['to date'].toString()}"}\n"
                                "${"Email:  ${snapshot.data!.docs[index]['student email'].toString()}"}\n"
                                "status:  $status",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/





























/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' show ByteData, Codec;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
//import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:permission_handler/permission_handler.dart';

//import 'package:downloads_path_provider/downloads_path_provider.dart';

class LeavePassHistory extends StatefulWidget {
  const LeavePassHistory({Key? key}) : super(key: key);

  @override
  State<LeavePassHistory> createState() => _LeavePassHistoryState();
}

class _LeavePassHistoryState extends State<LeavePassHistory> {
  List<List<dynamic>> csvData = [];
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> outpasses = [];

  @override
  Widget build(BuildContext context) {
    Color color;
    Color choose(String status) {
      if (status == 'accepted') {
        color = Colors.green;
      } else if (status == 'rejected') {
        color = Colors.red;
      } else {
        color = Colors.yellow;
      }
      return color;
    }

    Future<Uint8List> _loadArialFontData() async {
      // Replace 'path/to/arial.ttf' with the path to a TrueType font file (TTF)
      final ByteData data = await rootBundle.load('assets/arial.ttf');
      return data.buffer.asUint8List();
    }

    Future<void> _downloadPDF() async {
      final pw.Document pdf = pw.Document();

      final List<List<dynamic>> rows = [
        ['Reason', 'From Date', 'To Date', 'Email', 'Status']
      ];

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('leavePass')
          .where('status', isNotEqualTo: 'pending')
          .get();

      querySnapshot.docs.forEach((DocumentSnapshot document) {
        final status = document['status'];
        if (status == 'accepted') {
          rows.add([
            document['reason'],
            // document['from date'].toString().substring(0, 10),
            (document['from date'] != null &&
                    document['from date'].toString().isNotEmpty)
                ? document['from date'].toString().substring(0, 10)
                : 'N/A',
            (document['to date'] != null &&
                    document['to date'].toString().isNotEmpty)
                ? document['to date'].toString().substring(0, 10)
                : 'N/A',

            //document['from date'].toString().substring(0, 10),
            document['student email'].toString().substring(0, 13),
            status,
          ]);
        }
      });

      // Initialize pdfBytes with an empty Uint8List
      Uint8List pdfBytes = Uint8List(0);

      try {
        if (rows.isEmpty) {
          print('No data available for PDF generation.');
          return; // or handle the case appropriately
        }

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Table.fromTextArray(
                context: context,
                data: rows,
              );
            },
          ),
        );

        // Use a TrueType font with Unicode support
        final Uint8List fontData = await _loadArialFontData();
        final pw.Font ttfFont = pw.Font.ttf(fontData.buffer.asByteData());

        pdf.addPage(
          pw.Page(
            theme: pw.ThemeData.withFont(
              base: ttfFont,
            ),
            build: (pw.Context context) {
              return pw.Table.fromTextArray(
                context: context,
                data: rows,
              );
            },
          ),
        );

        pdfBytes = await pdf.save();
        // Continue with handling or saving the PDF bytes
      } catch (e) {
        print('Exception while saving PDF: $e');
      }

      try {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final downloadsDirectory =
              Directory('${directory.path}/downloads/Flutter');
          if (!(await downloadsDirectory.exists())) {
            await downloadsDirectory.create(recursive: true);
          }

          final File file =
              File(path.join(downloadsDirectory.path, 'leave_pass_data.pdf'));
          await file.writeAsBytes(pdfBytes);
          print('PDF saved at: ${file.path}');
        } else {
          print('Unable to get external storage directory');
        }
      } catch (e) {
        print('Exception while saving PDF: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel Ease'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Enter Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: (value) async {
                outpasses.clear();
                final QuerySnapshot querySnapshot = await FirebaseFirestore
                    .instance
                    .collection('leavePass')
                    .where('status', isEqualTo: 'accepted')
                    .where('student email', isEqualTo: value)
                    .get();

                querySnapshot.docs.forEach((DocumentSnapshot document) {
                  final Map<String, dynamic> outpass = {
                    'reason': document['reason'],
                    'fromDate': document['from date'],
                    'toDate': document['to date'],
                    'email': document['student email'],
                    'status': document['status'],
                  };
                  outpasses.add(outpass);
                });
                setState(() {});
              },
            ),
          ),
          ElevatedButton(
            onPressed: _downloadPDF,
            child: Text('Download PDF'),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('leavePass')
                  .where('status', isNotEqualTo: 'pending')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final status = snapshot.data!.docs[index]['status'];
                      if (status == 'accepted') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: choose(status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              title: Text(
                                "${"Reason: " + snapshot.data!.docs[index]['reason']}\n",
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "${"From Date: ${snapshot.data!.docs[index]['from date'].toString()}"}\n"
                                "${"To:  ${snapshot.data!.docs[index]['from date'].toString()}"}\n"
                                "${"Email:  ${snapshot.data!.docs[index]['student email'].toString()}"}\n"
                                "status:  $status",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}*/
