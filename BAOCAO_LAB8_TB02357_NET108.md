# BÁO CÁO THỰC HÀNH LAB 8: TÀI LIỆU KỸ THUẬT & TRIỂN KHAI HỆ THỐNG WEB C#
**MÔN HỌC: DỰ ÁN .NET 1 (NET108 / SOF1022)**  
**LỚP: DỰ ÁN 1 — NHÓM THỰC HIỆN: NHÓM 5**  
**MÃ SINH VIÊN: TB02357**  
**ĐỀ TÀI: HỆ THỐNG QUẢN LÝ THƯ VIỆN ĐIỆN TỬ (LIBRARY MANAGEMENT SYSTEM)**  

---

## MỤC TIÊU BÀI THỰC HÀNH LAB 8
1. Hiểu rõ vai trò và tầm quan trọng của tài liệu kỹ thuật trong vòng đời phát triển phần mềm.
2. Xây dựng bộ tài liệu kỹ thuật chuẩn chỉnh cho dự án Web C# (ASP.NET Core MVC + EF Core Code First).
3. Trình bày tường minh kiến trúc hệ thống (Client–Server, MVC, Dependency Injection), danh mục công nghệ và cấu trúc mã nguồn.
4. Thực hiện đầy đủ quy trình cài đặt, cấu hình, triển khai (Deploy) ứng dụng Web C# lên Server/VPS (IIS / Linux Nginx) và kiểm tra vận hành.
5. Nhận thức các vấn đề vận hành, sao lưu (Backup), bảo mật (HTTPS, User Secrets, Anti-CSRF) và bảo trì hệ thống; ứng dụng AI để rà soát lỗi tài liệu kỹ thuật.

---

## BÀI 1 (3 ĐIỂM): PHÂN TÍCH VÀ LẬP DANH MỤC TÀI LIỆU KỸ THUẬT

### 1. Xác định đối tượng đọc tài liệu kỹ thuật của dự án
* **Quản lý dự án (Project Manager / Giảng viên hướng dẫn)**: Đọc để nắm bức tranh tổng thể, phạm vi chức năng, kiến trúc tổng quan và tiến độ hoàn thiện kỹ thuật.
* **Lập trình viên phát triển mới / Bảo trì (Backend & Frontend Developers)**: Đọc để hiểu kiến trúc MVC, `LibraryDbContext` Code First, các Service/DAL, quy ước đặt tên code để mở rộng tính năng hoặc sửa lỗi nhanh chóng.
* **Kỹ sư kiểm thử (QA / Tester)**: Đọc để hiểu luồng dữ liệu, quy tắc nghiệp vụ, ràng buộc CSDL và phân quyền nhằm thiết kế Test Plan & Test Case chính xác.
* **Kỹ sư vận hành / Quản trị hệ thống (DevOps / SysAdmin / Thủ thư IT)**: Đọc để nắm yêu cầu phần mềm, cách cấu hình Connection String, SMTP, chạy Migration và triển khai ứng dụng lên Windows IIS hoặc Linux VPS.

### 2. Danh mục tài liệu kỹ thuật cần có & Mục tiêu từng loại tài liệu

