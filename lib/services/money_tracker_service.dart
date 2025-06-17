import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modul_4/models/money_tracker.dart';

class MoneyTrackerService {
  static const String baseUrl =
      'https://restapifirebase-e2316-default-rtdb.firebaseio.com/money_tracker';

  static const String authParam =
      '?auth=cLuhAhrphf7HlI9zPyKatBDjGB0UcCjY1oaN0rRs';

  // GET / READ
  static Future<List<MoneyTracker>> fetchData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl.json$authParam'));
      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);
        if (data == null) return [];

        return data.entries.map((entry) {
          return MoneyTracker.fromJson(entry.key, entry.value);
        }).toList();
      } else {
        throw Exception('Failed to load money tracker data');
      }
    } catch (e) {
      print('Error fetching money tracker data: $e');
      rethrow;
    }
  }

  // CREATE
  static Future<void> addData(MoneyTracker tracker) async {
    final response = await http.post(
      Uri.parse('$baseUrl.json$authParam'),
      body: json.encode(tracker.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add data');
    }
  }

  // UPDATE
  static Future<void> updateData(String id, MoneyTracker tracker) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id.json$authParam'),
      body: json.encode(tracker.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update data');
    }
  }

  // DELETE
  static Future<void> deleteData(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id.json$authParam'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete data');
    }
  }
}
