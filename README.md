## Diễn Đàn Hỗ Trợ Và Xử Lý Bug: 
### [https://www.facebook.com/groups/wordpresseb](https://www.facebook.com/groups/wordpresseb)

ECHBAY-VPSSIM là bản chỉnh sửa lại từ VPSSIM-3.8.1, đây là phiên bản cuối cùng của VPSSIM mà mình clone
lại được trước khi VPSSIM tiến hành mã hóa và thương mại hóa.
Cơ bản thì trong bản VPSSIM mình chỉnh sửa lại cũng không có gì đặc biệt, chủ yếu tinh chỉnh lại một số
phiên bản phần mềm cho phù hợp với thời điểm 2020, tránh tình trạng cổ lỗ sĩ quá.

### Lệnh Cài Đặt ECHBAY-VPSSIM Trên Centos 6 & 7:
```
yum -y install wget ; wget --no-check-certificate https://vpssim.echbay.com/install ; chmod +x install ; bash install
```

### Chức Năng, Tiện Ích Và Tối Ưu VPS Của ECHBAY-VPSSIM:
#### - Cài đặt nginx-1.18.0, đây là phiên bản ổn định và mới nhất của nginx tính đến thời điểm tháng 08-2020,
#### kết hợp với openssl-1.0.2s thay cho bản openssl cũ của VPSSIM, phiên bản này mới hỗ trợ đầy đủ HTTP/2.
##### + Phiên bản nginx được xem và cập nhật tại: [http://nginx.org/en/download.html](http://nginx.org/en/download.html)
##### + openssl version: https://www.openssl.org/source/
##### + https://ftp.pcre.org/pub/pcre/
##### + https://www.zlib.net/

#### - Cho bạn lựa chọn MariaDB phiên bản 10.0, 10.1, 10.2 & 10.3 và tự động config phù hợp với cấu hình server.
#### - Lựa chọn 6 phiên bản PHP : 7.2, 7.1, 7.0, 5.6, 5.5 hoặc 5.4 . VPSSIM tự động config tối ưu PHP tùy theo cấu hình VPS và thay bạn có thể thay đổi PHP version thoải mái trong quá trình sử dụng.
#### - Loại bỏ memcached trong quá trình cài đặt mặc định, cái này ai thấy cần thiết thì cài thêm là được.
#### - Loại bỏ CSF trong quá trình cài đặt mặc định, về cơ bản thì CSF khá tốn RAM, ai có VPS hoặc server RAM khỏe thì bấm cài thêm thủ công.
#### - Còn lại hầu hết các tính năng vẫn được giữ nguyên hoặc chưa có thời gian chỉnh sửa, bổ sung...
