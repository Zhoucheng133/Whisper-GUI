import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisper_gui/utils/controller.dart';

Future<void> showOkDialog(BuildContext context, String title, String content, {String okText="好的"}) async {
  await showDialog(
    context: context, 
    builder: (BuildContext context)=>AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: ()=>Navigator.pop(context), 
          child: Text(okText)
        )
      ],
    )
  );
}

Future<void> manualWhisperPath(BuildContext context, bool cancel) async {
  final Controller controller=Get.find();
  TextEditingController pathController=TextEditingController(text: controller.whisperPath.value);
  await showDialog(
    context: context, 
    builder: (context)=>StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text('手动设置whisper路径'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text("你需要手动定位whisper程序的位置"),
              ),
              SizedBox(
                width: 400,
                child: TextField(
                  controller: pathController,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '输入whisper位置',
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15)
                  ),
                ),
              ),
            ],
          ),
          actions: [
            if(cancel) TextButton(
              onPressed: ()=>Navigator.pop(context), 
              child: Text("取消")
            ),
            TextButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  // File file = File(result.files.single.path!);
                  setState((){
                    pathController.text=result.files.single.path!;
                  });
                }
              }, 
              child: Text('选择')
            ),
            ElevatedButton(
              onPressed: (){
                if(pathController.text.isEmpty){
                  showOkDialog(context, "无法完成设置", "whisper路径不能为空");
                  return;
                }
                controller.whisperPath.value=pathController.text;
              }, 
              child: Text('完成')
            )
          ],
        );
      }
    )
  );
}