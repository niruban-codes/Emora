import 'dart:math';
import 'package:flutter/material.dart';

class BiometricScanScreen extends StatefulWidget {
  const BiometricScanScreen({super.key});

  @override
  State<BiometricScanScreen> createState() => _BiometricScanScreenState();
}

class _BiometricScanScreenState extends State<BiometricScanScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _blinkController;

  double _coordX = 142.88;
  double _coordY = 894.32;
  double _syncProgress = 0.68;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return false;
      setState(() {
        _coordX += (_random.nextDouble() - 0.5) * 0.4;
        _coordY += (_random.nextDouble() - 0.5) * 0.4;
        _coordX = double.parse(_coordX.toStringAsFixed(2));
        _coordY = double.parse(_coordY.toStringAsFixed(2));
        if (_random.nextDouble() < 0.01 && _syncProgress < 1.0) {
          _syncProgress = (_syncProgress + 0.01).clamp(0.0, 1.0);
        }
      });
      return true;
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0D2E),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1135), Color(0xFF0A0D2E)],
          ),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.only(left: 8), // ← adds extra left padding
          child: Column(
            children: [
              // ✅ _buildStatusBar() REMOVED from here
              Expanded(child: _buildScannerArea()),
              _buildProgressSection(),
              _buildInstruction(),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ _buildStatusBar(), _buildSignalIcon(),
  // _buildWifiIcon(), _buildBatteryIcon() ALL DELETED

  Widget _buildScannerArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ..._buildCornerBrackets(),
            SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _rotationController,
                    builder: (_, __) => CustomPaint(
                      size: const Size(280, 280),
                      painter: ScannerPainter(
                        angle: _rotationController.value * 2 * pi,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    right: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'X: ${_coordX.toStringAsFixed(2)}',
                          style: _monoStyle(10, opacity: 0.85),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Y: ${_coordY.toStringAsFixed(2)}',
                          style: _monoStyle(10, opacity: 0.85),
                        ),
                      ],
                    ),
                  ),
                  Positioned(bottom: 55, child: _buildFaceDetectedBadge()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCornerBrackets() {
    const size = 28.0;
    const stroke = 2.0;
    const color = Color(0xFFD864FF);
    const offset = 12.0;

    Widget bracket(AlignmentGeometry alignment, BorderRadius radius) {
      return Positioned(
        top: alignment == Alignment.topLeft || alignment == Alignment.topRight
            ? offset
            : null,
        bottom:
            alignment == Alignment.bottomLeft ||
                alignment == Alignment.bottomRight
            ? offset
            : null,
        left:
            alignment == Alignment.topLeft || alignment == Alignment.bottomLeft
            ? offset
            : null,
        right:
            alignment == Alignment.topRight ||
                alignment == Alignment.bottomRight
            ? offset
            : null,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border(
              top:
                  (alignment == Alignment.topLeft ||
                      alignment == Alignment.topRight)
                  ? const BorderSide(color: color, width: stroke)
                  : BorderSide.none,
              bottom:
                  (alignment == Alignment.bottomLeft ||
                      alignment == Alignment.bottomRight)
                  ? const BorderSide(color: color, width: stroke)
                  : BorderSide.none,
              left:
                  (alignment == Alignment.topLeft ||
                      alignment == Alignment.bottomLeft)
                  ? const BorderSide(color: color, width: stroke)
                  : BorderSide.none,
              right:
                  (alignment == Alignment.topRight ||
                      alignment == Alignment.bottomRight)
                  ? const BorderSide(color: color, width: stroke)
                  : BorderSide.none,
            ),
            borderRadius: radius,
          ),
        ),
      );
    }

    return [
      bracket(
        Alignment.topLeft,
        const BorderRadius.only(topLeft: Radius.circular(4)),
      ),
      bracket(
        Alignment.topRight,
        const BorderRadius.only(topRight: Radius.circular(4)),
      ),
      bracket(
        Alignment.bottomLeft,
        const BorderRadius.only(bottomLeft: Radius.circular(4)),
      ),
      bracket(
        Alignment.bottomRight,
        const BorderRadius.only(bottomRight: Radius.circular(4)),
      ),
    ];
  }

  Widget _buildFaceDetectedBadge() {
    return AnimatedBuilder(
      animation: _blinkController,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0A32).withOpacity(0.75),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD864FF).withOpacity(0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(
                  const Color(0xFF00E5A0),
                  const Color(0xFF00A070),
                  _blinkController.value,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'FACE DETECTED',
              style: _monoStyle(
                9,
                opacity: 0.9,
                color: const Color(0xFFDCFFF0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    final syncPercent = (_syncProgress * 100).round();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('BIOMETRIC FLOW', style: _monoStyle(9, opacity: 0.6)),
              Text('$syncPercent% SYNC', style: _monoStyle(9, opacity: 0.8)),
            ],
          ),
          const SizedBox(height: 6),
          Stack(
            children: [
              Container(
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFB450DC).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              FractionallySizedBox(
                widthFactor: _syncProgress,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA03CDC), Color(0xFFDC64FF)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFDC64FF),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: const Color(0xFFB450DC).withOpacity(0.12),
          ),
        ),
      ),
      child: Text(
        'Align facial markers with the guidance grid..',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFFCCB4E6).withOpacity(0.7),
          fontSize: 12,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _iconButton(Icons.photo_library_outlined),
          _captureButton(),
          _iconButton(Icons.refresh_rounded),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return IconButton(
      icon: Icon(
        icon,
        color: const Color(0xFFB464DC).withOpacity(0.8),
        size: 26,
      ),
      onPressed: () {},
    );
  }

  Widget _captureButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFDC64FF).withOpacity(0.6),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC850FF).withOpacity(0.25),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.3, -0.4),
                colors: [
                  Colors.white.withOpacity(0.15),
                  const Color(0xFFC850FF).withOpacity(0.45),
                  const Color(0xFF8C28C8).withOpacity(0.65),
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFC850FF),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _monoStyle(double size, {double opacity = 1.0, Color? color}) {
    return TextStyle(
      color: (color ?? const Color(0xFFDCA0FF)).withOpacity(opacity),
      fontSize: size,
      fontFamily: 'monospace',
      letterSpacing: 1.2,
    );
  }
}

