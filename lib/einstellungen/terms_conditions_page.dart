import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/s.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        leading: BackButton(color: textColor),
        title: Text(
          strings.termsTitle,
          style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.termsLastUpdated,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              strings.terms1Title,
              strings.terms1Content,
              textColor,
            ),
            _buildSection(
              strings.terms2Title,
              strings.terms2Content,
              textColor,
            ),
            _buildSection(
              strings.terms3Title,
              strings.terms3Content,
              textColor,
            ),
            _buildSection(
              strings.terms4Title,
              strings.terms4Content,
              textColor,
            ),
            _buildSection(
              strings.terms5Title,
              strings.terms5Content,
              textColor,
            ),
            _buildSection(
              strings.terms6Title,
              strings.terms6Content,
              textColor,
            ),
            _buildSection(
              strings.terms7Title,
              strings.terms7Content,
              textColor,
            ),
            _buildSection(
              strings.terms8Title,
              strings.terms8Content,
              textColor,
            ),
            _buildSection(
              strings.terms9Title,
              strings.terms9Content,
              textColor,
            ),
            _buildSection(
              strings.terms10Title,
              strings.terms10Content,
              textColor,
            ),
            _buildSection(
              strings.terms11Title,
              strings.terms11Content,
              textColor,
            ),
            _buildSection(
              strings.terms12Title,
              strings.terms12Content,
              textColor,
            ),
            _buildSection(
              strings.terms13Title,
              strings.terms13Content,
              textColor,
            ),
            Text(
              strings.termsImportantNotice,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: GoogleFonts.nunito(fontSize: 16, color: textColor),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
