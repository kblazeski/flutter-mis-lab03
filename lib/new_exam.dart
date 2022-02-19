import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class NewExam extends StatefulWidget {
  final Function(String, String, Location, DateTime) addNewExam;
  const NewExam({Key? key, required this.addNewExam}) : super(key: key);

  @override
  _NewExamState createState() => _NewExamState();
}

class _NewExamState extends State<NewExam> {
  final courseNameController = TextEditingController();
  final locationNameController = TextEditingController();

  DateTime? _selectedDate;

  Future<void> submitData() async {
    if (courseNameController.text.isNotEmpty &&
        _selectedDate != null &&
        locationNameController.text.isNotEmpty) {
      List<Location> locations =
          await locationFromAddress(locationNameController.text);
      widget.addNewExam(
        courseNameController.text,
        locationNameController.text,
        locations[0],
        _selectedDate!,
      );
      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(3000),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      DateTime finalDate = pickedDate;

      showTimePicker(context: context, initialTime: TimeOfDay.now())
          .then((pickedTime) {
        if (pickedTime == null) {
          return;
        }
        finalDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
            pickedTime.hour, pickedTime.minute);

        setState(() {
          _selectedDate = finalDate;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(),
                ),
                controller: courseNameController,
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Location Name',
                  border: OutlineInputBorder(),
                ),
                controller: locationNameController,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${new DateFormat('dd.MM.yyyy hh:mm').format(_selectedDate!)}',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: submitData,
                child: const Text(
                  'Submit exam',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
