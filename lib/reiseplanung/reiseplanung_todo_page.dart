import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/dark_mode_provider.dart';
import 'package:flutter/services.dart';
import '../providers/premium_provider.dart';
import '../pages/premium_verwalten_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../l10n/s.dart';

class TodoPage extends ConsumerStatefulWidget {
  final String tripId;
  const TodoPage({super.key, required this.tripId});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _todos = [];
  List<TextEditingController> _controllers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todosRef = _firestore
        .collection('trips')
        .doc(widget.tripId)
        .collection('todos');

    final snapshot = await todosRef.orderBy('createdAt').get();

    _todos = snapshot.docs
        .map(
          (doc) => {
            'id': doc.id,
            'title': doc.data()['title'] ?? '',
            'done': doc.data()['done'] ?? false,
          },
        )
        .toList();

    // Falls noch kein Dokument existiert, erstelle das erste
    if (_todos.isEmpty) {
      final docRef = todosRef.doc();
      await docRef.set({
        'title': '',
        'done': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _todos.add({'id': docRef.id, 'title': '', 'done': false});
    }

    // Controller parallel zu Todos
    _controllers = _todos
        .map((todo) => TextEditingController(text: todo['title']))
        .toList();

    if (!mounted) return;
    setState(() {
      _loading = false;
    });
  }

  void _addTodo() {
    final isPremiumAsync = ref.watch(premiumProvider);
    final strings = S.of(context)!;

    isPremiumAsync.when(
      data: (isPremium) {
        if (!isPremium && _todos.length >= 5) {
          final snackBar = SnackBar(
            content: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PremiumPage(
                      uid: FirebaseAuth.instance.currentUser!.uid,
                    ),
                  ),
                );
              },
              child: Text(strings.premiumTodoLimit),
            ),
            backgroundColor: const Color(0xFF7B4DE8),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }

        setState(() {
          _todos.add({'id': null, 'title': '', 'done': false});
          _controllers.add(TextEditingController(text: ''));
        });
      },
      loading: () {},
      error: (err, stack) =>
          debugPrint(strings.premiumCheckError(err.toString())),
    );
  }

  Future<void> _saveTodos() async {
    final strings = S.of(context)!;
    final todosRef = _firestore
        .collection('trips')
        .doc(widget.tripId)
        .collection('todos');

    for (int i = 0; i < _todos.length; i++) {
      final todo = _todos[i];
      final controller = _controllers[i];
      final title = controller.text;

      if (todo['id'] == null) {
        // Neues Dokument anlegen
        final docRef = todosRef.doc();
        await docRef.set({
          'title': title,
          'done': todo['done'] ?? false,
          'createdAt': FieldValue.serverTimestamp(),
        });
        todo['id'] = docRef.id;
      } else {
        // Bestehendes Dokument updaten
        await todosRef.doc(todo['id']).update({
          'title': title,
          'done': todo['done'] ?? false,
        });
      }

      // Local synchronisieren
      todo['title'] = title;
    }
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(strings.todosSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref
        .watch(darkModeProvider)
        .maybeWhen(data: (v) => v, orElse: () => false);

    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final strings = S.of(context)!;

    final total = _todos.length;
    final completed = _todos.where((e) => e['done'] == true).length;
    final progress = total == 0 ? 0.0 : completed / total;

    return Scaffold(
      backgroundColor: bgColor,

      // ================= APP BAR =================
      appBar: AppBar(
        title: Text(
          strings.todoTitle,
          style: GoogleFonts.pacifico(color: textColor, fontSize: 28),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () async {
            await _saveTodos();
            if (mounted) Navigator.pop(context);
          },
        ),
      ),

      // ================= BODY =================
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ================= PROGRESS HEADER =================
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey.shade900
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vor der Reise erledigen",
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "$completed von $total erledigt",
                        style: TextStyle(color: textColor),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF8C77FF),
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= LIST =================
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: _todos.length,
                      itemBuilder: (context, index) {
                        final todo = _todos[index];
                        final controller = _controllers[index];
                        final isLastItem = index == _todos.length - 1;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),

                          child: Dismissible(
                            key: Key(todo['id'] ?? index.toString()),
                            direction: DismissDirection.endToStart,

                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),

                            onDismissed: (_) async {
                              if (todo['id'] != null) {
                                await _firestore
                                    .collection('trips')
                                    .doc(widget.tripId)
                                    .collection('todos')
                                    .doc(todo['id'])
                                    .delete();
                              }

                              setState(() {
                                _todos.removeAt(index);
                                _controllers.removeAt(index);
                              });
                            },

                            child: Row(
                              children: [
                                // ===== CHECKBOX =====
                                Checkbox(
                                  value: todo['done'] ?? false,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  fillColor:
                                      WidgetStateProperty.resolveWith<Color>((
                                        states,
                                      ) {
                                        if (states.contains(
                                          WidgetState.selected,
                                        )) {
                                          return const Color(0xFF8C77FF);
                                        }
                                        return isDarkMode
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade200;
                                      }),
                                  onChanged: (v) async {
                                    setState(() {
                                      todo['done'] = v;
                                    });

                                    await _saveTodos();
                                  },
                                ),

                                // ===== TEXT =====
                                Expanded(
                                  child: TextField(
                                    controller: controller,
                                    style: TextStyle(color: textColor),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: strings.todoHint,
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(30),
                                    ],
                                    onChanged: (val) {
                                      todo['title'] = val;
                                    },
                                  ),
                                ),

                                // ===== ADD BUTTON =====
                                if (isLastItem)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.deepPurple,
                                    ),
                                    onPressed: _addTodo,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
