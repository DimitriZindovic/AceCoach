import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// Asks for a city name used as the weather fallback. Returns the trimmed
/// city, an empty string to clear it, or `null` when dismissed.
Future<String?> showHomeCityDialog(BuildContext context, {String? initial}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _HomeCityDialog(initial: initial),
  );
}

class _HomeCityDialog extends StatefulWidget {
  const _HomeCityDialog({this.initial});

  final String? initial;

  @override
  State<_HomeCityDialog> createState() => _HomeCityDialogState();
}

class _HomeCityDialogState extends State<_HomeCityDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text.trim());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Home court city'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Used for the weather when your location is not available.',
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'e.g. Paris',
              prefixIcon: Icon(Icons.place_outlined),
            ),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        if ((widget.initial ?? '').isNotEmpty)
          TextButton(
            onPressed: () => Navigator.of(context).pop(''),
            child: const Text('Clear'),
          ),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
