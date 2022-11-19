import 'package:flutter/material.dart';
import 'package:mokamayu/services/photo_tapped.dart';
import 'package:provider/provider.dart';

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
  const DragTargetContainer({Key? key}) : super(key: key);

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
  String photoUrl = "";

  @override
  void initState() {
    screen = Size(400, 500);

    list.add(ContainerList(
      height: 200.0,
      width: 200.0,
      rotation: 0.0,
      scale: 1.0,
      xPosition: 0.1,
      yPosition: 0.1,
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    photoUrl = Provider.of<PhotoTapped>(context).getId;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      height: 450.0,
      color: Color.fromARGB(255, 244, 232, 217),
      child: Stack(
        children: list.map((value) {
          // print(i);
          return GestureDetector(
            onScaleStart: (details) {
              if (value == null) return;
              _initPos = details.focalPoint;
              _currentPos = Offset(value.xPosition, value.yPosition);
              _currentScale = value.scale;
              _currentRotation = value.rotation;
            },
            onScaleUpdate: (details) {
              if (value == null) return;
              final delta = details.focalPoint - _initPos;
              final left = (delta.dx / screen.width) + _currentPos.dx;
              final top = (delta.dy / screen.height) + _currentPos.dy;

              setState(() {
                value.xPosition = Offset(left, top).dx;
                value.yPosition = Offset(left, top).dy;
                value.rotation = details.rotation + _currentRotation;
                value.scale = details.scale * _currentScale;
              });
            },
            child: Stack(
              children: [
                Positioned(
                  left: value.xPosition * screen.width,
                  top: value.yPosition * screen.height,
                  child: Transform.scale(
                    scale: value.scale,
                    child: Transform.rotate(
                      angle: value.rotation,
                      child: Container(
                        height: value.height,
                        width: value.width,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Listener(
                            onPointerDown: (details) {
                              // if (_inAction) return;
                              // _inAction = true;
                              // _activeItem = val;
                              _initPos = details.position;
                              _currentPos =
                                  Offset(value.xPosition, value.yPosition);
                              _currentScale = value.scale;
                              _currentRotation = value.rotation;
                            },
                            onPointerUp: (details) {
                              // _inAction = false;
                            },
                            // child: Container(
                            //   height: value.height,
                            //   width: value.width,
                            //   color: Colors.red,
                            // ),
                            child: Image.network(photoUrl, fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
