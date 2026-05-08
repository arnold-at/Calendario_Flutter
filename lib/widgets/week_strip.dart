import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../data/dummy_data.dart';

class WeekStrip extends StatelessWidget {
  final DateTime weekStart;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDayTap;

  const WeekStrip({
    super.key,
    required this.weekStart,
    required this.selectedDay,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      child: Row(
        children: List.generate(7, (i) {
          final day = weekStart.add(Duration(days: i));
          final isSelected = _isSameDay(day, selectedDay);
          final isToday = _isSameDay(day, DateTime.now());
          final hasEvents = eventsForDay(day).isNotEmpty;

          return Expanded(
            child: GestureDetector(
              onTap: () => onDayTap(day),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.accent
                      : isToday
                          ? AppTheme.accentLight
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('E').format(day).substring(0, 1).toUpperCase(),
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: isSelected
                            ? Colors.white.withOpacity(0.8)
                            : AppTheme.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${day.day}',
                      style: GoogleFonts.cormorant(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : isToday
                                ? AppTheme.accentDark
                                : AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (hasEvents)
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.7)
                              : AppTheme.accent,
                          shape: BoxShape.circle,
                        ),
                      )
                    else
                      const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}