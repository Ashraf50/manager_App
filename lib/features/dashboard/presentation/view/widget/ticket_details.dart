import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manager_app/core/constant/app_colors.dart';
import 'package:manager_app/core/constant/app_styles.dart';
import 'package:manager_app/core/widget/custom_app_bar.dart';
import 'package:manager_app/core/widget/custom_scaffold.dart';
import 'package:manager_app/features/all_tickets/presentation/view/widget/status_button.dart';
import 'package:manager_app/features/chat/presentation/view_model/cubit/chat_cubit.dart';
import 'package:manager_app/features/dashboard/data/model/statistics/recent_ticket.dart';
import 'package:manager_app/generated/l10n.dart';
import '../../../../all_tickets/presentation/view/widget/chat_custom_button.dart';
import '../../../../all_tickets/presentation/view/widget/ticket_details_view.dart';

class DashboardTicketDetails extends StatelessWidget {
  final RecentTicket ticket;
  const DashboardTicketDetails({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: S.of(context).ticket_details,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                CustomWidget(
                  title: "${S.of(context).ticketId}: ",
                  subTitle: ticket.id.toString(),
                ),
                CustomWidget(
                  title: "${S.of(context).title}: ",
                  subTitle: ticket.title ?? "No Title",
                ),
                CustomWidget(
                  title: "${S.of(context).created_at}: ",
                  subTitle:
                      formatDateWithOrdinal(ticket.createdAt.toString()) ??
                          S.of(context).no_details,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).status,
                      style: AppStyles.textStyle16,
                    ),
                    StatusButton(
                      status: ticket.status!,
                      isOverdue: ticket.isOverdue ?? false,
                    ),
                  ],
                ),
                CustomWidget(
                  title: "${S.of(context).manager_name}: ",
                  subTitle: ticket.manager?.user?.name ?? "N/A",
                ),
                CustomWidget(
                  title: "${S.of(context).service_name}: ",
                  subTitle: ticket.service?.name ?? "N/A",
                ),
                CustomWidget(
                  title: "${S.of(context).user_name}: ",
                  subTitle: ticket.user?.name ?? "N/A",
                ),
                CustomWidget(
                  title: "${S.of(context).ticketian_name}: ",
                  subTitle: ticket.technician?.user?.name ?? "N/A",
                ),
                CustomWidget(
                  title: "${S.of(context).max_time}: ",
                  subTitle: '${ticket.maxMinutes.toString()} m' ?? "N/A",
                ),
                CustomWidget(
                  title: "${S.of(context).assigned_at}: ",
                  subTitle:
                      formatDateWithOrdinal(ticket.assignedAt.toString()) ??
                          "N/A",
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 8,
            ),
            if (ticket.status == 0) ...[
              Text(
                S.of(context).quick_chat,
                style: AppStyles.textStyle18bold,
              ),
              CustomChatButton(
                title: S.of(context).chat_with_user,
                color: AppColors.activeBlue,
                onTap: () {
                  final userId = ticket.user?.id;
                  if (userId != null) {
                    context.read<ChatCubit>().handleChatWithUser(
                        userId, ticket.id.toString(), context);
                  }
                },
              ),
            ] else if (ticket.status != 2) ...[
              Text(
                S.of(context).quick_chat,
                style: AppStyles.textStyle18bold,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomChatButton(
                    title: S.of(context).chat_with_user,
                    color: AppColors.activeBlue,
                    onTap: () {
                      final userId = ticket.user?.id;
                      if (userId != null) {
                        context.read<ChatCubit>().handleChatWithUser(
                            userId, ticket.id.toString(), context);
                      }
                    },
                  ),
                  if (ticket.technician?.user?.id != null)
                    CustomChatButton(
                      title: S.of(context).chat_with_ticket,
                      color: AppColors.darkBlue,
                      onTap: () {
                        final ticketianId = ticket.technician?.user!.id;
                        if (ticketianId != null) {
                          context.read<ChatCubit>().handleChatWithUser(
                              ticketianId, ticket.id.toString(), context);
                        }
                      },
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
