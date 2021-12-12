import 'package:flutter/material.dart';
import 'package:to_do_beta/providers/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:to_do_beta/widgets/text_box.dart';
import './TaskTile.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './setTime.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import './delete_step.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class TaskDescription extends StatefulWidget {
  //static const route = '/home/taskDescripition';

  @override
  _TaskDescriptionState createState() => _TaskDescriptionState();
}

class _TaskDescriptionState extends State<TaskDescription> {
  TimeOfDay _time = TimeOfDay.now();
  DateTime _dueDate = null; //DateTime.now();
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
      scheduleAlarm();
    }
  }

  void scheduleAlarm() async {
    var now = DateTime.now();
    var alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _time.hour,
      _time.minute,
    );

    var scheduleNotificationDateTime =
        now.add(Duration(seconds: now.difference(alarmDateTime).inSeconds));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm Notification',
      icon: 'matlab',
      largeIcon: DrawableResourceAndroidBitmap('matlab'),
    );
    var iosPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Hurray',
        'First notificaton built',
        scheduleNotificationDateTime,
        platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String;
    var mediaQuery = MediaQuery.of(context);
    var taskProvider = Provider.of<TaskProvider>(context);
    var item = taskProvider.getItem(id);
    var textController = TextEditingController();
    var stepController = TextEditingController();
    return Scaffold(
      body: Container(
        height: mediaQuery.size.height - mediaQuery.padding.top,
        margin: EdgeInsets.only(top: mediaQuery.padding.top),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    //color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text("Personal"),
                Spacer(),
              ],
            ),
            ListTile(
              title: TextFieldText(item.task, Icon(null), 0),
            ),
            // TaskTile(
            //   id: item.id,
            //   task: item.task,
            //   date: item.date,
            //   isChecked: item.isChecked,
            // ),
            Expanded(
              child: ListView.builder(
                  itemBuilder: (ctx, ind) {
                    var steps = item.steps;
                    print(steps[ind]);
                    // return Text(steps[ind]);
                    return ListTile(
                      title: TextFieldText(steps[ind].step,
                          DeleteStep(item.id, steps[ind].id), 1),
                    );
                  },
                  itemCount: item.steps.length),
            ),
            Expanded(
              child: ListTile(
                //  contentPadding: EdgeInsets.all(0),
                minVerticalPadding: 0,
                leading: IconButton(
                  // padding: EdgeInsets.all(0),
                  // constraints: BoxConstraints(minHeight: 24, minWidth: 24),
                  icon: Icon(
                    Icons.add,
                    //  size: 30,
                  ),
                  onPressed: () {
                    var step = stepController.text;
                    taskProvider.addSteps(id, step);
                    stepController.clear();
                  },
                  //iconSize: 39,
                ),
                //),
                title: TextField(
                  // style: TextStyle(),
                  //scrollPadding: EdgeInsets.all(0),

                  controller: stepController,
                  decoration: InputDecoration(
                    //  isDense: true,
                    //  contentPadding: EdgeInsets.all(0),
                    hintText: "Add Steps",

                    //   prefixIcon:
                    border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.alarm),
                  onPressed: () {
                    // scheduleAlarm();
                    _selectTime();
                  },
                ),
                title: Text("Reminder"),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          content: Container(
                            height: 400,
                            width: 400,
                            child: TableCalendar(
                                firstDay: DateTime.utc(2010, 10, 16),
                                lastDay: DateTime.utc(2030, 3, 14),
                                focusedDay: DateTime.now(),
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _dueDate = selectedDay;
                                  });
                                }),
                          ),
                        );
                      },
                    );
                  },
                ),
                title: _dueDate == null
                    ? Text("Add due date")
                    : Text(DateFormat.yMMMd().format(_dueDate).toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
