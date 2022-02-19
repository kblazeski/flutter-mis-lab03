import 'package:flutter/material.dart';
import 'package:flutter_lab03/exams_list.dart';
import 'package:flutter_lab03/model/exam.dart';
import 'package:flutter_lab03/new_exam.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_lab03/map.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIos = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {},
  );

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIos,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '181103 - Flutter Lab 04',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '181103 - Flutter Lab 05'),
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
  final List<Exam> exams = [];

  bool isCalendar = false;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  void addNewExam(
    String courseName,
    String locationName,
    Location location,
    DateTime examDateTime,
  ) {
    var exam = Exam(
      courseName: courseName,
      examDateTime: examDateTime,
      location: location,
      locationName: locationName,
    );

    scheduleNotification(exam);
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

  void removeExam(Exam exam) {
    setState(() {
      exams.remove(exam);
    });
  }

  List<Exam> _getEventsForDay(DateTime day) {
    var eventsForDay = exams.where((element) {
      var elementDateTime = element.examDateTime;
      return elementDateTime.year == day.year &&
          elementDateTime.month == day.month &&
          elementDateTime.day == day.day;
    }).toList();
    return eventsForDay;
  }

  void scheduleNotification(Exam exam) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      icon: 'ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
    );

    var formattedDateTime = new DateFormat('hh:mm').format(exam.examDateTime);

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // reminder before 15minutes of the examDateTime
    var scheduledTime = exam.examDateTime.subtract(
      Duration(minutes: 15),
    );

    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Exam',
      'You have incoming exam for the course: ${exam.courseName} at $formattedDateTime ',
      scheduledTime,
      platformChannelSpecifics,
    );
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
          IconButton(
              icon: const Icon(Icons.change_circle),
              onPressed: () => setState(() => isCalendar = !isCalendar)),
        ],
      ),
      body: isCalendar
          ? Column(
              children: [
                TableCalendar<Exam>(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay =
                          focusedDay; // update `_focusedDay` here as well
                    });
                  },
                  eventLoader: _getEventsForDay,
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: ExamsList(
                    exams: _getEventsForDay(_selectedDay),
                    removeExam: removeExam,
                  ),
                ),
              ],
            )
          : Map(exams: exams),
    );
  }
}
