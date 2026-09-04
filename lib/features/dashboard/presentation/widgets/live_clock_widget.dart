import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class LiveClockWidget extends StatefulWidget {
  final double size;

  const LiveClockWidget({super.key, this.size = 110});

  @override
  State<LiveClockWidget> createState() => _LiveClockWidgetState();
}

class _LiveClockWidgetState extends State<LiveClockWidget> {
  late DateTime _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getTimezoneAbbreviation() {
    final name = _currentTime.timeZoneName;
    if (name.isNotEmpty && name.length <= 5) return name;
    final offset = _currentTime.timeZoneOffset;
    final hours = offset.inHours;
    final sign = hours >= 0 ? '+' : '';
    return 'GMT$sign$hours';
  }

  @override
  Widget build(BuildContext context) {
    final tz = _getTimezoneAbbreviation();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _AnalogClockPainter(_currentTime),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          tz,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _AnalogClockPainter extends CustomPainter {
  final DateTime dateTime;

  _AnalogClockPainter(this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer Glass Ring
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius - 2, ringPaint);

    // Clock Face Background
    final facePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 3, facePaint);

    // Hour Markers (12, 3, 6, 9)
    const textStyle = TextStyle(
      color: Colors.white70,
      fontSize: 10,
      fontWeight: FontWeight.w700,
      fontFamily: 'Inter',
    );

    final labels = {'12': -math.pi / 2, '3': 0.0, '6': math.pi / 2, '9': math.pi};
    for (final entry in labels.entries) {
      final angle = entry.value;
      final textPainter = TextPainter(
        text: TextSpan(text: entry.key, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      final markerRadius = radius - 14;
      final x = center.dx + markerRadius * math.cos(angle) - (textPainter.width / 2);
      final y = center.dy + markerRadius * math.sin(angle) - (textPainter.height / 2);
      textPainter.paint(canvas, Offset(x, y));
    }

    // Tick Marks for other hours
    final tickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      if (i % 3 == 0) continue; // Skip 12, 3, 6, 9
      final angle = i * math.pi / 6;
      final inner = Offset(
        center.dx + (radius - 12) * math.cos(angle),
        center.dy + (radius - 12) * math.sin(angle),
      );
      final outer = Offset(
        center.dx + (radius - 7) * math.cos(angle),
        center.dy + (radius - 7) * math.sin(angle),
      );
      canvas.drawLine(inner, outer, tickPaint);
    }

    // Time calculations
    final second = dateTime.second;
    final minute = dateTime.minute;
    final hour = dateTime.hour % 12;

    final secondAngle = (second * 6) * math.pi / 180 - math.pi / 2;
    final minuteAngle = ((minute + second / 60) * 6) * math.pi / 180 - math.pi / 2;
    final hourAngle = ((hour + minute / 60) * 30) * math.pi / 180 - math.pi / 2;

    // Hour Hand
    final hourPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    final hourHandEnd = Offset(
      center.dx + (radius * 0.48) * math.cos(hourAngle),
      center.dy + (radius * 0.48) * math.sin(hourAngle),
    );
    canvas.drawLine(center, hourHandEnd, hourPaint);

    // Minute Hand
    final minutePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final minuteHandEnd = Offset(
      center.dx + (radius * 0.68) * math.cos(minuteAngle),
      center.dy + (radius * 0.68) * math.sin(minuteAngle),
    );
    canvas.drawLine(center, minuteHandEnd, minutePaint);

    // Second Hand (Cyan Accent)
    final secondPaint = Paint()
      ..color = const Color(0xFF2DD4BF) // Mint/Cyan accent
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    final secondHandEnd = Offset(
      center.dx + (radius * 0.76) * math.cos(secondAngle),
      center.dy + (radius * 0.76) * math.sin(secondAngle),
    );
    final secondHandTail = Offset(
      center.dx - (radius * 0.15) * math.cos(secondAngle),
      center.dy - (radius * 0.15) * math.sin(secondAngle),
    );
    canvas.drawLine(secondHandTail, secondHandEnd, secondPaint);

    // Center Cap
    final capPaint = Paint()
      ..color = const Color(0xFF2DD4BF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3.5, capPaint);

    final innerCapPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 1.8, innerCapPaint);
  }

  @override
  bool shouldRepaint(covariant _AnalogClockPainter oldDelegate) {
    return oldDelegate.dateTime.second != dateTime.second;
  }
}
