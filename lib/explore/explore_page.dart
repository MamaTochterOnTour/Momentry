import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Explore"),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),

      body: ListView(
        children: [
          // ================= HERO =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8C77FF), Color(0xFFE6E0F8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  "🌍 Entdecke deine nächste Reise",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ================= FEED =================
          _SectionHeader(title: "🔥 Feed für dich"),

          _HorizontalCards(),

          const SizedBox(height: 24),

          // Beispiel Feed Items (vertikal besser später erweitern)
          _FeedCard(
            title: "Rom in 48 Stunden",
            subtitle: "Reiseidee • Italien",
          ),
          _FeedCard(title: "Barcelona Highlights", subtitle: "City Guide"),
          _FeedCard(title: "Norwegen Fjorde", subtitle: "Kreuzfahrt Story"),

          const SizedBox(height: 30),

          // ================= Q&A =================
          _SectionHeader(title: "💬 Fragen & Antworten"),

          _ActionCard(title: "Stelle eine Frage", icon: Icons.edit),

          _ActionCard(
            title: "Beliebte Fragen entdecken",
            icon: Icons.help_outline,
          ),

          const SizedBox(height: 30),

          // ================= PEOPLE =================
          _SectionHeader(title: "👥 Personen entdecken"),

          _HorizontalPeople(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ================= SECTION HEADER =================
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ================= FEED CARD =================
class _FeedCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _FeedCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

// ================= ACTION CARD =================
class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ActionCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE6E0F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF8C77FF)),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ================= PEOPLE =================
class _HorizontalPeople extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person),
                ),
                const SizedBox(height: 6),
                Text(
                  "User",
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ================= HORIZONTAL PLACEHOLDER =================
class _HorizontalCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: List.generate(5, (index) {
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[200],
            ),
            child: const Center(child: Text("Highlight")),
          );
        }),
      ),
    );
  }
}
