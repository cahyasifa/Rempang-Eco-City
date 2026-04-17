import 'package:flutter/material.dart';

class RoleSwitch extends StatelessWidget {
  final String role;
  final Function(String) onChanged;

  RoleSwitch({required this.role, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: Text("Produsen"),
          selected: role == "produsen",
          onSelected: (_) => onChanged("produsen"),
        ),
        SizedBox(width: 10),
        ChoiceChip(
          label: Text("Mitra"),
          selected: role == "mitra",
          onSelected: (_) => onChanged("mitra"),
        ),
      ],
    );
  }
}