import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../data/dummy_data.dart';
import '../models/event_model.dart';
import '../widgets/week_strip.dart';
import '../widgets/event_card.dart';

class CalendarScreen extends StatefulWidget {
  final VoidCallback onGoToDay;
  const CalendarScreen({super.key, required this.onGoToDay});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _weekStart = _getWeekStart(_selectedDay);
  }

  DateTime _getWeekStart(DateTime d) {
    final weekday = d.weekday; // 1=Mon
    return DateTime(d.year, d.month, d.day - (weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    final events = eventsForDay(_selectedDay);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildWeekGrid(),
            _buildDayPreview(events),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM').format(_selectedDay).toUpperCase(),
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppTheme.accent,
                ),
              ),
              Text(
                DateFormat('yyyy').format(_selectedDay),
                style: GoogleFonts.cormorant(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  height: 1.0,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => setState(() {
              _selectedDay = DateTime.now();
              _weekStart = _getWeekStart(_selectedDay);
            }),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Today',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        children: [
          // Navigation row
          Row(
            children: [
              _WeekNavBtn(
                icon: Icons.chevron_left_rounded,
                onTap: () => setState(() {
                  _weekStart = _weekStart.subtract(const Duration(days: 7));
                  _selectedDay = _weekStart;
                }),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    _weekRangeLabel(),
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
              _WeekNavBtn(
                icon: Icons.chevron_right_rounded,
                onTap: () => setState(() {
                  _weekStart = _weekStart.add(const Duration(days: 7));
                  _selectedDay = _weekStart;
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          WeekStrip(
            weekStart: _weekStart,
            selectedDay: _selectedDay,
            onDayTap: (day) => setState(() => _selectedDay = day),
          ),
          const SizedBox(height: 4),
          // Mini event dots row
          _buildMiniEventRow(),
        ],
      ),
    );
  }

  Widget _buildMiniEventRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        children: List.generate(7, (i) {
          final day = _weekStart.add(Duration(days: i));
          final events = eventsForDay(day);
          if (events.isEmpty) return const Expanded(child: SizedBox());

          final cats = events.map((e) => e.category).toSet().take(3).toList();
          return Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: cats.map((c) => Container(
                width: 5,
                height: 5,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: c.color.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              )).toList(),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDayPreview(List<EventModel> events) {
    final isToday = _isSameDay(_selectedDay, DateTime.now());

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
            child: Row(
              children: [
                Text(
                  isToday
                      ? 'Today'
                      : DateFormat('EEEE, d').format(_selectedDay),
                  style: GoogleFonts.cormorant(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.accentLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${events.length} event${events.length != 1 ? 's' : ''}',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentDark,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onGoToDay,
                  child: Text(
                    'See all →',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: events.isEmpty
                ? _buildEmptyDay()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: events.length,
                    itemBuilder: (_, i) => EventCard(
                      event: events[i],
                      compact: true,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDay() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.event_available_outlined,
                color: AppTheme.textTertiary, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            'Free day',
            style: GoogleFonts.cormorant(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No events scheduled',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, color: Colors.white, size: 20),
                SizedBox(width: 6),
                Text(
                  'New event',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _weekRangeLabel() {
    final end = _weekStart.add(const Duration(days: 6));
    if (_weekStart.month == end.month) {
      return '${DateFormat('MMM d').format(_weekStart)} – ${end.day}';
    }
    return '${DateFormat('MMM d').format(_weekStart)} – ${DateFormat('MMM d').format(end)}';
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _WeekNavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _WeekNavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppTheme.surfaceMuted,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppTheme.textSecondary),
      ),
    );
  }
}