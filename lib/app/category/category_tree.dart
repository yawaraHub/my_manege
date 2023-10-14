import 'package:flutter/material.dart';
import 'package:my_manege/app/category/sc_add_category.dart';
import 'package:my_manege/app/schedule/sc_add_schedule/sc_add_schedule.dart';
import 'package:my_manege/main.dart';
import 'package:my_manege/sqflite/tb_category.dart';

class TreeNode {
  final int id;
  final String name;
  final String color;
  final String description;
  final int isShow;
  final int parentId;
  final int order;
  final int? userId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  List<TreeNode>? children;

  TreeNode(
      {required this.id,
      required this.name,
      required this.color,
      required this.description,
      required this.isShow,
      required this.parentId,
      required this.order,
      required this.userId,
      required this.createdAt,
      required this.updatedAt,
      required this.deletedAt,
      this.children});
}

class CreateTreeNode {
  List<TreeNode> createTree(List<Map<String, dynamic>> nestedData) {
    List<TreeNode> treeNodes = [];

    for (var item in nestedData) {
      List<Map<String, dynamic>>? childrenData = item['children'];

      TreeNode treeNode = TreeNode(
          id: item['id'],
          name: item['name'],
          color: item['color'],
          description: item['description'],
          isShow: item['is_show'],
          parentId: item['parent_id'],
          order: item['category_order'],
          userId: item['user_id'],
          createdAt: item['created_at'],
          updatedAt: item['updated_at'],
          deletedAt: item['deleted_at']);
      if (childrenData != null) {
        treeNode.children = createTree(childrenData);
      }

      treeNodes.add(treeNode);
    }

    return treeNodes;
  }
}

class TreeViewState extends StatefulWidget {
  final TreeNode node;
  final int homeIndex;

  TreeViewState({required this.node, required this.homeIndex});

  @override
  _TreeViewState createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeViewState> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return AddSchedule(
                  homeIndex: widget.homeIndex,
                  scheduleData: {
                    'schedule': true,
                    'data': {
                      'category_id': widget.node.id,
                      'date': DateTime.now(),
                      'start_at': DateTime.now(),
                      'end_at': DateTime.now().add(Duration(hours: 1)),
                      'description': '',
                    },
                  },
                );
              }),
            );
          },
          child: ListTile(
            leading: IconButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              icon: Icon(
                _isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                size: 50,
                color: Color(int.parse('0xbb${widget.node.color}')),
              ),
            ),
            title: Text(widget.node.name),
            subtitle: SizedBox(
              width: 150,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddOrEditCategory(
                              categoryData: {
                                'name': '',
                                'color': '660000',
                                'description': '',
                                'is_show': 1,
                                'parent_id': widget.node.id,
                                'category_order': 0,
                                'created_at': '',
                                'updated_at': '',
                              },
                            );
                          });
                    },
                    icon: Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddOrEditCategory(
                              categoryData: {
                                'id': widget.node.id,
                                'name': widget.node.name,
                                'color': widget.node.color,
                                'description': widget.node.description,
                                'is_show': widget.node.isShow,
                                'parent_id': widget.node.parentId,
                                'category_order': widget.node.order,
                                'created_at': widget.node.createdAt,
                                'updated_at': widget.node.updatedAt,
                              },
                            );
                          });
                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  '${widget.node.name}を削除しますか？\n${widget.node.name}のカテゴリーも削除されます。'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('削除しない'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    CategoriesDao().delete(widget.node.id);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return HomePage(selectedIndex: 3);
                                      }),
                                    );
                                  },
                                  child: Text('削除'),
                                ),
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isExpanded && widget.node.children != null)
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Column(
              children: widget.node.children!
                  .map((child) => TreeViewState(
                        node: child,
                        homeIndex: widget.homeIndex,
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
