enum FileStorageProtocol {
  nip96(serverName: 'Nip96 Server'),
  blossom(serverName: 'Mini Server'),
  minio(serverName: 'Minio Server');

  final String serverName;

  const FileStorageProtocol({required this.serverName});
}

class FileStorageServer {
  final String name;
  final FileStorageProtocol protocol;
  final String? description;
  final bool canEdit;

  FileStorageServer({
    required this.name,
    this.description,
    required this.protocol,
    bool? canEdit,
  }) : canEdit = canEdit ?? true;

  factory FileStorageServer.fromJson(Map<String, dynamic> json) {
    FileStorageProtocol getFileStorageProtocol(int index) =>
        FileStorageProtocol.values
            .where((element) => element.index == index)
            .first;

    return FileStorageServer(
      name: json['name'] ?? '',
      protocol: getFileStorageProtocol(json['protocol'] ?? 0),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson(FileStorageServer fileStorageServer) =>
      <String, dynamic>{
        'name': fileStorageServer.name,
        'protocol': fileStorageServer.protocol.index,
        'description': fileStorageServer.description,
      };

  static List<FileStorageServer> get defaultFileStorageServers => List.from([
        Nip96Server(
          name: 'nostr.build',
          description: 'Free storage, expired in 7 days',
        ),
        Nip96Server(
          name: 'void.cat',
          description: 'Free storage, expired in 7 days',
        ),
        Nip96Server(
          name: 'pomf2.lain.la,',
          description: 'Free storage, expired in 7 days',
        ),
        BlossomServer(
          name: 'nosto.re',
          description: 'Free storage, expired in 7 days,',
        )
      ]);
}

class Nip96Server extends FileStorageServer {
  Nip96Server({
    required super.name,
    super.description,
  }) : super(protocol: FileStorageProtocol.nip96);
}

class BlossomServer extends FileStorageServer {
  BlossomServer({
    required super.name,
    super.description,
  }) : super(protocol: FileStorageProtocol.blossom);
}

class MinioServer extends FileStorageServer {
  final String endPoint;
  final String accessKey;
  final String secretKey;
  final bool useSSL;

  MinioServer({
    required this.endPoint,
    required this.accessKey,
    required this.secretKey,
    required super.name,
    super.description,
    bool? useSSL,
  })  : useSSL = useSSL ?? true,
        super(protocol: FileStorageProtocol.minio);
}
