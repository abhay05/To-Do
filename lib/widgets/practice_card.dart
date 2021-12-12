import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PracticeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(15)),
      //     side: BorderSide(
      //       color: Theme.of(context).primaryColor,
      //       width: 5,
      //     )),
      //side : ,
      elevation: 10,
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        child: Container(
          height: 100,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 7,
                color: Theme.of(context).primaryColor,
              ),
              left: BorderSide(
                width: 7,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Task", style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Icon(Icons.delete_outline),
                  Icon(Icons.label_important_outline),
                  Icon(Icons.more_vert),
                  Icon(Icons.access_time)
                ],
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Theme.of(context).accentColor,
                      ),
                      child: Text("Complete your homework"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
