import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Sobre versionado canónico de respaldo según directrices de data-export-and-restore.
@immutable
class RespaldoEnvelope {
  const RespaldoEnvelope({
    this.formatVersion = 1,
    this.schemaVersion = 1,
    this.appVersion = '1.0.0',
    required this.exportedAtUtc,
    required this.payloadSha256,
    required this.payloadCifrado,
  });

  final int formatVersion;
  final int schemaVersion;
  final String appVersion;
  final DateTime exportedAtUtc;
  final String payloadSha256;
  final String payloadCifrado;

  Map<String, dynamic> toMap() {
    return {
      'formatVersion': formatVersion,
      'schemaVersion': schemaVersion,
      'appVersion': appVersion,
      'exportedAtUtc': exportedAtUtc.toIso8601String(),
      'payloadSha256': payloadSha256,
      'payloadCifrado': payloadCifrado,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory RespaldoEnvelope.fromMap(Map<String, dynamic> map) {
    return RespaldoEnvelope(
      formatVersion: map['formatVersion'] as int? ?? 1,
      schemaVersion: map['schemaVersion'] as int? ?? 1,
      appVersion: map['appVersion'] as String? ?? '1.0.0',
      exportedAtUtc: DateTime.parse(map['exportedAtUtc'] as String),
      payloadSha256: map['payloadSha256'] as String,
      payloadCifrado: map['payloadCifrado'] as String,
    );
  }

  factory RespaldoEnvelope.fromJson(String jsonStr) {
    return RespaldoEnvelope.fromMap(
      jsonDecode(jsonStr) as Map<String, dynamic>,
    );
  }
}
