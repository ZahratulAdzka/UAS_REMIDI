import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modul_4/models/photo_model.dart';
import 'package:modul_4/services/photo_db_helper.dart';

class PhotoHistoryScreen extends StatelessWidget {
  const PhotoHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Foto'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<PhotoModel>>(
        future: PhotoDbHelper.instance.getAllPhotos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada foto yang disimpan.'));
          }

          final photos = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.file(
                        File(photo.filePath),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.teal),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(photo.location,
                                style: const TextStyle(fontSize: 14)),
                          ),
                          const Icon(Icons.access_time,
                              size: 16, color: Colors.teal),
                          const SizedBox(width: 4),
                          Text(photo.timestamp,
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
