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
                  ()=> ListView.builder(
                    itemCount: controller.logs.length,
                    itemBuilder: (BuildContext context, int index)=>Text(
                      controller.logs[index]
                    )
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  if(controller.running.value){
                    try {
                      controller.process.kill();
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