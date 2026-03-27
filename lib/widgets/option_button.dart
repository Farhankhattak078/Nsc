import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final String label; // A, B, C, D
  final bool isSelected;
  final bool isCorrect;
  final bool hasAttempted;
  final VoidCallback onTap;

  const OptionButton({
    super.key,
    required this.text,
    required this.label,
    required this.isSelected,
    required this.isCorrect,
    required this.hasAttempted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color getBorderColor() {
      if (!hasAttempted) return Colors.grey.withValues(alpha: 0.3);
      if (isCorrect) return Colors.green;
      if (isSelected && !isCorrect) return Colors.red;
      return Colors.grey.withValues(alpha: 0.3);
    }

    Color getBackgroundColor() {
      if (!hasAttempted) return Colors.transparent;
      if (isCorrect) return Colors.green.withValues(alpha: 0.1);
      if (isSelected && !isCorrect) return Colors.red.withValues(alpha: 0.1);
      return Colors.transparent;
    }

    Color getTextColor() {
      if (!hasAttempted) return Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
      if (isCorrect) return Colors.green;
      if (isSelected && !isCorrect) return Colors.red;
      return Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: hasAttempted ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: getBackgroundColor(),
            border: Border.all(color: getBorderColor(), width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: getBorderColor(), width: 2),
                    color: getBackgroundColor() == Colors.transparent ? Colors.transparent : getBackgroundColor().withValues(alpha: 0.2),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getTextColor(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: getTextColor(),
                    ),
                  ),
                ),
                if (hasAttempted && isCorrect)
                  const Icon(Icons.check_circle, color: Colors.green),
                if (hasAttempted && isSelected && !isCorrect)
                  const Icon(Icons.cancel, color: Colors.red),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