| STT | Tên loại tài liệu kỹ thuật | Đối tượng đọc chính | Mục tiêu & Nội dung cốt lõi |
| :--- | :--- | :--- | :--- |
| 1 | **Tài liệu Tổng quan Hệ thống** (*System Overview Document*) | PM, Giảng viên, BA, Toàn bộ nhóm | Xác định mục tiêu nghiệp vụ, phạm vi chức năng, các nhóm người dùng (`Admin`, `Librarian`, `Reader`) và luồng hoạt động nghiệp vụ thư viện từ đầu đến cuối. |
| 2 | **Tài liệu Kiến trúc Hệ thống** (*Software Architecture Document*) | Tech Lead, Developers, QA | Mô tả mô hình Client–Server, kiến trúc ASP.NET Core MVC 3 lớp + DI, luồng xử lý Request/Response, cấu trúc thư mục source code và các nguyên tắc thiết kế bảo mật. |
| 3 | **Tài liệu Thiết kế CSDL** (*Database Design / ERD & Code First Spec*) | Backend Dev, DBA, QA | Mô tả sơ đồ ERD Level 1 & Level 2, cấu hình `LibraryDbContext` (Fluent API, Unique Index, `DeleteBehavior`), lịch sử EF Core Migrations và dữ liệu khởi tạo (`HasData`). |
| 4 | **Tài liệu Cài đặt & Triển khai** (*Installation & Deployment Guide*) | DevOps, SysAdmin, Developers | Liệt kê yêu cầu môi trường (.NET Hosting Bundle, SQL Server), các bước cấu hình `appsettings.Production.json`, chạy `dotnet ef database update`, `dotnet publish` và kiểm thử sau triển khai. |
| 5 | **Tài liệu Vận hành, Bảo mật & Bảo trì** (*Operations & Maintenance Runbook*) | SysAdmin, Bảo trì hệ thống | Hướng dẫn sao lưu định kỳ SQL Server, xoay vòng mật khẩu/API key, theo dõi log lỗi, chính sách phân quyền Cookie/RBAC và khắc phục sự cố thường gặp. |

---

## BÀI 2 (2 ĐIỂM): GIỚI THIỆU DỰ ÁN VÀ KIẾN TRÚC HỆ THỐNG

### 1. Giới thiệu dự án
* **Tên dự án**: **Hệ thống Quản lý Thư viện Điện tử** (*Electronic Library Management System — SOF1022 / NET108*).
* **Mục tiêu nghiệp vụ**: Số hóa toàn diện quy trình nghiệp vụ của thư viện truyền thống: quản lý kho sách đa chiều (Thể loại, Tác giả, NXB, Kệ sách), quản lý thẻ bạn đọc, xử lý lưu thông mượn/trả/đặt trước, tính phí phạt trễ hạn tự động, theo dõi doanh thu và hỗ trợ bạn đọc tra cứu sách trực tuyến.
* **Phạm vi chức năng chính**:
  - *Cổng Độc giả (Reader Portal)*: Đăng ký/Đăng nhập, tra cứu & lọc sách, xem lịch sử đọc/yêu thích/đánh giá, đặt trước sách, gửi phiếu hỗ trợ (`SupportTickets`), AI Chatbot tra cứu sách.
  - *Bảng điều khiển Thủ thư & Quản trị (Admin/Staff Dashboard)*: CRUD Sách, Thể loại, Tác giả, NXB, Kệ sách, Độc giả, Nhân viên; Quầy lập & xử lý Phiếu mượn trả (`BorrowSlips`); Quản lý tiền phạt (`Fines`); Phân quyền RBAC chi tiết; Thống kê doanh thu & Top sách bằng biểu đồ Chart.js; Xuất báo cáo Excel (`ClosedXML`).
* **Đối tượng sử dụng**:
  1. **Quản trị viên (`Admin`)**: Toàn quyền cấu hình hệ thống, quản lý nhân viên, phân quyền, xem thống kê tài chính và phê duyệt hóa đơn.
  2. **Thủ thư (`Librarian`)**: Thực hiện nghiệp vụ mượn/trả sách tại quầy, tra cứu danh mục, xử lý đặt giữ chỗ và hỗ trợ bạn đọc.
  3. **Độc giả (`Reader`)**: Tìm kiếm sách, xem sách khả dụng, đặt trước sách, theo dõi lịch sử mượn trả và thời hạn thẻ.
* **Tổng quan luồng hoạt động hệ thống**:
  ```text
  [Người dùng / Trình duyệt] ──(HTTPS Request)──▶ [ASP.NET Core Routing & Auth Middleware]
                                                               │
                                                  (Kiểm tra Cookie / Policy)
                                                               ▼
  [SQL Server 2022] ◀──(EF Core Code First / LINQ)── [Service / DAL Layer] ◀── [Controller]
         │                                                                          │
         └──────────────(Dữ liệu Entity / ViewModel)────────────────────────────────▼
                                                                             [Razor View .cshtml]
                                                                                    │
                                                                            (HTML + Chart.js + BS5)
                                                                                    ▼
                                                                           [Hiển thị trên Trình duyệt]
  ```

