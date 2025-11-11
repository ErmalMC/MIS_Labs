import 'package:flutter/material.dart';
import '../models/exam.dart';

class ExamDetailScreen extends StatelessWidget {
  final Exam exam;

  const ExamDetailScreen({super.key, required this.exam});

  String timeLeft() {
    final difference = exam.dateTime.difference(DateTime.now());
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    if (difference.isNegative) {
      return "This exam has already passed.";
    }
    return "$days days, $hours hours remaining";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exam.subjectName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.subjectName,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 8),
                Text(
                  "${exam.dateTime.day}/${exam.dateTime.month}/${exam.dateTime.year} - ${exam.dateTime.hour}:${exam.dateTime.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, size: 20),
                const SizedBox(width: 8),
                Text(
                  exam.venues.join(", "),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Time Left: ${timeLeft()}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
