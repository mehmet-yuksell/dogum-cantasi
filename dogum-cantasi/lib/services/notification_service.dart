import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Hatırlatıcı ekranının kullandığı yerel bildirim servisi.
///
/// NOT (entegrasyon ekibi için): Bu sınıf bilerek tek bir sabit
/// bildirim kimliği (id: 1) kullanır — modülde tek bir "gebelik
/// haftası hatırlatıcısı" olduğu varsayılır. Modül başka bir
/// uygulamaya eklenirse ve başka bildirimlerle id çakışması riski
/// varsa, id'yi ana uygulamadaki bildirim id havuzuna göre ayarlayın.
class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _reminderNotificationId = 1;

  Future<void> init() async {
    tz_data.initializeTimeZones();
    // Cihazın yerel saat dilimini kullan (sunucu olmadığı için
    // konum/IP tabanlı bir saat dilimi tespiti yapılmaz).
    tz.setLocalLocation(tz.getLocation(await _localTimeZoneNameOrFallback()));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await _plugin.initialize(initSettings);
  }

  /// timezone paketi cihazın adını otomatik algılayamaz; bu basit
  /// fallback UTC kullanır. Prod entegrasyonunda flutter_timezone gibi
  /// bir paketle gerçek cihaz saat dilimi okunması önerilir — burada
  /// ekstra paket eklememek için bilinçli olarak atlanmıştır
  /// (bkz. README -> Bilinen Sınırlamalar).
  Future<String> _localTimeZoneNameOrFallback() async {
    return 'UTC';
  }

  Future<bool> requestPermission() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final iosImpl = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    final androidGranted =
        await androidImpl?.requestNotificationsPermission() ?? true;
    final iosGranted = await iosImpl?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        true;
    return androidGranted && iosGranted;
  }

  /// [triggerDate] geldiğinde "çantanı hazırla" bildirimi planlar.
  /// Aynı anda tek hatırlatıcı desteklenir; yeni bir hafta seçilirse
  /// eskisinin yerine geçer (cancel + yeniden schedule).
  Future<void> scheduleWeekReminder({
    required int week,
    required DateTime triggerDate,
  }) async {
    await _plugin.cancel(_reminderNotificationId);

    const androidDetails = AndroidNotificationDetails(
      'dogum_cantasi_reminder',
      'Doğum Çantası Hatırlatıcı',
      channelDescription: 'Seçilen gebelik haftası geldiğinde çanta hazırlama hatırlatması',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      _reminderNotificationId,
      'Doğum çantanı hazırlama zamanı!',
      '$week. haftaya girdin — çantanı gözden geçirmenin tam zamanı.',
      tz.TZDateTime.from(triggerDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelReminder() async {
    await _plugin.cancel(_reminderNotificationId);
  }
}
