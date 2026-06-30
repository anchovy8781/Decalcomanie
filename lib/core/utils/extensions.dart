import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  String toKoreanDate() {
    return DateFormat('yyyy년 MM월 dd일', 'ko_KR').format(this);
  }

  String toRelativeTime() {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}주 전';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}개월 전';
    return '${(diff.inDays / 365).floor()}년 전';
  }
}

extension IntFormatting on int {
  String toSubscriberCount() {
    if (this >= 100000000) return '${(this / 100000000).toStringAsFixed(1)}억';
    if (this >= 10000) return '${(this / 10000).toStringAsFixed(1)}만';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}천';
    return toString();
  }
}

extension StringExtension on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
