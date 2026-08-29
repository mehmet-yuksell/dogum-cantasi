import '../models/bag_item.dart';
import '../models/category.dart';

// HAZIR LİSTE — 34 madde (Anne: 12, Bebek: 12, Evrak: 10).
//
// DÜRÜST NOT: Bu liste, bu görev için canlı internet/arama erişimi
// OLMADAN hazırlanmıştır. Yani "Sağlık Bakanlığı sayfası X der ki..."
// gibi tekil, doğrulanmış bir web kaynağı gösteremiyorum. Bunun yerine
// her maddeyi iki seviyeden biriyle etiketledim:
//
//  - "Genel/yaygın öneri": Doğum öncesi hastane çantası listelerinde
//    (ACOG dahil çoğu hastane/ebe kaynağında) neredeyse evrensel olarak
//    tekrar eden, tıbben tartışmasız maddeler (gecelik, bebek bezi vb.)
//  - "TR hastane uygulaması - yaygın öneri": Türkiye'deki hastanelerde
//    sık istenen ama hastaneden hastaneye değişebilecek evrak/uygulama.
//
// Entegrasyon/gerçek kullanım öncesi bu listenin ilgili hastane veya
// Sağlık Bakanlığı'nın güncel gebe bilgilendirme materyaliyle
// karşılaştırılması önerilir (README -> Bilinen Sınırlamalar).

const String _genel = 'Genel/yaygın öneri (çoğu hastane ve ebe kaynağında yer alır)';
const String _tr = "TR hastane uygulamasında yaygın öneri — hastaneye göre değişebilir";

