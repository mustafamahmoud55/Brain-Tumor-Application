import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'print_screen.dart';

Future<void> _ensurePermissions() async {
  await [
    Permission.storage,
    Permission.camera,
  ].request();
}



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
void initState() {
  super.initState();
  _ensurePermissions();
}


  _showOptions(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Make a choice'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () => _imageFromGallery(context),
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () => _imageFromCamera(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _imageFromGallery(BuildContext context) async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        imageFile = File(image.path);
      }
    });
    Navigator.pop(context);
  }

  Future _imageFromCamera(BuildContext context) async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        imageFile = File(image.path);
      }
    });
    Navigator.pop(context);
  }

  Future<void> _uploadImage() async {
    if (imageFile == null) return;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://0fa8-156-205-182-128.ngrok-free.app/upload'),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // The key expected by the server
        imageFile!.path,
      ),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      var bytes = response.bodyBytes;
      var pdfPath = await _saveFile(bytes);
      print('PDF saved successfully! Path: $pdfPath');

      // Navigate to PrintScreen with the pdfPath after saving the file
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrintScreen(pdfPath: pdfPath),
        ),
      );
    } else {
      print('Image upload failed with status: ${response.statusCode}');
    }
  }

  Future<String> _saveFile(List<int> bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/Report1.pdf';
    File file = File(path);
    await file.writeAsBytes(bytes);
    return path;
  }

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload MRI Image!'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageFile != null
                  ? Image.file(
                      imageFile!,
                      width: 400,
                      height: 400,
                    )
                  : Text('There is no image',
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
              Text(
                user.email!,
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        color: Colors.amber[900],
                        child: const Text('Sign out!'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: MaterialButton(
                        onPressed: _uploadImage,
                        color: Colors.blue[900],
                        child: const Text('Upload'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showOptions(context),
        child: const Icon(
          Icons.add_photo_alternate,
        ),
      ),
    );
  }
}
