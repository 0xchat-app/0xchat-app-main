enum FileStorageProtocol {
  nip96(serverName: 'Nip96 Server'),
  blossom(serverName: 'Blossom Server'),
  minio(serverName: 'Minio Server'),
  oss(serverName: 'OSS Server'),
  originless(serverName: 'Originless Server');

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
        FileStorageProtocol.values.where((element) => element.index == index).first;
    final url = json['url'] ?? '';
    final protocol = getFileStorageProtocol(json['protocol'] ?? 0);
    final name = json['name'] ?? '';
    final description = json['description'] ?? '';
    final canEdit = json['canEdit'];

    switch (protocol) {
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
      case FileStorageProtocol.originless:
        return OriginlessServer(
          url: url,
          name: name,
          canEdit: canEdit,
          description: description,
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
    switch (fileStorageServer.protocol) {
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
      case FileStorageProtocol.originless:
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

  /// Default file storage server list. Originless is first so it becomes the default selected server (index 0).
  static List<FileStorageServer> get defaultFileStorageServers => List.from([
        OriginlessServer(
          url: 'https://originless.besoeasy.com',
          name: 'originless.besoeasy.com',
          canEdit: false,
          description: 'https://originless.besoeasy.com',
        ),
        BlossomServer(
          url: 'https://blossom.band',
          name: 'blossom.band',
          canEdit: false,
          description: 'https://blossom.band',
        ),
        Nip96Server(
          url: 'https://nostr.build',
          name: 'nostr.build',
          canEdit: false,
          description: 'https://nostr.build',
        ),
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

class OriginlessServer extends FileStorageServer {
  OriginlessServer({
    required super.url,
    required super.name,
    super.canEdit,
    super.description,
  }) : super(protocol: FileStorageProtocol.originless);
}
