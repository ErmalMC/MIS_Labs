import 'package:flutter/material.dart';
import '../models/exam.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;

  const ExamCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    bool isPast = exam.dateTime.isBefore(DateTime.now());

    return Card(
      color: isPast ? Colors.red[100] : Colors.green[100],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.subjectName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 5),
                Text(
                  '${exam.dateTime.day}/${exam.dateTime.month}/${exam.dateTime.year} - ${exam.dateTime.hour}:${exam.dateTime.minute.toString().padLeft(2, '0')}',
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 5),
                Text(exam.venues.join(", ")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
