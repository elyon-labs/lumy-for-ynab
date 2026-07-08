class CategoryViewNotFoundError extends Error {
  CategoryViewNotFoundError(this.viewId);

  final String viewId;

  @override
  String toString() {
    return 'CategoryViewNotFoundError: View with id $viewId not found.';
  }
}
