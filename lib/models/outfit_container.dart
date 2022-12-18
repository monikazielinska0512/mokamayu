class OutfitContainer {
  double height;
  double width;
  double scale;
  double rotation;
  double xPosition;
  double yPosition;

  OutfitContainer({
    required this.height,
    required this.rotation,
    required this.scale,
    required this.width,
    required this.xPosition,
    required this.yPosition,
  });

  factory OutfitContainer.fromJson(Map<String, dynamic> json) =>
      OutfitContainer(
          height: json['height'] as double,
          rotation: json['rotation'] as double,
          scale: json['scale'] as double,
          width: json['width'] as double,
          xPosition: json['xPosition'] as double,
          yPosition: json['yPosition'] as double);

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'rotation': rotation,
      'scale': scale,
      'width': width,
      'xPosition': xPosition,
      'yPosition': yPosition
    };
  }
}
