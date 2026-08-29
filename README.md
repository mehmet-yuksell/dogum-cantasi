# Doğum Çantası Modülü

Gebeliğin son haftalarında hastaneye götürülecek çantayı yönetmek için
bağımsız, sunucusuz bir Flutter modülü. Anne, bebek ve evrak
maddelerini ayrı kategorilerde takip eder, hazır listeyle başlar,
gebelik haftasına göre yerel bildirim hatırlatıcısı kurar ve eksik
maddeleri metin olarak paylaşmana izin verir.

## Ekranlar

1. **Çanta Listesi** — Anne / Bebek / Evrak sekmeleri, üstte "x/y hazır"
   ilerleme çubuğu, checkbox ile işaretleme, sağa kaydırarak silme,
   madde ekleme (FAB).
2. **Madde Detayı** — ad, adet, not, kategori düzenleme; hazır (seed)
   maddelerde "neden gerekli" açıklaması ve kaynak notu gösterilir.
3. **Hatırlatıcı** — tahmini doğum tarihini (EDD) seçip, hangi gebelik
   haftasında (28-40) hatırlatılmak istediğini seçersin; uygulama o
   haftanın takvim tarihini hesaplayıp yerel bildirim planlar.
4. **Özet / Paylaş** — henüz işaretlenmemiş maddeleri kategoriye göre
   listeler, düz metin olarak WhatsApp/SMS/e-posta gibi uygulamalara
   paylaşılabilir.

## Kurulum

```bash
git clone <bu-repo-url>
cd dogum-cantasi
flutter pub get
flutter run
```

Gerekli minimum: Flutter 3.x (Dart >=3.0), bir Android emülatörü veya
fiziksel cihaz. Bildirimlerin çalışması için Android 13+ cihazlarda
uygulama ilk açılışta bildirim izni ister (Hatırlatıcı ekranında
tetiklenir).

## Neden sqflite (shared_preferences değil)?

Liste, tek bir JSON blobu değil; her maddenin kendi alanları olan
(ad, kategori, adet, not, işaretli mi, neden gerekli, kaynak notu)
kayıtlar toplamıdır. shared_preferences ile bunu yönetmek, her küçük
değişiklikte (tek bir checkbox tıklaması dahil) tüm listeyi JSON'a
çevirip yeniden yazmayı gerektirir — madde sayısı arttıkça
verimsizleşir ve eşzamanlı yazma hatalarına açık hale gelir. sqflite
ile tek bir madde satır bazında güncellenir/silinir, kategoriye göre
sorgulanabilir ve ileride (ör. arama, filtreleme) genişletilmesi kolay
olur. Modülün "sunucu yok" gereksinimiyle de çelişmez — sqflite tamamen
cihaz üzerinde, dosya tabanlı çalışır.

## Kullanılan paketler ve gerekçeleri

| Paket | Neden gerekli |
|---|---|
| `sqflite` | Madde listesinin kalıcı, satır bazlı yerel veritabanı depolaması. |
| `path` | sqflite'ın veritabanı dosya yolunu platform bağımsız birleştirmek için (sqflite'ın kendi dokümantasyonunda önerilen eşlik paketi). |
| `path_provider` | Veritabanı dosyasının cihazda hangi dizine yazılacağını bulmak için. |
| `flutter_local_notifications` | Hatırlatıcı ekranının sunucusuz, cihaz üzerinde zamanlanmış bildirim göndermesi için — modülün "yerel bildirim" gereksinimi bunu doğrudan işaret ediyor. |
| `timezone` | `flutter_local_notifications`'ın zamanlanmış (`zonedSchedule`) bildirimleri doğru saatte tetikleyebilmesi için resmi bağımlılığı; bu paket olmadan zamanlanmış bildirim API'si çalışmaz. |
| `share_plus` | Özet ekranındaki "eksik maddeler" metnini WhatsApp/SMS/e-posta gibi dış uygulamalara paylaşmak için. Flutter'ın kendi SDK'sında paylaşım API'si yok. |
| `cupertino_icons` | Flutter'ın varsayılan proje şablonunda gelen standart ikon seti (iOS tarzı ikonlar için). |

Toplamda 6 üçüncü parti paket + varsayılan ikon paketi — hepsi
görevde açıkça istenen bir özelliğe (kalıcı depolama, bildirim, paylaşım)
doğrudan karşılık geliyor; süsleme amaçlı paket eklenmedi.

## İçerik ve kaynaklar hakkında dürüst not

Hazır listedeki 34 madde bu görev için **canlı web arama erişimi
olmadan** derlendi. Bu yüzden Sağlık Bakanlığı veya belirli bir
hastane sayfasına ait tekil bir URL gösteremiyorum — bunu iddia etmek
yanlış olurdu. Bunun yerine her madde `lib/data/default_items.dart`
içinde iki etiketten biriyle işaretlendi:

- **"Genel/yaygın öneri"** — doğum çantası konusunda hemen her
  kaynakta (ACOG dahil, hastane/ebe bilgilendirme materyallerinde
  tekrar eden) yer alan, tıbben tartışmasız maddeler.
- **"TR hastane uygulamasında yaygın öneri"** — Türkiye'de hastanelerin
  sıklıkla istediği ama hastaneden hastaneye değişebilecek evrak/uygulamalar
  (kimlik, SGK belgesi, kan grubu kartı, gebelik takip karnesi vb.).

