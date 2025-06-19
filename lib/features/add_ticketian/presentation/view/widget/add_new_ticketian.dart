import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:manager_app/core/constant/app_colors.dart';
import 'package:manager_app/core/helper/api_helper.dart';
import 'package:manager_app/core/widget/custom_app_bar.dart';
import 'package:manager_app/core/widget/custom_button.dart';
import 'package:manager_app/core/widget/custom_toast.dart';
import 'package:manager_app/features/add_ticketian/data/model/ticketian_model/section.dart';
import 'package:manager_app/features/add_ticketian/data/repo/ticketian_repo_impl.dart';
import 'package:manager_app/features/add_ticketian/presentation/view/widget/sections_drpo.dart';
import 'package:manager_app/features/add_ticketian/presentation/view_model/cubit/add_ticketian_cubit.dart';
import 'package:manager_app/features/add_ticketian/presentation/view_model/cubit/create_ticketian_cubit.dart';
import 'package:manager_app/features/add_ticketian/presentation/view_model/cubit/selectable_section_cubit.dart';
import 'package:manager_app/generated/l10n.dart';
import '../../../../../../../core/widget/custom_text_field.dart';
import '../../../../../core/constant/app_styles.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class AddNewTicketian extends StatefulWidget {
  final int serviceId;
  const AddNewTicketian({super.key, required this.serviceId});

  @override
  State<AddNewTicketian> createState() => _AddNewTicketianState();
}

class _AddNewTicketianState extends State<AddNewTicketian> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController phonePassController = TextEditingController();
  bool visibility = true;
  final formKey = GlobalKey<FormState>();
  int? selectedServiceId;
  SectionModel? selectedSection;

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateTicketianCubit, CreateTicketianState>(
      listener: (context, state) {
        if (state is CreateTicketianLoading) {
          SmartDialog.showLoading();
        } else if (state is CreateTicketianFailure) {
          SmartDialog.dismiss();
          CustomToast.show(
            message: state.errMessage,
            backgroundColor: Colors.red,
          );
        } else if (state is CreateTicketianSuccess) {
          SmartDialog.dismiss();
          context.pop(context);
          context.read<AddTicketianCubit>().fetchTicketian();
          CustomToast.show(
            message: S.of(context).ticketian_created_successfully,
            alignment: Alignment.topCenter,
            backgroundColor: AppColors.toastColor,
          );
        }
      },
      child: CustomScaffold(
        appBar: CustomAppBar(title: S.of(context).createNew),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  S.of(context).name,
                  style: AppStyles.textStyle18bold,
                ),
                CustomTextfield(
                  hintText: S.of(context).name,
                  controller: nameController,
                ),
                Text(
                  S.of(context).Email,
                  style: AppStyles.textStyle18bold,
                ),
                CustomTextfield(
                  hintText: S.of(context).email,
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return value != null && !EmailValidator.validate(value)
                        ? S.of(context).enter_valid_email
                        : null;
                  },
                ),
                BlocProvider(
                  create: (context) =>
                      SelectableSectionCubit(TicketianRepoImpl(ApiHelper()))
                        ..fetchSelectableSections(serviceId: widget.serviceId),
                  child: BlocBuilder<SelectableSectionCubit,
                      SelectableSectionState>(
                    builder: (context, state) {
                      if (state is FetchSelectableSectionsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is FetchSelectableSectionsFailure) {
                        return Text(state.errMessage);
                      } else if (state is FetchSelectableSectionsSuccess) {
                        if (state.sections.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade100,
                            ),
                            child: Text(
                              S
                                  .of(context)
                                  .noServicesAvailable, // Add this key in .arb files
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }
                        return TicketianDropdownTextField(
                          sections: state.sections,
                          selectedSection: selectedSection,
                          hint: S.of(context).select_section,
                          onChanged: (record) {
                            setState(() {
                              selectedSection = record;
                              selectedServiceId = record.id;
                            });
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                Text(
                  S.of(context).phone,
                  style: AppStyles.textStyle18bold,
                ),
                CustomTextfield(
                  hintText: S.of(context).phone,
                  controller: phonePassController,
                ),
                Text(
                  S.of(context).Password,
                  style: AppStyles.textStyle18bold,
                ),
                CustomTextfield(
                  hintText: S.of(context).password,
                  obscureText: visibility,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        visibility = !visibility;
                      });
                    },
                    icon: visibility
                        ? const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Colors.grey,
                          ),
                  ),
                  controller: passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.length < 8) {
                      return S.of(context).pass_short;
                    } else {
                      return null;
                    }
                  },
                ),
                Text(
                  S.of(context).confirmPassword,
                  style: AppStyles.textStyle18bold,
                ),
                CustomTextfield(
                  hintText: S.of(context).confirmPassword,
                  obscureText: visibility,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        visibility = !visibility;
                      });
                    },
                    icon: visibility
                        ? const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Colors.grey,
                          ),
                  ),
                  controller: confirmPassController,
                ),
                CustomButton(
                  title: S.of(context).submit,
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      final cubit = context.read<CreateTicketianCubit>();
                      await cubit.createTicketian(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phonePassController.text,
                        password: passwordController.text,
                        confirmPass: confirmPassController.text,
                        sectionId: selectedServiceId!,
                      );
                    } else {
                      CustomToast.show(message: S.of(context).check_email);
                    }
                  },
                  color: nameController.text.isEmpty
                      ? AppColors.inActiveBlue
                      : AppColors.activeBlue,
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
