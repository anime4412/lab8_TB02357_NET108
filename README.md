# 📚 LAB 8 — TÀI LIỆU KỸ THUẬT & HƯỚNG DẪN TRIỂN KHAI HỆ THỐNG THƯ VIỆN ĐIỆN TỬ

- **Môn học:** Dự án .NET 1 (`NET108` / `SOF1022`)
- **Sinh viên thực hiện:** `TB02357` — **Nhóm 5**
- **Đề tài:** Hệ thống Quản lý Thư viện Điện tử (Library Management System)
- **Kiến trúc:** ASP.NET Core MVC + Entity Framework Core (Code First) + SQL Server 2022

## 📁 Thành phần trong thư mục bàn giao
1. [`BAOCAO_LAB8_TB02357_NET108.docx`](./BAOCAO_LAB8_TB02357_NET108.docx) — Báo cáo Word đầy đủ 5 phần của Lab 8.
2. [`BAOCAO_LAB8_TB02357_NET108.md`](./BAOCAO_LAB8_TB02357_NET108.md) — Tài liệu kỹ thuật đầy đủ định dạng Markdown.
3. [`appsettings.Production.example.json`](./appsettings.Production.example.json) — Mẫu cấu hình môi trường Production (không chứa thông tin nhạy cảm).
4. [`publish_deploy.ps1`](./publish_deploy.ps1) — Script PowerShell hỗ trợ Build & Publish bản Release triển khai lên Server/VPS.
5. [`lab8_TB02357_NET108.zip`](./lab8_TB02357_NET108.zip) — File nén nộp LMS.

## 🚀 Tóm tắt các bước triển khai nhanh lên Server
```bash
# 1. Áp dụng EF Core Code First Migration tạo CSDL & Seed Data
dotnet ef database update

# 2. Đóng gói bản Release
dotnet publish -c Release -o ./publish

# 3. Chạy trên Kestrel / IIS / Nginx Reverse Proxy
cd publish
dotnet SOF1022_NHOM1_SD2003_Ver2.dll --urls "http://0.0.0.0:5000"
```
