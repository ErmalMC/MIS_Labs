import 'package:flutter/material.dart';
import '../models/exam.dart';
import '../widgets/exam_card.dart';
import 'exam_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Exam> exams = [
    Exam(subjectName: "Calculus", dateTime: DateTime(2025, 11, 5, 9, 0), venues: ["Room 117"]),
    Exam(subjectName: "Object Oriented Programming", dateTime: DateTime(2025, 11, 7, 14, 0), venues: ["Lab 2"]),
    Exam(subjectName: "Algorithms And Data Structures", dateTime: DateTime(2025, 11, 9, 9, 0), venues: ["Lab 3"]),
    Exam(subjectName: "Advanced Programming", dateTime: DateTime(2025, 11, 10, 10, 0), venues: ["MF 223"]),
    Exam(subjectName: "Databases", dateTime: DateTime(2025, 11, 12, 13, 0), venues: ["Lab 13"]),
    Exam(subjectName: "Computer Architecture", dateTime: DateTime(2025, 11, 14, 9, 0), venues: ["Room 315"]),
    Exam(subjectName: "Human-Computer Interactions", dateTime: DateTime(2025, 11, 16, 11, 0), venues: ["Lab 13"]),
    Exam(subjectName: "Mobile Information Systems", dateTime: DateTime(2025, 11, 18, 9, 0), venues: ["Lab 200AB"]),
    Exam(subjectName: "Integrated Systems", dateTime: DateTime(2025, 11, 20, 9, 0), venues: ["Lab 12"]),
    Exam(subjectName: "Digitizacija", dateTime: DateTime(2025, 11, 22, 10, 0), venues: ["TMF 117"]),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    exams.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Schedule - 221543'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: exams.length,
        itemBuilder: (context, index) {
          final exam = exams[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamDetailScreen(exam: exam),
                ),
              );
            },
            child: ExamCard(exam: exam),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Total Exams: ${exams.length}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
