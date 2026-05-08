import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../data/dummy_data.dart';
import '../models/event_model.dart';
import '../widgets/event_card.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = List.generate(7, (i) => today.add(Duration(days: i)));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(today),
            _buildWeekProgressBar(today),
            Expanded(child: _buildAgendaList(days, today)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DateTime today) {
    final greeting = _getGreeting();
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: AppTheme.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Your week ahead',
                  style: GoogleFonts.cormorant(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          _buildWeekSummaryBadge(today),
        ],
      ),
    );
  }

  Widget _buildWeekSummaryBadge(DateTime today) {
    int total = 0;
    for (int i = 0; i < 7; i++) {
      total += eventsForDay(today.add(Duration(days: i))).length;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.accentLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accent.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            '$total',
            style: GoogleFonts.cormorant(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppTheme.accentDark,
              height: 1,
            ),
          ),
          Text(
            'events',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.accent,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekProgressBar(DateTime today) {
    final weekday = today.weekday; // 1=Mon, 7=Sun
    final progress = (weekday - 1) / 6.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Week ${_weekNumber(today)}',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textTertiary,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}% complete',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.surfaceMuted,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgendaList(List<DateTime> days, DateTime today) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: days.length,
      itemBuilder: (context, i) {
        final day = days[i];
        final events = eventsForDay(day);
        final isToday = i == 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DayHeader(day: day, isToday: isToday, eventCount: events.length),
            if (events.isEmpty) _buildEmptyDayRow() else
              ...events.map((e) => EventCard(event: e)),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildEmptyDayRow() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.cardBorder,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline,
              size: 16, color: AppTheme.textTertiary.withOpacity(0.5)),
          const SizedBox(width: 10),
          Text(
            'Nothing scheduled — enjoy the space',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'GOOD MORNING';
    if (hour < 17) return 'GOOD AFTERNOON';
    return 'GOOD EVENING';
  }

  int _weekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final diff = date.difference(startOfYear).inDays;
    return ((diff + startOfYear.weekday - 1) / 7).ceil();
  }
}

class _DayHeader extends StatelessWidget {
  final DateTime day;
  final bool isToday;
  final int eventCount;

  const _DayHeader({
    required this.day,
    required this.isToday,
    required this.eventCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Day number circle
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isToday ? AppTheme.accent : AppTheme.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE').format(day).substring(0, 3).toUpperCase(),
                  style: GoogleFonts.dmSans(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: isToday
                        ? Colors.white.withOpacity(0.8)
                        : AppTheme.textTertiary,
                  ),
                ),
                Text(
                  '${day.day}',
                  style: GoogleFonts.cormorant(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isToday ? Colors.white : AppTheme.textPrimary,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isToday ? 'Today' : DateFormat('EEEE').format(day),
                style: GoogleFonts.cormorant(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isToday ? AppTheme.accent : AppTheme.textPrimary,
                ),
              ),
              Text(
                DateFormat('MMMM d').format(day),
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (eventCount > 0)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isToday ? AppTheme.accentLight : AppTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$eventCount',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isToday ? AppTheme.accentDark : AppTheme.textTertiary,
                ),
              ),
            ),
          // Decorative line
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 0.5,
              color: AppTheme.cardBorder,
            ),
          ),
        ],
      ),
    );
  }
}