### 2. Kiến trúc hệ thống
* **Mô hình Client – Server**:
  - **Client (Presentation Tier)**: Trình duyệt web (Chrome, Edge, Safari) tải giao diện HTML5, CSS3, Bootstrap 5, JavaScript và biểu đồ Chart.js. Gửi HTTP/HTTPS Request và nhận phản hồi từ Server.
  - **Application Server (Logic Tier)**: Chạy trên nền **.NET Kestrel Web Server** (đứng sau Reverse Proxy **IIS** hoặc **Nginx**). Tiếp nhận Request qua Pipeline Middleware (HTTPS Redirection, Static Files, Routing, Authentication, Authorization), xử lý logic nghiệp vụ và kết xuất Razor View.
  - **Database Server (Data Tier)**: **Microsoft SQL Server 2022** lưu trữ toàn bộ bảng dữ liệu được quản lý phiên bản thông qua **EF Core Code First Migrations**.
* **Mô hình MVC kết hợp phân tầng Dịch vụ (Service/DAL) & Dependency Injection**:
  - Tách biệt rõ: **Model** (Entity + ViewModel) $\leftrightarrow$ **View** (Razor `.cshtml`) $\leftrightarrow$ **Controller** (điều phối Request) $\leftrightarrow$ **Service / DAL** (xử lý nghiệp vụ & truy xuất `LibraryDbContext`).
* **Các nguyên tắc thiết kế áp dụng**:
  - *Separation of Concerns (SoC)*: Controller không chứa câu truy vấn SQL thô hay logic tính toán phức tạp; giao hết cho Service/DAL và DbContext.
  - *Dependency Injection (DI)*: Đăng ký `AddDbContext` và `AddScoped<Service/DAL>` trong `Program.cs` giúp dễ kiểm thử (Unit Test với EF Core InMemory ở Lab 7).
  - *Code First & Migrations*: Mọi thay đổi cấu trúc CSDL đều được theo dõi qua code C# và Migration snapshot.
  - *Defense-in-Depth Security*: Bảo vệ bằng Cookie `HttpOnly`, `[Authorize(Policy = "...")]`, `[ValidateAntiForgeryToken]` chống CSRF và Data Annotations validation.

---

## BÀI 3 (2 ĐIỂM): MÔ TẢ CÔNG NGHỆ VÀ CẤU TRÚC SOURCE CODE

### 1. Danh sách công nghệ sử dụng trong dự án

| Thành phần | Công nghệ lựa chọn | Vai trò & Phiên bản |
| :--- | :--- | :--- |
| **Ngôn ngữ lập trình** | **C#** (C# 12 / C# 14), HTML5, CSS3, JavaScript (ES6) | Ngôn ngữ chính phía Backend (.NET) và Frontend (Razor + JS). |
| **Framework / Công nghệ Web** | **ASP.NET Core MVC** (.NET 8.0 LTS / .NET 10.0) & **Entity Framework Core** | Framework xây dựng Web App MVC và ORM Code First thao tác CSDL. |
| **Application Server** | **Kestrel** (tích hợp sẵn trong .NET) kết hợp **IIS** (Windows) hoặc **Nginx** (Linux) | Máy chủ chạy ứng dụng .NET hiệu năng cao, hỗ trợ Reverse Proxy & SSL. |
| **Cơ sở dữ liệu (Database)** | **Microsoft SQL Server 2022** (và **EF Core InMemory** cho Unit Test) | Hệ quản trị CSDL quan hệ lưu trữ toàn bộ dữ liệu thư viện. |
| **Công cụ & Thư viện hỗ trợ** | Visual Studio 2022, Git/GitHub, **Bootstrap 5**, **Chart.js**, **SignalR**, **ClosedXML**, **xUnit** | Phát triển giao diện, vẽ biểu đồ, chat realtime, xuất Excel và kiểm thử tự động. |

### 2. Cấu trúc Source Code chuẩn theo mô hình ASP.NET Core MVC
*(Đối chiếu trực tiếp từ dự án thực tế `SOF1022_NHOM1_SD2003_Ver2` và chuỗi bài Lab 3–7 Code First)*:

