// Student: Ki Hyun Park

import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const SmileyApp());
}

enum FaceType {
  classic,
  sleepy,
  surprised,
}

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Face Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff5c6bc0),
        ),
        useMaterial3: true,
      ),
      home: const DrawingPlayground(),
    );
  }
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  final math.Random random = math.Random();

  double mood = 0.65;
  FaceType faceType = FaceType.classic;
  Color faceColor = const Color(0xffffd54f);

  String get moodText {
    if (mood < 0.35) {
      return 'Not feeling it';
    }

    if (mood <= 0.7) {
      return 'Pretty good';
    }

    return 'Great mood';
  }

  String get faceName {
    switch (faceType) {
      case FaceType.classic:
        return 'Classic';
      case FaceType.sleepy:
        return 'Sleepy';
      case FaceType.surprised:
        return 'Surprised';
    }
  }

  Color colorForMood(double value) {
    if (value < 0.35) {
      return const Color(0xff90caf9);
    }

    if (value <= 0.7) {
      return const Color(0xffffd54f);
    }

    return const Color(0xffffab40);
  }

  Color randomColorForMood(double value) {
    if (value < 0.35) {
      final colors = [
        const Color(0xff90caf9),
        const Color(0xff80cbc4),
        const Color(0xffb39ddb),
      ];

      return colors[random.nextInt(colors.length)];
    }

    if (value <= 0.7) {
      final colors = [
        const Color(0xffffd54f),
        const Color(0xffffe082),
        const Color(0xffdce775),
      ];

      return colors[random.nextInt(colors.length)];
    }

    final colors = [
      const Color(0xffffab40),
      const Color(0xffff8a65),
      const Color(0xffffca28),
    ];

    return colors[random.nextInt(colors.length)];
  }

  void changeMood(double value) {
    setState(() {
      mood = value;
      faceColor = colorForMood(value);
    });
  }

  void selectFace(FaceType type) {
    setState(() {
      faceType = type;
    });

    showMessage('$faceName face selected');
  }

  void cycleFace() {
    setState(() {
      final next = (faceType.index + 1) % FaceType.values.length;
      faceType = FaceType.values[next];
    });

    showMessage('Changed to $faceName');
  }

  void randomizeFace() {
    setState(() {
      mood = random.nextDouble();
      faceColor = randomColorForMood(mood);
    });

    showMessage('Mood and color randomized');
  }

  void showMessage(String text) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final drawingSize = (width * 0.7).clamp(220.0, 310.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Face Lab'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 520,
              ),
              child: Column(
                children: [
                  Text(
                    faceName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap the face to switch • Hold to randomize',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: cycleFace,
                    onLongPress: randomizeFace,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xfff7f7fb),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 18,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: CustomPaint(
                        size: Size(drawingSize, drawingSize),
                        painter: SmileyPainter(
                          mood: mood,
                          faceColor: faceColor,
                          faceType: faceType,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      const Text(
                        'Mood',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${mood.toStringAsFixed(2)}  $moodText',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: mood,
                    min: 0,
                    max: 1,
                    divisions: 100,
                    onChanged: changeMood,
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Face style',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Classic'),
                        selected: faceType == FaceType.classic,
                        onSelected: (_) {
                          selectFace(FaceType.classic);
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Sleepy'),
                        selected: faceType == FaceType.sleepy,
                        onSelected: (_) {
                          selectFace(FaceType.sleepy);
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Surprised'),
                        selected: faceType == FaceType.surprised,
                        onSelected: (_) {
                          selectFace(FaceType.surprised);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'Quick Controls',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Tap = next face\nLong press = random mood and color',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  const SmileyPainter({
    required this.mood,
    required this.faceColor,
    required this.faceType,
  });

  final double mood;
  final Color faceColor;
  final FaceType faceType;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.shortestSide * 0.4;

    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xff252536)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.045;

    canvas.drawCircle(
      center,
      radius,
      facePaint,
    );

    canvas.drawCircle(
      center,
      radius,
      borderPaint,
    );

    switch (faceType) {
      case FaceType.classic:
        drawClassic(
          canvas,
          center,
          radius,
        );
        break;

      case FaceType.sleepy:
        drawSleepy(
          canvas,
          center,
          radius,
        );
        break;

      case FaceType.surprised:
        drawSurprised(
          canvas,
          center,
          radius,
        );
        break;
    }

    if (mood > 0.42) {
      drawBlush(
        canvas,
        center,
        radius,
      );
    }
  }

  void drawClassic(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final eyePaint = Paint()
      ..color = const Color(0xff252536)
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final eyeRadius = radius * 0.09;
    final eyeX = radius * 0.34;
    final eyeY = center.dy - radius * 0.2;

    final leftEye = Offset(
      center.dx - eyeX,
      eyeY,
    );

    final rightEye = Offset(
      center.dx + eyeX,
      eyeY,
    );

    canvas.drawCircle(
      leftEye,
      eyeRadius,
      eyePaint,
    );

    canvas.drawCircle(
      rightEye,
      eyeRadius,
      eyePaint,
    );

    canvas.drawCircle(
      leftEye.translate(
        -eyeRadius * 0.25,
        -eyeRadius * 0.25,
      ),
      eyeRadius * 0.25,
      highlightPaint,
    );

    canvas.drawCircle(
      rightEye.translate(
        -eyeRadius * 0.25,
        -eyeRadius * 0.25,
      ),
      eyeRadius * 0.25,
      highlightPaint,
    );

    drawMoodMouth(
      canvas,
      center,
      radius,
    );
  }

  void drawSleepy(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final eyePaint = Paint()
      ..color = const Color(0xff252536)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.05
      ..strokeCap = StrokeCap.round;

    final eyeX = radius * 0.34;
    final eyeY = center.dy - radius * 0.18;
    final eyeWidth = radius * 0.27;

    canvas.drawLine(
      Offset(
        center.dx - eyeX - eyeWidth / 2,
        eyeY,
      ),
      Offset(
        center.dx - eyeX + eyeWidth / 2,
        eyeY + radius * 0.025,
      ),
      eyePaint,
    );

    canvas.drawLine(
      Offset(
        center.dx + eyeX - eyeWidth / 2,
        eyeY + radius * 0.025,
      ),
      Offset(
        center.dx + eyeX + eyeWidth / 2,
        eyeY,
      ),
      eyePaint,
    );

    final mouthPaint = Paint()
      ..color = const Color(0xff252536)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.045
      ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy + radius * 0.26,
      ),
      width: radius * 0.85,
      height: radius * (0.25 + mood * 0.2),
    );

    if (mood < 0.35) {
      canvas.drawArc(
        mouthRect,
        1.15 * math.pi,
        0.7 * math.pi,
        false,
        mouthPaint,
      );
    } else {
      canvas.drawArc(
        mouthRect,
        0.15 * math.pi,
        0.7 * math.pi,
        false,
        mouthPaint,
      );
    }
  }

  void drawSurprised(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final eyePaint = Paint()
      ..color = const Color(0xff252536)
      ..style = PaintingStyle.fill;

    final eyeX = radius * 0.34;
    final eyeY = center.dy - radius * 0.2;
    final eyeRadius = radius * (0.11 + mood * 0.025);

    canvas.drawCircle(
      Offset(
        center.dx - eyeX,
        eyeY,
      ),
      eyeRadius,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(
        center.dx + eyeX,
        eyeY,
      ),
      eyeRadius,
      eyePaint,
    );

    final mouthPaint = Paint()
      ..color = const Color(0xff252536)
      ..style = PaintingStyle.fill;

    final mouthRect = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy + radius * 0.3,
      ),
      width: radius * (0.28 + mood * 0.12),
      height: radius * (0.4 + mood * 0.25),
    );

    canvas.drawOval(
      mouthRect,
      mouthPaint,
    );

    final insidePaint = Paint()
      ..color = const Color(0xffef5350)
      ..style = PaintingStyle.fill;

    final inside = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy + radius * 0.42,
      ),
      width: mouthRect.width * 0.58,
      height: mouthRect.height * 0.25,
    );

    canvas.drawOval(
      inside,
      insidePaint,
    );
  }

  void drawMoodMouth(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final mouthPaint = Paint()
      ..color = const Color(0xff252536)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.05
      ..strokeCap = StrokeCap.round;

    if (mood < 0.35) {
      final mouthRect = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.36,
        ),
        width: radius * 0.95,
        height: radius * 0.45,
      );

      canvas.drawArc(
        mouthRect,
        1.15 * math.pi,
        0.7 * math.pi,
        false,
        mouthPaint,
      );

      return;
    }

    if (mood <= 0.7) {
      final mouthRect = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.14,
        ),
        width: radius * 0.9,
        height: radius * 0.32,
      );

      canvas.drawArc(
        mouthRect,
        0.15 * math.pi,
        0.7 * math.pi,
        false,
        mouthPaint,
      );

      return;
    }

    final mouthRect = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy + radius * 0.12,
      ),
      width: radius * 1.1,
      height: radius * (0.42 + mood * 0.18),
    );

    canvas.drawArc(
      mouthRect,
      0.12 * math.pi,
      0.76 * math.pi,
      false,
      mouthPaint,
    );
  }

  void drawBlush(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final blushPaint = Paint()
      ..color = const Color(0xffff6f61).withValues(alpha: 0.38)
      ..style = PaintingStyle.fill;

    final blushWidth = radius * 0.28;
    final blushHeight = radius * 0.12;

    final leftBlush = Rect.fromCenter(
      center: Offset(
        center.dx - radius * 0.52,
        center.dy + radius * 0.11,
      ),
      width: blushWidth,
      height: blushHeight,
    );

    final rightBlush = Rect.fromCenter(
      center: Offset(
        center.dx + radius * 0.52,
        center.dy + radius * 0.11,
      ),
      width: blushWidth,
      height: blushHeight,
    );

    canvas.drawOval(
      leftBlush,
      blushPaint,
    );

    canvas.drawOval(
      rightBlush,
      blushPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.faceColor != faceColor ||
        oldDelegate.faceType != faceType;
  }
}