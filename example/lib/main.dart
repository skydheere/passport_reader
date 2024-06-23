import 'package:flutter/material.dart';
import 'package:passport_reader/passport_reader.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passport Reader Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passport Reader Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _navigateToPassportReader(context);
          },
          child: const Text('Scan Passport'),
        ),
      ),
    );
  }

  void _navigateToPassportReader(BuildContext context) async {
    final apiKey = 'openai_api_key'; // Replace with your actual API key

    final extractedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassportReader(apiKey: apiKey),
      ),
    );

    if (extractedData != null) {
      _showExtractedDataDialog(context, extractedData);
    }
  }

  void _showExtractedDataDialog(
      BuildContext context, Map<String, dynamic> extractedData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Extracted Passport Information'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Name', extractedData['name']),
              _buildTextField('Mother\'s Name', extractedData['mother_name']),
              _buildTextField('Nationality', extractedData['nationality']),
              _buildTextField('Date of Birth', extractedData['dob']),
              _buildTextField('Gender', extractedData['gender']),
              _buildTextField('Passport Number', extractedData['passport_no']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
          const Divider(),
        ],
      ),
    );
  }
}
