import 'package:flutter/material.dart';

class PrivacyNoteWidget extends StatelessWidget {
  const PrivacyNoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.privacy_tip_outlined, color: Color(0xFF0064FF)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Privacy Notice: We do not collect any personal information. Your selected video is used only for conversion and is not stored or shared.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
