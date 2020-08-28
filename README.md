## Diễn Đàn Hỗ Trợ Và Xử Lý Bug: 
### [https://www.facebook.com/groups/wordpresseb](https://www.facebook.com/groups/wordpresseb)

ECHBAY-VPSSIM là bản chỉnh sửa lại từ VPSSIM-3.8.1 (phiên bản này được VPSSIM update vào lúc 2016-02-18 01:30:09) với một số điểm tinh chỉnh lại cho phù hợp với thời điểm 2020.

### Lệnh Cài Đặt ECHBAY-VPSSIM Trên Centos 6 & 7:
```
yum -y install wget ; wget --no-check-certificate https://vpssim.echbay.com/install ; chmod +x install ; bash install
```

Chức Năng, Tiện Ích Và Tối Ưu VPS Của ECHBAY-VPSSIM:
	- Cài đặt nginx-1.18.0, đây là phiên bản ổn định và mới nhất của nginx, kết hợp với openssl-1.0.2s thay cho bản openssl cũ của VPSSIM, giúp tối ưu sức mạnh của HTTP2.
		+ Nginx new version: http://nginx.org/en/download.html
		+ openssl version: https://www.openssl.org/source/
		+ https://ftp.pcre.org/pub/pcre/
		+ https://www.zlib.net/
	- Cho bạn lựa chọn MariaDB phiên bản 10.0, 10.1, 10.2 & 10.3 và tự động config phù hợp với cấu hình server.
	- Lựa chọn 6 phiên bản PHP : 7.2, 7.1, 7.0, 5.6, 5.5 hoặc 5.4 . VPSSIM tự động config tối ưu PHP tùy theo cấu hình VPS và thay bạn có thể thay đổi PHP version thoải mái trong quá trình sử dụng.
	- Loại bỏ memcached trong quá trình cài đặt mặc định, cái này ai thấy cần thiết thì cài thêm là được.
	- Loại bỏ CSF trong quá trình cài đặt mặc định, về cơ bản thì CSF khá tốn RAM, ai có VPS hoặc server RAM khỏe thì bấm cài thêm thủ công.
	- Còn lại hầu hết các tính năng vẫn được giữ nguyên hoặc chưa có thời gian chỉnh sửa, bổ sung...
