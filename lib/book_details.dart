import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moth/resource/colors.dart';
import 'package:moth/resource/widgets.dart';
import 'package:flutter/material.dart';
import 'package:rating_bar/rating_bar.dart';

import 'comment_page.dart';
import 'models/bookModel.dart';

class BookDetails extends StatefulWidget {
  Book? book;

  BookDetails(this.book);

  @override
  State<BookDetails> createState() => _BookDetailsState( );
}

class _BookDetailsState extends State<BookDetails> {
  final _firestore = FirebaseFirestore.instance;
  double? _rating;
  static int ratedCheck = 0;
  @override
  void initState() {
    // TODO: implement initState
    checkBookRated();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              //   Text(
              //     '${PicRef.get()}',
              //     style: TextStyle(fontSize: 24),
              //   ),

              widget.book!.bookImage!.length == 0
                  ? Image.asset(
                "assets/images/bookSoon.jpeg",
                height: 300,
                fit: BoxFit.cover,
                width: 180,
              )
                  : Padding(
                padding: const EdgeInsets.only( top: 30.0 ),
                child: Image.network(
                  widget.book!.bookImage!,
                  height: MediaQuery
                      .of( context )
                      .size
                      .height / 2.5,
                  width: MediaQuery
                      .of( context )
                      .size
                      .width / 2,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric( horizontal: 24, vertical: 20 ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          widget.book!.bookName!,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                              fontSize: 21 ),
                        ),
                        Spacer( ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            StarRating(
                              rating: 5,
                            ),

                            SizedBox(
                              height: 6,
                            ),
                            // Text(
                            //   "Fairy Tales",
                            //   style: TextStyle(color: darkGreen, fontSize: 14),
                            // )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      widget.book!.summary!,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        letterSpacing: 0.6,
                        wordSpacing: 0.6,
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CommentPage(
                                            book: widget.book,
                                          ) ) );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric( vertical: 18 ),
                              decoration: BoxDecoration(
                                  color: darkGreen,
                                  borderRadius: BorderRadius.circular( 12 ) ),
                              child: Text(
                                "Comments",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600 ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text( "Hello,Rate This Book" ),
                                      actions: [
                                        RatingBar(
                                          onRatingChanged: (rating) {
                                            setState( () {
                                              _rating = rating;
                                              ratedCheck++;
                                            } );
                                          },
                                          filledIcon: Icons.star,
                                          emptyIcon: Icons.star_border,
                                          halfFilledIcon: Icons.star_half,
                                          isHalfAllowed: false,
                                          filledColor: Colors.yellowAccent[700],
                                          emptyColor: Colors.grey,
                                          halfFilledColor: Colors.amberAccent,
                                          size: 48,
                                        ),
                                        SizedBox( height: 32 ),
                                        Text(
                                          'Rating : ${widget.book!.rating
                                              .toString( )}',
                                          style: Theme
                                              .of( context )
                                              .textTheme
                                              .subtitle1,
                                        ),
                                        TextButton(
                                            onPressed: () async {
                                              if (ratedCheck == 1) {
                                                try {
                                                  String userId = FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid;


                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection( "books" )
                                                      .doc(
                                                      widget.book!.bookID )
                                                      .update({
                                                  "ratingCount":
                                                  FieldValue.increment(1),
                                                  "totalRating":
                                                  FieldValue.increment(
                                                  _rating!.toInt()),
                                                  "ratedUser":
                                                  FieldValue.arrayUnion([userId]),
                                                  });
                                                } catch (e) {
                                                  print( e );
                                                }

                                                Fluttertoast.showToast(
                                                    msg:
                                                    "Tebrkikler  🎉🎉🎉 kitaba ${_rating!
                                                        .toInt( )
                                                        .toString( )} yıldız verdiniz",
                                                    toastLength:
                                                    Toast.LENGTH_SHORT,
                                                    gravity:
                                                    ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 4,
                                                    backgroundColor:
                                                    Colors.white,
                                                    textColor: Colors.blue[800],
                                                    fontSize: 16.0 );

                                                Navigator.of( context ).pop( );
                                              } else if (ratedCheck > 1) {
                                                print( "rate leme yapıldı" );
                                                Fluttertoast.showToast(
                                                    msg:
                                                    "Zaten kitaba yıldız verdin !!!",
                                                    toastLength:
                                                    Toast.LENGTH_SHORT,
                                                    gravity:
                                                    ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 4,
                                                    backgroundColor:
                                                    Colors.grey[800],
                                                    textColor: Colors.white,
                                                    fontSize: 16.0 );
                                                Navigator.of( context ).pop( );
                                              }
                                            },
                                            child: Text( "Finish" ) )
                                      ],
                                    );
                                  } );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric( vertical: 18 ),
                              decoration: BoxDecoration(
                                  border:
                                  Border.all( color: greyColor, width: 2 ),
                                  borderRadius: BorderRadius.circular( 12 ) ),
                              child: Text(
                                "Give Star ⭐",
                                style: TextStyle(
                                    color: greyColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600 ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

   checkBookRated() {

   }
}
