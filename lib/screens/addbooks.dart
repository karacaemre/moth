import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class addbooks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _addbooksSate();
  }
}

class _addbooksSate extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Books"),
      ),
      body: Center(
        child: Text("Form burda olacak"),
      ),
    );
  }
}