```text
QuanLyThuVien/
├── Controllers/        # Tầng Điều phối (Request Handling): AccountController, BooksController,
│                       # CategoriesController, BorrowSlipsController, EmployeesController, StatisticsController...
├── Services/ & DAL/    # Tầng Nghiệp vụ & Truy xuất Dữ liệu: BorrowService, FineCalculationService,
│                       # EmailService, BookDAL, CategoryDAL, BorrowSlipDAL, StatisticsDAL...
├── Datas/ (Data/)      # Tầng Ánh xạ EF Core Code First: LibraryDbContext.cs (DbSet, Fluent API, HasData)
├── Migrations/         # Tệp Code First Migrations sinh bởi dotnet-ef (InitialCreate.cs, ModelSnapshot.cs)
├── Models/             # Tầng Thực thể & ViewModel: Books, Categories, Readers, BorrowSlips, BorrowDetails,
│                       # Employee, Fines, ViewModels (LoginViewModel, StatisticsViewModel...)
├── Views/              # Tầng Giao diện Razor (.cshtml): Views/Books/, Views/BorrowSlips/, Views/Statistics/,
│                       # Views/Account/, Views/Shared/_Layout.cshtml
├── Helpers/ & Utils/   # Lớp tiện ích dùng chung: FileUtil.cs, BookAvailabilityHelper.cs, PermissionExtensions.cs
├── Hubs/               # SignalR Hubs phục vụ thông báo & hỗ trợ trực tuyến realtime
├── wwwroot/            # Tài nguyên tĩnh (CSS, JS, Bootstrap, ảnh bìa upload tại wwwroot/uploads/)
├── appsettings.json    # Cấu hình ConnectionStrings & SmtpSettings
└── Program.cs          # Điểm khởi chạy ứng dụng, cấu hình DI, DbContext, Cookie Auth & Policies
```

### 3. Các quy ước code quan trọng (Coding Conventions)
* **Quy ước đặt tên (Naming Conventions)**:
  - Tên Class, Method, Property, Controller, ViewModel dùng **PascalCase** (`BorrowSlipsController`, `CreateBorrowSlip`, `AvailableQuantity`).
  - Tên Interface bắt đầu bằng chữ **`I`** (`IBorrowService`, `IEmailService`, `IPermissionService`).
  - Tham số hàm và biến cục bộ dùng **camelCase** (`categoryId`, `searchString`); trường private dùng `_camelCase` (`_context`, `_borrowSlipDal`).
* **Quy chuẩn bảo mật & EF Core**:
  - Mọi Action `POST` thay đổi dữ liệu bắt buộc gắn `[ValidateAntiForgeryToken]` và `[Authorize(Policy = "...")]`.
  - Truy vấn chỉ đọc sử dụng `.AsNoTracking()` để tối ưu bộ nhớ; dùng `.Include()` / `.ThenInclude()` tránh lỗi N+1 Query hoặc `NullReferenceException`.
  - Mọi thông tin mật khẩu DB / SMTP Password không hardcode trong mã nguồn C#, phải đưa vào `appsettings.json` hoặc Biến môi trường / User Secrets.

---

## BÀI 4A (2 ĐIỂM): HƯỚNG DẪN CÀI ĐẶT & TRIỂN KHAI LÊN SERVER / VPS

