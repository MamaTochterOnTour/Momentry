import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Wenn du UserID brauchst
import '../pages/premium_verwalten_page.dart';
import '../../l10n/s.dart';

class KaribikReisePage extends StatefulWidget {
  final bool isDarkMode;

  const KaribikReisePage({super.key, required this.isDarkMode});

  @override
  State<KaribikReisePage> createState() => _KaribikReisePageState();
}

class _KaribikReisePageState extends State<KaribikReisePage> {
  bool? isPremium;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadPremiumStatus();
  }

  Future<void> _loadPremiumStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isPremium = false);
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    setState(() {
      isPremium = userDoc.data()?['isPremium'] == true;
    });
  }

  bool showContent(int dayIndex) {
    if (isPremium == true) return true; // Premium: alles
    if (dayIndex <= 2) return true; // Nicht-Premium: Tag 1-3 alles
    if (dayIndex == 3) return false; // Tag 4: Text & Bilder ausblenden
    return false; // Ab Tag 5: nichts sichtbar
  }

  bool showReadMoreBox(int dayIndex) {
    if (isPremium == true) return false; // Premium: keine Box
    return dayIndex == 3; // Tag 4: Box anzeigen
  }

  // Anzahl der Bilder pro Tag
  final List<int> imagesPerDay = [
    7,
    1,
    14,
    6,
    14,
    0,
    3,
    4,
    12,
    0,
    4,
    3,
    4,
    1,
    0,
  ];

  // Aktueller Bildindex pro Tag
  List<int> currentImageIndex = List.filled(15, 0);

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final s = S.of(context)!;

    // Bilderpfade pro Tag (Platzhalter, bitte durch echte Bilder ersetzen)
    final List<List<String>> images = [
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlughafenKölnLaRomana.jpg?alt=media&token=5b1723d7-e327-4fb8-88d4-f0dd411baf7f',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlughafenKölnLaRomana2.jpg?alt=media&token=79b0be9b-df9c-488a-8dee-dae8e4fbc86c',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlughafenKölnLaRomana3.jpg?alt=media&token=e4d78330-8a1c-4c77-8619-44b6cf057419',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlughafenKölnLaRomana4.jpg?alt=media&token=8ad17f1b-100d-46b1-a775-6dfb81e70858',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FLaRomana10.jpg?alt=media&token=d4fa50df-a52e-464d-8674-a2aad5e71969',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FLaRomana3.jpg?alt=media&token=b5d07749-0160-40eb-a676-74326aaf2ce5',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FLaRomana4.jpg?alt=media&token=896b1f37-b0cf-4a64-bf79-19aabda1e976',
      ],
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FInfinityPool.jpg?alt=media&token=95717e31-5944-4b7c-ad4c-51baac78b293',
      ],
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba2.jpg?alt=media&token=7ed48168-1578-4516-a6c2-fd47726950a9',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba3.jpg?alt=media&token=04c6e39b-e5fe-4cdb-822f-ac9f3078ed78',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba4.jpg?alt=media&token=e3938719-4075-48db-b651-aeba648f641c',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba5.jpg?alt=media&token=d93141ab-c2e5-47be-a0b8-9e2450636e1c',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba6.jpg?alt=media&token=41a72a69-0277-4c2d-81b4-d390fbf163d5',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba7.jpg?alt=media&token=d6cb43de-a0b3-4bca-952a-5833187a863a',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba8.jpg?alt=media&token=fde5df00-8287-4a6d-8631-c7b6db4b67f4',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba9.jpg?alt=media&token=2589079e-0908-43ac-a69b-d6831ad6f703',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba10.jpg?alt=media&token=6d90ceb0-2046-4ddf-9183-564465ee681f',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba11.jpg?alt=media&token=c4e769ba-a830-4b37-8945-6dbd00923f78',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba12.jpg?alt=media&token=80a88bab-de74-4482-81a2-5d3192c6f308',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba13.jpg?alt=media&token=d2502f99-491b-45df-bd21-de69b91c8fc8',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba14.jpg?alt=media&token=4be6728e-e145-49ef-bebd-0b0f8aa972b7',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAruba15.jpg?alt=media&token=1f0738c7-6298-401d-87ce-b3133eb94b44',
      ],
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCuracao2.jpg?alt=media&token=8330760a-a8c9-476c-a001-e1ade0b72758',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCuracao3.jpg?alt=media&token=7e9e323f-cddb-47e2-af0d-6e33826ff755',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCuracao4.jpg?alt=media&token=b5e2d59f-e15e-4bdd-98d0-80e07d0706ce',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCuracao5.jpg?alt=media&token=2999b53e-d99b-42f9-8a55-1dfea77797ae',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCuracao6.jpg?alt=media&token=a5f5416c-59fe-4134-aa86-84e6ba4a65d9',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCuracao7.jpg?alt=media&token=02be93ea-da8b-44fb-b1ce-fb3b9eb8add0',
      ],
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair2.jpg?alt=media&token=4820f41e-0897-42f5-9a0f-90456de5f7c5',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair3.jpg?alt=media&token=84ae166f-803a-4029-ac8a-37682c81eacb',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair4.jpg?alt=media&token=6f25e5af-a04d-4b00-97cb-413d4924bfed',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair5.jpg?alt=media&token=fc5aa307-a604-4e2f-81c7-11d6b250cfc5',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair6.jpg?alt=media&token=1318d73f-0241-453b-93a5-cc8dfd9d4f55',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair7.jpg?alt=media&token=21df631b-3980-49ff-bc67-b4d57258e9a3',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair8.jpg?alt=media&token=674af082-c6da-449e-af9c-0972f8bc6ec1',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair9.jpg?alt=media&token=78485f72-a205-45d0-980d-088036107a9c',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair10.jpg?alt=media&token=3d6b543b-da35-4c19-88c6-434d094937b1',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair11.jpg?alt=media&token=0d75f8ca-4517-41f1-99d1-055bf27a2b5a',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair12.jpg?alt=media&token=334e1bdb-e123-40a1-93e0-6f8f24674bd8',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair13.jpg?alt=media&token=e6808453-2327-4aaa-9399-ce7beea9ce80',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair14.jpg?alt=media&token=590abd7d-480c-4816-ba46-465c2b9036dd',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBonair15.jpg?alt=media&token=2b19055f-757c-4a80-9b48-ab226cd6f623',
      ],
      [],
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGrenada2.jpg?alt=media&token=78c50948-fbf9-4a0a-9742-57b9d8a94568',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGrenada3.jpg?alt=media&token=7028f0ac-b185-4c64-9c97-3a87bbe22b61',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGrenada4.jpg?alt=media&token=6472a5ab-5ca9-4177-abf8-aca964ba2384',
      ],
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBarbados2.jpg?alt=media&token=2234eedd-75e4-400d-ab79-64cd66e26dcc',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBarbados3.jpg?alt=media&token=aca91abe-5ca4-4787-abd9-77ea7d091a7f',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBarbados4.jpg?alt=media&token=fa95e87f-be41-4405-8568-6f2a2fe53a90',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBarbados5.jpg?alt=media&token=8007a7a8-c9b0-4536-8134-f6cd8a3cdfc9',
      ],
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVincent2.jpg?alt=media&token=69de46ab-e235-497d-99f7-656628fa3cbf',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVincent3.jpg?alt=media&token=6b90e1c4-e2ac-46c8-8422-d2968b40ef35',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVincent4.jpg?alt=media&token=d98e3560-26b2-48e2-a31c-363361076e11',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVincent5.jpg?alt=media&token=4d943748-d624-4659-aaf2-0ca540575e0b',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVincent6.jpg?alt=media&token=835a7675-2c38-4781-83f1-cab3a256c717',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVincent7.jpg?alt=media&token=3683a7b3-10b4-4556-863e-3cce09f2c2f1',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVincent8.jpg?alt=media&token=b618d4c7-6b46-4b04-9dcb-2974c407ba94',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVincent9.jpg?alt=media&token=bb8f0686-9bf3-430e-95f6-a218ce9d539f',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVincent10.jpg?alt=media&token=e67463fe-776e-4e42-81ee-9bd8d953757c',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVincent11.jpg?alt=media&token=e4e2c05f-c39c-4df3-b288-d672b80ebf62',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVincent12.jpg?alt=media&token=35c72179-0f0e-433a-9523-c27c11d5312e',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVincent13.jpg?alt=media&token=9bb18927-6b57-470f-ae93-fa68ab30ba68',
      ],
      [],
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FDominica1.jpg?alt=media&token=475ec117-a327-4cf8-9cdf-92c12bf18198',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FDominica2.jpg?alt=media&token=7c43830a-d804-4fbb-853f-479db2ce712d',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FDominica3.jpg?alt=media&token=b7715f86-25a6-46ca-ae40-9a46c69fd4d5',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FDominica4.jpg?alt=media&token=f74aec73-3da8-4729-aa68-8361aba909db',
      ],
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGuadeloupe1.jpg?alt=media&token=73ca5945-1ade-4a1e-9201-10ad32295678',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGuadeloupe2.jpg?alt=media&token=1710c893-fa74-476a-800d-fd0f517be8e5',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGuadeloupe3.jpg?alt=media&token=9dabc0bb-1f84-42d8-a43d-a7d3b3ecc790',
      ],
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAntigua1.jpg?alt=media&token=fc5ef2a8-ccd3-4491-8466-19c441a5f917',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAntigua2.jpg?alt=media&token=f8487ee6-58a9-4f49-8e71-bdd1eae68a42',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAntigua3.jpg?alt=media&token=c2121812-a9e0-43ef-8fb1-e62cd78de2b0',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAntigua4.jpg?alt=media&token=401d46f4-c4e5-4460-8854-1704dcef422a',
      ],
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDADunkel.jpg?alt=media&token=b234be01-deb1-49eb-bc64-264deca4015d',
      ],
      [],
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          S.of(context)!.caribeanTitle,
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
              // Titel nur anzeigen, wenn Content sichtbar ist
              if (showContent(dayIndex))
                Text(
                  [
                    s.aidaKaribikDay1,
                    s.aidaKaribikDay2,
                    s.aidaKaribikDay3,
                    s.aidaKaribikDay4,
                    s.aidaKaribikDay5,
                    s.aidaKaribikDay6,
                    s.aidaKaribikDay7,
                    s.aidaKaribikDay8,
                    s.aidaKaribikDay9,
                    s.aidaKaribikDay10,
                    s.aidaKaribikDay11,
                    s.aidaKaribikDay12,
                    s.aidaKaribikDay13,
                    s.aidaKaribikDay14,
                    s.aidaKaribikDay15,
                  ][dayIndex],
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              if (showContent(dayIndex)) const SizedBox(height: 6),

              // Beschreibung nur anzeigen, wenn Content sichtbar
              if (showContent(dayIndex))
                Text(
                  [
                    s.aidaKaribik1,
                    s.aidaKaribik2,
                    s.aidaKaribik3,
                    s.aidaKaribik4,
                    s.aidaKaribik5,
                    s.aidaKaribik6,
                    s.aidaKaribik7,
                    s.aidaKaribik8,
                    s.aidaKaribik9,
                    s.aidaKaribik10,
                    s.aidaKaribik11,
                    s.aidaKaribik12,
                    s.aidaKaribik13,
                    s.aidaKaribik14,
                    s.aidaKaribik15,
                  ][dayIndex],
                  style: TextStyle(color: textColor),
                ),

              if (showContent(dayIndex)) const SizedBox(height: 12),

              // Bilder nur anzeigen, wenn Content sichtbar
              if (showContent(dayIndex) && imageCount > 0)
                Column(
                  children: [
                    SizedBox(
                      height: 500,
                      child: PageView.builder(
                        itemCount: imageCount,
                        onPageChanged: (i) {
                          setState(() {
                            currentImageIndex[dayIndex] = i;
                          });
                        },
                        itemBuilder: (context, imgIndex) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              images[dayIndex][imgIndex],
                              fit: BoxFit.contain,
                              width: double.infinity,
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

              // Box „Weiterlesen nur mit Premium“ nur für Tag 4 bei Nicht-Premium
              if (showReadMoreBox(dayIndex))
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purple[100], // helles Lila
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withAlpha((0.2 * 255).round()),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "🌴 Möchtest du wissen, wie unsere Karibik-Reise weiterging? 🌊\n\nDer Rest ist nur in Premium verfügbar! ⭐",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PremiumPage(uid: uid),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.purple, // dunkleres Lila für den Button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Zur Premium-Seite 🔑",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
