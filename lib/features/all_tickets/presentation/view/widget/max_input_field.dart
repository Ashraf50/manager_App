import 'package:flutter/material.dart';
import 'package:manager_app/generated/l10n.dart';

class MaxTimeInputField extends StatelessWidget {
  final TextEditingController controller;

  const MaxTimeInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: S.of(context).enter_time,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        prefixIcon: const Icon(
          Icons.timer,
          color: Colors.grey,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).empty_field;
        }
        final parsed = int.tryParse(value);
        if (parsed == null || parsed <= 0) {
          return S.of(context).positive_num;
        }
        return null;
      },
    );
  }
}
