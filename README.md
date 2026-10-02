# DiaryChatAI

Hỗ trợ người dùng viết nhật ký gần gũi hơn thông qua chatting với AI, đồng thời lưu giữ, gợi nhớ và tìm kiếm thông tin từ những câu chuyện, sự kiện trong quá khứ.

## 1. Introduce

DiaryChat là một AI companion có memory dài hạn, được xây dựng để trò chuyện với người dùng như một người bạn và có khả năng ghi nhớ, kết nối, gợi nhớ và tái dựng những câu chuyện người dùng đã chia sẻ theo thời gian.

DiaryChat hướng tới trở thành một AI companion có khả năng:

Trò chuyện tự nhiên và thân thiện như một người bạn. 
Ghi nhớ những sự kiện và thông tin người dùng. 
Kết nối và gợi nhớ những chuyện cũ khi chúng liên quan đến context hiện tại.

## 2. Memory architecture

1. Conversation - chứa dữ liệu gốc của người dùng, là cơ sở quan trọng chính nhất cho AI nhận diện và lấy thông tin người dùng
2. Memory objects - trích xuất những thông tin có ý nghĩa trong dữ liệu gốc thành các object nhỏ hơn để lưu trữ và sắp xếp thông tin
3. Core memory - là một cơ chế quan trọng nhất của DiaryChatAI, giúp kết nối dữ liệu tương đồng về mặt ý nghĩa, liên quan về mặt ngữ cảnh, thời gian thành một mạch ký ức lớn, cho phép người dùng bổ sung, liên kết thông tin thành một mạch hoàn chỉnh
4. Plan & event - hỗ trợ ghi nhớ các dự định, cuộc hẹn trong tương lai và các sự kiện đã hoặc đang xảy ra.

## 3.Key Principles

Người dùng phải xác nhận trước khi thông tin trở thành memory dài hạn.
AI không được biến suy luận thành sự thật.
Conversation gốc không bị AI tự ý sửa.
Người dùng có quyền xem, sửa và xóa memory.
Timeline phải giữ đúng mức độ chính xác của thời gian.
Memory có thể được bổ sung vào những sự kiện trong quá khứ.
Retrieval không chỉ dựa vào semantic search mà hướng tới hybrid retrieval.
AI hỗ trợ và đưa ra gợi ý, không thay người dùng quyết định.
* Người dùng có quyền xem, sửa và xóa memory.
* Timeline phải giữ đúng mức độ chính xác của thời gian.
* Memory có thể được bổ sung vào những sự kiện trong quá khứ.
* Retrieval không chỉ dựa vào semantic search mà hướng tới hybrid retrieval.
* AI hỗ trợ và đưa ra gợi ý, không thay người dùng quyết định.
