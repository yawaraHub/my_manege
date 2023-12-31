import 'package:flutter/material.dart';
import 'package:my_manege/app/category/category_tree.dart';
import 'package:my_manege/app/category/sc_add_category.dart';
import 'package:my_manege/main.dart';
import 'package:my_manege/sqflite/tb_category.dart';

class SelectCategory extends StatefulWidget {
  final int homeIndex;
  const SelectCategory({super.key, required this.homeIndex});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  late List<Map<String, dynamic>> categories = [];
  late List<TreeNode> categoryTreeNodes = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategoriesAndTreeNode();
  }

  _getCategoriesAndTreeNode() async {
    categories = await CategoriesDao().getCategoryHierarchy();
    categoryTreeNodes = CreateTreeNode().createTree(categories);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ElevatedButton(
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
                          'parent_id': 0,
                          'category_order': 0,
                          'created_at': '',
                          'updated_at': '',
                        },
                      );
                    });
              },
              child: Text('カテゴリーを追加'),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: categoryTreeNodes.map((node) {
                    return TreeViewState(
                      node: node,
                      homeIndex: widget.homeIndex,
                    );
                  }).toList(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return HomePage(selectedIndex: widget.homeIndex);
                  }),
                );
              },
              child: Text('閉じる'),
            ),
          ],
        ),
      ),
    );
  }
}
