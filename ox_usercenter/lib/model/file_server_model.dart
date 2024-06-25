enum FileServerType {
  nip96(serverName: 'Nip96 Server'),
  mini(serverName: 'Mini Server');

  final String serverName;
  const FileServerType({required this.serverName});
}

class FileServerModel {
  final String name;
  final String? description;
  final bool canEdit;

  FileServerModel({
    required this.name,
    this.description,
    bool? canEdit,
  }) : canEdit = canEdit ?? true;
}
