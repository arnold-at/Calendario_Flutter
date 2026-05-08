import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum EventCategory { work, personal, health, social, focus }

extension EventCategoryExt on EventCategory {
  String get label {
    switch (this) {
      case EventCategory.work:     return 'Work';
      case EventCategory.personal: return 'Personal';
      case EventCategory.health:   return 'Health';
      case EventCategory.social:   return 'Social';
      case EventCategory.focus:    return 'Focus';
    }
  }

  Color get color {
    switch (this) {
      case EventCategory.work:     return AppTheme.catWork;
      case EventCategory.personal: return AppTheme.catPersonal;
      case EventCategory.health:   return AppTheme.catHealth;
      case EventCategory.social:   return AppTheme.catSocial;
      case EventCategory.focus:    return AppTheme.catFocus;
    }
  }

  Color get lightColor {
    return color.withOpacity(0.12);
  }

  IconData get icon {
    switch (this) {
      case EventCategory.work:     return Icons.work_outline_rounded;
      case EventCategory.personal: return Icons.person_outline_rounded;
      case EventCategory.health:   return Icons.favorite_border_rounded;
      case EventCategory.social:   return Icons.group_outlined;
      case EventCategory.focus:    return Icons.center_focus_strong_outlined;
    }
  }
}

class EventModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? location;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay? endTime;
  final EventCategory category;
  final bool isAllDay;

  const EventModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.location,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.category,
    this.isAllDay = false,
  });

  String get timeLabel {
    if (isAllDay) return 'All day';
    final start = _formatTime(startTime);
    if (endTime == null) return start;
    return '$start – ${_formatTime(endTime!)}';
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'am' : 'pm';
    return '$h:$m $period';
  }

  int get durationMinutes {
    if (endTime == null) return 60;
    final startMin = startTime.hour * 60 + startTime.minute;
    final endMin = endTime!.hour * 60 + endTime!.minute;
    return endMin - startMin;
  }
}