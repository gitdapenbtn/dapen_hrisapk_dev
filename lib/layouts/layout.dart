import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';

class Layout extends StatefulWidget {
  final LayoutAppBar? appBar;
  final RefreshCallback? onRefresh;
  final EdgeInsets? padding;
  final Widget? bottomSheet;
  final FloatingActionButton? floatingActionButton;
  final List<Widget>? children;
  final Widget? child;
  final bool isLoading;
  final BoxConstraints? constraints;
  final bool hasNavigationBottom;
  
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool safeAreaLeft;
  final bool safeAreaRight;

  const Layout({ 
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.bottomSheet,
    this.padding,
    this.onRefresh,
    this.children,
    this.child,
    this.isLoading = false,
    this.constraints,
    this.hasNavigationBottom = false,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
  });
  
  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final EdgeInsets _padding = const EdgeInsets.symmetric(vertical: 20);

  double get appBarHeight => widget.appBar != null ? widget.appBar!.preferredSize.height : 0;
  double get safeAreaHeight => (widget.safeAreaTop || widget.appBar != null) ? MediaQuery.of(context).padding.top : 0;
  double get bottomNavigationBarHeight => widget.hasNavigationBottom ? kBottomNavigationBarHeight : 0;

  double get minHeight => (MediaQuery.of(context).size.height - (appBarHeight + safeAreaHeight + bottomNavigationBarHeight));

  @override
  void initState() {
    super.initState();

  }
  Future _refreshData() async {
    if(widget.onRefresh != null) {
      await widget.onRefresh!();
    }
  }

  Widget _body() {
    Widget body;
    if(widget.isLoading) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      body = widget.child ?? Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.children ?? [],
      );
    }
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      backgroundColor: LayoutColor.background,
      body: SafeArea(
        top: widget.safeAreaTop,
        bottom: widget.safeAreaBottom,
        right: widget.safeAreaRight,
        left: widget.safeAreaLeft,
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              color: LayoutColor.background,
              width: MediaQuery.of(context).size.width,
              padding: widget.padding ?? _padding,
              constraints: widget.constraints ?? BoxConstraints(
                minHeight: minHeight
              ),
              child: _body(),
            ),
          ),
        ),
      ),
      bottomSheet: widget.bottomSheet,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}