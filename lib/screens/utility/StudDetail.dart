import 'package:flutter/material.dart';

class StudentDetails extends StatelessWidget {
  final name;
  final yearSection;
  final regNumber;
  final department;

  const StudentDetails(
      {this.name, this.yearSection, this.regNumber, this.department});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, top: 5),
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Name - ' + name,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          ),
          SizedBox(
            height: 3,
          ),
          Text('Year/Section - ' + yearSection,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
          SizedBox(
            height: 3,
          ),
          Text('Reg Num - ' + regNumber,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green)),
          SizedBox(
            height: 3,
          ),
          Text('Department - ' + department,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green))
        ],
      ),
    );
  }
}
