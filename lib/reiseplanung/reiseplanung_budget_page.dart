import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

// Wichtig:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dark_mode_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/premium_verwalten_page.dart';
import '../pages/main_navigation.dart';
import '../providers/premium_provider.dart';
import '../../l10n/s.dart';

class BudgetPage extends ConsumerStatefulWidget {
  final String userId;
  final String tripId;

  const BudgetPage({super.key, required this.userId, required this.tripId});

  @override
  ConsumerState<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends ConsumerState<BudgetPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _categories = [];
  double _totalSaved = 0;
  double _totalTarget = 0;

  bool _isLoading = true;

  /// Für eingeklappt/ausgeklappt pro Kategorie
  final Set<String> _expandedCategories = {};

  // 🔒 SAFE-CONVERT-FUNKTION
  double toDouble(dynamic value) {
    if (value == null) return 0.0;
    return (value as num).toDouble();
  }

  @override
  void initState() {
    super.initState();
    _loadBudgetData();
  }

  // ---------------- KATEGORIE LÖSCHEN ----------------
  Future<void> _deleteCategory(String id) async {
    try {
      // Firestore-Dokument löschen
      await _firestore
          .collection('trips')
          .doc(widget.tripId)
          .collection('budget')
          .doc(id)
          .delete();

      // Lokal aktualisieren
      _categories.removeWhere((c) => c['id'] == id);

      setState(() {});

      // Daten neu laden
      _loadBudgetData();
    } catch (e) {
      debugPrint('Fehler beim Löschen der Kategorie: $e');
    }
  }

  // ---------------- LOAD ----------------
  Future<void> _loadBudgetData() async {
    try {
      final snapshot = await _firestore
          .collection('trips')
          .doc(widget.tripId)
          .collection('budget')
          .get();

      final loaded = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // sicherstellen, dass ID vorhanden ist
        return data;
      }).toList();

      double saved = 0;
      double target = 0;

      for (var cat in loaded) {
        saved += toDouble(cat['spent']);
        target += toDouble(cat['target']);
      }

