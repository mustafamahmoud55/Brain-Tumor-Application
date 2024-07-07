import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

class PrintScreen extends StatelessWidget {
  final String pdfPath;

  const PrintScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Print PDF'),
      ),
      body: FutureBuilder<bool>(
        future: _checkFileExists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!) {
            return Center(child: Text('File not found at path: $pdfPath'));
          } else {
            return PDFView(
              filePath: pdfPath,
              onRender: (_pages) {
                print('Document rendered with $_pages pages');
              },
              onError: (error) {
                print('Error loading PDF: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error loading PDF: $error')),
                );
              },
              onPageError: (page, error) {
                print('Error on page $page: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error on page $page: $error')),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<bool> _checkFileExists() async {
    return File(pdfPath).exists();
  }
}
