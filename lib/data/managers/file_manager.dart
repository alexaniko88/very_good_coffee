part of managers;

typedef OnProcessResponseCallback = Future<Response> Function();

@named
@injectable
class FileManager {
  final FileSource fileSource;

  FileManager({
    @factoryMethod required this.fileSource,
  });

  Future<String> getFavorite() async {
    try {
      return await fileSource.getFavoritePath();
    } catch (_) {
      return '';
    }
  }

  Future<String?> saveFavorite({
    required String url,
    required OnProcessResponseCallback onProcessBodyBytes,
  }) async {
    try {
      final favoritesDir = await fileSource.getFavoriteDirectory();
      final file = fileSource.getFile(url: url, dirPath: favoritesDir.path);
      if (await fileSource.isEmpty(favoritesDir)) {
        await _storeFile(
          file: file,
          onProcessBodyBytes: onProcessBodyBytes,
        );
        return file.path;
      } else {
        final isTheSameRemoved = await fileSource.removeFile(
          dir: favoritesDir,
          fileToRemovePath: file.path,
        );
        if (isTheSameRemoved) {
          return '';
        } else {
          await _storeFile(
            file: file,
            onProcessBodyBytes: onProcessBodyBytes,
          );
          return file.path;
        }
      }
    } catch (_) {
      return null;
    }
  }

  Future<void> _storeFile({
    required File file,
    required OnProcessResponseCallback onProcessBodyBytes,
  }) async {
    final coffeeResponse = await onProcessBodyBytes();
    await fileSource.writeToFile(
      file: file,
      response: coffeeResponse,
    );
  }
}

class FileSource {
  final String _favoriteDir = 'favorite';

  const FileSource();

  Future<Directory> getFavoriteDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return await Directory("${appDir.path}/$_favoriteDir").create();
  }

  Future<bool> isEmpty(Directory dir) => dir.list().isEmpty;

  Future<String> getFavoritePath() async {
    final dir = await getFavoriteDirectory();
    return (await dir.list().first).path;
  }

  Future<bool> removeFile({
    required Directory dir,
    required String fileToRemovePath,
  }) async {
    bool isTheSame = false;
    final file = dir.listSync().first;
    if (file.path == fileToRemovePath) {
      isTheSame = true;
    }
    await file.delete();
    return isTheSame;
  }

  File getFile({
    required String url,
    required String dirPath,
  }) =>
      File(join(dirPath, basename(url)));

  Future<void> writeToFile({
    required File file,
    required Response response,
  }) =>
      file.writeAsBytes(response.bodyBytes);
}
