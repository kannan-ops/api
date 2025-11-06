import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  List post = [];

  TextEditingController title = TextEditingController();
  TextEditingController author = TextEditingController();
  TextEditingController genre = TextEditingController();
  TextEditingController availabilityStatus = TextEditingController();

  late TextEditingController title1;
  late TextEditingController author1;
  late TextEditingController genre1;
  late TextEditingController availabilityStatus1;

  void LibraryUpdate() async {
    try {
      var response = await http.patch(
        Uri.parse("http://92.205.109.210:8051/library/create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": title.text,
          "author": author.text,
          "genre": genre.text,
          "availabilityStatus": availabilityStatus.text,
        }),
      );

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseBody["message"])));
        getBooks();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed: ${responseBody["message"]}")));
      }
    } catch (k) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $k")));
    }

    title.clear();
    author.clear();
    genre.clear();
    availabilityStatus.clear();
  }

  Future<void> getBooks() async {
    try {
      var response =
      await http.get(Uri.parse("http://92.205.109.210:8051/library/getall"));
      var bodyData = jsonDecode(response.body);
      post = bodyData["data"];
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      var response = await http
          .delete(Uri.parse("http://92.205.109.210:8051/library/delete/$id"));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Book Deleted Successfully")));
        getBooks();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to delete book")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> editBook(int id) async {
    try {
      var response = await http.post(
        Uri.parse("http://92.205.109.210:8051/library/update/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": title1.text,
          "author": author1.text,
          "genre": genre1.text,
          "availabilityStatus": availabilityStatus1.text,
        }),
      );
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");


      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Book Updated Successfully")));
        setState(() {
          getBooks();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to update book: ${response.body}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  void initState() {
    super.initState();
    getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          "LIBRARY API TASK",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image:NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUcB3L1jzD_eLQ5tpvVs9uie6yBgQDStqG0w&s"),fit: BoxFit.fill)
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: title,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.title),
                  hintText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: author,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: "Author",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: genre,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.category),
                  hintText: "Genre",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: availabilityStatus,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.event_available),
                  hintText: "Availability Status",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                LibraryUpdate();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text("Add to Library"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: post.length,
                itemBuilder: (context, index) {
                  final book = post[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${book['title']}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text("Author: ${book['author']}"),
                          Text("Genre: ${book['genre']}"),
                          Text("Available: ${book['availabilityStatus']}"),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  title.text = book['title'];
                                  author.text = book['author'];
                                  genre.text = book['genre'];
                                  availabilityStatus.text =
                                  book['availabilityStatus'];

                                  title1 = TextEditingController(text: title.text);
                                  author1 =
                                      TextEditingController(text: author.text);
                                  genre1 =
                                      TextEditingController(text: genre.text);
                                  availabilityStatus1 =
                                      TextEditingController(text: availabilityStatus.text);

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: Text("Edit Book Details"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: title1,
                                                decoration: InputDecoration(
                                                  hintText: "Title",
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: author1,
                                                decoration: InputDecoration(
                                                  hintText: "Author",
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: genre1,
                                                decoration: InputDecoration(
                                                  hintText: "Genre",
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: availabilityStatus1,
                                                decoration: InputDecoration(
                                                  hintText: "Availability Status",
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              editBook(book['bookId']);
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white),
                                            child: Text("Save"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey),
                                child: Text("Edit"),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  bool? confirm = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Confirm Delete"),
                                      content: Text(
                                          "Are you sure you want to delete this book?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text("No")),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text("Yes")),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    deleteBook(book['bookId']);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: Text("Delete"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}