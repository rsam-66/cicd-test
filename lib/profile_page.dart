// profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName;
  String? userEmail;
  bool isLoading = true;
  String? errorMessage;

  String? profileImageUrl; // URL dari API setelah upload
  File? _imageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        throw Exception('User ID not found.');
      }

      final response = await http.post(
        Uri.parse('https://rizzhoma-mobile-app.onrender.com/api/getDataUser'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userID': userId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'][0];

        setState(() {
          userName = data['username'];
          userEmail = data['email'];
          isLoading = false;
          profileImageUrl = data['profileImageUrl'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> pickAndUploadImage() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://rizzhoma-mobile-app.onrender.com/api/uploadImage'),
    );

    request.files.add(await http.MultipartFile.fromPath('image', pickedFile.path));

    var res = await request.send();

    if (res.statusCode == 200) {
      final resBody = await res.stream.bytesToString();
      final data = jsonDecode(resBody);

      String uploadedImageUrl = data['imageUrl'];

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId != null) {
        // Update user profile di database Anda dengan imageUrl yang baru di-upload
        await updateProfileImage(userId: userId.toString(), imageUrl: uploadedImageUrl);

        setState(() {
          profileImageUrl = uploadedImageUrl;
        });
      } else {
        print('User ID tidak ditemukan di session, mungkin user belum login.');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: ${res.statusCode}')),
      );
    }
  }
}


  Future<void> updateProfileImage({required String userId, required String imageUrl}) async {
    final response = await http.post(
      Uri.parse('https://rizzhoma-mobile-app.onrender.com/api/updateProfile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userID': userId,
        'profileImageUrl': imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
    } else {
      print('Failed to update profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                profileImageUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(profileImageUrl!),
                  )
                : _imageFile != null
                    ? CircleAvatar(
                        backgroundImage: FileImage(_imageFile!),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
            SizedBox(width: 10),
            
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$userName',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('$userEmail'),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: pickAndUploadImage,
              child: Text('Upload Profile Picture'),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('My orders'),
              subtitle: Text('Already have 12 orders'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text('Shipping addresses'),
              subtitle: Text('3 Addresses'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text('Payment methods'),
              subtitle: Text('m-banking'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text('Promocodes'),
              subtitle: Text('You have special promo codes'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text('My reviews'),
              subtitle: Text('Reviews for 4 items'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text('Settings'),
              subtitle: Text('Privacy, password'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
