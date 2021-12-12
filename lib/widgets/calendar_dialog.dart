import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';

class Calendar extends StatefulWidget {
  String taskId;
  Calendar(this.taskId);
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  var _selectedDay;
  var _dueDate;
  var taskProvider;
  @override
  void initState() {
//     Future.delayed(Duration(seconds: 0)).then((value) => {
// var taskProvider = Provider.of<TaskProvider>(context);
//     _dueDate = taskProvider.getDueDate(widget.taskId);
//     });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var taskProvider = Provider.of<TaskProvider>(context);
    _dueDate = taskProvider.getDueDate(widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 400,
        width: 400,
        child: TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            selectedDayPredicate: (day) {
              print("Hello1");
              return isSameDay(_selectedDay, day);
            },
            focusedDay: _dueDate == null ? DateTime.now() : _dueDate,
            onDaySelected: (selectedDay, focusedDay) {
              print("Hello2");
              setState(() {
                _selectedDay = selectedDay;
                _dueDate = selectedDay;
                taskProvider.updateDueDate(widget.taskId, _dueDate);
              });
              print(_dueDate.toString());
            }),
      ),
    );
  }
}