### 1. Yêu cầu phần mềm (Prerequisites)
* **Môi trường phát triển (Dev)**: .NET 8.0 SDK (hoặc .NET 10 SDK), Visual Studio 2022, SQL Server 2019/2022, Git.
* **Môi trường Server / VPS triển khai (Production)**:
  - *Windows Server + IIS*: Cài đặt **.NET Hosting Bundle** tương ứng phiên bản .NET của dự án và bật tính năng **IIS (Internet Information Services)**.
  - *Linux VPS (Ubuntu 22.04/24.04)*: Cài đặt `aspnetcore-runtime-8.0` (hoặc `10.0`) và **Nginx** làm Reverse Proxy, cấu hình chứng chỉ SSL miễn phí với **Certbot (Let's Encrypt)**.
  - *Database*: SQL Server 2022 (hoặc SQL Server Express / Docker container `mcr.microsoft.com/mssql/server:2022-latest`).

### 2. Các bước cấu hình & Triển khai chi tiết

#### Bước 1: Lấy mã nguồn từ GitHub & Cấu hình thông số Production
```bash
git clone https://github.com/anime4412/<ten-repo>.git
cd QuanLyThuVien
```
Tạo tệp `appsettings.Production.json` (tham khảo mẫu chuẩn tại [`appsettings.Production.example.json`](./appsettings.Production.example.json)) để ghi đè chuỗi kết nối SQL Server thật và tài khoản SMTP:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=SQL_SERVER_IP;Database=QuanLyThuVien;User Id=sa;Password=YOUR_STRONG_PASSWORD;TrustServerCertificate=True;"
  },
  "SmtpSettings": {
    "Host": "smtp.gmail.com",
    "Port": 587,
    "SenderEmail": "noreply@thuvien.edu.vn",
    "Password": "YOUR_APP_PASSWORD"
  }
}
```

#### Bước 2: Khởi tạo Cơ sở Dữ liệu bằng EF Core Code First
```bash
# Kiểm tra tool dotnet-ef và đẩy toàn bộ Migration + Seed Data lên SQL Server
dotnet ef database update
```

#### Bước 3: Biên dịch & Đóng gói bản phát hành (`Release`)
*(Có thể chạy trực tiếp script [`publish_deploy.ps1`](./publish_deploy.ps1) đã đính kèm)*:
```bash
dotnet restore
dotnet build -c Release
dotnet publish -c Release -o ./publish
```

#### Bước 4: Cấu hình chạy trên Server / VPS
* **Phương án A — Windows Server + IIS**:
  1. Mở **IIS Manager** $\rightarrow$ Tạo **Application Pool** mới, chọn *.NET CLR version* = **`No Managed Code`**.
  2. Tạo **Website** mới, trỏ *Physical Path* tới thư mục `./publish` vừa xuất, gán cổng `80`/`443` và chứng chỉ SSL.
  3. Cấp quyền `Read & Execute` (và `Modify` cho thư mục `wwwroot/uploads/`) cho tài khoản `IIS_IUSRS`.
* **Phương án B — Linux VPS (Ubuntu + Systemd + Nginx)**:
  1. Copy thư mục `./publish` lên `/var/www/quanlythuvien`.
  2. Tạo dịch vụ Systemd (`/etc/systemd/system/thuvien.service`) chạy lệnh `ExecStart=/usr/bin/dotnet /var/www/quanlythuvien/QuanLyThuVien.dll` dưới biến `ASPNETCORE_ENVIRONMENT=Production`.
  3. Chạy `sudo systemctl enable --now thuvien`.
  4. Cấu hình Nginx `proxy_pass http://127.0.0.1:5000;` và chạy `sudo certbot --nginx` để kích hoạt HTTPS.

### 3. Cách kiểm tra ứng dụng chạy thành công & Checklist Vận hành / Bảo trì
1. **Kiểm tra khởi chạy**: Truy cập tên miền hoặc `https://localhost:<port>` $\rightarrow$ Trang chủ Thư viện tải đầy đủ giao diện Bootstrap 5 (HTTP `200 OK`).
2. **Kiểm tra kết nối Database**: Đăng nhập tài khoản `admin@thuvien.edu.vn` / `Admin@123` $\rightarrow$ Vào mục Sách / Hóa đơn / Thống kê kiểm tra dữ liệu Seed Data hiển thị và biểu đồ Chart.js vẽ chuẩn xác.
3. **Kiểm tra Phân quyền & Upload**: Thử đăng nhập tài khoản Thủ thư để xác nhận chặn `403 AccessDenied` tại khu vực Admin; thử upload ảnh bìa kiểm tra file lưu vào `wwwroot/uploads/`.
4. **Vận hành, Bảo mật & Bảo trì định kỳ**:
   - Thiết lập lịch tự động **Backup CSDL SQL Server** hàng ngày (`FULL` + `DIFF`).
   - Ghi nhận log lỗi hệ thống (Serilog / File Log), không hiển thị trang `DeveloperExceptionPage` ở môi trường Production.
   - Bật HTTPS bắt buộc (`UseHsts`, `UseHttpsRedirection`) và định kỳ cập nhật bản vá bảo mật .NET Runtime / NuGet packages.

