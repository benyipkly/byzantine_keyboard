import 'dart:io';
import 'package:path/path.dart' as p;

// PORT to serve on
const int port = 8080;
// Directory to serve (flutter build output)
final String buildDir = p.join(Directory.current.path, 'build', 'web');

Future<void> main() async {
  final dir = Directory(buildDir);
  if (!await dir.exists()) {
    print('Error: Build directory not found at $buildDir');
    print('Please run "flutter build web --wasm" first.');
    exit(1);
  }

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('Serving $buildDir at http://localhost:$port');
  print('Press Ctrl+C to stop');

  await for (HttpRequest request in server) {
    // 1. Add COOP/COEP Headers
    request.response.headers.add('Cross-Origin-Opener-Policy', 'same-origin');
    request.response.headers.add(
      'Cross-Origin-Embedder-Policy',
      'require-corp',
    );

    // 2. Serve Files
    final String path = request.uri.path == '/'
        ? '/index.html'
        : request.uri.path;
    final File file = File(
      p.join(buildDir, path.substring(1)),
    ); // Remove leading /

    if (await file.exists()) {
      String mimeType = 'text/plain';
      if (path.endsWith('.html'))
        mimeType = 'text/html';
      else if (path.endsWith('.js') || path.endsWith('.mjs'))
        mimeType = 'application/javascript';
      else if (path.endsWith('.css'))
        mimeType = 'text/css';
      else if (path.endsWith('.png'))
        mimeType = 'image/png';
      else if (path.endsWith('.wasm'))
        mimeType = 'application/wasm';
      else if (path.endsWith('.json'))
        mimeType = 'application/json';

      request.response.headers.contentType = ContentType.parse(mimeType);
      await file.openRead().pipe(request.response);
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Not Found');
      await request.response.close();
    }
  }
}
