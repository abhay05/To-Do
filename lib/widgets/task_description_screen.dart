import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './setTime.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_beta/providers/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:to_do_beta/widgets/text_box.dart';
import './delete_step.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';
import './calendar_dialog.dart';
import './text_area.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
enum Stage {
  Start,
  Progress,
  Done,
}

class TaskDescriptionScreen extends StatefulWidget {
  static const route = '/home/taskDescripition';
  @override
  _TaskDescriptionScreenState createState() => _TaskDescriptionScreenState();
}

class _TaskDescriptionScreenState extends State<TaskDescriptionScreen> {
  Stage _stage = Stage.Start;

  TimeOfDay _time = TimeOfDay.now();
  DateTime _dueDate = null; //DateTime.now();
  var _selectedDay = null;
  void _selectTime(String task) async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
      scheduleAlarm(task);
    }
  }

  void scheduleAlarm(String task) async {
    var now = DateTime.now();
    var alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _time.hour,
      _time.minute,
    );

    var scheduleNotificationDateTime = now
        .add(Duration(seconds: now.difference(alarmDateTime).inSeconds.abs()));
    print("Scheduled Time $scheduleNotificationDateTime");
    print(
        "Print difference in seconds ${now.difference(alarmDateTime).inSeconds.abs()}");

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm Notification',
      icon: 'pen',
      largeIcon: DrawableResourceAndroidBitmap('pen'),
    );
    var iosPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(0, 'Reminder', '$task',
        scheduleNotificationDateTime, platformChannelSpecifics);
  }

  List<String> labels = ["exercise", "routine", "special"];

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String;
    var mediaQuery = MediaQuery.of(context);
    var taskProvider = Provider.of<TaskProvider>(context);
    var item = taskProvider.getItem(id);
    var state = taskProvider.getState(id);
    var textController = TextEditingController();
    var stepController = TextEditingController();
    var textAreaController =
        TextEditingController(text: taskProvider.getDescription(id));
    var colorsBack;
    switch (state) {
      case TaskState.Start:
        {
          colorsBack = [Colors.yellow, Colors.white];
        }
        break;
      case TaskState.Progress:
        {
          colorsBack = [Colors.lightGreen, Colors.green];
        }
        break;
      case TaskState.Complete:
        {
          colorsBack = [Colors.lightBlue, Colors.yellow];
        }
        break;
    }

    //var mediaQuery = MediaQuery.of(context);
    var totalHeight = mediaQuery.size.height - mediaQuery.padding.top;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: totalHeight,
                margin: EdgeInsets.only(top: mediaQuery.padding.top),
                //color: Colors.blue[50],
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colorsBack,
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: totalHeight * 0.1,
                      //border:BoxBorder(shadow)
                      decoration: BoxDecoration(
                          //boxShadow: [
                          //BoxShadow(
                          //   //spreadRadius: 2,
                          //   blurRadius: 5,
                          //   color: Colors.blue[400].withOpacity(0.5),
                          // ),
                          //],
                          //color: Colors.blue,
                          ),
                      child: Container(
                        // height: 0,
                        width: mediaQuery.size.width,
                        // padding: EdgeInsets.only(
                        //top: 3,
                        // bottom: 6,
                        //   ),
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          // color: Colors.blue,
                          // boxShadow: [
                          //   BoxShadow(
                          //     offset: Offset(0, 2),
                          //     blurRadius: 20,
                          //     color: Colors.blue.withOpacity(0.2),
                          //   ),
                          //   BoxShadow(
                          //     offset: Offset(15, 25),
                          //     blurRadius: 20,
                          //     color: Colors.blue.withOpacity(0.2),
                          //   ),
                          // ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: IconButton(
                                icon: Image(
                                  image:
                                      AssetImage('assets/images/previous.png'),
                                  height: 30,
                                ),
                                constraints: BoxConstraints(
                                    minHeight: 100, minWidth: 10),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            Expanded(
                              child: Container(
                                //color: Colors.black,
                                child: IconButton(
                                  //padding: EdgeInsets.all(4),
                                  constraints: BoxConstraints(
                                      minHeight: 100, minWidth: 10),
                                  icon: Image(
                                    image: AssetImage(
                                        'assets/images/reminder.png'),
                                    height: 30,
                                  ),
                                  onPressed: () {
                                    _selectTime(item.task);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                constraints: BoxConstraints(
                                    minHeight: 100, minWidth: 10),
                                icon: Image(
                                  image:
                                      AssetImage('assets/images/timetable.png'),
                                  //color: Colors.white,
                                  height: 30,
                                  //size: 20,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return Calendar(id);
                                    },
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: PopupMenuButton<TaskState>(
                                iconSize: 30,
                                icon:
                                    Icon(Icons.more_vert, color: Colors.purple),
                                //color: Colors.white,
                                onSelected: (state) {
                                  setState(() {
                                    //_stage = stage;
                                    taskProvider.setState(id, state);
                                  });
                                },
                                itemBuilder: (ctx) {
                                  return [
                                    PopupMenuItem(
                                      value: TaskState.Start,
                                      child: Text("Start"),
                                    ),
                                    PopupMenuItem(
                                      value: TaskState.Progress,
                                      child: Text("Progress"),
                                    ),
                                    PopupMenuItem(
                                      value: TaskState.Complete,
                                      child: Text("Complete"),
                                    ),
                                  ];
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      //  alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 10),
                      height: totalHeight * 0.1,
                      child: Text(
                        item.task,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Container(
                      height: totalHeight * 0.1,
                      child: Tags(
                        textField: TagsTextField(
                          autofocus: false,
                          onSubmitted: (label) {
                            setState(() {
                              labels.add(label);
                            });
                          },
                        ),
                        itemCount: labels.length,
                        itemBuilder: (ind) {
                          return ItemTags(
                            title: labels[ind],
                            index: ind,
                            textStyle: TextStyle(fontSize: 15),
                            removeButton: ItemTagsRemoveButton(
                              onRemoved: () {
                                setState(() {
                                  labels.removeAt(ind);
                                });
                                return true;
                              },
                            ),
                            onPressed: (item) {
                              print(item);
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      height: totalHeight * 0.4,
                      padding: EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 0,
                            ),
                            //  contentPadding: EdgeInsets.all(0),
                            minVerticalPadding: 0,
                            leading: IconButton(
                              padding: EdgeInsets.all(4),
                              constraints:
                                  BoxConstraints(minHeight: 24, minWidth: 24),
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
                              style: TextStyle(fontSize: 20),
                              controller: stepController,
                              cursorHeight: 20,
                              decoration: InputDecoration(
                                isDense: true,

                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 0),
                                hintText: "Add Steps",

                                //   prefixIcon:
                                border: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                padding: EdgeInsets.only(top: 0, bottom: 0),
                                itemBuilder: (ctx, ind) {
                                  var steps = item.steps;
                                  print(steps[ind]);
                                  // return Text(steps[ind]);
                                  return ListTile(
                                    minVerticalPadding: 0,
                                    dense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 0,
                                    ),
                                    leading: IconButton(
                                      padding: EdgeInsets.all(4),
                                      constraints: BoxConstraints(
                                          minHeight: 24, minWidth: 24),
                                      icon: steps[ind].check
                                          ? Icon(Icons.check_box,
                                              color: Colors.green)
                                          : Icon(Icons.check_box_outline_blank),
                                      onPressed: () {
                                        taskProvider.flipStepCheck(id,
                                            steps[ind].id, !steps[ind].check);
                                      },
                                    ),
                                    title: TextFieldText(steps[ind].step,
                                        DeleteStep(item.id, steps[ind].id), 1),
                                  );
                                },
                                itemCount: item.steps.length),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // color: Colors.amber,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextArea(textAreaController, id),
                    ),
                    Container(
                      //color: Colors.pink,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        child: Text("Add"),
                        onPressed: () {
                          taskProvider.addDescription(
                              id, textAreaController.text);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IgnorePointer(
              ignoring: true,
              child: Center(
                child: Opacity(
                  opacity: 0.03,
                  child: //SvgPicture.asset('assets/images/task-list-menu.svg'),
                      Image(
                    image: AssetImage(
                      'assets/images/homework.png',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
