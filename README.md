## Diễn Đàn Hỗ Trợ Và Xử Lý Bug: 
### [https://www.facebook.com/groups/wordpresseb](https://www.facebook.com/groups/wordpresseb)

ECHBAY-VPSSIM là bản chỉnh sửa lại từ VPSSIM-3.8.1, đây là phiên bản cuối cùng của VPSSIM mà mình clone
lại được trước khi VPSSIM tiến hành mã hóa và thương mại hóa.
Cơ bản thì trong bản VPSSIM mình chỉnh sửa lại cũng không có gì đặc biệt, chủ yếu tinh chỉnh lại một số
phiên bản phần mềm cho phù hợp với thời điểm 2020, tránh tình trạng cổ lỗ sĩ quá.

### Lệnh Cài Đặt ECHBAY-VPSSIM Trên Centos 6 & 7:
```
curl -sO https://vpssim.echbay.com/install && bash install
```
#### Hoặc lệnh
```
yum -y install wget ; wget --no-check-certificate https://vpssim.echbay.com/install ; chmod +x install ; bash install
```

### Chức Năng, Tiện Ích Và Tối Ưu VPS Của ECHBAY-VPSSIM:
#### - Cài đặt nginx-1.18.0, đây là phiên bản ổn định và mới nhất của nginx tính đến thời điểm tháng 08-2020, kết hợp với openssl-1.0.2s thay cho bản openssl cũ của VPSSIM, phiên bản này mới hỗ trợ đầy đủ HTTP/2.
##### + Phiên bản nginx được xem và cập nhật tại: http://nginx.org/en/download.html . Mặc định mình chỉ chọn phiên bản Stable version, các bản Mainline là đang phát triển nên không chọn.
##### + Openssl hiện mình mới chỉ cài được bản 1.0.2s, đây là bản cũ nhưng vẫn hỗ trợ HTTP/2, thay cho bản 1.0.2l trên VPSSIM. Các phiên bản OpenSSL khác có thể xem thêm tại đây: https://www.openssl.org/source/
##### + https://ftp.pcre.org/pub/pcre/ -> dùng bản 8.43 thay cho bản 8.39 của VPSSIM.
##### + https://www.zlib.net/ -> dùng bản 1.2.11 thay cho bản 1.2.8 của VPSSIM.

#### - Cho bạn lựa chọn MariaDB phiên bản 10.3, 10.2, 10.1, 10.0 và bản 5.5 thay vì bản 10.0 và 5.5 mặc định của VPSSIM. Tự động config phù hợp với cấu hình server.
#### - Lựa chọn 6 phiên bản PHP : 7.2, 7.1, 7.0, 5.6, 5.5 hoặc 5.4 . VPSSIM tự động config tối ưu PHP tùy theo cấu hình VPS và thay bạn có thể thay đổi PHP version thoải mái trong quá trình sử dụng.
#### - Loại bỏ memcached trong quá trình cài đặt mặc định, cái này ai thấy cần thiết thì cài thêm là được. Giờ Server/ VPS thường thuê là hàng chạy ổ SSD cũng rất nhanh, nên mình dùng Cache trên ổ cứng cho nó kinh tế hơn nhiều mà tốc độ tải không chậm hơn so với RAM là bao nhiêu.
#### - Loại bỏ CSF trong quá trình cài đặt mặc định, về cơ bản thì CSF khá tốn RAM, ai có VPS hoặc server RAM khỏe thì bấm cài thêm thủ công. Sau khi cài xong VPS các bạn nên đổi SSH port đi, điều này cũng tránh được khá nhiều phiền toái cho VPS mà lại nhẹ. Đổi SSH port bằng cách vào menu số 25) Tien ich - Addons -> 13) Thay Doi Port SSH Number.
#### - Còn lại hầu hết các tính năng vẫn được giữ nguyên hoặc chưa có thời gian chỉnh sửa, bổ sung...

### Có gì mới!
#### Nói chung là cũng không có quá nhiều cái mới, hầu hết những gì VPSSIM cung cấp mình thấy rất ổn định và dễ sử dụng, ngoài mấy phần mềm cũ so với thời thế thì mình thay bằng bản mới hơn.
#### Cách cài đặt: cũng được mình thay đổi bằng cách cài đặt từ https://github.com/itvn9online/vpssim-free thay vì download từ nhiều nguồn khác nhau như VPSSIM. Thêm nữa khi up code lên github thì cũng có cái nhìn trực quan hơn, mọi người sẽ dễ dàng tham khảo và góp ý các thay đổi hơn cho đúng chuẩn mã nguồn mở.