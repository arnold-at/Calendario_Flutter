import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../data/dummy_data.dart';
import '../models/event_model.dart';
import '../widgets/week_strip.dart';
import '../widgets/event_card.dart';

class DayEventsScreen extends StatefulWidget {
  const DayEventsScreen({super.key});

  @override
  State<DayEventsScreen> createState() => _DayEventsScreenState();
}

class _DayEventsScreenState extends State<DayEventsScreen> {
  late DateTime _selectedDay;
  late DateTime _weekStart;

  final ScrollController _timelineScroll = ScrollController();

  static const double _hourHeight = 64.0;
  static const int _startHour = 6;
  static const int _endHour = 23;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _weekStart = _getWeekStart(_selectedDay);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToNow());
  }

  @override
  void dispose() {
    _timelineScroll.dispose();
    super.dispose();
  }

  DateTime _getWeekStart(DateTime d) {
    return DateTime(d.year, d.month, d.day - (d.weekday - 1));
  }

  void _scrollToNow() {
    final now = TimeOfDay.now();
    final offset = ((now.hour - _startHour) * _hourHeight) - 80;
    if (_timelineScroll.hasClients) {
      _timelineScroll.animateTo(
        offset.clamp(0.0, double.infinity),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = eventsForDay(_selectedDay);
    final isToday = _isSameDay(_selectedDay, DateTime.now());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isToday),
            _buildWeekStrip(),
            _buildDayStats(events),
            Expanded(child: _buildTimeline(events)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isToday) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isToday ? 'TODAY' : DateFormat('EEEE').format(_selectedDay).toUpperCase(),
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppTheme.accent,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: DateFormat('d').format(_selectedDay),
                      style: GoogleFonts.cormorant(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        height: 1.0,
                      ),
                    ),
                    TextSpan(
                      text: '  ${DateFormat('MMMM').format(_selectedDay)}',
                      style: GoogleFonts.cormorant(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondary,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildDayNav(),
        ],
      ),
    );
  }

  Widget _buildDayNav() {
    return Row(
      children: [
        _SmallIconBtn(
          icon: Icons.chevron_left_rounded,
          onTap: () => setState(() {
            _selectedDay = _selectedDay.subtract(const Duration(days: 1));
            _weekStart = _getWeekStart(_selectedDay);
          }),
        ),
        const SizedBox(width: 6),
        _SmallIconBtn(
          icon: Icons.chevron_right_rounded,
          onTap: () => setState(() {
            _selectedDay = _selectedDay.add(const Duration(days: 1));
            _weekStart = _getWeekStart(_selectedDay);
          }),
        ),
      ],
    );
  }

  Widget _buildWeekStrip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: WeekStrip(
        weekStart: _weekStart,
        selectedDay: _selectedDay,
        onDayTap: (day) => setState(() => _selectedDay = day),
      ),
    );
  }

  Widget _buildDayStats(List<EventModel> events) {
    if (events.isEmpty) return const SizedBox.shrink();

    final categories = <EventCategory, int>{};
    for (final e in events) {
      categories[e.category] = (categories[e.category] ?? 0) + 1;
    }

    return Container(
      height: 46,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Center(
              child: Text(
                '${events.length} events',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
          ...categories.entries.map((entry) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: entry.key.lightColor,
              borderRadius: BorderRadius.circular(23),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(entry.key.icon, size: 12, color: entry.key.color),
                const SizedBox(width: 5),
                Text(
                  entry.key.label,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: entry.key.color,
                  ),
                ),
                if (entry.value > 1) ...[
                  const SizedBox(width: 4),
                  Text(
                    '×${entry.value}',
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      color: entry.key.color.withOpacity(0.7),
                    ),
                  ),
                ]
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTimeline(List<EventModel> events) {
    final totalHours = _endHour - _startHour;
    final totalHeight = totalHours * _hourHeight;

    final now = TimeOfDay.now();
    final nowOffset = (now.hour - _startHour + now.minute / 60.0) * _hourHeight;

    return SingleChildScrollView(
      controller: _timelineScroll,
      padding: const EdgeInsets.fromLTRB(0, 8, 20, 100),
      child: SizedBox(
        height: totalHeight + 60,
        child: Stack(
          children: [
            // Hour lines
            ...List.generate(totalHours + 1, (i) {
              final hour = _startHour + i;
              final y = i * _hourHeight;
              return Positioned(
                top: y,
                left: 0,
                right: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 56,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          hour == 12
                              ? '12 pm'
                              : hour > 12
                                  ? '${hour - 12} pm'
                                  : '$hour am',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 0.5,
                        color: AppTheme.cardBorder,
                        margin: const EdgeInsets.only(top: 7),
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Event blocks
            ...events.where((e) => !e.isAllDay).map((event) {
              final startMin = event.startTime.hour * 60 + event.startTime.minute;
              final top = (startMin / 60 - _startHour) * _hourHeight;

              return Positioned(
                top: top,
                left: 56,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: TimelineEventCard(event: event),
                ),
              );
            }),

            // All-day events
            if (events.any((e) => e.isAllDay))
              Positioned(
                top: 0,
                left: 56,
                right: 0,
                child: Column(
                  children: events
                      .where((e) => e.isAllDay)
                      .map((e) => Container(
                            margin: const EdgeInsets.only(left: 8, bottom: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: e.category.lightColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: e.category.color.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              e.title,
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: e.category.color,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),

            // Current time indicator
            if (_isSameDay(_selectedDay, DateTime.now()) &&
                nowOffset > 0 &&
                nowOffset < totalHeight)
              Positioned(
                top: nowOffset - 1,
                left: 44,
                right: 0,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1.5,
                        color: AppTheme.accent,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _SmallIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SmallIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppTheme.textSecondary),
      ),
    );
  }
}