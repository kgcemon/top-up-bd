String timeAgo(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inMinutes < 1) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes == 1) {
    return '1 minute ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours == 1) {
    return '1 hour ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays == 1) {
    return '1 day ago';
  } else {
    return '${difference.inDays} days ago';
  }
}