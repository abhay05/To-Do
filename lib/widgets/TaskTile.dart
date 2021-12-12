import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_beta/widgets/task_description_screen.dart';
import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';

class TaskTile extends StatefulWidget {
  String task;
  DateTime date;
  String id;
  bool isChecked;
  TaskTile({this.task, this.date, this.id, @required this.isChecked});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  //bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context, listen: false);
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.grey;
      }
      return Colors.green;
    }

    //var state = taskProvider.getState(widget.id);

    return ListTile(
      //tileColor: Colors.amber,
      leading: InkWell(
        onTap: () {
          setState(() {
            widget.isChecked = !widget.isChecked;
            taskProvider.setChecked(widget.isChecked, widget.id);
          });
        },
        child: Container(
            height: 23,
            width: 23,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isChecked ? Colors.green : Colors.white,
              border: Border.all(
                color: widget.isChecked ? Colors.green : Colors.grey,
                width: 2,
              ),
              // borderRadius: BorderRadius.all( cant' be defined with shape=cirlce
              //   Radius.circular(5),
              // ),
            ),
            child: widget.isChecked
                ? FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ))
                : Icon(null)),
      ),
      // Checkbox(
      //     value: isChecked,
      //     onChanged: (bool val) {
      //       setState(() {
      // isChecked = val;
      //       });
      //     },
      //     fillColor: MaterialStateProperty.resolveWith(getColor),
      //     checkColor: Colors.white,
      //   ),
      title: Text(
        widget.task,
        style: TextStyle(
          decoration: widget.isChecked
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          TaskDescriptionScreen.route,
          arguments: widget.id,
        );
      },
      subtitle: Text(DateFormat.yMMMd().format(widget.date).toString()),
      trailing: IconButton(
        icon: Icon(
          Icons.star_outline,
          size: 25,
        ),
        onPressed: () {},
      ),
    );
  }
}
