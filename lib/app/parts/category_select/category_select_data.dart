// import 'package:flutter/material.dart';
// import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
// import 'package:my_manege/app/tree/tree.dart';
//
// class CreateSelectCategoryTreeNode {
//   CategoryTreeNodeData buildTreeNode(Map<String, dynamic> data) {
//     final label = data['name'] as String;
//     final childrenData = data['children'] as List<dynamic>;
//     final children = childrenData
//         .map((childData) => buildTreeNode(childData as Map<String, dynamic>))
//         .toList();
//
//     return CategoryTreeNodeData(label, children);
//   }
//
//   List<CategoryTreeNodeData> buildTree(List dataList) {
//     final List<CategoryTreeNodeData> nodes = [];
//     for (final data in dataList) {
//       final label = data['name'] as String;
//       final childrenData = data['children'] as List;
//
//       if (childrenData.isNotEmpty) {
//         final childrenNodes = buildTree(childrenData);
//         nodes.add(CategoryTreeNodeData(label, childrenNodes));
//       } else {
//         nodes.add(CategoryTreeNodeData(label, []));
//       }
//     }
//     return nodes;
//   }
//
//   List<TreeNode> _buildCategoryTreeNodes(
//       BuildContext context, List<CategoryTreeNodeData> data) {
//     return data.map((nodeData) {
//       return TreeNode(
//         content: Expanded(
//           child: ListTile(
//             title: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal, child: Text(nodeData.label)),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         children: _buildCategoryTreeNodes(context, nodeData.children),
//       );
//     }).toList();
//   }
//
//   List<TreeNode> listToListTreeNode(BuildContext context, List data) {
//     List<CategoryTreeNodeData> treeData = buildTree(data);
//     return _buildCategoryTreeNodes(context, treeData);
//   }
// }
