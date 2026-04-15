import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/main_navigation.dart';

class UsernameSetupPage extends StatefulWidget {
  final String uid;

  const UsernameSetupPage({super.key, required this.uid});

  @override
  State<UsernameSetupPage> createState() => _UsernameSetupPageState();
}

class _UsernameSetupPageState extends State<UsernameSetupPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool _isChecking = false;
  String? _error;
  bool? _isAvailable;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkUsername(String username) async {
    if (username.length < 3) {
      setState(() {
        _isAvailable = null;
        _error = "Mindestens 3 Zeichen";
      });
      return;
    }

    setState(() {
      _isChecking = true;
      _error = null;
    });

    final query = await _firestore
        .collection('Users')
        .where('username', isEqualTo: username.toLowerCase())
        .limit(1)
        .get();

    setState(() {
      _isChecking = false;
      _isAvailable = query.docs.isEmpty;
      _error = query.docs.isEmpty ? null : "Username ist bereits vergeben";
    });
  }

  Future<void> _saveUsername() async {
    final username = _controller.text.trim().toLowerCase();

    if (username.isEmpty) return;

    setState(() => _isLoading = true);

    final doc = _firestore.collection('Users').doc(widget.uid);

    await doc.set({'username': username}, SetOptions(merge: true));

    setState(() => _isLoading = false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _isAvailable == true;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wähle deinen Username"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              "Dein Username",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "So wirst du in der App gefunden.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _controller,
              onChanged: (value) {
                Future.delayed(const Duration(milliseconds: 400), () {
                  if (_controller.text == value) {
                    _checkUsername(value.trim().toLowerCase());
                  }
                });
              },
              decoration: InputDecoration(
                prefixText: "@",
                labelText: "Username",
                suffixIcon: _isChecking
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        isValid ? Icons.check_circle : Icons.info_outline,
                        color: isValid ? Colors.green : Colors.grey,
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isValid && !_isLoading ? _saveUsername : null,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Weiter"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
