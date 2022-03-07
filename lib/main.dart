// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'image_previews.dart';
import 'kakao_share_helper.dart';

void main() {
  KakaoContext.clientId = 'c93e39871656ed427af75eea5812d436';

  runApp(const DemoApp());
}

class DemoApp extends StatefulWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  DemoAppState createState() => DemoAppState();
}

class DemoAppState extends State<DemoApp> {
  String text = '';
  String subject = '';
  List<String> imagePaths = [];

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Share Plugin Demo',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Share Plugin Demo'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                      labelText: '공유 텍스트:',
                    ),
                    maxLines: 2,
                    onChanged: (String value) => setState(() {
                      text = value;
                    }),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 12.0)),
                  ImagePreviews(imagePaths, onDelete: _onDeleteImage),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('이미지 불러오기'),
                    onTap: () async {
                      final imagePicker = ImagePicker();
                      final pickedFile = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          imagePaths.add(pickedFile.path);
                        });
                      }
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 12.0)),
                  Builder(
                    builder: (BuildContext context) {
                      return ElevatedButton(
                        onPressed: text.isEmpty && imagePaths.isEmpty
                            ? null
                            : () => _onShare(context),
                        child: const Text('공유'),
                      );
                    },
                  ),

                  const Padding(padding: EdgeInsets.only(top: 12.0)),
                  ElevatedButton(
                    onPressed:
                        () => _onCapture(),
                    child: const Text('캡쳐 후 공유'),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 12.0)),
                  ElevatedButton(
                    onPressed:
                        () => _onCaptureSave(),
                    child: const Text('캡쳐 후 카카오 공유'),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 12.0)),
                  ElevatedButton(
                    onPressed:
                        () => _onCaptureSave(),
                    child: const Text('캡쳐 후 저장'),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _onDeleteImage(int position) {
    setState(() {
      imagePaths.removeAt(position);
    });
  }

  void _onCapture() {
    screenshotController
        .captureFromWidget(
      Container(
        width: 952 * 0.36,
        height: 1350 * 0.36,
        padding: const EdgeInsets.symmetric(vertical: 60 * 0.36, horizontal: 40 * 0.36),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(40 * 0.36)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("IT거래량 전략 | 포트폴리오", style: TextStyle(color: Colors.black, fontSize: 50 * 0.36),),
            const SizedBox(height: 20 * 0.36),
            const Text("성과평과 2020.1.1 ~ 2020.7.31", style: TextStyle(color: Colors.black, fontSize: 36 * 0.36),),

            const SizedBox(height: 60 * 0.36),
            ImagePreviews(imagePaths),
          ],
        ),
      ),
    )
        .then((capturedImage) async {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/image.png').create();
      await imagePath.writeAsBytes(capturedImage);

      final box = context.findRenderObject() as RenderBox?;

      await Share.shareFiles([imagePath.path],
          text: text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    });
  }

  void _onCaptureKakaoShare() {
    screenshotController
        .captureFromWidget(
      Container(
        width: 952 * 0.36,
        height: 1350 * 0.36,
        padding: const EdgeInsets.symmetric(vertical: 60 * 0.36, horizontal: 40 * 0.36),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(40 * 0.36)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("IT거래량 전략 | 포트폴리오", style: TextStyle(color: Colors.black, fontSize: 50 * 0.36),),
            const SizedBox(height: 20 * 0.36),
            const Text("성과평과 2020.1.1 ~ 2020.7.31", style: TextStyle(color: Colors.black, fontSize: 36 * 0.36),),

            const SizedBox(height: 60 * 0.36),
            ImagePreviews(imagePaths),
          ],
        ),
      ),
    )
        .then((capturedImage) async {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/image.png').create();
      await imagePath.writeAsBytes(capturedImage);

      final result = await ImageGallerySaver.saveFile(imagePath.path);

      KakaoShareManager share = KakaoShareManager();
      share.shareMyCode();
    });
  }



  void _onCaptureSave() {
    screenshotController
        .captureFromWidget(
      Container(
        width: 952 * 0.36,
        height: 1350 * 0.36,
        padding: const EdgeInsets.symmetric(vertical: 60 * 0.36, horizontal: 40 * 0.36),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(40 * 0.36)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("IT거래량 전략 | 포트폴리오", style: TextStyle(color: Colors.black, fontSize: 50 * 0.36),),
            const SizedBox(height: 20 * 0.36),
            const Text("성과평과 2020.1.1 ~ 2020.7.31", style: TextStyle(color: Colors.black, fontSize: 36 * 0.36),),

            const SizedBox(height: 60 * 0.36),
            ImagePreviews(imagePaths),
          ],
        ),
      ),
    )
        .then((capturedImage) async {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/image.png').create();
      await imagePath.writeAsBytes(capturedImage);

      final result = await ImageGallerySaver.saveFile(imagePath.path);
    });
  }

  void _onShare(BuildContext context) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final box = context.findRenderObject() as RenderBox?;

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
          text: text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }
}
