import 'package:flutter/material.dart';
import 'package:mokamayu/services/photo_tapped.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';

class ContainerList {
  double height;
  double width;
  double scale;
  double rotation;
  double xPosition;
  double yPosition;

  ContainerList({
    required this.height,
    required this.rotation,
    required this.scale,
    required this.width,
    required this.xPosition,
    required this.yPosition,
  });
}

class DragTargetContainer extends StatefulWidget {
  DragTargetContainer({Key? key, this.map}) : super(key: key);
  Map<String, ContainerList>? map = {};

  @override
  _DragTargetState createState() => _DragTargetState();
}

class _DragTargetState extends State<DragTargetContainer> {
  List<ContainerList> list = [];
  late Offset _initPos;
  late Offset _currentPos = Offset(0, 0);
  late double _currentScale;
  late double _currentRotation;
  late Size screen;

  @override
  void initState() {
    screen = Size(400, 500);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      height: 450.0,
      color: CustomColors.soft,
      child: Stack(
        children: widget.map!.entries.map((entry) {
          return GestureDetector(
            onTap: () {
              widget.map!.removeWhere((key, value) => key == entry.key);
              setState(() {});
            },
            onScaleStart: (details) {
              if (entry.value == null) return;
              _initPos = details.focalPoint;
              _currentPos =
                  Offset(entry.value.xPosition, entry.value.yPosition);
              _currentScale = entry.value.scale;
              _currentRotation = entry.value.rotation;
            },
            onScaleUpdate: (details) {
              if (entry.value == null) return;
              final delta = details.focalPoint - _initPos;
              var left = (delta.dx / screen.width) + _currentPos.dx;
              var top = (delta.dy / screen.height) + _currentPos.dy;
              // print(left);
              // print(top);

              if (left < 0) left = 0;
              if (left > 0.54) left = 0.54;
              if (top < 0) top = 0;
              if (top > 0.5) top = 0.5;
              // print(_currentScale);

              setState(() {
                entry.value.xPosition = Offset(left, top).dx;
                entry.value.yPosition = Offset(left, top).dy;
                entry.value.rotation = details.rotation + _currentRotation;
                entry.value.scale = details.scale * _currentScale;
                if (entry.value.scale > 1) entry.value.scale = 1;
                // print(entry.value.scale);
              });
            },
            child: Stack(
              children: [
                Positioned(
                  left: entry.value.xPosition * screen.width,
                  top: entry.value.yPosition * screen.height,
                  child: Transform.scale(
                    scale: entry.value.scale,
                    child: Transform.rotate(
                        angle: entry.value.rotation,
                        child: Container(
                          height: entry.value.height,
                          width: entry.value.width,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Listener(
                              onPointerDown: (details) {
                                _initPos = details.position;
                                _currentPos = Offset(entry.value.xPosition,
                                    entry.value.yPosition);
                                _currentScale = entry.value.scale;
                                _currentRotation = entry.value.rotation;
                              },
                              onPointerUp: (details) {},
                              child: Image.network(entry.key, fit: BoxFit.fill),
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
