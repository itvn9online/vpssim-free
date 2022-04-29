## Diễn Đàn Hỗ Trợ Và Xử Lý Bug: 
### [https://www.facebook.com/groups/wordpresseb](https://www.facebook.com/groups/wordpresseb)

ECHBAY-VPSSIM là bản chỉnh sửa lại từ VPSSIM-3.8.1, đây là phiên bản cuối cùng của VPSSIM mà mình clone lại được trước khi VPSSIM tiến hành mã hóa và thương mại hóa.
Cơ bản thì trong phiên bản ECHBAY-VPSSIM mình chủ yếu cập nhật lại một số phiên bản phần mềm trong cài đặt mặc định lên bản mới và ổn định nhất cho phù hợp với thời điểm 2020 và hỗ trợ các hệ điều hành mới hơn như CentOS 7 & 8 thay vì tập trung vào CentOS 6 như phiên bản gốc.

### Lệnh Cài Đặt ECHBAY-VPSSIM Trên Centos 6 & 7 & 8 (Without SELinux):
```
bash <( curl -k https://raw.githubusercontent.com/itvn9online/vpssim-free/master/install )
```

### Lệnh Cài Đặt yum-cron (auto update system) Trên Centos 6 & 7 & 8:
```
bash <( curl -k https://raw.githubusercontent.com/itvn9online/vpssim-free/master/script/yum-cron-setup )
```

----------------------------------------------

### Phiên bản hệ điều hành khuyên dùng:
- [x] **`CentOS 7 x64` Khuyên dùng để cho hiệu suất tốt nhất. Mã nguồn ECHBAY-VPSSIM hiện tại đang phát triển chính trên CentOS 7 x64.**
- [ ] `CentOS 8 x64` MỚI và đang thử nghiệm. Tương lai gần ECHBAY-VPSSIM cũng sẽ phát triển song song cả trên CentOS 8 x64, hiện tại mới đang thử nghiệm.
- [ ] `CentOS 6 x64` VPSSIM được phát triển trên phiên bản CentOS 6 x64, do ECHBAY-VPSSIM kế thừa mã nguồn của VPSSIM nên ECHBAY-VPSSIM cũng hoạt động tốt trên CentOS 6 x64, nên nếu có yêu cầu bắt buộc phải dùng CentOS 6 thì bạn có thể hoàn toàn yên tâm sử dụng, chỉ là về lâu dài thì các phiên bản cũ sẽ trờ nên lỗi thời, nên ECHBAY-VPSSIM chỉ phát triển từ CentOS 7 & 8.

----------------------------------------------

### Danh sách các phiên bản kết hợp đã qua quá trình cài đặt thử nghiệm thành công:
> Với `CentOS 6 x64` đã chạy thực nghiệm từ nhiều năm nay và cho kết quả ổn định, nên ở mục này chủ yếu thống kê cho phiên bản CentOS 7 & 8 và ECHBAY-VPSSIM cũng chỉ hỗ trợ phiên bản x64 chứ không hỗ trợ x32 như VPSSIM bản gốc.

> 2022/04/29
- [x] CentOS-**7** x64 && Nginx-1.20.2 + OpenSSL-1.1.1n + Prce-8.45 + Zlib-1.2.12 && PHP-7.4
- [x] **MariaDB-10.2** --- Cấu hình khuyên dùng ---------------------------------------------------

> 2020/09/14
- [x] CentOS-**7** x64 && Nginx-1.18.0 + OpenSSL-1.1.1i + Prce-8.44 + Zlib-1.2.11 && PHP-7.4
- [x] **MariaDB-10.2**

> 2020/09/15
- [x] CentOS-**7** x64 && Nginx-1.18.0 + OpenSSL-1.1.1i + Prce-8.44 + Zlib-1.2.11 && PHP-7.4
- [x] **MariaDB-10.4**

> 2020/09/15
- [x] CentOS-**7** x64 && Nginx-1.18.0 + OpenSSL-1.1.1i + Prce-8.44 + Zlib-1.2.11 && PHP-7.4
- [ ] **MariaDB-10.5**

