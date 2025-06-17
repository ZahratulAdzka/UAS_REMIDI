import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../models/money_tracker.dart';

class FormScreen extends StatefulWidget {
  final MoneyTracker? existingData;

  const FormScreen({super.key, this.existingData});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedType = 'income';

  File? _imageFile;
  String? _location;
  String? _timestamp;

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      final data = widget.existingData!;
      _amountController.text = data.amount.toString();
      _categoryController.text = data.category;
      _descriptionController.text = data.description;
      _selectedDate = data.date;
      _selectedType = data.type;

      // Jika ada data gambar, lokasi, waktu
      _imageFile = data.imagePath != null ? File(data.imagePath!) : null;
      _location = data.location;
      _timestamp = data.timestamp;
    }
  }

  Future<void> _getLocationAndSave(File image) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) return;
    }

    final position = await Geolocator.getCurrentPosition();
    final location = '${position.latitude}, ${position.longitude}';
    final timestamp = DateFormat('HH:mm:ss').format(DateTime.now());

    await ImageGallerySaver.saveFile(image.path);

    setState(() {
      _imageFile = image;
      _location = location;
      _timestamp = timestamp;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      await _getLocationAndSave(file);
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newTracker = MoneyTracker(
        id: widget.existingData?.id ?? UniqueKey().toString(),
        amount: double.parse(_amountController.text),
        category: _categoryController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        type: _selectedType,
        imagePath: _imageFile?.path,
        location: _location,
        timestamp: _timestamp,
      );

      // Simpan ke backend/database di sini jika pakai service
      // await MoneyTrackerService.save(newTracker);

      Navigator.pop(context, true); // Refresh data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingData != null
            ? 'Edit Transaksi'
            : 'Tambah Transaksi'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Kategori'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Tipe:'),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _selectedType,
                    onChanged: (value) =>
                        setState(() => _selectedType = value!),
                    items: const [
                      DropdownMenuItem(
                          value: 'income', child: Text('Pemasukan')),
                      DropdownMenuItem(
                          value: 'expense', child: Text('Pengeluaran')),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Tanggal:'),
                  const SizedBox(width: 12),
                  Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: const Text('Pilih Tanggal'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Kamera'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text('Galeri'),
                  ),
                ],
              ),
              if (_imageFile != null) ...[
                const SizedBox(height: 12),
                Image.file(_imageFile!, height: 200),
                Text('Lokasi: $_location',
                    style: const TextStyle(fontSize: 12)),
                Text('Waktu: $_timestamp',
                    style: const TextStyle(fontSize: 12)),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: Text(widget.existingData != null ? 'Update' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
