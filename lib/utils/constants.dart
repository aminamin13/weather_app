import 'package:flutter/material.dart';

class Constants {
  final Color primaryColor = Color(0xFF6366F1); // Indigo
  final Color secondaryColor = Color(0xFF8B5CF6); // Purple
  final Color accentColor = Color(0xFF06B6D4); // Cyan
  final Color backgroundColor = Color(0xFFF8FAFC); // Light gray
  final Color cardColor = Colors.white;
  final Color textPrimary = Color(0xFF1E293B);
  final Color textSecondary = Color(0xFF64748B);
  
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  LinearGradient get cardGradient => LinearGradient(
    colors: [cardColor, cardColor.withOpacity(0.8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}