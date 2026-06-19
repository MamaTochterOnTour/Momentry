import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/premium_verwalten_page.dart';
import '../../l10n/s.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/premium_provider.dart';
import '../providers/dark_mode_provider.dart';

class PacklisteDetailPage extends ConsumerStatefulWidget {
  final String packlisteId;
  final String userId;
  final String tripId;
  final String title;
  final bool isPremium;
  final VoidCallback onUpdate;

  const PacklisteDetailPage({
    super.key,
    required this.packlisteId,
    required this.userId,
    required this.tripId,
    required this.title,
    required this.isPremium,
    required this.onUpdate,
  });

  @override
  ConsumerState<PacklisteDetailPage> createState() =>
      _PacklisteDetailPageState();
}

class _PacklisteDetailPageState extends ConsumerState<PacklisteDetailPage> {
  late TextEditingController _titleController;
  final Map<String, List<Map<String, dynamic>>> _categorizedItems = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isSaving = false;
  bool _loading = true;
  final Map<String, TextEditingController> _controllers = {};

  DocumentReference get _packlisteRef => _firestore
      .collection('trips')
      .doc(widget.tripId)
      .collection('packlisten')
      .doc(widget.packlisteId);

  CollectionReference get _itemsRef => _packlisteRef.collection('items');

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() => _loading = true);

    try {
      // Packliste laden
      final packlisteDoc = await _packlisteRef.get();
      if (packlisteDoc.exists) {
        final data = packlisteDoc.data() as Map<String, dynamic>;

        _titleController.text = data['title'] ?? widget.title;
      }

      // Items laden
      final itemsSnap = await _itemsRef.get();
      _categorizedItems.clear();

      for (var doc in itemsSnap.docs) {
        final item = doc.data() as Map<String, dynamic>;
        if (!mounted) return;
        final strings = S.of(context)!;
        final cat = (item['category'] as String?)?.isNotEmpty == true
            ? item['category']
            : strings.otherCategory;

        _categorizedItems.putIfAbsent(cat, () => []);
        _categorizedItems[cat]!.add({
          'id': doc.id,
          'name': item['name'] ?? '',
          'completed': item['completed'] ?? false,
          'category': item['category'] ?? cat,
          'quantity': item['quantity'] ?? 1,
        });
      }
    } catch (e) {
      debugPrint("Error loading packing list: $e");
    }

    setState(() => _loading = false);
  }

  Future<void> _saveDetail() async {
    if (!mounted) return;
    setState(() => isSaving = true);

    try {
      // Packliste speichern
      await _packlisteRef.set({
        'title': _titleController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      for (var entry in _categorizedItems.entries) {
        final category = entry.key;

        for (var item in entry.value) {
          String id = item['id'];

          // 🔥 FIX: neue Items haben evtl. keinen echten Firestore-ID
          if (id.startsWith('Instance') || id.length < 10) {
            final newDoc = _itemsRef.doc();
            id = newDoc.id;
            item['id'] = id; // wichtig zurückschreiben!
          }

          await _itemsRef.doc(id).set({
            'name': item['name'] ?? '',
            'completed': item['completed'] ?? false,
            'category': category,
            'quantity': item['quantity'] ?? 1,
          }, SetOptions(merge: true));
        }
      }

      widget.onUpdate();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Error saving: $e");
    }

    if (mounted) {
      setState(() => isSaving = false);
    }
  }

  void _toggleItem(String category, int index, bool? value) {
    setState(() {
      _categorizedItems[category]![index]['completed'] = value ?? false;
    });
  }

  void _addItem({String? category}) {
    final strings = S.of(context)!;
    final cat = category ?? strings.otherCategory;

    final totalItems = _categorizedItems.values.expand((list) => list).length;

    final isPremiumAsync = ref.watch(premiumProvider);

    final isPremium = isPremiumAsync.maybeWhen(
      data: (value) => value,
      loading: () =>
          widget.isPremium, // fallback (oder false, aber besser: widget)
      error: (_, _) => widget.isPremium,
      orElse: () => widget.isPremium,
    );

    if (!isPremium && totalItems >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PremiumPage(uid: widget.userId),
                ),
              );
            },
            child: Text(strings.premiumItemLimit),
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

    if (!_categorizedItems.containsKey(cat)) _categorizedItems[cat] = [];
    setState(() {
      _categorizedItems[cat]!.add({
        'id': UniqueKey().toString(),
        'name': '',
        'completed': false,
        'category': cat,
        'quantity': 1,
      });
    });
  }

  void _removeItem(String category, int index) async {
    final item = _categorizedItems[category]![index];
    final id = item['id'];

    if (id != null) {
      await _itemsRef.doc(id).delete();
    }

    setState(() {
      _categorizedItems[category]!.removeAt(index);
    });
  }

  void _addCategory() async {
    final strings = S.of(context)!;
    final totalCategories = _categorizedItems.keys
        .where((key) => key != strings.otherCategory)
        .length;

    final isPremiumAsync = ref.watch(premiumProvider);

    final isPremium = isPremiumAsync.maybeWhen(
      data: (value) => value,
      loading: () => widget.isPremium,
      error: (_, _) => widget.isPremium,
      orElse: () => widget.isPremium,
    );

    if (!isPremium && totalCategories >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PremiumPage(uid: widget.userId),
                ),
              );
            },
            child: Text(strings.premiumCategoryLimit),
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

    final controller = TextEditingController();
    final categoryName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.addCategoryTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: strings.categoryNameHint),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(strings.add),
          ),
        ],
      ),
    );

    if (categoryName != null &&
        categoryName.isNotEmpty &&
        !_categorizedItems.containsKey(categoryName)) {
      setState(() {
        _categorizedItems[categoryName] = [];
        _addItem(category: categoryName);
      });
    }
  }

  void _deleteCategory(String category) async {
    final strings = S.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.deleteCategoryTitle),
        content: Text(strings.deleteCategoryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.no),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(strings.yes),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final batch = _firestore.batch();

      for (var item in _categorizedItems[category] ?? []) {
        final id = item['id'];
        if (id != null) {
          batch.delete(_itemsRef.doc(id));
        }
      }

      batch.commit();

      setState(() {
        _categorizedItems.remove(category);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkModeAsync = ref.watch(darkModeProvider);

    final darkMode = darkModeAsync.maybeWhen(
      data: (v) => v,
      orElse: () => false,
    );
    final strings = S.of(context)!;

    final backgroundColor = darkMode ? Colors.black : Colors.white;
    final appBarColor = darkMode ? Colors.black : Colors.white;

    final textColor = darkMode ? Colors.white : Colors.black;
    final iconColor = darkMode ? Colors.white : Colors.black;

    final completed = _categorizedItems.values
        .expand((l) => l)
        .where((i) => i['completed'] == true)
        .length;

    final totalItems = _categorizedItems.values.expand((l) => l).length;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,

        iconTheme: IconThemeData(color: iconColor),

        title: Text(
          "Packliste",
          textAlign: TextAlign.center,
          style: GoogleFonts.pacifico(fontSize: 24, color: iconColor),
        ),
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: backgroundColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (totalItems > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        completed == totalItems
                            ? strings.packingDoneMessage
                            : strings.packingProgress(completed, totalItems),
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                    ),

                  Expanded(
                    child: ListView(
                      children: _categorizedItems.entries.map((entry) {
                        final category = entry.key;
                        final items = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    category,
                                    style: GoogleFonts.nunito(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ),

                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert, color: iconColor),

                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      final controller = TextEditingController(
                                        text: category,
                                      );

                                      final newName = await showDialog<String>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(strings.editCategory),
                                          content: TextField(
                                            controller: controller,
                                            decoration: InputDecoration(
                                              hintText: strings.newCategoryName,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(strings.cancel),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => Navigator.pop(
                                                context,
                                                controller.text.trim(),
                                              ),
                                              child: Text(strings.save),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (newName != null &&
                                          newName.isNotEmpty &&
                                          newName != category) {
                                        setState(() {
                                          _categorizedItems[newName] =
                                              _categorizedItems[category]!;
                                          _categorizedItems.remove(category);

                                          for (var item
                                              in _categorizedItems[newName]!) {
                                            item['category'] = newName;
                                          }
                                        });
                                      }
                                    } else if (value == 'delete') {
                                      _deleteCategory(category);
                                    }
                                  },

                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text(strings.edit),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text(strings.delete),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            ...List.generate(items.length, (i) {
                              final item = items[i];

                              return Dismissible(
                                key: Key('${category}_$i'),
                                direction: DismissDirection.endToStart,

                                onDismissed: (_) => _removeItem(category, i),

                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),

                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: item['completed'],
                                      onChanged: (v) =>
                                          _toggleItem(category, i, v),

                                      checkColor: Colors.white,

                                      fillColor:
                                          WidgetStateProperty.resolveWith<
                                            Color
                                          >((states) {
                                            if (states.contains(
                                              WidgetState.selected,
                                            )) {
                                              return const Color(0xFF8C77FF);
                                            }
                                            return darkMode
                                                ? Colors.grey[800]!
                                                : Colors.grey[200]!;
                                          }),
                                    ),

                                    SizedBox(
                                      width: 40,
                                      child: TextFormField(
                                        initialValue: '${item['quantity']}x',
                                        keyboardType: TextInputType.number,

                                        onChanged: (v) {
                                          final val =
                                              int.tryParse(
                                                v.replaceAll(
                                                  RegExp(r'[^0-9]'),
                                                  '',
                                                ),
                                              ) ??
                                              1;

                                          setState(() {
                                            _categorizedItems[category]![i]['quantity'] =
                                                val;
                                          });
                                        },

                                        style: TextStyle(color: textColor),

                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),

                                        textAlign: TextAlign.right,
                                      ),
                                    ),

                                    const SizedBox(width: 4),

                                    Expanded(
                                      child: TextField(
                                        controller: _controllers.putIfAbsent(
                                          item['id'],
                                          () => TextEditingController(
                                            text: item['name'] ?? '',
                                          ),
                                        ),

                                        onChanged: (v) {
                                          _categorizedItems[category]![i]['name'] =
                                              v;
                                        },

                                        decoration: InputDecoration(
                                          hintText: strings.itemHint,
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),

                                    IconButton(
                                      icon: Icon(Icons.add, color: iconColor),
                                      onPressed: () =>
                                          _addItem(category: category),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _addItem(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkMode ? Colors.grey[900] : null,
                            foregroundColor: darkMode ? Colors.white : null,
                          ),
                          child: Text(strings.addItem),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _addCategory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkMode ? Colors.grey[900] : null,
                            foregroundColor: darkMode ? Colors.white : null,
                          ),
                          child: Text(strings.addCategory),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: isSaving ? null : _saveDetail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8C77FF),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      isSaving ? strings.saving : strings.saveButton,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
