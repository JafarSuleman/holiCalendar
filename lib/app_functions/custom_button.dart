import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final IconData? iconData;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.width,
    this.height,
    this.iconData,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  var size, height, width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xffE25E2A) ,// Text color
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 10), // Button padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Button border radius
          ),
        ),
        child: Row(
          // Row to contain icon and text
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.iconData != null) // Conditionally add icon
              Icon(widget.iconData),
            const SizedBox(width: 8), // Space between icon and text
            Text(
              widget.buttonText,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