class ScannerPainter extends CustomPainter {
  final double angle;
  ScannerPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final dashedPaint = Paint()
      ..color = const Color(0xFFB450DC).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final arcPaint = Paint()
      ..color = const Color(0xFFDC64FF).withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final innerRingPaint = Paint()
      ..color = const Color(0xFFB450DC).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final centerRingPaint = Paint()
      ..color = const Color(0xFFDC64FF).withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final crosshairPaint = Paint()
      ..color = const Color(0xFFDC64FF).withOpacity(0.5)
      ..strokeWidth = 1;

    final dotPaint = Paint()
      ..color = const Color(0xFFDC64FF).withOpacity(0.9)
      ..style = PaintingStyle.fill;

    _drawDashedCircle(
      canvas,
      center,
      130,
      dashedPaint,
      dashLength: 6,
      gapLength: 6,
    );

    final arcRect = Rect.fromCircle(center: center, radius: 130);
    canvas.drawArc(arcRect, angle, 1.4, false, arcPaint);

    for (final r in [90.0, 60.0]) {
      canvas.drawCircle(center, r, innerRingPaint);
    }
    canvas.drawCircle(center, 35, centerRingPaint);

    canvas.drawLine(
      Offset(center.dx, center.dy - 60),
      Offset(center.dx, center.dy - 40),
      crosshairPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + 40),
      Offset(center.dx, center.dy + 60),
      crosshairPaint,
    );
    canvas.drawLine(
      Offset(center.dx - 60, center.dy),
      Offset(center.dx - 40, center.dy),
      crosshairPaint,
    );
    canvas.drawLine(
      Offset(center.dx + 40, center.dy),
      Offset(center.dx + 60, center.dy),
      crosshairPaint,
    );

    canvas.drawCircle(center, 4, dotPaint);
    canvas.drawCircle(
      center,
      8,
      Paint()
        ..color = const Color(0xFFDC64FF).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint, {
    required double dashLength,
    required double gapLength,
  }) {
    final circumference = 2 * pi * radius;
    final totalDash = dashLength + gapLength;
    final count = (circumference / totalDash).floor();
    final angleStep = (2 * pi) / count;
    final dashAngle = angleStep * (dashLength / totalDash);

    for (int i = 0; i < count; i++) {
      final startAngle = i * angleStep;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ScannerPainter old) => old.angle != angle;
}
