import 'package:drivest_office/home/pages/profile/my_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../widgets/profile_page_app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  static const primary = Color(0xff015093);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('user_name') ?? 'Guest';
      emailController.text = prefs.getString('user_email') ?? 'guest@gmail.com';
      dobController.text = prefs.getString('user_dob') ?? '23/09/02';
      addressController.text = prefs.getString('user_address') ?? '2464 Royal Ln. Mesa, New Jersey 45463';
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text = DateFormat('dd/MM/yy').format(picked);
      });
    }
  }

  Future<void> _updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', nameController.text.trim());
    await prefs.setString('user_dob', dobController.text.trim());
    await prefs.setString('user_address', addressController.text.trim());
    // email is usually not editable, so skip saving it

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const DrivestAppBar(title: "Edit Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: _image == null
                        ? Image.asset('assets/images/profile.jpg.png', width: 140, height: 140, fit: BoxFit.cover)
                        : Image.file(_image!, width: 140, height: 140, fit: BoxFit.cover),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: primary,
                      child: IconButton(
                        icon: const Icon(Icons.add_a_photo_outlined, size: 16, color: Colors.white),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Full Name
            const Text('Full Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter full name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),

            // Date of Birth
            const Text('Date of Birth', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextField(
              controller: dobController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Select date of birth',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Email
            const Text('Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),

            // Address
            const Text('Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: 'Enter address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 8,
                  shadowColor: primary.withOpacity(.35),
                ),
                child: const Text('Update', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
