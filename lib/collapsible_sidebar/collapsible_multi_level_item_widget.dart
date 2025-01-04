import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_item.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_item_widget.dart';
import 'package:flutter/material.dart';

class CollapsibleMultiLevelItemWidget extends StatefulWidget {
  const CollapsibleMultiLevelItemWidget({
    super.key,
    required this.onHoverPointer,
    required this.textStyle,
    required this.padding,
    required this.offsetX,
    required this.scale,
    // required this.mainLevel,
    required this.subItems,
    required this.extendable,
    required this.disable,
    this.iconColor,
    this.iconSize,
    this.onTapMainLevel,
    this.onHold,
    this.isCollapsed,
    this.isSelected,
    this.minWidth,
    this.parentComponent,
    this.expandSubMenuWidget,
    this.collapseSubMenuWidget,
    this.borderRadius,
    this.hoverBackgroundColor,
    this.leadingIcon,
    this.textWidget,
  });

  // final Widget mainLevel;
  final MouseCursor onHoverPointer;
  final TextStyle textStyle;
  final double offsetX, scale, padding;
  final bool? isCollapsed;
  final bool? isSelected;
  final double? minWidth;
  final List<CollapsibleItem> subItems;
  final bool extendable;
  final bool? disable;
  final double? iconSize;
  final Color? iconColor;
  final VoidCallback? onTapMainLevel, onHold;
  final bool? parentComponent;
  final Widget? expandSubMenuWidget;
  final Widget? collapseSubMenuWidget;
  final BorderRadius? borderRadius;
  final Color? hoverBackgroundColor;
  final Widget? leadingIcon;
  final Widget? textWidget;
  @override
  _CollapsibleMultiLevelItemWidgetState createState() =>
      _CollapsibleMultiLevelItemWidgetState();
}

class _CollapsibleMultiLevelItemWidgetState
    extends State<CollapsibleMultiLevelItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.parentComponent == true &&
        (widget.isSelected == false || widget.isSelected == null) &&
        isOpen == true) {
      setState(() {
        isOpen = false;
      });
    }
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.onTapMainLevel != null) {
              widget.onTapMainLevel!();
            }
            setState(() {
              isOpen = !isOpen;
            });
          },
          onLongPress: widget.onHold,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Stack(
                      children: [
                        widget.leadingIcon!,
                        if (!isOpen &&
                            widget.collapseSubMenuWidget != null &&
                            widget.isCollapsed == true)
                          Positioned(
                            top: 2,
                            right: 0,
                            child: SizedBox(
                              height: 15,
                              width: 15,
                              child: widget.collapseSubMenuWidget!,
                            ),
                          ),
                      ],
                    ),
                    widget.textWidget!,
                  ],
                ),
              ),

              /// Custom widget
              if (widget.disable != null && widget.disable == false)
                _submenuWidget, // Wrap this with Expanded
            ],
          ),
        ),
        SizedBox(
          height: widget.padding,
        ),
        if (widget.disable != null && widget.disable == false)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              height: widget.extendable == true && isOpen ? null : 0,
              child: Column(
                children: widget.subItems
                    .map(
                      (subItem) => CollapsibleItemWidget(
                        onHoverPointer: widget.onHoverPointer,
                        borderRadius: widget.borderRadius,
                        hoverBackgroundColor: widget.hoverBackgroundColor,
                        padding: EdgeInsets.all(
                          widget.padding,
                        ),
                        offsetX: widget.offsetX,
                        scale: widget.scale,
                        leading: subItem.iconImage != null
                            ? Image(
                                image: subItem.iconImage!,
                                width: widget.iconSize,
                                height: widget.iconSize,
                              )
                            : (subItem.icon != null
                                ? Icon(
                                    subItem.icon,
                                    size: widget.iconSize,
                                    color: widget.iconColor,
                                  )
                                : SizedBox(
                                    width: widget.iconSize,
                                    height: widget.iconSize,
                                  )),
                        iconSize: widget.iconSize,
                        iconColor: widget.iconColor,
                        title: subItem.text,
                        textStyle: widget.textStyle,
                        isCollapsed: widget.isCollapsed,
                        minWidth: widget.minWidth,
                        onTap: () {
                          subItem.onPressed();
                        },
                        onLongPress: () {
                          if (subItem.onHold != null) {
                            subItem.onHold!();
                          }
                        },
                        subItems: subItem.subItems,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget get _submenuWidget {
    return Opacity(
      opacity: widget.scale,
      child: Transform.translate(
        offset: Offset(
          widget.isCollapsed == true ? widget.offsetX : 0,
          0,
        ),
        child: Transform.scale(
          scale: widget.scale,
          child: widget.extendable
              ? (isOpen
                  ? widget.expandSubMenuWidget ?? const SizedBox.shrink()
                  : widget.collapseSubMenuWidget ?? const SizedBox.shrink())
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
