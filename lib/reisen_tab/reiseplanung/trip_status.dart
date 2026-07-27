enum TripStatus { upcoming, ongoing, completed }

TripStatus getTripStatus(DateTime start, DateTime end) {
  final today = DateTime.now();

  final currentDay = DateTime(today.year, today.month, today.day);

  final startDay = DateTime(start.year, start.month, start.day);

  final endDay = DateTime(end.year, end.month, end.day);

  if (currentDay.isBefore(startDay)) {
    return TripStatus.upcoming;
  }

  if (currentDay.isAfter(endDay)) {
    return TripStatus.completed;
  }

  return TripStatus.ongoing;
}
