import 'package:flutter/material.dart';
import 'package:mokamayu/constants/constants.dart';
import 'package:mokamayu/services/managers/photo_tapped_manager.dart';
import 'package:provider/provider.dart';

import '../../models/outfit_container.dart';

//ignore: must_be_immutable
class DragTargetContainer extends StatefulWidget {
  DragTargetContainer({Key? key, this.map}) : super(key: key);
  Map<List<dynamic>, OutfitContainer>? map = {};

  @override
  DragTargetState createState() => DragTargetState();
}

class DragTargetState extends State<DragTargetContainer> {
  List<OutfitContainer> list = [];
  late Offset _initPos;
  late Offset _currentPos = const Offset(0, 0);
  late double _currentScale;
  late double _currentRotation;
  late Size screen;

  @override
  void initState() {
    screen = const Size(400, 500);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsConstants.white,
        borderRadius: BorderRadius.circular(12),
      ),
      // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 500,
      //color: ColorsConstants.soft,
      child: Stack(
        children: widget.map!.entries.map((entry) {
          return GestureDetector(
            onTap: () {
              widget.map!.removeWhere((key, value) => key == entry.key);
              Provider.of<PhotoTapped>(context, listen: false)
                  .photoRemoved(entry.key[1]);
              setState(() {});
            },
            onScaleStart: (details) {
              // ignore: unnecessary_null_comparison
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

              if (left < 0) left = 0;
              if (left > 0.72) left = 0.72;
              if (top < 0) top = 0;
              if (top > 0.6) top = 0.6;

              setState(() {
                entry.value.xPosition = Offset(left, top).dx;
                entry.value.yPosition = Offset(left, top).dy;
                entry.value.rotation = details.rotation + _currentRotation;
                entry.value.scale = details.scale * _currentScale;
                if (entry.value.scale > 2) entry.value.scale = 2;
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
                        child: SizedBox(
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
                              child:
                                  Image.network(entry.key[0], fit: BoxFit.fill),
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
