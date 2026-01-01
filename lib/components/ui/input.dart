import 'package:flutter/material.dart';
import '../styles/color.dart';

class InputField extends StatefulWidget {
  final Function(String) onSubmit;

  const InputField({super.key, required this.onSubmit});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final TextEditingController _controller = TextEditingController();

  void _handleSubmitted() {
    if (_controller.text.isNotEmpty) {
      widget.onSubmit(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15), // Glass effect
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "What needs to be done?",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.white),
            onPressed: _handleSubmitted,
          ),
        ),
        onSubmitted: (_) => _handleSubmitted(),
      ),
    );
  }
}
