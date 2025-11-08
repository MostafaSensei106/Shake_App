import 'package:flutter/material.dart';
import 'package:shake_app/quote_service.dart';
import 'package:shake_app/quote_display.dart';
import 'package:shake_app/shake_status_indicator.dart';

void main() {
  runApp(const ShakeQuoteApp());
}

class ShakeQuoteApp extends StatelessWidget {
  const ShakeQuoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shake for Quote',
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
      home: const QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({Key? key}) : super(key: key);

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen>
    with SingleTickerProviderStateMixin {
  late QuoteService _quoteService;
  String _currentQuote = 'Shake your phone to get a motivational quote!';
  bool _isListening = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _quoteService = QuoteService();
    _setupAnimation();
    _startShakeListener();
    _listenToShakeEvents();
    _currentQuote = _quoteService.getRandomQuote(); // Set initial quote
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  Future<void> _startShakeListener() async {
    await _quoteService.startShakeDetection();
    setState(() {
      _isListening = true;
    });
  }

  Future<void> _stopShakeListener() async {
    await _quoteService.stopShakeDetection();
    setState(() {
      _isListening = false;
    });
  }

  void _listenToShakeEvents() {
    _quoteService.shakeEvents.listen(
      (dynamic event) {
        if (event == 'onShakeDetected') {
          _showNewQuote();
        }
      },
      onError: (dynamic error) {
        debugPrint('Error receiving shake event: $error');
      },
    );
  }

  void _showNewQuote() {
    setState(() {
      _currentQuote = _quoteService.getRandomQuote();
    });

    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stopShakeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shake for Motivation'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.format_quote, size: 60, color: Colors.purple),
              const SizedBox(height: 40),
              QuoteDisplay(
                quote: _currentQuote,
                scaleAnimation: _scaleAnimation,
                fadeAnimation: _fadeAnimation,
              ),
              const SizedBox(height: 60),
              ShakeStatusIndicator(isListening: _isListening),
              const SizedBox(height: 20),
              const Icon(Icons.phone_android, size: 80, color: Colors.purple),
              const SizedBox(height: 16),
              const Text(
                'Shake your phone!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
