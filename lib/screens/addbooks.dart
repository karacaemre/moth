import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class addbooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Add a Book';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: addbooksForm(),
      ),
    );
  }
}

class addbooksForm extends StatefulWidget {
  @override
  addbooksFormState createState() {
    // TODO: implement createState
    return addbooksFormState();
  }
}

class addbooksFormState extends State<addbooksForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.menu_book_sharp),
              hintText: 'Enter a book name',
              labelText: 'Name',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Enter author name',
              labelText: 'Author',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.calendar_today),
              hintText: 'Enter publishing date',
              labelText: 'Date published',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.menu_book_sharp),
              hintText: 'Enter summary',
              labelText: 'Summary',
            ),
          ),
          new Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              child: new RaisedButton(
                child: const Text('Submit'),
                onPressed: null,
              )),
        ],
      ),
    );
  }
}
