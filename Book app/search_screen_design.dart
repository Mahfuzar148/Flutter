import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening URLs

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<DocumentSnapshot> books = [];
  List<DocumentSnapshot> filteredBooks = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final int _selectedIndex =
      3; // To track the selected index for bottom navigation

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('books')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        books = snapshot.docs;
        filteredBooks = [];
      });
    });
  }

  void _searchBooks() {
    final query = _searchController.text.toLowerCase();
    final minPrice = _minPriceController.text.isNotEmpty
        ? double.tryParse(_minPriceController.text) ?? 0
        : 0;
    final maxPrice = _maxPriceController.text.isNotEmpty
        ? double.tryParse(_maxPriceController.text) ?? double.infinity
        : double.infinity;

    final filtered = books.where((book) {
      final bookData = book.data() as Map<String, dynamic>;
      final title = (bookData['title'] ?? '').toLowerCase();
      final author = (bookData['author'] ?? '').toLowerCase();
      final isbn = (bookData['isbn']?.toString() ?? '').toLowerCase();
      final category = (bookData['category'] ?? '').toLowerCase();
      final price = (bookData['price'] ?? 0).toDouble();

      return (title.contains(query) ||
              author.contains(query) ||
              isbn.contains(query) ||
              category.contains(query)) &&
          price >= minPrice &&
          price <= maxPrice;
    }).toList();

    setState(() {
      filteredBooks = filtered;
    });
  }

  void _onSearchButtonPressed() {
    _searchBooks();
  }

  // Function to open URLs like PDF or contact
  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Book Management Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.blue),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                },
              ),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.blue),
                title: const Text('Add Book'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/addBook');
                },
              ),
              ListTile(
                leading: const Icon(Icons.book, color: Colors.blue),
                title: const Text('Available Books'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/availableBooks');
                },
              ),
              ListTile(
                leading: const Icon(Icons.search, color: Colors.blue),
                title: const Text('Search Books'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/searchBooks');
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.lightBlueAccent,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.book,
                  size: 64,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Search for books by title, author, ISBN, category, or price range.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Min Price',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _maxPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Max Price',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _onSearchButtonPressed,
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredBooks.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      final bookData = book.data() as Map<String, dynamic>;
                      final imageUrl = bookData['image'] ?? '';
                      final pdfUrl = bookData['pdf'] ?? '';
                      final contactEmail = bookData['contact'] ??
                          'contact@bookstore.com'; // Assuming contact field is available

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    width: 80,
                                    height: 100,
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bookData['title'] ?? 'Unknown Title',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          'Author: ${bookData['author'] ?? 'Unknown Author'}',
                                        ),
                                        Text(
                                          'Pages: ${bookData['pages'] ?? 'N/A'}',
                                        ),
                                        Text(
                                          'Price: \$${bookData['price'] ?? 'N/A'}',
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.picture_as_pdf),
                                    label: const Text('View PDF'),
                                    onPressed: () {
                                      _launchUrl(pdfUrl);
                                    },
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.email),
                                    label: const Text('Contact to Buy'),
                                    onPressed: () {
                                      _launchUrl('mailto:$contactEmail');
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text('No results found')),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal,
        selectedItemColor: const Color.fromRGBO(20, 201, 71, 1),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            // Implement the necessary actions based on the index
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add Book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Available Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search Books',
          ),
        ],
      ),
    );
  }
}
