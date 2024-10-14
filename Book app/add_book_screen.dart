import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _pagesController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();

  Future<void> _addBook() async {
    await FirebaseFirestore.instance.collection('books').add({
      'title': _titleController.text,
      'author': _authorController.text,
      'availability': _availabilityController.text,
      'pages': int.tryParse(_pagesController.text) ?? 0,
      'isbn': _isbnController.text,
    });

    // Clear the text fields after adding
    _titleController.clear();
    _authorController.clear();
    _availabilityController.clear();
    _pagesController.clear();
    _isbnController.clear();

    // Optionally, navigate back or show a success message
    Navigator.pop(context);
  }

  void _onDrawerItemTapped(BuildContext context, String routeName) {
    Navigator.pop(context); // Close the drawer
    Navigator.pushNamed(context, routeName); // Navigate to the selected route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open drawer
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Book Management Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () =>
                  _onDrawerItemTapped(context, '/'), // Navigate to Home
            ),
            ListTile(
              title: const Text('Add Book'),
              onTap: () => _onDrawerItemTapped(
                  context, '/addBook'), // Navigate to Add Book
            ),
            ListTile(
              title: const Text('Available Books'),
              onTap: () => _onDrawerItemTapped(
                  context, '/availableBooks'), // Navigate to Available Books
            ),
            ListTile(
              title: const Text('Search Books'),
              onTap: () => _onDrawerItemTapped(
                  context, '/searchBooks'), // Navigate to Search Books
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            TextField(
              controller: _availabilityController,
              decoration: const InputDecoration(labelText: 'Availability'),
            ),
            TextField(
              controller: _pagesController,
              decoration: const InputDecoration(labelText: 'Number of Pages'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _isbnController,
              decoration: const InputDecoration(labelText: 'ISBN'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addBook,
              child: const Text('Add Book'),
            ),
          ],
        ),
      ),
    );
  }
}
