import 'package:manager_app/features/add_ticketian/data/model/ticketian_model/section.dart';
import 'user.dart';

class TicketianModel {
  int? id;
  User? user;
  SectionModel? section;

  TicketianModel({this.id, this.user, this.section});

  factory TicketianModel.fromJson(Map<String, dynamic> json) {
    return TicketianModel(
      id: json['id'] as int?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      section: json['section'] != null
          ? SectionModel.fromJson(json['section'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user?.toJson(),
      };
}
