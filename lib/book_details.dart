import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moth/resource/colors.dart';
import 'package:moth/resource/widgets.dart';
import 'package:flutter/material.dart';

class BookDetails extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference bookref = _firestore.collection('books');
    var PicRef = bookref.doc('1984');

  var link = "https://firebasestorage.googleapis.com/v0/b/moth-d8dc9.appspot.com/o/1984.jpg?alt=media&token=78a10519-fc48-426a-beb2-5c1e0ecc183e";

    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[

            //   Text(
            //     '${PicRef.get()}',
            //     style: TextStyle(fontSize: 24),
            //   ),

            ElevatedButton(
              child: Text('Koleksiyon Çek'),
              onPressed: () async {
                var response = await bookref.get();
                var list = response.docs;
                print(list.first.data());


              },
            ),
            ElevatedButton(
              child: Text('Döküman Çek'),
              onPressed: () async {
                var response = await PicRef.get();
                dynamic map = response.data();
                print(map['id']);
                var pic = map['PicRef'];

              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Image.network(
                "$link",
                height: 200
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "The Little memaid",
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
                          Text(
                            "Fairy Tales",
                            style: TextStyle(color: darkGreen, fontSize: 14),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "“The Little Mermaid” is a fairy tale written by the Danish author Hans Christian Andersen. The story follows the journey of a young mermaid who is willing to give up her life in the sea as a mermaid to gain a human soul. The tale was first published in 1837 as part of a collection of fairy tales for children.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
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
