import 'package:flutter/foundation.dart';

/// Represents an authenticated Rescue Personnel within the ResQLink AI platform.
@immutable
class RescueUser {
  final String id;
  final String rescueId;
  final String name;
  final String role;
  final String teamId;
  final String? token;

  const RescueUser({
    required this.id,
    required this.rescueId,
    required this.name,
    required this.role,
    required this.teamId,
    this.token,
  });

  RescueUser copyWith({
    String? id,
    String? rescueId,
    String? name,
    String? role,
    String? teamId,
    String? token,
  }) {
    return RescueUser(
      id: id ?? this.id,
      rescueId: rescueId ?? this.rescueId,
      name: name ?? this.name,
      role: role ?? this.role,
      teamId: teamId ?? this.teamId,
      token: token ?? this.token,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RescueUser &&
        other.id == id &&
        other.rescueId == rescueId &&
        other.name == name &&
        other.role == role &&
        other.teamId == teamId &&
        other.token == token;
  }

  @override
  int get hashCode => Object.hash(id, rescueId, name, role, teamId, token);

  @override
  String toString() {
    return 'RescueUser(id: $id, rescueId: $rescueId, name: $name, role: $role, teamId: $teamId)';
  }
}
