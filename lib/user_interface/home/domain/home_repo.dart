

abstract class HomeRepo{
  Future<String> extractAsset({required String sourceFileName});
  List<String?> readFile({required String path});
}