> 2020/09/14
- [x] CentOS-**7** x64 && Nginx-1.18.0 + OpenSSL-1.1.1i + Prce-8.44 + Zlib-1.2.11 && PHP-7.4
- [x] **MariaDB-10.1**

> 2020/09/14
- [x] CentOS-**7** x64 && Nginx-1.18.0 + OpenSSL-1.1.1i + Prce-8.44 + Zlib-1.2.11 && PHP-7.4
- [x] **MariaDB-10.3**

----------------------------------------------

> 2020/09/19
- [x] CentOS-**8** x64 && Nginx-1.18.0 + OpenSSL-1.1.1i + Prce-8.44 + Zlib-1.2.11 && PHP-7.4
- [x] **MariaDB-10.3**

> 2020/09/19
- [x] CentOS-**8** x64 && Nginx-1.18.0 + OpenSSL-1.1.1i + Prce-8.44 + Zlib-1.2.11 && PHP-7.4
- [ ] **MariaDB-10.4**

> 2020/09/19
- [x] CentOS-**8** x64 && Nginx-1.18.0 + OpenSSL-1.1.1i + Prce-8.44 + Zlib-1.2.11 && PHP-7.4
- [ ] **MariaDB-10.5**

----------------------------------------------

### Loại bỏ phiên bản MariaDB 10.0 và MariaDB 5.5
> 2020/10/19
Lâu không dùng 2 bản cũ kia, mà nọ có việc nên xem lại câu lệnh từ phiên bản đó thấy nó cổ lỗ sĩ hơn cả MySQL nên mình quyết định loại bỏ thẳng tay luôn

### Varnish Cache
> 2020/09/11
#### Thêm chức năng cài đặt Varnish Cache: https://packagecloud.io/varnishcache/
#### Ngoài việc sử dụng ECHBAY-VPSSIM làm VPS chạy website thông thường, giờ đây bạn cũng có thể sử dụng để làm VPS chạy Varnish Cache rất tiện dụng. Hiện tại mình đang chạy thành công trên Varnish 4.1, bản 6.xx mới hơn chút xíu nhưng mình chưa thử nghiệm ngon lành, nên khuyên dùng vẫn là Varnish 4.1
#### Mã thực thi: https://github.com/itvn9online/vpssim-free/tree/master/script/vpssim/menu/varnish
> Cách sử dụng: Trong VPSSIM menu -> 25) Tien ich - Addons -> 23) Varnish Cache -> Chọn phiên bản Varnish mà bạn muốn cài đặt
#### Không nên sử dụng VPS vừa làm VPS cache vừa làm VPS chạy web để tránh các xung đột không cần thiết.

----------------------------------------------

### OpenSSL
> 2020/09/01
#### Cập nhật OpenSSL lên bản mới nhất và build nginx từ bản này: https://linuxscriptshub.com/update-openssl-1-1-0-centos-6-9-7-0/
#### Mã thực thi: https://github.com/itvn9online/vpssim-free/blob/master/script/vpssim/menu/nang-cap-openssl
> Cách sử dụng: Trong VPSSIM menu -> 26) Update System -> 7) Thay phien phien ban OpenSSL

----------------------------------------------

### Nginx
> 2020/09/01
#### Nguồn cài đặt: https://github.com/itvn9online/vpssim-free/blob/master/script/vpssim/nginx-setup.conf
- Cài đặt nginx-1.18.0, đây là phiên bản ổn định và mới nhất của nginx tính đến thời điểm hiện tại, kết hợp với OpenSSL-1.1.1i thay cho bản openssl cũ của VPSSIM, phiên bản này mới hỗ trợ đầy đủ HTTP/2.
	- Phiên bản nginx được xem và cập nhật tại: http://nginx.org/en/download.html . Mặc định mình chỉ chọn phiên bản Stable version, các bản Mainline là đang phát triển nên không chọn.
	- Chuyển sang sử dụng OpenSSL-1.1.1i, đây cũng là bản openssl mới nhất hiện nay. Hỗ trợ HTTP/2 hoàn chỉnh, TLSv1.3 và rất nhiều cải tiến khác so với các bản tiền nhiệm. Các phiên bản OpenSSL khác có thể xem thêm tại đây: https://www.openssl.org/source/
	- https://ftp.pcre.org/pub/pcre/ -> dùng bản 8.44 thay cho bản 8.39 của VPSSIM.
	- https://www.zlib.net/ -> dùng bản 1.2.11 thay cho bản 1.2.8 của VPSSIM.

