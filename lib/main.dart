//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './widgets/TaskTile.dart';
import './widgets/task_description_screen.dart';
import './providers/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './widgets/setTime.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid = AndroidInitializationSettings('pen');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => TaskProvider(),
        ),
      ],
      child: MaterialApp(
        home: TODO(),
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Colors.green,
          accentColor: Colors.grey.shade300,
          //cardTheme: CardTheme(),
        ),
        routes: {
          TaskDescriptionScreen.route: (ctx) {
            return TaskDescriptionScreen();
          },
        },
      ),
    );
  }
}

class TODO extends StatefulWidget {
  @override
  _TODOState createState() => _TODOState();
}

class _TODOState extends State<TODO> {
  var inputController = TextEditingController();

  // void addTask(String task) {
  //   TaskProvider.add(task: task, date: DateTime.now());
  //   var taskTile = Task(task: task, date: DateTime.now());
  //   setState(() {
  //     taskTiles.add(taskTile);
  //   });
  // }

  List<Widget> taskTiles = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        //  height: mediaQuery.size.height - mediaQuery.padding.top,
        margin: EdgeInsets.only(top: mediaQuery.padding.top),
        alignment: Alignment.topCenter,
        //color: Colors.black,
        child: Container(
          // color: Colors.blue,
          height: mediaQuery.size.height - mediaQuery.padding.top,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.3,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.amber,
                      ),
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/dailyQuote.jpg'),
                      ),
                    ),
                    Positioned(
                      top: 165,
                      left: 20,
                      child: Text(
                        "Personal",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Icon(Icons.arrow_back_sharp),
                    ),
                  ],
                ),
              ),
              //...taskTiles.forEach((taskItem) => TaskTile(task: taskItem,date:DateTime.now())).toList(),

              Expanded(
                child: Container(
                  // color: Colors.red,
                  // height:
                  //   (mediaQuery.size.height - mediaQuery.padding.top) * 0.7,
                  child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: taskProvider.getTasks.length,
                    itemBuilder: (ctx, ind) {
                      var task = taskProvider.getTasks[ind];
                      return TaskTile(
                        task: task.task,
                        date: task.date,
                        id: task.id,
                        isChecked:
                            taskProvider.getState(task.id) == TaskState.Complete
                                ? true
                                : task.isChecked,
                      );
                    },
                  ),
                ),
              ),
              ListTile(
                // tileColor: Colors.amber,
                title: TextField(
                  controller: inputController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.add,
                          //size: 70,
                        ),
                        onPressed: () {
                          // showDialog(
                          //     context: context,
                          //     builder: (ctx) {
                          //       return SetTime();
                          //     });
                          //scheduleAlarm();
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onSubmitted: (task) {
                    print("task added");
                    //inputController.va
                    taskProvider.add(task, DateTime.now());
                    inputController.clear();
                  },
                ),
              ),

              // RadioListTile(value: 1, groupValue: 1, onChanged: (val) {}),
            ],
          ),
        ),
      ),
    );
  }

  void scheduleAlarm() async {
    var scheduleNotificationDateTime =
        DateTime.now().add(Duration(seconds: 30));

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
}
