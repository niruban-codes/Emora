import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/screens/emotion/mood_model.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 👈 added
import '../../../services/firestore_service.dart'; // 👈 added

/// EmotionDetectionScreen
///
/// Presents a camera-viewfinder style UI with an "Upload Photo" fallback.
/// Since camera & ML are backend concerns, this screen simulates the flow:
///   1. User sees the viewfinder / upload area.
///   2. They tap "Capture" or "Upload".
///   3. A loading / "analysing" overlay plays.
///   4. Navigation pushes to ResultScreen with a detected MoodModel.
///
/// TODO (backend integration):
///   - Replace [_simulateDetection] with actual camera capture via
///     `camera` package + image upload to your emotion-detection API.
///   - Replace [_simulateDetection] result with the API response string.
///   - Pass the real image bytes to ResultScreen if needed.

class EmotionDetectionScreen extends StatefulWidget {
  const EmotionDetectionScreen({super.key});

  @override
  State<EmotionDetectionScreen> createState() => _EmotionDetectionScreenState();
}

class _EmotionDetectionScreenState extends State<EmotionDetectionScreen>
    with TickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────
  bool _isAnalysing = false;
  bool _imageCaptured = false; // true once user taps capture / selects image
  String? _capturedLabel; // shown in preview after "capture"

  // ── Animation controllers ──────────────────────────────────────────────────
  late AnimationController _scanLineCtrl;
  late Animation<double> _scanLineAnim;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  // ── Scanning line colours cycle ────────────────────────────────────────────
  final List<Color> _scanColors = const [
    Color(0xFF8B2D8B),
    Color(0xFFA7338A),
    Color(0xFF7C4DFF),
  ];
  int _scanColorIndex = 0;

  @override
  void initState() {
    super.initState();

    _scanLineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLineAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _scanLineCtrl, curve: Curves.easeInOut));

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    // Cycle scan line colour
    _scanLineCtrl.addListener(() {
      if (_scanLineCtrl.value == 0) {
        setState(() {
          _scanColorIndex = (_scanColorIndex + 1) % _scanColors.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _scanLineCtrl.dispose();
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Simulated detection ────────────────────────────────────────────────────
  /// Replace this method with your real camera-capture + API call.
  Future<void> _simulateDetection() async {
    setState(() {
      _isAnalysing = true;
      _imageCaptured = true;
    });

    // 1. Simulate network delay
    await Future.delayed(const Duration(milliseconds: 2800));

    // 2. Logic to pick the mood
    final moodIndex = DateTime.now().millisecond % allMoods.length;
    final detectedMood = allMoods[moodIndex];
    final detectedLabel = detectedMood.label.toLowerCase();

    // 3. Save to Firestore (using the label as "emotion" and a dummy insight)
    try {
      await FirestoreService().addEmotion(
        detectedMood.label,
        detectedMood.description,
      );
      print(
        "✅ DB Success: Saved '${detectedMood.label}' to emotion_history",
      ); // Log success
    } catch (e) {
      print(
        "❌ Database Error: $e",
      ); // Log any errors but continue navigation regardless, since this is non-critical for the user flow.
    }

    if (!mounted) return;

    setState(() {
      _isAnalysing = false;
      _capturedLabel = detectedLabel;
    });

    // Brief pause so user sees "captured" state, then navigate
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    context.go('/result', extra: MoodModel.fromString(detectedLabel));
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1135),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSubtitle(),
                      _buildViewfinder(),
                      _buildStatusChips(),
                      Column(
                        children: [
                          _buildCaptureButton(),
                          const SizedBox(height: 10),
                          _buildUploadButton(),
                        ],
                      ),
                      _buildMoodLegend(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Components ─────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          // const Spacer(),
          Expanded(
            child: Center(
              child: Text(
                'Emotion Scan',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 38),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Position your face in the frame\nand let the AI read your emotion',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        color: Colors.white.withOpacity(0.5),
        fontSize: 16,
        height: 1.8,
      ),
    );
  }

  Widget _buildViewfinder() {
    return AnimatedBuilder(
      animation: Listenable.merge([_scanLineAnim, _pulseAnim]),
      builder: (context, _) {
        return Container(
          width: double.infinity,
          height: 370,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: const Color(0xFF151830),
            border: Border.all(
              color: _scanColors[_scanColorIndex].withOpacity(
                _isAnalysing ? _pulseAnim.value : 0.4,
              ),
              width: _isAnalysing ? 2.0 : 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.2,
                      colors: [
                        const Color(0xFF1E1A35),
                        const Color(0xFF0D1135),
                      ],
                    ),
                  ),
                ),

                // Grid overlay (subtle)
                CustomPaint(
                  size: const Size(double.infinity, 370),
                  painter: _GridPainter(),
                ),

                // Centre face guide oval
                Center(
                  child: Container(
                    width: 160,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: _scanColors[_scanColorIndex].withOpacity(0.35),
                        width: 1.5,
                      ),
                    ),
                    child: null,
                  ),
                ),

                // Animated scan line
                if (!_imageCaptured || _isAnalysing)
                  Positioned(
                    top: 20 + (_scanLineAnim.value * 320),
                    left: 24,
                    right: 24,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            _scanColors[_scanColorIndex].withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                // Corner brackets
                ..._cornerBrackets(_scanColors[_scanColorIndex]),

                // NEURAL ANALYSIS badge
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B2D8B),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'NEURAL ANALYSIS',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                // Status text
                Positioned(
                  top: 40,
                  left: 14,
                  child: Text(
                    _isAnalysing
                        ? 'STATUS: ANALYSING...'
                        : _imageCaptured
                        ? 'STATUS: DETECTED'
                        : 'STATUS: READY',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 9,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                // Analysing spinner overlay
                if (_isAnalysing)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.45),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                _scanColors[_scanColorIndex],
                              ),
                              strokeWidth: 2.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Mapping emotion...',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Coordinates — bottom-right
                Positioned(
                  bottom: 14,
                  right: 14,
                  child: Row(
                    children: [
                      Text(
                        'X: 42.1  Y: 88.4',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 9,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.adjust,
                        color: _scanColors[_scanColorIndex],
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChips() {
    final chips = [
      (Icons.face_retouching_natural_outlined, 'Face Detected'),
      (Icons.lightbulb_outline, 'Lighting OK'),
      (Icons.center_focus_strong_outlined, 'In Focus'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: chips.map((chip) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(chip.$1, color: const Color(0xFF8B2D8B), size: 13),
              const SizedBox(width: 5),
              Text(
                chip.$2,
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 10),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCaptureButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isAnalysing ? null : _simulateDetection,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B2D8B),
          disabledBackgroundColor: const Color(0xFF8B2D8B).withOpacity(0.4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 8,
          shadowColor: const Color(0xFF8B2D8B).withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              _isAnalysing ? 'Analysing...' : 'Capture & Detect',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _isAnalysing ? null : _simulateDetection,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white.withOpacity(0.25)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        icon: Icon(
          Icons.upload_file_outlined,
          color: Colors.white.withOpacity(0.65),
          size: 20,
        ),
        label: Text(
          'Upload a Photo Instead',
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.65),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Driven entirely by allMoods — no hardcoded labels or colours here.
  Widget _buildMoodLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DETECTABLE EMOTIONS',
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.4),
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allMoods.map((mood) {
            final color = mood.labelColor;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  //Text(mood.emoji, style: const TextStyle(fontSize: 10)),
                  //const SizedBox(width: 4),
                  Text(
                    mood.label,
                    style: GoogleFonts.poppins(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Corner brackets helper ─────────────────────────────────────────────────
  List<Widget> _cornerBrackets(Color color) {
    const size = 22.0;
    const stroke = 2.0;

    Widget bracket(bool top, bool left) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border(
          top: top ? BorderSide(color: color, width: stroke) : BorderSide.none,
          bottom: !top
              ? BorderSide(color: color, width: stroke)
              : BorderSide.none,
          left: left
              ? BorderSide(color: color, width: stroke)
              : BorderSide.none,
          right: !left
              ? BorderSide(color: color, width: stroke)
              : BorderSide.none,
        ),
      ),
    );

    return [
      Positioned(top: 10, left: 10, child: bracket(true, true)),
      Positioned(top: 10, right: 10, child: bracket(true, false)),
      Positioned(bottom: 10, left: 10, child: bracket(false, true)),
      Positioned(bottom: 10, right: 10, child: bracket(false, false)),
    ];
  }
}

// ── Custom painter for subtle grid overlay ─────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 0.5;

    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}
