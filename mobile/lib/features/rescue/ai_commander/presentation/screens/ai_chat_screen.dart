import 'package:flutter/material.dart';
import '../../domain/entities/ai_commander_entities.dart';
import '../providers/ai_commander_provider.dart';
import '../widgets/ai_typing_indicator.dart';
import '../widgets/chat_bubble_widget.dart';

/// Interactive AI Tactical Chat Screen (`/rescue/ai/chat`).
class AIChatScreen extends StatefulWidget {
  final AICommanderNotifier? notifier;
  final String? initialPrompt;
  final String? relatedIncidentId;

  const AIChatScreen({
    super.key,
    this.notifier,
    this.initialPrompt,
    this.relatedIncidentId,
  });

  static const String routeName = '/rescue/ai/chat';

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  late final AICommanderNotifier _notifier;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const List<String> mockPrompts = [
    'Analyze flood risk',
    'Suggest evacuation plan',
    'Find safest rescue route',
    'Allocate rescue teams',
    'Resource optimization',
  ];

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? AICommanderDependencies.notifier;
    _notifier.addListener(_onStateChanged);

    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notifier.sendMessage(
          widget.initialPrompt!,
          relatedIncidentId: widget.relatedIncidentId,
        );
      });
    }
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChanged);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendCurrentMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    _notifier.sendMessage(text, relatedIncidentId: widget.relatedIncidentId);
  }

  void _showSessionSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final sessions = _notifier.state.allChatSessions;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'AI Tactical Sessions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      await _notifier.createNewChatSession(title: 'New Incident Session');
                    },
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('New Session'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sessions.length,
                itemBuilder: (_, idx) {
                  final s = sessions[idx];
                  final isCurrent = s.id == _notifier.state.activeChatSession?.id;
                  return ListTile(
                    leading: Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: isCurrent ? Theme.of(context).colorScheme.primary : Colors.grey,
                    ),
                    title: Text(s.title, style: TextStyle(fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal)),
                    subtitle: Text('${s.district} • ${s.messages.length} messages'),
                    trailing: isCurrent ? const Icon(Icons.check_rounded, color: Colors.green) : null,
                    onTap: () {
                      _notifier.selectChatSession(s);
                      Navigator.of(ctx).pop();
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _notifier.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeSession = state.activeChatSession;
    final messages = activeSession?.messages ?? [];

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _showSessionSelector,
          child: Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 18, color: Color(0xFF6366F1)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeSession?.title ?? 'AI Tactical Commander',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${activeSession?.district ?? "General"} • Active Link',
                      style: const TextStyle(fontSize: 10, color: Color(0xFF10B981), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_drop_down_rounded),
            ],
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Clear Chat History',
            icon: const Icon(Icons.cleaning_services_outlined),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear Conversation?'),
                  content: const Text('This will reset the current tactical AI conversation history.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                    ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Clear')),
                  ],
                ),
              );
              if (ok == true) {
                _notifier.clearActiveChatSession();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length + (state.isSendingMessage ? 1 : 0),
              itemBuilder: (context, idx) {
                if (idx < messages.length) {
                  final msg = messages[idx];
                  return ChatBubbleWidget(
                    message: msg,
                    onSuggestionTap: (sugg) {
                      _notifier.sendMessage(sugg);
                    },
                  );
                } else {
                  return const AITypingIndicator();
                }
              },
            ),
          ),

          // Quick Command Suggestion Strip
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              border: Border(
                top: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: mockPrompts.map((p) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6, top: 5, bottom: 5),
                  child: ActionChip(
                    label: Text(p, style: const TextStyle(fontSize: 11)),
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                    side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.25)),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _notifier.sendMessage(p),
                  ),
                );
              }).toList(),
            ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              border: Border(
                top: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Enter mission command or query...',
                        hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (_) => _sendCurrentMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: _sendCurrentMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
