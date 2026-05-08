import 'package:flutter/material.dart';
import '../models/event_model.dart';

final DateTime _today = DateTime.now();
DateTime _d(int offset) =>
    DateTime(_today.year, _today.month, _today.day + offset);

final List<EventModel> dummyEvents = [
  // ── Today ──────────────────────────────────────────────────
  EventModel(
    id: '1',
    title: 'Morning Standup',
    subtitle: 'Engineering team sync',
    location: 'Google Meet',
    date: _d(0),
    startTime: const TimeOfDay(hour: 9, minute: 0),
    endTime: const TimeOfDay(hour: 9, minute: 30),
    category: EventCategory.work,
  ),
  EventModel(
    id: '2',
    title: 'Deep Work Block',
    subtitle: 'Q4 strategy deck',
    date: _d(0),
    startTime: const TimeOfDay(hour: 10, minute: 0),
    endTime: const TimeOfDay(hour: 12, minute: 0),
    category: EventCategory.focus,
  ),
  EventModel(
    id: '3',
    title: 'Lunch with Clara',
    location: 'Café Libertad',
    date: _d(0),
    startTime: const TimeOfDay(hour: 13, minute: 0),
    endTime: const TimeOfDay(hour: 14, minute: 0),
    category: EventCategory.social,
  ),
  EventModel(
    id: '4',
    title: 'Design Review',
    subtitle: 'Mobile onboarding flow',
    location: 'Room B-12',
    date: _d(0),
    startTime: const TimeOfDay(hour: 15, minute: 30),
    endTime: const TimeOfDay(hour: 16, minute: 30),
    category: EventCategory.work,
  ),
  EventModel(
    id: '5',
    title: 'Yoga',
    location: 'Studio Zen',
    date: _d(0),
    startTime: const TimeOfDay(hour: 18, minute: 30),
    endTime: const TimeOfDay(hour: 19, minute: 30),
    category: EventCategory.health,
  ),

  // ── Tomorrow ───────────────────────────────────────────────
  EventModel(
    id: '6',
    title: 'Product Roadmap',
    subtitle: 'H1 planning session',
    date: _d(1),
    startTime: const TimeOfDay(hour: 10, minute: 0),
    endTime: const TimeOfDay(hour: 11, minute: 30),
    category: EventCategory.work,
  ),
  EventModel(
    id: '7',
    title: 'Doctor Appointment',
    location: 'Clínica del Sol',
    date: _d(1),
    startTime: const TimeOfDay(hour: 13, minute: 0),
    endTime: const TimeOfDay(hour: 14, minute: 0),
    category: EventCategory.health,
  ),
  EventModel(
    id: '8',
    title: 'Book Club',
    subtitle: '"Sapiens" – Capítulo 12',
    location: 'Virtual',
    date: _d(1),
    startTime: const TimeOfDay(hour: 19, minute: 0),
    endTime: const TimeOfDay(hour: 20, minute: 30),
    category: EventCategory.personal,
  ),

  // ── +2 days ───────────────────────────────────────────────
  EventModel(
    id: '9',
    title: 'Sprint Planning',
    subtitle: 'Sprint 24 kickoff',
    date: _d(2),
    startTime: const TimeOfDay(hour: 9, minute: 0),
    endTime: const TimeOfDay(hour: 10, minute: 30),
    category: EventCategory.work,
  ),
  EventModel(
    id: '10',
    title: 'Run – 8km',
    location: 'Parque Kennedy',
    date: _d(2),
    startTime: const TimeOfDay(hour: 7, minute: 0),
    endTime: const TimeOfDay(hour: 7, minute: 50),
    category: EventCategory.health,
  ),
  EventModel(
    id: '11',
    title: 'Team Dinner',
    location: 'La Rosa Náutica',
    date: _d(2),
    startTime: const TimeOfDay(hour: 20, minute: 0),
    endTime: const TimeOfDay(hour: 22, minute: 0),
    category: EventCategory.social,
  ),

  // ── +3 days ───────────────────────────────────────────────
  EventModel(
    id: '12',
    title: 'Investor Call',
    subtitle: 'Series B update',
    date: _d(3),
    startTime: const TimeOfDay(hour: 11, minute: 0),
    endTime: const TimeOfDay(hour: 12, minute: 0),
    category: EventCategory.work,
  ),
  EventModel(
    id: '13',
    title: 'Personal Finance Review',
    date: _d(3),
    startTime: const TimeOfDay(hour: 17, minute: 0),
    endTime: const TimeOfDay(hour: 18, minute: 0),
    category: EventCategory.personal,
  ),

  // ── +4 days ───────────────────────────────────────────────
  EventModel(
    id: '14',
    title: 'Focus Day',
    subtitle: 'No meetings, deep work',
    date: _d(4),
    startTime: const TimeOfDay(hour: 9, minute: 0),
    endTime: const TimeOfDay(hour: 17, minute: 0),
    category: EventCategory.focus,
    isAllDay: true,
  ),
  EventModel(
    id: '15',
    title: 'Piano Lesson',
    location: 'Estudio Armónico',
    date: _d(4),
    startTime: const TimeOfDay(hour: 18, minute: 0),
    endTime: const TimeOfDay(hour: 19, minute: 0),
    category: EventCategory.personal,
  ),

  // ── +5 days ───────────────────────────────────────────────
  EventModel(
    id: '16',
    title: 'Saturday Hike',
    location: 'Lomas de Lúcumo',
    date: _d(5),
    startTime: const TimeOfDay(hour: 7, minute: 30),
    endTime: const TimeOfDay(hour: 11, minute: 0),
    category: EventCategory.health,
  ),
  EventModel(
    id: '17',
    title: 'Family Lunch',
    location: 'Casa de mamá',
    date: _d(5),
    startTime: const TimeOfDay(hour: 13, minute: 0),
    endTime: const TimeOfDay(hour: 16, minute: 0),
    category: EventCategory.personal,
  ),

  // ── +6 days ───────────────────────────────────────────────
  EventModel(
    id: '18',
    title: 'Weekly Reflection',
    date: _d(6),
    startTime: const TimeOfDay(hour: 10, minute: 0),
    endTime: const TimeOfDay(hour: 11, minute: 0),
    category: EventCategory.focus,
  ),
  EventModel(
    id: '19',
    title: 'Dinner with friends',
    location: 'La Pescadería',
    date: _d(6),
    startTime: const TimeOfDay(hour: 20, minute: 30),
    endTime: const TimeOfDay(hour: 23, minute: 0),
    category: EventCategory.social,
  ),
];

List<EventModel> eventsForDay(DateTime day) {
  return dummyEvents.where((e) =>
    e.date.year == day.year &&
    e.date.month == day.month &&
    e.date.day == day.day,
  ).toList()
    ..sort((a, b) {
      final aMin = a.startTime.hour * 60 + a.startTime.minute;
      final bMin = b.startTime.hour * 60 + b.startTime.minute;
      return aMin.compareTo(bMin);
    });
}