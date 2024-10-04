import 'package:biblia_fundamentos/models/abbrev.dart';

class Book {
  final Abbrev abbrev;
  final String author;
  int? chapters;
  String? comment;
  final String group;
  final String name;
  String? testament;

  Book({
    required this.abbrev,
    required this.author,
    this.chapters,
    this.comment,
    required this.group,
    required this.name,
    this.testament
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      abbrev:  Abbrev.fromJson(json['abbrev']),
      author:  json['author'] as String ?? "",
      chapters : json['chapters'],
      comment : json['comment'],
      group : json['group'] as String ?? "",
      name : json['name'] as String ?? "",
      testament : json['testament'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['abbrev'] = abbrev.toJson();
    data['author'] = author;
    data['chapters'] = chapters;
    data['comment'] = comment;
    data['group'] = group;
    data['name'] = name;
    data['testament'] = testament;
    return data;
  }
}
