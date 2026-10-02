# DiaryChatAI

Hỗ trợ người dùng viết nhật ký gần gũi hơn thông qua chatting với AI, đồng thời lưu giữ, gợi nhớ và tìm kiếm thông tin từ những câu chuyện, sự kiện trong quá khứ.

## 1. Introduce

DiaryChat là một AI companion có memory dài hạn, được xây dựng để trò chuyện với người dùng như một người bạn và có khả năng ghi nhớ, kết nối, gợi nhớ và tái dựng những câu chuyện người dùng đã chia sẻ theo thời gian.

DiaryChat hướng tới trở thành một AI companion có khả năng:

* Trò chuyện tự nhiên và thân thiện như một người bạn.
* Ghi nhớ những sự kiện và thông tin người dùng đã xác nhận.
* Kết nối và gợi nhớ những chuyện cũ khi chúng liên quan đến context hiện tại.

## 2. Memory Architecture

1. **Conversation** — dữ liệu gốc của cuộc trò chuyện, không bị AI tự ý thay đổi.
2. **Memory Objects** — trích xuất những thông tin có ý nghĩa từ conversation thành các object nhỏ hơn để lưu trữ và tổ chức.
3. **Core Memory** — kết nối các memory có liên quan về mặt ý nghĩa và context thành một mạch ký ức lớn, cho phép bổ sung và liên kết thông tin theo thời gian.
4. **Plan & Event** — hỗ trợ ghi nhớ các dự định trong tương lai và các sự kiện đã hoặc đang xảy ra.

## 3. Key Principles

* Người dùng phải xác nhận trước khi thông tin trở thành memory dài hạn.
* AI không được biến suy luận thành sự thật.
* Conversation gốc không bị AI tự ý sửa.
* Người dùng có quyền xem, sửa và xóa memory.
* Timeline phải giữ đúng mức độ chính xác của thời gian.
* Memory có thể được bổ sung vào những sự kiện trong quá khứ.
* Retrieval không chỉ dựa vào semantic search mà hướng tới hybrid retrieval.
* AI hỗ trợ và đưa ra gợi ý, không thay người dùng quyết định.
