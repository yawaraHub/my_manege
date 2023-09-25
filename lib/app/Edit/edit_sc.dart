import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:my_manege/app/Edit/category_add_sc.dart';
import 'package:my_manege/app/Edit/category_data.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  List category = [
    {
      "name": '勉強',
      'children': [
        {
          "name": "数学",
          "children": [
            {"name": "線形代数", "children": []},
            {"name": "微分積分", "children": []}
          ],
        },
        {
          "name": "物理",
          "children": [
            {"name": "機械力学asdasdasdsa", "children": []},
            {"name": "流体力学", "children": []},
            {"name": "熱力学", "children": []},
          ]
        }
      ]
    },
    {
      "name": '趣味',
      'children': [
        {
          "name": "DIY",
          "children": [
            {"name": "木工", "children": []},
            {"name": "電子", "children": []}
          ],
        },
        {
          "name": "プログラミング",
          "children": [
            {"name": "Python", "children": []},
            {"name": "Flutter", "children": []},
          ]
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    List<TreeNode> createTreeNode =
        CreateCategoryTreeNode().listToListTreeNode(context, category);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Category'),
            TreeView(nodes: createTreeNode),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CategoryAdd();
                    });
              },
              child: Text('追加'),
            ),
          ],
        ),
      ),
    );
  }
}
