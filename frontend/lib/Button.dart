import 'package:flutter/material.dart';
import 'incoming_events.dart';
class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      TextButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => IncomingEvents())
          );
        },
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.cyan[500],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80)
      ),
    );
  }
}
