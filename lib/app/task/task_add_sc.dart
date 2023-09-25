import 'package:flutter/material.dart';

class TaskAdd extends StatefulWidget {
  const TaskAdd({Key? key}) : super(key: key);

  @override
  State<TaskAdd> createState() => _TaskAddState();
}

class _TaskAddState extends State<TaskAdd> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('タスクの追加'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            //TODO:期限の登録をできるようにする
            TextField(
              decoration: InputDecoration(labelText: 'タスク名'),
            ),
            TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'メモ',
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('閉じる'),
        ),
        ElevatedButton(onPressed: () {}, child: Text('追加'))
      ],
    );
  }
}
