// Triggers a hot reload on a running Flutter app through the Dart VM Service.
//
// Usage: dart tool/hot_reload.dart <vm-service-uri>
// Example: dart tool/hot_reload.dart http://127.0.0.1:54321/gTf5bF__9g0=
//
// The URI is the "Dart VM Service ... available at" URL printed by `flutter run`.
// This performs the same work as pressing `r` in an attached `flutter run`
// session: reloadSources on the main isolate followed by a UI reassemble.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart tool/hot_reload.dart <vm-service-uri>');
    exitCode = 1;
    return;
  }

  final base = args.first.trim();
  final normalized = base.endsWith('/') ? base : '$base/';
  final socketUrl =
      '${normalized.replaceFirst('http://', 'ws://').replaceFirst('https://', 'wss://')}ws';

  final WebSocket socket;
  try {
    socket = await WebSocket.connect(socketUrl).timeout(const Duration(seconds: 10));
  } catch (e) {
    stderr.writeln('could not connect to VM service: $e');
    exitCode = 1;
    return;
  }

  final pending = <String, Completer<Map<String, dynamic>>>{};
  var counter = 0;

  socket.listen(
    (data) {
      if (data is! String) return;
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic> && decoded['id'] != null) {
        pending.remove(decoded['id'].toString())?.complete(decoded);
      }
    },
    onError: (Object e) => stderr.writeln('socket error: $e'),
    onDone: () {
      for (final c in pending.values) {
        if (!c.isCompleted) c.completeError('VM service connection closed');
      }
    },
  );

  Future<Map<String, dynamic>> call(String method, Map<String, dynamic> params) {
    final id = 'req-${++counter}';
    final completer = Completer<Map<String, dynamic>>();
    pending[id] = completer;
    socket.add(jsonEncode({
      'jsonrpc': '2.0',
      'id': id,
      'method': method,
      'params': params,
    }));
    return completer.future.timeout(const Duration(seconds: 30));
  }

  try {
    final vm = await call('getVM', {});
    final isolates =
        (vm['result']['isolates'] as List).cast<Map<String, dynamic>>();
    final main = isolates.firstWhere(
      (i) => i['name'] == 'main',
      orElse: () => isolates.first,
    );
    final isolateId = main['id'] as String;

    await call('reloadSources', {'isolateId': isolateId});
    stdout.writeln('hot reload complete (isolate ${main['name']})');

    final reassemble = await call(
      'ext.flutter.reassemble',
      {'isolateId': isolateId},
    );
    if (reassemble.containsKey('error')) {
      stdout.writeln('reassemble skipped: ${reassemble['error']}');
    } else {
      stdout.writeln('UI reassembled');
    }
  } catch (e) {
    stderr.writeln('hot reload failed: $e');
    exitCode = 1;
  } finally {
    await socket.close();
  }
}
