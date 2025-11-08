import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api extends StatefulWidget {
  const Api({super.key});

  @override
  State<Api> createState() => _ApiState();
}

class _ApiState extends State<Api> {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();

  List items = [];
  bool loading = false;

  final String baseUrl = "https://flutter-task.onrender.com/task";

  @override
  void initState() {
    super.initState();
    getAll();
  }

  Future<void> getAll() async {
    setState(() => loading = true);
    try {
      final res = await http.get(Uri.parse("$baseUrl/getall"));
      if (res.statusCode == 200 || res.statusCode == 201) {
        final body = jsonDecode(res.body);
        setState(() {
          items = body['Tasks'] ?? [];
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      debugPrint("GET Error: $e");
    }
    setState(() => loading = false);
  }

  Future<void> postData() async {
    if (title.text.trim().isEmpty || description.text.trim().isEmpty) {
      _showSnack("Fill both fields da macha");
      return;
    }
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/create"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode({
          "title": title.text.trim(),
          "description": description.text.trim(),
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        _showSnack("Task added successfully!");
        title.clear();
        description.clear();
        getAll();
      } else {
        throw Exception("Failed to post");
      }
    } catch (e) {
      debugPrint("POST Error: $e");
    }
  }

  // 🔹 UPDATE task
  Future<void> updateData(String id, String newTitle, String newDesc) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/update"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode({
          "id": id,
          "title": newTitle,
          "description": newDesc,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        _showSnack("✏️ Task updated successfully!");
        getAll();
      } else {
        throw Exception("Failed to update");
      }
    } catch (e) {
      debugPrint("UPDATE Error: $e");
    }
  }

  // 🔹 DELETE task
  Future<void> deleteData(String id) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/remove"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode({"id": id}),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        _showSnack("🗑️ Task deleted");
        setState(() {
          items.removeWhere((element) => element['_id'] == id);
        });
      } else {
        throw Exception("Failed to delete");
      }
    } catch (e) {
      debugPrint("DELETE Error: $e");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // 🔹 Edit dialog
  void _showEditDialog(String id, String oldTitle, String oldDesc) {
    final editCtrl = TextEditingController(text: oldTitle);
    final descCtrl = TextEditingController(text: oldDesc);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: editCtrl,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              updateData(id, editCtrl.text.trim(), descCtrl.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD API Demo"),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: description,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: postData,
              child: const Text("Add Task"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text("No tasks found"))
                  : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    elevation: 3,
                    margin:
                    const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(item['title'] ?? 'No Title',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      subtitle:
                      Text(item['description'] ?? 'No Desc'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blue),
                            onPressed: () => _showEditDialog(
                                item['_id'],
                                item['title'],
                                item['description']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () =>
                                deleteData(item['_id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
