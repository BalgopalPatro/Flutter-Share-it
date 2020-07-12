import 'dart:io' show File, Platform;
import 'package:flutter/material.dart';

import 'package:share_it/share_it.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart'
    show getExternalStorageDirectory, getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;

class UsingShareIt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ShareIt',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Share File Using Share_it'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/photo.jpg', width: 100),
              FlatButton(
                child: Text('Share image'),
                onPressed: () async {
                  ShareIt.file(
                      path: await _imageBundlePath,
                      type: ShareItFileType.image);
                },
              ),
              FlatButton(
                child: Text('Share file'),
                onPressed: () async {
                  ShareIt.file(
                      path: await _fileBundlePath,
                      type: ShareItFileType.anyFile);
                },
              ),
              FlatButton(
                child: Text('Share link method 1'),
                onPressed: () async {
                  ShareIt.text(content: 'https://www.google.com');
                },
              ),
              FlatButton(
                child: Text('Share link method 2'),
                onPressed: () async {
                  ShareIt.link(
                      url: 'https://www.google.com',
                      androidSheetTitle: 'Google');
                },
              ),
              FlatButton(
                child: Text('Share image and text'),
                onPressed: () async {
                  ShareIt.list(
                      androidSheetTitle: 'Multiple stuff!',
                      parameters: [
                        ShareItParameters.plainText(content: 'Example text'),
                        ShareItParameters(
                          type: ShareItFileType.image,
                          path: await _imageBundlePath,
                        )
                      ]);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> get _imageBundlePath async {
    return _fileFromBundle(name: 'photo.jpg');
  }

  Future<String> get _fileBundlePath async {
    return _fileFromBundle(name: 'housing.csv');
  }

  Future<String> _fileFromBundle({@required String name}) async {
    final directory = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();
    final filePath = join(directory.path, name);
    final bundleData = await rootBundle.load('assets/$name');
    List<int> bytes = bundleData.buffer
        .asUint8List(bundleData.offsetInBytes, bundleData.lengthInBytes);
    final file = await File(filePath).writeAsBytes(bytes);
    return file.path;
  }
}
