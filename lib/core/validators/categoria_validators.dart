String? validateRequiredText(
  String? value, {
  required String fieldName,
}) {
  if (value == null || value.trim().isEmpty) {
    return 'Ingresa $fieldName.';
  }

  return null;
}
