import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moth/profile_page.dart';
import 'package:moth/screens/addbooks.dart';

import 'book_details.dart';
import 'login_page.dart';
import 'models/bookModel.dart';

class BooksPage extends StatelessWidget {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = FirebaseAuth.instance;

  List<Book> _data = [];

  List<Book> secondData = [];

  List<DocumentSnapshot> _snap = [];

  @override
  void initState() {
    //başlangıç
    // TODO: implement initState

    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundGradient(),
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: refresh,
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            print(_data.length);
                          },
                          child: CustomBanner()),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          "BEST SELLERS",
                        ),
                      ),
                      Container(
                        height: 200,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              //tıklanabilir özelliği
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        BookDetails(_data[index])));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors.white,
                                  child: _data[index].bookImage!.length == 0
                                      ? Image.asset(
                                          "assets/images/bookSoon.jpeg", //placeholder
                                          height: 200,
                                          fit: BoxFit.cover,
                                          width: 180,
                                        )
                                      : Image.network(
                                          _data[index]
                                              .bookImage!, //kitapların resmi
                                          height: 500,
                                          width: 180,
                                        ),
                                ),
                              ),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: _data.length,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "RECENTLY ADDED BOOKS",
                        ),
                      ),
                      Container(
                        height: 200,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        BookDetails(secondData[index])));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors.white,
                                  child:
                                      secondData[index].bookImage!.length == 0
                                          ? Image.asset(
                                              "assets/images/bookSoon.jpeg",
                                              height: 200,
                                              fit: BoxFit.cover,
                                              width: 180,
                                            )
                                          : Image.network(
                                              secondData[index].bookImage!,
                                              height: 500,
                                              width: 180,
                                            ),
                                ),
                              ),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: secondData.length,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  )
                ],
              ),
            ),
            Align(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: RaisedButton(
                      color: Colors.green[100],
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.person, color: Colors.redAccent),
                          SizedBox(width: 5.0),
                          Text("Profile"),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileUI2()));
                      },
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: RaisedButton(
                      color: Colors.green[100],
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 5.0),
                          Text("Add a Book"),
                        ],
                      ),
                      onPressed: () {
                        print("redirecting...");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => addbooks()));
                      },
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: RaisedButton(
                        color: Colors.green[100],
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.exit_to_app, color: Colors.black),
                            SizedBox(width: 5.0),
                            Text("Logout"),
                          ],
                        ),
                        onPressed: () {
                          auth.signOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        }),
                  ),
                ],
              ),
              alignment: Alignment.bottomCenter,
            )
          ],
        ),
      ),
    );
  }

  //verileri asenkron çektiğimiz alan
  Future _getData() async {
    print("getdata is working");
    QuerySnapshot data;
    data = await FirebaseFirestore.instance
        .collection("books")
        .get(); //firebase den books u çekiyoruz

    if (data != null && data.docs.length > 0) {
      setState(() {
        _snap.addAll(data.docs); //gelen dataları snapshot a atıyoruz
        _data = _snap
            .map((e) => Book.fromFirestore(e))
            .toList(); //gelen datayı book tipinde tutuyoruz
        secondData = _snap.map((e) => Book.fromFirestore(e)).toList();
        secondData.shuffle();
      });
    }
  }

  Future<void> refresh() async {
    //anasayfayı refreshleme , refresh indicator
    setState(() {
      //re-compile
      _data.clear();
      secondData.clear();
      _snap.clear();
    });

    await _getData();
  }
}

BoxDecoration backgroundGradient() {
  return BoxDecoration(
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
          Color(0x995ac18e),
          Color(0x665ac18e),
          Color(0x665ac18e),
          Color(0x995ac18e),
        ]),
  );
}

class CustomBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        height: 170.0,
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/enjoy-your-book.png",
                  height: 120,
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
