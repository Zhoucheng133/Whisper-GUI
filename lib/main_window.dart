import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisper_gui/utils/controller.dart';
import 'package:whisper_gui/utils/dialogs.dart';
import 'package:whisper_gui/view/add.dart';
import 'package:window_manager/window_manager.dart';
import 'package:process_run/which.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with WindowListener {

  final Controller controller=Get.find();
  late SharedPreferences prefs;

  Future<void> initWshiper(BuildContext context) async {
    prefs=await SharedPreferences.getInstance();

    String? whisper=prefs.getString("whisper");
    if(whisper!=null){
      controller.whisperPath.value=whisper;
      return;
    }

    var whisperExec = whichSync('whisper');

    if(whisperExec==null && context.mounted){
      manualWhisperPath(context, false);
    }
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    windowManager.setResizable(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initWshiper(context);
    });
  }

 @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  bool isMax=false;

  @override
  void onWindowMaximize(){
    setState(() {
      isMax=true;
    });
  }
  
  @override
  void onWindowUnmaximize(){
    setState(() {
      isMax=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: Row(
            children: [
              Expanded(child: DragToMoveArea(child: Container())),
              if(Platform.isWindows) Row(
                children: [
                  WindowCaptionButton.minimize(
                    brightness: Theme.of(context).brightness,
                    onPressed: ()=>windowManager.minimize()
                  ),
                  isMax ? WindowCaptionButton.unmaximize(
                    brightness: Theme.of(context).brightness,
                    onPressed: ()=>windowManager.unmaximize()
                  ) : WindowCaptionButton.maximize(
                    brightness: Theme.of(context).brightness,
                    onPressed: ()=>windowManager.maximize()
                  ),  
                  WindowCaptionButton.close(
                    brightness: Theme.of(context).brightness,
                    onPressed: ()=>windowManager.close()
                  ),
                ],
              ),
            ],
          ),
        ),
        Obx(()=>
          controller.configOk.value==false ? AddView() : Container(),
        )
      ],
    );
  }
}