import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter File Write',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExportScreen(),
    );
  }
}

class ExportScreen extends StatefulWidget {
  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Export Data')),
      body: Center(
        child: ElevatedButton(
          onPressed: _exportData,
          child: Text('Export'),
        ),
      ),
    );
  }

  Future<void> _exportData() async {
    print('Requesting storage permission...');
    // Request storage permissions
    if (await _requestStoragePermission()) {
      print('Storage permission granted.');

      // Get the directory path
      final directory = Directory('/storage/emulated/0/StocktakeApp');

      if (!await directory.exists()) {
        print('Creating base directory: $directory');
        await directory.create(recursive: true);
      } else {
        print('Base directory already exists: $directory');
      }

      // Define the text file path
      final filePath = '${directory.path}/hello_world.txt';
      final file = File(filePath);

      try {
        // Increment counter and write to the file
        _counter++;
        final content = 'Hello World $_counter\n';

        // Write to text file
        print('Writing to text file: $filePath');
        await file.writeAsString(content, mode: FileMode.append);
        print('Text file written successfully: $filePath');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data exported to $filePath')));
      } catch (e) {
        print('Failed to export data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export data: $e')),
        );
      }
    } else {
      print('Storage permission denied');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  Future<bool> _requestStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();
    if (status == PermissionStatus.granted) {
      print('Storage permission granted after request.');
    } else {
      print('Storage permission denied after request.');
    }
    return status == PermissionStatus.granted;
  }
}
