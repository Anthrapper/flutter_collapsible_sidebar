import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_multi_level_item_widget.dart';
import 'package:flutter/material.dart';

class CollapsibleItemWidget extends StatefulWidget {
  const CollapsibleItemWidget({
    super.key,
    required this.onHoverPointer,
    required this.leading,
    required this.title,
    required this.textStyle,
    required this.padding,
    required this.offsetX,
    required this.scale,
    this.isCollapsed,
    this.isSelected,
    this.minWidth,
    this.onTap,
    this.subItems,
    this.onLongPress,
    this.iconSize,
    this.iconColor,
    this.parentComponent,
    this.collapseSubMenuWidget,
    this.expandSubMenuWidget,
    this.hoverBackgroundColor,
    this.defaultBackgroundColor,
    this.borderRadius,
  });

  final MouseCursor onHoverPointer;
  final Widget leading;
  final String title;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final double offsetX, scale;
  final bool? isCollapsed;
  final bool? isSelected;
  final double? minWidth;
  final VoidCallback? onTap;
  final List<CollapsibleItem>? subItems;
  final double? iconSize;
  final Color? iconColor;
  final bool? parentComponent;
  final VoidCallback? onLongPress;
  final Widget? collapseSubMenuWidget;
  final Widget? expandSubMenuWidget;
  final Color? hoverBackgroundColor;
  final Color? defaultBackgroundColor;
  final BorderRadius? borderRadius;

  @override
  _CollapsibleItemWidgetState createState() => _CollapsibleItemWidgetState();
}

class _CollapsibleItemWidgetState extends State<CollapsibleItemWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          _hovered = false;
        });
      },
      cursor: widget.onHoverPointer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: widget.subItems != null
            ? null
            : BoxDecoration(
                color: _hovered
                    ? widget.hoverBackgroundColor ?? Colors.grey[300]
                    : widget.defaultBackgroundColor ?? Colors.transparent,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              ),
        padding: widget.padding,
        child: widget.subItems == null
            ? GestureDetector(
                onTap: widget.onTap,
                onLongPress: widget.onLongPress,
                child: Row(
                  children: [
                    widget.leading,
                    _title,
                  ],
                ),
              )
            : CollapsibleMultiLevelItemWidget(
                borderRadius: widget.borderRadius,
                hoverBackgroundColor: widget.hoverBackgroundColor,
                onHoverPointer: widget.onHoverPointer,
                textStyle: widget.textStyle,
                offsetX: widget.offsetX,
                isSelected: widget.isSelected,
                scale: widget.scale,
                padding: widget.padding.bottom,
                minWidth: widget.minWidth,
                isCollapsed: widget.isCollapsed,
                parentComponent: widget.parentComponent,
                onHold: widget.onLongPress,
                leadingIcon: widget.leading,
                textWidget: _title,
                // mainLevel: Row(
                //   children: [
                //     widget.leading,
                //     _title,
                //   ],
                // ),
                onTapMainLevel: widget.onTap,
                subItems: widget.subItems!,
                extendable:
                    widget.isCollapsed != false || widget.isSelected != false,
                disable: widget.isCollapsed,
                iconColor: widget.iconColor,
                iconSize: widget.iconSize,
                collapseSubMenuWidget: widget.collapseSubMenuWidget,
                expandSubMenuWidget: widget.expandSubMenuWidget,
              ),
      ),
    );
  }

  Widget get _title {
    return Flexible(
      child: Opacity(
        opacity: widget.scale,
        child: Transform.translate(
          offset: Offset(
            Directionality.of(context) == TextDirection.ltr
                ? widget.offsetX
                : 0,
            0,
          ),
          child: Transform.scale(
            scale: widget.scale,
            child: Text(
              widget.title,
              style: widget.textStyle,
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ),
    );
  }
}
