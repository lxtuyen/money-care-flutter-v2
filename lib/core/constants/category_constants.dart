class CategoryDetail {
  final String description;
  final List<String> examples;
  final String savingTip;

  const CategoryDetail({
    required this.description,
    required this.examples,
    required this.savingTip,
  });
}

class CategoryConstants {
  static const Map<String, CategoryDetail> categoryDetails = {
    // Expense
    'Ăn uống': CategoryDetail(
      description: 'Các chi phí dành cho việc ăn uống hàng ngày tại nhà hàng, quán cà phê hoặc gọi đồ ăn về.',
      examples: ['Cà phê sáng', 'Cơm trưa văn phòng', 'Liên hoan bạn bè', 'Trà sữa', 'Giao đồ ăn'],
      savingTip: 'Hãy thử mang cơm trưa đi làm và hạn chế các thức uống đắt tiền để tiết kiệm một khoản đáng kể mỗi tháng!',
    ),
    'Đi chợ': CategoryDetail(
      description: 'Chi tiêu cho thực phẩm tươi sống và nhu yếu phẩm phục vụ sinh hoạt tại gia đình.',
      examples: ['Thịt cá, rau củ', 'Gia vị nhà bếp', 'Đồ dùng nhà tắm', 'Bột giặt, chất tẩy rửa', 'Nước uống đóng chai'],
      savingTip: 'Lên danh sách trước khi đi chợ giúp bạn tránh mua những thứ không cần thiết và giảm lãng phí thực phẩm.',
    ),
    'Di chuyển': CategoryDetail(
      description: 'Chi phí đi lại hàng ngày và bảo trì phương tiện cá nhân hoặc sử dụng phương tiện công cộng.',
      examples: ['Xăng xe', 'Thay dầu, sửa xe', 'Phí gửi xe', 'Grab, Be, Taxi', 'Vé xe bus, tàu hỏa'],
      savingTip: 'Bảo trì xe định kỳ giúp tiết kiệm nhiên liệu và tránh các khoản sửa chữa lớn đột xuất.',
    ),
    'Hóa đơn': CategoryDetail(
      description: 'Các khoản thanh toán cố định định kỳ hàng tháng cho nơi ở và các dịch vụ cơ bản.',
      examples: ['Tiền điện, nước', 'Cước Internet, truyền hình', 'Tiền thuê nhà', 'Phí quản lý chung cư', 'Thuê bao di động'],
      savingTip: 'Tắt các thiết bị điện khi không sử dụng và kiểm tra lại các gói cước dịch vụ để tối ưu hóa chi phí.',
    ),
    'Mua sắm': CategoryDetail(
      description: 'Chi phí cho quần áo, phụ kiện, đồ dùng cá nhân hoặc trang thiết bị trong nhà.',
      examples: ['Quần áo, giày dép', 'Đồ trang sức', 'Điện thoại, máy tính', 'Nội thất gia đình', 'Đồ điện tử'],
      savingTip: 'Hãy áp dụng quy tắc "chờ 24 giờ" trước khi mua một món đồ không thiết yếu để tránh mua sắm theo cảm xúc.',
    ),
    'Sức khỏe': CategoryDetail(
      description: 'Các khoản chi liên quan đến khám chữa bệnh, thuốc men và rèn luyện thể chất.',
      examples: ['Mua thuốc, bông băng', 'Khám bệnh định kỳ', 'Thực phẩm chức năng', 'Thẻ tập Gym/Yoga', 'Bảo hiểm sức khỏe'],
      savingTip: 'Phòng bệnh hơn chữa bệnh. Tập thể dục đều đặn là cách tốt nhất để tiết kiệm chi phí y tế lâu dài.',
    ),
    'Giải trí': CategoryDetail(
      description: 'Các hoạt động thư giãn, văn hóa và giải trí giúp tái tạo năng lượng sau giờ làm việc.',
      examples: ['Xem phim tại rạp', 'Du lịch, dã ngoại', 'Sách truyện, báo chí', 'Trò chơi điện tử', 'Vé xem ca nhạc'],
      savingTip: 'Tận dụng các ngày giảm giá tại rạp phim hoặc các điểm vui chơi công cộng miễn phí để vẫn vui vẻ mà ít tốn kém.',
    ),
    'Giáo dục': CategoryDetail(
      description: 'Đầu tư vào kiến thức, kỹ năng và phát triển bản thân cho bạn hoặc con cái.',
      examples: ['Học phí trường học', 'Khóa học kỹ năng online', 'Sách chuyên môn', 'Dụng cụ học tập', 'Hội thảo, workshop'],
      savingTip: 'Tận dụng các nguồn tài liệu miễn phí từ thư viện hoặc các khóa học trực tuyến miễn phí có chất lượng.',
    ),
    'Làm đẹp': CategoryDetail(
      description: 'Dịch vụ chăm sóc ngoại hình, thẩm mỹ và các loại mỹ phẩm cá nhân.',
      examples: ['Cắt tóc, làm đầu', 'Mỹ phẩm, đồ trang điểm', 'Chăm sóc da, Spa', 'Làm móng (Nail)', 'Nước hoa'],
      savingTip: 'Học cách tự chăm sóc da cơ bản tại nhà có thể giúp bạn giảm tần suất đi Spa đắt đỏ.',
    ),
    'Khác': CategoryDetail(
      description: 'Các khoản chi phí phát sinh bất ngờ hoặc không thuộc về các nhóm danh mục trên.',
      examples: ['Quyên góp, từ thiện', 'Đồ dùng bị thất lạc', 'Phí ngân hàng', 'Chi phí không tên khác'],
      savingTip: 'Cố gắng phân loại mọi thứ rõ ràng nhất có thể để biết chính xác tiền của bạn đã đi đâu.',
    ),

    // Income
    'Lương': CategoryDetail(
      description: 'Thu nhập chính hàng tháng từ công việc ổn định của bạn.',
      examples: ['Lương cứng', 'Tiền làm thêm giờ (OT)', 'Phụ cấp công việc'],
      savingTip: 'Hãy trích ít nhất 20% lương ngay khi nhận được để cho vào quỹ tiết kiệm trước khi bắt đầu chi tiêu.',
    ),
    'Thưởng': CategoryDetail(
      description: 'Các khoản tiền thưởng bổ sung cho nỗ lực làm việc hoặc nhân dịp đặc biệt.',
      examples: ['Thưởng dự án', 'Thưởng Tết (Lương tháng 13)', 'Thưởng doanh số', 'Tiền hoa hồng'],
      savingTip: 'Dùng tiền thưởng để trả nợ hoặc đầu tư thay vì chi tiêu hoang phí cho các mục tiêu ngắn hạn.',
    ),
    'Kinh doanh': CategoryDetail(
      description: 'Lợi nhuận thu được từ hoạt động buôn bán, đầu tư hoặc công việc tự do (Freelance).',
      examples: ['Bán hàng online', 'Doanh thu cửa hàng', 'Nhuận bút, thiết kế', 'Cho thuê nhà/xe'],
      savingTip: 'Tái đầu tư một phần lợi nhuận để giúp công việc kinh doanh của bạn ngày càng phát triển hơn.',
    ),
    'Lãi suất': CategoryDetail(
      description: 'Tiền lãi phát sinh từ các khoản tiền gửi tiết kiệm hoặc đầu tư tài chính.',
      examples: ['Lãi gửi ngân hàng', 'Cổ tức chứng khoán', 'Lãi trái phiếu', 'Tiền lãi cho vay'],
      savingTip: 'Lãi suất kép là kỳ quan thứ 8. Hãy kiên nhẫn tích lũy để thấy sức mạnh của tiền đẻ ra tiền.',
    ),
    'Quà tặng': CategoryDetail(
      description: 'Các khoản tiền nhận được từ người thân, bạn bè nhân các dịp lễ hoặc quà tặng bất ngờ.',
      examples: ['Tiền mừng sinh nhật', 'Tiền mừng cưới', 'Người thân cho tiền', 'Trúng thưởng xổ số'],
      savingTip: 'Quà tặng là lộc may mắn, hãy dùng một phần để tự thưởng cho bản thân và phần còn lại để tiết kiệm.',
    ),
    'Khác (Thu nhập)': CategoryDetail(
      description: 'Các khoản thu nhập không thường xuyên hoặc không thuộc các nhóm trên.',
      examples: ['Tiền hoàn thuế', 'Bán đồ cũ', 'Thu nợ', 'Tiền lẻ phát sinh'],
      savingTip: 'Dù là khoản thu nhỏ, việc ghi chép lại sẽ giúp bạn có cái nhìn tổng thể chính xác về dòng tiền của mình.',
    ),
  };
}
