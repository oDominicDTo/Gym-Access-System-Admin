import 'package:flutter/material.dart';

class CustomCardButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;

  const CustomCardButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.iconColor,
  }) : super(key: key);

  @override
  State<CustomCardButton> createState() => _CustomCardButtonState();
}

class _CustomCardButtonState extends State<CustomCardButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onHover: (hovered) {
        setState(() {
          isHovered = hovered;
        });
      },
      child: Card(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 500,
          height: 120,
          decoration: BoxDecoration(
            color: isHovered ? Colors.blue.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: Colors.blueGrey,
              width: isHovered ? 2.0 : 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 40,
                  color: isHovered ? Colors.blue : widget.iconColor,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: isHovered ? Colors.blue : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
