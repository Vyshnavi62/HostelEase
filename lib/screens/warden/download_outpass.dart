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

class downloadOutPass extends StatefulWidget {
  const downloadOutPass({Key? key}) : super(key: key);

  @override
  State<downloadOutPass> createState() => _downloadHistoryState();
}

class _downloadHistoryState extends State<downloadOutPass> {
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
              File(path.join(downloadsDirectory.path, 'out_pass_data.pdf'));

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
          ),
          ElevatedButton(
            onPressed: _downloadPDF,
            //child: Text('Download PDF'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.download), // Add the download icon here
                SizedBox(width: 8.0), // Add some spacing between icon and text
                Text('Download PDF'),
              ],
            ),
          ),
          Divider(),
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

class downloadOutPass extends StatefulWidget {
  const downloadOutPass({Key? key}) : super(key: key);

  @override
  State<downloadOutPass> createState() => _downloadHistoryState();
}

class _downloadHistoryState extends State<downloadOutPass> {
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
          ),
          ElevatedButton(
            onPressed: _downloadPDF,
            //child: Text('Download PDF'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.download), // Add the download icon here
                SizedBox(width: 8.0), // Add some spacing between icon and text
                Text('Download PDF'),
              ],
            ),
          ),
          Divider(),
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

class downloadOutPass extends StatefulWidget {
  const downloadOutPass({Key? key}) : super(key: key);

  @override
  State<downloadOutPass> createState() => _downloadHistoryState();
}

class _downloadHistoryState extends State<downloadOutPass> {
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
          Divider(),
          Text('Student Outing History'),
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