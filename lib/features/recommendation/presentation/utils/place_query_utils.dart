String normalizeVietnameseText(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
      .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
      .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
      .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
      .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
      .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
      .replaceAll('đ', 'd')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String queryFromCategory(String? categoryName) {
  final normalized = normalizeVietnameseText(categoryName ?? '');
  if (normalized.isEmpty) return 'địa điểm gần đây';

  if (normalized.contains('an uong') ||
      normalized.contains('do an') ||
      normalized.contains('thuc an') ||
      normalized.contains('nha hang') ||
      normalized.contains('restaurant') ||
      normalized.contains('food')) {
    return 'quán ăn';
  }

  if (normalized.contains('cafe') ||
      normalized.contains('ca phe') ||
      normalized.contains('coffee')) {
    return 'cafe';
  }

  if (normalized.contains('mua sam') ||
      normalized.contains('shopping') ||
      normalized.contains('cua hang')) {
    return 'cửa hàng';
  }

  return 'địa điểm gần đây';
}

bool shouldAutoPromptCheckinForCategory(String? categoryName) {
  final query = queryFromCategory(categoryName);
  return query == 'quán ăn' || query == 'cafe' || query == 'cửa hàng';
}

String normalizePlaceQuery(String value) {
  final trimmed = value.trim();
  final normalized = normalizeVietnameseText(trimmed);

  switch (normalized) {
    case 'com':
      return 'quán cơm';
    case 'pho':
      return 'quán phở';
    case 'bun':
      return 'quán bún';
    case 'cafe':
    case 'ca phe':
    case 'coffee':
      return 'cafe';
    case 'tra sua':
      return 'trà sữa';
    case 'quan an':
    case 'an uong':
      return 'quán ăn';
    default:
      return trimmed;
  }
}
