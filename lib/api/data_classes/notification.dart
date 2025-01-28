class Notification {
  final String message;
  final String category;
  final DateTime date;
  final bool seen;
  const Notification(
      {required this.message,
      required this.category,
      required this.date,
      required this.seen});
}
