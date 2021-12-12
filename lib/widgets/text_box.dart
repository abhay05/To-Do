import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class TextFieldText extends StatefulWidget {
  String task;
  Widget childItem;
  int title;
  TextFieldText(this.task, this.childItem, this.title);
  @override
  TextFieldTextState createState() {
    return TextFieldTextState();
  }
}

class TextFieldTextState extends State<TextFieldText> {
  int _editing = 0;
  // int _title = 0;
  TextEditingController _controller;
  void initState() {
    _controller = TextEditingController(text: widget.task);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 50,
      //height: 60,
      child: Row(
        children: [
          Expanded(
            child: TextField(
                style: widget.title == 0
                    ? TextStyle(fontSize: 20)
                    : TextStyle(
                        fontSize: 15,
                      ),
                controller: _controller,
                decoration: _editing == 0
                    ? InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      )
                    : InputDecoration(
                        isDense: true,

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
