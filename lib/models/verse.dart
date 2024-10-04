import 'package:biblia_fundamentos/models/book.dart';

class Verse {
  Book? book;
  int? chapter;
  int? number;
  String? text;

  Verse({this.book, this.chapter, this.number, this.text});

  Verse.fromJson(Map<String, dynamic> json) {
    book = json['book'] != null ? new Book.fromJson(json['book']) : null;
    chapter = json['chapter'];
    number = json['number'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.book != null) {
      data['book'] = this.book!.toJson();
    }
    data['chapter'] = this.chapter;
    data['number'] = this.number;
    data['text'] = this.text;
    return data;
  }
}