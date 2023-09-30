import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:my_manege/app/category/category_add_sc.dart';
import 'package:my_manege/app/category/category_data.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  List category = [
    {
      'id': 1,
      "name": '勉強',
      'color': '00ff00',
      'description': '',
      'is_show': 1,
      'parent_id': 0,
      'order': 0,
      'created_at': '20020930',
      'updated_at': '20020930',
      'children': [
        {
          'id': 2,
          "name": "数学",
          'color': '6799ff',
          'description': '',
          'is_show': 1,
          'parent_id': 1,
          'order': 0,
          'created_at': '20020930',
          'updated_at': '20020930',
          "children": [
            {
              'id': 4,
              "name": "線形代数",
              'color': '00ff88',
              'description': '',
              'is_show': 1,
              'parent_id': 2,
              'order': 0,
              'created_at': '20020930',
              'updated_at': '20020930',
              "children": []
            },
            {
              'id': 5,
              "name": "微分積分",
              'color': '88ff00',
              'description': '',
              'is_show': 0,
              'parent_id': 2,
              'order': 0,
              'created_at': '20020930',
              'updated_at': '20020930',
              "children": []
            }
          ],
        },
        {
          'id': 3,
          "name": "物理",
          'description': '',
          'is_show': 1,
          'color': '00ff00',
          'parent_id': 1,
          'order': 0,
          'created_at': '20020930',
          'updated_at': '20020930',
          "children": [
            {
              'id': 6,
              "name": "機械力学asdasdasdsa",
              'description': '',
              'is_show': 1,
              'color': '00ff00',
              'parent_id': 3,
              'order': 0,
              'created_at': '20020930',
              'updated_at': '20020930',
              "children": []
            },
            {
              'id': 7,
              "name": "流体力学",
              'color': '00ff00',
              'description': '',
              'is_show': 1,
              'parent_id': 3,
              'order': 0,
              'created_at': '20020930',
              'updated_at': '20020930',
              "children": []
            },
            {
              'id': 8,
              "name": "熱力学",
              'color': '00ff00',
              'description': '',
              'is_show': 1,
              'parent_id': 3,
              'order': 0,
              'created_at': '20020930',
              'updated_at': '20020930',
              "children": []
            },
          ]
        }
      ]
    },
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
                      return CategoryAdd(parentId: 0);
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