---

## BÀI 4B (1 ĐIỂM): ỨNG DỤNG AI TRONG KIỂM TRA, ĐÁNH GIÁ VÀ SỬA LỖI TÀI LIỆU KỸ THUẬT

### 1. Câu lệnh Prompt gửi AI rà soát tài liệu kỹ thuật
```text
Vai trò: Bạn là Senior Solution Architect chuyên về ASP.NET Core MVC (.NET 8/10) và SQL Server.
Nhiệm vụ: Hãy đọc kỹ bản dự thảo Tài liệu kỹ thuật và danh mục cấu trúc source code của dự án Hệ thống Quản lý Thư viện Điện tử (viết bằng C# / ASP.NET Core MVC / EF Core Code First).
Yêu cầu kiểm tra và chỉ rõ các lỗi sau:
1) Sai tên công nghệ, framework hoặc nhầm lẫn giữa hệ sinh thái Java (JSP, DAO, Tomcat) và .NET (Razor View, DbContext/DAL, Kestrel/IIS).
2) Thiếu sót bước triển khai quan trọng đối với EF Core Code First (như Migration, Hosting Bundle).
3) Lỗi chính tả tiếng Việt hoặc thuật ngữ kỹ thuật không nhất quán.
Hãy lập bảng liệt kê: Vị trí lỗi -> Nội dung sai ban đầu -> Giải pháp sửa chuẩn xác.
```

### 2. Kết quả AI phát hiện và khắc phục các lỗi trong tài liệu kỹ thuật

| STT | Loại lỗi phát hiện | Nội dung sai / nhầm lẫn trong bản thảo | Nội dung đã hiệu chỉnh chuẩn xác |
| :--- | :--- | :--- | :--- |
| 1 | **Nhầm lẫn Framework View (Java vs .NET)** | Trong đề cương/bản nháp mục cấu trúc MVC ghi `View (JSP)`. | **JSP** là công nghệ của Java Servlet/Spring; dự án đang dùng ASP.NET Core MVC nên đã sửa chuẩn thành **`Razor View (.cshtml)`**. |
| 2 | **Nhầm lẫn thuật ngữ tầng dữ liệu** | Tài liệu cũ chỉ ghi chung `DAO` (thuật ngữ phổ biến bên Java JDBC). | Dự án triển khai theo **EF Core Code First**, vì vậy đã chuẩn hóa thành **`EF Core DbContext (LibraryDbContext) + Service / DAL (Repository Pattern)`**. |
| 3 | **Sai tên Application Server triển khai** | Dễ nhầm lẫn liệt kê Apache Tomcat hoặc chỉ ghi chung chung "Web Server". | Chuẩn hóa chính xác thành **`.NET Kestrel Web Server`** kết hợp Reverse Proxy **`IIS`** (Windows Server) hoặc **`Nginx`** (Linux VPS) kèm yêu cầu **`.NET Hosting Bundle`**. |
| 4 | **Thiếu bước Code First Migration khi Deploy** | Bản hướng dẫn cài đặt cũ thiếu bước tạo CSDL từ code trên Server mới. | Bổ sung bắt buộc lệnh **`dotnet ef database update`** trước bước `dotnet publish` / khởi chạy hệ thống. |
| 5 | **Lỗi chính tả & Bảo mật cấu hình** | Sai chính tả tiếng Việt (`khoản thời gian` thay vì `khoảng thời gian`) và để lộ chuỗi kết nối mật khẩu trực tiếp trong hướng dẫn. | Sửa đúng chính tả **`khoảng thời gian`**; tách toàn bộ thông tin nhạy cảm sang tệp mẫu ẩn thông tin **`appsettings.Production.example.json`** và loại trừ `appsettings.Production.json` trong `.gitignore`. |
