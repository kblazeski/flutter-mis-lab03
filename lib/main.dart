import 'package:flutter/material.dart';
import 'package:flutter_lab03/exams_list.dart';
import 'package:flutter_lab03/model/Exam.dart';
import 'package:flutter_lab03/new_exam.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '181103 - Flutter Lab 03',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '181103 - Flutter Lab 03'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Exam> exams = [
    const Exam(
      courseName: 'Mobile Information Systems',
      examDateTime: '01.12.2021 15:00',
    ),
    const Exam(
      courseName: 'Mobile Platforms and Programming',
      examDateTime: '04.12.2021 12:00',
    ),
    const Exam(
      courseName: 'Web Based Systems',
      examDateTime: '27.11.2021 11:30',
    ),
  ];

  void addNewExam(String courseName, String examDateTime) {
    var exam = Exam(courseName: courseName, examDateTime: examDateTime);

    setState(() {
      exams.add(exam);
    });
  }

  void openNewExamDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bCtx) {
        return GestureDetector(
          child: NewExam(
            addNewExam: addNewExam,
          ),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void removeExam(int index) {
    setState(() {
      exams.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => openNewExamDialog(context),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        child: exams.length <= 0
            ? const Text('There are no exams entered!',
                textAlign: TextAlign.center)
            : ExamsList(exams: exams, removeExam: removeExam),
      ),
    );
  }
}
