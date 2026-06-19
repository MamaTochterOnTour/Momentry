import 'product.dart';

final List<Product> travelGiudes = [
  Product(
    id: 'guide_1',
    name: '✨ Paris Insider Guide',
    price: 4.99,
    description:
        'Paris ist viel mehr als Eiffelturm, Louvre und eine Stadt für einen kurzen Städtetrip. Dieser Guide zeigt dir die Stadt so, wie wir sie erleben – mit echten Lieblingsorten, besonderen Highlights, versteckten Ecken und persönlichen Empfehlungen.\n\nStatt oberflächlicher Tipps bekommst du eine klare, strukturierte Übersicht über die wichtigsten Sehenswürdigkeiten, Insider-Spots, Cafés und praktischen Reisetipps für deinen Aufenthalt.\n\nOb Architektur, Stadtviertel, französisches Lebensgefühl oder Food-Szenen – dieser Guide hilft dir dabei, Paris stressfrei, authentisch und intensiver zu entdecken.\n\nPerfekt für alle, die nicht einfach nur durch Paris laufen, sondern die Stadt wirklich erleben wollen.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FParisThumbnail.png?alt=media&token=0dfea857-904a-4fe9-9b56-62b786a140ad',
    tab: 0,
    rcProductId: 'Paris',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FParisGuide.pdf?alt=media&token=a692a2ad-c9c9-4029-9dc2-7f276f5bbea8',
    categories: ['frankreich'],
  ),
  Product(
    id: 'guide_2',
    name: '✨ Mallorca Insider Guide',
    price: 4.99,
    description:
        'Mallorca ist viel mehr als Ballermann und Hotelanlagen. Dieser Guide zeigt dir die Insel so, wie wir sie auf unseren Reisen erlebt haben – mit echten Lieblingsorten, versteckten Buchten, besonderen Restaurants und persönlichen Empfehlungen.\n\nStatt oberflächlicher Tipps bekommst du eine klare, strukturierte Übersicht über die schönsten Orte der Insel, kombiniert mit echten Erfahrungen, Insider-Spots und praktischen Reisetipps.\n\nOb Strände, Berge, Städte oder Food – dieser Guide hilft dir dabei, Mallorca stressfrei, authentisch und deutlich intensiver zu erleben.\n\nPerfekt für alle, die nicht einfach „Urlaub machen“, sondern die Insel wirklich entdecken wollen.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FMallorcaThumbnail.png?alt=media&token=79122bfc-d2eb-4789-b5d8-e837ce29bef9',
    tab: 0,
    rcProductId: 'Mallorca',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FMallorcaGuide.pdf?alt=media&token=00f26e1a-c701-4b24-b088-bf153dc2a077',
    categories: ['spanien', 'beliebt'],
  ),
  Product(
    id: 'guide_3',
    name: '✨ Florenz Insider Guide',
    price: 4.99,
    description:
        'Florenz ist viel mehr als Renaissance, Museen und ein kurzer Stopp auf einer Italienreise. Dieser Guide zeigt dir die Stadt so, wie wir sie erleben – mit echten Lieblingsorten, besonderen Highlights, versteckten Ecken und persönlichen Empfehlungen.\n\nStatt oberflächlicher Tipps bekommst du eine klare, strukturierte Übersicht über die wichtigsten Sehenswürdigkeiten, Insider-Spots, Cafés und praktischen Reisetipps für deinen Aufenthalt.\n\nOb Kunst, Architektur, italienisches Lebensgefühl oder Food-Szenen – dieser Guide hilft dir dabei, Florenz stressfrei, authentisch und intensiver zu entdecken.\n\nPerfekt für alle, die nicht einfach nur durch Florenz laufen, sondern die Stadt wirklich erleben wollen.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FFlorenzThumbnail.png?alt=media&token=75a6f50b-0c6d-4d6a-b066-b3d555c50a30',
    tab: 0,
    rcProductId: 'Florenz',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FFlorenzGuide.pdf?alt=media&token=7ce46951-aa8c-4560-ad9f-9faed9ab038e',
    categories: ['italien'],
  ),
  Product(
    id: 'guide_4',
    name: '✨ Mailand Insider Guide',
    price: 4.99,
    description:
        'Mailand ist viel mehr als Mode, Business und eine Stadt für einen kurzen Zwischenstopp. Dieser Guide zeigt dir die Stadt so, wie wir sie erleben – mit echten Lieblingsorten, besonderen Highlights, versteckten Ecken und persönlichen Empfehlungen.\n\nStatt oberflächlicher Tipps bekommst du eine klare, strukturierte Übersicht über die wichtigsten Sehenswürdigkeiten, Insider-Spots, Cafés und praktischen Reisetipps für deinen Aufenthalt.\n\nOb Architektur, Stadtviertel, italienisches Lebensgefühl oder Food-Szenen – dieser Guide hilft dir dabei, Mailand stressfrei, authentisch und intensiver zu entdecken.\n\nPerfekt für alle, die nicht einfach nur durch Mailand laufen, sondern die Stadt wirklich erleben wollen.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FMailandThumbnail.png?alt=media&token=9bb67989-b0a4-4ea0-9185-f1848398c6a9',
    tab: 0,
    rcProductId: 'Mailand',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FMailandGuide.pdf?alt=media&token=80c04f17-d43d-45f5-8746-c9d51677fb15',
    categories: ['italien'],
  ),
  Product(
    id: 'guide_5',
    name: '✨ Venedig Insider Guide',
    price: 4.99,
    description:
        'Venedig ist viel mehr als Gondeln, Kanäle und der Markusplatz. Dieser Guide zeigt dir die Stadt so, wie wir sie erleben – mit echten Lieblingsorten, besonderen Highlights, versteckten Ecken und persönlichen Empfehlungen.\n\nStatt oberflächlicher Tipps bekommst du eine klare, strukturierte Übersicht über die wichtigsten Sehenswürdigkeiten, Insider-Spots, Cafés und praktischen Reisetipps für deinen Aufenthalt.\n\nOb historische Plätze, ruhige Viertel, venezianisches Lebensgefühl oder Food-Spots – dieser Guide hilft dir dabei, Venedig stressfrei, authentisch und intensiver zu entdecken.\n\nPerfekt für alle, die nicht einfach nur durch Venedig laufen, sondern die Stadt wirklich erleben wollen.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FVenedigThumbnail.png?alt=media&token=5c78c619-c45b-4ba3-8114-e1174818c366',
    tab: 0,
    rcProductId: 'Venedig',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FVenedigGuide.pdf?alt=media&token=29b59ea0-ec77-41dc-8eab-3befe372d38b',
    categories: ['italien'],
  ),
  Product(
    id: 'guide_6',
    name: '✨ Berlin Insider Guide',
    price: 4.99,
    description:
        'Berlin ist viel mehr als nur Hauptstadt, Politik und bekannte Sehenswürdigkeiten. Dieser Guide zeigt dir die Stadt so, wie wir sie auf unseren Reisen erlebt haben – mit echten Lieblingsorten, besonderen Vierteln, spannenden Highlights und persönlichen Empfehlungen.\n\nStatt oberflächlicher Tipps bekommst du eine klare, strukturierte Übersicht über die wichtigsten Orte der Stadt, kombiniert mit echten Erfahrungen, Insider-Spots und praktischen Reisetipps.\n\nOb Geschichte, moderne Kieze, Streetfood oder kulturelle Highlights – dieser Guide hilft dir dabei, Berlin stressfrei, authentisch und deutlich intensiver zu erleben.\n\nPerfekt für alle, die nicht einfach nur durch Berlin laufen, sondern die Stadt wirklich entdecken wollen.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FBerlinThumbnail.png?alt=media&token=5e280bab-4028-4460-947a-4725cde84136',
    tab: 0,
    rcProductId: 'Berlin',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FBerlinGuide.pdf?alt=media&token=9f05d804-000b-4c44-b2f3-a617e7d16a4a',
    categories: ['deutschland'],
  ),
  Product(
    id: 'guide_7',
    name: '✨ Hamburg Insider Guide',
    price: 4.99,
    description:
        'Hamburg ist viel mehr als nur Hafen, Reeperbahn und bekannte Sehenswürdigkeiten. Dieser Guide zeigt dir die Stadt so, wie wir sie auf unseren Reisen erlebt haben – mit echten Lieblingsorten, besonderen Vierteln, spannenden Highlights und persönlichen Empfehlungen.\n\nStatt oberflächlicher Tipps bekommst du eine klare, strukturierte Übersicht über die wichtigsten Orte der Stadt, kombiniert mit echten Erfahrungen, Insider-Spots und praktischen Reisetipps.\n\nOb Hafen, moderne Stadtviertel, kulinarische Highlights oder kulturelle Orte – dieser Guide hilft dir dabei, Hamburg stressfrei, authentisch und deutlich intensiver zu erleben.\n\nPerfekt für alle, die nicht einfach nur durch Hamburg laufen, sondern die Stadt wirklich entdecken wollen.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FHamburgThumbnail.png?alt=media&token=cc137bf0-1017-4193-9ed8-f93ad1b7f7aa',
    tab: 0,
    rcProductId: 'Hamburg',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FHamburgGuide.pdf?alt=media&token=f0157de9-be25-4f53-a98d-56648f64e609',
    categories: ['deutschland', 'beliebt'],
  ),
  Product(
    id: 'guide_8',
    name: '🛳️ AIDA Kreuzfahrt Guide – Tarife, Clubstufen & Insider Tipps',
    price: 4.99,
    description:
        'AIDA ist viel mehr als nur eine Kreuzfahrt – es ist ein komplettes Urlaubssystem mit eigenen Tarifen, Clubstufen, Internetpaketen und Bordleben. Dieser Guide zeigt dir alles, was du vor deiner Reise wirklich wissen musst – klar, verständlich und ohne komplizierte Fachsprache.\n\nStatt unübersichtlicher Informationen bekommst du eine strukturierte Übersicht über die wichtigsten AIDA Tarife, Clubstufen, Internet an Bord sowie praktische Tipps für deine Buchung und Reise.\n\nOb Kabinenwahl, Preisunterschiede, Internetnutzung oder Vorteile im AIDA Club – dieser Guide hilft dir dabei, AIDA besser zu verstehen, clever zu buchen und unnötige Kosten zu vermeiden.\n\nPerfekt für alle, die ihre erste AIDA Reise planen oder einfach das Maximum aus ihrer Kreuzfahrt herausholen wollen.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FAIDAThumbnail.png?alt=media&token=2b840cd0-16c8-4cbc-94cb-6565a68ac17f',
    tab: 2,
    rcProductId: 'AIDAAllgemein',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FAIDAGuide.pdf?alt=media&token=47aa780f-05f9-415b-ab42-14a0f928a0ec',
    categories: ['aida', 'beliebt'],
  ),
  Product(
    id: 'guide_9',
    name: '🛳️ Kreuzfahrt - Mediterrane Schätze mit Korsika',
    price: 14.99,
    description:
        'Diese Kreuzfahrt verbindet mediterranes Lebensgefühl mit einigen der schönsten Küstenstädte Europas. Sonne, Kultur und Küstenorte machen diese Route zu einer der abwechslungsreichsten Kreuzfahrten.\n\nStatt allgemeiner Informationen findest du hier eine klare Übersicht über alle Stopps, kombiniert mit echten Tipps für Landgänge, Sehenswürdigkeiten und die schönsten Ausflugsziele in jeder Region.\n\nOb italienische Küstenstädte, französisches Flair oder spanisches Stadtleben – diese Kreuzfahrt vereint Kultur, Genuss und Mittelmeer-Atmosphäre.\n\nPerfekt für alle, die Sonne, Städte und mediterrane Vielfalt in einer Reise erleben wollen.\n\nHäfen & Ausflüge:\n- Mallorca (Start / Ziel)\n- La Spezia → Pisa / Florenz\n- Civitavecchia → Rom\n- Korsika\n- Barcelona',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FMediterraneSchaetzeThumbnail.png?alt=media&token=a1f4f4f9-b307-4ba3-b4ae-ddaf1a3e059b',
    tab: 1,
    rcProductId: 'MedSchätzeKreuzfahrt',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FMediterraneSchaetzeGuide.pdf?alt=media&token=01027c64-70ec-48fb-84a4-908c23db071b',
    categories: ['aida'],
  ),
  Product(
    id: 'guide_10',
    name: '🛳️ Kreuzfahrt - Metropolen ab Hamburg',
    price: 14.99,
    description:
        'Diese Kreuzfahrt ist viel mehr als nur eine klassische Nordsee-Route. Sie verbindet einige der schönsten Metropolen Westeuropas mit einzigartigen Hafenmomenten und spannenden Tagesausflügen.\n\nStatt oberflächlicher Reiseinfos bekommst du eine klare, strukturierte Übersicht über jede Station deiner Route – kombiniert mit echten Erfahrungen, Ausflugstipps und praktischen Hinweisen für Landgänge in Europas bekanntesten Städten.\n\nOb Großstadtflair, historische Altstädte oder ikonische Sehenswürdigkeiten – diese Kreuzfahrt zeigt dir Europa auf eine intensive und unkomplizierte Art.\n\nPerfekt für alle, die in kurzer Zeit viele Städte erleben wollen, ohne selbst alles planen zu müssen.\n\nHäfen & Ausflüge:\n- Hamburg (Start / Ziel)\n- Zeebrügge → Brüssel\n- Rotterdam\n- Le Havre → Paris\n- Southampton → London',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FMetropolenThumbnail.png?alt=media&token=eb9c23da-04e6-48e8-bd22-b38dab10e075',
    tab: 1,
    rcProductId: 'MetropolenKreuzfahrt',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FMetropolenGuide.pdf?alt=media&token=2e842ebc-79d6-4fe5-96d3-0e5db43cd369',
    categories: ['aida'],
  ),
  Product(
    id: 'guide_11',
    name: 'Barcelona in 48 Stunden\n(Digital)',
    price: 4.99,
    description:
        'Erlebe Barcelona in nur zwei Tagen! Unser digitaler Barcelona-Guide zeigt dir, wie du die Highlights der Stadt entspannt entdeckst, wo du richtig gut essen kannst 🍤🥘 und an welchen Orten du echtes Barcelona-Feeling spürst – Stadt, Strand & Genuss perfekt kombiniert. Für wen ist dieser Guide geeignet? Für Kurzurlauber, die Barcelona in 48 Stunden optimal nutzen möchten ⏰ Für Familien, Paare oder Freundesgruppen, die stressfrei planen wollen 👨👩👧👦💑 Für alle, die ehrliche Tipps & Genussmomente aus erster Hand lieben 🗺️ Für wen ist er eher nicht geeignet? Für Langzeitreisende, die Barcelona über viele Wochen entdecken möchten Für Reisende, die nur reine Sehenswürdigkeiten ohne persönliche Empfehlungen suchen ✨ Dieser Guide wurde liebevoll erlebt und zusammengestellt von MamaTochterOnTour – für zwei unvergessliche Tage in Barcelona! ❤️',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FBarcelona48.png?alt=media&token=92662efc-db07-4f71-9bd4-b8e45976e85d',
    tab: 2,
    rcProductId: 'Barcelona48',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FBarcelona48Stunden.pdf?alt=media&token=4f9cf91d-a727-4b25-9e5b-605d7ea8c7e5',
    categories: ['spanien'],
  ),
  Product(
    id: 'guide_12',
    name: 'Rom in 48 Stunden',
    price: 4.99,
    description:
        'Entdecke Rom in nur 48 Stunden! 🇮🇹✨\n\nDieser digitale Reiseguide zeigt dir, wie du die Highlights der Ewigen Stadt stressfrei erleben kannst – von weltberühmten Sehenswürdigkeiten bis hin zu versteckten Lieblingsorten. Freue dich auf persönliche Empfehlungen, praktische Zeitpläne und ausgewählte Restauranttipps. 🍕🍷\n\n💡 Perfekt für:\n• Kurzurlauber, die das Beste aus zwei Tagen herausholen möchten\n• Familien, Paare und Freundesgruppen\n• Reisende, die eine entspannte Planung mit echten Insider-Tipps schätzen\n\n📍 Das erwartet dich:\n• Die wichtigsten Sehenswürdigkeiten kompakt geplant\n• Restaurant- und Café-Empfehlungen\n• Persönliche Tipps & versteckte Highlights\n• Ein erprobter 48-Stunden-Reiseplan\n\nMit Liebe erlebt und zusammengestellt von MamaTochterOnTour ❤️\n\nDamit eure Reise nach Rom unvergesslich wird.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FRom48.png?alt=media&token=a424ebbb-ff62-443a-b173-aa5744c690f0',
    tab: 2,
    rcProductId: 'Rom48',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FRom48Stunden.pdf?alt=media&token=12fe4854-2bd9-4c37-b474-4902b121817f',
    categories: ['beliebt', 'italien'],
  ),
  Product(
    id: 'guide_13',
    name: '🛳️ Kreuzfahrt - Norwegens Fjorde ab Hamburg',
    price: 16.99,
    description:
        'Diese Kreuzfahrt ist eine Reise durch eine der eindrucksvollsten Naturlandschaften Europas. Zwischen tiefen Fjorden, Wasserfällen und kleinen Hafenstädten erlebst du Norwegen von seiner schönsten Seite.\n\nStatt einfacher Routendaten bekommst du eine übersichtliche und praktische Aufbereitung aller Stopps – mit Tipps für Landgänge, Naturerlebnisse und die besten Aussichtspunkte entlang der Fjorde.\n\nOb spektakuläre Landschaften, ruhige Küstenorte oder beeindruckende Naturkulissen – diese Kreuzfahrt steht für echte Ruhe und unvergessliche Ausblicke.\n\nPerfekt für alle, die Natur, Weite und besondere Landschaften lieben.\n\nHäfen & Stopps:\n- Hamburg (Start / Ziel)\n- Bergen\n- Geirangerfjord\n- Molde\n- Åndalsnes\n- Trondheim\n- Ålesund\n- Måløy\n- Flåm\n- Eidfjord\n- Stavanger',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FNorwegensFjordeThumbnail.png?alt=media&token=accbf4c8-f23b-49cb-a460-f5fe014f45ea',
    tab: 2,
    rcProductId: 'NorwegenKreuzfahrt',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FNorwegenGuide.pdf?alt=media&token=a16faa15-4019-4ed9-8853-9192e487a3a0',
    categories: ['beliebt', 'aida'],
  ),
  Product(
    id: 'guide_14',
    name: '🛳️ Kreuzfahrt - Karibische Inseln ab Dom. Republik',
    price: 18.99,
    description:
        'Diese Kreuzfahrt ist weit mehr als nur eine klassische Schiffsreise durch die Karibik. Sie verbindet einige der schönsten Inseln der Region mit türkisblauem Wasser, weißen Sandstränden und einzigartigen Natur- und Kulturerlebnissen.\n\nStatt oberflächlicher Reiseinfos bekommst du eine klare, strukturierte Übersicht über jede Station deiner Route – kombiniert mit echten Ausflugstipps, Strand-Highlights und praktischen Hinweisen für unvergessliche Landgänge in der Karibik.\n\nOb tropische Strände, bunte Inselkulturen, Schnorchelabenteuer oder entspannte Hafenstädte – diese Kreuzfahrt zeigt dir die Karibik auf eine intensive und gleichzeitig entspannte Art.\n\nPerfekt für alle, die viele Inseln in kurzer Zeit erleben wollen, ohne selbst jede Route oder jeden Ausflug planen zu müssen.\n\nHäfen & Ausflüge:\n- La Romana (Start / Ziel)\n- Aruba\n- Curaçao\n- Bonaire\n- Grenada\n- Barbados\n- Saint Vincent\n- Saint Lucia\n- Dominica\n- Guadeloupe\n- Antigua',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FKaribikThumbnail.png?alt=media&token=f776984a-b5bb-4d35-a79c-f12b8ade68ee',
    tab: 2,
    rcProductId: 'KaribikKreuzfahrt',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FKaribikGuide.pdf?alt=media&token=b078afb6-b823-44e0-9383-3c9a7955b0f3',
    categories: ['beliebt', 'aida'],
  ),
  Product(
    id: 'guide_15',
    name: '✨ Ajaccio Insider Guide',
    price: 4.99,
    description:
        'Ajaccio ist viel mehr als nur Hafen, Altstadt und mediterrane Kulisse auf Korsika. Dieser Guide zeigt dir die Stadt so, wie sie wirklich erlebt werden kann – mit echten Lieblingsorten, besonderen Aussichtspunkten, versteckten Ecken und persönlichen Empfehlungen.\n\nStatt oberflächlicher Tipps bekommst du eine klare, strukturierte Übersicht über die wichtigsten Sehenswürdigkeiten, Strände, Cafés und praktischen Reisetipps für deinen Aufenthalt in der korsischen Hauptstadt.\n\nOb Napoleon-Geschichte, türkisblaues Meer, kleine Gassen oder entspannte Strandmomente – dieser Guide hilft dir dabei, Ajaccio stressfrei, authentisch und intensiver zu entdecken.\n\nPerfekt für alle, die nicht nur kurz anlegen oder durchlaufen wollen, sondern Ajaccio wirklich erleben möchten.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FAjaccioThumbnail.png?alt=media&token=9171e699-85fe-4c33-b963-baa90d1892ba',
    tab: 2,
    rcProductId: 'AjaccioGuide',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FAjaccioGuide.pdf?alt=media&token=f10f0b2e-e6c1-4dac-9914-85e5060c6f83',
    categories: ['frankreich'],
  ),
  Product(
    id: 'guide_16',
    name: '✨ Rom Insider Guide',
    price: 4.99,
    description:
        'Rom ist viel mehr als Kolosseum, Vatikan und Trevi-Brunnen. Dieser Guide zeigt dir die Stadt so, wie wir sie erleben – mit echten Lieblingsorten, besonderen Highlights, versteckten Ecken und persönlichen Empfehlungen.\n\nStatt oberflächlicher Tipps bekommst du eine klare, strukturierte Übersicht über die wichtigsten Sehenswürdigkeiten, authentische Viertel, Cafés, Restaurants und praktische Reisetipps für deinen Aufenthalt.\n\nOb antike Geschichte, italienisches Lebensgefühl, lebendige Piazzas oder kulinarische Highlights – dieser Guide hilft dir dabei, Rom stressfrei, authentisch und intensiver zu entdecken.\n\nPerfekt für alle, die nicht einfach nur durch Rom laufen, sondern die Stadt wirklich erleben wollen.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FRomThumbnail.png?alt=media&token=899fcb7a-377c-4adc-bdbe-ccc516e1de1d',
    tab: 2,
    rcProductId: 'RomGuide',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FRomGuide.pdf?alt=media&token=da5fc0f2-f1c7-47f1-8bed-a52307ce653e',
    categories: ['italien'],
  ),
  Product(
    id: 'guide_17',
    name: '✨ Barcelona Insider Guide',
    price: 4.99,
    description:
        'Barcelona ist viel mehr als nur Sagrada Família, Strand und Tapas. Dieser Guide zeigt dir die Stadt so, wie wir sie erleben – mit echten Lieblingsorten, besonderen Highlights, versteckten Ecken und persönlichen Empfehlungen.\n\nStatt oberflächlicher Tipps bekommst du eine klare, strukturierte Übersicht über die wichtigsten Sehenswürdigkeiten, Viertel, Cafés, Restaurants und praktischen Reisetipps für deinen Aufenthalt.\n\nOb Gaudí-Architektur, das Gotische Viertel, Strandspaziergänge oder das pulsierende Nachtleben – dieser Guide hilft dir dabei, Barcelona stressfrei, authentisch und intensiver zu entdecken.\n\nPerfekt für alle, die nicht einfach nur durch Barcelona laufen, sondern die Stadt wirklich erleben wollen.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FBarcelonaThumbnail.png?alt=media&token=d2ff9fb4-d093-40cc-9078-7e02abdc6bdc',
    tab: 2,
    rcProductId: 'BarcelonaGuide',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FBarcelonaGuide.pdf?alt=media&token=cd904a3c-5b4c-4025-acc3-861daf5a8a4c',
    categories: ['spanien'],
  ),
  Product(
    id: 'guide_18',
    name: '✨ London Insider Guide',
    price: 4.99,
    description:
        'London ist viel mehr als Big Ben, rote Busse und der Buckingham Palace. Dieser Guide zeigt dir die Stadt so, wie wir sie erleben – mit echten Lieblingsorten, besonderen Highlights, versteckten Ecken und persönlichen Empfehlungen.\n\nStatt oberflächlicher Tipps bekommst du eine klare, strukturierte Übersicht über die wichtigsten Sehenswürdigkeiten, Insider-Spots, Cafés, Pubs und praktischen Reisetipps für deinen Aufenthalt.\n\nOb historische Viertel, moderne Architektur, Streetlife in Soho oder entspannte Parks – dieser Guide hilft dir dabei, London stressfrei, authentisch und intensiver zu entdecken.\n\nPerfekt für alle, die nicht einfach nur durch London laufen, sondern die Stadt wirklich erleben wollen.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FLondonThumbnail.png?alt=media&token=cb3b0c10-731a-4fb0-b9c6-ba403b17dbb7',
    tab: 2,
    rcProductId: 'LondonGuide',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FLondonGuide.pdf?alt=media&token=1ec36592-ec2c-4857-a928-b9f820d4c834',
    categories: ['vereinigteskönigreich'],
  ),
  Product(
    id: 'guide_19',
    name: '✨ Wien Insider Guide',
    price: 4.99,
    description:
        'Wien ist viel mehr als Kaffeehäuser, Stephansdom und klassische Musik. Dieser Guide zeigt dir die Stadt so, wie wir sie erleben – mit echten Lieblingsorten, besonderen Highlights, versteckten Ecken und persönlichen Empfehlungen.\n\nStatt oberflächlicher Tipps bekommst du eine klare, strukturierte Übersicht über die wichtigsten Sehenswürdigkeiten, Insider-Spots, Cafés, Heurige und praktischen Reisetipps für deinen Aufenthalt.\n\nOb imperiale Architektur, gemütliche Kaffeehauskultur, moderne Viertel oder entspannte Parks – dieser Guide hilft dir dabei, Wien stressfrei, authentisch und intensiver zu entdecken.\n\nPerfekt für alle, die nicht einfach nur durch Wien laufen, sondern die Stadt wirklich erleben wollen.',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/guides_bilder%2FWienThumbnail.png?alt=media&token=d77e3522-a2bf-41ae-bb3d-f77d1d823f35',
    tab: 2,
    rcProductId: 'WienGuide',
    pdfUrl:
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/travel_guides%2FWienGuide.pdf?alt=media&token=42c389ff-bf2a-4e71-9110-302a139677ef',
    categories: ['oesterreich'],
  ),
];
