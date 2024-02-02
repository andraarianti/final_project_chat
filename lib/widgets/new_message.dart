//new_message
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:image_picker/image_picker.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  File? _image;
  bool _showImagePreview = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(pickedFile!=null){
      setState(() {
        _image = File(pickedFile.path);
        _showImagePreview = true;
      });
    }
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty && _image == null) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    try {
      if (_image == null) {
        await FirebaseFirestore.instance.collection('chat').add({
          'text': enteredMessage,
          'imageUrl': '',
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'username': userData.data()!['username'],
          'userImage': userData.data()!['image_url'],
        });
      } else {
        // Handle image upload to Storage
        String imageUrl = await uploadImageToStorage(_image!);
        await FirebaseFirestore.instance.collection('chat').add({
          'text': '',
          'imageUrl': imageUrl,
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'username': userData.data()!['username'],
          'userImage': userData.data()!['image_url'],
        });
      }
    } catch (error) {
      print('Error sending message to Firestore: $error');
      // Handle the error as needed
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    try{
      final user = FirebaseAuth.instance.currentUser!;
      //To declare name of image that user upload
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('chat_images')
          .child('${user.uid}_${DateTime.now().microsecondsSinceEpoch}.jpg');
      await storageRef.putFile(imageFile);

      // Use 'putFile' to upload the image to Firebase Storage
      // then retrive the download URL of the uploaded image useing 'getDownloadURL'
      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    }catch (error){
      print('Error Upload Image[WIDGET NEW MESSAGE] -- $error');
      throw error;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(
              Icons.image,
            ),
            onPressed: _pickImage,
          ),
          if (_showImagePreview && _image != null) // Add this condition
            Container(
              width: 40,
              height: 40,
              child: Image.file(_image!),
            ),
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(
              Icons.send,
            ),
            onPressed: _submitMessage,
          ),
        ],
      ),
    );
  }
}