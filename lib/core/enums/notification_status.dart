enum NotificationStatus {
  accepted,
  pending,
  rejected,

}

extension NotificationStatusExtension on NotificationStatus {
  String get nameSpanish {
    switch (this) {
      case NotificationStatus.accepted:
        return 'Aceptada';
      case NotificationStatus.pending:
        return 'Pendiente';
      case NotificationStatus.rejected:
        return 'Rechazada';
    }
  }

  static NotificationStatus fromName(String label) {
    switch (label.toLowerCase()) {
      case 'accepted':
        return NotificationStatus.accepted;
      case 'pending':
        return NotificationStatus.pending;
      case 'rejected':
        return NotificationStatus.rejected;
      default:
        throw ArgumentError('Unknown notification status: $label');
    }
  }
}