----------------------------------------------

### PHP MyAdmin
> 2021/06/05
#### Download: https://www.phpmyadmin.net/downloads/

----------------------------------------------

> 2020/08/29
#### Loại bỏ phiên bản MariaDB 5 do có vẻ nó đã lỗi thời, với lại mấy năm nay mình dùng bản MariaDB 10 thấy rất ổn định nên cũng khuyên dùng.

----------------------------------------------

> 2020/08/27
- Cho bạn lựa chọn MariaDB phiên bản 10.3, 10.2, 10.1, 10.0 và bản 5.5 thay vì bản 10.0 và 5.5 mặc định của VPSSIM. Tự động config phù hợp với cấu hình server.
- Lựa chọn 6 phiên bản PHP : 7.2, 7.1, 7.0, 5.6, 5.5 hoặc 5.4 . VPSSIM tự động config tối ưu PHP tùy theo cấu hình VPS và thay bạn có thể thay đổi PHP version thoải mái trong quá trình sử dụng.
- Loại bỏ memcached trong quá trình cài đặt mặc định, cái này ai thấy cần thiết thì cài thêm là được. Giờ Server/ VPS thường thuê là hàng chạy ổ SSD cũng rất nhanh, nên mình dùng Cache trên ổ cứng cho nó kinh tế hơn nhiều mà tốc độ tải không chậm hơn so với RAM là bao nhiêu.
- Loại bỏ CSF trong quá trình cài đặt mặc định, về cơ bản thì CSF khá tốn RAM, ai có VPS hoặc server RAM khỏe thì bấm cài thêm thủ công. Sau khi cài xong VPS các bạn nên đổi SSH port đi, điều này cũng tránh được khá nhiều phiền toái cho VPS mà lại nhẹ. Đổi SSH port bằng cách vào menu số 25) Tien ich - Addons -> 13) Thay Doi Port SSH Number.
- Còn lại hầu hết các tính năng vẫn được giữ nguyên hoặc chưa có thời gian chỉnh sửa, bổ sung...

----------------------------------------------

### Giới thiệu!
#### Về cơ bản thì ECHBAY-VPSSIM được hình thành do thời gian gần đây VPSSIM rất ít cập nhật và sử dụng những phần mềm quan trọng nhưng lại rất cũ so với thời đại. Ngoài ra, trong quá trình cài đặt và sử dụng có lỗi thì tác giả cũng rất lâu mới sửa, việc liên hệ với tác giả cũng rất khó nên mình quyết định từ bỏ bản mới nhất của tác giả là 4.6 để quay lại với phiên bản cũ hơn, ít tính năng hơn nhưng hầu hết những cái cần thiết với mình đều đã có.
#### Quan trọng nhất thì bản VPSSIM-3.8.1 này là bản chưa mã hóa nên mình có thể xem mã nguồn và chỉnh sửa được nó theo ý muốn, theo kiến thức mà mình đã có.
### Cách cài đặt:
#### Cũng được mình thay đổi bằng cách cài đặt từ https://github.com/itvn9online/vpssim-free thay vì download từ nhiều nguồn khác nhau như VPSSIM. Thêm nữa khi up code lên github thì cũng có cái nhìn trực quan hơn, mọi người sẽ dễ dàng tham khảo và góp ý các thay đổi hơn cho đúng chuẩn mã nguồn mở.

### Liên hệ:
#### Facebok: https://www.facebook.com/ech.bay/
#### Email: itvn9online@yahoo.com
#### Website: https://echbay.com/
#### [Mã HTML cho tệp README.md](https://docs.github.com/en/github/writing-on-github/basic-writing-and-formatting-syntax)
