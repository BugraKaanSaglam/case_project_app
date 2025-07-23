import 'package:logger/logger.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;

  late final Logger _logger;

  LoggerService._internal() {
    _logger = Logger(printer: PrettyPrinter(methodCount: 2, errorMethodCount: 5, lineLength: 80, colors: true, printEmojis: true, printTime: true));
  }

  // Kısa yol metodları
  void v(String msg) => _logger.v(msg);
  void d(String msg) => _logger.d(msg);
  void i(String msg) => _logger.i(msg);
  void w(String msg) => _logger.w(msg);
  void e(String msg, [Exception? ex, StackTrace? st]) => _logger.e(msg, ex, st);
}