List<BagItem> seedDefaultItems() {
  return [
    // ---------------- ANNE (12) ----------------
    BagItem(
      name: 'Önden düğmeli gecelik / hastane önlüğü',
      category: BagCategory.anne,
      quantity: 3,
      whyNeeded: 'Emzirmeye uygun önden açılan gecelikler doğum sonrası ve emzirme için pratiklik sağlar.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Sabahlık / robdöşambr',
      category: BagCategory.anne,
      quantity: 1,
      whyNeeded: 'Koridorda/ziyaretçi karşısında rahat hareket edebilmek için.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Kaymaz tabanlı terlik',
      category: BagCategory.anne,
      quantity: 1,
      whyNeeded: 'Hastane zeminlerinde güvenli yürüyüş için kaymaz taban önemlidir.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Emzirme sütyeni',
      category: BagCategory.anne,
      quantity: 3,
      whyNeeded: 'Emzirmeyi kolaylaştıran ön açmalı model doğum sonrası ilk günlerde önerilir.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Göğüs pedi',
      category: BagCategory.anne,
      quantity: 1,
      note: '1 kutu',
      whyNeeded: 'Süt gelişiyle oluşan sızıntıyı önlemek için.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Bol/rahat iç çamaşırı',
      category: BagCategory.anne,
      quantity: 6,
      whyNeeded: 'Lohusalık pedi ile birlikte rahat kullanım için bol kesim önerilir.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Lohusa (doğum sonrası) ped',
      category: BagCategory.anne,
      quantity: 1,
      note: '1 paket, büyük boy',
      whyNeeded: 'Doğum sonrası kanama için normal adet pedinden daha emici, özel pedler gerekir.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Kişisel bakım seti (diş fırçası, macun, şampuan, sabun)',
      category: BagCategory.anne,
      quantity: 1,
      whyNeeded: 'Hastanede kalış süresi boyunca temel hijyen ihtiyaçları.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Telefon şarj aleti (uzun kablo) / powerbank',
      category: BagCategory.anne,
      quantity: 1,
      whyNeeded: 'Prizin yataktan uzak olabileceği düşünülerek uzun kablo önerilir.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Eve dönüş kıyafeti (rahat, bol kesim)',
      category: BagCategory.anne,
      quantity: 1,
      whyNeeded: 'Doğum sonrası vücut ölçüsü değiştiğinden hamilelik öncesi dar kıyafetler yerine bol kesim önerilir.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Su şişesi ve enerji verici atıştırmalık',
      category: BagCategory.anne,
      quantity: 1,
      whyNeeded: 'Doğum eylemi uzun sürebilir; susuz/açık kalmamak için.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Kalın çorap',
      category: BagCategory.anne,
      quantity: 2,
      whyNeeded: 'Doğumhane ve hastane odaları serin olabilir.',
      sourceNote: _genel,
      isPreset: true,
    ),

    // ---------------- BEBEK (12) ----------------
    BagItem(
      name: 'Zıbın / body (0-3 ay)',
      category: BagCategory.bebek,
      quantity: 5,
      whyNeeded: 'Yenidoğanın sık kirlenen/değişen iç giysisi.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Tulum / çıtçıtlı takım',
      category: BagCategory.bebek,
      quantity: 4,
      whyNeeded: 'Bez değişimini kolaylaştıran çıtçıtlı model önerilir.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Bebek battaniyesi / kundak',
      category: BagCategory.bebek,
      quantity: 2,
      whyNeeded: 'Yenidoğanı sıcak tutmak ve sarmalamak için.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Yenidoğan bezi',
      category: BagCategory.bebek,
      quantity: 1,
      note: '1 paket (hastane genelde kendi bezini de sağlar, teyit edin)',
      whyNeeded: 'Bazı hastaneler kendi bezini kullanır; yine de yedek bulundurmak önerilir.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Islak mendil (parfümsüz, yenidoğana uygun)',
      category: BagCategory.bebek,
      quantity: 1,
      whyNeeded: 'Bez değişiminde ve genel temizlikte kullanılır.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Bebek şapkası',
      category: BagCategory.bebek,
      quantity: 2,
      whyNeeded: 'Yenidoğanın ısı kaybını azaltmaya yardımcı olur.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Patik / çorap',
      category: BagCategory.bebek,
      quantity: 3,
      whyNeeded: 'Ayakların soğuk kalmaması için.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Eldiven (tırmalamayı önleyici)',
      category: BagCategory.bebek,
      quantity: 2,
      whyNeeded: 'Yenidoğan kendi yüzünü tırmalamasın diye kullanılır.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Eve dönüş kıyafeti / özel takım',
      category: BagCategory.bebek,
      quantity: 1,
      whyNeeded: 'Taburcu günü ve ilk fotoğraflar için ayrılan özel kıyafet.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Bebek oto koltuğu',
      category: BagCategory.bebek,
      quantity: 1,
      whyNeeded: 'Türkiye trafik mevzuatına göre bebeğin araçla güvenli taşınması için oto koltuğu zorunludur.',
      sourceNote: _tr,
      isPreset: true,
    ),
    BagItem(
      name: 'Emzik (doğum sonrası kullanılacaksa)',
      category: BagCategory.bebek,
      quantity: 1,
      whyNeeded: 'Bazı aileler doğumdan itibaren kullanmayı tercih eder; zorunlu değildir.',
      sourceNote: _genel,
      isPreset: true,
    ),
    BagItem(
      name: 'Mama bezi / omuz bezi',
      category: BagCategory.bebek,
      quantity: 3,
      whyNeeded: 'Kusma/geğirme sırasında kıyafetleri korumak için.',
      sourceNote: _genel,
      isPreset: true,
    ),

    // ---------------- EVRAK (10) ----------------
    BagItem(
      name: 'Kimlik belgesi (T.C. kimlik kartı / nüfus cüzdanı)',
      category: BagCategory.evrak,
      quantity: 1,
      whyNeeded: 'Hastaneye kayıt ve bebeğin nüfus/doğum bildirimi işlemleri için zorunludur.',
      sourceNote: _tr,
      isPreset: true,
    ),
    BagItem(
      name: 'Sağlık sigortası / SGK belgesi',
      category: BagCategory.evrak,
      quantity: 1,
      whyNeeded: 'Hastane giriş işlemlerinde ve fatura/provizyon sürecinde istenir.',
      sourceNote: _tr,
      isPreset: true,
    ),
    BagItem(
      name: 'Doğum öncesi tetkik sonuçları (kan tahlilleri, ultrason raporları)',
      category: BagCategory.evrak,
      quantity: 1,
      whyNeeded: 'Doğum ekibinin gebelik geçmişini ve riskleri hızlı değerlendirebilmesi için.',
      sourceNote: _tr,
      isPreset: true,
    ),
    BagItem(
      name: 'Kan grubu kartı / belgesi',
      category: BagCategory.evrak,
      quantity: 1,
      whyNeeded: 'Olası kan/kan ürünü ihtiyacında hızlı işlem için önceden bilinmesi istenir.',
      sourceNote: _tr,
      isPreset: true,
    ),
    BagItem(
      name: 'Gebelik takip karnesi (Anne-Çocuk Sağlığı Karnesi)',
      category: BagCategory.evrak,
      quantity: 1,
      whyNeeded: 'Gebelik boyunca tutulan takip kaydı, doğum ekibi için önemli geçmiş bilgi içerir.',
      sourceNote: _tr,
      isPreset: true,
    ),
    BagItem(
      name: 'Anne-baba kimlik fotokopileri',
      category: BagCategory.evrak,
      quantity: 2,
      whyNeeded: 'Bebeğin nüfus/doğum kaydı işlemlerinde hastane idaresi tarafından istenebilir.',
      sourceNote: _tr,
      isPreset: true,
    ),
    BagItem(
      name: 'Evlilik cüzdanı fotokopisi (varsa)',
      category: BagCategory.evrak,
      quantity: 1,
      whyNeeded: 'Bazı hastaneler bebeğin nüfus kaydı için evlilik cüzdanı örneği isteyebilir.',
      sourceNote: _tr,
      isPreset: true,
    ),
    BagItem(
      name: 'Özel hastane anlaşma/ön kabul belgesi (varsa)',
      category: BagCategory.evrak,
      quantity: 1,
      whyNeeded: 'Özel hastanelerde giriş öncesi ödeme/anlaşma sürecinin tamamlanmış olması istenir.',
      sourceNote: _tr,
      isPreset: true,
    ),
    BagItem(
      name: 'Doğum izni / işyeri bildirim belgesi (opsiyonel)',
      category: BagCategory.evrak,
      quantity: 1,
      whyNeeded: 'Çalışan anneler için işyerine sunulacak doğum raporu sürecini hızlandırır.',
      sourceNote: _tr,
      isPreset: true,
    ),
    BagItem(
      name: 'Nakit veya kredi kartı',
      category: BagCategory.evrak,
      quantity: 1,
      whyNeeded: 'Depozito, ek ücret veya beklenmeyen masraflar için hazır bulundurulması önerilir.',
      sourceNote: _genel,
      isPreset: true,
    ),
  ];
}
