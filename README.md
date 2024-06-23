# passport_reader

A Flutter package to read passport information using OpenAI GPT-4-o.

## Features

- Capture passport image using the device camera.
- Extract passport details using OpenAI GPT-4-o API.

 

## Installation

Add `passport_reader` to your `pubspec.yaml`:

```yaml
dependencies:
  passport_reader: ^0.0.1:
```

## Usage
To use this package, first import it in your Dart code:

``` dart 
import 'package:passport_reader/passport_reader.dart';
```


Here's a simple example of how to use passport_reader:

``` dart 
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
      home: PassportReaderExample(),
    );
  }
}

class PassportReaderExample extends StatefulWidget {
  @override
  _PassportReaderExampleState createState() => _PassportReaderExampleState();
}

class _PassportReaderExampleState extends State<PassportReaderExample> {
  Map<String, String> passportData = {};

  Future<void> _scanPassport() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassportReader(
          apiKey: 'YOUR_API_KEY',
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        passportData = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passport Reader Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _scanPassport,
              child: Text('Scan Passport'),
            ),
            if (passportData.isNotEmpty) ...[
              Text('First Name: ${passportData['firstName']}'),
              Text('Middle Name: ${passportData['middleName']}'),
              Text('Last Name: ${passportData['lastName']}'),
              Text('Mother Name: ${passportData['mother_name']}'),
              Text('Nationality: ${passportData['nationality']}'),
              Text('Date of Birth: ${passportData['dob']}'),
              Text('Gender: ${passportData['gender']}'),
              Text('Passport No: ${passportData['passport_no']}'),
            ]
          ],
        ),
      ),
    );
  }
}

```



#### `example/lib/main.dart`

```dart
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
      home: PassportReaderExample(),
    );
  }
}

class PassportReaderExample extends StatefulWidget {
  @override
  _PassportReaderExampleState createState() => _PassportReaderExampleState();
}

class _PassportReaderExampleState extends State<PassportReaderExample> {
  Map<String, String> passportData = {};

  Future<void> _scanPassport() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassportReader(
          apiKey: 'YOUR_API_KEY',
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        passportData = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passport Reader Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _scanPassport,
              child: Text('Scan Passport'),
            ),
            if (passportData.isNotEmpty) ...[
              Text('First Name: ${passportData['firstName']}'),
              Text('Middle Name: ${passportData['middleName']}'),
              Text('Last Name: ${passportData['lastName']}'),
              Text('Mother Name: ${passportData['mother_name']}'),
              Text('Nationality: ${passportData['nationality']}'),
              Text('Date of Birth: ${passportData['dob']}'),
              Text('Gender: ${passportData['gender']}'),
              Text('Passport No: ${passportData['passport_no']}'),
            ]
          ],
        ),
      ),
    );
  }
}
```
## Publisher
This package is published by Imran Adan



