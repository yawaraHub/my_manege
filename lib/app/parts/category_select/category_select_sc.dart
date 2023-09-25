import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:my_manege/app/parts/category_select/category_select_data.dart';

class CategorySelect extends StatefulWidget {
  const CategorySelect({Key? key}) : super(key: key);

  @override
  State<CategorySelect> createState() => _CategorySelectState();
}

class _CategorySelectState extends State<CategorySelect> {
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
        CreateSelectCategoryTreeNode().listToListTreeNode(context, category);
    return AlertDialog(
      title: Text('カテゴリーを選択'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TreeView(nodes: createTreeNode),
            ],
          ),
        ),
      ),
    );
  }
}
