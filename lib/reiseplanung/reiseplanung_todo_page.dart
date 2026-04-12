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

  Future<void> _updateSingleTodo(int index) async {
    final todo = _todos[index];
    final controller = _controllers[index];

    if (todo['id'] != null) {
      await _firestore
          .collection('trips')
          .doc(widget.tripId)
          .collection('todos')
          .doc(todo['id'])
          .update({'title': controller.text, 'done': todo['done'] ?? false});
      todo['title'] = controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref
        .watch(darkModeProvider)
        .maybeWhen(data: (v) => v, orElse: () => false);

    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final strings = S.of(context)!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          strings.todoTitle,
          style: GoogleFonts.pacifico(color: textColor, fontSize: 28),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.deepPurple),
            onPressed: _saveTodos,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  final controller = _controllers[index];
                  final isLast = index == _todos.length - 1;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {
                          todo['focused'] = hasFocus;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: todo['done'] ?? false,
                            onChanged: (v) async {
                              setState(() {
                                todo['done'] = v;
                              });
                              await _updateSingleTodo(index);
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller, // <-- DAS ist die Lösung
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: strings.todoHint,
                              ),
                              maxLines: 1,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                              onChanged: (val) {
                                todo['title'] = val;
                              },
                            ),
                          ),

                          if (isLast)
                            IconButton(
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: Colors.deepPurple,
                              ),
                              onPressed: _addTodo,
                            ),
                          // Mini-Löschen-Icon nur sichtbar bei Fokus
                          if (todo['focused'] ?? false)
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.redAccent,
                              ),
                              onPressed: () async {
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
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
