class ServiceRequest {
  final int id;
  final int serviceId;
  final String title;
  final String description;
  final String requestedAt;
  final String estimatedTime;
  final String status;
  final String room;

  ServiceRequest({
    required this.id,
    required this.serviceId,
    required this.title,
    required this.description,
    required this.requestedAt,
    required this.estimatedTime,
    required this.status,
    required this.room,
  });
}
