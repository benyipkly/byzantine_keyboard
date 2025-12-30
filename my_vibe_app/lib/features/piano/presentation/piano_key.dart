import 'package:flutter/material.dart';

class PianoKey extends StatefulWidget {
  final bool isBlack;
  final VoidCallback onTrigger;
  final VoidCallback onRelease;
  final String label;
  final bool isPressed;

  const PianoKey({
    super.key,
    required this.isBlack,
    required this.onTrigger,
    required this.onRelease,
    this.label = '',
    this.isPressed = false,
  });

  @override
  State<PianoKey> createState() => _PianoKeyState();
}

class _PianoKeyState extends State<PianoKey> {
  // Track pointers currently touching THIS key
  final Set<int> _activePointers = {};

  void _handlePointerDown(PointerDownEvent event) {
    if (_activePointers.isEmpty) {
      // First touch on this key
      widget.onTrigger();
    }
    _activePointers.add(event.pointer);
    setState(() {});
  }

  void _handlePointerUp(PointerUpEvent event) {
    _activePointers.remove(event.pointer);
    if (_activePointers.isEmpty) {
      // Last touch left this key
      widget.onRelease();
    }
    setState(() {});
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _activePointers.remove(event.pointer);
    if (_activePointers.isEmpty) {
      widget.onRelease();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool active = _activePointers.isNotEmpty || widget.isPressed;
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: widget.isBlack ? 40 : 60,
        height: widget.isBlack ? 150 : 250,
        margin: EdgeInsets.symmetric(horizontal: widget.isBlack ? 2 : 1),
        decoration: BoxDecoration(
          color: widget.isBlack
              ? (active ? Colors.grey[800] : Colors.black)
              : (active ? Colors.grey[300] : Colors.white),
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          widget.label,
          style: TextStyle(
            color: widget.isBlack ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
