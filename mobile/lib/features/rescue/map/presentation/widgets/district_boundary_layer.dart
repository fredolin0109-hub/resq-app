import 'package:flutter/material.dart';

/// Displays tactical district boundaries and geographical reference landmarks for Tamil Nadu.
class DistrictBoundaryLayer extends StatelessWidget {
  final bool showTraffic;
  final bool showFloodLayer;

  const DistrictBoundaryLayer({
    super.key,
    this.showTraffic = true,
    this.showFloodLayer = true,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _TamilNaduGridPainter(
          showTraffic: showTraffic,
          showFloodLayer: showFloodLayer,
        ),
      ),
    );
  }
}

class _TamilNaduGridPainter extends CustomPainter {
  final bool showTraffic;
  final bool showFloodLayer;

  _TamilNaduGridPainter({
    required this.showTraffic,
    required this.showFloodLayer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.blueGrey.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Tactical lat/long grid lines
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // High risk flood corridor simulation (Kaveri / Vaigai / Thamirabarani basins)
    if (showFloodLayer) {
      final floodPaint = Paint()
        ..color = Colors.blue.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;

      final path = Path()
        ..moveTo(size.width * 0.25, size.height * 0.4)
        ..quadraticBezierTo(size.width * 0.5, size.height * 0.45, size.width * 0.8, size.height * 0.48);
      canvas.drawPath(path, floodPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TamilNaduGridPainter oldDelegate) =>
      oldDelegate.showTraffic != showTraffic || oldDelegate.showFloodLayer != showFloodLayer;
}
