import 'package:flutter/material.dart';

import '../services/voice_service.dart';

class SpeakButton extends StatelessWidget {
  final String text;
  final String? tooltip;

  const SpeakButton({
    super.key,
    required this.text,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      tooltip: tooltip ?? 'Speak aloud',
      onPressed: () async {
        final ok = await VoiceService.instance.speak(text);
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(ok ? 'Speaking...' : 'Voice unavailable on this device'),
            duration: const Duration(milliseconds: 1200),
          ),
        );
      },
      icon: const Icon(Icons.volume_up_rounded),
    );
  }
}
