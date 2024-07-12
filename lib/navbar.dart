import 'package:flutter/material.dart';

class FloatingBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const FloatingBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _FloatingBottomNavBarState createState() => _FloatingBottomNavBarState();
}

class _FloatingBottomNavBarState extends State<FloatingBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FloatingBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Color(0xFFF3520D),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home, 'Beranda', 0),
              _buildNavItem(Icons.article, 'Artikel', 1),
              _buildNavItem(Icons.group, 'Komunitas', 2),
              _buildNavItem(Icons.campaign, 'Laporan', 3),
              _buildNavItem(Icons.person, 'Profil', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = widget.selectedIndex == index;
    return InkWell(
      onTap: () => widget.onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: isSelected ? 1.0 + (_animation.value * 0.2) : 1.0,
                child: child,
              );
            },
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakarta',
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          AnimatedContainer(
            duration: Duration(milliseconds: 350),
            width: isSelected ? 20 : 0,
            height: 2,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
