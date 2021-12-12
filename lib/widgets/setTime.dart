import 'package:flutter/material.dart';

class SetTime extends StatefulWidget {
  @override
  _SetTimeState createState() => _SetTimeState();
}

class _SetTimeState extends State<SetTime> {
  TimeOfDay _time = TimeOfDay.now();
  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('SELECT TIME'),
            ),
            SizedBox(height: 8),
            Text(
              'Selected Time: ${_time.format(context)}',
            )
          ],
        ),
      ),
    );
  }
}
