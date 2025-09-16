import 'package:desktop_drop/desktop_drop.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;
import 'package:whisper_gui/utils/controller.dart';
import 'package:whisper_gui/utils/dialogs.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {

  final Controller controller=Get.find();

  String filePath="";
  bool autoLanguage=true;
  TextEditingController langController=TextEditingController();
  bool wordTimeStamps=true;
  String model=Models.turbo.name;

  Future<void> filePicker(BuildContext context, String path) async {
    bool valid;
    switch (p.extension(path)) {
      case ".mp4":
      case ".mp3":
      case ".wav":
      case ".mov":
      case ".mkv":
      case ".flv":
      case ".aac":
        valid=true;
        break;
      default:
        valid=false;
    }
    if(!valid){
      await showOkDialog(context, "文件不合法", "选择一个音频/视频文件");
      return;
    }

    setState(() {
      filePath=path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropTarget(
        onDragDone: (detail) async {
          final filePath=detail.files[0].path.replaceAll("\\", "/");
          filePicker(context, filePath);
        },
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: filePath.isEmpty ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles();
                        if (result != null && context.mounted) {
                          filePicker(context, result.files.single.path!);
                        }
                      }, 
                      icon: Icon(Icons.add_rounded)
                    ),
                    const SizedBox(height: 5,),
                    Text('添加音视频文件或者拖拽到窗口中'),
                  ],
                ) : Text(
                  filePath
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            splashRadius: 0,
                            value: autoLanguage, 
                            onChanged: (val){
                              if(val!=null){
                                setState(() {
                                  autoLanguage=val;
                                });
                              }
                            }
                          ),
                          // const SizedBox(width: 5,),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  autoLanguage=!autoLanguage;
                                });
                              },
                              child: Text("自动检测语言")
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          controller: langController,
                          enabled: !autoLanguage,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "自定义语言",
                            isCollapsed: true,
                            hintStyle: GoogleFonts.notoSansSc(
                              color: Colors.grey[400]
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10)
                          ),
                          style: GoogleFonts.notoSansSc(
                            fontSize: 13
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            splashRadius: 0,
                            value: wordTimeStamps, 
                            onChanged: (val){
                              if(val!=null){
                                setState(() {
                                  wordTimeStamps=val;
                                });
                              }
                            }
                          ),
                          // const SizedBox(width: 5,),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  wordTimeStamps=!wordTimeStamps;
                                });
                              },
                              child: Text("逐字识别")
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Text("模型"),
                          const SizedBox(width: 5,),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                buttonStyleData: ButtonStyleData(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)
                                  )
                                ),
                                menuItemStyleData: MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  padding: const EdgeInsets.symmetric(vertical: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).colorScheme.surface
                                  )
                                ),
                                isExpanded: true,
                                value: model,
                                items: Models.values.map((item){
                                  return DropdownMenuItem(
                                    value: item.name,
                                    child: Text(
                                      item.name,
                                      style: GoogleFonts.notoSansSc(
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val){
                                  if(val!=null){
                                    setState(() {
                                      model=val;
                                    });
                                  }
                                },
                              )
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      ElevatedButton(
                        onPressed: filePath.isEmpty ? null : ()=>controller.exec(filePath, autoLanguage ? null : langController.text, wordTimeStamps, model), 
                        child: Text('执行')
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}