import 'package:flutter/material.dart';
import 'package:manager_app/core/constant/app_colors.dart';
import 'package:manager_app/features/add_ticketian/data/model/ticketian_model/section.dart';

class TicketianDropdownTextField extends StatelessWidget {
  final List<SectionModel> sections;
  final ValueChanged<SectionModel> onChanged;
  final SectionModel? selectedSection;
  final String hint;
  const TicketianDropdownTextField({
    super.key,
    required this.sections,
    required this.onChanged,
    required this.selectedSection,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SectionModel>(
          isExpanded: true,
          value: selectedSection,
          dropdownColor: AppColors.white,
          hint: Text(
            hint,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          items: sections.map((record) {
            return DropdownMenuItem<SectionModel>(
              value: record,
              child: Text(record.name!),
            );
          }).toList(),
          onChanged: (record) {
            if (record != null) {
              onChanged(record);
            }
          },
        ),
      ),
    );
  }
}
