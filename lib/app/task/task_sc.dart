import 'package:flutter/material.dart';
import 'package:my_manege/app/task/task_add_sc.dart';

class Task extends StatefulWidget {
  const Task({Key? key}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  List tasks = [
    {
      'deadline': '2023-09-03 09:28:15.970671',
      'name': 'task1',
      'memo': '一つ目のタスク',
      'complete': 0,
    },
  ];
  List displayTasks = [
    {
      'deadline': '2023-09-03 09:28:15.970671',
      'name': 'task1',
      'memo': '一つ目のタスク',
      'complete': 0,
    },
  ];
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Text('task'),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TaskAdd();
                  });
            },
            child: Text('タスク追加'),
          ),
          //タスクのリストを表示
          for (int i = 0; i < displayTasks.length; i++) ...{
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(displayTasks[i]['name']),
                        Text('${displayTasks[i]['deadline']}')
                      ],
                    ),
                    value: displayTasks[i]['complete'] != 0,
                    onChanged: (bool? newValue) {
                      setState(() {
                        if (newValue != null) {
                          if (newValue == false) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('未完了にしますか？'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('いいえ'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            displayTasks[i]['complete'] =
                                                newValue ? 1 : 0;
                                          });
                                        },
                                        child: Text('はい'),
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            setState(() {
                              displayTasks[i]['complete'] = newValue ? 1 : 0;
                            });
                          }
                        }
                      });
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("このタスクを削除する"),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text("閉じる"),
                              onPressed: () {
                                Navigator.of(context).pop(); // AlertDialogを閉じる
                              },
                            ),
                            ElevatedButton(
                              child: Text("削除"),
                              onPressed: () {
                                Navigator.of(context).pop(); // AlertDialogを閉じる
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          }
        ],
      ),
    ));
  }
}
