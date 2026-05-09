import 'package:flutter/material.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/views/base/custom_loading.dart';

class CustomListHandler extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final double scrollThreshold;
  final double horizontalPadding;
  final double spacing;
  final Widget? child;
  final List<Widget> children;
  final Widget? seperator;
  final String endIndicator;
  final String placeholder;
  final TextStyle textStyle;
  final bool reverse;
  final bool topPadding;
  final bool isLoading;
  final bool isLoadingMore;
  final bool shrinkWrap;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  const CustomListHandler({
    super.key,
    this.child,
    this.children = const [],
    this.onRefresh,
    this.onLoadMore,
    this.reverse = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.topPadding = false,
    this.shrinkWrap = false,
    this.seperator,
    this.endIndicator = "End of the list",
    this.placeholder = "Nothing to show",
    this.textStyle = const TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.w300,
    ),
    this.scrollThreshold = 200,
    this.spacing = 12,
    this.horizontalPadding = 24,
    this.controller,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (reverse) {
          if (scrollInfo.metrics.pixels <= scrollThreshold) {
            if (onLoadMore != null) onLoadMore!();
          }
        } else {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - scrollThreshold) {
            if (onLoadMore != null) onLoadMore!();
          }
        }

        return false;
      },
      child: isLoading
          ? Center(child: CustomLoading())
          : reverse
          ? getChild() ?? getChildren()
          : RefreshIndicator(
              onRefresh: onRefresh ?? () async {},
              color: AppColors.black,
              backgroundColor: AppColors.zinc,
              child: getChild() ?? getChildren(),
            ),
    );
  }

  SingleChildScrollView? getChild() {
    if (child == null) {
      return null;
    }
    return SingleChildScrollView(
      controller: controller,
      clipBehavior: Clip.none,
      reverse: reverse,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SafeArea(child: child!),
    );
  }

  ListView getChildren() {
    return ListView.separated(
      controller: controller,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: spacing,
      ),
      itemBuilder: (context, index) {
        if (index == children.length) {
          if (children.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(placeholder, style: textStyle),
              ),
            );
          }
          if (isLoadingMore) {
            return Center(child: CustomLoading());
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(endIndicator, style: textStyle),
            ),
          );
        }
        if (topPadding && index == 0) {
          return Padding(
            padding: EdgeInsets.only(top: spacing),
            child: children[index],
          );
        }
        return children[index];
      },
      separatorBuilder: (context, index) {
        if (seperator != null && index != children.length - 1) {
          return seperator!;
        }
        return SizedBox(height: spacing);
      },
      itemCount: children.length + 1,
    );
  }
}
