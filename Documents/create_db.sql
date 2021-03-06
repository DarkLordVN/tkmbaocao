

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ConvertDelimitedListIntoTable] (
     @list NVARCHAR(MAX) ,@delimiter CHAR(1) )
RETURNS @table TABLE ( 
     item VARCHAR(255) NOT NULL )
AS 
    BEGIN
        DECLARE @pos INT ,@nextpos INT ,@valuelen INT

        SELECT  @pos = 0 ,@nextpos = 1

        WHILE @nextpos > 0 
            BEGIN
                SELECT  @nextpos = CHARINDEX(@delimiter,@list,@pos + 1)
                SELECT  @valuelen = CASE WHEN @nextpos > 0 THEN @nextpos
                                         ELSE LEN(@list) + 1
                                    END - @pos - 1
                INSERT  @table ( item )
                VALUES  ( CONVERT(INT,SUBSTRING(@list,@pos + 1,@valuelen)) )
                SELECT  @pos = @nextpos

            END

        DELETE  FROM @table
        WHERE   item = ''

        RETURN 
    END
GO
/****** Object:  Table [dbo].[DmDonVi]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DmDonVi](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KhoaChaID] [int] NULL,
	[MaDinhDanh] [varchar](14) NULL,
	[TenDonVi] [nvarchar](250) NULL,
	[KyHieu] [nvarchar](50) NULL,
	[NguoiTao] [varchar](50) NULL,
	[NgayTao] [datetime] NULL,
	[NguoiTaoID] [int] NULL,
	[NguoiCapNhatID] [int] NULL,
	[NguoiCapNhat] [varchar](50) NULL,
	[NgayCapNhat] [datetime] NULL,
	[ThuTu] [int] NULL,
	[TrangThai] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsDonVi] [bit] NULL,
	[ListCanBoXuLyVanBanDenID] [varchar](max) NULL,
	[ListCanBoXuLyHoSoCongViecID] [varchar](max) NULL,
 CONSTRAINT [PK_DmDonVi_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HeThongThamSo]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HeThongThamSo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MaThamSo] [varchar](50) NULL,
	[TenThamSo] [nvarchar](250) NULL,
	[MoTa] [nvarchar](500) NULL,
	[NguoiCapNhatID] [int] NULL,
	[NgayCapNhat] [datetime] NULL,
	[TrangThai] [bit] NOT NULL,
 CONSTRAINT [PK_HeThongThamSo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NguoiDung]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NguoiDung](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[HoVaTen] [nvarchar](250) NULL,
	[NgaySinh] [datetime] NULL,
	[GioiTinh] [bit] NULL,
	[NhomQuyenID] [int] NULL,
	[NhomQuyenList] [nvarchar](500) NULL,
	[ChucVuID] [int] NULL,
	[DonViID] [int] NULL,
	[TenDangNhap] [varchar](100) NULL,
	[MatKhau] [varchar](500) NULL,
	[AnhDaiDien] [varchar](500) NULL,
	[Email] [varchar](250) NULL,
	[SoDienThoai] [varchar](250) NULL,
	[DiaChi] [nvarchar](500) NULL,
	[Fax] [nvarchar](100) NULL,
	[NguoiTao] [varchar](50) NULL,
	[NgayTao] [datetime] NULL,
	[NguoiTaoID] [int] NULL,
	[NguoiCapNhatID] [int] NULL,
	[NguoiCapNhat] [varchar](50) NULL,
	[NgayCapNhat] [datetime] NULL,
	[ThuTu] [int] NULL,
	[TrangThai] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_NguoiDung] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NhatKyHeThong]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NhatKyHeThong](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NguoiDungId] [int] NULL,
	[MoTa] [nvarchar](2000) NULL,
	[NgayTao] [datetime] NULL,
	[IpClient] [varchar](50) NULL,
 CONSTRAINT [PK_HeThongLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NhomDonVi]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NhomDonVi](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TenNhom] [nvarchar](250) NULL,
	[ListDonViThuocNhomID] [varchar](max) NULL,
	[NguoiTao] [varchar](50) NULL,
	[NgayTao] [datetime] NULL,
	[NguoiTaoID] [int] NULL,
	[NguoiCapNhatID] [int] NULL,
	[NguoiCapNhat] [varchar](50) NULL,
	[NgayCapNhat] [datetime] NULL,
	[TrangThai] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_NhomDonVi] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NhomNguoiDung]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NhomNguoiDung](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TenNhom] [nvarchar](250) NULL,
	[ListNguoiDungThuocNhomID] [varchar](max) NULL,
	[PhamViSuDung] [bit] NOT NULL,
	[NguoiTao] [varchar](50) NULL,
	[NgayTao] [datetime] NULL,
	[NguoiTaoID] [int] NULL,
	[NguoiCapNhatID] [int] NULL,
	[NguoiCapNhat] [varchar](50) NULL,
	[NgayCapNhat] [datetime] NULL,
	[TrangThai] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_NhomNguoiDung_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NhomQuyen]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[NhomQuyen](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KyHieu] [nvarchar](50) NULL,
	[MaNhom] [varchar](50) NULL,
	[TenNhom] [nvarchar](250) NULL,
	[GhiChu] [nvarchar](500) NULL,
	[NguoiTao] [varchar](50) NULL,
	[NgayTao] [datetime] NULL,
	[NguoiTaoID] [int] NULL,
	[NguoiCapNhatID] [int] NULL,
	[NguoiCapNhat] [varchar](50) NULL,
	[NgayCapNhat] [datetime] NULL,
	[ThuTu] [int] NULL,
	[TrangThai] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_NhomNguoiDung] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NhomQuyenQuyen]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[NhomQuyenQuyen](
	[QuyenID] [int] NOT NULL,
	[NhomQuyenID] [int] NOT NULL,
	[QuyenChiTiet] [varchar](100) NULL,
 CONSTRAINT [PK_NhomNguoiDungQuyen] PRIMARY KEY CLUSTERED 
(
	[QuyenID] ASC,
	[NhomQuyenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Quyen]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Quyen](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KhoaChaID] [int] NULL,
	[MaQuyen] [nvarchar](50) NULL,
	[TenQuyen] [nvarchar](250) NULL,
	[NhanQuyen] [bit] NOT NULL,
	[TenHienThi] [nvarchar](250) NULL,
	[Controller] [nvarchar](50) NULL,
	[IconPath] [nvarchar](255) NULL,
	[GhiChu] [nvarchar](250) NULL,
	[Action] [nvarchar](50) NULL,
	[FontAwesome] [nvarchar](50) NULL,
	[IsMenu] [bit] NOT NULL,
	[PhanHe] [tinyint] NULL,
	[NguoiTao] [varchar](50) NULL,
	[NgayTao] [datetime] NULL,
	[NguoiTaoID] [int] NULL,
	[NguoiCapNhatID] [int] NULL,
	[NguoiCapNhat] [varchar](50) NULL,
	[NgayCapNhat] [datetime] NULL,
	[ThuTu] [int] NULL,
	[TrangThai] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_ChucNang] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ThongBao]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ThongBao](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TieuDe] [nvarchar](500) NULL,
	[NoiDung] [nvarchar](max) NULL,
	[LstNguoiNhanID] [varchar](max) NULL,
	[LstNhomNguoiNhanID] [varchar](max) NULL,
	[FileDinhKem] [varchar](max) NULL,
	[NguoiTaoID] [int] NULL,
	[NgayTao] [datetime] NULL,
	[ChucNangID] [int] NULL,
	[Link] [nvarchar](500) NULL,
	[IsDaGui] [bit] NOT NULL,
	[LstNguoiNhanDaXemID] [varchar](max) NULL,
	[LstNguoiNhanDaNhanMoiNhatID] [varchar](max) NULL,
	[isXoaTam] [bit] NOT NULL,
 CONSTRAINT [PK_ThongBao] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ThongBaoAttach]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ThongBaoAttach](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ThongBaoID] [int] NULL,
	[LinkFile] [varchar](max) NULL,
	[NameFile] [nvarchar](max) NULL,
	[ReplaceName] [nvarchar](max) NULL,
	[Size] [varchar](500) NULL,
	[Code] [varchar](500) NULL,
	[NgayTao] [datetime] NULL,
	[TrangThai] [bit] NOT NULL,
 CONSTRAINT [PK_ThongBaoAttach] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[HistoryCustomFilter](
	[monthval] [int] NULL,
	[quarterval] [int] NULL,
	[weekval] [int] NULL,
	[yearval] [int] NULL,
	[dateval] [date] NULL,
	[monthlabel] [nvarchar](50) NULL,
	[quarterlabel] [nvarchar](50) NULL,
	[weeklabel] [nvarchar](50) NULL,
	[datelabel] [nvarchar](50) NULL
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[HistoryCustomReport](
	[itemid] [bigint] NOT NULL,
	[value_min] [numeric](16, 4) NOT NULL,
	[value_avg] [numeric](16, 4) NOT NULL,
	[value_max] [numeric](16, 4) NOT NULL,
	[createdDate] [datetime] NULL,
	[maxClock] [int] NULL,
	[minClock] [int] NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[HistoryCustomReport] ADD  CONSTRAINT [DF__HistoryCu__value__3FBB6990]  DEFAULT ((0.0000)) FOR [value_min]
GO

ALTER TABLE [dbo].[HistoryCustomReport] ADD  CONSTRAINT [DF__HistoryCu__value__40AF8DC9]  DEFAULT ((0.0000)) FOR [value_avg]
GO

ALTER TABLE [dbo].[HistoryCustomReport] ADD  CONSTRAINT [DF__HistoryCu__value__41A3B202]  DEFAULT ((0.0000)) FOR [value_max]
GO


SET IDENTITY_INSERT [dbo].[Quyen] ON 

GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (1, 0, NULL, N'Quản trị hệ thống', 0, NULL, N'', N'fas fa-cogs', NULL, N'', NULL, 1, NULL, N'admin', CAST(0x0000AD0A00F2F660 AS DateTime), 5, 5, N'admin', CAST(0x0000AD0E014F1923 AS DateTime), 45, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (3, 1, NULL, N'Nhật ký hệ thống', 0, NULL, N'NhatKyHeThong', N'fal fa-book-open', NULL, N'Index', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00029390 AS DateTime), 5, 5, N'admin', CAST(0x0000AD2000861192 AS DateTime), 58, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (4, 0, NULL, N'Thống kê nhóm thiết bị', 0, NULL, N'', N'fal fa-analytics', NULL, N'', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00A738AA AS DateTime), 5, 5, N'admin', CAST(0x0000AD22001A2515 AS DateTime), 1, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (5, 0, NULL, N'Báo cáo hiệu năng thiết bị', 0, NULL, N'', N'fa fa-file-medical-alt', NULL, N'', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00A75CC1 AS DateTime), 5, 5, N'admin', CAST(0x0000AD22001A1B16 AS DateTime), 7, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (7, 1, NULL, N'Nhóm người dùng', 0, NULL, N'NhomNguoiDung', N'fal fa-users', NULL, N'Index', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00A7D649 AS DateTime), 5, NULL, NULL, NULL, 38, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (8, 1, NULL, N'Người dùng', 0, NULL, N'NguoiDung', N'fal fa-user', NULL, N'Index', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00A80BEA AS DateTime), 5, NULL, NULL, NULL, 43, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (9, 1, NULL, N'Nhóm quyền', 0, NULL, N'NhomQuyen', N'far fa-atlas', NULL, N'Index', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00A93C0B AS DateTime), 5, NULL, NULL, NULL, 44, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (10, 1, NULL, N'Quyền', 0, NULL, N'Quyen', N'fal fa-atom-alt', NULL, N'Index?check', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00A99D0A AS DateTime), 5, NULL, NULL, NULL, 45, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (11, 4, NULL, N'Số lượng theo nhóm', 0, NULL, N'BaoCao', NULL, NULL, N'TongThietBiNhom', NULL, 1, NULL, N'admin', CAST(0x0000AD0E014E375D AS DateTime), 5, 5, N'admin', CAST(0x0000AD1D011F78B0 AS DateTime), 25, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (12, 4, NULL, N'Chi tiết thiết bị theo nhóm', 0, NULL, N'BaoCao', NULL, NULL, N'ChiTietThietBiNhom', NULL, 1, NULL, N'admin', CAST(0x0000AD0E014E52F4 AS DateTime), 5, 5, N'admin', CAST(0x0000AD1D01224026 AS DateTime), 27, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (13, 0, NULL, N'Thống kê vấn đề', 0, NULL, N'', N'fal fa-atom', NULL, N'', NULL, 1, NULL, N'admin', CAST(0x0000AD0E014E7ECB AS DateTime), 5, 5, N'admin', CAST(0x0000AD22001A2E22 AS DateTime), 2, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (16, 0, NULL, N'Báo cáo hiệu năng máy chủ', 0, NULL, N'', N'fa fa-coins', NULL, N'Add', NULL, 1, NULL, N'admin', CAST(0x0000AD0E0150233D AS DateTime), 5, 5, N'admin', CAST(0x0000AD22001A0E32 AS DateTime), 5, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (17, 0, NULL, N'Báo cáo tổng hợp', 0, NULL, N'BaoCao', N'fal fa-book-open', NULL, N'BaoCaoTongHop', NULL, 1, NULL, N'admin', CAST(0x0000AD0E01504250 AS DateTime), 5, 5, N'admin', CAST(0x0000AD27014A1ECB AS DateTime), 8, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (18, 5, NULL, N'Hiệu năng sử dụng CPU', 0, NULL, N'BaoCao', NULL, NULL, N'HieuNangNhom?keytype=cpu&groupby=host', NULL, 1, NULL, N'admin', CAST(0x0000AD0E01512A7C AS DateTime), 5, 5, N'admin', CAST(0x0000AD20002157C7 AS DateTime), 2, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (19, 5, NULL, N'Hiệu năng sử dụng RAM', 0, NULL, N'BaoCao', NULL, NULL, N'HieuNangNhom?keytype=ram&groupby=host', NULL, 1, NULL, N'admin', CAST(0x0000AD0E01525F75 AS DateTime), 5, 5, N'admin', CAST(0x0000AD200020E38C AS DateTime), 5, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (20, 5, NULL, N'Hiệu năng sử dụng ổ cứng', 0, NULL, N'BaoCao', NULL, NULL, N'HieuNangNhom?keytype=hdd&groupby=host', NULL, 1, NULL, N'admin', CAST(0x0000AD0E015276F6 AS DateTime), 5, 5, N'admin', CAST(0x0000AD200020F233 AS DateTime), 7, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (21, 13, NULL, N'Tổng vấn đề theo nhóm', 0, NULL, N'BaoCao', NULL, NULL, N'Index', NULL, 1, NULL, N'admin', CAST(0x0000AD1D01214D51 AS DateTime), 5, 5, N'admin', CAST(0x0000AD1D0121579D AS DateTime), 18, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (22, 5, NULL, N'Băng thông', 0, NULL, N'BaoCao', NULL, NULL, N'HieuNangNhom?keytype=bwd&groupby=host', NULL, 1, NULL, N'admin', CAST(0x0000AD200020C98F AS DateTime), 5, 5, N'admin', CAST(0x0000AD200020D4BB AS DateTime), 11, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (23, 16, NULL, N'Hiệu năng sử dụng CPU', 0, NULL, N'BaoCao', NULL, NULL, N'HieuNangNhom?keytype=cpu', NULL, 1, NULL, N'admin', CAST(0x0000AD0E01512A7C AS DateTime), 5, 5, N'admin', CAST(0x0000AD20002157C7 AS DateTime), 2, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (24, 16, NULL, N'Hiệu năng sử dụng RAM', 0, NULL, N'BaoCao', NULL, NULL, N'HieuNangNhom?keytype=ram', NULL, 1, NULL, N'admin', CAST(0x0000AD0E01525F75 AS DateTime), 5, 5, N'admin', CAST(0x0000AD200020E38C AS DateTime), 5, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (25, 16, NULL, N'Hiệu năng sử dụng ổ cứng', 0, NULL, N'BaoCao', NULL, NULL, N'HieuNangNhom?keytype=hdd', NULL, 1, NULL, N'admin', CAST(0x0000AD0E015276F6 AS DateTime), 5, 5, N'admin', CAST(0x0000AD200020F233 AS DateTime), 7, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (27, 16, NULL, N'Băng thông', 0, NULL, N'BaoCao', NULL, NULL, N'HieuNangNhom?keytype=bwd', NULL, 1, NULL, N'admin', CAST(0x0000AD200020C98F AS DateTime), 5, 5, N'admin', CAST(0x0000AD200020D4BB AS DateTime), 11, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (29, 13, NULL, N'Danh sách vấn đề', 0, NULL, N'BaoCao', NULL, NULL, N'ChiTietVanDe', NULL, 1, NULL, N'user2', CAST(0x0000AD220015EA19 AS DateTime), 7, NULL, NULL, NULL, 3, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (1023, 1, NULL, N'Tham số hệ thống', 0, NULL, N'HeThongThamSo', N'fa fa-bomb', NULL, N'Index', NULL, 1, NULL, N'admin', CAST(0x0000AD2E0163F168 AS DateTime), 5, NULL, NULL, NULL, 16, 1, 0)
GO
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (1024, 0, NULL, N'Báo cáo đề xuất thiết bị', 0, NULL, N'BaoCao', N'fal fa-snowflake', NULL, N'DeXuatThietBi', NULL, 1, NULL, N'admin', CAST(0x0000AD32001884E5 AS DateTime), 5, 5, N'admin', CAST(0x0000AD320019013D AS DateTime), 9, 1, 0)
GO
SET IDENTITY_INSERT [dbo].[Quyen] OFF
GO
SET IDENTITY_INSERT [dbo].[NhomQuyen] ON 

GO
INSERT [dbo].[NhomQuyen] ([ID], [KyHieu], [MaNhom], [TenNhom], [GhiChu], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (1, NULL, NULL, N'Quản trị hệ thống', NULL, N'admin', CAST(0x0000AD0B018AC84D AS DateTime), 5, 5, N'admin', CAST(0x0000AD3200189A85 AS DateTime), 3, 1, 0)
GO
INSERT [dbo].[NhomQuyen] ([ID], [KyHieu], [MaNhom], [TenNhom], [GhiChu], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (2, NULL, NULL, N'Báo cáo', NULL, N'admin', CAST(0x0000AD0B018AD2EC AS DateTime), 5, 5, N'admin', CAST(0x0000AD22001AA18A AS DateTime), 1, 1, 0)
GO
SET IDENTITY_INSERT [dbo].[NhomQuyen] OFF
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (1, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (3, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (4, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (4, 2, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (5, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (7, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (8, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (9, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (10, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (11, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (12, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (12, 2, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (13, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (13, 2, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (16, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (17, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (18, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (19, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (20, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (21, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (22, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (23, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (24, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (25, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (27, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (29, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (29, 2, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (1023, 1, N',1,2,3,4,5,6,')
GO
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (1024, 1, N',1,2,3,4,5,6,')
GO
SET IDENTITY_INSERT [dbo].[NguoiDung] ON 

GO
INSERT [dbo].[NguoiDung] ([ID], [HoVaTen], [NgaySinh], [GioiTinh], [NhomQuyenID], [NhomQuyenList], [ChucVuID], [DonViID], [TenDangNhap], [MatKhau], [AnhDaiDien], [Email], [SoDienThoai], [DiaChi], [Fax], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (5, N'Quản trị hệ thống SYSMAN', CAST(0x0000AD0A00000000 AS DateTime), 0, 1, N',1,', 0, 0, N'admin', N'4297F44B13955235245B2497399D7A93', N'/2021/06/02/02_06_21_13_50_35.png', NULL, N'0338971669', NULL, NULL, NULL, NULL, NULL, 5, N'admin', CAST(0x0000AD3B00E42274 AS DateTime), NULL, 1, 0)
GO
INSERT [dbo].[NguoiDung] ([ID], [HoVaTen], [NgaySinh], [GioiTinh], [NhomQuyenID], [NhomQuyenList], [ChucVuID], [DonViID], [TenDangNhap], [MatKhau], [AnhDaiDien], [Email], [SoDienThoai], [DiaChi], [Fax], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (6, N'Nguyễn Văn A', CAST(0x0000AD0800000000 AS DateTime), 1, 1, N',1,2,', 0, 0, N'user1', N'4297F44B13955235245B2497399D7A93', N'/2021/06/02/02_06_21_13_50_20.jpg', N'lekhanhtoan.unv2010@gmail.com', N'0338971669', NULL, NULL, N'admin', CAST(0x0000AD0E0001FE05 AS DateTime), 5, 5, N'admin', CAST(0x0000AD3B00E4106E AS DateTime), NULL, 1, 0)
GO
INSERT [dbo].[NguoiDung] ([ID], [HoVaTen], [NgaySinh], [GioiTinh], [NhomQuyenID], [NhomQuyenList], [ChucVuID], [DonViID], [TenDangNhap], [MatKhau], [AnhDaiDien], [Email], [SoDienThoai], [DiaChi], [Fax], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (7, N'Phạm Thị B', NULL, 0, 2, N',2,', 0, 0, N'user2', N'4297F44B13955235245B2497399D7A93', N'/2021/06/02/02_06_21_13_50_12.png', NULL, NULL, NULL, NULL, N'admin', CAST(0x0000AD0E0002758E AS DateTime), 5, 5, N'admin', CAST(0x0000AD3B00E40742 AS DateTime), NULL, 1, 0)
GO
SET IDENTITY_INSERT [dbo].[NguoiDung] OFF
GO
SET IDENTITY_INSERT [dbo].[NhomNguoiDung] ON 

GO
INSERT [dbo].[NhomNguoiDung] ([ID], [TenNhom], [ListNguoiDungThuocNhomID], [PhamViSuDung], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [TrangThai], [IsDeleted]) VALUES (1, N'Quản trị hệ thống', N',5,', 0, N'admin', CAST(0x0000AD0B018AA64A AS DateTime), 5, NULL, NULL, NULL, 1, 0)
GO
INSERT [dbo].[NhomNguoiDung] ([ID], [TenNhom], [ListNguoiDungThuocNhomID], [PhamViSuDung], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [TrangThai], [IsDeleted]) VALUES (2, N'Báo cáo', N',5,', 0, N'admin', CAST(0x0000AD0E000172E9 AS DateTime), 5, NULL, NULL, NULL, 1, 0)
GO
SET IDENTITY_INSERT [dbo].[NhomNguoiDung] OFF
GO



ALTER TABLE [dbo].[DmDonVi] ADD  CONSTRAINT [DF_DmDonVi_NgayTao_1]  DEFAULT (getdate()) FOR [NgayTao]
GO
ALTER TABLE [dbo].[DmDonVi] ADD  CONSTRAINT [DF_DmDonVi_ThuTu_1]  DEFAULT ((0)) FOR [ThuTu]
GO
ALTER TABLE [dbo].[DmDonVi] ADD  CONSTRAINT [DF_DmDonVi_IsDeleted_1]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[HeThongThamSo] ADD  CONSTRAINT [DF_Table_1_CreateDate1]  DEFAULT (getdate()) FOR [NgayCapNhat]
GO
ALTER TABLE [dbo].[NguoiDung] ADD  CONSTRAINT [DF_NguoiDung_NgayTao]  DEFAULT (getdate()) FOR [NgayTao]
GO
ALTER TABLE [dbo].[NhatKyHeThong] ADD  CONSTRAINT [DF_HeThongLog_CreateDate]  DEFAULT (getdate()) FOR [NgayTao]
GO
ALTER TABLE [dbo].[NhomDonVi] ADD  CONSTRAINT [DF_NhomDonVi_NgayTao]  DEFAULT (getdate()) FOR [NgayTao]
GO
ALTER TABLE [dbo].[NhomDonVi] ADD  CONSTRAINT [DF_NhomDonVi_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[NhomNguoiDung] ADD  CONSTRAINT [DF_NhomNguoiDung_NgayTao_1]  DEFAULT (getdate()) FOR [NgayTao]
GO
ALTER TABLE [dbo].[NhomNguoiDung] ADD  CONSTRAINT [DF_NhomNguoiDung_IsDeleted_1]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[NhomQuyen] ADD  CONSTRAINT [DF_NhomNguoiDung_NgayTao]  DEFAULT (getdate()) FOR [NgayTao]
GO
ALTER TABLE [dbo].[NhomQuyen] ADD  CONSTRAINT [DF_NhomNguoiDung_ThuTu]  DEFAULT ((0)) FOR [ThuTu]
GO
ALTER TABLE [dbo].[NhomQuyen] ADD  CONSTRAINT [DF_NhomNguoiDung_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Quyen] ADD  CONSTRAINT [DF_ChucNang_NgayTao]  DEFAULT (getdate()) FOR [NgayTao]
GO
ALTER TABLE [dbo].[Quyen] ADD  CONSTRAINT [DF_Quyen_ThuTuSapXep]  DEFAULT ((0)) FOR [ThuTu]
GO
ALTER TABLE [dbo].[Quyen] ADD  CONSTRAINT [DF_Quyen_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[ThongBao] ADD  CONSTRAINT [DF_ThongBao_IsDaGui]  DEFAULT ((0)) FOR [IsDaGui]
GO
ALTER TABLE [dbo].[ThongBaoAttach] ADD  CONSTRAINT [DF_ThongBaoAttach_LinkFile]  DEFAULT (getdate()) FOR [LinkFile]
GO
ALTER TABLE [dbo].[ThongBaoAttach] ADD  CONSTRAINT [DF_ThongBaoAttach_NameFile]  DEFAULT (getdate()) FOR [NameFile]
GO
ALTER TABLE [dbo].[ThongBaoAttach] ADD  CONSTRAINT [DF_ThongBaoAttach_ReplaceName]  DEFAULT (getdate()) FOR [ReplaceName]
GO
ALTER TABLE [dbo].[NhomQuyenQuyen]  WITH NOCHECK ADD  CONSTRAINT [FK_NhomNguoiDungQuyen_NhomNguoiDung] FOREIGN KEY([NhomQuyenID])
REFERENCES [dbo].[NhomQuyen] ([ID])
GO
ALTER TABLE [dbo].[NhomQuyenQuyen] CHECK CONSTRAINT [FK_NhomNguoiDungQuyen_NhomNguoiDung]
GO
ALTER TABLE [dbo].[NhomQuyenQuyen]  WITH NOCHECK ADD  CONSTRAINT [FK_NhomNguoiDungQuyen_Quyen] FOREIGN KEY([QuyenID])
REFERENCES [dbo].[Quyen] ([ID])
GO
ALTER TABLE [dbo].[NhomQuyenQuyen] CHECK CONSTRAINT [FK_NhomNguoiDungQuyen_Quyen]
GO
ALTER TABLE [dbo].[ThongBao]  WITH CHECK ADD  CONSTRAINT [FK_ThongBao_NguoiDung] FOREIGN KEY([NguoiTaoID])
REFERENCES [dbo].[NguoiDung] ([ID])
GO
ALTER TABLE [dbo].[ThongBao] CHECK CONSTRAINT [FK_ThongBao_NguoiDung]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t5"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t1"
            Begin Extent = 
               Top = 7
               Left = 290
               Bottom = 170
               Right = 484
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t2"
            Begin Extent = 
               Top = 7
               Left = 532
               Bottom = 170
               Right = 759
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t8"
            Begin Extent = 
               Top = 7
               Left = 807
               Bottom = 170
               Right = 1061
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t9"
            Begin Extent = 
               Top = 175
               Left = 48
               Bottom = 338
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t6"
            Begin Extent = 
               Top = 175
               Left = 290
               Bottom = 338
               Right = 544
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t4"
            Begin Extent = 
               Top = 175
               Left = 592
               Bottom = 316
               Right = 786
            End
            DisplayFlags = 280
            TopColumn = 0
         ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_problems'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'End
         Begin Table = "t3"
            Begin Extent = 
               Top = 175
               Left = 834
               Bottom = 338
               Right = 1058
            End
            DisplayFlags = 280
            TopColumn = 26
         End
         Begin Table = "t7"
            Begin Extent = 
               Top = 322
               Left = 592
               Bottom = 485
               Right = 786
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_problems'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_problems'
GO

CREATE VIEW [dbo].[v_performance]
AS
SELECT TOP (100) PERCENT t5.name AS groupname, t3.name AS hostname, t2.name AS itemName, (CASE t2.units WHEN 'B' THEN 'GB' WHEN 'Bps' THEN 'Mbps' ELSE t2.units END) AS units, 
                  (CASE t2.units WHEN 'B' THEN t1.value_min / 1073741824 WHEN 'Bps' THEN t1.value_min / 131072 ELSE t1.value_min END) AS value_min, 
                  (CASE t2.units WHEN 'B' THEN t1.value_avg / 1073741824 WHEN 'Bps' THEN t1.value_avg / 131072 ELSE t1.value_avg END) AS value_avg, 
                  (CASE t2.units WHEN 'B' THEN t1.value_max / 1073741824 WHEN 'Bps' THEN t1.value_max / 131072 ELSE t1.value_max END) AS value_max, DATEPART(year, t1.createdDate) AS yearval, DATEPART(quarter, t1.createdDate) AS quarterval, 
                  N'Quý ' + CAST(DATEPART(quarter, t1.createdDate) AS nvarchar) + '/' + CAST(DATEPART(year, t1.createdDate) AS nvarchar) AS quarterlabel, DATEPART(MONTH, t1.createdDate) AS monthval, N'Tháng ' + CAST(DATEPART(month, 
                  t1.createdDate) AS nvarchar) + '/' + CAST(DATEPART(year, t1.createdDate) AS nvarchar) AS monthlabel, DATEPART(week, t1.createdDate) AS weekval, N'Tuần ' + CAST(DATEPART(week, t1.createdDate) AS nvarchar) 
                  + '/' + CAST(DATEPART(year, t1.createdDate) AS nvarchar) AS weeklabel, t1.createdDate AS dateval, { fn CONCAT({ fn CONCAT(CONVERT(varchar, t1.createdDate, 103), ' ') }, CONVERT(varchar, t1.createdDate, 108)) } AS datelabel, t2.key_, 
                  t1.itemid, t1.maxClock, t1.minClock, t6.ip, t3.hostid, t5.groupid
FROM     dbo.HistoryCustomReport AS t1 INNER JOIN
                  dbo.items AS t2 ON t1.itemid = t2.itemid INNER JOIN
                  dbo.hosts AS t3 ON t2.hostid = t3.hostid INNER JOIN
                  dbo.hosts_groups AS t4 ON t3.hostid = t4.hostid INNER JOIN
                  dbo.hstgrp AS t5 ON t4.groupid = t5.groupid INNER JOIN
                  dbo.interface AS t6 ON t3.hostid = t6.hostid
WHERE  (LOWER(t5.name) NOT LIKE '%template%')

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t1"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t2"
            Begin Extent = 
               Top = 7
               Left = 290
               Bottom = 170
               Right = 544
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t3"
            Begin Extent = 
               Top = 7
               Left = 592
               Bottom = 170
               Right = 816
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t4"
            Begin Extent = 
               Top = 7
               Left = 864
               Bottom = 148
               Right = 1058
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t5"
            Begin Extent = 
               Top = 154
               Left = 864
               Bottom = 317
               Right = 1058
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t6"
            Begin Extent = 
               Top = 7
               Left = 1106
               Bottom = 170
               Right = 1300
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_performance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_performance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_performance'
GO




CREATE PROCEDURE [dbo].[AutoInsert]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO HistoryCustomReport(itemid,value_min,value_avg,value_max,createdDate,maxClock,minClock) 
SELECT itemid, min(value) minval, avg(value) avgval, max(value) maxval, clockConvert, max(clock) maxclock, min(clock) minclock FROM (SELECT *, CAST(dateadd(s, convert(bigint, clock), convert(datetime, '1-1-1970 7:00:00')) AS DATE) clockConvert FROM history WHERE clock > (SELECT CASE WHEN min(maxclock) IS NULL THEN 0 ELSE min(maxclock) END FROM HistoryCustomReport)) tblAll GROUP BY itemid, clockConvert;

	INSERT INTO HistoryCustomReport(itemid,value_min,value_avg,value_max,createdDate,maxClock,minClock) 
SELECT itemid, min(value_min) minval, avg(value_avg) avgval, max(value_max) maxval, clockConvert, max(clock) maxclock, min(clock) minclock FROM (SELECT *, CAST(dateadd(s, convert(bigint, clock), convert(datetime, '1-1-1970 7:00:00')) AS DATETIME) clockConvert FROM trends WHERE clock < (SELECT min(clock) FROM history)) tblAll GROUP BY itemid, clockConvert;

    INSERT INTO HistoryCustomFilter (monthval, quarterval, weekval, yearval, dateval, monthlabel, quarterlabel, weeklabel, datelabel) SELECT DISTINCT monthval, quarterval, weekval, yearval, dateval, monthlabel, quarterlabel, weeklabel, datelabel  FROM  v_performance where datelabel NOT IN (SELECT datelabel from HistoryCustomFilter);
END


CREATE VIEW [dbo].[v_performanceFilter]
AS
SELECT DISTINCT dateval AS Expr1, weekval AS Expr2, monthval AS Expr3, quarterval AS Expr4, yearval AS Expr5, monthlabel AS Expr6, quarterlabel AS Expr7, weeklabel AS Expr8, datelabel AS Expr9, dbo.HistoryCustomFilter.*
FROM     dbo.HistoryCustomFilter

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "HistoryCustomFilter"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_performanceFilter'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_performanceFilter'
GO


GO



CREATE PROCEDURE [dbo].[CountHostsByGroup]
(
@p_listGroup AS NVARCHAR(MAX),
@p_trangThai AS NVARCHAR(MAX),
@p_tuNgay AS DATETIME,
@p_denNgay AS DATETIME,
@p_pageIndex AS INT,
@p_pageSize AS INT,
@p_columnName AS NVARCHAR(50),
@p_orderBy AS NVARCHAR(50)
)
AS  
BEGIN 
	SELECT name, (totalThietBi - totalLoi) totalThietBiKhongLoi, totalLoi, totalThietBi FROM (SELECT ROW_NUMBER() OVER(ORDER BY name) rnum,*, (SELECT COUNT(hostid) FROM hosts_groups WHERE groupid = t1.groupid) totalThietBi, (SELECT COUNT(hostid) FROM hosts_groups WHERE groupid = t1.groupid AND hostid IN (SELECT hostid FROM v_problems WHERE (@p_tuNgay IS NULL OR (clock >= (CAST(Datediff(s, '1970-01-01', @p_tuNgay) AS BIGINT)))) 
	AND (@p_denNgay IS NULL OR (clock <= (CAST(Datediff(s, '1970-01-01', @p_denNgay) AS BIGINT)))))) totalLoi FROM hstgrp t1 WHERE groupid IN (SELECT groupid from hosts_groups) AND LOWER(name) NOT LIKE '%Templates%'
	AND (@p_listGroup IS NULL OR @p_listGroup = '' OR (@p_listGroup != '' AND groupid IN ((SELECT * FROM dbo.ConvertDelimitedListIntoTable(@p_listGroup,',')))))
	) tblAll WHERE (@p_pageIndex = 0 AND @p_pageSize = 0 OR (tblAll.rnum BETWEEN ((@p_pageIndex - 1) * @p_pageSize + 1) AND (@p_pageIndex * @p_pageSize)));
END  

CREATE VIEW [dbo].[v_problems]
AS
SELECT t7.name AS groupname, t7.groupid, t1.r_eventid, t1.eventid, t1.severity, t1.clock, CAST(DATEADD(s, CONVERT(bigint, t1.clock), CONVERT(datetime, '1-1-1970 7:00:00')) AS DATETIME) AS createDate, 
                  { fn CONCAT({ fn CONCAT(CONVERT(nvarchar, CAST(DATEADD(s, CONVERT(bigint, t1.clock), CONVERT(datetime, '1-1-1970 7:00:00')) AS DATETIME), 103), ' ') }, CONVERT(nvarchar, CAST(DATEADD(s, CONVERT(bigint, t1.clock), 
                  CONVERT(datetime, '1-1-1970 7:00:00')) AS DATETIME), 108)) } AS thoigiantao, CASE WHEN r_eventid IS NOT NULL THEN { fn CONCAT({ fn CONCAT(CONVERT(nvarchar, CAST(DATEADD(s, CONVERT(bigint, t1.r_clock), CONVERT(datetime, 
                  '1-1-1970 7:00:00')) AS DATETIME), 103), ' ') }, CONVERT(nvarchar, CAST(DATEADD(s, CONVERT(bigint, t1.r_clock), CONVERT(datetime, '1-1-1970 7:00:00')) AS DATETIME), 108)) } ELSE '' END AS thoigianxuly, t1.objectid, t3.hostid, 
                  t3.status AS hoststatus, t3.flags AS hostflags, t3.name AS hostname, t1.name AS problemname, dbo.interface.ip AS iphost, CASE WHEN r_eventid IS NOT NULL THEN (CASE WHEN (t1.r_clock - t1.clock) 
                  > 86400 THEN RIGHT('0' + CAST((t1.r_clock - t1.clock) / 86400 AS VARCHAR), 2) + N' ngày ' + RIGHT('0' + CAST(((t1.r_clock - t1.clock) / 3600) % 24 AS VARCHAR), 2) + N' giờ ' ELSE (CASE WHEN (t1.r_clock - t1.clock) 
                  >= 3600 THEN RIGHT('0' + CAST((t1.r_clock - t1.clock) / 3600 AS VARCHAR), 2) + N' giờ ' ELSE '' END) END) + RIGHT('0' + CAST((t1.r_clock - t1.clock) / 60 % 60 AS VARCHAR), 2) + N' phút ' + RIGHT('0' + CAST((t1.r_clock - t1.clock) 
                  % 60 AS VARCHAR), 2) + N' giây ' ELSE '' END AS thoigiantontai
FROM     dbo.functions AS t5 INNER JOIN
                  dbo.problem AS t1 INNER JOIN
                  dbo.triggers AS t2 ON t1.objectid = t2.triggerid ON t5.triggerid = t2.triggerid INNER JOIN
                  dbo.items AS t8 ON t5.itemid = t8.itemid INNER JOIN
                  dbo.events AS t9 ON t1.eventid = t9.eventid INNER JOIN
                  dbo.items AS t6 ON t5.itemid = t6.itemid INNER JOIN
                  dbo.hosts_groups AS t4 INNER JOIN
                  dbo.hosts AS t3 ON t4.hostid = t3.hostid ON t6.hostid = t3.hostid INNER JOIN
                  dbo.hstgrp AS t7 ON t4.groupid = t7.groupid CROSS JOIN
                  dbo.interface
WHERE  (LOWER(t7.name) NOT LIKE '%template%')

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t5"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t1"
            Begin Extent = 
               Top = 7
               Left = 290
               Bottom = 170
               Right = 484
            End
            DisplayFlags = 280
            TopColumn = 10
         End
         Begin Table = "t2"
            Begin Extent = 
               Top = 7
               Left = 532
               Bottom = 170
               Right = 759
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t8"
            Begin Extent = 
               Top = 7
               Left = 807
               Bottom = 170
               Right = 1061
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t9"
            Begin Extent = 
               Top = 175
               Left = 48
               Bottom = 338
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "t6"
            Begin Extent = 
               Top = 175
               Left = 290
               Bottom = 338
               Right = 544
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "t4"
            Begin Extent = 
               Top = 175
               Left = 592
               Bottom = 316
               Right = 786
            End
            DisplayFlags = 280
            TopColumn = 0
        ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_problems'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' End
         Begin Table = "t3"
            Begin Extent = 
               Top = 175
               Left = 834
               Bottom = 338
               Right = 1058
            End
            DisplayFlags = 280
            TopColumn = 26
         End
         Begin Table = "t7"
            Begin Extent = 
               Top = 322
               Left = 592
               Bottom = 485
               Right = 786
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "interface"
            Begin Extent = 
               Top = 7
               Left = 1109
               Bottom = 170
               Right = 1303
            End
            DisplayFlags = 280
            TopColumn = 4
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_problems'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_problems'
GO



CREATE PROCEDURE [dbo].[CountProblemByStatus]
(
@p_listGroup AS NVARCHAR(MAX),
@p_trangThai AS NVARCHAR(MAX),
@p_groupBy AS NVARCHAR(50),
@p_tuNgay AS DATETIME,
@p_denNgay AS DATETIME,
@p_pageIndex AS INT,
@p_pageSize AS INT,
@p_columnName AS NVARCHAR(50),
@p_orderBy AS NVARCHAR(50)
)
AS  
BEGIN 
	SELECT * FROM (SELECT ROW_NUMBER() OVER(ORDER BY groupname, (CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'host') THEN hostname END)) rnum, 
			COUNT(groupname) OVER() as totalItem, groupname, 
			(CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'host') THEN hostname END) name, 
			(CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'host') THEN iphost END) ip, 
			COUNT(eventid) tongvande, 
			SUM(CASE WHEN r_eventid IS NULL THEN 1 ELSE 0 END) chuaxuly, 
			SUM(CASE WHEN r_eventid IS NOT NULL THEN 1 ELSE 0 END) daxuly FROM
	(SELECT ROW_NUMBER() OVER (PARTITION BY objectid ORDER BY clock DESC) rnum,* FROM v_problems) tblAll WHERE rnum = 1 
		AND (@p_listGroup IS NULL OR @p_listGroup = '' OR (@p_listGroup != '' AND groupid IN ((SELECT * FROM dbo.ConvertDelimitedListIntoTable(@p_listGroup,',')))))
		AND (@p_trangThai IS NULL OR @p_trangThai = '' OR (@p_trangThai = '1' AND r_eventid IS NOT NULL) OR (@p_trangThai = '0' AND r_eventid IS NULL))
		AND (@p_tuNgay IS NULL OR (clock >= (CAST(Datediff(s, '1970-01-01', @p_tuNgay) AS BIGINT)))) 
		AND (@p_denNgay IS NULL OR (clock <= (CAST(Datediff(s, '1970-01-01', @p_denNgay) AS BIGINT))))
	GROUP BY (CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'host') THEN hostname END), 
			(CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'host') THEN iphost END), groupname) tblAll WHERE ((@p_pageIndex = 0 AND @p_pageSize = 0) 
			OR (tblAll.rnum BETWEEN ((@p_pageIndex - 1) * @p_pageSize + 1) AND (@p_pageIndex * @p_pageSize)));
END  


GO



CREATE PROCEDURE [dbo].[CountProblemBySeverity]
(
@p_listGroup AS NVARCHAR(MAX),
@p_trangThai AS NVARCHAR(MAX),
@p_groupBy AS NVARCHAR(50),
@p_tuNgay AS DATETIME,
@p_denNgay AS DATETIME,
@p_pageIndex AS INT,
@p_pageSize AS INT,
@p_columnName AS NVARCHAR(50),
@p_orderBy AS NVARCHAR(50)
)
AS  
BEGIN 
	SELECT * FROM (SELECT ROW_NUMBER() OVER(ORDER BY groupname, (CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'host') THEN hostname END)) rnum, 
			COUNT(groupname) OVER() as totalItem, groupname, 
			(CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'host') THEN hostname END) name, 
			(CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'host') THEN iphost END) ip, 
			COUNT(eventid) tongvande, 
			SUM(CASE WHEN severity = 0 THEN 1 ELSE 0 END) chuabiet,
			SUM(CASE WHEN severity = 1 THEN 1 ELSE 0 END) thongtin,
			SUM(CASE WHEN severity = 2 THEN 1 ELSE 0 END) canhbao,
			SUM(CASE WHEN severity = 3 THEN 1 ELSE 0 END) trungbinh,
			SUM(CASE WHEN severity = 4 THEN 1 ELSE 0 END) cao,
			SUM(CASE WHEN severity = 5 THEN 1 ELSE 0 END) nghiemtrong
			FROM
	(SELECT ROW_NUMBER() OVER (PARTITION BY objectid ORDER BY clock DESC) rnum,* FROM v_problems) tblAll WHERE rnum = 1 
		AND (@p_listGroup IS NULL OR @p_listGroup = '' OR (@p_listGroup != '' AND groupid IN ((SELECT * FROM dbo.ConvertDelimitedListIntoTable(@p_listGroup,',')))))
		AND (@p_trangThai IS NULL OR @p_trangThai = '' OR (@p_trangThai = '1' AND r_eventid IS NOT NULL) OR (@p_trangThai = '0' AND r_eventid IS NULL))
		AND (@p_tuNgay IS NULL OR (clock >= (CAST(Datediff(s, '1970-01-01', @p_tuNgay) AS BIGINT)))) 
		AND (@p_denNgay IS NULL OR (clock <= (CAST(Datediff(s, '1970-01-01', @p_denNgay) AS BIGINT))))
	GROUP BY (CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'host') THEN hostname END), 
			(CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'host') THEN iphost END), groupname) tblAll WHERE ((@p_pageIndex = 0 AND @p_pageSize = 0) 
			OR (tblAll.rnum BETWEEN ((@p_pageIndex - 1) * @p_pageSize + 1) AND (@p_pageIndex * @p_pageSize)));
END  


GO




CREATE PROCEDURE [dbo].[DeXuatNhomThietBi]
(
@p_listGroup AS NVARCHAR(MAX),
@p_listHost AS NVARCHAR(MAX),
@p_groupBy AS NVARCHAR(50),
@p_groupTime AS NVARCHAR(50),
@p_keyType AS NVARCHAR(50),
@p_getDetail AS INT,
@p_tuNgay AS DATE,
@p_denNgay AS DATE,
@p_pageIndex AS INT,
@p_pageSize AS INT,
@p_columnName AS NVARCHAR(50),
@p_orderBy AS NVARCHAR(50)
)
AS  
BEGIN 
	DECLARE @KyTu NVARCHAR(50) = '';
	DECLARE @Value NVARCHAR(50) = '';
	SET @Value = (SELECT TOP 1 MoTa FROM HeThongThamSo WHERE @p_keyType IS NULL 
				OR (@p_keyType = 'cpu' AND MaThamSo = 'CPU')
				OR (@p_keyType = 'ram' AND MaThamSo = 'RAM')
				OR (@p_keyType = 'hdd' AND MaThamSo = N'Ổ cứng')
				OR (@p_keyType = 'bwi' AND MaThamSo = N'Băng thông vào')	
				OR (@p_keyType = 'bwo' AND MaThamSo = N'Băng thông ra')	
				--OR (@p_keyType = 'bwd' AND (MaThamSo = 'Băng thông vào' OR MaThamSo = 'Băng thông ra'))
				)
	SET @KyTu = (SELECT TOP 1 TenThamSo FROM HeThongThamSo WHERE @p_keyType IS NULL 
				OR (@p_keyType = 'cpu' AND MaThamSo = 'CPU')
				OR (@p_keyType = 'ram' AND MaThamSo = 'RAM')
				OR (@p_keyType = 'hdd' AND MaThamSo = N'Ổ cứng')
				OR (@p_keyType = 'bwi' AND MaThamSo = N'Băng thông vào')	
				OR (@p_keyType = 'bwo' AND MaThamSo = N'Băng thông ra')	
				--OR (@p_keyType = 'bwd' AND (MaThamSo = 'Băng thông vào' OR MaThamSo = 'Băng thông ra'))
				)
	SELECT * FROM (SELECT ROW_NUMBER() OVER(ORDER BY yearval desc, stt desc, name) rnum, * FROM (SELECT avg(value_avg) value,
	(CASE WHEN (@p_groupTime IS NULL OR @p_groupTime = '' OR @p_groupTime = 'month') THEN monthval 
			WHEN @p_groupTime = 'year' THEN CAST(yearval AS nvarchar) 
			WHEN @p_groupTime = 'quarter' THEN quarterval
			WHEN @p_groupTime = 'week' THEN weekval 
			ELSE CAST(CAST(Datediff(s, '1970-01-01', dateval) AS BIGINT) AS nvarchar) END) stt, yearval, groupname,
		(CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'group') THEN groupname ELSE hostname END) name, (CASE WHEN @p_getDetail = 1 AND @p_groupBy = 'host' THEN ip END) ip, (CASE WHEN @p_getDetail = 1 THEN itemname END) itemname,
	(CASE WHEN (@p_groupTime IS NULL OR @p_groupTime = '' OR @p_groupTime = 'month') THEN monthlabel
			WHEN @p_groupTime = 'year' THEN CAST(yearval AS nvarchar) 
			WHEN @p_groupTime = 'quarter' THEN quarterlabel
			WHEN @p_groupTime = 'week' THEN weeklabel
			ELSE datelabel END) timelabel,
	(REPLACE(CAST(ROUND(min(value_min), 2) AS decimal(32,2)),'.00','') + ' ' + units) minval, 
	(REPLACE(CAST(ROUND(avg(value_avg), 2) AS decimal(32,2)),'.00','') + ' ' + units) avgval, 
	(REPLACE(CAST(ROUND(avg(value_max), 2) AS decimal(32,2)),'.00','') + ' ' + units) maxval 
	FROM v_performance 
	WHERE 1=1 
	--dateval >= DATEADD(month,-12,GETDATE()) AND dateval <= DATEADD(month,-4,GETDATE()) 
		AND (@p_tuNgay IS NULL OR (dateval >= @p_tuNgay)) 
		AND (@p_denNgay IS NULL OR (dateval <= @p_denNgay))
		AND (@p_keyType IS NULL 
				OR (@p_keyType = 'cpu' AND key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'DeXuatCPU'), '%'))
				OR (@p_keyType = 'ram' AND key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'DeXuatRAM'), '%'))
				OR (@p_keyType = 'hdd' AND key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'DeXuatHDD'), '%'))
				OR (@p_keyType = 'bwi' AND key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'DeXuatBangThongVao'), '%'))	
				OR (@p_keyType = 'bwo' AND key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'DeXuatBangThongRa'), '%'))	
				OR (@p_keyType = 'bwd' AND (key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'DeXuatBangThongVao'), '%') 
												OR key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'DeXuatBangThongRa'), '%')))			
		)
		AND (@KyTu IS NULL OR @KyTu = ''
				OR (@KyTu = '>=' AND value_avg >= @Value)
				OR (@KyTu = '>' AND value_avg > @Value)
				OR (@KyTu = '<' AND value_avg < @Value)
				OR (@KyTu = '<=' AND value_avg <= @Value)
				OR (@KyTu = '=' AND value_avg = @Value)
							)
		AND (@p_listGroup IS NULL OR @p_listGroup = '' OR (@p_listGroup != '' AND groupid IN ((SELECT * FROM dbo.ConvertDelimitedListIntoTable(@p_listGroup,','))))) 
		AND (@p_listHost IS NULL OR @p_listHost = '' OR (@p_listHost != '' AND LOWER(hostname) LIKE LOWER('%' + @p_listHost + '%'))) 
	GROUP BY units, yearval, groupname, (CASE WHEN @p_getDetail = 1 AND @p_groupBy = 'host' THEN ip END), (CASE WHEN @p_getDetail = 1 THEN itemname END),
	(CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'group') THEN groupname ELSE hostname END), 
	(CASE WHEN (@p_groupTime IS NULL OR @p_groupTime = '' OR @p_groupTime = 'month') THEN monthval
			WHEN @p_groupTime = 'year' THEN CAST(yearval AS nvarchar) 
			WHEN @p_groupTime = 'quarter' THEN quarterval
			WHEN @p_groupTime = 'week' THEN weekval
			ELSE CAST(CAST(Datediff(s, '1970-01-01', dateval) AS BIGINT) AS nvarchar) END),
			(CASE WHEN (@p_groupTime IS NULL OR @p_groupTime = '' OR @p_groupTime = 'month') THEN monthlabel
			WHEN @p_groupTime = 'year' THEN CAST(yearval AS nvarchar) 
			WHEN @p_groupTime = 'quarter' THEN quarterlabel
			WHEN @p_groupTime = 'week' THEN weeklabel
			ELSE datelabel END) 
) subTBL) tblAll WHERE (@p_pageIndex = 0 AND @p_pageSize = 0 OR (tblAll.rnum BETWEEN ((@p_pageIndex - 1) * @p_pageSize + 1) AND (@p_pageIndex * @p_pageSize)));
	
	--SELECT name, (totalThietBi - totalLoi) totalThietBiKhongLoi, totalLoi, totalThietBi FROM (SELECT ROW_NUMBER() OVER(ORDER BY name) rnum,*, (SELECT COUNT(hostid) FROM hosts_groups WHERE groupid = t1.groupid) totalThietBi, (SELECT COUNT(hostid) FROM hosts_groups WHERE groupid = t1.groupid AND hostid IN (SELECT hostid FROM v_problems WHERE (@p_tuNgay IS NULL OR (clock >= (CAST(Datediff(s, '1970-01-01', @p_tuNgay) AS BIGINT)))) 
	--AND (@p_denNgay IS NULL OR (clock <= (CAST(Datediff(s, '1970-01-01', @p_denNgay) AS BIGINT)))))) totalLoi FROM hstgrp t1 WHERE groupid IN (SELECT groupid from hosts_groups) AND LOWER(name) NOT LIKE '%Templates%'
	--AND (@p_listGroup IS NULL OR @p_listGroup = '' OR (@p_listGroup != '' AND groupid IN ((SELECT * FROM dbo.ConvertDelimitedListIntoTable(@p_listGroup,',')))))
	--) tblAll WHERE (@p_pageIndex = 0 AND @p_pageSize = 0 OR (tblAll.rnum BETWEEN ((@p_pageIndex - 1) * @p_pageSize + 1) AND (@p_pageIndex * @p_pageSize)));
END  


GO


CREATE PROCEDURE [dbo].[GetFilterHieuNang]
(
@p_groupTime AS NVARCHAR(50)
)
AS  
BEGIN 
	SELECT DISTINCT timeval, timelabel, yearval FROM (SELECT 
	(CASE WHEN (@p_groupTime IS NULL OR @p_groupTime = '' OR @p_groupTime = 'month') THEN monthval 
			WHEN @p_groupTime = 'year' THEN CAST(yearval AS nvarchar) 
			WHEN @p_groupTime = 'quarter' THEN quarterval
			WHEN @p_groupTime = 'week' THEN weekval 
			ELSE CAST(dateval AS nvarchar) END) timeval,
	(CASE WHEN (@p_groupTime IS NULL OR @p_groupTime = '' OR @p_groupTime = 'month') THEN monthlabel
			WHEN @p_groupTime = 'year' THEN CAST(yearval AS nvarchar) 
			WHEN @p_groupTime = 'quarter' THEN quarterlabel
			WHEN @p_groupTime = 'week' THEN weeklabel
			ELSE datelabel END) timelabel, yearval 
	FROM v_performanceFilter 
		) tblAll ORDER BY yearval desc, timeval desc
END  


GO



CREATE PROCEDURE [dbo].[GetNhomThietBi] 
AS  
BEGIN 
	SELECT * FROM hstgrp WHERE groupid IN (SELECT groupid from hosts_groups) AND LOWER(name) NOT LIKE '%Templates%' ORDER BY name;
END  


GO


CREATE PROCEDURE [dbo].[GetProblemDetail]
(
@p_listGroup AS NVARCHAR(MAX) = '',
@p_trangThai AS NVARCHAR(MAX),
@p_groupBy AS NVARCHAR(50),
@p_capDo AS INT,
@p_tuNgay AS DATETIME,
@p_denNgay AS DATETIME,
@p_pageIndex AS INT,
@p_pageSize AS INT,
@p_columnName AS NVARCHAR(50),
@p_orderBy AS NVARCHAR(50)
)
AS  
BEGIN 
	SELECT * FROM (SELECT ROW_NUMBER() OVER(ORDER BY groupname, (CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'host') THEN hostname END), createDate desc) rnum, 
			COUNT(groupname) OVER() as totalItem,(CASE WHEN r_eventid IS NULL THEN 0 ELSE 1 END) trangThai, severity, groupname, hostname name, iphost ip, problemname, thoigiantao, thoigiantontai, CASE severity WHEN 0 THEN N'Chưa biết' WHEN 1 THEN N'Thông tin' WHEN 2 THEN N'Cảnh báo' WHEN 3 THEN N'Trung bình' WHEN 4 THEN N'Cao' WHEN 5 THEN N'Nghiêm trọng' END capDo, (CASE WHEN r_eventid IS NULL THEN N'Chưa xử lý' ELSE N'Đã hoàn thành' END) trangThaiStr
			FROM
	(SELECT ROW_NUMBER() OVER (PARTITION BY objectid ORDER BY clock DESC) rnum,* FROM v_problems) tblAll WHERE rnum = 1 
		AND (@p_listGroup IS NULL OR @p_listGroup = '' OR (@p_listGroup != '' AND groupid IN ((SELECT * FROM dbo.ConvertDelimitedListIntoTable(@p_listGroup,',')))))
		AND (@p_trangThai IS NULL OR @p_trangThai = '' OR (@p_trangThai = '1' AND r_eventid IS NOT NULL) OR (@p_trangThai = '0' AND r_eventid IS NULL))
		AND (@p_capDo IS NULL OR (@p_capDo Is NOT NULL AND severity = @p_capDo))
		AND (@p_tuNgay IS NULL OR (clock >= (CAST(Datediff(s, '1970-01-01', @p_tuNgay) AS BIGINT)))) 
		AND (@p_denNgay IS NULL OR (clock <= (CAST(Datediff(s, '1970-01-01', @p_denNgay) AS BIGINT))))
	--GROUP BY (CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'host') THEN hostname END), 
	--		(CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'host') THEN iphost END), groupname
	) tblAll WHERE ((@p_pageIndex = 0 AND @p_pageSize = 0) 
			OR (tblAll.rnum BETWEEN ((@p_pageIndex - 1) * @p_pageSize + 1) AND (@p_pageIndex * @p_pageSize)));
END  


GO


CREATE PROCEDURE [dbo].[HieuNangNhomThietBi]
(
@p_listGroup AS NVARCHAR(MAX),
@p_listHost AS NVARCHAR(MAX),
@p_groupBy AS NVARCHAR(50),
@p_groupTime AS NVARCHAR(50),
@p_keyType AS NVARCHAR(50),
@p_getDetail AS INT,
@p_tuNgay AS DATE,
@p_denNgay AS DATE,
@p_pageIndex AS INT,
@p_pageSize AS INT,
@p_columnName AS NVARCHAR(50),
@p_orderBy AS NVARCHAR(50)
)
AS  
BEGIN 
	SELECT * FROM (SELECT ROW_NUMBER() OVER(ORDER BY yearval desc, stt desc, name) rnum, * FROM (SELECT avg(value_avg) value,
	(CASE WHEN (@p_groupTime IS NULL OR @p_groupTime = '' OR @p_groupTime = 'month') THEN monthval 
			WHEN @p_groupTime = 'year' THEN CAST(yearval AS nvarchar) 
			WHEN @p_groupTime = 'quarter' THEN quarterval
			WHEN @p_groupTime = 'week' THEN weekval 
			ELSE CAST(CAST(Datediff(s, '1970-01-01', dateval) AS BIGINT) AS nvarchar) END) stt, yearval, groupname,
		(CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'group') THEN groupname ELSE hostname END) name, (CASE WHEN @p_getDetail = 1 AND @p_groupBy = 'host' THEN ip END) ip, (CASE WHEN @p_getDetail = 1 THEN itemname END) itemname,
	(CASE WHEN (@p_groupTime IS NULL OR @p_groupTime = '' OR @p_groupTime = 'month') THEN monthlabel
			WHEN @p_groupTime = 'year' THEN CAST(yearval AS nvarchar) 
			WHEN @p_groupTime = 'quarter' THEN quarterlabel
			WHEN @p_groupTime = 'week' THEN weeklabel
			ELSE datelabel END) timelabel,
	(REPLACE(CAST(ROUND(min(value_min), 2) AS decimal(32,2)),'.00','') + ' ' + units) minval, 
	(REPLACE(CAST(ROUND(avg(value_avg), 2) AS decimal(32,2)),'.00','') + ' ' + units) avgval, 
	(REPLACE(CAST(ROUND(avg(value_max), 2) AS decimal(32,2)),'.00','') + ' ' + units) maxval 
	FROM v_performance 
	WHERE 1=1 
	--dateval >= DATEADD(month,-12,GETDATE()) AND dateval <= DATEADD(month,-4,GETDATE()) 
		AND (@p_tuNgay IS NULL OR (dateval >= @p_tuNgay)) 
		AND (@p_denNgay IS NULL OR (dateval <= @p_denNgay))
		AND (@p_keyType IS NULL 
				OR (@p_keyType = 'cpu' AND key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'HieuNangCPU'), '%'))
				OR (@p_keyType = 'ram' AND key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'HieuNangRAM'), '%'))
				OR (@p_keyType = 'hdd' AND key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'HieuNangHDD'), '%'))
				OR (@p_keyType = 'bwi' AND key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'BangThongVao'), '%'))	
				OR (@p_keyType = 'bwo' AND key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'BangThongRa'), '%'))	
				OR (@p_keyType = 'bwd' AND (key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'BangThongVao'), '%') 
												OR key_ LIKE CONCAT('%', (SELECT MoTa FROM HeThongThamSo WHERE MaThamSo LIKE 'BangThongRa'), '%')))			)
		AND (@p_listGroup IS NULL OR @p_listGroup = '' OR (@p_listGroup != '' AND groupid IN ((SELECT * FROM dbo.ConvertDelimitedListIntoTable(@p_listGroup,','))))) 
		AND (@p_listHost IS NULL OR @p_listHost = '' OR (@p_listHost != '' AND LOWER(hostname) LIKE LOWER('%' + @p_listHost + '%'))) 
	GROUP BY units, yearval, groupname, (CASE WHEN @p_getDetail = 1 AND @p_groupBy = 'host' THEN ip END), (CASE WHEN @p_getDetail = 1 THEN itemname END),
	(CASE WHEN (@p_groupBy IS NULL OR @p_groupBy = '' OR @p_groupBy = 'group') THEN groupname ELSE hostname END), 
	(CASE WHEN (@p_groupTime IS NULL OR @p_groupTime = '' OR @p_groupTime = 'month') THEN monthval
			WHEN @p_groupTime = 'year' THEN CAST(yearval AS nvarchar) 
			WHEN @p_groupTime = 'quarter' THEN quarterval
			WHEN @p_groupTime = 'week' THEN weekval
			ELSE CAST(CAST(Datediff(s, '1970-01-01', dateval) AS BIGINT) AS nvarchar) END),
			(CASE WHEN (@p_groupTime IS NULL OR @p_groupTime = '' OR @p_groupTime = 'month') THEN monthlabel
			WHEN @p_groupTime = 'year' THEN CAST(yearval AS nvarchar) 
			WHEN @p_groupTime = 'quarter' THEN quarterlabel
			WHEN @p_groupTime = 'week' THEN weeklabel
			ELSE datelabel END) 
) subTBL) tblAll WHERE (@p_pageIndex = 0 AND @p_pageSize = 0 OR (tblAll.rnum BETWEEN ((@p_pageIndex - 1) * @p_pageSize + 1) AND (@p_pageIndex * @p_pageSize)));
	
	--SELECT name, (totalThietBi - totalLoi) totalThietBiKhongLoi, totalLoi, totalThietBi FROM (SELECT ROW_NUMBER() OVER(ORDER BY name) rnum,*, (SELECT COUNT(hostid) FROM hosts_groups WHERE groupid = t1.groupid) totalThietBi, (SELECT COUNT(hostid) FROM hosts_groups WHERE groupid = t1.groupid AND hostid IN (SELECT hostid FROM v_problems WHERE (@p_tuNgay IS NULL OR (clock >= (CAST(Datediff(s, '1970-01-01', @p_tuNgay) AS BIGINT)))) 
	--AND (@p_denNgay IS NULL OR (clock <= (CAST(Datediff(s, '1970-01-01', @p_denNgay) AS BIGINT)))))) totalLoi FROM hstgrp t1 WHERE groupid IN (SELECT groupid from hosts_groups) AND LOWER(name) NOT LIKE '%Templates%'
	--AND (@p_listGroup IS NULL OR @p_listGroup = '' OR (@p_listGroup != '' AND groupid IN ((SELECT * FROM dbo.ConvertDelimitedListIntoTable(@p_listGroup,',')))))
	--) tblAll WHERE (@p_pageIndex = 0 AND @p_pageSize = 0 OR (tblAll.rnum BETWEEN ((@p_pageIndex - 1) * @p_pageSize + 1) AND (@p_pageIndex * @p_pageSize)));
END  


GO


CREATE PROCEDURE [dbo].[HostsByGroup]
(
@p_listGroup AS NVARCHAR(MAX),
@p_hostname AS NVARCHAR(MAX),
@p_pageIndex AS INT,
@p_pageSize AS INT,
@p_columnName AS NVARCHAR(50),
@p_orderBy AS NVARCHAR(50)
)
AS  
BEGIN 
	SELECT groupname, hostname, ip, happlications, hitems, htriggers FROM (
	SELECT ROW_NUMBER() OVER(ORDER BY t1.hostid) rnum, t1.hostid, t3.name groupname, t1.name hostname, (SELECT ip FROM interface WHERE hostid = t1.hostid) ip, (SELECT COUNT(*) FROM applications WHERE hostid = t1.hostid) happlications, (SELECT COUNT(*) FROM items WHERE hostid = t1.hostid) hitems, (SELECT COUNT(DISTINCT triggerid) FROM functions WHERE itemid IN (SELECT itemid FROM items WHERE hostid = t1.hostid)) htriggers FROM hosts t1, hosts_groups t2, hstgrp t3 WHERE t1.hostid = t2.hostid AND t2.groupid = t3.groupid AND LOWER(t3.name) NOT LIKE '%Templates%' 
	AND (@p_hostname IS NULL OR @p_hostname = '' OR (@p_hostname != '' AND LOWER(t1.name) LIKE LOWER('%' + @p_hostname + '%')))
	AND (@p_listGroup IS NULL OR @p_listGroup = '' OR (@p_listGroup != '' AND t3.groupid IN ((SELECT * FROM dbo.ConvertDelimitedListIntoTable(@p_listGroup,',')))))
	) tblAll WHERE (@p_pageIndex = 0 AND @p_pageSize = 0 OR (tblAll.rnum BETWEEN ((@p_pageIndex - 1) * @p_pageSize + 1) AND (@p_pageIndex * @p_pageSize)));
END  


GO




CREATE PROCEDURE [dbo].[AutoInsert]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO HistoryCustomReport(itemid,value_min,value_avg,value_max,createdDate,maxClock,minClock) 
SELECT itemid, min(value) minval, avg(value) avgval, max(value) maxval, clockConvert, max(clock) maxclock, min(clock) minclock FROM (SELECT *, CAST(dateadd(s, convert(bigint, clock), convert(datetime, '1-1-1970 7:00:00')) AS DATE) clockConvert FROM history WHERE clock > (SELECT CASE WHEN min(maxclock) IS NULL THEN 0 ELSE min(maxclock) END FROM HistoryCustomReport)) tblAll GROUP BY itemid, clockConvert;

	INSERT INTO HistoryCustomReport(itemid,value_min,value_avg,value_max,createdDate,maxClock,minClock) 
SELECT itemid, min(value_min) minval, avg(value_avg) avgval, max(value_max) maxval, clockConvert, max(clock) maxclock, min(clock) minclock FROM (SELECT *, CAST(dateadd(s, convert(bigint, clock), convert(datetime, '1-1-1970 7:00:00')) AS DATETIME) clockConvert FROM trends WHERE clock < (SELECT min(clock) FROM history)) tblAll GROUP BY itemid, clockConvert;

    INSERT INTO HistoryCustomFilter (monthval, quarterval, weekval, yearval, dateval, monthlabel, quarterlabel, weeklabel, datelabel) SELECT DISTINCT monthval, quarterval, weekval, yearval, dateval, monthlabel, quarterlabel, weeklabel, datelabel  FROM  v_performance where datelabel NOT IN (SELECT datelabel from HistoryCustomFilter);
END

GO