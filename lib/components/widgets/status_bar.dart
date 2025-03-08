import 'package:flutter/material.dart';
import 'package:medication_compliance_tool/utils/constants.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 640;

    return Container(
      width: double.infinity,
      height: 35,
      color: AppColors.statusBarBackground,
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10 : 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Time
          _buildTimeWidget(),

          // Center - Notch
          _buildNotchWidget(),

          // Right side - Status icons
          _buildStatusIcons(),
        ],
      ),
    );
  }

  Widget _buildTimeWidget() {
    return SizedBox(
      width: 78,
      height: 15,
      child: CustomPaint(painter: TimeWidgetPainter()),
    );
  }

  Widget _buildNotchWidget() {
    return Positioned(
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: 21,
          height: 21,
          child: CustomPaint(painter: NotchPainter()),
        ),
      ),
    );
  }

  Widget _buildStatusIcons() {
    return Row(
      children: [
        _buildIcon(AlarmIconPainter(), 15, 15),
        const SizedBox(width: 2),
        _buildIcon(VolumeIconPainter(), 15, 15),
        const SizedBox(width: 2),
        _buildIcon(WifiIconPainter(), 15, 15),
        const SizedBox(width: 2),
        _buildIcon(CellIconPainter(), 15, 15),
        const SizedBox(width: 2),
        _buildIcon(CellIconPainter(), 15, 15), // Second cell icon
        const SizedBox(width: 2),
        Transform.rotate(
          angle: -1.5708, // -90 degrees in radians
          child: _buildIcon(BatteryIconPainter(), 16, 16),
        ),
      ],
    );
  }

  Widget _buildIcon(CustomPainter painter, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: painter),
    );
  }
}

// Custom painters for each icon
class TimeWidgetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // This is a simplified representation of the time widget
    // In a real app, you would draw the actual time text
    final textSpan = TextSpan(
      text: '9:41',
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(0, 0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NotchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

    // Draw the outer circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );

    // Draw the inner circle
    paint.color = Color(0xFF2F2D2D);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 4.5,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AlarmIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    // Draw a simplified alarm clock icon
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2.5, paint);

    // Draw clock hands
    canvas.drawLine(
      center,
      Offset(center.dx, center.dy - size.height / 4),
      paint,
    );
    canvas.drawLine(
      center,
      Offset(center.dx + size.width / 4, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class VolumeIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    // Draw a simplified volume icon
    final Path path = Path();
    path.moveTo(size.width / 4, size.height * 0.4);
    path.lineTo(size.width / 8, size.height * 0.4);
    path.lineTo(size.width / 8, size.height * 0.6);
    path.lineTo(size.width / 4, size.height * 0.6);
    path.lineTo(size.width / 2, size.height * 0.8);
    path.lineTo(size.width / 2, size.height * 0.2);
    path.lineTo(size.width / 4, size.height * 0.4);
    canvas.drawPath(path, paint);

    // Draw sound waves
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width / 2,
        height: size.height / 2,
      ),
      -0.5,
      1,
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.7,
        height: size.height * 0.7,
      ),
      -0.5,
      1,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WifiIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    // Draw a simplified WiFi icon
    for (int i = 0; i < 3; i++) {
      final radius = size.width / 2 - (i * size.width / 6);
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height + size.height / 4),
          width: radius * 2,
          height: radius * 2,
        ),
        3.14,
        3.14,
        true,
        paint,
      );
    }

    // Draw the dot at the bottom
    canvas.drawCircle(
      Offset(size.width / 2, size.height - size.height / 8),
      size.width / 12,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CellIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    // Draw a simplified cell signal icon
    final path = Path();
    path.moveTo(size.width / 8, size.height * 0.8);
    path.lineTo(size.width * 0.9, size.height * 0.8);
    path.lineTo(size.width * 0.9, size.height * 0.2);
    path.lineTo(size.width / 8, size.height * 0.8);
    canvas.drawPath(path, paint);

    // Draw the signal bar
    final barPath = Path();
    barPath.moveTo(size.width * 0.7, size.height * 0.8);
    barPath.lineTo(size.width * 0.85, size.height * 0.8);
    barPath.lineTo(size.width * 0.85, size.height * 0.4);
    barPath.lineTo(size.width * 0.7, size.height * 0.4);
    barPath.close();
    canvas.drawPath(barPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BatteryIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    // Draw battery outline
    final RRect batteryOutline = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.2,
        size.width * 0.8,
        size.height * 0.6,
      ),
      Radius.circular(2),
    );
    canvas.drawRRect(batteryOutline, paint);

    // Draw battery cap
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.4,
        size.height * 0.1,
        size.width * 0.2,
        size.height * 0.1,
      ),
      paint,
    );

    // Draw battery level
    paint.style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.15,
        size.height * 0.25,
        size.width * 0.5,
        size.height * 0.5,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
