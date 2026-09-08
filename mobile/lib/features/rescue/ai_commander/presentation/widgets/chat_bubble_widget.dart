import 'package:flutter/material.dart';
import '../../domain/entities/ai_commander_entities.dart';

/// Bubble widget rendering user and AI Commander tactical messages with action chips.
class ChatBubbleWidget extends StatelessWidget {
  final AIChatMessage message;
  final Function(String suggestion)? onSuggestionTap;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    this.onSuggestionTap,
  });

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ChatSender.user;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.auto_awesome_rounded, size: 16, color: Color(0xFF6366F1)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? theme.colorScheme.primary
                        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                      bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                    ),
                    border: isUser
                        ? null
                        : Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'AI COMMANDER',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6366F1),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                            const SizedBox(width: 3),
                            const Text('TACTICAL LINK', style: TextStyle(fontSize: 8, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        message.text,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: isUser ? Colors.white : (isDark ? Colors.white : const Color(0xFF0F172A)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            fontSize: 9,
                            color: isUser ? Colors.white70 : (isDark ? Colors.white38 : Colors.grey.shade500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isUser && message.actionSuggestions != null && message.actionSuggestions!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: message.actionSuggestions!.map((sugg) {
                      return ActionChip(
                        avatar: const Icon(Icons.bolt_rounded, size: 12, color: Color(0xFF6366F1)),
                        label: Text(sugg, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                        backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        side: BorderSide(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        visualDensity: VisualDensity.compact,
                        onPressed: onSuggestionTap != null ? () => onSuggestionTap!(sugg) : null,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded, size: 16, color: theme.colorScheme.primary),
            ),
          ],
        ],
      ),
    );
  }
}
