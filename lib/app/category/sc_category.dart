import 'package:flutter/material.dart';
import 'package:my_manege/app/category/category_tree.dart';
import 'package:my_manege/app/category/sc_add_category.dart';
import 'package:my_manege/sqflite/tb_category.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  CategoriesDao categoriesDao = CategoriesDao();
  late List<Map<String, dynamic>> categories = [];
  late List<TreeNode> categoryTreeNodes = [];

  @override
  void initState() {
    super.initState();
    getCategoriesAndTreeNode();
  }

  getCategoriesAndTreeNode() async {
    categories = await categoriesDao.getCategoryHierarchy();
    categoryTreeNodes = CreateTreeNode().createTree(categories);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
            Column(
              children: categoryTreeNodes.map((node) {
                return TreeViewState(
                  node: node,
                  homeIndex: 3,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
