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
    final protocol = getFileStorageProtocol(json['protocol'] ?? 0);
    final name = json['name'] ?? '';
    final description = json['description'] ?? '';
    final canEdit = json['canEdit'];

    switch(protocol) {
      case FileStorageProtocol.nip96:
        return Nip96Server(
          name: name,
          canEdit: canEdit,
          description: description,
        );
      case FileStorageProtocol.blossom:
        return BlossomServer(
          name: name,
          canEdit: canEdit,
          description: description,
        );
      case FileStorageProtocol.minio:
        return MinioServer(
          name: name,
          endPoint: json['endPoint'] ?? '',
          accessKey: json['accessKey'] ?? '',
          secretKey: json['secretKey'] ?? '',
          bucketName: json['bucketName'] ?? '',
          description: description,
        );
      case FileStorageProtocol.oss:
        return OXChatServer(
          name: name,
          canEdit: canEdit,
          description: description,
        );
      default:
        return FileStorageServer(
          name: name,
          protocol: protocol,
          canEdit: canEdit,
        );
    }
  }

  Map<String, dynamic> toJson(FileStorageServer fileStorageServer) {
    final fileServerJson = <String, dynamic>{
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
          'endPoint': minioServer.endPoint,
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

  static List<FileStorageServer> get defaultFileStorageServers => List.from([
        OXChatServer(
          name: '0xchat File Server',
          canEdit: false,
          description: 'Free storage, expired in 7 days',
        ),
        Nip96Server(
          name: 'nostr.build',
          canEdit: false,
          description: 'Free storage, expired in 7 days',
        ),
        Nip96Server(
          name: 'void.cat',
          canEdit: false,
          description: 'Free storage, expired in 7 days',
        ),
        Nip96Server(
          name: 'pomf2.lain.la',
          canEdit: false,
          description: 'Free storage, expired in 7 days',
        ),
        BlossomServer(
          name: 'nosto.re',
          canEdit: false,
          description: 'Free storage, expired in 7 days',
        )
      ]);
}

class Nip96Server extends FileStorageServer {
  Nip96Server({
    required super.name,
    super.canEdit,
    super.description,
  }) : super(protocol: FileStorageProtocol.nip96);
}

class BlossomServer extends FileStorageServer {
  BlossomServer({
    required super.name,
    super.canEdit,
    super.description,
  }) : super(protocol: FileStorageProtocol.blossom);
}

class MinioServer extends FileStorageServer {
  final String endPoint;
  final String accessKey;
  final String secretKey;
  final String bucketName;
  final bool useSSL;
  final int? port;

  MinioServer({
    required this.endPoint,
    required this.accessKey,
    required this.secretKey,
    required this.bucketName,
    this.port,
    required super.name,
    super.description,
    bool? useSSL,
  })  : useSSL = useSSL ?? true,
        super(protocol: FileStorageProtocol.minio);
}

class OXChatServer extends FileStorageServer {
  OXChatServer({
    required super.name,
    super.canEdit,
    super.description,
  }) : super(protocol: FileStorageProtocol.blossom);
}
