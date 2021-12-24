import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as io;

import 'package:image_picker/image_picker.dart';

import '../books_page.dart';

class addbooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Add a Book';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: addbooksForm(),
    );
    //yanlış kullanım geri tuşu çalışmaz**
    //   MaterialApp(
    //   title: appTitle,
    //   home: ,
    //   debugShowCheckedModeBanner: false,
    // );
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
  XFile? imageFile; //mobilden gelen resim
  final ImagePicker _picker = ImagePicker();

  TextEditingController nameController = TextEditingController(); //form check
  TextEditingController authorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController summaryController = TextEditingController();

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //  mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),

                // ignore: unnecessary_null_comparison
                imageFile != null //image nullsa sembol, değilse seçilen image
                    ? Center(
                        child: Image.file(
                        File(imageFile!.path),
                        width: 280,
                        height: 400,
                        fit: BoxFit.cover,
                      ))
                    : InkWell(
                        onTap: () async {
                          try {
                            final pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery, //go-to gallery
                              maxWidth: 800,
                              maxHeight: 800,
                              imageQuality: 80,
                            );
                            setState(() {
                              imageFile = pickedFile;
                            });
                          } catch (e) {}
                        },
                        child: Center(
                          child: Container(
                            child: Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.tealAccent[700],
                              size: 55,
                            ),
                          ),
                        ),
                      ),

                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.menu_book_sharp),
                    hintText: 'Enter a book name',
                    labelText: 'Name',
                  ),
                ),
                TextFormField(
                  controller: authorController,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Enter author name',
                    labelText: 'Author',
                  ),
                ),
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.calendar_today),
                    hintText: 'Enter publishing date',
                    labelText: 'Date published',
                  ),
                ),
                TextFormField(
                  controller: summaryController,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.menu_book_sharp),
                    hintText: 'Enter summary',
                    labelText: 'Summary',
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                        height: 40,
                        width: 100,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Colors.blue[700],
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () async {
                            print("onpressed");
                            if (imageFile == null) {
                              //image eklenmediyse uyarı ver
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor: Colors.tealAccent,
                                    title: Text(
                                      "Warning",
                                      style: TextStyle(color: Colors.black87),
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Text(
                                      "You Are Adding Books Without Images",
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          "Close",
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pop-up ı kapat
                                        },
                                      ),
                                      FlatButton(
                                        child: Text(
                                          "Continue",
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                        onPressed: () async {
                                          //Devam dedikten sonra alan kontrolü
                                          if (!nameController.text.isEmpty &&
                                              !authorController.text.isEmpty &&
                                              !dateController.text.isEmpty &&
                                              !summaryController.text.isEmpty) {
                                            var docId = FirebaseFirestore
                                                .instance
                                                .collection("books")
                                                .doc()
                                                .id; //yeni kitaba id atama

                                            bool gelenData =
                                                await formSubmit(docId);

                                            if (gelenData) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              BooksPage()));
                                            }
                                          } else {
                                            _showDialog(); //boş alan var uyarısı
                                          }
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            } else {
                              if (!nameController.text.isEmpty &&
                                  !authorController.text.isEmpty &&
                                  !dateController.text.isEmpty &&
                                  !summaryController.text.isEmpty) {
                                var docId = FirebaseFirestore.instance
                                    .collection("books")
                                    .doc()
                                    .id;

                                firebase_storage.Reference ref =
                                    firebase_storage.FirebaseStorage.instance
                                        .ref()
                                        .child('books')
                                        .child('/$docId.png');

                                final metadata =
                                    firebase_storage.SettableMetadata(
                                        contentType: 'image/jpeg',
                                        customMetadata: {
                                      'picked-file-path': imageFile!.path
                                    });

                                await ref.putFile(
                                    io.File(imageFile!.path), metadata);

                                String imageUrl = await ref.getDownloadURL();

                                bool gelenData =
                                    await formSubmitWithImage(docId, imageUrl);

                                if (gelenData) {
                                  await Future.delayed(
                                      Duration(milliseconds: 300));

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => BooksPage()));
                                }
                              } else {
                                _showDialog();
                              }
                            }
                          },
                        )),
                  ),
                ),

                SizedBox(
                  height: 400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  formSubmitWithImage(
    String docId,
    String imageUrl,
  ) async {
    try {
      await FirebaseFirestore.instance.collection("books").doc(docId).set({
        "author": authorController.text,
        "name": nameController.text,
        "publishDate": dateController.text,
        "summary": summaryController.text,
        "bookID": docId,
        "ratingCount": 0,
        "totalRating": 0,
        "bookComment": [],
        "bookCommentedUser": [],
        "ratedUsers": [],
        "bookImage": imageUrl
      });
      return true;
    } catch (e) {
      print("error while adding a book" + e.toString());
      return false;
    }
  }

  formSubmit(
    String docId,
  ) async {
    try {
      await FirebaseFirestore.instance.collection("books").doc(docId).set({
        "author": authorController.text,
        "name": nameController.text,
        "publishDate": dateController.text,
        "summary": summaryController.text,
        "bookID": docId,
        "ratingCount": 0,
        "totalRating": 0,
        "bookComment": [],
        "ratedUsers": [],
        "bookCommentedUser": [],
        "bookImage": ""
      });
      return true;
    } catch (e) {
      print("error while adding a book" + e.toString());
      return false;
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.red,
          title: new Text(
            "Warning",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          content: new Text(
            "There Are Blank Fields On The Form ",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
