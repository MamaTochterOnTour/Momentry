import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/s.dart';

class ContactFeedbackPage extends StatefulWidget {
  const ContactFeedbackPage({super.key});

  @override
  State<ContactFeedbackPage> createState() => _ContactFeedbackPageState();
}

class _ContactFeedbackPageState extends State<ContactFeedbackPage>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _improvementController = TextEditingController();
  final _wishesController = TextEditingController();
  final _questionsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _heartAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _improvementController.dispose();
    _wishesController.dispose();
    _questionsController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    final strings = S.of(context)!;

    if (_formKey.currentState!.validate()) {
      if (_improvementController.text.trim().isEmpty &&
          _wishesController.text.trim().isEmpty &&
          _questionsController.text.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.feedbackFillAtLeastOne)));
        return;
      }

      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final improvement = _improvementController.text.trim();
      final wishes = _wishesController.text.trim();
      final questions = _questionsController.text.trim();

      final subject = Uri.encodeComponent("${strings.feedbackSubject} $name");
      final body = Uri.encodeComponent(
        "${strings.feedbackBodyName}: $name\n${strings.feedbackBodyEmail}: $email\n\n${strings.feedbackBodyImprovement}:\n$improvement\n\n${strings.feedbackBodyWishes}:\n$wishes\n\n${strings.feedbackBodyQuestions}:\n$questions",
      );
      final mailUrl = Uri.parse(
        "mailto:mamatochterontour@outlook.de?subject=$subject&body=$body",
      );

      if (await canLaunchUrl(mailUrl)) {
        await launchUrl(mailUrl);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.feedbackCannotOpenEmail)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final boxColor = isDarkMode ? Colors.grey[850]! : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: textColor),
        title: Text(
          strings.feedbackTitle,
          style: GoogleFonts.pacifico(color: textColor, fontSize: 28),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ScaleTransition(
              scale: _heartAnimation,
              child: Icon(Icons.favorite, color: Colors.redAccent, size: 60),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                strings.feedbackIntro,
                style: GoogleFonts.nunito(fontSize: 16, color: textColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: strings.feedbackLabelName,
                    boxColor: boxColor,
                    textColor: textColor,
                    validatorMsg: strings.feedbackValidatorName,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: strings.feedbackLabelEmail,
                    boxColor: boxColor,
                    textColor: textColor,
                    validatorMsg: strings.feedbackValidatorEmail,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _improvementController,
                    label: strings.feedbackLabelImprovement,
                    boxColor: boxColor,
                    textColor: textColor,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _wishesController,
                    label: strings.feedbackLabelWishes,
                    boxColor: boxColor,
                    textColor: textColor,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _questionsController,
                    label: strings.feedbackLabelQuestions,
                    boxColor: boxColor,
                    textColor: textColor,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _sendEmail,
                      child: Text(strings.feedbackButtonSubmit),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Color boxColor,
    required Color textColor,
    String? validatorMsg,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: boxColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: TextStyle(color: textColor),
      ),
      style: TextStyle(color: textColor),
      validator: validatorMsg != null
          ? (value) => value!.isEmpty ? validatorMsg : null
          : null,
      maxLines: maxLines,
    );
  }
}
