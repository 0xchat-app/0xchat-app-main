enum FileStorageProtocol {
  nip96(serverName: 'Nip96 Server'),
  blossom(serverName: 'Blossom Server'),
  minio(serverName: 'Minio Server'),
  oss(serverName: 'OSS Server');

  final String serverName;

  const FileStorageProtocol({required this.serverName});
}

class FileStorageServer {
  final String name;
  final String url;
  final FileStorageProtocol protocol;
  final String? description;
  final bool canEdit;

  FileStorageServer({
    required this.name,
    required this.url,
    this.description,
    required this.protocol,
    bool? canEdit,
  }) : canEdit = canEdit ?? true;

  factory FileStorageServer.fromJson(Map<String, dynamic> json) {
    FileStorageProtocol getFileStorageProtocol(int index) =>
        FileStorageProtocol.values
            .where((element) => element.index == index)
            .first;
    final url = json['url'] ?? '';
    final protocol = getFileStorageProtocol(json['protocol'] ?? 0);
    final name = json['name'] ?? '';
    final description = json['description'] ?? '';
    final canEdit = json['canEdit'];

    switch(protocol) {
      case FileStorageProtocol.nip96:
        return Nip96Server(
          url: url,
          name: name,
          canEdit: canEdit,
          description: description,
        );
      case FileStorageProtocol.blossom:
        return BlossomServer(
          url: url,
          name: name,
          canEdit: canEdit,
          description: description,
        );
      case FileStorageProtocol.minio:
        return MinioServer(
          name: name,
          url: url,
          accessKey: json['accessKey'] ?? '',
          secretKey: json['secretKey'] ?? '',
          bucketName: json['bucketName'] ?? '',
          description: description,
        );
      case FileStorageProtocol.oss:
        return OXChatServer(
          url: url,
          name: name,
          canEdit: canEdit,
          description: description,
        );
      default:
        return FileStorageServer(
          url: url,
          name: name,
          protocol: protocol,
          canEdit: canEdit,
        );
    }
  }

  Map<String, dynamic> toJson(FileStorageServer fileStorageServer) {
    final fileServerJson = <String, dynamic>{
      'url': fileStorageServer.url,
      'name': fileStorageServer.name,
      'protocol': fileStorageServer.protocol.index,
      'description': fileStorageServer.description,
      'canEdit': fileStorageServer.canEdit
    };
    switch(fileStorageServer.protocol) {
      case FileStorageProtocol.nip96:
        return fileServerJson;
      case FileStorageProtocol.blossom:
        return fileServerJson;
      case FileStorageProtocol.minio:
        MinioServer minioServer = fileStorageServer as MinioServer;
        return <String, dynamic>{
          ...fileServerJson,
          'accessKey': minioServer.accessKey,
          'secretKey': minioServer.secretKey,
          'bucketName': minioServer.bucketName
        };
      case FileStorageProtocol.oss:
        return fileServerJson;
      default:
        return fileServerJson;

    }
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileStorageServer && other.url == url;
  }

  static List<FileStorageServer> get defaultFileStorageServers => List.from([
        OXChatServer(
          url: 'https://www.0xchat.com',
          name: '0xchat.com',
          canEdit: false,
          description: 'https://www.0xchat.com',
        ),
        Nip96Server(
          url: 'https://nostr.build',
          name: 'nostr.build',
          canEdit: false,
          description: 'https://nostr.build',
        ),
        Nip96Server(
          url: 'https://void.cat',
          name: 'void.cat',
          canEdit: false,
          description: 'https://void.cat',
        ),
        Nip96Server(
          url: 'https://pomf2.lain.la',
          name: 'pomf2.lain.la',
          canEdit: false,
          description: 'https://pomf2.lain.la',
        ),
        BlossomServer(
          url: 'https://nosto.re',
          name: 'nosto.re',
          canEdit: false,
          description: 'https://nosto.re',
        )
      ]);
}

class Nip96Server extends FileStorageServer {
  Nip96Server({
    required super.name,
    required super.url,
    super.canEdit,
    super.description,
  }) : super(protocol: FileStorageProtocol.nip96);
}

class BlossomServer extends FileStorageServer {
  BlossomServer({
    required super.name,
    required super.url,
    super.canEdit,
    super.description,
  }) : super(protocol: FileStorageProtocol.blossom);
}

class MinioServer extends FileStorageServer {
  final String accessKey;
  final String secretKey;
  final String bucketName;
  final bool useSSL;
  final int? port;

  MinioServer({
    required super.url,
    required this.accessKey,
    required this.secretKey,
    required this.bucketName,
    this.port,
    required super.name,
    super.description,
    bool? useSSL,
  })  : useSSL = useSSL ?? true,
        super(protocol: FileStorageProtocol.minio);

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MinioServer &&
        other.url == url &&
        other.accessKey == accessKey &&
        secretKey == secretKey &&
        bucketName == bucketName;
  }
}

class OXChatServer extends FileStorageServer {
  OXChatServer({
    required super.url,
    required super.name,
    super.canEdit,
    super.description,
  }) : super(protocol: FileStorageProtocol.oss);
}
