import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:get/get.dart';

enum Models{
  tiny,
  base,
  small,
  medium,
  large,
  turbo
}

class Task{
  String? filePath;
  String? lang;
  bool? wordTimeStamps;
  Models? model;

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Task &&
    filePath == other.filePath &&
    lang == other.lang &&
    model == other.model &&
    wordTimeStamps == other.wordTimeStamps;

  @override
  int get hashCode => Object.hash(filePath, lang, wordTimeStamps, model);

  Task(this.filePath, this.lang, this.wordTimeStamps, this.model);
}

class Controller extends GetxController{
  RxString whisperPath="".obs;
  RxString ffmpegPath="".obs;

  RxBool configOk=false.obs;

  Rx<Task> task=Rx(Task(null, null, null, null));
  late Process process;
  RxList logs=[].obs;

  RxBool running=false.obs;

  Future<void> exec(String filePath, String? lang, bool wordTimeStamps, String model) async {
    Models taskModel;
    switch (model) {
      case "tiny":
        taskModel=Models.tiny;
        break;
      case "base":
        taskModel=Models.base;
        break;
      case "small":
        taskModel=Models.small;
        break;
      case "medium":
        taskModel=Models.medium;
        break;
      case "large":
        taskModel=Models.large;
        break;
      default:
        taskModel=Models.turbo;
    }

    task.value=Task(
      filePath, 
      lang, 
      wordTimeStamps, 
      taskModel
    );

    configOk.value=true;
    running.value=true;

    try {
      final args = [
        filePath,
        "--model", model,
        "--word_timestamps", wordTimeStamps ? "True" : "False",
        if (lang != null) "--language",
        if (lang != null) lang,
      ];

      process = await Process.start(
        whisperPath.value,
        args,
        runInShell: true,
        environment: {
          'PYTHONUNBUFFERED': '1',
          'PATH': "/Users/zhoucheng/ffmpeg:\$PATH"
        },
        workingDirectory: p.dirname(filePath)
      );

      process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) {
        logs.insert(0, line);
      });

      process.stderr
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) {
        logs.insert(0, line);
      });

      process.exitCode.then((code) {
        running.value=false;
      });
    } catch (_) {}

  }
}