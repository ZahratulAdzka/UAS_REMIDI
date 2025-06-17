import 'package:intl/intl.dart';
class MoneyTracker {
  final String id;
  final double amount;
  final String type;
  final String category;
  final String description;
  final DateTime date;

  MoneyTracker({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.description,
    required this.date,
  });

  factory MoneyTracker.fromJson(String id, Map<String, dynamic> json) {
    return MoneyTracker(
      id: id,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      category: json['category'],
      description: json['description'],
      date: DateTime.parse(json['date']), // yyyy-MM-dd
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
      'date': DateFormat('yyyy-MM-dd').format(date), // SIMPAN sebagai string tanggal saja
    };
  }
}
