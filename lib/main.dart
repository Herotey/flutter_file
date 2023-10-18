import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(storage: Storage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Storage storage;
  const MyHomePage({Key? key, required this.storage}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  TextEditingController controller = TextEditingController();
   String? state;
  Future<Directory>? _appDocDir;
  @override
  void initState() {
    super.initState();
    widget.storage.readData().then((String value) {
      setState(() {
        state = value;
      });
    });
  }

  Future<File> writeData() async {
    setState(() {
      state = controller.text;
      controller.text = '';
    });
    return widget.storage.writeData(state!);
  }

  void getAppDirecotory() {
    setState(() {
      _appDocDir = getApplicationDocumentsDirectory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('testing files'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              state!,
            ),
            TextField(
              controller: controller,
            ),
            TextButton(
                onPressed: writeData, child: const Text('Write to file')),
            TextButton(
                onPressed: getAppDirecotory, child: const Text('Read Data')),
            FutureBuilder<Directory>(
                future: _appDocDir,
                builder:
                    (BuildContext context, AsyncSnapshot<Directory> snapshot) {
                  Text text = const Text('');
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      text = Text('Error ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      text = Text('Path ${snapshot.data!.path}');
                    } else {
                      text = const Text("Unavaible");
                    }
                  }
                  return Container(
                    child: text,
                  );
                }),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class Storage {
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/db.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }
}
