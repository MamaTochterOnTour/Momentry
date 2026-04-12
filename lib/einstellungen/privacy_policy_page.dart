import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/s.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final bool isDarkMode;

  const PrivacyPolicyPage({super.key, this.isDarkMode = false});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
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
          strings.privacyTitle,
          style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.privacyLastUpdated,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              strings.privacyIntro,
              style: GoogleFonts.nunito(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 16),
            _buildSection(
              strings.privacySection1Title,
              strings.privacySection1Content,
              textColor,
            ),
            _buildSection(
              strings.privacySection2Title,
              strings.privacySection2Content,
              textColor,
            ),
            _buildSection(
              strings.privacySection3Title,
              strings.privacySection3Content,
              textColor,
            ),
            _buildSection(
              strings.privacySection4Title,
              strings.privacySection4Content,
              textColor,
            ),
            _buildSection(
              strings.privacySection5Title,
              strings.privacySection5Content,
              textColor,
            ),
            _buildSection(
              strings.privacySection6Title,
              strings.privacySection6Content,
              textColor,
            ),
            _buildSection(
              strings.privacySection7Title,
              strings.privacySection7Content,
              textColor,
            ),
            _buildSection(
              strings.privacySection8Title,
              strings.privacySection8Content,
              textColor,
            ),
            _buildSection(
              strings.privacySection9Title,
              strings.privacySection9Content,
              textColor,
            ),
            _buildSection(
              strings.privacySection10Title,
              strings.privacySection10Content,
              textColor,
            ),
            _buildSection(
              strings.privacySection11Title,
              strings.privacySection11Content,
              textColor,
            ),
            const SizedBox(height: 30),
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
