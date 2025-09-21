import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisper_gui/utils/controller.dart';

class LogsView extends StatefulWidget {
  const LogsView({super.key});

  @override
  State<LogsView> createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {

  final Controller controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  ()=> controller.logs.isEmpty ? Center(
                    child: CircularProgressIndicator(),
                  ) : ListView.builder(
                    itemCount: controller.logs.length,
                    itemBuilder: (BuildContext context, int index)=>Text(
                      controller.logs[index]
                    )
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () async {
                  if(controller.running.value){
                    try {
                      if(Platform.isMacOS){
                        controller.process.kill();
                      }else{
                        await Process.run(
                          'taskkill',
                          ['/PID', controller.process.pid.toString(), '/T', '/F']
                        );
                      }
                    } catch (_) {}
                    controller.running.value=false;
                  }
                  controller.configOk.value=false;
                  controller.logs.value=[];
                }, 
                child: Obx(()=>Text( controller.running.value ? "停止" : "完成"))
              ),
              const SizedBox(height: 10,)
            ],
          ),
        ),
      )
    );
  }
}