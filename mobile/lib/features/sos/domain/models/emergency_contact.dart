class EmergencyContact {
  final String id;
  final String name;
  final String phoneNumber;
  final String relationship;
  final int priority;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    this.priority = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'relationship': relationship,
      'priority': priority,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phone_number'],
      relationship: map['relationship'],
      priority: map['priority'] ?? 0,
    );
  }
}
