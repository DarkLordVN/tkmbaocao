USE [sysmanTNOK]
GO
/****** Object:  StoredProcedure [dbo].[CountHostsByGroup]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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

GO
/****** Object:  StoredProcedure [dbo].[CountProblemByGroup]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CountProblemByGroup]
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
	--SELECT * FROM (SELECT ROW_NUMBER() OVER(ORDER BY groupname) rnum, COUNT(groupname) OVER() as totalItem,groupname, COUNT(eventid) tongvande, SUM(CASE WHEN r_eventid IS NULL THEN 1 ELSE 0 END) chuaxuly, SUM(CASE WHEN r_eventid IS NOT NULL THEN 1 ELSE 0 END) daxuly FROM (SELECT ROW_NUMBER() OVER (PARTITION BY t1.objectid ORDER BY t1.clock DESC) rnum,t7.name groupname, t7.groupid grid,t1.r_eventid, t1.eventid, t1.severity, t1.clock, t1.objectid  FROM problem t1, triggers t2, hosts t3, hosts_groups t4, functions t5, items t6, hstgrp t7, items t8, events t9 WHERE t1.objectid = t2.triggerid AND t3.hostid = t4.hostid AND t2.triggerid = t5.triggerid AND t8.itemid = t5.itemid AND t1.eventid = t9.eventid AND t6.itemid = t5.itemid AND t6.hostid = t3.hostid AND t7.groupid = t4.groupid AND lower(t7.name) NOT LIKE '%template%') tblAll WHERE rnum = 1 
	--AND (@p_listGroup IS NULL OR @p_listGroup = '' OR (@p_listGroup != '' AND grid IN ((SELECT * FROM dbo.ConvertDelimitedListIntoTable(@p_listGroup,',')))))
	--AND (@p_trangThai IS NULL OR @p_trangThai = '' OR (@p_trangThai = '1' AND r_eventid IS NOT NULL) OR (@p_trangThai = '0' AND r_eventid IS NULL))
	--AND (@p_tuNgay IS NULL OR (clock >= (CAST(Datediff(s, '1970-01-01', @p_tuNgay) AS BIGINT)))) 
	--AND (@p_denNgay IS NULL OR (clock <= (CAST(Datediff(s, '1970-01-01', @p_denNgay) AS BIGINT))))
	--GROUP BY groupname) tblAll WHERE ((@p_pageIndex = 0 AND @p_pageSize = 0) 
	--		OR (tblAll.rnum BETWEEN ((@p_pageIndex - 1) * @p_pageSize + 1) AND (@p_pageIndex * @p_pageSize)));

	SELECT * FROM (SELECT ROW_NUMBER() OVER(ORDER BY groupname) rnum, COUNT(groupname) OVER() as totalItem,groupname, COUNT(eventid) tongvande, SUM(CASE WHEN r_eventid IS NULL THEN 1 ELSE 0 END) chuaxuly, SUM(CASE WHEN r_eventid IS NOT NULL THEN 1 ELSE 0 END) daxuly FROM (SELECT ROW_NUMBER() OVER (PARTITION BY objectid ORDER BY clock DESC) rnum,* FROM v_problems) tblAll WHERE rnum = 1 
	AND (@p_listGroup IS NULL OR @p_listGroup = '' OR (@p_listGroup != '' AND grid IN ((SELECT * FROM dbo.ConvertDelimitedListIntoTable(@p_listGroup,',')))))
	AND (@p_trangThai IS NULL OR @p_trangThai = '' OR (@p_trangThai = '1' AND r_eventid IS NOT NULL) OR (@p_trangThai = '0' AND r_eventid IS NULL))
	AND (@p_tuNgay IS NULL OR (clock >= (CAST(Datediff(s, '1970-01-01', @p_tuNgay) AS BIGINT)))) 
	AND (@p_denNgay IS NULL OR (clock <= (CAST(Datediff(s, '1970-01-01', @p_denNgay) AS BIGINT))))
	GROUP BY groupname) tblAll WHERE ((@p_pageIndex = 0 AND @p_pageSize = 0) 
			OR (tblAll.rnum BETWEEN ((@p_pageIndex - 1) * @p_pageSize + 1) AND (@p_pageIndex * @p_pageSize)));
END  

GO
/****** Object:  StoredProcedure [dbo].[GetNhomThietBi]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetNhomThietBi] 
AS  
BEGIN 
	SELECT * FROM hstgrp WHERE groupid IN (SELECT groupid from hosts_groups) AND LOWER(name) NOT LIKE '%Templates%' ORDER BY name;
END  

GO
/****** Object:  StoredProcedure [dbo].[HostsByGroup]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  UserDefinedFunction [dbo].[ConvertDelimitedListIntoTable]    Script Date: 03/05/2021 23:57:07 ******/
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
/****** Object:  View [dbo].[v_problems]    Script Date: 03/05/2021 23:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_problems]
AS
SELECT t7.name AS groupname, t7.groupid AS grid, t1.r_eventid, t1.eventid, t1.severity, t1.clock, t1.objectid, t3.hostid, t3.status AS hoststatus, t3.flags AS hostflags, t3.name AS hostname
FROM     dbo.functions AS t5 INNER JOIN
                  dbo.problem AS t1 INNER JOIN
                  dbo.triggers AS t2 ON t1.objectid = t2.triggerid ON t5.triggerid = t2.triggerid INNER JOIN
                  dbo.items AS t8 ON t5.itemid = t8.itemid INNER JOIN
                  dbo.events AS t9 ON t1.eventid = t9.eventid INNER JOIN
                  dbo.items AS t6 ON t5.itemid = t6.itemid INNER JOIN
                  dbo.hosts_groups AS t4 INNER JOIN
                  dbo.hosts AS t3 ON t4.hostid = t3.hostid ON t6.hostid = t3.hostid INNER JOIN
                  dbo.hstgrp AS t7 ON t4.groupid = t7.groupid
WHERE  (LOWER(t7.name) NOT LIKE '%template%')

GO
SET IDENTITY_INSERT [dbo].[HeThongThamSo] ON 

INSERT [dbo].[HeThongThamSo] ([ID], [MaThamSo], [TenThamSo], [MoTa], [NguoiCapNhatID], [NgayCapNhat], [TrangThai]) VALUES (1, N'ip', N'IPZabbix', N'10.123456', 5, CAST(0x0000AD0D01810500 AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[HeThongThamSo] OFF
SET IDENTITY_INSERT [dbo].[NguoiDung] ON 

INSERT [dbo].[NguoiDung] ([ID], [HoVaTen], [NgaySinh], [GioiTinh], [NhomQuyenID], [NhomQuyenList], [ChucVuID], [DonViID], [TenDangNhap], [MatKhau], [AnhDaiDien], [Email], [SoDienThoai], [DiaChi], [Fax], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (5, N'Quản trị hệ thống SYSMAN', CAST(0x0000AD0A00000000 AS DateTime), 0, 1, N',1,', 0, 0, N'admin', N'4297F44B13955235245B2497399D7A93', N'/2021/04/14/14_04_21_10_45_53.jpg', NULL, N'0338971669', NULL, NULL, NULL, NULL, NULL, 5, N'admin', CAST(0x0000AD0C0187C661 AS DateTime), NULL, 1, 0)
INSERT [dbo].[NguoiDung] ([ID], [HoVaTen], [NgaySinh], [GioiTinh], [NhomQuyenID], [NhomQuyenList], [ChucVuID], [DonViID], [TenDangNhap], [MatKhau], [AnhDaiDien], [Email], [SoDienThoai], [DiaChi], [Fax], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (6, N'Nguyễn Văn A', CAST(0x0000AD0800000000 AS DateTime), 1, 1, N',1,2,', 0, 0, N'user1', N'4297F44B13955235245B2497399D7A93', N'/2021/04/18/18_04_21_00_07_13.jpg', N'lekhanhtoan.unv2010@gmail.com', N'0338971669', NULL, NULL, N'admin', CAST(0x0000AD0E0001FE05 AS DateTime), 5, NULL, NULL, NULL, NULL, 1, 0)
INSERT [dbo].[NguoiDung] ([ID], [HoVaTen], [NgaySinh], [GioiTinh], [NhomQuyenID], [NhomQuyenList], [ChucVuID], [DonViID], [TenDangNhap], [MatKhau], [AnhDaiDien], [Email], [SoDienThoai], [DiaChi], [Fax], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (7, N'Hoàng Thị Trà My', NULL, 0, 1, N',1,', 0, 0, N'user2', N'4297F44B13955235245B2497399D7A93', N'/2021/04/18/18_04_21_00_08_53.jpg', NULL, NULL, NULL, NULL, N'admin', CAST(0x0000AD0E0002758E AS DateTime), 5, NULL, NULL, NULL, NULL, 1, 0)
SET IDENTITY_INSERT [dbo].[NguoiDung] OFF
SET IDENTITY_INSERT [dbo].[NhatKyHeThong] ON 

INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (1, 0, N'Đăng xuất hệ thống', CAST(0x0000AD0A00AEBDB9 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (2, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0A00AF1427 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (3, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0A00B18215 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (4, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0A00B18474 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (5, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0A00B3F677 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (6, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0A00B3FA1A AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (7, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0A00B3FF63 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (8, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0A00B43D4E AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (9, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0A00D963A1 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (10, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0A00D9EC51 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (11, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0A00DA5FEA AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (12, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0A0139F29B AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (13, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0A013A1255 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (14, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0A0161E006 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (15, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0A018A0EC1 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (16, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0A018A471D AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (17, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0B0174B722 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (18, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0C0141C138 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (19, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0C0188CB02 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (20, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0C0188CE87 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (21, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0D000017C2 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (22, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0D00001A85 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (23, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0D00005657 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (24, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0D000073E0 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (25, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0D00015588 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (26, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0D000157DA AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (27, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0D00017B2B AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (28, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0D00017E3F AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (29, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0D0002B146 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (30, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0D0002B3BF AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (31, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0D00A63F7D AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (32, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0D00A9D836 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (33, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0D00A9DAB1 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (34, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0D012DB376 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (35, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0D012DBED6 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (36, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0D012F7E5C AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (37, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0D013CC160 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (38, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0D013E8527 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (39, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0D016215D0 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (40, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0E0002967F AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (41, 7, N'Đăng nhập hệ thống', CAST(0x0000AD0E0002A239 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (42, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0E008C8094 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (43, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0E00C55479 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (44, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0E014D7E12 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (45, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0E014D82EB AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (46, 5, N'Đăng xuất hệ thống', CAST(0x0000AD0E015E08B4 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (47, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0E015E0D6A AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (48, 5, N'Đăng nhập hệ thống', CAST(0x0000AD0F00050365 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (49, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1001586041 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (50, 5, N'Đăng xuất hệ thống', CAST(0x0000AD10017FB4CD AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (51, 5, N'Đăng nhập hệ thống', CAST(0x0000AD10017FB85F AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (52, 5, N'Đăng nhập hệ thống', CAST(0x0000AD11009A620E AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (53, 5, N'Đăng xuất hệ thống', CAST(0x0000AD1100A56F74 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (54, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1100A6C859 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (55, 5, N'Đăng nhập hệ thống', CAST(0x0000AD11015233BF AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (56, 5, N'Đăng nhập hệ thống', CAST(0x0000AD110189A06F AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (57, 5, N'Đăng nhập hệ thống', CAST(0x0000AD12016505C4 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (58, 5, N'Đăng nhập hệ thống', CAST(0x0000AD13018956C6 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (59, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1301895BA3 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (60, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1400AAEA0D AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (61, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1400F5C0EF AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (62, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1400F5C59A AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (63, 5, N'Đăng nhập hệ thống', CAST(0x0000AD140166C5E0 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (64, 5, N'Đăng nhập hệ thống', CAST(0x0000AD140166CBCE AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (65, 5, N'Đăng nhập hệ thống', CAST(0x0000AD15001482AC AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (66, 5, N'Đăng nhập hệ thống', CAST(0x0000AD150017EB09 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (67, 5, N'Đăng nhập hệ thống', CAST(0x0000AD15008909FD AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (68, 5, N'Đăng nhập hệ thống', CAST(0x0000AD15008909FD AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (69, 5, N'Đăng nhập hệ thống', CAST(0x0000AD150112006D AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (70, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1501120351 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (71, 5, N'Đăng nhập hệ thống', CAST(0x0000AD150161F109 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (72, 5, N'Đăng nhập hệ thống', CAST(0x0000AD150161FAEF AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (73, 5, N'Đăng nhập hệ thống', CAST(0x0000AD160096C439 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (74, 5, N'Đăng nhập hệ thống', CAST(0x0000AD16014633C8 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (75, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1700017A17 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (76, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1700A908F1 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (77, 5, N'Đăng xuất hệ thống', CAST(0x0000AD1700E22B7A AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (78, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1700E230E9 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (79, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1800054758 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (80, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1800E1465F AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (81, 5, N'Đăng nhập hệ thống', CAST(0x0000AD18014FBFDD AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (82, 5, N'Đăng nhập hệ thống', CAST(0x0000AD18017647F7 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (83, 5, N'Đăng nhập hệ thống', CAST(0x0000AD19013240AD AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (84, 5, N'Đăng nhập hệ thống', CAST(0x0000AD19016FF756 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (85, 5, N'Đăng nhập hệ thống', CAST(0x0000AD19018801D0 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (86, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1A00F0797E AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (87, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1A011F509A AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (88, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1A0156DB92 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (89, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1B00945778 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (90, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1B011AD4C0 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (91, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1B01520913 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (92, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1C014AFB6C AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (93, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1D009142B6 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (94, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1D00C8532B AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (95, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1D01147B64 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (96, 5, N'Đăng xuất hệ thống', CAST(0x0000AD1D011FD541 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (97, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1D011FDA73 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (98, 5, N'Đăng xuất hệ thống', CAST(0x0000AD1D012172D3 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (99, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1D0121766C AS DateTime), N'::1')
GO
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (100, 5, N'Đăng xuất hệ thống', CAST(0x0000AD1D012242C9 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (101, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1D01224645 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (102, 5, N'Đăng xuất hệ thống', CAST(0x0000AD1D0122C6CF AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (103, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1D0125A32C AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (104, 5, N'Đăng xuất hệ thống', CAST(0x0000AD1D012618C4 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (105, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1D01261C31 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (106, 5, N'Đăng xuất hệ thống', CAST(0x0000AD1D0127BA78 AS DateTime), N'192.168.126.1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (107, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1D0127BE60 AS DateTime), N'::1')
INSERT [dbo].[NhatKyHeThong] ([ID], [NguoiDungId], [MoTa], [NgayTao], [IpClient]) VALUES (108, 5, N'Đăng nhập hệ thống', CAST(0x0000AD1D015C5215 AS DateTime), N'::1')
SET IDENTITY_INSERT [dbo].[NhatKyHeThong] OFF
SET IDENTITY_INSERT [dbo].[NhomNguoiDung] ON 

INSERT [dbo].[NhomNguoiDung] ([ID], [TenNhom], [ListNguoiDungThuocNhomID], [PhamViSuDung], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [TrangThai], [IsDeleted]) VALUES (1, N'Quản trị hệ thống', N',5,', 0, N'admin', CAST(0x0000AD0B018AA64A AS DateTime), 5, NULL, NULL, NULL, 1, 0)
INSERT [dbo].[NhomNguoiDung] ([ID], [TenNhom], [ListNguoiDungThuocNhomID], [PhamViSuDung], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [TrangThai], [IsDeleted]) VALUES (2, N'Báo cáo', N',5,', 0, N'admin', CAST(0x0000AD0E000172E9 AS DateTime), 5, NULL, NULL, NULL, 1, 0)
SET IDENTITY_INSERT [dbo].[NhomNguoiDung] OFF
SET IDENTITY_INSERT [dbo].[NhomQuyen] ON 

INSERT [dbo].[NhomQuyen] ([ID], [KyHieu], [MaNhom], [TenNhom], [GhiChu], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (1, NULL, NULL, N'Quản trị hệ thống', NULL, N'admin', CAST(0x0000AD0B018AC84D AS DateTime), 5, 5, N'admin', CAST(0x0000AD1D01281A25 AS DateTime), 2, 1, 0)
INSERT [dbo].[NhomQuyen] ([ID], [KyHieu], [MaNhom], [TenNhom], [GhiChu], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (2, NULL, NULL, N'Báo cáo', NULL, N'admin', CAST(0x0000AD0B018AD2EC AS DateTime), 5, 5, N'admin', CAST(0x0000AD0B018ADFB2 AS DateTime), 1, 1, 0)
SET IDENTITY_INSERT [dbo].[NhomQuyen] OFF
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (1, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (3, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (4, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (5, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (7, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (8, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (9, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (10, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (11, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (12, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (13, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (14, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (15, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (16, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (17, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (18, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (19, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (20, 1, N',1,2,3,4,5,6,')
INSERT [dbo].[NhomQuyenQuyen] ([QuyenID], [NhomQuyenID], [QuyenChiTiet]) VALUES (21, 1, N',1,2,3,4,5,6,')
SET IDENTITY_INSERT [dbo].[Quyen] ON 

INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (1, 0, NULL, N'Quản trị hệ thống', 0, NULL, N'', N'fas fa-cogs', NULL, N'', NULL, 1, NULL, N'admin', CAST(0x0000AD0A00F2F660 AS DateTime), 5, 5, N'admin', CAST(0x0000AD0E014F1923 AS DateTime), 22, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (3, 1, NULL, N'Nhật ký hệ thống', 0, NULL, N'NhatKyHeThong', NULL, NULL, N'Index', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00029390 AS DateTime), 5, 5, N'admin', CAST(0x0000AD1D0120F5C3 AS DateTime), 35, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (4, 0, NULL, N'Tổng hợp thiết bị', 0, NULL, N'', N'fal fa-analytics', NULL, N'', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00A738AA AS DateTime), 5, 5, N'admin', CAST(0x0000AD0E014E5E3F AS DateTime), 5, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (5, 0, NULL, N'Báo cáo hiệu năng thiết bị', 0, NULL, N'', N'fal fa-book', NULL, N'', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00A75CC1 AS DateTime), 5, 5, N'admin', CAST(0x0000AD0E014E6712 AS DateTime), 8, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (7, 1, NULL, N'Nhóm người dùng', 0, NULL, N'NhomNguoiDung', N'fal fa-users', NULL, N'Index', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00A7D649 AS DateTime), 5, NULL, NULL, NULL, 16, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (8, 1, NULL, N'Người dùng', 0, NULL, N'NguoiDung', N'fal fa-user', NULL, N'Index', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00A80BEA AS DateTime), 5, NULL, NULL, NULL, 20, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (9, 1, NULL, N'Nhóm quyền', 0, NULL, N'NhomQuyen', N'far fa-atlas', NULL, N'Index', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00A93C0B AS DateTime), 5, NULL, NULL, NULL, 21, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (10, 1, NULL, N'Quyền', 0, NULL, N'Quyen', N'fal fa-atom-alt', NULL, N'Index?check', NULL, 1, NULL, N'admin', CAST(0x0000AD0D00A99D0A AS DateTime), 5, NULL, NULL, NULL, 22, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (11, 4, NULL, N'Số lượng theo nhóm', 0, NULL, N'BaoCao', NULL, NULL, N'TongThietBiNhom', NULL, 1, NULL, N'admin', CAST(0x0000AD0E014E375D AS DateTime), 5, 5, N'admin', CAST(0x0000AD1D011F78B0 AS DateTime), 4, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (12, 4, NULL, N'Chi tiết thiết bị theo nhóm', 0, NULL, N'BaoCao', NULL, NULL, N'ChiTietThietBiNhom', NULL, 1, NULL, N'admin', CAST(0x0000AD0E014E52F4 AS DateTime), 5, 5, N'admin', CAST(0x0000AD1D01224026 AS DateTime), 6, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (13, 0, NULL, N'Tổng hợp vấn đề', 0, NULL, N'', N'fa fa-compress', NULL, N'', NULL, 1, NULL, N'admin', CAST(0x0000AD0E014E7ECB AS DateTime), 5, 5, N'admin', CAST(0x0000AD1D01277AE2 AS DateTime), 9, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (14, 0, NULL, N'Thống kê số lượng vấn đề', 0, NULL, N'', NULL, NULL, N'Add', NULL, 1, NULL, N'admin', CAST(0x0000AD0E014E9427 AS DateTime), 5, NULL, NULL, NULL, 13, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (15, 0, NULL, N'Tình hình sử dụng băng thông', 0, NULL, N'', NULL, NULL, N'Add', NULL, 1, NULL, N'admin', CAST(0x0000AD0E01501125 AS DateTime), 5, NULL, NULL, NULL, 15, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (16, 0, NULL, N'Báo cáo hiệu năng máy chủ', 0, NULL, N'', NULL, NULL, N'Add', NULL, 1, NULL, N'admin', CAST(0x0000AD0E0150233D AS DateTime), 5, NULL, NULL, NULL, 17, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (17, 0, NULL, N'Báo cáo tổng hợp', 0, NULL, N'', NULL, NULL, N'Add', NULL, 1, NULL, N'admin', CAST(0x0000AD0E01504250 AS DateTime), 5, NULL, NULL, NULL, 18, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (18, 5, NULL, N'Tổng hợp theo CPU', 0, NULL, N'', NULL, NULL, N'Add', NULL, 1, NULL, N'admin', CAST(0x0000AD0E01512A7C AS DateTime), 5, NULL, NULL, NULL, 1, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (19, 5, NULL, N'Tổng hợp theo RAM', 0, NULL, N'', NULL, NULL, N'Add', NULL, 1, NULL, N'admin', CAST(0x0000AD0E01525F75 AS DateTime), 5, NULL, NULL, NULL, 2, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (20, 5, NULL, N'Tổng hợp theo ổ cứng', 0, NULL, N'', NULL, NULL, N'Add', NULL, 1, NULL, N'admin', CAST(0x0000AD0E015276F6 AS DateTime), 5, NULL, NULL, NULL, 3, 1, 0)
INSERT [dbo].[Quyen] ([ID], [KhoaChaID], [MaQuyen], [TenQuyen], [NhanQuyen], [TenHienThi], [Controller], [IconPath], [GhiChu], [Action], [FontAwesome], [IsMenu], [PhanHe], [NguoiTao], [NgayTao], [NguoiTaoID], [NguoiCapNhatID], [NguoiCapNhat], [NgayCapNhat], [ThuTu], [TrangThai], [IsDeleted]) VALUES (21, 13, NULL, N'Tổng vấn đề theo nhóm', 0, NULL, N'BaoCao', NULL, NULL, N'Index', NULL, 1, NULL, N'admin', CAST(0x0000AD1D01214D51 AS DateTime), 5, 5, N'admin', CAST(0x0000AD1D0121579D AS DateTime), 1, 1, 0)
SET IDENTITY_INSERT [dbo].[Quyen] OFF
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
