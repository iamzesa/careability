import 'package:flutter/material.dart';

class MyDropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;

  const MyDropdownField({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}
