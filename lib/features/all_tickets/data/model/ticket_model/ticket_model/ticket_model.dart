import 'manager.dart';
import 'service.dart';
import 'technician.dart';
import 'user.dart';

class TicketModel {
  int? id;
  String? title;
  int? status;
  bool? isOverdue;
  String? createdAt;
  String? assignedAt;
  int? maxMinutes;
  String? description;
  Service? service;
  User? user;
  Manager? manager;
  Technician? technician;

  TicketModel({
    this.id,
    this.title,
    this.status,
    this.isOverdue,
    this.createdAt,
    this.assignedAt,
    this.maxMinutes,
    this.description,
    this.service,
    this.user,
    this.manager,
    this.technician,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        id: json['id'] as int?,
        title: json['title'] as String?,
        status: json['status'] as int?,
        createdAt: json['created_at'] as String?,
        assignedAt: json['assigned_at'] as String?,
        isOverdue: json['is_overdue'] as bool?,
        maxMinutes: json['maximum_minutes'] as int?,
        description: json['description'] as String?,
        service: json['service'] == null
            ? null
            : Service.fromJson(json['service'] as Map<String, dynamic>),
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        manager: json['manager'] == null
            ? null
            : Manager.fromJson(json['manager'] as Map<String, dynamic>),
        technician: json['technician'] == null
            ? null
            : Technician.fromJson(json['technician'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'status': status,
        'created_at': createdAt,
        'maximum_minutes': maxMinutes,
        "assigned_at": assignedAt,
        'description': description,
        'service': service?.toJson(),
        'user': user?.toJson(),
        'manager': manager?.toJson(),
        'technician': technician?.toJson(),
        'is_overdue': isOverdue,
      };
}
