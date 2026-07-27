import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../l10n/s.dart';

class NorwegenFjordePage extends StatefulWidget {
  final bool isDarkMode;

  const NorwegenFjordePage({super.key, required this.isDarkMode});

  @override
  State<NorwegenFjordePage> createState() => _NorwegenFjordePageState();
}

class _NorwegenFjordePageState extends State<NorwegenFjordePage> {
  Widget buildFirebaseImage(String storagePath) {
    final fileName = storagePath.split('/').last;
    final bool portrait = imageOrientation[fileName] ?? true;

    return FutureBuilder<String>(
      future: FirebaseStorage.instance.ref(storagePath).getDownloadURL(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
        }

        return Image.network(
          snapshot.data!,
          fit: portrait ? BoxFit.fitHeight : BoxFit.fitWidth,
          width: double.infinity,
        );
      },
    );
  }

  final List<int> imagesPerDay = [4, 0, 4, 2, 3, 1, 4, 4, 1, 1, 2, 0];
  List<int> currentImageIndex = List.filled(12, 0);

  final List<List<String>> imagePaths = [
    // Tag 1: Hamburg
    [
      'bilder/AIDAprima Norwegen mit Geiranger/Hamburg5.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Hamburg2.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Hamburg3.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Hamburg4.jpeg',
    ],

    // Tag 2: Seetag
    [],

    // Tag 3: Bergen
    [
      'bilder/AIDAprima Norwegen mit Geiranger/Bergen1.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Bergen2.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Bergen3.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Bergen4.jpg',
    ],

    // Tag 4: Ålesund
    [
      'bilder/AIDAprima Norwegen mit Geiranger/Alesund1.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Alesund2.jpg',
    ],

    // Tag 5: Geirangerfjord
    [
      'bilder/AIDAprima Norwegen mit Geiranger/Geiranger1.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Geiranger2.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Geiranger3.jpg',
    ],

    // Tag 6: Trondheim
    ['bilder/AIDAprima Norwegen mit Geiranger/Trondheim.jpg'],

    // Tag 7: Molde
    [
      'bilder/AIDAprima Norwegen mit Geiranger/Molde2.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Molde3.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Molde4.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Molde5.jpg',
    ],

    // Tag 8: Moloy
    [
      'bilder/AIDAprima Norwegen mit Geiranger/Maloy2.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Maloy3.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Maloy4.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/Maloy5.jpg',
    ],

    // Tag 9: Flom
    ['bilder/AIDAprima Norwegen mit Geiranger/Flam.jpg'],

    // Tag 10: Stavanger
    ['bilder/AIDAprima Norwegen mit Geiranger/Stavanger.jpg'],

    // Tag 11: Seetag Rückfahrt
    [
      'bilder/AIDAprima Norwegen mit Geiranger/2Seetag1.jpg',
      'bilder/AIDAprima Norwegen mit Geiranger/2Seetag2.jpg',
    ],

    // Tag 12: Abreise
    [],
  ];

  final Map<String, bool> imageOrientation = {
    'Hamburg5.jpg': true,
    'Hamburg2.jpg': true,
    'Hamburg3.jpg': true,
    'Hamburg4.jpg': true,

    'Bergen1.jpg': true,
    'Bergen2.jpg': true,
    'Bergen3.jpg': true,
    'Bergen4.jpg': true,

    'Alesund1.jpg': true,
    'Alesund2.jpg': true,

    'Geiranger1.jpg': true,
    'Geiranger2.jpg': true,
    'Geiranger3.jpg': true,

    'Trondheim.jpg': true,

    'Molde1.jpg': true,
    'Molde2.jpg': true,
    'Molde3.jpg': true,
    'Molde4.jpg': true,
    'Molde5.jpg': true,

    'Maloy1.jpg': true,
    'Maloy2.jpg': true,
    'Maloy3.jpg': true,
    'Maloy4.jpg': true,
    'Maloy5.jpg': true,

    'Flam.jpg': true,
    'Stavanger.jpg': true,
    '2Seetag1.jpg': true,
    '2Seetag2.jpg': true,
  };

  // Beschreibungen pro Tag (7 Tage)
  final List<String> descriptions = [
    "Unsere zweite Norwegen-Kreuzfahrt stand endlich bevor, gebucht hatten wir sie wieder einmal entspannt etwa zwei Wochen vorher. Mit meiner Mama und meiner Uroma machten wir uns auf den Weg nach Hamburg, einer Stadt, die wir schon oft besucht haben und die zu unseren Lieblingsstädten gehört ❤️.\n\nAm ersten Tag in Hamburg kamen wir mittags an und ließen uns direkt im Brauhaus Blockbräu nieder, das bei jedem unserer Hamburg-Besuche auf dem Programm steht 🍺. Das Essen war wie immer hervorragend – deftige Speisen, frisch zubereitet und mit viel Liebe angerichtet. Wir genossen das gemeinsame Essen und das Beisammensein in entspannter Atmosphäre, ein perfekter Start in unseren Hamburg-Aufenthalt. Danach machten wir einen Spaziergang durch den alten Elbtunnel, der immer wieder beeindruckt. Auf der anderen Seite angekommen, hatten wir einen tollen Blick auf die Elbphilharmonie, den Hafen und die vorbeiziehenden Schiffe. Die Perspektive war einfach einmalig und wir haben uns Zeit genommen, um die Aussicht richtig auf uns wirken zu lassen, bevor wir wieder zurück durch den Tunnel gingen. Danach ging es zurück ins Hotel, wo wir den Tag ruhig ausklingen ließen.\n\nAm zweiten Tag stand die Hop-on-Hop-off-Bustour auf dem Programm. Wir starteten an den Landungsbrücken und hatten von dort aus einen tollen Überblick über Hamburgs Hafen und die vorbeiziehenden Schiffe 🌊. Die Tour führte vorbei am Überseequartier, dem modernen Stadtviertel mit seinen eleganten Büro- und Wohngebäuden, und wir genossen den Mix aus Tradition und zeitgenössischer Architektur. Weiter ging es am Hauptbahnhof, wo wir kurz ausgestiegen sind, um das geschäftige Treiben der Stadt zu beobachten. Die Bustour führte dann an der Alster vorbei – der Blick auf das Wasser und die umgebenden Parkanlagen war richtig schön und hat uns sofort das typische Hamburger Flair gezeigt 🌿.\n\nWir fuhren auch an den eleganten Villenvierteln, wie dem Uhlenhorst (das ist das Viertel, das viele wunderschöne Altbauten und Villen hat), vorbei und bestaunten die prachtvollen Fassaden und Gärten. Ein Highlight war auch die HafenCity, das moderne, aufstrebende Viertel mit seinen futuristischen Bauten direkt am Wasser. Am Rathaus und an der St. Michaeliskirche fuhren wir vorbei – zwei Orte, die Hamburg so einzigartig machen und die wir immer wieder gern sehen. Ein lustiger Insider auf der Tour: Bei einer Einbahnstraße erfuhren wir, dass sich die Richtung dieser Straße einmal täglich ändert – ein kleines Detail, das uns richtig zum Schmunzeln brachte 😄. Vorbei ging es auch an den Messehallen, und zwischendurch stiegen wir an verschiedenen Punkten aus, um die Stadt auf eigene Faust zu erkunden. Danach fuhren wir entspannt mit dem Bus zurück zu den Landungsbrücken, aßen etwas Kleines unterwegs und besuchten noch die Reeperbahn im Penny Kiez, bevor wir zurück ins Hotel gingen.\n\nAm dritten Tag genossen wir das Stadtleben aus einer etwas anderen Perspektive. Wir spazierten durch die HafenCity und die Speicherstadt, ließen uns vom Wasser, den alten Lagerhäusern und den modernen Gebäuden beeindrucken und nahmen uns Zeit, die Architektur auf uns wirken zu lassen. Unser Ziel war das Westfield Einkaufszentrum, wo wir ausgiebig shoppen gingen 🛍️. Ich selbst habe mir im Cinnaversum ein Franzbrötchen mit Smarties gegönnt – ein echter Genuss 😋! Danach ging es zurück ins Hotel für einen kurzen Mittagsschlaf, bevor wir abends zum Musical „& Julia“ gingen. Die Show fand im Operettenhaus direkt neben unserem Hotel statt – super praktisch, da wir keine langen Wege hatten. Das Musical war unterhaltsam, hochwertig inszeniert und hat uns allen drei richtig gut gefallen 🎭.\n\nAm vierten Morgen war es dann endlich so weit: Es ging für uns an Bord der AIDA Prima 🛳️. Wir hatten wieder den AIDA Frühcheck-in gebucht und konnten bereits um 10:30 Uhr einchecken – etwas, das wir wirklich sehr schätzen, weil der Start in die Kreuzfahrt dadurch einfach so viel entspannter ist. Alles lief reibungslos, ohne Hektik oder lange Wartezeiten.\n\nBesonders schön war, dass uns direkt gesagt wurde, dass unsere Kabine schon fertig ist. Also ging es ohne Umwege direkt zu unserer Verandakabine 9286 auf der Backbordseite, relativ weit hinten im Schiff. Das war tatsächlich das erste Mal, dass wir so weit achtern gewohnt haben. Es war absolut okay und wir haben uns wohlgefühlt, aber wir haben auch gemerkt: Am liebsten wohnen wir einfach in der Mitte des Schiffes – das liegt uns persönlich doch am meisten.\n\nDie Kabine selbst war richtig praktisch geschnitten: ein Doppelbett, eine Schlafcouch, ein schöner Balkon und vor allem zwei Badezimmer, was mit drei Generationen einfach unglaublich angenehm war. In einem Bad befanden sich Toilette und Waschbecken, im anderen Dusche und Waschbecken – das hat den Alltag an Bord deutlich entspannter gemacht.\n\nNachdem wir uns kurz eingerichtet hatten, gingen wir gegen 12 Uhr Mittag essen, und kaum waren wir zurück auf der Kabine, standen auch schon unsere Koffer vor der Tür. Wir packten alles in Ruhe aus, machten es uns gemütlich und kamen richtig an Bord an. Die AIDA Prima kannten wir ja bereits von früheren Reisen, trotzdem fühlte es sich jedes Mal wieder vertraut an, über die Decks zu laufen und dieses besondere Kreuzfahrtgefühl zu spüren.\n\nAm frühen Abend, gegen 18 Uhr, legten wir schließlich in Hamburg ab. Das Ablegen dort ist jedes Mal etwas ganz Besonderes: die Elbe, die Hafenkräne, die langsam vorbeiziehende Stadt und dieses Gefühl, dass der Urlaub jetzt wirklich beginnt. Zum Abendessen gingen wir ins Buffalo Steakhouse, wo es wie immer unglaublich lecker war 🍽️. Danach schlenderten wir noch ein wenig durch die Shops und ich konnte einfach nicht widerstehen – ich habe mir ein paar AIDA-Anhänger für mein Pandora-Armband gekauft, eine schöne Erinnerung an diese Reise.\n\nDen Abend ließen wir ganz ruhig auf unserem Balkon ausklingen. Wir hatten sogar eine kleine Lichterkette dabei, die wir aufgehängt hatten, saßen draußen, hörten das Meeresrauschen und schauten in die Dunkelheit hinaus. Genau diese Momente sind es, die Kreuzfahrten für uns so besonders machen ✨🌊.",
    "Unser erster Seetag fühlte sich genau so an, wie Urlaub sich anfühlen sollte: ruhig, entschleunigt und vollkommen stressfrei. Kein Zeitdruck, kein Programm – einfach ankommen und genießen.\n\nWir starteten den Tag ganz gemütlich mit einem Frühstück im Buffalo Steakhouse. Das Frühstück dort ist zwar kostenpflichtig, aber genau das macht es für uns immer wieder besonders: eine ruhige Atmosphäre, ein kleines, feines Frühstücksbuffet und einfach deutlich entspannter als die großen Buffetrestaurants. Für diesen Seetag war das der perfekte Start ☕🥐.\n\nDanach nutzten wir die Zeit, um meiner Uroma die AIDA Prima zu zeigen, denn sie kannte bis dahin nur die AIDA Nova, mit der wir schon gemeinsam unterwegs gewesen waren. Also schlenderten wir ganz in Ruhe über die verschiedenen Decks, schauten uns Restaurants, Lounges und Außenbereiche an und blieben immer wieder stehen, um den Blick aufs offene Meer zu genießen. Es war schön zu sehen, wie sie das Schiff Stück für Stück entdeckte und wie sehr ihr die Prima gefiel.\n\nNatürlich durfte auch ein kleiner kulinarischer Klassiker nicht fehlen: Currywurst von der Scharfen Ecke 🌭🔥. Die Currywurst auf der AIDA ist einfach jedes Mal ein Highlight – richtig lecker, genau das Richtige für zwischendurch und für uns irgendwie fest mit einem Seetag verbunden.\n\nZwischendurch ließen wir uns einfach treiben: ein bisschen Zeit auf dem Balkon, das Meeresrauschen im Hintergrund, kleine Spaziergänge über das Schiff und immer wieder kurze Pausen zum Hinsetzen und Durchatmen 🌊. Genau diese Art von Seetag lieben wir – weil man nichts „schaffen“ muss, sondern einfach da ist.\n\nDieser Tag war der perfekte Einstieg in die Reise. Bevor es in den nächsten Tagen mit Sightseeing und neuen Häfen losging, konnten wir hier ganz in Ruhe an Bord ankommen – im Urlaub, auf dem Schiff und im Kopf ❤️.",
    "Nach dem entspannten Seetag am Vortag wachten wir voller Vorfreude auf, denn uns erwartete Bergen – eine Stadt, die wir schon kannten und die uns beim ersten Besuch so begeistert hatte, dass für uns sofort klar war: Hier wollen wir unbedingt noch einmal hin. Umso schöner war es, nun wieder hier zu sein 🧡.\n\nSchon am Morgen merkten wir, wie viel Glück wir mit dem Wetter hatten. Für Bergen fast schon ungewöhnlich: es war richtig schön warm, so warm, dass ich nur einen Pullover und eine Weste darüber trug. Kein Regen, kein Wind – einfach perfektes Wetter, um die Stadt zu Fuß zu entdecken ☀️✨.\n\nWie schon am Tag zuvor starteten wir entspannt mit einem Frühstück im Buffalo Steakhouse. Ruhig, gemütlich und genau richtig, bevor es für uns an Land ging. Danach hieß es: Jacken an, Kamera griffbereit – Bergen wartete 📸.\n\nUnser erster Programmpunkt war eine Hop-on-Hop-off-Bustour, ideal, um Bergen wieder kennenzulernen und sich gleichzeitig bequem einen Überblick zu verschaffen 🚌. An den berühmten bunten Häusern im Hanseviertel Bryggen stiegen wir aus. Dieses Viertel ist einfach etwas ganz Besonderes: die schmalen, farbigen Holzhäuser, die Geschichte, die man hier förmlich spürt, und direkt daneben der Hafen – Bergen zeigt sich hier von seiner schönsten Seite ⚓🏠.\n\nWir schlenderten über den Fischmarkt (Fisketorget), ließen die Atmosphäre auf uns wirken, schauten uns die Stände an und spazierten anschließend noch ein Stück am Hafen entlang. Mit der Sonne im Gesicht, dem Blick aufs Wasser und die umliegenden Berge war das einfach nur schön 🌊☀️.\n\nDanach ging es für uns zu einem echten Highlight des Tages – der Fløibanen. Beim letzten Besuch hatten wir es zeitlich nicht nach oben geschafft, diesmal wollten wir uns diese Aussicht auf keinen Fall entgehen lassen. Die Fahrt nach oben war schon ein Erlebnis für sich, aber als wir oben ankamen, waren wir einfach nur sprachlos 😍.\n\nDer Blick über Bergen, die umliegenden Berge, das Wasser – und die AIDA von oben zu sehen – war einfach überwältigend. So eine Aussicht hat man wirklich nicht oft. Wir verbrachten bestimmt eine gute Stunde dort oben, schlenderten herum, schauten in die kleinen Shops, setzten uns zwischendurch und genossen diesen Moment ganz bewusst. Einer dieser Augenblicke, die man abspeichert und nicht mehr vergisst 💙.\n\nWieder unten angekommen gönnten wir uns noch etwas Süßes: ein Softeis im Eisladen Tjommis in der Stadt 🍦. Eigentlich war ich erst skeptisch, doch ein älteres Ehepaar schwärmte so sehr davon, dass wir es einfach probieren mussten. Ich entschied mich für Softeis mit Erdbeeren und Erdbeersoße – und ich habe es wirklich nicht bereut. Es war richtig, richtig lecker 🍓😋.\n\nAnschließend bummelten wir noch durch ein paar Geschäfte, unter anderem durch einen kleinen Christmas Shop, den man über eine schmale, steile Treppe erreicht. Ein bisschen abenteuerlich – aber total süß und definitiv einen Besuch wert 🎄.\n\nAm Nachmittag ging es dann mit dem Hop-on-Hop-off-Bus wieder zurück zum Schiff. Perfektes Timing, denn um 15 Uhr wartete an Bord schon der Kuchen 🍰. Es gab Erdbeerkuchen mit Erdbeeren vom Karls Erdbeerhof – frisch, fruchtig und genau das Richtige nach einem erlebnisreichen Tag.\n\nUm 17 Uhr hieß es schließlich Abschied nehmen von Bergen. Das Auslaufen ist hier jedes Mal etwas Besonderes, vor allem wenn das Schiff unter der Askøybrua hindurchfährt. Wir standen auf unserem Balkon und genossen noch einmal die Aussicht, während Bergen langsam hinter uns verschwand 🌉⚓.\n\nAm Abend kehrten wir wieder im Buffalo Steakhouse ein. Ich gönnte mir erneut einen Burger, meine Mama ein Steak – beides wie immer richtig gut 🍔🥩. Danach schlenderten wir noch ein wenig durch die Shops an Bord, unter anderem durch den LEGO Store, bevor wir den Tag ganz ruhig ausklingen ließen.\n\nSpät am Abend saßen wir noch lange auf unserem Balkon, beobachteten den Sonnenuntergang, hörten das Meeresrauschen und ließen diesen wunderschönen Tag Revue passieren 🌅🌊. Bergen hat uns auch beim zweiten Besuch nicht enttäuscht – im Gegenteil. Es fühlte sich ein bisschen an wie Nachhausekommen 🧡.",
    "Am nächsten Morgen legten wir in Ålesund an, und wir freuten uns riesig, wieder in dieser wunderschönen Stadt zu sein. Schon vor Ankunft hatten wir online Tickets für die Bimmelbahn gebucht 🚋, damit wir vorne sitzen konnten und die Tour entspannt starten würden. So stiegen wir direkt nach dem Aussteigen vom Schiff in die Bimmelbahn ein und fuhren hinauf zum Aksla Aussichtspunkt 🌄.\n\nOben angekommen hatten wir etwa 20 Minuten, um die Aussicht zu genießen. Die bunten Dächer der Stadt, der glitzernde Hafen und das sanft schaukelnde Wasser darunter – alles wirkte so friedlich und idyllisch. Ich musste zugeben, dass die Aussicht in Bergen noch spektakulärer war, aber diese hier hatte ihren ganz eigenen Charme 💛. Wir atmeten tief durch, machten Fotos und ließen einfach den Moment auf uns wirken.\n\nNach der Bimmelbahnfahrt gingen wir zu Fuß durch die Straßen von Ålesund und bewunderten die wunderschöne Jugendstil-Architektur 🏛️. Überall waren kunstvolle Fassaden, kleine Balkone und liebevolle Details, die die Stadt so besonders machten. Zwischendurch schauten wir in ein paar Souvenirshops hinein, bestaunten kleine Handwerkskunstwerke und genossen die entspannte Atmosphäre. Anschließend schlenderten wir noch am Hafen entlang, beobachteten die Boote und ließen die frische Meeresluft auf uns wirken 🚤🌊.\n\nAm Abend kehrten wir aufs Schiff zurück und um 20 Uhr legten wir ab ⛴️. Wir setzten uns auf unseren Balkon, tranken unsere Getränke und lauschten dem Meeresrauschen, während die Sonne den Himmel in leuchtende Orange- und Rosatöne tauchte 🌅💛. So ließen wir den Tag in Ålesund gemütlich ausklingen, voller schöner Eindrücke, entspannter Momente und dem typischen Gefühl, dass Norwegen einfach immer wieder verzaubert 🛳️✨.",
    "Am nächsten Morgen erreichten wir endlich wieder Geirangerfjord, einen Ort, den wir einfach lieben 💛. Dieses Mal war alles ein bisschen anders: Wir legten zwei Stunden früher an als im Jahr zuvor und haben dadurch die ersten Momente der Einfahrt verschlafen 😅. Glücklicherweise wachten wir genau zur Passage der Sieben Schwestern auf – perfekt getimt, um die Wasserfälle noch in voller Pracht zu sehen. Die Sieben Schwestern – sieben einzelne Wasserfälle, die über die steilen Felsen stürzen – haben eine alte Legende: Ein Troll wollte einst die sieben Schwestern heiraten, doch sie entkamen ihm, indem sie sich in Wasserfälle verwandelten. Diese Geschichte hat den Fjord für uns noch magischer gemacht, während wir staunend aus dem Fenster schauten 🌟💦.\n\nKaum angelegt, ging es direkt ins Buffalo Steakhouse zum Frühstück 🍳🥓. Das kleine Frühstücksbuffet dort war zwar extra, aber es hat sich absolut gelohnt. Wir haben gemütlich gesessen, die Aussicht auf den Fjord genossen und uns auf den Tag eingestimmt. Anschließend stiegen wir vom Schiff und schlenderten durch die kleinen Gassen des Ortes Geiranger. Wir schauten in Souvenirshops, besuchten den Joker-Laden und probierten die berühmte Schokowaffel von Geiranger Sjokolade 🍫🧇 – außen knusprig, innen saftig, mit weißer Schokolade überzogen, einfach ein Traum! Auch der kleine Christmas-Laden war richtig süß 🎄✨.\n\nEin richtig cooles Highlight war der Seawalk, der vom Schiff aus in den Fjord hinausführt. Man läuft quasi über das Wasser, das Schiff liegt in der Mitte des Fjords, während um einen herum die majestätischen Berge aufragen. Es war zwar windig, selbst bei unserem sonnigen, warmen Wetter 🌞, und der Steg wackelte leicht, aber genau das machte den Spaziergang so besonders – ein echtes Abenteuer mit atemberaubender Aussicht 🏔️💨.\n\nZurück an Bord gönnten wir uns einen Milchshake, den ein besonders netter Kellner für uns extra zubereitet hat 🥤💛. Ich und meine Uroma hatten einen Milkshake, meine Mama einen Cocktail 🍹. Danach setzten wir uns auf den Balkon, atmeten die frische Fjordluft ein und ließen einfach alles auf uns wirken.\n\nUm 18 Uhr legten wir wieder ab, und wir saßen gemütlich auf dem Balkon, während wir an den Felsen und dem Troll vorbeifuhren. Die Sonne tauchte den Fjord in warme Farben, das Wasser glitzerte, und wir genossen das Meeresrauschen in vollen Zügen 🌅💖.\n\nAbends gab es wieder ein köstliches Dinner auf der AIDA – ich gönnte mir einen Burger, meine Mutter ein Steak 🍽️ – und danach ließen wir den Tag auf dem Balkon ausklingen. So viele Eindrücke, so viel Ruhe, so viel Schönheit – Geirangerfjord hat uns erneut verzaubert und uns wieder einmal bewusst gemacht, warum wir immer wieder hierher zurückkehren wollen.",
    "Am nächsten Morgen legten wir um 10 Uhr in Trondheim an ⛴️. Bevor wir das Schiff verließen, ging es wie immer zuerst ins Buffalo Steakhouse zum Frühstück 🍳🥐. Auch wenn das Frühstück dort extra kostet, lohnt es sich wirklich: frisch zubereitete Leckereien, gemütliches Ambiente und ein perfekter Start in den Tag, während draußen langsam die Sonne über Trondheim aufging 🌞.\n\nAnschließend machten wir uns auf den Weg, Trondheim auf eigene Faust zu erkunden 🚶‍♀️🚶‍♀️. Unser erster Spaziergang führte uns am Hafen entlang, vorbei an den bunten Lagerhäusern, die auf Stelzen direkt am Wasser stehen. Diese alten Holzhäuser, so typisch für Norwegen, strahlen einfach einen besonderen Charme aus – man fühlt sich sofort wie in einer anderen Zeit 🌊🏘️.\n\nDanach liefen wir zur Gamle Bybro, der alten Stadtbrücke von Trondheim, auch „Die Rote Brücke“ genannt. Von hier aus hatte man einen wunderbaren Blick auf die Holzhäuser auf der anderen Seite des Flusses Nidelva und die Umgebung der Altstadt. Die Brücke selbst ist ein beliebtes Fotomotiv und man spürt die Geschichte, die an diesem Ort in den Mauern und Holzbohlen steckt 📸✨.\n\nWir schlenderten anschließend noch ein bisschen durch die Straßen der Stadt. Trondheim ist zwar etwas größer als die kleinen Fjordhäfen, die wir bisher besucht hatten, aber trotzdem sehr charmant und gemütlich. Überall gab es kleine Cafés, Geschäfte und die typischen nordischen Häuser zu entdecken. Meine Mama und ich kannten die Stadt schon von früheren Besuchen, trotzdem hat es uns Spaß gemacht, noch ein paar neue Ecken zu erkunden 💛.\n\nUm 19 Uhr legten wir wieder ab, und wir konnten einen wunderschönen Sonnenuntergang über dem Fjord beobachten 🌅💖. Auf dem Schiff ging es anschließend noch in die AIDA Shops, wo ich mir eine richtig schöne Handtasche gekauft habe – ein kleines Souvenir, das mich immer an diesen Tag erinnern wird 👜✨.\n\nDen Abend ließen wir auf unserem Balkon ausklingen, tranken unsere Getränke, hörten das sanfte Meeresrauschen und genossen die Ruhe, während das Schiff langsam Trondheim hinter sich ließ 🌊💫. Es war ein perfekter Tag zwischen Stadtbummel, nordischem Charme und der entspannten Kreuzfahrt-Atmosphäre – einer dieser Tage, die man einfach in Erinnerung behält ❤️.",
    "Am nächsten Morgen legten wir bereits um 8 Uhr in Molde an ⛴️. Beim Einlaufen konnten wir schon aus der Ferne das markante Gebäude Scandic Seilet erkennen – ein architektonisches Highlight der Stadt. Von unserem Balkon aus hatten wir außerdem sofort einen Blick auf die Kathedrale von Molde, die majestätisch zwischen den Rosenbeeten der Stadt hervorstach ⛪🌹.\n\nNachdem wir von Bord gegangen waren, begrüßte uns direkt Dodo 🐾 – natürlich musste sofort ein kleines TikTok-Video her! Molde kannten wir schon ein wenig von früher, aber es ist einfach immer wieder wunderschön. Die Stadt trägt nicht umsonst den Beinamen „Stadt der Rosen“, überall blühten Rosen in allen Farben und verbreiteten einen herrlich frischen Duft 🌹💛.\n\nZuallererst spazierten wir zum Steg direkt vor dem Schiff, der um diese Uhrzeit noch ruhig und leer war. Besonders schön waren die Rosenkübel entlang des Stegs, die den Ort so idyllisch und gemütlich machten 🌸✨. Danach ging es weiter Richtung Kathedrale, am Rathaus vorbei und zum kleinen Blumentchen-Pavillon, an dem Touren angeboten wurden. Wir entschieden uns für die kürzere Tour, die uns zu einer spektakulären Aussicht führen sollte – das Molde-Panorama. Oben angekommen, wurden wir mit einem wunderschönen Blick über die Stadt, das Meer und die umliegenden Berge belohnt 🏞️😍. Es war ein toller Moment, die frische Luft zu genießen, die Sonne auf der Haut zu spüren und einfach die Schönheit Norwegens auf sich wirken zu lassen.\n\nAuf dem Rückweg hielten wir noch am Romsdal Museum. Das war wirklich interessant und ein bisschen verrückt zugleich – man konnte durch die Fenster sehen, dass dort tatsächlich früher Menschen lebten, mit Küchenutensilien, Möbeln und sogar Hunden 🏠🐶. Diese kleine Zeitreise war spannend und hat uns einen guten Eindruck vom Leben in Molde früher vermittelt.\n\nNach der Tour ging es zurück zum Rathaus, und nun passierte etwas Besonderes: Ich betrat mein erstes Café in Molde – das Macé Café AS ☕🥪🍓. Eigentlich gehe ich selten in Cafés, aber dieses hier hat mich magisch angezogen. Das Angebot war einfach unglaublich: frische belegte Brote, Waffeln, Smoothies und Kuchen. Wir haben belegte Brote gegessen und Smoothies getrunken – alles war frisch, lecker und mit viel Liebe zubereitet 😋💛. Das Café war zwar nicht ganz günstig, aber absolut empfehlenswert und ich kann mir jetzt schon vorstellen, dass wir bei zukünftigen Besuchen in Molde auf jeden Fall wieder hierher kommen werden.\n\nAm späten Nachmittag ging es zurück an Bord, und um 18 Uhr legten wir aus Molde wieder ab. Zum Abendessen ging es wie immer ins Buffalo Steakhouse, wo wir den Tag noch einmal Revue passieren ließen 🥩🍽️. Anschließend genossen wir noch die Abendstunden auf unserem Balkon, hörten das sanfte Meeresrauschen, ließen die warmen Farben des Sonnenuntergangs auf uns wirken 🌅🌊 und beendeten so einen rundum gelungenen Tag in Molde voller schöner Eindrücke, leckerem Essen und nordischem Flair ❤️✨.",
    "Am nächsten Morgen legten wir um 8 Uhr in Måløy (auf der Insel Måløyna) an, einem Hafen, wo wir zum ersten Mal überhaupt waren, und wir freuten uns total, etwas Neues zu entdecken 🌟. Schon beim Einlaufen behielten wir die ganze Zeit den Blick auf den Hafen und auf die Aussicht – alles wirkte so ruhig und typisch nordisch, dass wir sofort wussten: Heute wird ein richtig besonderer Tag 📍.\n\nDa die Freigabe auf 9 Uhr festgelegt war, gingen wir vorher noch ins Buffalo Steakhouse frühstücken 🥐☕. Das war super gemütlich, und wir waren danach entspannt und voller Energie, bevor wir endlich von Bord durften. Als wir dann vom Schiff runtergingen, warteten auch schon direkt einige nette Einheimische und Touranbieter, die ihre Touren anboten – und wir entschieden uns ganz spontan für eine geführte Tour mit dem Kleinbus 🚐.\n\nDer Busfahrer war einfach ein Highlight für sich 😄! Er war super sympathisch, hatte laute gute Musik an, brachte ab und zu ein Mikrofon raus und machte mit uns Karaoke – wir saßen direkt hinter ihm und es fühlte sich an wie ein kleines Mini‑Roadtrip‑Konzert 🎤🎶. Insgesamt waren wir so mit ca. 15 Leuten unterwegs und es war einfach total lustig.\n\nUnser erster Stopp war bei einem lila Haus 🟣, an dem wir anhielten, weil der Busfahrer uns erzählte, dass dort eine Frau aus Thailand wohnt, die ihr Haus mit einem Stein‑Motiv bemalt hat. In dieser Straße standen auch mehrere bunte Häuser – ein echter Hingucker und sooo fotogen 📸.\n\nDer nächste Halt war einer der wichtigsten Punkte des Tages: der Kannesteinen – eine ganz besondere Felsformation, die über Jahrtausende vom Wind und von den Wellen des Nordatlantiks geformt wurde 🪨💦. Dieser pilzförmige Stein in Oppedal ist etwa drei Meter hoch und zeigt ganz eindrucksvoll, was die Natur hier geleistet hat. Unser Busfahrer zeigte uns Bilder, die er dort gemacht hatte: einmal bei Sonnenuntergang, einmal mit Polarlichtern – einfach wunderschön ✨. Der Kalk der Wellen, die dagegenschlagen, hat dem Felsen seine einzigartige Form gegeben – ein echtes Naturkunstwerk 📷.  \n\nWeiter ging es zum Kråkenes fyr – dem Leuchtturm von Kråkenes 🗼, wo wir für etwa drei Viertelstunde anhielten und die etwa 10‑minütige Wanderung zum Aussichtspunkt machten. Der Weg dorthin war schon so schön: wilde Natur, die frische Luft, der Blick übers weite Meer – einfach Norwegen pur 🌬️🌊. Oben angekommen hatten wir Zeit, die Aussicht zu genießen und einige Fotos zu machen, bevor wir den Weg zurück zum Bus antraten. Leider war der Platz für Menschen mit Rollatoren nicht gut geeignet, was ein wenig schade war, aber für uns war es ein echtes Natur‑Erlebnis 🌿.\n\nDer letzte Stopp war der Strand Refviksanden 🏖️ – ein weißer Sandstrand, der oft als einer der schönsten Strände Norwegens beschrieben wird und mit seiner Länge von etwa 1,5 km wirklich beeindruckend ist 💙. Da stand es auf unserer Bucket‑List, zumindest einmal im Fjord „schwimmen“ zu gehen – also liefen wir einfach in unsere Sachen ins Wasser. Mit etwa 15 Grad Wassertemperatur war es zwar etwas frisch, aber überraschend angenehm und überhaupt nicht unangenehm ❄️😊. Wir hatten richtig Glück mit dem Wetter – Sonne, blauer Himmel und diese unglaubliche nordische Strandkulisse.  \n\nDie gesamte Tour dauerte etwa vier Stunden und war einfach ein Highlight des Tages – Landschaft, Lachen im Bus, Natur, Meer und ein super sympathischer Fahrer, der uns zwischendurch Geschichten erzählt hat 🚌✨.\n\nUm 16 Uhr legten wir wieder ab, und beim Ablegen gab es sogar eine kleine Strand‑Party 🎉: ein Elvis‑Imitator sang mit vollem Einsatz, und es wurden deutsche und norwegische Flaggen geschwungen 🇩🇪🇳🇴. Ein so verrückter, schöner Moment, den wir so schnell nicht vergessen werden.\n\nAbends gingen wir in der Tapas‑Bar auf der AIDA essen 🍽️ – so lecker und gemütlich – und danach ließen wir den Tag wieder auf unserem Balkon ausklingen 🌅🌊. Wir hörten das sanfte Meeresrauschen, blickten aufs Wasser und waren einfach dankbar für diesen wunderschönen, abwechslungsreichen Tag ❤️.",
    "Am nächsten Morgen legten wir pünktlich um 8 Uhr in Flåm an ⛴️. Schon der Hafen selbst ist ein Erlebnis: eingebettet zwischen den steilen, grünen Bergen und direkt am Aurlandsfjord – ein Ort, der sofort dieses besondere Norwegen‑Gefühl weckt 🌲🖼️.\n\nNatürlich wollten wir mit der berühmten Flåmsbana fahren – der legendären Bahnstrecke, die als eine der spektakulärsten Zugfahrten der Welt gilt. Doch leider war sie an diesem Tag bereits ausverkauft, und wir konnten keine Tickets mehr bekommen 😕. Das war zwar etwas schade, aber wir wollten trotzdem nicht tatenlos dastehen.\n\nAlso schauten wir uns um, was man sonst machen konnte – denn Flåm ist zwar nicht groß, dafür aber ausgesprochen gemütlich und einladend. Wir entdeckten eine Bimmelbahn‑Tour, die um 10 Uhr starten sollte 🚋, und buchten spontan mit. Bis dahin hatten wir noch etwas Zeit, also gingen wir noch einmal zurück an Bord und frühstückten wieder im Buffalo Steakhouse 🥐☕ – unser Standard‑Start in die Hafentage, wenn wir schon früh anlegen.\n\nNach dem Frühstück stiegen wir mit guter Laune in die Bimmelbahn ein. Die Fahrt dauerte etwa eine Stunde und führte uns in gemütlichem Tempo durch den Ortskern und ein kleines Stück der umliegenden Naturlandschaft 🌳🚂. Unterwegs sahen wir unter anderem die hübsche Flåmskyrkja – die kleine Kirche von Flåm –, deren weißer Turm sich malerisch vor den Bergen abzeichnete ⛪. Wirklich steile Berge oder dramatische Wasserfälle wie bei der Flåmsbana gab es hier nicht, aber gerade das machte es so angenehm und entspannt: vorbei an kleinen Häusern, Wiesen und immer wieder dieser klaren norwegischen Luft um uns herum 🌬️💚.\n\nWieder im Hafen angekommen, spazierten wir noch ein bisschen direkt vor dem Schiff über die Felsen. Wir suchten uns ein schönes Plätzchen, saßen nebeneinander und genossen den Blick aufs Wasser 🌊. Dabei mussten wir aufpassen, nicht aus Versehen auf einen losgelösten Felsen zu treten 🪨😅 – kleine Risiken gehören eben irgendwie auch zu solchen Naturerlebnissen dazu. Anschließend bummelten wir durch die Souvenir‑Shops, sahen uns ein paar lokale Sachen an und genossen das einfache, entspannte Flair in Flåm 🛍️✨.\n\nGegen 13 Uhr waren wir wieder auf dem Schiff und gönnten uns eine richtig leckere Currywurst 🌭, bevor es am Nachmittag weiterging. Doch auch der Abend hatte noch einiges zu bieten:\n\nZum Abendessen kehrten wir wieder im Buffalo Steakhouse ein 🍽️ – einfach unser Lieblingsplatz an Hafentagen, weil es dort immer so gemütlich ist und man sich nach einem langen Tag direkt willkommen fühlt. Danach zog es uns noch zur Eisbar, wo ich mir einen riesigen Erdbeerbecher mit Erdbeeren vom Karls Erdbeerhof 🍓🍨 gönnte – und ja, der war so gut, dass ich ihn auf der Reise später noch öfter hatte 😍.\n\nAm Abend nahmen wir an der Silent Party teil 🎧 – ein richtiges Highlight an Bord: Musik, die man über Kopfhörer direkt in den Ohren hat, Leute, die mitwippen, lachen und einfach Spaß haben. Danach war es Zeit für den gemütlichen Abschluss des Tages. Wir setzten uns wieder auf unseren Balkon, hörten das sanfte Meeresrauschen, blickten in den Sternenhimmel und ließen diesen wunderschönen Flåm‑Tag ganz in Ruhe ausklingen 🌌💫.",
    "Als wir am nächsten Morgen in Stavanger ankamen, waren wir sofort wieder begeistert. Wir kannten diesen Hafen schon von einer früheren Reise, aber jedes Mal, wenn man die Stadt erreicht und die weißen Häuser direkt am Wasser sieht, bleibt das ein wunderschöner Anblick 🏘️✨. Schon beim Einlaufen hatten wir diesen kleinen magischen Moment: die Sonne fiel auf die Dächer, der Himmel war klar, und die Kombination aus Altstadt und Meer wirkte wie ein klassisches Postkartenbild 📸.\n\nWir legten um 10 Uhr an und konnten es kaum erwarten, die Stadt zu erkunden. Direkt nach dem Ausschiffen liefen wir an den Straßenständen vorbei Richtung Innenstadt 🚶‍♀️🚶‍♀️. Irgendwie zog uns der erste Schuhladen magisch an 😉 – und was soll ich sagen… wir hatten einen echten Shopping‑Treffer! 🛍️👟✨ Insgesamt nahmen wir vier Paar Schuhe mit: zwei für mich und zwei für meine Mama. Der Tag war damit für uns schon erfolgreich gestartet – wenn man schöne Schuhe findet, macht das einfach gute Laune 😄.\n\nAnschließend spazierten wir weiter durch die Stadt, ließen uns treiben und genossen das urbane Flair. Besonders schön war das Gebiet mit den typischen weißen, malerischen Häusern, die Stavanger so ihren besonderen Charakter geben 🏡🤍. Diese Gegend heißt Gamle Stavanger – ein historisches Viertel mit engen Gassen, alten Gebäuden und einer Atmosphäre, die einen sofort zum Verweilen einlädt. Hier entdeckten wir auch wieder die Wichteltür, ein kleines, charmantes Detail, das wir schon vom letzten Besuch kannten und das uns dieses Mal wieder zum Schmunzeln brachte 🧝‍♂️🚪.\n\nWir schlenderten durch die engen Straßen von Gamle Stavanger, schauten in kleine Boutiquen und genossen einfach die Mischung aus Geschichte, modernen Shops und nordischer Lebensfreude 🌤️. Stavanger hat für uns genau diesen Mix: charmant, nicht zu groß, aber voller schöner Ecken.\n\nAm späten Nachmittag kehrten wir zurück zum Schiff, und um 19:30 Uhr legten wir wieder ab 🌅⚓. Das Auslaufen aus Stavanger war wieder wunderschön – sun setting, leichte Brise, das glitzernde Meer vor uns – ein perfekter Abschluss für einen wirklich gelungenen Tag in der Stadt.\n\nDen Abend ließen wir an Bord ausklingen: Wir waren noch ein bisschen in der Disco D6, haben getanzt, gelacht und den Tag einfach genossen 🕺🎶. Anschließend setzten wir uns auf unseren Balkon, hörten das entspannte Meeresrauschen, blickten auf das dunkle Wasser hinaus und ließen den Tag ganz ruhig ausklingen 🌊💜✨.",
    "Der Tag begann eigentlich wie ein entspannter Seetag, doch schon am Vorabend hatte der Kapitän uns informiert, dass wir uns so schnell wie möglich nach Hamburg bewegen müssen, da die Elbe wegen eines möglichen Sturms geschlossen werden könnte ⛈️😯. Eigentlich sollten wir erst am Morgen nach Hamburg kommen, aber nun war klar: wir mussten den Tag auf See genießen, aber gleichzeitig das Tempo halten.\n\nWir starteten entspannt in den Tag und gingen frühstücken ins Buffalo Steakhouse 🥓🥐☕. Dort gab es wieder das leckere kleine Frühstücksbuffet, und wir haben es richtig genossen, in Ruhe in den Tag zu starten. Danach hieß es Koffer packen und ein letztes Mal die AIDA Prima erkunden. Wir schlenderten durch die Shops, schauten uns noch ein paar Souvenirs an und machten das Schiff so richtig unsicher 😄🛍️.\n\nAm Nachmittag nutzten wir die Gelegenheit, es uns auf unserem Balkon gemütlich zu machen, den Blick auf das weite Meer zu genießen und einfach ein bisschen zu entspannen 🌊💺. Es war ein herrlicher Tag auf See, die Sonne schien, und wir hatten die frische Meeresbrise um die Nase.\n\nAm Abend kehrten wir erneut ins Buffalo Steakhouse zum Abendessen ein 🥩🍔 – ein perfekter Abschluss für einen Tag auf See. Danach setzten wir uns noch einmal auf unseren Balkon, denn die Elbe rief schon nach uns. Schon während wir auf dem Balkon saßen, konnten wir beobachten, wie die MSC an uns vorbeifuhr und kurz danach ein norwegisches Kreuzfahrtschiff. Es war spannend zu sehen, wie sich die großen Schiffe aneinander vorbeibewegten – ein richtiges Kreuzfahrt‑Highlight 🚢✨.\n\nGegen 23 Uhr erreichten wir schließlich Hamburg – noch vor der geplanten Morgenankunft. Wir fuhren am Containerhafen vorbei, sahen Planten un Blomen und die Lichter der Stadt glitzerten bereits im Dunkeln 🌃🌟. Um Mitternacht legten wir dann offiziell an. Endlich Hamburg! Es war so ein schönes Gefühl, die Stadt wiederzusehen und nach der langen Reise wieder festen Boden unter den Füßen zu haben 😍🏙️.\n\nNach diesem aufregenden Abend ging es dann für uns nur noch für ein paar Stunden schlafen, denn der Wecker würde früh klingeln, um die letzte Etappe unseres Hamburg-Aufenthaltes zu starten ⏰💤.",
    "Der letzte Tag unserer zweiten Norwegen-Kreuzfahrt begann noch einmal entspannt, aber auch ein kleines bisschen wehmütig. Wir starteten in den Tag mit einem Frühstück im Buffalo Steakhouse 🥓🥐☕ – unser allerletztes Frühstück an Bord der AIDA Prima. Es war wieder richtig lecker, und während wir da saßen, konnte ich gar nicht fassen, wie schnell die elf Tage vergangen waren. 😌💭\n\nUm 10 Uhr hieß es dann endgültig Abschied nehmen. Wir verließen das Schiff, stiegen ins Auto ein und machten uns bereit für die Heimreise nach Köln 🚗💨. Das Packen war ein kleines Abenteuer für sich – wir hatten so unglaublich viel mitgenommen, dass wir uns gefühlt wie echte Tetris-Meister vorkamen, bis alles irgendwie ins Auto passte 😅📦.\n\nEndlich alles verstaut, starteten wir die lange Fahrt – viereinhalb Stunden lagen vor uns. Doch während wir auf der Autobahn unterwegs waren, konnten wir richtig dankbar sein: Wir hatten Glück mit der Elbe und dem Wetter, konnten rechtzeitig in Hamburg anlegen und mussten keine Häfen auslassen. Tatsächlich hatte es für die nächste Kreuzfahrt dort richtiges Unwetter gegeben 🌧️⚡. Die Schiffe mussten mehrere Tage im Hamburger Hafen bleiben, konnten erst verspätet starten, und manche Häfen wurden sogar gestrichen. Wir konnten uns wirklich glücklich schätzen, dass wir unsere Route so problemlos genießen konnten – und dass wir die Stadt noch einmal in Ruhe erleben durften.\n\nWährend wir über die Autobahn fuhren, war es ein richtiges Gefühl der Ruhe und des Nachklingens: Wir redeten noch über unsere Lieblingsmomente, lachten über kleine Pannen, erinnerten uns an wunderschöne Sonnenuntergänge auf dem Balkon 🌅🛳️, die Aussicht auf die Fjorde, das leckere Essen an Bord und in den Häfen, und an all die besonderen Augenblicke, die wir zu dritt – ich, meine Mama und meine Uroma – erleben durften. 💖\n\nSo ging ein weiterer unvergesslicher Abschnitt unserer Kreuzfahrt zu Ende. Wir fuhren aus Hamburg heraus, weg vom Sturm, Richtung Heimat – voller glücklicher Erinnerungen und schon mit Plänen im Kopf für die nächste Reise 🛳️✨.",
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final s = S.of(context)!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          S.of(context)!.titleNorwegen,
          style: GoogleFonts.pacifico(color: textColor, fontSize: 28),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: textColor),
        toolbarHeight: 80,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: imagesPerDay.length,
        itemBuilder: (context, dayIndex) {
          final imageCount = imagesPerDay[dayIndex];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                [
                  s.norwegenDayTitle1,
                  s.norwegenDayTitle2,
                  s.norwegenDayTitle3,
                  s.norwegenDayTitle4,
                  s.norwegenDayTitle5,
                  s.norwegenDayTitle6,
                  s.norwegenDayTitle7,
                  s.norwegenDayTitle8,
                  s.norwegenDayTitle9,
                  s.norwegenDayTitle10,
                  s.norwegenDayTitle11,
                  s.norwegenDayTitle12,
                ][dayIndex],
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                [
                  s.norwegenDay1,
                  s.norwegenDay2,
                  s.norwegenDay3,
                  s.norwegenDay4,
                  s.norwegenDay5,
                  s.norwegenDay6,
                  s.norwegenDay7,
                  s.norwegenDay8,
                  s.norwegenDay9,
                  s.norwegenDay10,
                  s.norwegenDay11,
                  s.norwegenDay12,
                ][dayIndex],
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 12),

              if (imageCount > 0)
                Column(
                  children: [
                    SizedBox(
                      height: 300, // max Höhe, Quer/Hochkant passt sich an
                      child: PageView.builder(
                        itemCount: imageCount,
                        onPageChanged: (i) {
                          setState(() {
                            currentImageIndex[dayIndex] = i;
                          });
                        },
                        itemBuilder: (context, imgIndex) {
                          final path = imagePaths[dayIndex][imgIndex];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: buildFirebaseImage(path),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(imageCount, (dotIndex) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentImageIndex[dayIndex] == dotIndex
                                ? Colors.purple
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
