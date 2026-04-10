# 📱 Android ROM Settings Extractor

*Đọc bằng [English](README.md)*

Một công cụ tinh gọn giúp tự động trích xuất ứng dụng `Settings.apk` từ các bản ROM Android định dạng tải OTA (Payload). Dự án mang đến **2 phương thức hoạt động song song**: một bản chạy qua **Docker** cho hệ sinh thái Linux và một bản chạy trực tiếp môi trường **Native Windows (PowerShell)** cực kỳ thân thiện với người dùng máy tính không chuyên. 

## ✨ Tính Năng Nổi Bật

- Hỗ trợ độc lập cho cả 2 nền tảng: **Thuần Windows** hoặc **Cỗ máy ảo Docker**. 
- Tự động quét và xẻ thịt ROM `.zip` để lấy `payload.bin`.
- Tự động giải nén và cắt phân vùng hệ thống `system_ext.img`.
- **Tự động tải Engine:** Công cụ `payload-dumper-go` sẽ được tự động tải về bổ sung nếu trên máy Windows gốc chưa tồn tại.
- Rút file `Settings.apk` ra và tự động đổi tên bài bản theo chuẩn ngay trên tên ROM truyền vào: `Settings_{codename}_from_{version}.apk` 
- Hệ thống thông minh tự dọn rác phân vùng ảo vài chục GB lập tức ngay sau khi trích xuất nhằm giải nguy cho ổ cứng của bạn.

---

## 🚀 CÁCH 1: GIẢI NÉN THUẦN TRÊN WINDOWS NATIVE (KHUYÊN DÙNG)

Phương thức này ép hệ thống PowerShell của Windows kết hợp với sức mạnh của **7-Zip** làm việc, bạn hoàn toàn **không cần Docker** hay kiến thức máy ảo, không lo việc đầy dung lượng ổ C đột ngột.

### 🛠️ Yêu Cầu
- Máy dùng Windows 10/11 có sẵn Windows PowerShell.
- **Bắt buộc** có phần mềm [7-Zip](https://www.7-zip.org/download.html) đã cài trên máy (Phải nằm trong vị trí mặc định `C:\Program Files\7-Zip`).

### ⚙️ Cách Chạy (Chỉ 1 lệnh)
1. Hãy ném file hệ điều hành ROM `.zip` của bạn vào cùng thư mục này (không giải nén).
2. Mở Terminal / PowerShell và dọn thẳng dòng lệnh sau để uỷ quyền tự động 100%:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\extract.ps1
```
*(💡 Mẹo: Nếu bạn đang gõ lệnh từ cửa sổ của phần mềm Git Bash, hãy chú ý đổi chiều thanh gạch chéo thành `./extract.ps1` nha)*

Toàn bộ quá trình cắt ROM -> Load tool -> Lấy APK sẽ chạy và lưu APK thành quả vào mục `settings_apks/`. Rác đệm sẽ tự được xoá.

---

## 🐋 CÁCH 2: GIẢI NÉN QUA DOCKER (DÀNH CHO DÂN CHUYÊN LINUX/WSL2)

Sử dụng môi trường cách ly mạnh mẽ để tránh xả rác phần mềm lên máy chủ.

### 🛠️ Yêu Cầu
1. Cần cài đặt **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** (Bật backend WSL2).
2. Lệnh tắt tiện ích **Make** (Sẵn có trên Git Bash, Linux/macOS).

### ⚙️ Cách Chạy
1. Vẫn đặt file `.zip` chung thư mục này.
2. Build và tạo nền kiến trúc image chạy ẩn (Chỉ gõ lần đầu):
   ```bash
   make build
   ```
3. Khởi lệnh cho máy tuốt tự động đi tìm file zip và trích xuất:
   ```bash
   make extract
   ```
   *(Nếu thư mục có quá nhiều gói `.zip`, chỉ đích danh nó: `make extract ROM=tên_file.zip`)*.

---

## 🧹 Cứu Hộ Máy Tính & Fix Tràn Ổ C (Cho người dùng Docker)

Việc chạy Docker trên Windows để xả ổ đĩa ảo dễ khiến file trung gian `ext4.vhdx` của hệ điều hành Windows phình lên cực lớn nhưng không xẹp đi.

Nắm trọn bí kíp sau để dọn dẹp nhà cửa:

- **1. Xoá mọi rác tàn hình, tàn dư sau khi bóc ROM (giữ lại Apk):**
  ```bash
  make clean
  ```

- **2. Nhả lại toàn bộ Cấu hình Cache bị Docker ép chiếm:**
  ```bash
  make prune
  ```
  Tắt nóng toàn bộ lõi nhân WSL2 để ép Windows trả lại RAM:
  ```bash
  make shutdown
  ```

> ⚠️ **Bí kíp DiskPart thần thánh bóp ổ C**:
> Nếu ổ C của bạn thất thoát kịch liệt vài chục GB, hãy mở PowerShell bằng **Quyền Administrator**, gõ `diskpart` > Gõ chọn file `select vdisk file="đường/dẫn/đến/ext4.vhdx"` > Gõ khoá ổ cứng bằng lệnh `attach vdisk readonly` > Và cuối cùng gõ lệnh vắt kiệt mỡ: `compact vdisk`. Ổ máy tính của bạn sẽ rộng thênh thang trở lại.
