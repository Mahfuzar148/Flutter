import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Management App'),
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
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              title: const Text('Add Book'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/addBook');
              },
            ),
            ListTile(
              title: const Text('Available Books'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/availableBooks');
              },
            ),
            ListTile(
              title: const Text('Search Books'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/searchBooks');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/img/home_page.png',
              fit: BoxFit.cover,
            ),
          ),
          // Encouraging Text aligned at the top
          const Positioned(
            top:
                30, // Adjust this value as needed to place the text higher or lower
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Welcome to the Book Management App! Organize your library, explore new titles, and keep track of all your books easily. Happy reading!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
