import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonColumnWrapper extends StatelessWidget {
  final Column column;
  final bool enabled;
  const SkeletonColumnWrapper(
      {super.key, required this.column, required this.enabled});

  @override
  Widget build(BuildContext context) {
    if (enabled) return column;
    // Replacing each child of the Column with Skeleton.widget
    final children = column.children.map((child) {
      // Wrap each child with Skeleton.widget
      return Skeleton.leaf(child: child);
    }).toList();

    // Return a new Column with modified children
    return Column(
      children: children,
    );
  }
}

class SkeletonGridWrapper extends StatelessWidget {
  final GridView grid;
  final bool enabled;
  const SkeletonGridWrapper(
      {super.key, required this.grid, required this.enabled});

  @override
  Widget build(BuildContext context) {
    if (!enabled) return grid;
    // Replacing each child of the Column with Skeleton.widget

    // Return a new Column with modified children
    return GridView(
        key: grid.key,
        scrollDirection: grid.scrollDirection,
        reverse: grid.reverse,
        controller: grid.controller,
        primary: grid.primary,
        physics: grid.physics,
        shrinkWrap: grid.shrinkWrap,
        padding: grid.padding,
        gridDelegate: grid.gridDelegate,
        cacheExtent: grid.cacheExtent,
        semanticChildCount: grid.semanticChildCount,
        dragStartBehavior: grid.dragStartBehavior,
        clipBehavior: grid.clipBehavior,
        keyboardDismissBehavior: grid.keyboardDismissBehavior,
        restorationId: grid.restorationId,
        hitTestBehavior: grid.hitTestBehavior,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey,
              width: 32,
              height: 32,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey,
              width: 32,
              height: 32,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey,
              width: 32,
              height: 32,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey,
              width: 32,
              height: 32,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey,
              width: 32,
              height: 32,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey,
              width: 32,
              height: 32,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey,
              width: 32,
              height: 32,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey,
              width: 32,
              height: 32,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey,
              width: 32,
              height: 32,
            ),
          ),
        ]);
  }
}
