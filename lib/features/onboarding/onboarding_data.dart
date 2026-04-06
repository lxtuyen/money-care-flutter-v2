class SuggestedCategory {
  final String name;
  final String emoji;
  final bool isEssential;
  const SuggestedCategory(this.name, this.emoji, [this.isEssential = true]);
}

const suggestedExpenseCategories = [
  SuggestedCategory('Thức ăn & Đồ uống', '🍔', true),
  SuggestedCategory('Nhà', '🏠', true),
  SuggestedCategory('Mua sắm', '🛍️', false),
  SuggestedCategory('Giao thông', '🚕', true),
  SuggestedCategory('Du lịch', '✈️', false),
  SuggestedCategory('Giải trí', '🎮', false),
  SuggestedCategory('Sức khỏe', '💊', true),
  SuggestedCategory('Thực phẩm', '🛒', true),
  SuggestedCategory('Thú cưng', '🐾', false),
  SuggestedCategory('Giáo dục', '🎓', true),
  SuggestedCategory('Điện tử', '📱', false),
  SuggestedCategory('Làm đẹp', '💄', false),
  SuggestedCategory('Thể thao', '⚽', false),
];

const suggestedIncomeCategories = [
  SuggestedCategory('Lương', '💵', true),
  SuggestedCategory('Đầu tư', '📈', false),
  SuggestedCategory('Tiền thưởng', '🎁', false),
  SuggestedCategory('Kinh doanh', '💼', true),
];
