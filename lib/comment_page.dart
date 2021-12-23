import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/bookModel.dart';
import 'models/commentModel.dart';

class CommentPage extends StatefulWidget {
  Book? book;

  CommentPage({this.book});

  @override
  _TestMeState createState() => _TestMeState();
}

class _TestMeState extends State<CommentPage> {
  List<Comments> _data = [];
  List<DocumentSnapshot> _snap = [];

  @override
  void initState() {
    // TODO: implement initState

    _getData();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [
    {
      'name': 'Buse',
      'pic':
          'https://st3.depositphotos.com/1039762/15793/i/600/depositphotos_157937858-stock-photo-70th-anniversary-screening-premiere.jpg',
      'message': 'kurk mantolu madonna çok güzel okumanızı tavsiye ederim'
    },
    {
      'name': 'Utku',
      'pic': 'https://picsum.photos/300/30',
      'message': 'Evet ben de okudum.Kitaba hayran kaldım :)'
    },
    {
      'name': 'Melis',
      'pic':
          'https://thumbs.dreamstime.com/b/close-up-photo-beautiful-amazing-her-lady-bad-person-tongue-out-mouth-showing-forehead-loser-symbol-teasing-friends-impolite-148230653.jpg',
      'message': 'Martı Jonathan benim en sevdigim kitap'
    },
    {
      'name': 'Ezgi',
      'pic':
          'https://blog.hubspot.com/hs-fs/hubfs/picnoi-free-stock-photos.jpg?width=350&name=picnoi-free-stock-photos.jpg',
      'message': 'The secret bas ucu kitaplarımdan biridir'
    },
  ];

  Widget commentChild(List<Comments> data) {
    if (data.length == 0) {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.comment),
              Center(
                  child: Text(
                "no comments here",
                style: TextStyle(fontSize: 18),
              )),
            ],
          ),
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          children: [
            for (var i = 0; i < data.length; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                child: ListTile(
//                          color: Colors.blueAccent[700],
                  trailing: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      DateFormat.yMMMd()
                              .format(data[i].commentDateTime!)
                              .toString() +
                          "-" +
                          DateFormat.j().format(data[i].commentDateTime!),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  leading: GestureDetector(
                    onTap: () async {
                      // Display the image in large form.
                      print("Comment Clicked");
                    },
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: new BoxDecoration(
                          color: Colors.blueAccent[700],
                          borderRadius:
                              new BorderRadius.all(Radius.circular(50))),
                      child: CircleAvatar(
                        radius: 50,
                        child: Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    data[i].commentedUserName!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      data[i].comment!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment Page"),
        backgroundColor: Color(0xff5ac18e),
      ),
      body: Container(
        child: CommentBox(
          userImage:
              "https://www.seekpng.com/png/detail/41-410093_circled-user-icon-user-profile-icon-png.png",
          child: commentChild(_data),
          labelText: 'Write a comment...',
          withBorder: false,
          errorText: 'Comment cannot be blank',
          sendButtonMethod: () async {
            var docId = FirebaseFirestore.instance.collection("books").doc().id;
            String userId = FirebaseAuth.instance.currentUser!.uid;

            print(userId);

            String? userName = FirebaseAuth.instance.currentUser!.email!
                .substring(
                    0, FirebaseAuth.instance.currentUser!.email!.indexOf("@"));

            print(FirebaseAuth.instance.currentUser!.email);

            await FirebaseFirestore.instance
                .collection("comments")
                .doc(docId)
                .set({
              "comment": commentController.text,
              "commentedUser": userId,
              "commentUserProfileImage": "",
              "commentedUserName": userName,
              "commentedBook": widget.book!.toMap(),
              "commentedBookID": widget.book!.bookID,
              "commentDateTime": FieldValue.serverTimestamp(),
            });
            commentController.clear();
            FocusScope.of(context).unfocus();
            await refresh();
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: Color(0xff5ac18e),
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
        ),
      ),
    );
  }

  Future _getData() async {
    print("getdata çalıştı");
    QuerySnapshot data;
    data = await FirebaseFirestore.instance
        .collection("comments")
        .where("commentedBookID", isEqualTo: widget.book!.bookID)
        .orderBy("commentDateTime", descending: true)
        .get();

    if (data != null && data.docs.length > 0) {
      setState(() {
        _snap.addAll(data.docs);
        _data = _snap.map((e) => Comments.fromFirestore(e)).toList();
      });
    }
  }

  Future<void> refresh() async {
    setState(() {
      _data.clear();
      _snap.clear();
    });

    await _getData();
  }
}
