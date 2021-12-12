import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';

class DeleteStep extends StatelessWidget {
  String taskId;
  //int stepInd;
  String task;
  DeleteStep(@required this.taskId, @required this.task);
  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        taskProvider.deleteStep(taskId, task);
      },
      child: Icon(Icons.close),
    );
  }
}
