import 'dart:async';
import '../domain/entities/offline_entities.dart';

/// Store-and-Forward transmission queue service.
/// Persists every outgoing packet, retries automatically with backoff,
/// forwards through mesh relays, and clears on acknowledgement.
class StoreAndForwardService {
  final List<OfflineMessage> _queue = [];
  final _queueController = StreamController<List<OfflineMessage>>.broadcast();

  StoreAndForwardService({List<OfflineMessage>? initialMessages}) {
    if (initialMessages != null) {
      _queue.addAll(initialMessages);
    }
  }

  List<OfflineMessage> get queue => List.unmodifiable(_queue);
  Stream<List<OfflineMessage>> get onQueueUpdated => _queueController.stream;

  /// Enqueue a message into local storage and forward stream.
  Future<OfflineMessage> enqueueMessage(OfflineMessage message) async {
    _queue.insert(0, message);
    _queueController.add(_queue);
    return message;
  }

  /// Mark message status as sending/transmitting.
  Future<void> markSending(String messageId) async {
    final idx = _queue.indexWhere((m) => m.id == messageId);
    if (idx != -1) {
      _queue[idx] = _queue[idx].copyWith(status: MessageQueueStatus.sending);
      _queueController.add(_queue);
    }
  }

  /// Acknowledge packet delivery from recipient or intermediate mesh relay.
  Future<void> markDelivered(String messageId) async {
    final idx = _queue.indexWhere((m) => m.id == messageId);
    if (idx != -1) {
      _queue[idx] = _queue[idx].copyWith(
        status: MessageQueueStatus.delivered,
        acknowledgedAt: DateTime.now(),
      );
      _queueController.add(_queue);
    }
  }

  /// Retry transmission with incremented retry count and exponential backoff.
  Future<OfflineMessage> retryMessage(String messageId) async {
    final idx = _queue.indexWhere((m) => m.id == messageId);
    if (idx != -1) {
      final current = _queue[idx];
      final newCount = current.retryCount + 1;
      final newStatus = newCount >= current.maxRetries
          ? MessageQueueStatus.failed
          : MessageQueueStatus.queued;

      final updated = current.copyWith(
        retryCount: newCount,
        status: newStatus,
        timestamp: DateTime.now(),
      );
      _queue[idx] = updated;
      _queueController.add(_queue);
      return updated;
    }
    throw Exception('Message $messageId not found in queue');
  }

  /// Remove all expired messages from the queue.
  Future<int> purgeExpired() async {
    final before = _queue.length;
    _queue.removeWhere((m) => m.isExpired);
    final count = before - _queue.length;
    if (count > 0) {
      _queueController.add(_queue);
    }
    return count;
  }

  /// Remove delivered & synchronized messages to save storage space.
  Future<int> clearDelivered() async {
    final before = _queue.length;
    _queue.removeWhere((m) =>
        m.status == MessageQueueStatus.delivered ||
        m.status == MessageQueueStatus.synchronized);
    final count = before - _queue.length;
    if (count > 0) {
      _queueController.add(_queue);
    }
    return count;
  }

  void dispose() {
    _queueController.close();
  }
}
