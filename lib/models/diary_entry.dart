// lib/models/diary_entry.dart
class DiaryEntry {
  String id; // เพิ่ม ID สำหรับการลบและแก้ไข
  String title;
  String content;
  DateTime timestamp; // ใช้ DateTime แทน String สำหรับเวลา

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  // Helper สำหรับการแสดงวันที่และเวลา
  String get formattedDate {
    return '${_getMonthAbbr(timestamp.month)} ${timestamp.day}\n${timestamp.year}';
  }

  String get formattedTime {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final ampm = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')} $ampm';
  }

  String _getMonthAbbr(int month) {
    switch (month) {
      case 1: return 'JAN';
      case 2: return 'FEB';
      case 3: return 'MAR';
      case 4: return 'APR';
      case 5: return 'MAY';
      case 6: return 'JUN';
      case 7: return 'JUL';
      case 8: return 'AUG';
      case 9: return 'SEP';
      case 10: return 'OCT';
      case 11: return 'NOV';
      case 12: return 'DEC';
      default: return '';
    }
  }
}