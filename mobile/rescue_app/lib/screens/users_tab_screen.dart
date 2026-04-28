import 'package:flutter/material.dart';

class UsersTabScreen extends StatelessWidget {
  const UsersTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_outline), text: 'משתמשים'),
              Tab(icon: Icon(Icons.groups_2_outlined), text: 'קבוצות'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _UsersList(context: context),
                _GroupsList(context: context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersList extends StatelessWidget {
  const _UsersList({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    const users = <({String name, String role, bool available})>[
      (name: 'ארי דין', role: 'מוקדן', available: true),
      (name: 'מאיה צ׳ן', role: 'פרמדיקית', available: true),
      (name: 'יונס ריד', role: 'מוביל חילוץ', available: false),
      (name: 'לילה נור', role: 'צוות כיבוי', available: true),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'צוות תגובה פעיל',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'מעקב אחר זמינות אנשי צוות לפני שיוך אירועים.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        for (final user in users)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(user.name.substring(0, 1)),
              ),
              title: Text(user.name),
              subtitle: Text(user.role),
              trailing: Chip(
                label: Text(user.available ? 'זמין' : 'עסוק'),
                backgroundColor: user.available
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
              ),
            ),
          ),
      ],
    );
  }
}

class _GroupsList extends StatelessWidget {
  const _GroupsList({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    const groups = <({String name, String focus, int members})>[
      (name: 'מוקד אלפא', focus: 'תיאום', members: 6),
      (name: 'רפואה בראבו', focus: 'אמבולנס', members: 8),
      (name: 'כיבוי צ׳רלי', focus: 'דיכוי אש', members: 5),
      (name: 'לוגיסטיקה דלתא', focus: 'אספקה', members: 4),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'קבוצות תגובה',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'ניהול הקבוצות המבצעיות ורמות האיוש הנוכחיות שלהן.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        for (final group in groups)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.groups_2_outlined),
              title: Text(group.name),
              subtitle: Text(group.focus),
              trailing: Text('${group.members} חברים'),
            ),
          ),
      ],
    );
  }
}
