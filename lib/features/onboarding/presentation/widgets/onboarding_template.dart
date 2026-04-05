import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';

class OnboardingTemplate extends StatefulWidget {
  final String imagePath;
  final String title;
  final String highlightText;
  final String description;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final int indicatorIndex;
  final int totalIndicators;

  const OnboardingTemplate({
    super.key,
    required this.imagePath,
    required this.title,
    required this.highlightText,
    required this.description,
    required this.onNext,
    required this.onSkip,
    this.indicatorIndex = 0,
    this.totalIndicators = 2,
  });

  @override
  State<OnboardingTemplate> createState() => _OnboardingTemplateState();
}

class _OnboardingTemplateState extends State<OnboardingTemplate>
    with TickerProviderStateMixin {
  late final AnimationController _pageController;
  late final AnimationController _buttonController;

  late final Animation<double> _imageFade;
  late final Animation<Offset> _imageSlide;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();

    _pageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    // Image: fade + slide up from bottom
    _imageFade = CurvedAnimation(
      parent: _pageController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _imageSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));

    // Text: fade + slide up, slightly delayed
    _textFade = CurvedAnimation(
      parent: _pageController,
      curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageController,
      curve: const Interval(0.3, 0.9, curve: Curves.easeOutCubic),
    ));

    // Button press scale
    _buttonScale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _pageController.forward();
  }

  @override
  void didUpdateWidget(OnboardingTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.indicatorIndex != widget.indicatorIndex) {
      _pageController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _handleNextTap() async {
    await _buttonController.forward();
    await _buttonController.reverse();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Skip button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onSkip,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: AppColors.text1, fontSize: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              FadeTransition(
                opacity: _imageFade,
                child: SlideTransition(
                  position: _imageSlide,
                  child: Center(
                    child: Image.asset(
                      widget.imagePath,
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: _textSlide,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text1,
                          ),
                          children: [
                            TextSpan(text: '${widget.title} '),
                            TextSpan(
                              text: widget.highlightText,
                              style: const TextStyle(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.text1,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              Row(
                children: List.generate(widget.totalIndicators, (index) {
                  final isActive = index == widget.indicatorIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                    margin: const EdgeInsets.only(right: 6),
                    width: isActive ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _handleNextTap,
                  child: ScaleTransition(
                    scale: _buttonScale,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.linearGradient,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}