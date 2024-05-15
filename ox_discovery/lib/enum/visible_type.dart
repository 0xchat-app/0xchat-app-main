enum VisibleType {
  everyone(name: 'Everyone', illustrate: 'All People'),
  allContact(name: 'My Contacts', illustrate: 'All Contacts'),
  private(name: 'Private', illustrate: 'Just me'),
  excludeContact(name: 'Selected Friends', illustrate: 'Selected Users');
  // includeContact(name: 'Selected User', illustrate: 'Just Selected Contacts');

  final String name;
  final String illustrate;

  const VisibleType({required this.name, required this.illustrate});
}
