enum VisibleType {
  everyone(name: 'Everyone', illustrate: 'All People'),
  allContact(name: 'My Contacts', illustrate: 'All Contacts'),
  excludeContact(name: 'Close Friends', illustrate: 'Exclude Selected Contacts'),
  includeContact(name: 'Selected User', illustrate: 'Just Selected Contacts');

  final String name;
  final String illustrate;

  const VisibleType({required this.name, required this.illustrate});
}
