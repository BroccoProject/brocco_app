import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/floating_nav_bar.dart';

class NavShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  const NavShell({
    super.key,
    required this.navigationShell,
    required this.children,
  });

  @override
  State<NavShell> createState() => _NavShellState();
}

class _NavShellState extends State<NavShell> {
  late final PageController _pageController;
  bool _isAnimatingToPage = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
  }

  @override
  void didUpdateWidget(covariant NavShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.navigationShell.currentIndex !=
        widget.navigationShell.currentIndex) {
      _isAnimatingToPage = true;
      _pageController
          .animateToPage(
            widget.navigationShell.currentIndex,
            duration: const Duration(milliseconds: 450),
            curve: Curves.fastOutSlowIn,
          )
          .then((_) {
            if (mounted) {
              setState(() => _isAnimatingToPage = false);
            }
          });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              return PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  if (!_isAnimatingToPage &&
                      index != widget.navigationShell.currentIndex) {
                    widget.navigationShell.goBranch(index);
                  }
                },
                itemCount: widget.children.length,
                itemBuilder: (context, index) {
                  double value = 0;
                  if (_pageController.position.hasContentDimensions) {
                    value = (_pageController.page ?? 0) - index;
                  } else {
                    value =
                        (widget.navigationShell.currentIndex).toDouble() -
                        index;
                  }

                  final double scale = (1 - (value.abs() * 0.15)).clamp(
                    0.85,
                    1.0,
                  );
                  final double opacity = (1 - (value.abs() * 0.5)).clamp(
                    0.0,
                    1.0,
                  );

                  return Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: scale,
                      child: widget.children[index],
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingNavBar(navigationShell: widget.navigationShell),
          ),
        ],
      ),
    );
  }
}
