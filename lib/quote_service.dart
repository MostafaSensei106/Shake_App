import 'package:flutter/services.dart';
import 'dart:math';

class QuoteService {
  static const platform = MethodChannel('com.mhsensei.shake_quote/method');
  static const eventChannel = EventChannel('com.mhsensei.shake_quote/shake');

  final List<String> _quotes = [
    'تفاءلوا بالخير تجدوه.',
    'ومن يتق الله يجعل له مخرجًا.',
    'وعسى أن تكرهوا شيئًا وهو خير لكم.',
    'الصبر مفتاح الفرج.',
    'إن مع العسر يسرًا.',
    'لا تحزن إن الله معنا.',
    'من توكل على الله فهو حسبه.',
    'ارحم تُرحم.',
    'الدنيا دار فناء، فاعمل لدار البقاء.',
    'من ترك شيئًا لله عوضه الله خيرًا منه.',
    'اذكر الله يطمئن قلبك.',
    'النية الطيبة تبارك العمل.',
    'العفو عند المقدرة من شيم الكرام.',
    'احسن كما أحسن الله إليك.',
    'من تواضع لله رفعه.',
    'القناعة كنز لا يفنى.',
    'من غرس خيرًا حصد خيرًا.',
    'ابتسم، فإن تبسّمك في وجه أخيك صدقة.',
    'اعمل لدنياك كأنك تعيش أبدًا، واعمل لآخرتك كأنك تموت غدًا.',
    'اللهم صلِّ وسلم على نبينا محمد.',
  ];

  String getRandomQuote() {
    final random = Random();
    return _quotes[random.nextInt(_quotes.length)];
  }

  Future<void> startShakeDetection() async {
    try {
      await platform.invokeMethod('startShakeDetection');
    } on PlatformException catch (e) {
      print("Failed to start shake detection: ${e.message}");
    }
  }

  Future<void> stopShakeDetection() async {
    try {
      await platform.invokeMethod('stopShakeDetection');
    } on PlatformException catch (e) {
      print("Failed to stop shake detection: ${e.message}");
    }
  }

  Stream<dynamic> get shakeEvents => eventChannel.receiveBroadcastStream();
}
