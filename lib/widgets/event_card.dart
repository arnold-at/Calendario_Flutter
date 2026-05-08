import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event_model.dart';
import '../theme/app_theme.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final bool compact;

  const EventCard({super.key, required this.event, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final cat = event.category;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Color bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: cat.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: compact ? 10 : 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Category chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: cat.lightColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(cat.icon,
                                  size: 10, color: cat.color),
                              const SizedBox(width: 4),
                              Text(
                                cat.label.toUpperCase(),
                                style: GoogleFonts.dmSans(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: cat.color,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          event.timeLabel,
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.title,
                      style: GoogleFonts.cormorant(
                        fontSize: compact ? 17 : 19,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    if (event.subtitle != null && !compact) ...[
                      const SizedBox(height: 3),
                      Text(
                        event.subtitle!,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                    if (event.location != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.place_outlined,
                              size: 12, color: AppTheme.textTertiary),
                          const SizedBox(width: 3),
                          Text(
                            event.location!,
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              color: AppTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Timeline EventCard ────────────────────────────────────────────────────
class TimelineEventCard extends StatelessWidget {
  final EventModel event;

  const TimelineEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final cat = event.category;
    final durationH = event.durationMinutes / 60.0;
    final minHeight = 64.0;
    final height = (durationH * 80).clamp(minHeight, 200.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: cat.lightColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cat.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: cat.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cormorant(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (height > 72) ...[
            const SizedBox(height: 4),
            Text(
              event.timeLabel,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: cat.color.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}