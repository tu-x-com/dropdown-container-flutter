import 'dart:math';

import 'package:dropdown_container/dropdown_container.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TextField with Dropdown',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'TextField with Dropdown'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _textController;
  late final DropdownContainerController _dropdownController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _dropdownController = DropdownContainerController();
  }

  @override
  void dispose() {
    _textController.dispose();
    _dropdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DropdownContainer(
        controller: _dropdownController,
        dropdownBuilder: (context) => Row(
          children: [
            Expanded(
                child: Container(
              color: Color(random.nextInt(0x00FFFFFF) | 0xFF000000),
              child: Image.network(
                  'https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png'),
            )),
            Expanded(
              child: Column(
                  children: _textController.text.characters
                      .map((e) => ListTile(
                            title: Text('$e => ${e.toUpperCase()}'),
                            tileColor:
                                Color(random.nextInt(0x00FFFFFF) | 0xFF000000),
                            onTap: () => ScaffoldMessenger.of(context)
                                .showSnackBar(
                                    SnackBar(content: Text('$e is selected'))),
                          ))
                      .toList()),
            )
          ],
        ),
        child: Focus(
          child: TextField(
              controller: _textController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _dropdownController.open();
                } else {
                  _dropdownController.close();
                }
                _dropdownController.update();
              }),
          onFocusChange: (value) {
            if (value && _textController.text.isNotEmpty) {
              _dropdownController.open();
            } else {
              _dropdownController.close();
            }
          },
        ),
      ),
    );
  }
}
