import 'package:flutter/material.dart';

class PopupMenuContainer<T> extends StatefulWidget {
  final Widget child;
  final List<PopupMenuEntry<T>> items;
  final void Function(T) onItemSelected;
  final void Function() onTap;

  PopupMenuContainer({required this.child, required this.items, required this.onItemSelected, required this.onTap, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PopupMenuContainerState<T>();
}


class PopupMenuContainerState<T> extends State<PopupMenuContainer<T>>{
  late Offset _tapDownPosition;


  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTapDown: (TapDownDetails details){
          _tapDownPosition = details.globalPosition;
        },
        onLongPress: () async {
          final RenderBox overlay = (Overlay.of(context)!.context.findRenderObject()) as RenderBox;

          T value = (await showMenu<T>(
            context: context,
            items: widget.items,

            position: RelativeRect.fromLTRB(
              _tapDownPosition.dx,
              _tapDownPosition.dy,
              overlay.size.width - _tapDownPosition.dx,
              overlay.size.height - _tapDownPosition.dy,
            ),
          ))!;

          widget.onItemSelected(value);
        },
        onTap: widget.onTap,
        child: widget.child
    );
  }
}