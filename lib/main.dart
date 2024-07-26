import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';
// import 'package:to_csv/to_csv.dart' as exportCSV;


// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter File Write',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ExportScreen(),
//     );
//   }
// }
//
// class ExportScreen extends StatefulWidget {
//   @override
//   _ExportScreenState createState() => _ExportScreenState();
// }
//
// class _ExportScreenState extends State<ExportScreen> {
//   int _counter = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Export Data')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _exportData,
//           child: Text('Export'),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _exportData() async {
//     print('Requesting storage permission...');
//     // Request storage permissions
//     if (await _requestStoragePermission()) {
//       print('Storage permission granted.');
//
//       // Get the directory path
//       final directory = Directory('/storage/emulated/0/StocktakeApp');
//
//       if (!await directory.exists()) {
//         print('Creating base directory: $directory');
//         await directory.create(recursive: true);
//       } else {
//         print('Base directory already exists: $directory');
//       }
//
//       // Define the text file path
//       final filePath = '${directory.path}/hello_world.txt';
//       final file = File(filePath);
//
//       try {
//         // Increment counter and write to the file
//         _counter++;
//         final content = 'Hello World $_counter\n';
//
//         // Write to text file
//         print('Writing to text file: $filePath');
//         await file.writeAsString(content, mode: FileMode.append);
//         print('Text file written successfully: $filePath');
//
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data exported to $filePath')));
//       } catch (e) {
//         print('Failed to export data: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to export data: $e')),
//         );
//       }
//     } else {
//       print('Storage permission denied');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Storage permission denied')),
//       );
//     }
//   }
//
//   Future<bool> _requestStoragePermission() async {
//     final status = await Permission.manageExternalStorage.request();
//     if (status == PermissionStatus.granted) {
//       print('Storage permission granted after request.');
//     } else {
//       print('Storage permission denied after request.');
//     }
//     return status == PermissionStatus.granted;
//   }
// }


// for csv
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CSV Export',
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
  List<StockTake> _stockTakes = [
    StockTake(
      stocktakeID: 'STK001',
      barcode: '1234567890123',
      uom: 'Roll',
      location: 'Aisle 1',
      quantity: 10,
      dateTime: DateTime.now(),
    ),
    StockTake(
      stocktakeID: 'STK002',
      barcode: '9876543210987',
      uom: 'Single',
      location: 'Aisle 2',
      quantity: 5,
      dateTime: DateTime.now(),
    ),
    StockTake(
      stocktakeID: 'STK003',
      barcode: '4567891234567',
      uom: 'Roll',
      location: 'Aisle 3',
      quantity: 8,
      dateTime: DateTime.now(),
    ),
    StockTake(
      stocktakeID: 'STK004',
      barcode: '7891234567890',
      uom: 'Single',
      location: 'Aisle 4',
      quantity: 15,
      dateTime: DateTime.now(),
    ),
    StockTake(
      stocktakeID: 'STK005',
      barcode: '3216549873216',
      uom: 'Roll',
      location: 'Aisle 5',
      quantity: 20,
      dateTime: DateTime.now(),
    ),
  ];

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

      // Define the CSV file path
      final filePath = '${directory.path}/stocktake_data.csv';

      // Prepare CSV header and data
      List<List<String>> data = [
        ['StocktakeID', 'Barcode', 'UOM', 'Location', 'Quantity', 'DateTime'],
        ..._stockTakes.map((stockTake) => [
          stockTake.stocktakeID,
          stockTake.barcode,
          stockTake.uom,
          stockTake.location,
          stockTake.quantity.toString(),
          stockTake.dateTime.toIso8601String(),
        ])
      ];

      try {
        // Convert the list to CSV
        String csvData = const ListToCsvConverter().convert(data);

        // Write to CSV file
        final file = File(filePath);
        print('Writing to CSV file: $filePath');
        await file.writeAsString(csvData);
        print('CSV file written successfully: $filePath');

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

class StockTake {
  final String stocktakeID;
  final String barcode;
  final String uom;
  final String location;
  final int quantity;
  final DateTime dateTime;

  StockTake({
    required this.stocktakeID,
    required this.barcode,
    required this.uom,
    required this.location,
    required this.quantity,
    required this.dateTime,
  });
}