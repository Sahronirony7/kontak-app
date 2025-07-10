import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../helpers/db_helper.dart';
import '../models/contact.dart';

class AddEditContactPage extends StatefulWidget {
  final Contact? contact;

  const AddEditContactPage({Key? key, this.contact}) : super(key: key);

  @override
  State<AddEditContactPage> createState() => _AddEditContactPageState();
}

class _AddEditContactPageState extends State<AddEditContactPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  String _photoPath = '';

  @override
  void initState() {
    super.initState();
    final contact = widget.contact;
    _firstNameController = TextEditingController(text: contact?.firstName ?? '');
    _lastNameController = TextEditingController(text: contact?.lastName ?? '');
    _phoneNumberController = TextEditingController(text: contact?.phoneNumber ?? '');
    _emailController = TextEditingController(text: contact?.email ?? '');
    _addressController = TextEditingController(text: contact?.address ?? '');
    _photoPath = contact?.photo ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photoPath = pickedFile.path;
      });
    }
  }

  Future<void> _saveContact() async {
    if (_formKey.currentState!.validate()) {
      final newContact = Contact(
        id: widget.contact?.id,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        photo: _photoPath,
      );

      if (widget.contact == null) {
        await DBHelper().insertContact(newContact);
      } else {
        await DBHelper().updateContact(newContact);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Kontak' : 'Tambah Kontak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _photoPath.isNotEmpty
                      ? FileImage(File(_photoPath))
                      : const AssetImage('assets/default_profile.png') as ImageProvider,
                  child: _photoPath.isEmpty
                      ? const Icon(Icons.add_a_photo, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nama Depan'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama depan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Nama Belakang'),
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Nomor HP'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty && !RegExp(r'^[0-9+ ]+$').hasMatch(value)) {
                    return 'Nomor HP tidak valid';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty &&
                      !RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveContact,
                icon: Icon(isEditing ? Icons.save : Icons.add),
                label: Text(isEditing ? 'Perbarui' : 'Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