      if (!mounted) return;
      setState(() {
        _categories = loaded;
        _totalSaved = saved;
        _totalTarget = target;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Budget Fehler: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  // ---------------- EINZAHLUNG HINZUFÜGEN ----------------
  Future<void> _addAmountToCategory(Map<String, dynamic> category) async {
    final controller = TextEditingController();
    final strings = S.of(context)!;

    final amount = await showDialog<double>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          (strings.addAmountDialogTitle as String).replaceFirst(
            "{category}",
            category['title'],
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: strings.amountLabel,
            suffixText: '€',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancelButton),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, double.tryParse(controller.text)),
            child: Text(strings.addButton),
          ),
        ],
      ),
    );

    if (amount == null || amount <= 0) return;

    final spent = toDouble(category['spent']);
    final target = toDouble(category['target']);
    final newSpent = spent + amount;

    if (target > 0 && newSpent > target) {
      final diff = newSpent - target;
      if (mounted) {
        // 🔹 Prüfen, ob Widget noch existiert
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(strings.goalExceededMessage(diff.toStringAsFixed(0))),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }

    category['spent'] = newSpent;
    category['history'] ??= [];
    category['history'].add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'amount': amount,
      'createdAt': DateTime.now().toIso8601String(),
    });

    await _firestore
        .collection('trips')
        .doc(widget.tripId)
        .collection('budget')
        .doc(category['id'])
        .update({'spent': newSpent, 'history': category['history']});

    _loadBudgetData();
  }

  // ---------------- HISTORY BEARBEITEN ----------------
  Future<void> _editHistory(
    Map<String, dynamic> category,
    Map<String, dynamic> entry,
  ) async {
    final controller = TextEditingController(text: entry['amount'].toString());

    final strings = S.of(context)!;
    final newAmount = await showDialog<double>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.editDepositTitle),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: strings.amountLabel,
            suffixText: '€',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancelButton),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, double.tryParse(controller.text)),
            child: Text(strings.saveButton),
          ),
        ],
      ),
    );

    if (newAmount == null || newAmount <= 0) return;

    final oldAmount = toDouble(entry['amount']);
    entry['amount'] = newAmount;

    category['spent'] = toDouble(category['spent']) - oldAmount + newAmount;

    await _firestore
        .collection('trips')
        .doc(widget.tripId)
        .collection('budget')
        .doc(category['id'])
        .update({'spent': category['spent'], 'history': category['history']});

    _loadBudgetData();
  }

  // ---------------- HISTORY LÖSCHEN ----------------
  Future<void> _deleteHistory(
    Map<String, dynamic> category,
    Map<String, dynamic> entry,
  ) async {
    category['history'].remove(entry);
    category['spent'] = max(
      0,
      toDouble(category['spent']) - toDouble(entry['amount']),
    );

    await _firestore
        .collection('trips')
        .doc(widget.tripId)
        .collection('budget')
        .doc(category['id'])
        .update({'spent': category['spent'], 'history': category['history']});

    _loadBudgetData();
  }

  // ---------------- BUDGET CATEGORY ERSTELLEN ----------------
  Future<void> _openBudgetBottomSheet(bool isDarkMode) async {
    final isPremiumAsync = ref.watch(premiumProvider);
    final strings = S.of(context)!;

    isPremiumAsync.when(
      data: (isPremium) async {
        final snapshot = await _firestore
            .collection('trips')
            .doc(widget.tripId)
            .collection('budget')
            .get();

        final categories = snapshot.docs.map((doc) => doc.data()).toList();

        if (!isPremium && categories.length >= 2) {
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
                child: Text(strings.premiumLimitMessage),
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
          return;
        }

        if (!mounted) return;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => AddBudgetCategorySheet(
            isDarkMode: isDarkMode,
            userId: widget.userId,
            tripId: widget.tripId,
            isPremium: isPremium,
            onSave: _loadBudgetData,
          ),
        );
      },
      loading: () {
        // Optional: Ladeindikator oder nichts tun
      },
      error: (err, stack) {
        debugPrint("Fehler beim Prüfen von Premium: $err");
      },
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider).value ?? false;
    final strings = S.of(context)!;

    final bg = isDarkMode ? Colors.black : Colors.white;
    final text = isDarkMode ? Colors.white : Colors.black;

    final progress = _totalTarget > 0
        ? min(_totalSaved / _totalTarget, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: text,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const MainNavigationPage(initialProfileTab: 2),
              ),
              (route) => false, // löscht den bisherigen Stack
            );
          },
        ),
        title: Text(
          strings.budgetTitle,
          style: GoogleFonts.pacifico(fontSize: 26, color: text),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12, top: 6),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD9CFFF).withAlpha((0.85 * 255).round()),
            ),
            child: IconButton(
              iconSize: 26,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.add),
              color: Colors.white,
              onPressed: () => _openBudgetBottomSheet(isDarkMode),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  strings.noBudgetCreated,
                  style: TextStyle(color: text, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Container(
              color: bg,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircularPercentIndicator(
                    radius: 90,
                    lineWidth: 14,
                    percent: progress,
                    center: Text(
                      "${(progress * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        color: text,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    progressColor: Colors.deepPurple,
                    backgroundColor: Colors.grey.withAlpha((0.3 * 255).toInt()),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "€${_totalSaved.toStringAsFixed(0)} / €${_totalTarget.toStringAsFixed(0)}",
                    style: TextStyle(color: text),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final double spent = toDouble(cat['spent']);
                        final double target = toDouble(cat['target']);
                        final double catProgress = target > 0
                            ? (spent / target).clamp(0.0, 1.0)
                            : 0.0;

                        final history = (cat['history'] ?? [])
                            .cast<Map<String, dynamic>>();
                        final expanded = _expandedCategories.contains(
                          cat['id'],
                        );

                        return Card(
                          color: isDarkMode
                              ? Colors.grey[850]
                              : Colors.grey[200],
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        cat['title'],
                                        style: TextStyle(
                                          color: text,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      color: Colors.deepPurple,
                                      onPressed: () =>
                                          _addAmountToCategory(cat),
                                    ),
                                    PopupMenuButton(
                                      onSelected: (_) =>
                                          _deleteCategory(cat['id']),
                                      itemBuilder: (_) => [
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text(strings.deleteMenuItem),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  "€${spent.toStringAsFixed(0)} / €${target.toStringAsFixed(0)}",
                                  style: TextStyle(
                                    color: text.withAlpha((0.7 * 255).toInt()),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                LinearProgressIndicator(
                                  value: catProgress,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey.withAlpha(
                                    (0.3 * 255).toInt(),
                                  ),
                                  valueColor: const AlwaysStoppedAnimation(
                                    Colors.deepPurple,
                                  ),
                                ),
                                if (spent > target)
                                  Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Text(
                                      strings.goalExceeded,
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 5),
                                if (history.isNotEmpty) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center, // bündig
                                    children: [
                                      Text(
                                        strings.depositsLabel,
                                        style: TextStyle(
                                          color: text,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (history.length > 1)
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          iconSize: 20,
                                          icon: Icon(
                                            expanded
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              expanded
                                                  ? _expandedCategories.remove(
                                                      cat['id'],
                                                    )
                                                  : _expandedCategories.add(
                                                      cat['id'],
                                                    );
                                            });
                                          },
                                        ),
                                    ],
                                  ),
                                  // erste Einzahlung direkt darunter
                                  _HistoryItem(
                                    entry: history.last,
                                    text: text,
                                    onEdit: () =>
                                        _editHistory(cat, history.last),
                                    onDelete: () =>
                                        _deleteHistory(cat, history.last),
                                  ),
                                  // ausgeklappte weiteren Einzahlungen
                                  if (expanded && history.length > 1)
                                    Column(
                                      children: [
                                        for (var h in history.reversed.skip(1))
                                          _HistoryItem(
                                            entry: h,
                                            text: text,
                                            onEdit: () => _editHistory(cat, h),
                                            onDelete: () =>
                                                _deleteHistory(cat, h),
                                          ),
                                      ],
                                    ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final Map<String, dynamic> entry;
  final Color text;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _HistoryItem({
    required this.entry,
    required this.text,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(entry['createdAt']);
    final strings = S.of(context)!;

    return GestureDetector(
      onLongPress: () async {
        final action = await showModalBottomSheet<String>(
          context: context,
          builder: (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text(strings.editMenuItem),
                onTap: () => Navigator.pop(context, 'edit'),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(strings.deleteMenuItem),
                onTap: () => Navigator.pop(context, 'delete'),
              ),
            ],
          ),
        );

        if (action == 'edit') onEdit();
        if (action == 'delete') onDelete();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          "+ €${entry['amount']} • ${date.day}.${date.month}.${date.year}",
          style: TextStyle(
            color: text.withAlpha((0.7 * 255).toInt()),
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class AddBudgetCategorySheet extends StatefulWidget {
  final bool isDarkMode;
  final String userId;
  final String tripId;
  final bool isPremium;
  final VoidCallback onSave;

  const AddBudgetCategorySheet({
    super.key,
    required this.isDarkMode,
    required this.tripId,
    required this.userId,
    required this.isPremium,
    required this.onSave,
  });

  @override
  State<AddBudgetCategorySheet> createState() => _AddBudgetCategorySheetState();
}

class _AddBudgetCategorySheetState extends State<AddBudgetCategorySheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

  bool isSaving = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveCategory() async {
    final title = _titleController.text.trim();
    final target = double.tryParse(_targetController.text.trim());
    final strings = S.of(context)!;

    if (title.isEmpty || target == null || target <= 0) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(strings.invalidInputTitle),
          content: Text(strings.invalidInputMessage),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (mounted) Navigator.pop(dialogContext);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    if (!mounted) return;
    setState(() => isSaving = true);

    final categoryId = DateTime.now().millisecondsSinceEpoch.toString();

    // 1️⃣ Premium-Limit prüfen
    final snapshot = await _firestore
        .collection('trips')
        .doc(widget.tripId)
        .collection('budget')
        .get();

    final categories = snapshot.docs.map((doc) => doc.data()).toList();

    if (!widget.isPremium && categories.length >= 2) {
      if (!mounted) return;

      setState(() => isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.premiumLimitMessage),
          backgroundColor: Colors.deepPurple,
        ),
      );
      return;
    }

    // 2️⃣ Neue Kategorie erstellen
    await _firestore
        .collection('trips')
        .doc(widget.tripId)
        .collection('budget')
        .doc(categoryId)
        .set({
          'id': categoryId,
          'title': title,
          'target': target,
          'spent': 0,
          'history': [],
          'createdAt': DateTime.now().toIso8601String(),
        });

    if (!mounted) return;
    setState(() => isSaving = false);

    widget.onSave();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.grey[900] : Colors.white;
    final strings = S.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              strings.addBudgetCategorySheetTitle,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // -------- KATEGORIE --------
            TextField(
              controller: _titleController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: strings.categoryLabel,
                labelStyle: TextStyle(color: textColor),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // -------- BETRAG --------
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: strings.targetAmountLabel,
                prefixText: "€ ",
                labelStyle: TextStyle(color: textColor),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: isSaving ? null : _saveCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8C77FF),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                isSaving ? strings.savingIndicator : strings.addCategoryButton,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
