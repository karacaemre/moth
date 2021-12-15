import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moth/main.dart';

import 'comment_page.dart';
import 'login_page.dart';

class BooksPage extends StatelessWidget {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BOOKS PAGE',
      theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.black, size: 40),
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection("books");
    return Scaffold(
      body: Container(
        decoration: backgroundGradient(),
        child: Stack(
          children: [
            /*           Align(
              alignment: Alignment.bottomCenter,
              child: CustomBottomNav(),
            ),

  */
            Column(
              children: [
                CustomBanner(),
                BookListView(
                  title: 'YOUR CHOICES',
                  books: [
                    '1984.jpg',
                    'aylak.jpg',
                    'dogru.jpg',
                    'ermis.jpg',
                    'ferrari.jpg',
                    'gunluk.jpg',
                    'hayvan.jpg',
                    'kuantum.jpg'
                  ],
                ),
                BookListView(
                  title: 'USERS FAVORITES',
                  books: [
                    'kucuk.jpg',
                    'magic.jpg',
                    'marti.jpg',
                    'nutuk.jpg',
                    'power.jpg',
                    'secret.jpg',
                    'simdi.jpg',
                  ],
                ),
                BottomNavBarWidget(),

/*                RaisedButton(
                  elevation: 5,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  color: Colors.white,
                  child: Text(
                    'COMMENT PAGE',
                    style: TextStyle(
                        fontFamily: 'PermanentMarker',
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CommentPage()));
                  },
                ),
    */
              ],
            )
          ],
        ),
      ),
    );
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
}

class BookListView extends StatelessWidget {
  final String title;
  final List<String> books;

  const BookListView({Key? key, required this.title, required this.books})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              title,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            height: 150,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: books.length,
                itemBuilder: (BuildContext context, int index) {
                  return BookCard(
                    file: books[index],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final String file;

  static const filePath = 'assets/images/';

  const BookCard({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0x665ac18e),
      ),
      child: Image.asset(filePath + file),
    );
  }
}

class CustomBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        height: 170.0,
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Image.asset(
                  "assets/images/enjoy-your-book.png",
                  height: 120,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBottomNav extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        child: RaisedButton(
            elevation: 5,
            padding: EdgeInsets.all(10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: Colors.white,
            child: Text('Logout',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'PermanentMarker')),
            onPressed: () {
              auth.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            }),
      ),
    );
  }
}

class BottomNavBarWidget extends StatefulWidget {
  const BottomNavBarWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavBarWidget> createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  int _selectedPage = 0;
  PageController pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 1000), curve: Curves.bounceIn);
  }

  _onTap() {
    // this has changed
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            _list[_selectedPage])); // this has changed
  }

  final List<Widget> _list = [Home(), BooksPage(), LoginScreen()];

  Widget choosePage(int _selectedPage) {
    if (_selectedPage == 0) {
      return Home();
    }
    if (_selectedPage == 1) {
      return BooksPage();
    }
    if (_selectedPage == 2) {
      return CommentPage();
    }
    return BooksPage();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.black12),
      child: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            title: SizedBox(
              height: 0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: SizedBox(
              height: 0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            title: SizedBox(
              height: 0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: SizedBox(
              height: 0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: SizedBox(
              height: 0,
            ),
          ),
        ],
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