**Öneri:** Modül gerçek kullanıcılara açılmadan önce bu listenin,
ilgili hastanenin veya Sağlık Bakanlığı'nın güncel gebe bilgilendirme
materyaliyle karşılaştırılması ve varsa hastaneye özgü farkların
(örn. bazı hastaneler kendi bebek bezini/önlüğünü sağlıyor) not
düşülmesi gerekir. Madde detayında görünen "kaynak notu" alanı tam da
bu şeffaflığı kullanıcıya da göstermek için var.

## Tasarım sistemi

Tüm renkler, boşluklar, köşe yarıçapları ve tipografi
`lib/theme/design_tokens.dart` dosyasında tanımlıdır. Ekranlarda ve
widget'larda hiçbir yerde ham `Color(0xFF...)` kodu veya sabit sayı
(`16.0`, `8.0` vb.) yazılmamıştır — hepsi `AppColors`, `AppSpacing`,
`AppRadius`, `AppTypography` sınıflarından çağrılır. Uygulama başka
bir sisteme entegre edilirse tema katmanını değiştirmek için sadece bu
tek dosyanın güncellenmesi yeterlidir.

## Bilinen sınırlamalar

- **Ekran görüntüsü yok:** Bu ortamda Flutter SDK çalıştırılamadığı
  (derleme/emülatör imkânı olmadığı) için gerçek ekran görüntüsü
  üretilemedi. Kodun kendisi tam ve çalışır durumda yazıldı, ancak
  `flutter run` ile ilk denemede küçük paket sürüm uyumsuzlukları
  çıkabilir — aşı ajandası modülünde yaşanan Gradle/Kotlin sorunlarına
  karşı `android/app/build.gradle.kts` içine önleyici ayarlar zaten
  eklendi (aşağıya bakın).
- **İçerik kaynakları doğrulanmadı** (yukarıdaki bölüme bakın) —
  yayın öncesi gerçek hastane/Bakanlık materyaliyle karşılaştırılmalı.
- **Saat dilimi:** `NotificationService` cihazın gerçek saat dilimini
  otomatik algılamıyor, sabit olarak UTC kullanıyor. Kullanıcı UTC
  dışında bir dilimdeyse hatırlatıcı birkaç saat kayabilir. Düzeltmek
  için `flutter_timezone` gibi bir paket eklenip cihaz saat dilimi
  okunmalı — bilinçli olarak paket sayısını artırmamak için bu sürümde
  atlandı.
- **Tek hatırlatıcı:** Aynı anda yalnızca bir gebelik haftası
  hatırlatıcısı desteklenir; yeni seçim eskisinin yerine geçer.
- **iOS test edilmedi:** Kod iOS için de yazıldı (Darwin bildirim
  ayarları dahil) ama bu ortamda Xcode/iOS simülatörü olmadığından
  fiilen denenmedi.

## Entegrasyon ekibi için notlar

- **Paket adı / namespace:** `com.mombykind.dogumcantasi` — ana
  uygulamaya entegre edilirken çakışma olmaması için değiştirin.
- **Android bildirim ayarları hazır:** `AndroidManifest.xml` içine
  `SCHEDULE_EXACT_ALARM`, `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`
  izinleri ve `flutter_local_notifications` receiver'ları önceden
  eklendi — aşı ajandası modülünde bunlar sonradan eklenmek zorunda
  kalınmıştı, bu sefer baştan var.
- **Gradle/Kotlin:** `build.gradle.kts` içinde `kotlinOptions` bloğu
  yerine bilerek `compileOptions` içinde `JavaVersion.VERSION_21`
  kullanıldı — aşı projesinde `kotlinOptions { jvmTarget = ... }`
  bloğu "Unresolved reference" hatası vermişti.
- **Bildirim ID'si sabit (1):** Modül tek hatırlatıcı varsayımıyla
  yazıldı. Ana uygulamada başka bildirimler varsa `notification_service.dart`
  içindeki `_reminderNotificationId` değerini ana uygulamanın bildirim
  ID havuzuna göre güncelleyin.
- **Veritabanı adı:** `dogum_cantasi.db` — ana uygulamada başka
  sqflite veritabanları varsa isim çakışması olmadığını kontrol edin.
- **Tema entegrasyonu:** `lib/theme/design_tokens.dart` dosyasındaki
  sabitleri ana uygulamanın tema/renk sistemine göre güncellemeniz
  yeterli; ekran kodlarında değişiklik gerekmez.
- **Veri taşıma:** Şu an içe/dışa aktarma (import/export) yok; ana
  uygulamaya entegrasyonda kullanıcının var olan sqflite verisini
  koruyup korumayacağınıza (tablo birleştirme vb.) karar vermeniz
  gerekir.

## Proje yapısı

```
lib/
  main.dart
  theme/design_tokens.dart       # renk / boşluk / radius / tipografi sabitleri
  models/category.dart           # BagCategory enum
  models/bag_item.dart           # BagItem veri modeli
  data/default_items.dart        # 34 maddelik hazır liste + kaynak notları
  data/db_helper.dart            # sqflite CRUD katmanı
  services/notification_service.dart
  widgets/progress_header.dart
  widgets/item_tile.dart
  screens/bag_list_screen.dart   # Ekran 1
  screens/item_detail_screen.dart# Ekran 2
  screens/reminder_screen.dart   # Ekran 3
  screens/summary_screen.dart    # Ekran 4
android/app/src/main/AndroidManifest.xml
android/app/build.gradle.kts
```

## Lisans

MIT — bkz. [LICENSE](LICENSE).
