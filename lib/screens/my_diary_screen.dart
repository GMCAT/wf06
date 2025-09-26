// lib/screens/my_diary_screen.dart
import 'package:flutter/material.dart';
import 'package:wf06/models/diary_entry.dart'; // แก้ไขชื่อ package ตามโปรเจกต์ของคุณ
import 'package:wf06/screens/add_note_screen.dart'; // แก้ไขชื่อ package ตามโปรเจกต์ของคุณ
import 'package:uuid/uuid.dart'; // ต้องเพิ่มแพ็กเกจ uuid สำหรับสร้าง ID

class MyDiaryScreen extends StatefulWidget {
  const MyDiaryScreen({super.key});

  @override
  State<MyDiaryScreen> createState() => _MyDiaryScreenState();
}

class _MyDiaryScreenState extends State<MyDiaryScreen> {
  List<DiaryEntry> diaryEntries = [];
  final Uuid _uuid = const Uuid(); // สร้าง instance ของ Uuid

  @override
  void initState() {
    super.initState();
    // เพิ่มข้อมูลตัวอย่างเริ่มต้น
    diaryEntries.add(
      DiaryEntry(
        id: _uuid.v4(),
        title: 'สาหร่ายน้ำ',
        content: 'Start with soft boiled eggs, bacon, boiled vegetables, steamed fish and black coffee.',
        timestamp: DateTime(2024, 8, 31, 11, 24),
      ),
    );
    diaryEntries.add(
      DiaryEntry(
        id: _uuid.v4(),
        title: 'ทำแผนการทำงานรายวันให้เสร็จก่อน 15.00 น.',
        content: '',
        timestamp: DateTime(2024, 8, 31, 11, 27),
      ),
    );
    diaryEntries.add(
      DiaryEntry(
        id: _uuid.v4(),
        title: 'ตรวจสอบออกกำลังกาย',
        content: '07.00 คาร์ดิโอ',
        timestamp: DateTime(2024, 8, 31, 11, 28),
      ),
    );
  }

  // ฟังก์ชันสำหรับเพิ่มบันทึกใหม่
  void _addEntry(DiaryEntry newEntry) {
    setState(() {
      diaryEntries.add(newEntry);
      // เรียงลำดับตามเวลาล่าสุด
      diaryEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  // ฟังก์ชันสำหรับอัปเดตบันทึก
  void _updateEntry(DiaryEntry updatedEntry) {
    setState(() {
      final index = diaryEntries.indexWhere((entry) => entry.id == updatedEntry.id);
      if (index != -1) {
        diaryEntries[index] = updatedEntry;
        // เรียงลำดับตามเวลาล่าสุด
        diaryEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }
    });
  }

  // ฟังก์ชันสำหรับลบบันทึก
  void _deleteEntry(String entryId) {
    setState(() {
      diaryEntries.removeWhere((entry) => entry.id == entryId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('บันทึกถูกลบแล้ว')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // ในแอปจริง คุณจะโหลดข้อมูลใหม่จากฐานข้อมูลที่นี่
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Refreshing data...')),
              );
              setState(() {
                // ตัวอย่างการรีเฟรช (ถ้ามีข้อมูลจากแหล่งภายนอก)
                // ณ ตอนนี้คือไม่มีอะไรให้รีเฟรชเพราะข้อมูลอยู่ใน memory
              });
            },
          ),
        ],
      ),
      body: diaryEntries.isEmpty
          ? const Center(
              child: Text(
                'No diary entries yet. Tap the + button to add one!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: diaryEntries.length,
              itemBuilder: (context, index) {
                final entry = diaryEntries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 2,
                  child: InkWell( // ทำให้ Card คลิกได้
                    onTap: () async {
                      // เมื่อคลิกที่รายการ เพื่อแก้ไข
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNoteScreen(entry: entry), // ส่ง entry ไปแก้ไข
                        ),
                      );
                      if (result != null && result is DiaryEntry) {
                        _updateEntry(result); // อัปเดตบันทึกที่แก้ไขแล้ว
                      }
                    },
                    onLongPress: () {
                      // เมื่อกดค้าง เพื่อลบ
                      _showDeleteConfirmationDialog(entry.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // วันที่
                          Container(
                            width: 60,
                            alignment: Alignment.center,
                            child: Text(
                              entry.formattedDate, // ใช้ formattedDate จาก Model
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // เนื้อหา
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.formattedTime, // ใช้ formattedTime จาก Model
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  entry.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (entry.content.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    entry.content,
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // ปุ่มลบ (ถ้าต้องการ) - แต่เราจะใช้ LongPress แทน
                          // IconButton(
                          //   icon: const Icon(Icons.delete, color: Colors.grey),
                          //   onPressed: () => _showDeleteConfirmationDialog(entry.id),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // ไปยังหน้า Add Note และรอผลลัพธ์กลับมา
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );
          if (result != null && result is DiaryEntry) {
            _addEntry(result); // เพิ่มบันทึกใหม่ที่ได้รับกลับมา
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Dialog สำหรับยืนยันการลบ
  Future<void> _showDeleteConfirmationDialog(String entryId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // ผู้ใช้ต้องกดปุ่ม
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('คุณแน่ใจหรือไม่ว่าต้องการลบบันทึกนี้?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ลบ'),
              onPressed: () {
                _deleteEntry(entryId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}