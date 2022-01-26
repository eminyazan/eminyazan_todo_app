import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../bases/todo_base.dart';
import '../../consts/todo_types.dart';
import '../../common/custom_alert_dialog.dart';
import '../../common/custom_button.dart';
import '../../common/human_readable_date.dart';
import '../../common/loading_page.dart';
import '../../consts/consts.dart';

class CreateTodoPage extends StatefulWidget {
  const CreateTodoPage({Key? key}) : super(key: key);

  @override
  _CreateTodoPageState createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  final Box<Todo> _todoBox = Hive.box<Todo>(TODO_BOX);
  Todo? _todo;

  bool _isLoading = false;
  bool _buttonLoading = false;
  File? image;

  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  String? _title, _about, _todoType, _selectedDateString;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _isLoading == false
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orangeAccent.shade200,
              title: Text(
                "New TODO",
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            return showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: size.height * 0.15,
                                    color: Colors.orangeAccent.shade100,
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                          ),
                                          title: Text(
                                            "Take a pic from camera",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onTap: () {
                                            _takePicFromCamera();
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.image,
                                            color: Colors.white,
                                          ),
                                          title: Text(
                                            "Choose from gallery",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onTap: () {
                                            _chooseFromGallery();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: image != null
                              ? CircleAvatar(
                                  backgroundColor: Colors.orangeAccent,
                                  radius: size.width * 0.21,
                                  child: CircleAvatar(
                                    radius: size.width * 0.2,
                                    backgroundImage: FileImage(
                                      image!,
                                    ),
                                  ),
                                )
                              : Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/add.svg",
                                      height: size.height * 0.2,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.orange.shade400,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      image != null ? TodoAvatar() : SizedBox(),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: TextFormField(
                          controller: _titleController,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return "Title is too short";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (inputTitle) {
                            _title = inputTitle!;
                          },
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2.5),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            errorStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                            icon: Icon(
                              Icons.title,
                              color: Colors.white,
                            ),
                            hintText: "TODO Title",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(29),
                          ),
                          child: TextFormField(
                            controller: _aboutController,
                            autofocus: false,
                            minLines: 3,
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 5) {
                                return "About is too short";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (inputAbout) {
                              _about = inputAbout!;
                            },
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.5),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              errorStyle: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              icon: Icon(
                                Icons.details,
                                color: Colors.white,
                                size: 35,
                              ),
                              hintText:
                                  "Enter your TODO details it can be helpful for remember it later",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      _selectedDateString == null
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButton(
                                    buttonColor: Colors.orange.shade300,
                                    buttonIcon: Icon(
                                      Icons.date_range_rounded,
                                      color: Colors.white,
                                      size: 27,
                                    ),
                                    buttonText: "Choose TODO Date",
                                    onPressed: () async {
                                      buildShowDateTimePicker(context);
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      buildShowDateTimePicker(context);
                                    },
                                    child: Text(
                                      "TODO Date:  " + _selectedDateString!,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.orange.shade300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.orangeAccent,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButton<String>(
                                            isDense: true,
                                            hint: new Text("Chose TODO Type"),
                                            value: _todoType,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _todoType = newValue!;
                                              });
                                              print(_todoType);
                                            },
                                            items: typeList.map((Map map) {
                                              return new DropdownMenuItem<
                                                  String>(
                                                value: map["type"].toString(),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: map["color"],
                                                      ),
                                                      width: size.width * 0.3,
                                                      height: size.height * 0.2,
                                                      child: map["icon"],
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        map["type"].toString(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                        child: CustomButton(
                          submited: _buttonLoading,
                          onPressed: () => _formSubmit(),
                          buttonText: "Create TODO",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : LoadingPage();
  }

  _formSubmit() async {
    if (image != null && _selectedDateString != null && _todoType != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        setState(() {
          _buttonLoading = true;
        });
        print("Image url ---> ${image!.path}");

        _todo = Todo(
          title: _title!,
          about: _about!,
          date: _selectedDate!,
          todoType: _todoType!,
          completed: false,
          imageUrl: image!.path,
        );

        await _todoBox.add(_todo!);
        setState(() {
          _buttonLoading = false;
        });
        await customAlertDialog(
          context,
          "Well Done!",
          "We created your TODO successfully",
          AlertType.success,
        );
        Navigator.pop(context);
      }
    } else {
      await customAlertDialog(context, "Missing Parameter",
          "Please be sure you filled all parameters", AlertType.error);
    }
  }

  Future<DateTime?> buildShowDateTimePicker(BuildContext context) {
    return DatePicker.showDateTimePicker(
      context,
      minTime: DateTime.now(),
      maxTime: DateTime(2050),
      theme: DatePickerTheme(
        doneStyle: TextStyle(
          color: Colors.white,
        ),
        backgroundColor: Colors.orangeAccent.shade200,
      ),
      showTitleActions: true,
      onConfirm: (DateTime date) {
        setState(() {
          _selectedDate = date;
          _selectedDateString = humanReadableDate(date);
        });
      },
      locale: LocaleType.en,
      currentTime: DateTime.now(),
    );
  }

  void _takePicFromCamera() async {
    final newImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 30);
    setState(() {
      image = File(newImage!.path);
    });
    Navigator.pop(context);
  }

  void _chooseFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final newImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      image = File(newImage!.path);
    });
    Navigator.pop(context);
  }
}

class TodoAvatar extends StatelessWidget {
  const TodoAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Todo Image",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
