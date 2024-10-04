import 'dart:async';
import 'dart:convert';

import 'package:biblia_fundamentos/models/book.dart';
import 'package:biblia_fundamentos/models/chapter_full.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<List<Book>> fetchBooks() async {
  final res =
      await http.get(Uri.parse('https://www.abibliadigital.com.br/api/books'));
  if (res.statusCode == 200) {
    return compute(parseBooks, res.body);
  } else {
    throw Exception('Failed to load Books');
  }
}

List<Book> parseBooks(String respBody) {
  final parsed = (jsonDecode(respBody) as List).cast<Map<String, dynamic>>();
  return parsed.map<Book>((json) => Book.fromJson(json)).toList();
}

Future<ChapterFull> fetchChapter(Book book, int chapter) async {
  final res = await http.get(Uri.parse(
      'https://www.abibliadigital.com.br/api/verses/acf/${book.abbrev.pt}/$chapter'));
  if (res.statusCode == 200) {
    return ChapterFull.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load Books');
  }
}

List<ChapterFull> parseChapter(String respBody) {
  final parsed = (jsonDecode(respBody) as List).cast<Map<String, dynamic>>();
  return parsed.map<ChapterFull>((json) => ChapterFull.fromJson(json)).toList();
}

class _MyHomePageState extends State<MyHomePage> {
  String version = "acf";
  String abbrev = "gn";
  String chapter = "1";
  int number = 1;

  late Future<List<Book>> futureBooks;
  late Future<ChapterFull> futureChapter;
  String? bookAbbrev;
  Book? selectedBook;
  int selectedChapter = 1;

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Book>>(
        future: futureBooks,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error fetchBooks ${snapshot.error}");
          } else if (snapshot.hasData) {
            List<Book> books = snapshot.data!;
            selectedBook ??= books.first;
            bookAbbrev ??= selectedBook?.name;
            List<DropdownMenuItem<int>> listChapters = [
              for (var i = 1; i <= selectedBook!.chapters!; i++)
                DropdownMenuItem<int>(value: i, child: Text("$i"))
            ];
            return Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      DropdownButton<String>(
                        // Books dropdown
                        value: bookAbbrev,
                        icon: const Icon(Icons.arrow_downward),
                        onChanged: (String? b) {
                          setState(() {
                            bookAbbrev = b!;
                            selectedBook = books
                                .firstWhere((book) => book.name == bookAbbrev);
                          });
                        },
                        items: books.map<DropdownMenuItem<String>>((Book b) {
                          return DropdownMenuItem(
                            value: b.name,
                            child: Text(b.name),
                          );
                        }).toList(),
                      ),
                      DropdownButton<int>(
                          // Chapters dropdown
                          value: selectedChapter,
                          icon: const Icon(Icons.arrow_downward),
                          items: listChapters,
                          onChanged: (int? i) {
                            setState(() {
                              selectedChapter = i ?? 1;
                            });
                          }),
                    ]),
                FutureBuilder<ChapterFull>(
                  future: fetchChapter(selectedBook!, selectedChapter),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error fetchChapter ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      final chapter = snapshot.data!;
                      var verses = chapter.verses;
                      return Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(20),
                            itemCount: verses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${verses[index].number}. "),
                                    Text(verses[index].text)
                                  ]);
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                          ),
                      );
                      //   ListView.separated(
                      //   padding: const EdgeInsets.all(20.0),
                      //
                      //   shrinkWrap: true,
                      //   itemCount: verses.length,
                      //   separatorBuilder: (context, index) => const Divider(),
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return Row(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Text("${verses[index].number}. "),
                      //               Text(verses[index].text)
                      //             ]);
                      //   },
                      // );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
