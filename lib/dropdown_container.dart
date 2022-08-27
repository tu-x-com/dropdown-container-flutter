library dropdown_container;

import 'package:flutter/material.dart';

/// Provides a dropdown for widgets
class DropdownContainer extends StatefulWidget {
  final DropdownContainerController _controller;
  final Widget _child;
  final WidgetBuilder _builder;
  final bool _barrierDismissable;

  /// Initialize the container.
  ///
  /// [controller] is used to control the dropdown.
  /// [dropdownBuilder] is called when dropdown is built.
  /// [child] is the widget in this container.
  /// [barrierDismissable] is used to determine if the dropdown should be close when tap outside of it.
  const DropdownContainer(
      {super.key,
      required DropdownContainerController controller,
      required WidgetBuilder dropdownBuilder,
      required Widget child,
      bool barrierDismissable = true})
      : _controller = controller,
        _child = child,
        _builder = dropdownBuilder,
        _barrierDismissable = barrierDismissable;

  @override
  State<StatefulWidget> createState() {
    return _DropdownContainerState();
  }
}

class _DropdownContainerState extends State<DropdownContainer> {
  final GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget._controller._opening.addListener(_listenOpening);
  }

  @override
  void dispose() {
    widget._controller._opening.removeListener(_listenOpening);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: key, child: widget._child);
  }

  void _listenOpening() {
    final context = key.currentContext;
    if (context != null) {
      if (widget._controller._opening.value) {
        final itemBox = context.findRenderObject()! as RenderBox;
        final Rect itemRect = itemBox.localToGlobal(Offset.zero) & itemBox.size;

        Navigator.of(context).push(_MenuRoute<String>(
            hostRect: itemRect,
            builder: widget._builder,
            update: widget._controller._update,
            opening: widget._controller._opening,
            barrierDismissable: widget._barrierDismissable));
      } else {
        Navigator.of(context).pop();
      }
    }
  }
}

/// Controls the dropdown of [DropdownContainer]
class DropdownContainerController {
  final ValueNotifier<bool> _opening = ValueNotifier(false);
  final ValueNotifier<int> _update = ValueNotifier(0);

  /// Initialize the controller.
  DropdownContainerController();

  /// Gets the state of opening of dropdown.
  bool get opening => _opening.value;

  /// Open the dropdown.
  void open() {
    _opening.value = true;
  }

  /// Close the dropdown.
  void close() {
    _opening.value = false;
  }

  /// Update the dropdown. This command will rebuild the dropdown widget
  void update() {
    _update.value += 1;
  }

  /// Dispose the controller
  void dispose() {}
}

class _MenuRoute<T> extends OverlayRoute<T> {
  final Rect hostRect;
  final WidgetBuilder builder;
  final ValueNotifier<int> update;
  final ValueNotifier<bool> opening;
  final bool barrierDismissable;

  _MenuRoute(
      {required this.hostRect,
      required this.builder,
      required this.update,
      required this.opening,
      required this.barrierDismissable});

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(
          builder: (context) => _MenuScope(
              hostRect: hostRect,
              builder: builder,
              update: update,
              opening: opening,
              barrierDismissable: barrierDismissable)),
    ];
  }
}

class _MenuScope extends StatelessWidget {
  final Rect hostRect;
  final WidgetBuilder builder;
  final ValueNotifier<int> update;
  final ValueNotifier<bool> opening;
  final bool barrierDismissable;

  const _MenuScope(
      {required this.hostRect,
      required this.builder,
      required this.update,
      required this.opening,
      required this.barrierDismissable});

  @override
  Widget build(BuildContext context) {
    return Navigator(
        requestFocus: false,
        onGenerateRoute: (settings) => _MenuNavigatorRoute(
            hostRect: hostRect,
            builder: builder,
            update: update,
            opening: opening,
            barrierDismissable: barrierDismissable));
  }
}

class _MenuNavigatorRoute extends OverlayRoute<String> {
  final Rect hostRect;
  final WidgetBuilder builder;
  final ValueNotifier<int> update;
  final ValueNotifier<bool> opening;
  final bool barrierDismissable;

  _MenuNavigatorRoute(
      {required this.hostRect,
      required this.builder,
      required this.update,
      required this.opening,
      required this.barrierDismissable});

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      if (barrierDismissable)
        OverlayEntry(
            builder: (context) => GestureDetector(
                  onTapDown: (e) => opening.value = false,
                )),
      OverlayEntry(
          builder: (context) => _MenuWidget(
              hostRect: hostRect, builder: builder, update: update)),
    ];
  }
}

class _MenuWidget extends StatefulWidget {
  final Rect hostRect;
  final WidgetBuilder builder;
  final ValueNotifier<int> update;

  const _MenuWidget(
      {required this.hostRect, required this.builder, required this.update});

  @override
  State<StatefulWidget> createState() {
    return _MenuWidgetState();
  }
}

class _MenuWidgetState extends State<_MenuWidget> {
  @override
  void initState() {
    super.initState();
    widget.update.addListener(listenUpdate);
  }

  @override
  void dispose() {
    widget.update.removeListener(listenUpdate);
    super.dispose();
  }

  void listenUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
        delegate: _MenuLayoutDelegate(hostRect: widget.hostRect),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Material(child: widget.builder(context))]));
  }
}

class _MenuLayoutDelegate extends SingleChildLayoutDelegate {
  final Rect hostRect;

  _MenuLayoutDelegate({required this.hostRect});

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    return oldDelegate != this;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(hostRect.left, hostRect.bottom);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
        minWidth: hostRect.width,
        maxWidth: hostRect.width,
        minHeight: constraints.minHeight - hostRect.bottom,
        maxHeight: constraints.maxHeight - hostRect.bottom);
  }
}
