import 'package:manager_app/features/add_ticketian/data/model/ticketian_model/service.dart';

class SectionModel {
  int? id;
  String? name;
  int? serviceId;
  ServiceModel? service;

  SectionModel({
    this.id,
    this.name,
    this.serviceId,
    this.service,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      serviceId: json['service_id'] as int?,
      service:
          json['service'] != null ? ServiceModel.fromJson(json['service']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'service_id': serviceId,
        'service': service?.toJson(),
      };
}
