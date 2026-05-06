String toolIconPath(String tool) {
  switch (tool.toLowerCase()) {
    case 'knife':
      return 'assets/icons/knife-kitchen-svgrepo-com.svg';
    case 'board':
      return 'assets/icons/cutting-board-svgrepo-com.svg';
    case 'pot':
      return 'assets/icons/pot-svgrepo-com.svg';
    case 'bowl':
      return 'assets/icons/bowl-svgrepo-com.svg';
    case 'mixer':
      return 'assets/icons/mixer-blender-svgrepo-com.svg';
    case 'pan':
      return 'assets/icons/pan-svgrepo-com.svg';
    case 'cutlery':
      return 'assets/icons/cutlery-fork-svgrepo-com.svg';
    default:
      return 'assets/icons/cutlery-fork-svgrepo-com.svg';
  }
}

double toolIconScale(String tool) {
  switch (tool.toLowerCase()) {
    case 'knife':
      return 0.85;
    case 'board':
      return 0.9;
    case 'pot':
      return 1.15;
    case 'bowl':
      return 1.15;
    case 'mixer':
      return 0.9;
    case 'pan':
      return 1.15;
    case 'cutlery':
      return 0.85;
    default:
      return 1.0;
  }
}
