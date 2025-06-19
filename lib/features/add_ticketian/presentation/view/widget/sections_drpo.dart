import 'package:flutter/material.dart';
import 'package:manager_app/core/constant/app_colors.dart';
import 'package:manager_app/features/add_ticketian/data/model/ticketian_model/section.dart';
import 'package:manager_app/generated/l10n.dart';

class TicketianDropdownTextField extends StatelessWidget {
  final List<SectionModel> sections;
  final ValueChanged<SectionModel> onChanged;
  final SectionModel? selectedSection;
  const TicketianDropdownTextField({
    super.key,
    required this.sections,
    required this.onChanged,
    required this.selectedSection,
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
            S.of(context).select_section,
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
