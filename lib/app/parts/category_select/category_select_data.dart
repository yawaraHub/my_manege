import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:my_manege/app/tree/tree.dart';

class CreateSelectCategoryTreeNode {
  TreeNodeData buildTreeNode(Map<String, dynamic> data) {
    final label = data['name'] as String;
    final childrenData = data['children'] as List<dynamic>;
    final children = childrenData
        .map((childData) => buildTreeNode(childData as Map<String, dynamic>))
        .toList();

    return TreeNodeData(label, children);
  }

  List<TreeNodeData> buildTree(List dataList) {
    final List<TreeNodeData> nodes = [];
    for (final data in dataList) {
      final label = data['name'] as String;
      final childrenData = data['children'] as List;

      if (childrenData.isNotEmpty) {
        final childrenNodes = buildTree(childrenData);
        nodes.add(TreeNodeData(label, childrenNodes));
      } else {
        nodes.add(TreeNodeData(label, []));
      }
    }
    return nodes;
  }

  List<TreeNode> _buildCategoryTreeNodes(
      BuildContext context, List<TreeNodeData> data) {
    return data.map((nodeData) {
      return TreeNode(
        content: Expanded(
          child: ListTile(
            title: SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: Text(nodeData.label)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        children: _buildCategoryTreeNodes(context, nodeData.children),
      );
    }).toList();
  }

  List<TreeNode> listToListTreeNode(BuildContext context, List data) {
    List<TreeNodeData> treeData = buildTree(data);
    return _buildCategoryTreeNodes(context, treeData);
  }
}
