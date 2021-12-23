import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/bookModel.dart';
import 'models/commentModel.dart';

class ProfileUI2 extends StatefulWidget {
  @override
  State<ProfileUI2> createState() => _ProfileUI2State( );
}

class _ProfileUI2State extends State<ProfileUI2> {
  List<Comments> _data = [];
  List<DocumentSnapshot> _snap = [];
  User? user;
  String? userName;
  List<Book>? commentBook;
  QuerySnapshot? bookData;

  @override
  void initState() {
    // TODO: implement initState
    user = FirebaseAuth.instance.currentUser;


    _getData( );
    super.initState( );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      tileMode: TileMode.mirror,
                      stops: [
                        0.0,
                        0.4,
                        0.6,
                        1
                      ],
                      colors: [
                        Color( 0x995ac18e ),
                        Color( 0x665ac18e ),
                        Color( 0x665ac18e ),
                        Color( 0x995ac18e ),
                      ] ),
                ),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Container(
                    alignment: Alignment( 0.0, 2.5 ),
                    child: CircleAvatar(
                      child: Icon(
                        Icons.account_circle,
                        size: 120,
                      ),
                      radius: 60.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                userName!,
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blueGrey,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400 ),
              ),
              SizedBox(
                height: 10,
              ),
              // Text(
              //   "Istanbul, Türkiye",
              //   style: TextStyle(
              //       fontSize: 18.0,
              //       color: Colors.black45,
              //       letterSpacing: 2.0,
              //       fontWeight: FontWeight.w300),
              // ),
              SizedBox(
                height: 10,
              ),
              Text(
                "'You can add a status'",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black45,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w300 ),
              ),
              SizedBox(
                height: 10,
              ),

              SizedBox(
                height: 15,
              ),
              Text(
                "The books they read",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black45,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w300 ),
              ),
              Card(
                margin: EdgeInsets.symmetric( horizontal: 20.0, vertical: 8.0 ),
                child: Padding(
                  padding: const EdgeInsets.all( 8.0 ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Rated",
                              style: TextStyle(
                                  color: Color( 0xff5ac18e ),
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600 ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            FutureBuilder( future: _getRatedData(),builder: (BuildContext context,
                                AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return CircularProgressIndicator( );

                              if (!snapshot.hasData) {
                                return Text( "0" );
                              } else {
                                return Text(
                                  snapshot.data.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w300 ),
                                );
                              }
                            } )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Commented",
                              style: TextStyle(
                                  color: Color( 0xff5ac18e ),
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600 ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              _data.length.toString( ),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w300 ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     RaisedButton(
              //       onPressed: () {},
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(80.0),
              //       ),
              //       child: Ink(
              //         decoration: BoxDecoration(
              //           color: Color(0xff5ac18e),
              //           borderRadius: BorderRadius.circular(30.0),
              //         ),
              //         child: Container(
              //           constraints: BoxConstraints(
              //             maxWidth: 100.0,
              //             maxHeight: 40.0,
              //           ),
              //           alignment: Alignment.center,
              //           child: Text(
              //             "See Books",
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 12.0,
              //                 letterSpacing: 2.0,
              //                 fontWeight: FontWeight.w300),
              //           ),
              //         ),
              //       ),
              //     ),
              //     RaisedButton(
              //       onPressed: () {},
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(80.0),
              //       ),
              //       child: Ink(
              //         decoration: BoxDecoration(
              //           color: Color(0xff5ac18e),
              //           borderRadius: BorderRadius.circular(80.0),
              //         ),
              //         child: Container(
              //           constraints: BoxConstraints(
              //             maxWidth: 100.0,
              //             maxHeight: 40.0,
              //           ),
              //           alignment: Alignment.center,
              //           child: Text(
              //             "Send DM",
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 12.0,
              //                 letterSpacing: 2.0,
              //                 fontWeight: FontWeight.w300),
              //           ),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              Container(
                child: Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(
                            2.0, 8.0, 2.0, 0.0 ),
                        child: ListTile(
//                          color: Colors.blueAccent[700],
                          trailing: Padding(
                            padding: const EdgeInsets.only( top: 15.0 ),
                            child: Text(
                              DateFormat.yMMMd( )
                                  .format( _data[index].commentDateTime! )
                                  .toString( ) +
                                  "-" +
                                  DateFormat.j( )
                                      .format( _data[index].commentDateTime! ),
                              style: TextStyle( fontSize: 13 ),
                            ),
                          ),
                          leading: GestureDetector(
                            onTap: () async {
                              // Display the image in large form.
                              print( "Comment Clicked" );
                            },
                            child: Container(
                              height: 150.0,
                              width: 70.0,
                              decoration: new BoxDecoration(
                              ),
                              child:
                              bookData!
                                  .docs[index]['commentedBook']['bookImage']
                                  .length == 0 ?
                              Image.asset(
                                "assets/images/bookSoon.jpeg",
                                height: 200,
                                fit: BoxFit.cover,
                                width: 180,
                              )


                                  :
                              Image.network( bookData!
                                  .docs[index]['commentedBook']['bookImage'], ),


                            ),
                          ),
                          title: Text(
                            _data[index].commentedUserName!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18 ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only( top: 4.0 ),
                            child: Text(
                              _data[index].comment!,
                              style: TextStyle( fontSize: 16 ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: _data.length,
                  ),
                ),
              )
            ],
          ),
        ) );
  }

  Future _getData() async {
    userName = user!.email!.substring( 0, user!.email!.indexOf( "@" ) );
    setState( () {} );

    print( "getdata çalıştı" );
    QuerySnapshot data;
    data = await FirebaseFirestore.instance
        .collection( "comments" )
        .where( "commentedUser", isEqualTo: user!.uid )
        .orderBy( "commentDateTime", descending: true )
        .get( );

    if (data != null && data.docs.length > 0) {
      print( "deneme book image" );
      //print(data.docs[1]['commentedBook']['bookImage']);

      _snap.addAll( data.docs );

      _data = _snap.map( (e) => Comments.fromFirestore( e ) ).toList( );


      setState( () {
        bookData = data;
      } );
    }
  }

  _getRatedData() async {
    QuerySnapshot commentData = await FirebaseFirestore.instance.collection( "books" ).where(
        "ratedUsers", arrayContains: user!.uid ).get( );
    return commentData.docs.length;
  }
}
