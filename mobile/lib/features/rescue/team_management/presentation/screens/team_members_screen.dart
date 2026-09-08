import 'package:flutter/material.dart';
import '../../domain/entities/team_management_entities.dart';
import '../widgets/member_list_tile.dart';

/// Screen listing squad personnel with credentials, certifications, and roles.
class TeamMembersScreen extends StatelessWidget {
  final RescueTeamDetailEntity team;

  const TeamMembersScreen({
    super.key,
    required this.team,
  });

  static const String routeName = '/rescue/teams/members';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${team.name} • Personnel'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: team.members.length,
          itemBuilder: (context, index) {
            final member = team.members[index];
            return MemberListTile(member: member);
          },
        ),
      ),
    );
  }
}
