import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dark_mode_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/premium_provider.dart';
import '../pages/premium_verwalten_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../l10n/s.dart';

class TripContactsPage extends ConsumerStatefulWidget {
  final String tripId;

  const TripContactsPage({super.key, required this.tripId});

  @override
  ConsumerState<TripContactsPage> createState() => _TripContactsPageState();
}

class _TripContactsPageState extends ConsumerState<TripContactsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedFilter = 'Alle'; // Dropdown-Filter, standardmäßig Alle

  // Kategorien für Kontakte
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Notfall', 'icon': Icons.warning, 'color': Colors.redAccent},
    {'name': 'Hotel', 'icon': Icons.hotel, 'color': Colors.deepPurple},
    {'name': 'Privat', 'icon': Icons.person, 'color': Colors.blue},
    {'name': 'Sonstiges', 'icon': Icons.contact_page, 'color': Colors.grey},
  ];

  String? _selectedCategory; // für Add/Edit Dialog

  Future<void> _callPhoneNumber(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    final strings = S.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(strings.callFailed)));
    }
  }

  Future<void> _confirmDelete(String contactId) async {
    final strings = S.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.deleteContactTitle),
        content: Text(strings.deleteContactConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              strings.deleteButton,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _firestore
          .collection('trips')
          .doc(widget.tripId)
          .collection('contacts')
          .doc(contactId)
          .delete();
    }
  }

  // ---------------- Kontakt erstellen ----------------
  Future<void> _addContactBottomSheet(bool isDark) async {
    _nameController.clear();
    _phoneController.clear();
    _selectedCategory = null;

    // Premium prüfen
    final isPremiumAsync = ref.watch(premiumProvider);
    final strings = S.of(context)!;

    isPremiumAsync.when(
      data: (isPremium) async {
        // Limit prüfen nur für Nicht-Premium-User
        if (!isPremium) {
          final snapshot = await _firestore
              .collection('trips')
              .doc(widget.tripId)
              .collection('contacts')
              .get();

          if (snapshot.docs.length >= 2) {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: GestureDetector(
                  onTap: () {
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid == null) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PremiumPage(uid: uid)),
                    );
                  },
                  child: const Text(
                    "Nicht-Premium-User können nur 2 Kontakte erstellen. Tippe hier, um Premium freizuschalten!",
                  ),
                ),
                backgroundColor: const Color(0xFF7B4DE8),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
            return; // BottomSheet nicht öffnen
          }
        }

        // BottomSheet öffnen
        if (!mounted) return;
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            String? errorText;

            return StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          strings.newContact,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: strings.nameLabel,
                            labelStyle: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: strings.phoneLabel,
                            labelStyle: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: strings.categoryLabel,
                            labelStyle: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          items: _categories.map<DropdownMenuItem<String>>((
                            cat,
                          ) {
                            return DropdownMenuItem<String>(
                              value: cat['name'] as String,
                              child: Row(
                                children: [
                                  Icon(
                                    cat['icon'] as IconData,
                                    color: cat['color'] as Color,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    cat['name'] as String,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) => setModalState(() {
                            _selectedCategory = val;
                            errorText = null;
                          }),
                        ),
                        if (errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              errorText!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(strings.cancelButton),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                              ),
                              onPressed: () async {
                                if (_nameController.text.trim().isEmpty ||
                                    _phoneController.text.trim().isEmpty ||
                                    _selectedCategory == null) {
                                  setModalState(() {
                                    errorText = strings.fillAllFieldsError;
                                  });
                                  return;
                                }

                                await _firestore
                                    .collection('trips')
                                    .doc(widget.tripId)
                                    .collection('contacts')
                                    .add({
                                      'name': _nameController.text.trim(),
                                      'phone': _phoneController.text.trim(),
                                      'category': _selectedCategory!,
                                      'createdAt': FieldValue.serverTimestamp(),
                                    });

                                if (!context.mounted) return;

                                Navigator.pop(context);
                              },
                              child: Text(
                                strings.saveButton,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () {},
      error: (err, stack) => debugPrint("Premium Error: $err"),
    );
  }

  // ---------------- Kontakt bearbeiten ----------------
  Future<void> _editContactBottomSheet(
    String contactId,
    Map<String, dynamic> data,
    bool isDark,
  ) async {
    _nameController.text = data['name'] ?? '';
    _phoneController.text = data['phone'] ?? '';
    _selectedCategory = data['category'] ?? 'Sonstiges';
    final strings = S.of(context)!;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String? errorText;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      strings.editContact,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Name
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: strings.nameLabel,
                        labelStyle: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Telefon
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: strings.phoneLabel,
                        labelStyle: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 8),
                    // Kategorie Dropdown
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: strings.categoryLabel,
                        labelStyle: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      items: _categories.map<DropdownMenuItem<String>>((cat) {
                        return DropdownMenuItem<String>(
                          value: cat['name'] as String,
                          child: Row(
                            children: [
                              Icon(
                                cat['icon'] as IconData,
                                color: cat['color'] as Color,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                cat['name'] as String,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setModalState(() {
                        _selectedCategory = val;
                        errorText = null;
                      }),
                    ),
                    if (errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          errorText!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Speicher-Button zentriert mit Abstand darunter
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
                            onPressed: () async {
                              if (_nameController.text.trim().isEmpty ||
                                  _phoneController.text.trim().isEmpty ||
                                  _selectedCategory == null) {
                                setModalState(() {
                                  errorText = strings.fillAllFieldsError;
                                });
                                return;
                              }

                              await _firestore
                                  .collection('trips')
                                  .doc(widget.tripId)
                                  .collection('contacts')
                                  .doc(contactId)
                                  .update({
                                    'name': _nameController.text.trim(),
                                    'phone': _phoneController.text.trim(),
                                    'category': _selectedCategory!,
                                  });

                              if (!context.mounted) return;

                              Navigator.pop(context);
                            },
                            child: Text(
                              strings.saveButton,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ), // kleiner Freiraum unter dem Button
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkModeAsync = ref.watch(darkModeProvider);
    final strings = S.of(context)!;

    return darkModeAsync.when(
      data: (isDark) {
        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              strings.tripContactsTitle,
              style: GoogleFonts.pacifico(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 28,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: Colors.deepPurple),
                onPressed: () =>
                    _addContactBottomSheet(isDark), // <-- hier ändern
              ),
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('trips')
                .doc(widget.tripId)
                .collection('contacts')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    strings.emptyContactsPlaceholder,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                );
              }

              final contacts = snapshot.data!.docs;

              // Filter anwenden
              final filteredContacts = _selectedFilter == strings.allFilter
                  ? contacts
                  : contacts.where((c) {
                      final data = c.data()! as Map<String, dynamic>;
                      return data['category'] == _selectedFilter;
                    }).toList();

              return Column(
                children: [
                  const SizedBox(height: 12),
                  // Filterleiste
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // Rechts ausrichten
                      children: [
                        DropdownButton<String>(
                          value: _selectedFilter,
                          dropdownColor: isDark
                              ? Colors.grey[900]
                              : Colors.white,
                          underline: const SizedBox(), // Unterlinie entfernen
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'Alle',
                              child: Text(strings.allFilter),
                            ),
                            ..._categories.map(
                              (c) => DropdownMenuItem(
                                value: c['name'] as String,
                                child: Row(
                                  children: [
                                    Icon(
                                      c['icon'] as IconData,
                                      color: c['color'] as Color,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(c['name'] as String),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedFilter = val);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];
                        final data = contact.data()! as Map<String, dynamic>;
                        final cat = _categories.firstWhere(
                          (c) =>
                              c['name'] ==
                              (data['category'] ?? strings.otherCategory),
                        );

                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) {
                                return SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.call),
                                        title: Text(strings.callAction),
                                        onTap: () {
                                          Navigator.pop(context);
                                          final phone = data['phone'] ?? '';
                                          if (phone.isNotEmpty) {
                                            _callPhoneNumber(phone);
                                          }
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.edit),
                                        title: Text(strings.editAction),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _editContactBottomSheet(
                                            contact.id,
                                            data,
                                            isDark,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: Text(
                                          strings.deleteAction,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          await _confirmDelete(contact.id);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[850] : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withValues(alpha: 0.3)
                                      : Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(cat['icon'], color: cat['color']),
                                    const SizedBox(width: 8),
                                    Text(
                                      data['name'] ?? strings.unknownContact,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${data['phone'] ?? ''}",
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[700],
                                  ),
                                ),
                                if (data['emergency'] == true)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      strings.emergencyContact,
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text("Fehler: $err"))),
    );
  }
}
