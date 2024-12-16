import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItems extends StatefulWidget {
  const MenuItems(
      {super.key,
      required this.selected,
      required this.menuSelect,
      required this.title,
      required this.icon});

  final bool selected;
  final Function() menuSelect;
  final String title;
  final Widget icon;

  @override
  State<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  bool ishovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        ishovered = true;
      }),
      onExit: (event) => setState(() {
        ishovered = false;
      }),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.selected || ishovered
              ? const Color(0xffFACB01).withOpacity(0.3)
              : Colors.white,
        ),
        child: ListTile(
          onTap: widget.menuSelect,
          leading: widget.icon,
          title: Text(
            widget.title,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight:
                    widget.selected || ishovered ? FontWeight.bold : null),
          ),
        ),
      ),
    );
  }
}
