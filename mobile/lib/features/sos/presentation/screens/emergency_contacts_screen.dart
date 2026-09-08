import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/emergency_contact.dart';
import '../../data/local/contacts_repository.dart';
import '../../application/call_service.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final ContactsRepository _repository = ContactsRepository();
  final CallService _callService = CallService();
  List<EmergencyContact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final contacts = await _repository.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  Future<void> _addContact() async {
    // A simple prompt to add a contact (in a real app, you'd use a form)
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name (e.g. Father)')),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                final newContact = EmergencyContact(
                  id: const Uuid().v4(),
                  name: nameController.text,
                  phoneNumber: phoneController.text,
                  relationship: 'Family',
                  priority: _contacts.length + 1,
                );
                await _repository.addContact(newContact);
                Navigator.pop(context);
                _loadContacts();
              }
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _contacts.length + 1,
        itemBuilder: (context, index) {
          if (index == _contacts.length) {
            return ListTile(
              leading: const Icon(Icons.local_hospital, color: Colors.red),
              title: const Text('Emergency Services'),
              subtitle: const Text('112'),
              trailing: IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () => _callService.callEmergencyServices(),
              ),
            );
          }
          final contact = _contacts[index];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(contact.name),
            subtitle: Text(contact.phoneNumber),
            trailing: IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: () => _callService.callNumber(contact.phoneNumber),
            ),
            onLongPress: () async {
              await _repository.deleteContact(contact.id);
              _loadContacts();
            },
          );
        },
      ),
    );
  }
}
