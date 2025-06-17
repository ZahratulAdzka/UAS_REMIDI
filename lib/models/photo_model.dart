class PhotoModel {
  final int? id;
  final String filePath;
  final String location;
  final String timestamp;

  PhotoModel({
    this.id,
    required this.filePath,
    required this.location,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filePath': filePath,
      'location': location,
      'timestamp': timestamp,
    };
  }

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    return PhotoModel(
      id: map['id'],
      filePath: map['filePath'],
      location: map['location'],
      timestamp: map['timestamp'],
    );
  }
}
