import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';

class TextArea extends StatefulWidget {
  TextEditingController textEditingController;
  String id;
  TextArea(this.textEditingController, this.id);
  @override
  _TextAreaState createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);
    return Container(
      child: TextField(
        textInputAction: TextInputAction.done,
        controller: widget.textEditingController,
        onTap: () {},
        onSubmitted: (value) {
          taskProvider.addDescription(
              widget.id, widget.textEditingController.text);
        },
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        minLines: 5,
        maxLines: 5,
      ),
    );
  }
}
