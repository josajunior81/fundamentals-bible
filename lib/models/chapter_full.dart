import 'package:biblia_fundamentos/models/book.dart';

class ChapterFull {
  final Book book;
  final Chapter chapter;
  final List<Verses> verses;

  ChapterFull({required this.book, required this.chapter, required this.verses});

  factory ChapterFull.fromJson(Map<String, dynamic> json) {
    final book = Book.fromJson(json['book']);
    final chapter = Chapter.fromJson(json['chapter']);
    final verses = <Verses>[];
    json['verses'].forEach((v) {
      verses.add(Verses.fromJson(v));
    });
    return ChapterFull(book: book, chapter: chapter, verses: verses);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.book != null) {
  //     data['book'] = this.book!.toJson();
  //   }
  //   if (this.chapter != null) {
  //     data['chapter'] = this.chapter!.toJson();
  //   }
  //   if (this.verses != null) {
  //     data['verses'] = this.verses!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Chapter {
  final int number;
  final int verses;

  Chapter({required this.number, required this.verses});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(number: json['number'], verses: json['verses']);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['number'] = this.number;
  //   data['verses'] = this.verses;
  //   return data;
  // }
}

class Verses {
  final int number;
  final String text;

  Verses({required this.number, required this.text});

  factory Verses.fromJson(Map<String, dynamic> json) {
    return Verses(number: json['number'], text: json['text']);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['number'] = this.number;
  //   data['text'] = this.text;
  //   return data;
  // }
}
