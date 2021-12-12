import 'package:flutter/material.dart';

enum TaskState { Start, Progress, Complete }

class Step {
  String id;
  String step;
  bool check;
  Step({this.id, this.step, this.check});
}

class Task {
  final String task;
  final DateTime date;
  final String id;
  bool isChecked = false;
  bool isFavorite = false;
  DateTime dueDate;
  List<Step> steps = [];
  TaskState state = TaskState.Start;
  String description;
  Task({
    @required this.task,
    // @required this.isChecked,
    @required this.date,
    @required this.id,
  });
}

class TaskProvider extends ChangeNotifier {
  List<Task> taskList = [];
  void add(String task, DateTime date) {
    Task taskItem = Task(task: task, date: date, id: date.toString());
    taskList.add(taskItem);
    notifyListeners();
  }

  List<Task> get getTasks {
    return [...taskList];
  }

  Task getItem(String id) {
    return taskList.firstWhere((element) => element.id == id);
  }

  void setChecked(bool checked, String id) {
    taskList.forEach((element) {
      if (element.id == id) {
        element.isChecked = checked;
      }
    });
    notifyListeners();
  }

  void addSteps(String id, String step) {
    taskList
        .firstWhere((element) => element.id == id)
        .steps
        .add(Step(step: step, id: step, check: false));
    print("step added");
    notifyListeners();
  }

  void deleteStep(String taskId, String id) {
    var steps = taskList.firstWhere((element) => element.id == taskId).steps;
    steps.removeWhere((ele) => ele.id == id);
    notifyListeners();
    //replace index with step id
    //taskList.fir((element) => element.steps == step);
  }

  void updateDueDate(String taskId, DateTime newDueDate) {
    taskList.firstWhere((element) => element.id == taskId).dueDate = newDueDate;
    notifyListeners();
  }

  DateTime getDueDate(String id) {
    print("I am providing due Date");
    print(taskList.firstWhere((element) => element.id == id).dueDate);
    return taskList.firstWhere((element) => element.id == id).dueDate;
  }

  TaskState getState(String id) {
    return taskList.firstWhere((element) => element.id == id).state;
  }

  void setState(String id, TaskState state) {
    taskList.firstWhere((element) => element.id == id).state = state;
  }

  void flipStepCheck(String taskId, String stepId, bool check) {
    taskList
        .firstWhere((element) => element.id == taskId)
        .steps
        .firstWhere((ele) => ele.id == stepId)
        .check = check;
    notifyListeners();
  }

  void addDescription(String id, String desc) {
    taskList.firstWhere((element) => element.id == id).description = desc;
    notifyListeners();
  }

  String getDescription(String id) {
    return taskList.firstWhere((element) => element.id == id).description;
  }
}
