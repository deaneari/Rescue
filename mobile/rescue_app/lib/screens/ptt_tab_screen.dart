import 'package:flutter/material.dart';

class PttTabScreen extends StatefulWidget {
  const PttTabScreen({super.key});

  @override
  State<PttTabScreen> createState() => _PttTabScreenState();
}

class _PttTabScreenState extends State<PttTabScreen> {
  int _selectedGroupIndex = 0;

  @override
  Widget build(BuildContext context) {
    const groups = <String>[
      'מוקד אלפא',
      'צוות רפואי בראבו',
      'סיוע כיבוי צ׳רלי',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentHeight = constraints.maxHeight - 32;
        final topHeight = contentHeight * 0.4;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: topHeight,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'קבוצות ערוץ',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.separated(
                            itemCount: groups.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              final isSelected = index == _selectedGroupIndex;

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                selected: isSelected,
                                onTap: () {
                                  setState(() {
                                    _selectedGroupIndex = index;
                                  });
                                },
                                leading: Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                ),
                                title: Text(groups[index]),
                                trailing: isSelected
                                    ? const Chip(label: Text('נבחר'))
                                    : null,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  child: LayoutBuilder(
                    builder: (context, cardConstraints) {
                      final buttonSize =
                          (cardConstraints.maxHeight * 0.42).clamp(88.0, 120.0);
                      final iconSize = (buttonSize * 0.34).clamp(28.0, 40.0);

                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'לחצן דיבור',
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ערוץ נבחר: ${groups[_selectedGroupIndex]}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'לחיצה ממושכת לשידור לקבוצת התגובה הנבחרת.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: EdgeInsets.all(buttonSize / 4),
                                minimumSize: Size(buttonSize, buttonSize),
                              ),
                              child: Icon(Icons.mic, size: iconSize),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
