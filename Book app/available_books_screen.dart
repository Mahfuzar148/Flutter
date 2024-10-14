import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AvailableBooksScreen extends StatelessWidget {
  const AvailableBooksScreen({super.key});

  void _onDrawerItemTapped(BuildContext context, String routeName) {
    Navigator.pop(context); // Close the drawer
    Navigator.pushNamed(context, routeName); // Navigate to the selected route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Books'),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading books'));
          }
          final books = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final bookData = books[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(bookData['title']),
                subtitle: Text('Author: ${bookData['author']}'),
                trailing: Text('ISBN: ${bookData['isbn']}'),
              );
            },
          );
        },
      ),
    );
  }
}
