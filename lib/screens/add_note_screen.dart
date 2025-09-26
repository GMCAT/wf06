// lib/screens/add_note_screen.dart
import 'package:flutter/material.dart';
import 'package:wf06/models/diary_entry.dart'; // แก้ไขชื่อ package ตามโปรเจกต์ของคุณ
import 'package:uuid/uuid.dart'; // ต้องเพิ่มแพ็กเกจ uuid สำหรับสร้าง ID

class AddNoteScreen extends StatefulWidget {
  final DiaryEntry? entry; // สามารถเป็น null ได้ถ้าเป็นการเพิ่มใหม่

  const AddNoteScreen({super.key, this.entry});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final Uuid _uuid = const Uuid(); // สร้าง instance ของ Uuid

  bool _isEditing = false; // ตรวจสอบว่ากำลังแก้ไขอยู่หรือไม่

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _isEditing = true;
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final String title = _titleController.text.trim();
    final String content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาใส่ชื่อเรื่องหรือเนื้อหา')),
      );
      return;
    }

    DiaryEntry resultEntry;
    if (_isEditing) {
      // ถ้าเป็นการแก้ไข ให้ใช้ ID เดิมและอัปเดตข้อมูล
      resultEntry = DiaryEntry(
        id: widget.entry!.id,
        title: title,
        content: content,
        timestamp: DateTime.now(), // อัปเดตเวลาล่าสุดเมื่อแก้ไข
      );
    } else {
      // ถ้าเป็นการเพิ่มใหม่ ให้สร้าง ID ใหม่และเวลาปัจจุบัน
      resultEntry = DiaryEntry(
        id: _uuid.v4(), // สร้าง ID ใหม่
        title: title,
        content: content,
        timestamp: DateTime.now(),
      );
    }
    Navigator.pop(context, resultEntry); // ส่ง DiaryEntry กลับไป
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit note' : 'Add note'), // เปลี่ยน Title ตามสถานะ
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              maxLines: null,
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Start typing here......',
                  border: InputBorder.none,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}