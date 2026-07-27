import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/s.dart';

class ImpressumPage extends StatelessWidget {
  const ImpressumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final boxColor = isDarkMode ? Colors.grey[850] : Colors.grey[200];

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: textColor),
        title: Text(
          strings.impressumTitle,
          style: GoogleFonts.pacifico(color: textColor, fontSize: 28),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBox(strings.impressumHeader, boxColor!, textColor),
            const SizedBox(height: 16),
            _buildSection(
              strings.impressumResponsibleTitle,
              strings.impressumResponsibleContent,
              textColor,
            ),
            _buildSection(
              strings.impressumVatTitle,
              strings.impressumVatContent,
              textColor,
            ),
            _buildSection(
              strings.impressumLiabilityContentTitle,
              strings.impressumLiabilityContentContent,
              textColor,
            ),
            _buildSection(
              strings.impressumLiabilityLinksTitle,
              strings.impressumLiabilityLinksContent,
              textColor,
            ),
            _buildSection(
              strings.impressumCopyrightTitle,
              strings.impressumCopyrightContent,
              textColor,
            ),
            _buildSection(
              strings.impressumDisputeTitle,
              strings.impressumDisputeContent,
              textColor,
            ),
            Text(
              strings.impressumStand,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: textColor,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildBox(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
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
      ],
    );
  }
}
