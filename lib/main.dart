import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///
  static const batteryMethodChannel = MethodChannel(
      'com.sabikrahat.flutter_method_channel_playground/battery');

  ///
  String? batteryLevelStatus;

  ///
  Future<void> getBatteryLevel() async {
    try {
      final arguments = <String, dynamic>{
        'name': 'Sabik Rahat',
        'task': 'Flutter Method Channel Demo',
      };
      final String res = await batteryMethodChannel.invokeMethod('getBatteryLevel', arguments);
      debugPrint('Method Channel Response: $res');
      setState(() => batteryLevelStatus = res);
    } on PlatformException catch (e) {
      debugPrint('Error: ${e.message}');
      setState(() => batteryLevelStatus = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Method Channel Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              batteryLevelStatus == null
                  ? 'Tap to get battery level'
                  : batteryLevelStatus!,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async => await getBatteryLevel(),
              child: const Text('Get Battery Level'),
            ),
          ],
        ),
      ),
    );
  }
}
