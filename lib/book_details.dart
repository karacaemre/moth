import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moth/resource/colors.dart';
import 'package:moth/resource/widgets.dart';
import 'package:flutter/material.dart';

import 'models/bookModel.dart';

class BookDetails extends StatefulWidget {
  Book? book;
  BookDetails(this.book);
  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  final _firestore = FirebaseFirestore.instance;

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


              widget.book!.bookImage!.length==0?
              Image.asset(
                "assets/images/bookSoon.jpeg",
                height: 300,
                fit: BoxFit.cover,
                width: 180,
              )
:

              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Image.network(widget.book!.bookImage!, height: MediaQuery.of(context).size.height/2.5,width: MediaQuery.of(context).size.width/2,),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          widget.book!.bookName!,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                              fontSize: 21),
                        ),
                        Spacer(),
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
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                                color: darkGreen,
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              "Comments",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                                border: Border.all(color: greyColor, width: 2),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              "More info",
                              style: TextStyle(
                                  color: greyColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
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
}

/*
  final firestoreInstance = FirebaseFirestore.instance;

  void get_book() {
    firestoreInstance.collection("books").doc('tur').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
      });
    });
  }

  void set_book() {
    CollectionReference BookRef = FirebaseFirestore.instance.collection('books');
    var kitaptur = BookRef.doc('tur');

    BookRef.add(
        {
          "tur" : "BilimKurgu",
          "id" : 01,
        }).then((value){
      print(value.id);
    });
  }


  void _onPressed(){
    var firebaseUser =  FirebaseAuth.instance.currentUser;
    firestoreInstance.collection("books").doc("BilimKurgu").doc(firebaseUser!.uid).set(
        {
          "name" : "john",
          "age" : 50,
          "email" : "example@example.com",
          "address" : {
            "street" : "street 24",
            "city" : "new york"
          }
        }).then((_){
      print("success!");
    });
  }

//CollectionReference books = FirebaseFirestore.instance.collection('books');
//int _counter=0;
//CollectionReference UsersRef = FirebaseFirestore.instance.collection('users');
//UsersRef.add({'field':''});

//final _firestore=FirebaseFirestore.instance;

//int _counter=0;
// CollectionReference BooksRef = FirebaseFirestore.instance.collection('books');
//BooksRef.add({'field':'$_counter'});

//CollectionReference kitap = _firestore.collection('books');
// var kitap1 = _firestore.collection('books').doc('BilimKurgu');
// print(kitap1.id);



  CollectionReference bookref = _firestore.collection('books');
    var PicRef = bookref.doc('1984');


 var response = await PicRef.get();
                dynamic map = response.data();
                print(map['PicRef']);
                print(map);



*/
