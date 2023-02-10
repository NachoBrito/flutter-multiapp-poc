import 'dart:async';

import "dart:developer" as developer;
import 'package:flutter/material.dart';
import 'package:js/js.dart' as js;
import 'package:js/js_util.dart' as js_util;

void main() {
  runApp(const WebComponent2());
}

class WebComponent2 extends StatelessWidget {
  const WebComponent2({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Component 2',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const WebComponent2Home(title: 'Component 2'),
    );
  }
}

class WebComponent2Home extends StatefulWidget {
  const WebComponent2Home({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<WebComponent2Home> createState() => _WebComponent2HomeState();
}

@js.JSExport()
class _WebComponent2HomeState extends State<WebComponent2Home> {
  final _streamController = StreamController<String>.broadcast();
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    final export = js_util.createDartExport(this);
    js_util.setProperty(js_util.globalThis, 'WebComponent2Home_state', export);
    js_util.callMethod<void>(
        js_util.globalThis, 'WebComponent2Home_initState', []);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @js.JSExport()
  void externalEvent(String evt) {
    developer.log("External event: $evt");
    setState(() {
      _counter++;
    });
  }

  void internalEvent(String evt) {
    setState(() {
      _counter++;
      _streamController.add(evt);
    });
  }

  @js.JSExport()
  void addHandler(void Function(String evt) handler) {
    _streamController.stream.listen((event) {
      handler(event);
    });
  }

  @js.JSExport()
  int get count => _counter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void incrementCounter() {
    internalEvent("counter.increase");
  }
}
