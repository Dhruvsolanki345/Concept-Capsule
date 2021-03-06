import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';

class CompletedCourses extends StatelessWidget {
  final String userId;

  const CompletedCourses({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Query<Map<String, dynamic>> completedCourse = FirebaseFirestore
        .instance
        .collection('users')
        .doc(userId)
        .collection('enrolledCourses')
        .where('complete', isEqualTo: true);
    return FutureBuilder<QuerySnapshot>(
      future: completedCourse.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.length != 0) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final DocumentSnapshot enCourse = snapshot.data!.docs[index];
              return Card(
                elevation: 5,
                color: Colors.white,
                shadowColor: Color.fromRGBO(0, 0, 0, 0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ), // RoundedRectangleBorder
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Image.network(
                        enCourse['thumbnail'],
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ), // Image.network
                    ), // Padding
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          enCourse['name'],
                          style: TextStyle(fontSize: 20),
                        ), // Text
                        SizedBox(height: 5),
                        Text(
                          enCourse['instructor'].toUpperCase(),
                          style: TextStyle(
                            fontSize: 17,
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                          ), // TextStyle
                        ), // Text
                        SizedBox(height: 10),
                        Text(
                          "Completed on " +
                              formatDate(enCourse['completedTime'].toDate(),
                                  [d, ' ', M, ', ', yyyy]),
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                          ), // TextStyle
                        ), // Text
                        SizedBox(height: 5),
                      ],
                    ) // Column
                  ],
                ), // Row
              ); // Card
            },
          ); // ListView.builder
        } else if (snapshot.hasData && snapshot.data!.docs.length == 0) {
          return Center(
            child: Text(
              "No Course found.",
              style: TextStyle(fontSize: 20),
            ), // Text
          ); // Center
        }
        return Center(
          child: CircularProgressIndicator(),
        ); // Center
      },
    ); // FutureBuilder
  }
}
