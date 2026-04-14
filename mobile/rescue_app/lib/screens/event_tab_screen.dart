import 'package:flutter/material.dart';

class EventTabScreen extends StatelessWidget {
  const EventTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const events = <({String title, String status, String location})>[
      (
        title: 'התנגשות בצד הדרך',
        status: 'קריטי',
        location: 'כביש A12 צפון',
      ),
      (
        title: 'אזעקת מחסן',
        status: 'גבוה',
        location: 'אזור הנמל, סקטור 4',
      ),
      (
        title: 'העברה רפואית',
        status: 'בינוני',
        location: 'מרפאת סנט אן',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('עדכוני אירועים',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'צפייה ומעקב אחר אירועים פעילים במקום אחד.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        for (final event in events)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.warning_amber_rounded),
              title: Text(event.title),
              subtitle: Text(event.location),
              trailing: Chip(label: Text(event.status)),
            ),
          ),
      ],
    );
  }
}
