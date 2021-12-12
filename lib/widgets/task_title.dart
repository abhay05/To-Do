import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class TaskTitle extends StatefulWidget {
  String task;
  Widget childItem;
  int title;
  TaskTitle(this.task, this.childItem, this.title);
  @override
  TaskTitleState createState() {
    return TaskTitleState();
  }
}

class TaskTitleState extends State<TaskTitle> {
  int _editing = 0;
  // int _title = 0;
  TextEditingController _controller;
  void initState() {
    _controller = TextEditingController(text: widget.task);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.1,
      child: Row(
        children: [
          Expanded(
            child: TextField(
                style: widget.title == 0
                    ? TextStyle(fontSize: 20)
                    : TextStyle(
                        fontSize: 12,
                      ),
                controller: _controller,
                decoration: _editing == 0
                    ? InputDecoration(border: InputBorder.none)
                    : InputDecoration(

                        // suffixIcon: IconButton(
                        //   icon: Icon(Icons.check_box),
                        //   onPressed: () {
                        //     setState(() {
                        //       _editing = 0;
                        //     });
                        //   },
                        // ),
                        ),
                onTap: () {
                  print("Text field tapped");
                  setState(() {
                    _editing = 1;
                  });
                },
                onEditingComplete: () {
                  print("Editing complete");
                },
                onSubmitted: (value) {
                  print("Submitted");
                }),
          ),
          _editing == 0
              ? widget.childItem
              : GestureDetector(
                  behavior: HitTestBehavior.deferToChild,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      _editing = 0;
                    });
                    print("Icon tapped");
                  },
                  child: Icon(Icons.check_box),
                ),
        ],
      ),
    );
  }
}
