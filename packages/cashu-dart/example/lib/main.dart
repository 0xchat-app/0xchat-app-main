
import 'package:flutter/material.dart';
import 'package:cashu_dart/business/wallet/cashu_manager.dart';


import 'home_page.dart';
import 'main.reflectable.dart';
import 'dart:async';


void main() {
  initializeReflectable();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future setupComplete = CashuManager.shared.setup(
    'test',
    defaultMint: ['https://legend.lnbits.com/cashu/api/v1/AptDNABNBXv8gpuywhx6NV'],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cashu Plugin example app'),
        ),
        body: FutureBuilder(
          future: setupComplete,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const ExamplePage();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        )
      ),
    );
  }
}
