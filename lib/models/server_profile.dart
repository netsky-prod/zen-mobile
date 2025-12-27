class ServerProfile {
  final String name;
  final String address;
  final int port;
  final String protocol;
  final String? uuid;
  final String? path;
  final String? host;
  final String rawLink;

  ServerProfile({
    required this.name,
    required this.address,
    required this.port,
    required this.protocol,
    this.uuid,
    this.path,
    this.host,
    this.rawLink = '',
  });

  static ServerProfile? fromVlessLink(String link) {
    try {
      // vless://uuid@server:port?params#name
      if (!link.startsWith('vless://')) return null;
      
      final withoutScheme = link.substring(8);
      final hashIndex = withoutScheme.indexOf('#');
      final name = hashIndex != -1 
          ? Uri.decodeComponent(withoutScheme.substring(hashIndex + 1))
          : 'VLESS Server';
      
      final mainPart = hashIndex != -1 
          ? withoutScheme.substring(0, hashIndex)
          : withoutScheme;
      
      final atIndex = mainPart.indexOf('@');
      if (atIndex == -1) return null;
      
      final uuid = mainPart.substring(0, atIndex);
      final rest = mainPart.substring(atIndex + 1);
      
      final queryIndex = rest.indexOf('?');
      final hostPort = queryIndex != -1 
          ? rest.substring(0, queryIndex)
          : rest;
      
      final colonIndex = hostPort.lastIndexOf(':');
      if (colonIndex == -1) return null;
      
      final address = hostPort.substring(0, colonIndex);
      final port = int.tryParse(hostPort.substring(colonIndex + 1)) ?? 443;
      
      String? path;
      String? host;
      
      if (queryIndex != -1) {
        final params = Uri.splitQueryString(rest.substring(queryIndex + 1));
        path = params['path'];
        host = params['host'] ?? params['sni'];
      }
      
      return ServerProfile(
        name: name.toUpperCase(),
        address: address,
        port: port,
        protocol: 'VLESS',
        uuid: uuid,
        path: path,
        host: host,
        rawLink: link,
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toSingboxConfig() {
    return {
      "type": "vless",
      "tag": "proxy",
      "server": address,
      "server_port": port,
      "uuid": uuid,
      "tls": {
        "enabled": true,
        "server_name": host ?? address,
        "insecure": false,
      },
      "transport": {
        "type": "ws",
        "path": path ?? "/",
        "headers": {
          "Host": host ?? address,
        },
      },
    };
  }
}

