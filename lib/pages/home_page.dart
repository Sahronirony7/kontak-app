import 'package:flutter/material.dart';
import 'dart:io';

import '../helpers/db_helper.dart';
import 'add_edit_contact.dart';
import '../models/contact.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Contact>> _contacts;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    _contacts = DBHelper().getContacts();
  }

  Future<void> _refreshContacts() async {
    setState(_loadContacts);
  }

  Future<void> _deleteContact(int id) async {
    await DBHelper().deleteContact(id);
    _refreshContacts();
  }

  void _navigateToAddEdit({Contact? contact}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditContactPage(contact: contact),
      ),
    );
    _refreshContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kontak Telepon'),
      ),
      body: FutureBuilder<List<Contact>>(
        future: _contacts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            );
          }

          final contacts = snapshot.data;

          if (contacts == null || contacts.isEmpty) {
            return const Center(
              child: Text('Tidak ada kontak yang tersedia.'),
            );
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              final imageFile = File(contact.photo);
              final imageProvider = imageFile.existsSync()
                  ? FileImage(imageFile)
                  : const AssetImage('assets/default_profile.png') as ImageProvider;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: imageProvider,
                ),
                title: Text('${contact.firstName} ${contact.lastName}'),
                subtitle: Text(contact.phoneNumber),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteContact(contact.id!),
                ),
                onTap: () => _navigateToAddEdit(contact: contact),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _navigateToAddEdit(),
      ),
    );
  }
}
