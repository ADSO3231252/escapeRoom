import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Saves and loads Level 3's progress locally, using its own storage key
/// (prefixed with "level3_") so it never touches the shared
/// lib/services/progress_service.dart file other teams may also be using.
class Level3ProgressService {
  static const String _storageKey = 'level3_progress';

  Future<void> saveProgress(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
