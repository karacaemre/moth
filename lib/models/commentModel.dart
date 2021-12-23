import 'package:cloud_firestore/cloud_firestore.dart';

import 'bookModel.dart';

class Comments {
  // "comment":commentController.text,
  // "commentedUser":userId,
  // "commentUserProfileImage":"",
  // "commentedUserName":userName,
  // "commentedBook":widget.book!.toMap(),
  //
  String? comment;
  String? commentedUser;
  String? commentedUserProfileImage;
  String? commentedUserName;
  Book? commentedBook;
  DateTime? commentDateTime;
  String? commentedBookID;

  Comments(
      {this.commentedBookID,
      this.commentDateTime,
      this.comment,
      this.commentedBook,
      this.commentedUser,
      this.commentedUserName,
      this.commentedUserProfileImage});

  factory Comments.fromFirestore(DocumentSnapshot snapshot) {
    var d = snapshot;
    return Comments(
      comment: d['comment'],
      commentedUser: d['commentedUser'],
      commentedUserProfileImage: d['commentUserProfileImage'],
      commentedUserName: d['commentedUserName'],
      commentedBookID: d['commentedBookID'],
      commentDateTime: (d['commentDateTime'] as Timestamp).toDate(),

      // commentedBook: Book.fromFirestore(d['commentedBook']),
    );
  }
}
