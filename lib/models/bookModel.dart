import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  String? author;
  List? bookComment;
  List? bookCommentedUser;
  String? bookID;
  String? bookImage;
  String? bookName;
  String? publishDate;
  int? ratingCount;
  int? totalRating;
  double? rating;
  String? summary;
  List? ratedUsers;

  Book(
      {this.ratedUsers,
      this.author,
      this.rating,
      this.bookID,
      this.bookImage,
      this.bookName,
      this.bookComment,
      this.bookCommentedUser,
      this.totalRating,
      this.publishDate,
      this.ratingCount,
      this.summary});

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'bookCommentedUser': bookCommentedUser,
      'bookID': bookID,
      'bookImage': bookImage,
      'name': bookName,
      'publishDate': publishDate,
      'ratingCount': ratingCount,
      'summary': summary,
      'totalRating': totalRating,
      'ratedUsers': ratedUsers,
    };
  }

  factory Book.fromFirestore(DocumentSnapshot snapshot) {
    var d = snapshot;
    return Book(
      author: d['author'],
      bookCommentedUser: d['bookCommentedUser'],
      bookID: d['bookID'],
      bookImage: d['bookImage'],
      bookName: d['name'],
      publishDate: d['publishDate'],
      ratingCount: d['ratingCount'],
      summary: d['summary'],
      ratedUsers: d['ratedUsers'] ?? [],
      totalRating: d['totalRating'],
      rating: 0,
    );
  }
}
