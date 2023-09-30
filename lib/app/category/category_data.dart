import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:my_manege/app/category/category_add_sc.dart';
import 'package:my_manege/app/tree/tree.dart';

class CreateCategoryTreeNode {
  CategoryTreeNodeData buildTreeNode(Map<String, dynamic> data) {
    final childrenData = data['children'] as List<dynamic>;
    final children = childrenData
        .map((childData) => buildTreeNode(childData as Map<String, dynamic>))
        .toList();

    return CategoryTreeNodeData(
        id: data['id'],
        name: data['name'],
        color: data['color'],
        description: data['description'],
        isShow: data['is_show'],
        parentId: data['parent_id'],
        order: data['order'],
        userId: data['user_id'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at'],
        deletedAt: data['deleted_at'],
        children: children);
  }

  List<CategoryTreeNodeData> buildTree(List dataList) {
    final List<CategoryTreeNodeData> nodes = [];
    for (final data in dataList) {
      final childrenData = data['children'] as List;

      if (childrenData.isNotEmpty) {
        final childrenNodes = buildTree(childrenData);
        nodes.add(CategoryTreeNodeData(
            id: data['id'],
            name: data['name'],
            color: data['color'],
            description: data['description'],
            isShow: data['is_show'],
            parentId: data['parent_id'],
            order: data['order'],
            userId: data['user_id'],
            createdAt: data['created_at'],
            updatedAt: data['updated_at'],
            deletedAt: data['deleted_at'],
            children: childrenNodes));
      } else {
        nodes.add(CategoryTreeNodeData(
            id: data['id'],
            name: data['name'],
            color: data['color'],
            description: data['description'],
            isShow: data['is_show'],
            parentId: data['parent_id'],
            order: data['order'],
            userId: data['user_id'],
            createdAt: data['created_at'],
            updatedAt: data['updated_at'],
            deletedAt: data['deleted_at'],
            children: []));
      }
    }
    return nodes;
  }

  List<TreeNode> _buildCategoryTreeNodes(
      BuildContext context, List<CategoryTreeNodeData> data) {
    return data.map((nodeData) {
      return TreeNode(
        content: Expanded(
          child: ListTile(
            title: SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: Text(nodeData.name)),
            trailing: SizedBox(
              width: 200,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CategoryAdd(parentId: nodeData.parentId);
                          });
                    },
                    icon: Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.remove_red_eye),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
        ),
        children: _buildCategoryTreeNodes(context, nodeData.children),
      );
    }).toList();
  }

  List<TreeNode> listToListTreeNode(BuildContext context, List data) {
    List<CategoryTreeNodeData> treeData = buildTree(data);
    return _buildCategoryTreeNodes(context, treeData);
  }
}
