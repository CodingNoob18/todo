import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_task.dart';
import 'package:todo/modules/done_task.dart';
import 'package:todo/modules/new_task.dart';
import 'package:todo/shared/components.dart';


class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout > {
  int index = 0;
  List<String> titles = ["New Tasks","Done Tasks","Archived Tasks"];
  List<Widget> screens = [NewTaskScreen(), DoneTaskScreen(), ArchivedTaskScreen()];
  Database? database;
  var scafKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isOpen = false;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafKey,
      appBar: AppBar(
        title: Text(titles[index]),
      ),
      body: screens[index],
      floatingActionButton: FloatingActionButton(
          child: isOpen ? Icon(Icons.add) : Icon(Icons.edit),
          onPressed: (){
            if(isOpen)
            {
              if(formKey.currentState!.validate())
              {
                Navigator.pop(context);
                isOpen = false;
              }
            }
            else
            {
              scafKey.currentState!.showBottomSheet(
                    (context) => Container(
                     width: double.infinity,
                     padding: EdgeInsets.symmetric(horizontal: 20),
                     child:Form(
                      key : formKey,
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defaultTFF(
                          control: titleController,
                          type: TextInputType.text,
                          label: "Task title",
                          preIcon: Icons.text_fields,
                          validate: (value){
                            if(value!.isEmpty)
                            {
                              return "Task title must be entered";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        defaultTFF(
                          control: timeController,
                          type: TextInputType.datetime,
                          label: "Task Time",
                          preIcon: Icons.watch_later_outlined,
                          onTap: (){
                            showTimePicker(context: context,
                                initialTime: TimeOfDay.now()).then
                              ((value) =>
                            {print(value!.format(context)),
                              timeController.text = value.format(context)}
                            ).catchError(
                                    (error)
                                {print("${error.toString()}");}
                            );
                          },
                          validate: (String value){
                            if(value.isEmpty)
                            {
                              return "Time must be entered";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        defaultTFF(
                          control: dateController,
                          type: TextInputType.datetime,
                          label: "Task Date",
                          preIcon: Icons.calendar_today,
                          onTap: (){
                            showDatePicker(context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse("2021-12-12")).then
                              ((value) => {dateController.text = DateFormat.yMMMd().format(value!),}
                            ).catchError((error){print("${error.toString()}");});
                          },
                          validate: (String value){
                            if(value.isEmpty)
                            {
                              return "Time must be entered";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ) ,
                ),
              );
              isOpen = true;
            }
            setState(() {
            });
          }
      ),
      bottomNavigationBar: BottomNavigationBar (
        type: BottomNavigationBarType.fixed,
        onTap: (value){
          setState(() {
            index = value;
          });
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon : Icon(Icons.menu),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon : Icon(Icons.check_circle),
            label: "Done",
          ),
          BottomNavigationBarItem(
            icon : Icon(Icons.archive_outlined),
            label: "Archive",
          ),
        ],
      ),
    );
  }

  Future<String> getName() async
  {
    return "Omar";
  }

  void createDB() async
  {
    database = await openDatabase(
      "todo.db",
      version:1,
      onCreate: (database, version){
        print("DB created");
        database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
        ).then((value) => print("Table created")).catchError((error){
          print("Error ${error.toString()}");
        });
      },
      onOpen: (database) async{
        print("DB open");
      },
    );
  }

  void insertRow()
  {
    database!.transaction(
            (txn) => txn.rawInsert(
            "INSERT INTO tasks(title, date, time, status) VALUES ('first task', '324', '4343', 'new')"
        )).then
      ((value) => {
      print("$value inserted successfully")
    }).catchError((error){
      print("Error inserting row ${error.toString()}");
    });
  }
}

