import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

IconData toolIcon(String tool) {
  switch (tool.toLowerCase()) {
    case 'knife':
      return Icons.crop_landscape;
    case 'board':
      return Icons.crop_landscape;
    case 'pot':
      return MdiIcons.potOutline;
    case 'bowl':
      return MdiIcons.bowlOutline;
    case 'mixer':
      return MdiIcons.bowlMixOutline;
    case 'pan':
      return MdiIcons.circleOutline;
    case 'cutlery':
      return MdiIcons.silverware;
    default:
      return MdiIcons.silverwareSpoon;
  }
}
