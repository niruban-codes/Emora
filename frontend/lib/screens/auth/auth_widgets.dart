import 'package:flutter/material.dart';

Widget myTextField(String hint, IconData icon, {bool isPass = false}) {
  return TextField(
    obscureText: isPass,
    style: const TextStyle(color: Colors.white, fontSize: 14),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white54, size: 18),
      suffixIcon: isPass
          ? const Icon(Icons.visibility_outlined, color: Colors.white38, size: 18)
          : null,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFF1A1F3A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2E3560), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2E3560), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF5B6EF5), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
    ),
  );
}

Widget socialButton(String label, Widget icon) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: Color(0xFF2E3560)),
        backgroundColor: const Color(0xFF12162B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    ),
  );
}