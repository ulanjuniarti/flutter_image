import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DisplayImagePage extends StatefulWidget {
  @override
  _DisplayImagePageState createState() => _DisplayImagePageState();
}

class _DisplayImagePageState extends State<DisplayImagePage> {
  List<Map<String, dynamic>> imageList = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    final response = await http.get(Uri.parse("http://10.10.24.130/flutter_image/fetch_images.php"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        imageList = List<Map<String, dynamic>>.from(jsonData);
      });
    } else {
      // Handle error
      print("Failed to fetch images: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: ListView.builder(
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          final imageInfo = imageList[index];
          final imageUrl = "http://10.10.24.130/flutter_image/uploads/${imageInfo['file_name']}";

          return ListTile(
            contentPadding: EdgeInsets.all(8.0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  imageUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8.0),
                Text(
                  imageInfo['description'],
                  style: TextStyle(
                    fontSize: 16.0,

                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
