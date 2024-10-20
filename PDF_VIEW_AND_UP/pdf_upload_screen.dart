import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

class UploadPdfScreen extends StatefulWidget {
  const UploadPdfScreen({super.key});

  @override
  _UploadPdfScreenState createState() => _UploadPdfScreenState();
}

class _UploadPdfScreenState extends State<UploadPdfScreen> {
  File? _pdfFile;
  String? _uploadedFileURL;
  bool _isUploading = false;

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadPdf(BuildContext context) async {
    if (_pdfFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      String fileName = basename(_pdfFile!.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('book_pdf/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_pdfFile!);

      await uploadTask.whenComplete(() async {
        String downloadURL = await firebaseStorageRef.getDownloadURL();
        setState(() {
          _uploadedFileURL = downloadURL; // Store the download URL
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF uploaded successfully!')),
        );
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload PDF: $error')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _viewPdf(BuildContext context) {
    if (_uploadedFileURL != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerPage(filePath: _uploadedFileURL!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload PDF')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickPdf,
              child: const Text('Pick PDF'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _uploadPdf(context),
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Upload Your PDF'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _uploadedFileURL != null ? () => _viewPdf(context) : null,
              child: const Text('View Uploaded PDF'),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFViewerPage extends StatelessWidget {
  final String filePath;

  const PDFViewerPage({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View PDF"),
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
        onRender: (pages) {
          // PDF rendered callback
        },
        onError: (error) {
          // Error callback
          print(error.toString());
        },
        onPageError: (page, error) {
          // Page error callback
          print('Page $page: ${error.toString()}');
        },
      ),
    );
  }
}
