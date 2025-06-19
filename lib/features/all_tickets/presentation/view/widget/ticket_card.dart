import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:manager_app/core/constant/app_colors.dart';
import 'package:manager_app/core/constant/app_styles.dart';
import 'package:manager_app/features/all_tickets/presentation/view/widget/max_input_field.dart';
import 'package:manager_app/features/all_tickets/presentation/view/widget/status_button.dart';
import 'package:manager_app/features/all_tickets/presentation/view_model/cubit/ticket_cubit.dart';
import 'package:manager_app/generated/l10n.dart';

class TicketCard extends StatelessWidget {
  final String ticketName;
  final int id;
  final String userName;
  final int status;
  final bool overdue;
  const TicketCard({
    super.key,
    required this.id,
    required this.ticketName,
    required this.userName,
    required this.status,
    required this.overdue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      ticketName,
                      style: AppStyles.textStyle18black,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      Text(
                        userName,
                        style: AppStyles.textStyle16,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  StatusButton(
                    status: status,
                    isOverdue: overdue,
                  ),
                  if (status == 0 || status == 1)
                    PopupMenuButton(
                      color: Colors.white,
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) {
                        final List<PopupMenuItem> items = [];
                        if (status == 0) {
                          items.add(
                            PopupMenuItem(
                              value: 'assign',
                              child: Text(S.of(context).assign),
                            ),
                          );
                        }
                        if (status == 1) {
                          items.add(
                            PopupMenuItem(
                              value: 'finish',
                              child: Text(S.of(context).finish),
                            ),
                          );
                        }
                        if (status == 1) {
                          items.add(
                            PopupMenuItem(
                              value: 'set_max_minutes',
                              child: Text(S.of(context).set_time),
                            ),
                          );
                        }
                        return items;
                      },
                      onSelected: (value) {
                        if (value == 'assign') {
                          context.push(
                            '/assign_ticket',
                            extra: id,
                          );
                        } else if (value == 'finish') {
                          _showFinishDialog(context);
                        } else if (value == 'set_max_minutes') {
                          _showSetMaxTimeDialog(context, id);
                        }
                      },
                    )
                  else
                    const SizedBox(width: 40),
                ],
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _showFinishDialog(BuildContext context) {
    SmartDialog.show(
      builder: (_) => AlertDialog(
        title: Text(S.of(context).confirm_finish),
        content: Text(S.of(context).sure_finish_Ticket),
        actions: [
          TextButton(
            onPressed: () => SmartDialog.dismiss(),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<TicketCubit>().finishTicket(ticketId: id);
              SmartDialog.dismiss();
            },
            child: Text(S.of(context).finish,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSetMaxTimeDialog(BuildContext context, int ticketId) {
    final TextEditingController timeController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    SmartDialog.show(
      builder: (_) => AlertDialog(
        title: Text(
          S.of(context).set_time,
        ),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 300,
            child: MaxTimeInputField(controller: timeController),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => SmartDialog.dismiss(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.darkBlue),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final minutes = int.parse(timeController.text.trim());
                context.read<TicketCubit>().updateMaximumMinutes(
                    ticketId: ticketId, maximumMinutes: minutes);
                SmartDialog.dismiss();
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
