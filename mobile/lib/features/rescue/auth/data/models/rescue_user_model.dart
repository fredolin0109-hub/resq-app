import '../../domain/entities/rescue_user.dart';

/// Data Transfer Object for [RescueUser].
class RescueUserModel extends RescueUser {
  const RescueUserModel({
    required super.id,
    required super.rescueId,
    required super.name,
    required super.role,
    required super.teamId,
    super.token,
  });

  factory RescueUserModel.fromJson(Map<String, dynamic> json) {
    return RescueUserModel(
      id: json['id'] as String? ?? '',
      rescueId: json['rescue_id'] as String? ?? json['rescueId'] as String? ?? '',
      name: json['name'] as String? ?? 'Rescue Responder',
      role: json['role'] as String? ?? 'Field Officer',
      teamId: json['team_id'] as String? ?? json['teamId'] as String? ?? 'ALPHA-1',
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rescue_id': rescueId,
      'name': name,
      'role': role,
      'team_id': teamId,
      if (token != null) 'token': token,
    };
  }

  factory RescueUserModel.fromDomain(RescueUser user) {
    return RescueUserModel(
      id: user.id,
      rescueId: user.rescueId,
      name: user.name,
      role: user.role,
      teamId: user.teamId,
      token: user.token,
    );
  }

  RescueUser toDomain() {
    return RescueUser(
      id: id,
      rescueId: rescueId,
      name: name,
      role: role,
      teamId: teamId,
      token: token,
    );
  }
}
