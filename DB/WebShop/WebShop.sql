USE [WebShop]
GO
/****** Object:  UserDefinedFunction [dbo].[GetProductIconGroupByFilter]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetProductIconGroupByFilter] ( 
	  @firstIconPriority int,
	  @featureDetailCombinationList nvarchar(max),
	  @delimiter varchar(max),
	  @parentIdList nvarchar(max),
	  @minPrice Decimal(18,2),
	  @maxPrice Decimal(18,2))
	  RETURNS @Output TABLE (
			
				Id uniqueidentifier not null,
				ParentId uniqueidentifier not null,
				ProductId int not null,
				IconUrl NVARCHAR(max),
				FeatureTypeId int,
				FeatureTypeName NVARCHAR(max),
				FeatureTypeDetailId int,
				BaseFeatureTypeDetailId int,
				FeatureTypeDetailPriority int,				
				FeatureTypeDetailName NVARCHAR(max)
			)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE @finalResult TABLE( 
								Id uniqueidentifier not null,
								ParentId uniqueidentifier not null,
								ProductId int not null,
								DetailIdPath nvarchar(max), 
								IconUrl NVARCHAR(max),
								FeatureTypeId int,
								FeatureTypeName NVARCHAR(max),
								FeatureTypeDetailId int,
								BaseFeatureTypeDetailId int,
								FeatureTypeDetailPriority int,
								FeatureTypeDetailName NVARCHAR(max)
				);

	declare @parentId nvarchar(max)
	declare @featureDetailTable table(detailId nvarchar(max)) 
	insert into @featureDetailTable SELECT * FROM dbo.SplitString(@featureDetailCombinationList, N',')
	DECLARE ParentIdCursor CURSOR FOR 
    SELECT * FROM dbo.SplitString(@parentIdList, N',')
	OPEN ParentIdCursor 
	 
	FETCH NEXT FROM ParentIdCursor INTO @parentId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		WITH  ViewProductFeatureTree (
								FeatureTypeDetailId,
								BaseFeatureTypeDetailId,
								FeatureTypeDetailName,
								DetailIdPath,
								Id, 
								ProductId, 
								ParentId,
								IconUrl,
								FeatureTypeId,
								FeatureTypeName,
								FeatureTypeDetailPriority

								) 
		AS 
		( 
			SELECT
			FeatureTypeDetailId,
			BaseFeatureTypeDetailId,
			FeatureTypeDetailName,
			'' + convert(varchar(max),BaseFeatureTypeDetailId), 
			Id, 
			ProductId, 
			ParentId,
			IconUrl,
			FeatureTypeId,
			FeatureTypeName,
			FeatureTypeDetailPriority
   
			FROM ViewProductFeature 
			WHERE ParentId = CONVERT(uniqueidentifier, @parentId) 
   
			UNION ALL
			SELECT
				vpf.FeatureTypeDetailId,
				vpf.BaseFeatureTypeDetailId,
				vpf.FeatureTypeDetailName,
				(convert(varchar(max),pft.BaseFeatureTypeDetailId) + @delimiter + convert(varchar(max), vpf.BaseFeatureTypeDetailId)) as DetailIdPath, 
				vpf.Id, 
				vpf.ProductId, 
				vpf.ParentId, 
	 			vpf.IconUrl,
				vpf.FeatureTypeId,
				vpf.FeatureTypeName,
				vpf.FeatureTypeDetailPriority

			FROM ViewProductFeature vpf, ViewProductFeatureTree pft 
			WHERE vpf.ParentId = pft.Id  and vpf.Price >= @minPrice and vpf.Price <= @maxPrice
		) 
		  
		insert into @finalResult 
			SELECT 
				Id,
				@ParentId,
				ProductId,
				DetailIdPath,
				IconUrl,
				FeatureTypeId,
				FeatureTypeName,
				FeatureTypeDetailId,
				BaseFeatureTypeDetailId,
				FeatureTypeDetailPriority,
				FeatureTypeDetailName
			FROM ViewProductFeatureTree 
		  
		FETCH NEXT FROM ParentIdCursor INTO @parentId
	END

	CLOSE ParentIdCursor
	DEALLOCATE ParentIdCursor

	if len(@featureDetailCombinationList) > 0 
	begin
		insert into @Output 
			select distinct 
				wsp.Id,
				fr.ParentId,
				wsp.ProductId,
				wsp.IconUrl,
				wsp.FeatureTypeId,
				wsp.FeatureTypeName,
				wsp.FeatureTypeDetailId,
				wsp.BaseFeatureTypeDetailId,
				wsp.FeatureTypeDetailPriority,
				wsp.FeatureTypeDetailName
				 
			from @finalResult fr 
				inner join ViewShopProduct wsp on fr.Id = wsp.Id
				WHERE  Exists  (select * from @featureDetailTable where detailId = DetailIdPath)
		end
	else
		begin
			insert into @Output 
				select distinct 
					wsp.Id,
					fr.ParentId,
					wsp.ProductId,
					wsp.IconUrl,
					wsp.FeatureTypeId,
					wsp.FeatureTypeName,
					wsp.FeatureTypeDetailId,
					wsp.BaseFeatureTypeDetailId,
					wsp.FeatureTypeDetailPriority,
					wsp.FeatureTypeDetailName
					 
				from @finalResult fr 

			inner join ViewShopProduct wsp on fr.Id = wsp.Id
	 
		end
	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitString]
(    
    @Input NVARCHAR(MAX),
    @Character nCHAR(1)
)
RETURNS @Output TABLE (
    Item NVARCHAR(max)
)
AS
BEGIN
    DECLARE @StartIndex INT, @EndIndex INT
 
    SET @StartIndex = 1
    IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
    BEGIN
        SET @Input = @Input + @Character
    END
 
    WHILE CHARINDEX(@Character, @Input) > 0
    BEGIN
        SET @EndIndex = CHARINDEX(@Character, @Input)
         
        INSERT INTO @Output(Item)
        SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
         
        SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
    END
 
    RETURN
END
GO
/****** Object:  Table [dbo].[BaseFeatureType]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BaseFeatureType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_BaseFeatureType_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BaseFeatureTypeDetail]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BaseFeatureTypeDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[BaseFeatureTypeId] [int] NOT NULL,
 CONSTRAINT [PK_BaseFeatureTypeDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[IsDefault] [bit] NOT NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FeatureType]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FeatureType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[BaseFeatureTypeId] [int] NOT NULL,
	[Priority] [int] NOT NULL,
 CONSTRAINT [PK_FeatureType_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FeatureTypeDetail]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FeatureTypeDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FeatureTypeId] [int] NOT NULL,
	[BaseFeatureTypeDetailId] [int] NOT NULL,
	[Priority] [int] NOT NULL,
 CONSTRAINT [PK_FeatureTypeDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Image]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Image](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[ImageUrl] [nvarchar](max) NULL,
	[Priority] [int] NOT NULL,
	[LinkUrl] [nvarchar](max) NULL,
	[ProductFeatureId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_WebShopImage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[IsPackage] [bit] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[QuantityUnitId] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Date] [datetime] NOT NULL,
	[ProductionDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[OccasionId] [smallint] NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductFeature]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductFeature](
	[Id] [uniqueidentifier] NOT NULL,
	[ParentId] [uniqueidentifier] NULL,
	[ProductId] [int] NOT NULL,
	[FeatureTypeDetailId] [int] NULL,
	[Price] [decimal](18, 2) NULL,
	[Quantity] [int] NULL,
	[Priority] [int] NOT NULL,
	[IconUrl] [nvarchar](max) NULL,
	[Showcase] [bit] NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_ProductFeature_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewProductFeatureFullInfo]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewProductFeatureFullInfo]
AS
SELECT        dbo.ProductFeature.Id, dbo.ProductFeature.ParentId, dbo.ProductFeature.ProductId, dbo.ProductFeature.FeatureTypeDetailId, dbo.BaseFeatureTypeDetail.Name AS FeatureTypeDetailName, 
                         dbo.BaseFeatureType.Name AS FeatureTypeName, dbo.ProductFeature.Price, dbo.ProductFeature.Quantity, dbo.FeatureTypeDetail.FeatureTypeId, dbo.ProductFeature.Priority, dbo.FeatureType.Priority AS FeatureTypePriority, 
                         dbo.FeatureTypeDetail.Priority AS FeatureTypeDetailPriority, dbo.ProductFeature.IconUrl, dbo.ProductFeature.Showcase, dbo.ProductFeature.Description, dbo.Product.CategoryId, dbo.Image.Title AS ImageTitle, 
                         dbo.Image.ImageUrl, dbo.Image.Priority AS ImagePriority, dbo.Image.LinkUrl, dbo.Category.Name AS CategoryName, dbo.Product.Description AS ProductDescription, dbo.Product.Name AS ProductName
FROM            dbo.BaseFeatureType INNER JOIN
                         dbo.FeatureTypeDetail INNER JOIN
                         dbo.FeatureType ON dbo.FeatureTypeDetail.FeatureTypeId = dbo.FeatureType.Id ON dbo.BaseFeatureType.Id = dbo.FeatureType.BaseFeatureTypeId INNER JOIN
                         dbo.BaseFeatureTypeDetail ON dbo.FeatureTypeDetail.BaseFeatureTypeDetailId = dbo.BaseFeatureTypeDetail.Id RIGHT OUTER JOIN
                         dbo.ProductFeature INNER JOIN
                         dbo.Product ON dbo.ProductFeature.ProductId = dbo.Product.Id INNER JOIN
                         dbo.Category ON dbo.Product.CategoryId = dbo.Category.Id LEFT OUTER JOIN
                         dbo.Image ON dbo.ProductFeature.Id = dbo.Image.ProductFeatureId ON dbo.FeatureTypeDetail.Id = dbo.ProductFeature.FeatureTypeDetailId
GO
/****** Object:  View [dbo].[ViewShopProduct]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewShopProduct]
AS
SELECT       dbo.ProductFeature.Id, dbo.ProductFeature.ParentId, dbo.ProductFeature.ProductId, dbo.ProductFeature.FeatureTypeDetailId, dbo.BaseFeatureTypeDetail.Name AS FeatureTypeDetailName, 
                         dbo.BaseFeatureType.Name AS FeatureTypeName, dbo.ProductFeature.Price, dbo.ProductFeature.Quantity, dbo.FeatureTypeDetail.FeatureTypeId, dbo.ProductFeature.Priority, dbo.FeatureType.Priority AS FeatureTypePriority, 
                         dbo.FeatureTypeDetail.Priority AS FeatureTypeDetailPriority, dbo.ProductFeature.IconUrl, dbo.Image.Title AS ImageTitle, dbo.Image.ImageUrl, dbo.Image.Priority AS ImagePriority, dbo.Image.LinkUrl, dbo.ProductFeature.Showcase, 
                         dbo.Product.ProductionDate, dbo.Product.ExpiryDate, dbo.Product.Name AS ProductName, dbo.Product.CategoryId, dbo.Product.Description AS ProductDescription, dbo.ProductFeature.Description, 
                         dbo.Category.Name AS CategoryName, dbo.FeatureTypeDetail.BaseFeatureTypeDetailId
FROM            dbo.Image INNER JOIN
                         dbo.ProductFeature ON dbo.Image.ProductFeatureId = dbo.ProductFeature.Id INNER JOIN
                         dbo.FeatureTypeDetail INNER JOIN
                         dbo.FeatureType ON dbo.FeatureTypeDetail.FeatureTypeId = dbo.FeatureType.Id ON dbo.ProductFeature.FeatureTypeDetailId = dbo.FeatureTypeDetail.Id INNER JOIN
                         dbo.Product ON dbo.ProductFeature.ProductId = dbo.Product.Id INNER JOIN
                         dbo.Category ON dbo.Product.CategoryId = dbo.Category.Id INNER JOIN
                         dbo.BaseFeatureType ON dbo.FeatureType.BaseFeatureTypeId = dbo.BaseFeatureType.Id INNER JOIN
                         dbo.BaseFeatureTypeDetail ON dbo.FeatureTypeDetail.BaseFeatureTypeDetailId = dbo.BaseFeatureTypeDetail.Id
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](max) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](max) NOT NULL,
	[RegisterDate] [datetime] NULL,
	[AuthenticationCode] [nvarchar](max) NULL,
	[LastSignIn] [datetime] NULL,
	[UserDefiner] [nvarchar](max) NULL,
	[AllowAcceptReject] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewUserRole]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ViewUserRole]
AS
SELECT       dbo.AspNetRoles.Id, dbo.AspNetUserRoles.UserId, dbo.AspNetRoles.Name AS RoleName, dbo.AspNetUsers.UserName
FROM            dbo.AspNetUserRoles INNER JOIN
                         dbo.AspNetRoles ON dbo.AspNetUserRoles.RoleId = dbo.AspNetRoles.Id INNER JOIN
                         dbo.AspNetUsers ON dbo.AspNetUserRoles.UserId = dbo.AspNetUsers.Id
GO
/****** Object:  Table [dbo].[Order]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceId] [int] NOT NULL,
	[ProductFeatureId] [uniqueidentifier] NOT NULL,
	[Date] [datetime] NOT NULL,
	[State] [int] NOT NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[Quantity] [int] NOT NULL,
	[RecipientTypeId] [int] NULL,
	[OccasionId] [int] NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[State] [int] NULL,
	[TempCartId] [uniqueidentifier] NULL,
	[UserId] [nvarchar](128) NULL,
	[Title] [nvarchar](max) NULL,
	[Date] [datetime] NOT NULL,
	[TransactionNo] [nvarchar](max) NULL,
	[Subtotal] [decimal](18, 2) NOT NULL,
	[Tax] [decimal](18, 2) NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[AmountDue] [decimal](18, 2) NOT NULL,
	[Finished] [bit] NOT NULL,
 CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewOrder]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewOrder]
AS
SELECT       dbo.[Order].Id, dbo.[Order].ProductFeatureId, dbo.[Order].Date, dbo.[Order].State, dbo.[Order].Price, dbo.[Order].Quantity, dbo.[Order].RecipientTypeId, dbo.[Order].OccasionId, dbo.Product.Name, dbo.Image.ImageUrl, 
                         CAST(0 AS decimal(18, 2)) AS TotalPrice, 0 AS TotalQuantity, dbo.ProductFeature.IconUrl, dbo.Product.CategoryId, dbo.Invoice.UserId, dbo.Invoice.TempCartId, dbo.Invoice.Id AS InvoiceId, dbo.Invoice.Title, 
                         dbo.Invoice.Date AS InvoiceDate, dbo.Invoice.TransactionNo, dbo.Invoice.Subtotal, dbo.Invoice.Tax, dbo.Invoice.Total, dbo.Invoice.AmountDue, dbo.Invoice.Finished, dbo.Invoice.State AS InvoiceState
FROM            dbo.[Order] INNER JOIN
                         dbo.ProductFeature ON dbo.[Order].ProductFeatureId = dbo.ProductFeature.Id INNER JOIN
                         dbo.Product ON dbo.ProductFeature.ProductId = dbo.Product.Id INNER JOIN
                         dbo.Invoice ON dbo.[Order].InvoiceId = dbo.Invoice.Id LEFT OUTER JOIN
                         dbo.Image ON dbo.[Order].ProductFeatureId = dbo.Image.ProductFeatureId AND dbo.Image.Priority = 1
GO
/****** Object:  Table [dbo].[CategoryField]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoryField](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CategoryId] [int] NOT NULL,
	[Priority] [int] NULL,
 CONSTRAINT [PK_JournalPage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewCategoryField]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewCategoryField]
AS
SELECT       dbo.CategoryField.Id, dbo.CategoryField.CategoryId, dbo.CategoryField.Name, dbo.Category.Name AS Category, dbo.CategoryField.Priority
FROM            dbo.CategoryField INNER JOIN
                         dbo.Category ON dbo.CategoryField.CategoryId = dbo.Category.Id
GO
/****** Object:  View [dbo].[ViewFeatureType]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewFeatureType]
AS
SELECT       dbo.FeatureType.Id, dbo.BaseFeatureType.Name, dbo.FeatureType.Priority, dbo.FeatureType.CategoryId, dbo.FeatureType.BaseFeatureTypeId
FROM            dbo.BaseFeatureType INNER JOIN
                         dbo.FeatureType ON dbo.BaseFeatureType.Id = dbo.FeatureType.BaseFeatureTypeId
GO
/****** Object:  View [dbo].[ViewFeatureTypeDetail]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewFeatureTypeDetail]
AS
SELECT       dbo.FeatureTypeDetail.Id, dbo.FeatureTypeDetail.FeatureTypeId, dbo.FeatureTypeDetail.Priority, dbo.BaseFeatureTypeDetail.Name, dbo.FeatureTypeDetail.BaseFeatureTypeDetailId
FROM            dbo.FeatureTypeDetail INNER JOIN
                         dbo.BaseFeatureTypeDetail ON dbo.FeatureTypeDetail.BaseFeatureTypeDetailId = dbo.BaseFeatureTypeDetail.Id
GO
/****** Object:  Table [dbo].[Message]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Message](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LanguageId] [int] NULL,
	[Sender] [nvarchar](128) NOT NULL,
	[Receiver] [nvarchar](128) NOT NULL,
	[MessageText] [nvarchar](max) NULL,
	[OrderNumber] [int] NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Visited] [bit] NULL,
	[Type] [int] NULL,
	[MessageDate] [datetime] NULL,
	[PublicUserEmail] [nvarchar](max) NULL,
 CONSTRAINT [PK_Message] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[LanguageId] [int] NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](100) NULL,
	[MobilePhone] [nvarchar](22) NULL,
	[Tel] [nvarchar](22) NULL,
	[Identifier] [nvarchar](128) NULL,
	[Sex] [bit] NOT NULL,
	[BirthDate] [date] NULL,
	[AcademicInfoNames] [nvarchar](max) NULL,
	[AcademicInfoValues] [nvarchar](max) NULL,
	[StreetLine1] [nvarchar](max) NULL,
	[StreetLine2] [nvarchar](max) NULL,
	[City] [nvarchar](max) NULL,
	[State] [nvarchar](max) NULL,
	[ZipCode] [nvarchar](max) NULL,
	[ProfilePictureUrl] [nvarchar](max) NULL,
	[CountryId] [int] NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewMessage]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewMessage]
AS
SELECT DISTINCT 
                         dbo.Message.Id, dbo.Message.Sender, dbo.Message.Receiver, dbo.Message.MessageText, dbo.Message.OrderNumber, Person_1.LastName + N' ' + Person_1.FirstName AS SenderName, Person_1.MobilePhone AS SenderMobilePhone, 
                         Person_1.Tel AS SenderTel, Person_3.LastName + N' ' + Person_3.FirstName AS ReceiverName, Person_3.MobilePhone AS ReceiverMobilePhone, Person_3.Tel AS ReceiverTel, dbo.Message.Title, dbo.Message.Visited, 
                         dbo.Message.Type, dbo.Message.MessageDate, dbo.Message.PublicUserEmail, dbo.Message.LanguageId
FROM            dbo.Person AS Person_3 RIGHT OUTER JOIN
                         dbo.Message ON Person_3.UserId = dbo.Message.Receiver LEFT OUTER JOIN
                         dbo.Person AS Person_1 ON dbo.Message.Sender = Person_1.UserId
GO
/****** Object:  Table [dbo].[Country]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Iso] [nvarchar](4) NOT NULL,
	[Name] [nvarchar](160) NOT NULL,
	[NiceName] [nvarchar](160) NOT NULL,
	[Iso3] [nvarchar](6) NULL,
	[NumCode] [smallint] NULL,
	[PhoneCode] [int] NOT NULL,
 CONSTRAINT [PK__Country__3214EC07B0B900E1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewPersonInRole]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewPersonInRole]
AS
SELECT       dbo.Person.LastName + N' ' + dbo.Person.FirstName AS Name, dbo.Person.Identifier, dbo.Person.Sex, dbo.Person.BirthDate, dbo.Person.AcademicInfoNames, dbo.Person.UserId, dbo.Person.Id, dbo.Person.AcademicInfoValues, 
                         dbo.AspNetUsers.UserName, dbo.AspNetUsers.Email, dbo.AspNetUsers.RegisterDate, dbo.AspNetRoles.Name AS RoleName, dbo.AspNetUserRoles.RoleId, dbo.AspNetUsers.UserDefiner, dbo.AspNetUsers.LastSignIn, 
                         dbo.Person.StreetLine1, dbo.Person.StreetLine2, dbo.Person.City, dbo.Person.State, dbo.Person.ZipCode, dbo.Person.ProfilePictureUrl, dbo.Person.FirstName, dbo.Person.LastName, dbo.AspNetUsers.PhoneNumber, 
                         dbo.Country.PhoneCode, dbo.Country.NumCode, dbo.Country.Iso, dbo.Country.Iso3, dbo.Person.CountryId, dbo.Country.Name AS Country, dbo.AspNetUsers.AllowAcceptReject
FROM            dbo.Person INNER JOIN
                         dbo.AspNetUsers ON dbo.Person.UserId = dbo.AspNetUsers.Id INNER JOIN
                         dbo.AspNetUserRoles ON dbo.AspNetUsers.Id = dbo.AspNetUserRoles.UserId INNER JOIN
                         dbo.AspNetRoles ON dbo.AspNetUserRoles.RoleId = dbo.AspNetRoles.Id LEFT OUTER JOIN
                         dbo.Country ON dbo.Person.CountryId = dbo.Country.Id
GO
/****** Object:  Table [dbo].[QuantityUnit]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuantityUnit](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[QuantityDetail] [int] NULL,
 CONSTRAINT [PK_QuantityUnit] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewProduct]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewProduct]
AS
SELECT       dbo.Category.Name AS CategoryName, dbo.Product.Id, dbo.Product.CategoryId, dbo.Product.IsPackage, dbo.Product.Name, dbo.Product.QuantityUnitId, dbo.Product.Description, dbo.Product.Date, dbo.Product.ProductionDate, 
                         dbo.Product.ExpiryDate, dbo.Product.OccasionId, dbo.QuantityUnit.Name AS QuantityUnitName, dbo.QuantityUnit.QuantityDetail, dbo.Category.IsDefault
FROM            dbo.Category INNER JOIN
                         dbo.Product ON dbo.Category.Id = dbo.Product.CategoryId INNER JOIN
                         dbo.QuantityUnit ON dbo.Product.QuantityUnitId = dbo.QuantityUnit.Id
GO
/****** Object:  Table [dbo].[ProductCategoryField]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductCategoryField](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[CategoryFieldId] [int] NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_ProductArea] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewProductCategoryField]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewProductCategoryField]
AS
SELECT       dbo.ProductCategoryField.Id, dbo.ProductCategoryField.ProductId, dbo.ProductCategoryField.CategoryFieldId, dbo.Product.CategoryId, dbo.CategoryField.Name AS CategoryFieldName, dbo.CategoryField.Priority, 
                         dbo.Category.Name AS CategoryName, dbo.Product.Name AS ProductName
FROM            dbo.Category INNER JOIN
                         dbo.CategoryField ON dbo.Category.Id = dbo.CategoryField.Id INNER JOIN
                         dbo.Product ON dbo.Category.Id = dbo.Product.CategoryId INNER JOIN
                         dbo.ProductCategoryField ON dbo.Product.Id = dbo.ProductCategoryField.ProductId
GO
/****** Object:  View [dbo].[ViewProductFeature]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewProductFeature]
AS
SELECT       dbo.ProductFeature.Id, dbo.ProductFeature.ParentId, dbo.ProductFeature.ProductId, dbo.ProductFeature.FeatureTypeDetailId, dbo.BaseFeatureTypeDetail.Name AS FeatureTypeDetailName, 
                         dbo.BaseFeatureType.Name AS FeatureTypeName, dbo.ProductFeature.Price, dbo.ProductFeature.Quantity, dbo.FeatureTypeDetail.FeatureTypeId, dbo.ProductFeature.Priority, dbo.FeatureType.Priority AS FeatureTypePriority, 
                         dbo.FeatureTypeDetail.Priority AS FeatureTypeDetailPriority, dbo.ProductFeature.IconUrl, dbo.ProductFeature.Showcase, dbo.ProductFeature.Description, dbo.Product.CategoryId, dbo.FeatureTypeDetail.BaseFeatureTypeDetailId
FROM            dbo.BaseFeatureType INNER JOIN
                         dbo.FeatureTypeDetail INNER JOIN
                         dbo.FeatureType ON dbo.FeatureTypeDetail.FeatureTypeId = dbo.FeatureType.Id ON dbo.BaseFeatureType.Id = dbo.FeatureType.BaseFeatureTypeId INNER JOIN
                         dbo.BaseFeatureTypeDetail ON dbo.FeatureTypeDetail.BaseFeatureTypeDetailId = dbo.BaseFeatureTypeDetail.Id RIGHT OUTER JOIN
                         dbo.ProductFeature INNER JOIN
                         dbo.Product ON dbo.ProductFeature.ProductId = dbo.Product.Id ON dbo.FeatureTypeDetail.Id = dbo.ProductFeature.FeatureTypeDetailId
GO
/****** Object:  Table [dbo].[Address]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AddressLine] [nvarchar](max) NOT NULL,
	[PostalCode] [nvarchar](max) NOT NULL,
	[Email] [nvarchar](max) NULL,
	[Country] [nvarchar](max) NOT NULL,
	[State] [nvarchar](max) NOT NULL,
	[City] [nvarchar](max) NOT NULL,
	[WebSite] [nvarchar](max) NULL,
	[MapURL] [nvarchar](max) NULL,
	[Longitude] [nvarchar](max) NULL,
	[Latitude] [nvarchar](max) NULL,
	[CustomerId] [int] NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[City]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[City](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[ProvinceId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dictionary]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dictionary](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CultureInfoCode] [nvarchar](255) NOT NULL,
	[RefrenceWordId] [int] NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_Dictionary] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Discount]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[DiscountTypeId] [smallint] NOT NULL,
 CONSTRAINT [PK_Discount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DiscountDetail]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiscountDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DiscountId] [int] NOT NULL,
	[Amount] [nchar](10) NULL,
	[Discount] [nchar](10) NULL,
 CONSTRAINT [PK_DiscountDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DiscountType]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiscountType](
	[Id] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_DiscountType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExcelDictionary]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExcelDictionary](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[en-US] [nvarchar](max) NULL,
	[fa-IR] [nvarchar](max) NULL,
	[tr-TR] [nvarchar](max) NULL,
 CONSTRAINT [PK_ExcelDictionary] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InvoiceStateHistory]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvoiceStateHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceId] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[State] [int] NOT NULL,
 CONSTRAINT [PK_OrderStateHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Language]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Language](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Country] [nvarchar](255) NULL,
	[TwoLetterCountryCode] [nvarchar](255) NULL,
	[ThreeLetterCountryCode] [nvarchar](255) NULL,
	[Language] [nvarchar](255) NULL,
	[TwoLetterLangCode] [nvarchar](255) NULL,
	[ThreeLetterLangCode] [nvarchar](255) NULL,
	[CultureInfoCode] [nvarchar](255) NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[CultureInfoCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LocalLink]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocalLink](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LanguageId] [int] NULL,
	[Caption] [nvarchar](max) NULL,
	[Content] [nvarchar](max) NULL,
	[Priority] [int] NULL,
 CONSTRAINT [PK_LocalLink] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[News]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](512) NULL,
	[Body] [text] NULL,
	[HtmlBody] [text] NULL,
	[PictureName] [nvarchar](max) NULL,
	[PictureType] [varchar](512) NULL,
	[PictureContentUrl] [nvarchar](max) NULL,
	[Priority] [int] NULL,
	[Type] [int] NULL,
 CONSTRAINT [PK_ADMSNews] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Occasion]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Occasion](
	[Id] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_Occasion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Package]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Package](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Price] [money] NULL,
	[OccasionId] [smallint] NULL,
	[Date] [datetime] NULL,
	[DiscountId] [money] NULL,
 CONSTRAINT [PK_Package] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackageDetail]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackageDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[PackageId] [int] NOT NULL,
	[Number] [int] NOT NULL,
 CONSTRAINT [PK_PackageDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackageOrder]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackageOrder](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PackageId] [int] NOT NULL,
 CONSTRAINT [PK_PackageOrder] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackageOrderDetail]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackageOrderDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Number] [int] NOT NULL,
 CONSTRAINT [PK_PackageOrderDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PageContent]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PageContent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Content] [nvarchar](max) NULL,
	[Subject] [nvarchar](max) NULL,
	[Type] [int] NULL,
	[LanguageId] [int] NULL,
 CONSTRAINT [PK_FirstPageContent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductDiscount]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductDiscount](
	[Id] [int] NOT NULL,
	[ProductId] [int] NULL,
	[DiscountDetailId] [int] NULL,
 CONSTRAINT [PK_ProductDiscount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Province]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Province](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CountryId] [int] NOT NULL,
 CONSTRAINT [PK_Province] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RecipientType]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecipientType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_RecipientType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RefrenceWord]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RefrenceWord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Word] [nvarchar](max) NULL,
 CONSTRAINT [PK_RefrenceWord] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SiteInfo]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SiteInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SiteName] [nvarchar](max) NULL,
 CONSTRAINT [PK_SiteInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Statistics]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Statistics](
	[Id] [uniqueidentifier] NOT NULL,
	[IPAddress] [nvarchar](max) NULL,
	[URL] [nvarchar](max) NULL,
	[LanguageId] [uniqueidentifier] NULL,
	[VisitCount] [int] NULL,
	[VisitDate] [date] NULL,
	[Browser] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Reference] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SundryImage]    Script Date: 3/7/2021 8:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SundryImage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Type] [int] NOT NULL,
	[ImageUrl] [nvarchar](max) NULL,
	[LanguageId] [int] NULL,
	[Priority] [int] NOT NULL,
	[LinkUrl] [nvarchar](max) NULL,
	[ObjectId] [int] NULL,
	[PackageItemType] [int] NOT NULL,
	[BannerImageUrl] [nvarchar](max) NULL,
	[BannerImageTitle] [nvarchar](max) NULL,
 CONSTRAINT [PK_WebShopSundryImage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'652a69dc-d46c-4cbf-ba28-8e7759b37752', N'Admin')
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'f522e425-0407-4fe5-894e-93dbdcfd1a2c', N'Member')
GO
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'70865ade-87a2-45cb-8dd8-61acbc08ceb0', N'f522e425-0407-4fe5-894e-93dbdcfd1a2c')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'652a69dc-d46c-4cbf-ba28-8e7759b37752')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'71808cb5-011a-433c-befc-d26cfb9c5033', N'f522e425-0407-4fe5-894e-93dbdcfd1a2c')
GO
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'70865ade-87a2-45cb-8dd8-61acbc08ceb0', N'Robo.arts@gmail.com', 1, N'AAIFjbExMbJsYQzJI5MNtilbXb13jeaDGMf7bFKU9FGK7Krz2DMoBFrwk4SIr+Pjvg==', N'9b8859fc-23a9-4e66-8586-686f56db8644', N'+989354558317', 0, 0, NULL, 0, 0, N'Robo.arts@gmail.com', CAST(N'2021-02-20T11:15:04.203' AS DateTime), NULL, CAST(N'2021-02-20T11:15:04.203' AS DateTime), NULL, 0)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'pournaeim@gmail.com', 1, N'ABnFNNZ/FF+3NZXvWvJyw+a+xId3HVQ+Kkj58wYBhDfqIo57qmrrYzZmsbh2UNAd+A==', N'69a7b95d-6831-4d80-8746-b03fec4135a3', N'0912', 1, 0, CAST(N'1754-01-01T00:00:00.000' AS DateTime), 0, 0, N'pournaeim@gmail.com', CAST(N'2018-01-01T00:00:00.000' AS DateTime), NULL, CAST(N'2018-11-13T20:18:15.677' AS DateTime), NULL, 0)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'71808cb5-011a-433c-befc-d26cfb9c5033', N'Roboarts@gmail.com', 1, N'ABFhY52ZR3xdGpPZ3SuTy0RS2SgfR/jqLl4SdHfS3Titg7E9Y4Irl3XF4cK4D6SwXA==', N'feef67fe-73d2-4270-a4c1-ad8cb8086a35', N'+989354558317', 0, 0, NULL, 0, 0, N'Roboarts@gmail.com', CAST(N'2021-02-28T07:53:18.373' AS DateTime), NULL, CAST(N'2021-02-28T07:53:18.373' AS DateTime), NULL, 0)
GO
SET IDENTITY_INSERT [dbo].[BaseFeatureType] ON 

INSERT [dbo].[BaseFeatureType] ([Id], [Name]) VALUES (1, N'Top Feature')
INSERT [dbo].[BaseFeatureType] ([Id], [Name]) VALUES (2, N'Sub Feature')
INSERT [dbo].[BaseFeatureType] ([Id], [Name]) VALUES (3, N'Last Sub Feature')
SET IDENTITY_INSERT [dbo].[BaseFeatureType] OFF
GO
SET IDENTITY_INSERT [dbo].[BaseFeatureTypeDetail] ON 

INSERT [dbo].[BaseFeatureTypeDetail] ([Id], [Name], [BaseFeatureTypeId]) VALUES (1, N'Top Feature 1', 1)
INSERT [dbo].[BaseFeatureTypeDetail] ([Id], [Name], [BaseFeatureTypeId]) VALUES (2, N'Top Feature 2', 1)
INSERT [dbo].[BaseFeatureTypeDetail] ([Id], [Name], [BaseFeatureTypeId]) VALUES (4, N'S F 1', 2)
INSERT [dbo].[BaseFeatureTypeDetail] ([Id], [Name], [BaseFeatureTypeId]) VALUES (5, N'S F 2', 2)
INSERT [dbo].[BaseFeatureTypeDetail] ([Id], [Name], [BaseFeatureTypeId]) VALUES (6, N'Top Feature 3', 1)
INSERT [dbo].[BaseFeatureTypeDetail] ([Id], [Name], [BaseFeatureTypeId]) VALUES (7, N'S F 3', 2)
INSERT [dbo].[BaseFeatureTypeDetail] ([Id], [Name], [BaseFeatureTypeId]) VALUES (8, N'Last Feature 1', 3)
INSERT [dbo].[BaseFeatureTypeDetail] ([Id], [Name], [BaseFeatureTypeId]) VALUES (9, N'Last Feature 2', 3)
INSERT [dbo].[BaseFeatureTypeDetail] ([Id], [Name], [BaseFeatureTypeId]) VALUES (10, N'S F 4', 2)
SET IDENTITY_INSERT [dbo].[BaseFeatureTypeDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[Category] ON 

INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (1, N'OYA STIL CATEGORY', -1, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (20, N'Men', 1, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (21, N'Women', 1, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (22, N'Clothing', 20, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (23, N'Accessories ', 20, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (25, N'Clothing', 21, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (47, N'Girls', 1, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (48, N'Boys', 1, 1)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (49, N'Girls From 4 to 14 years', 47, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (50, N'Boys From 4 to 14 years', 48, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (51, N'Girls From 0 to 4 years', 47, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (52, N'Boys From 0 to 4 years', 48, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (53, N'Shirts', 22, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (54, N'Dress', 25, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (55, N'Shoes', 23, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (56, N'Accessories', 21, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (57, N'Shoes', 56, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (1060, N'Dress', 49, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (1061, N'Shirt', 50, 0)
INSERT [dbo].[Category] ([Id], [Name], [ParentId], [IsDefault]) VALUES (1062, N'Trouser', 50, 0)
SET IDENTITY_INSERT [dbo].[Category] OFF
GO
SET IDENTITY_INSERT [dbo].[CategoryField] ON 

INSERT [dbo].[CategoryField] ([Id], [Name], [CategoryId], [Priority]) VALUES (13, N'field 1', 47, 1)
INSERT [dbo].[CategoryField] ([Id], [Name], [CategoryId], [Priority]) VALUES (15, N'field 1', 48, 10)
INSERT [dbo].[CategoryField] ([Id], [Name], [CategoryId], [Priority]) VALUES (16, N'field 2', 48, 20)
INSERT [dbo].[CategoryField] ([Id], [Name], [CategoryId], [Priority]) VALUES (17, N'field 3', 48, 30)
SET IDENTITY_INSERT [dbo].[CategoryField] OFF
GO
SET IDENTITY_INSERT [dbo].[City] ON 

INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1, N'تهران', 17, 1)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (2, N'کرج', 47, 1)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (15, N'دماوند', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (16, N'شهرري', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (17, N'ورامين', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (63, N'ابركوه', 34, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (64, N'اردكان', 34, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (65, N'بافق', 34, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (66, N'تفت', 34, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (67, N'صدوق', 34, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (68, N'طبس', 39, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (69, N'مهريز', 34, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (70, N'ميبد', 34, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (71, N'يزد', 34, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (72, N'بهاباد', 34, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (73, N'قم', 35, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (74, N'کهک', 35, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (75, N'آبادان', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (76, N'آباده', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (77, N'آران و بيدگل', 36, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (78, N'آستارا', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (79, N'آستانه اشرفيه', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (80, N'آق قلا', 38, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (81, N'آمل', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (82, N'ابهر', 21, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (83, N'اراك', 31, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (84, N'اردبيل', 10, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (85, N'اردستان', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (86, N'ارسنجان', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (87, N'اروميه', 12, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (88, N'استهبان', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (89, N'اسدآباد', 33, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (90, N'اسفراين', 40, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (91, N'اسكو', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (92, N'اصفهان', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (93, N'اقليد', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (94, N'اليگودرز', 29, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (96, N'اميركلا', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (97, N'اهواز', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (98, N'ايلام', 14, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (99, N'بابل', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (100, N'بابلسر', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (101, N'باخرز', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (102, N'بجنورد', 40, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (103, N'بردسكن', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (104, N'بردسير', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (105, N'بروجرد', 29, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (106, N'بروجن', 18, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (107, N'بم', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (108, N'بندرانزلي', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (109, N'بندرعباس', 32, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (110, N'بهشهر', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (111, N'بوئين زهرا', 37, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (112, N'بوشهر', 16, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (113, N'بوكان', 12, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (115, N'بيرجند', 39, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (116, N'پارس آباد', 10, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (117, N'تاكستان', 37, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (118, N'تالش', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (119, N'تايباد', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (120, N'تبريز', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (121, N'تربت جام', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (122, N'تربت حيدريه', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (123, N'تنكابن', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (124, N'تويسركان', 33, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (125, N'تيران', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (126, N'جهرم', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (127, N'جويبار', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (128, N'جيرفت', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (129, N'چالوس', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (130, N'چناران', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (131, N'خرم آباد', 29, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (132, N'خرمشهر', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (133, N'خمين', 31, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (134, N'خميني شهر', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (135, N'خواف', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (136, N'خوانسار', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (137, N'خوي', 12, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (138, N'داراب', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (139, N'دامغان', 22, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (140, N'دزفول', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (141, N'دليجان', 31, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (142, N'دهاقان', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (143, N'دورود', 29, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (144, N'دولت آباد', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (145, N'رامسر', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (146, N'رشت', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (147, N'رفسنجان', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (148, N'رودسر', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (149, N'رويان', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (150, N'زاهدان', 23, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (151, N'زرند', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (152, N'زرين شهر', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (153, N'زنجان', 21, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (154, N'زيراب', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (155, N'ساري', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (156, N'ساوه', 31, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (157, N'سبزوار', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (158, N'سراب', 11, 0)
GO
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (159, N'سرخس', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (160, N'سمنان', 22, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (161, N'سميرم', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (162, N'سنندج', 25, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (163, N'سوادكوه', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (164, N'سيرجان', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (165, N'شازند', 31, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (166, N'شاهرود', 22, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (167, N'شاهين شهر', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (168, N'شبستر', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (169, N'شهر صنعتي البرز', 37, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (170, N'شهرضا', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (171, N'شهركرد', 18, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (172, N'شوشتر', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (173, N'شيراز', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (174, N'شيروان', 40, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (175, N'صومعه سرا', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (176, N'طرقبه', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (177, N'عجب شير', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (178, N'علويجه', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (179, N'علي آباد كتول', 38, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (182, N'فردوس', 39, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (183, N'فريدن', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (184, N'فريدونكنار', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (185, N'فريمان', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (186, N'فسا', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (187, N'فلاورجان', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (188, N'فومن', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (189, N'فيروزآباد', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (190, N'فيض آباد', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (191, N'قائمشهر', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (192, N'قاين', 39, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (193, N'قاينات', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (194, N'قزوين', 37, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (195, N'قشم', 32, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (196, N'قوچان', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (197, N'كازرون', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (198, N'كاشان', 36, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (199, N'كاشمر', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (200, N'كبودرآهنگ', 33, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (201, N'كردكوي', 38, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (202, N'كرمان', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (203, N'كرمانشاه', 15, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (204, N'كلاله', 38, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (205, N'گچساران', 27, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (206, N'گراش', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (207, N'گرگان', 38, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (208, N'گرمسار', 22, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (209, N'گلپايگان', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (210, N'گلوگاه', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (211, N'گناباد', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (212, N'گناوه', 16, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (213, N'گنبد كاووس', 38, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (214, N'لار', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (215, N'لارستان', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (216, N'لاهيجان', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (217, N'لنگرود', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (218, N'مباركه', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (219, N'محلات', 31, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (220, N'محمودآباد', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (222, N'مراغه', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (223, N'مرند', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (224, N'مرودشت', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (225, N'مشگين شهر', 10, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (226, N'مشهد', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (227, N'ملاير', 33, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (228, N'ملكان', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (229, N'مهاباد', 12, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (230, N'مياندوآب', 12, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (231, N'ميانه', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (232, N'مينودشت', 38, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (233, N'نائين', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (234, N'نجف آباد', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (235, N'نطنز', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (236, N'نكا', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (237, N'نهاوند', 33, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (238, N'نور', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (239, N'نوشهر', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (240, N'ني ريز', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (241, N'نيشابور', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (242, N'همدان', 33, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (243, N'ياسوج', 27, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (245, N'کنگان', 16, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1101, N'شهر بابک', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1102, N'آشخانه', 40, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1103, N'بستان آباد', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1104, N'سردرود', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1105, N'راور', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1106, N'ايلخچي', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1107, N'لامرد', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1108, N'هشترود', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1109, N'آذرشهر', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1110, N'اهر', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1111, N'کميجان', 31, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1112, N'بحستان', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1113, N'گرمه جاجرم', 40, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1114, N'انار', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1115, N'صوفيان', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1116, N'برازجان', 16, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1117, N'خدابنده', 21, 0)
GO
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1118, N'خاتم', 34, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1119, N'انديمشک', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1120, N'شوش', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1121, N'ماهشهر', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1122, N'بهبهان', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1123, N'شادگان', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1124, N'رامهرمز', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1125, N'بندرلنگه', 32, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1126, N'پارسيان', 32, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1127, N'بستک', 32, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1128, N'کيش', 32, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1129, N'جعفريه', 35, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1130, N'جغتاي', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1132, N'شهريار', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1133, N'ساوجبلاغ', 47, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1134, N'رباط کريم', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1135, N'نظر آباد', 47, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1137, N'شهر قدس', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1138, N'بندرگز', 38, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1139, N'آزاد شهر', 38, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1140, N'هشتگرد', 47, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1141, N'رودبار', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1142, N'زابل', 23, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1143, N'کنگاور', 15, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1144, N'خسرو شهر', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1145, N'بافت', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1146, N'ميمه', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1147, N'سقز', 25, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1148, N'قروه', 25, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1149, N'فاروج', 40, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1150, N'خنداب', 31, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1151, N'سلفچگان', 35, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1152, N'سرايان', 39, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1153, N'عباس آباد', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1154, N'بشرويه', 39, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1155, N'محمد شهر', 47, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1156, N'کمال شهر', 47, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1157, N'بناب', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1158, N'طالقان', 47, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1159, N'ملارد', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1160, N'ورزقان', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1161, N'بانه', 25, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1162, N'هریس', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1163, N'سلماس', 12, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1164, N'خلیل آباد', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1165, N'ماهدشت', 47, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1166, N'جاجرم', 40, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1167, N'باسمنج', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1168, N'مهدیشهر', 22, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1169, N'میناب', 32, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1170, N'سربیشه', 39, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1171, N'رزن', 33, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1172, N'درچه', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1173, N'خوروبیابانک', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1174, N'آبیک', 37, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1175, N'حاجی آباد', 32, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1176, N'دهبارز', 32, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1177, N'بیجار', 25, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1178, N'حسن آبادجرقویه', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1179, N'درمیان', 39, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1180, N'خورموج', 16, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1181, N'دیلم', 16, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1182, N'زرقان', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1183, N'کوار', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1184, N'آبش احمد', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1185, N'جوین', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1186, N'کلیبر', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1187, N'شندآباد', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1188, N'شاندیز', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1189, N'بهنمیر', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1191, N'جلفا', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1192, N'میاندرود', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1193, N'مهربان', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1194, N'بندرترکمن', 38, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1195, N'قمصر', 36, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1196, N'سلسله', 29, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1197, N'چاراویماق ', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1198, N'هادیشهر', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1199, N'فراشبند', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1200, N'کوهدشت', 29, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1202, N'ابوزیدآباد', 36, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1203, N'نقده', 12, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1204, N'اقبالیه', 37, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1205, N'دستجرد', 35, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1206, N'خرم بید', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1208, N'پاکدشت', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1209, N'دلفان', 29, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1210, N'بیضا', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1211, N'زرین دشت', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1212, N'اسلامشهر', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1213, N'قرچک', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1214, N'نهبندان', 39, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1215, N'ترکمنچای', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1216, N'بهارستان ، نسیم شهر', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1217, N'مانه و سملقان ', 40, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1218, N'رودبارجنوب', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1219, N'فیروزکوه', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1220, N'خلخال', 10, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1221, N'راوند', 36, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1222, N'سهند', 11, 0)
GO
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1223, N'ایرانشهر', 23, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1224, N'زارچ', 34, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1225, N'نرماشیر', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1226, N'کلیشاد', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1227, N'کلات', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1228, N'بهارستان، صالحیه', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1229, N'سیریک', 32, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1230, N'دشت آزادگان', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1231, N'دهدشت', 27, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1232, N'مریوان', 25, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1233, N'کوهبنان', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1234, N'اسلامیه', 39, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1235, N'خوشاب', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1236, N'ماکو', 12, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1237, N'قیروکارزین', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1238, N'سرخرود', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1239, N'گرمی', 10, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1240, N'درگز', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1241, N'اختیارآباد', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1242, N'خوسف', 39, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1243, N'قنوات', 35, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1244, N'عقدا', 34, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1245, N'باغ بهادران', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1246, N'چابهار', 23, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1247, N'سراوان', 23, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1248, N'سپیدان', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1249, N'بومهن', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1250, N'زرگر محله', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1251, N'دیر', 16, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1252, N'حسن آباد', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1253, N'لواسان', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1254, N'اسلام آباد غرب', 15, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1255, N'معلم کلایه', 37, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1256, N'فیروزه', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1257, N'شیرگاه', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1259, N'سده', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1260, N'سیدان', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1261, N'گالیکش', 38, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1262, N'آسارا', 47, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1263, N'کیاسر', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1264, N'خشرودپی', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1265, N'چادگان', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1266, N'راز', 40, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1267, N'تسوج ', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1269, N'الوند', 37, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1271, N'کوهپایه', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1272, N'بادرود', 36, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1273, N'امیریه', 22, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1274, N'خلیل شهر', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1275, N'شفت', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1276, N'مشکین دشت ', 47, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1278, N'فولادشهر', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1279, N'بهار', 33, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1280, N'زیباشهر ', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1282, N'ارطه', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1283, N'املش', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1284, N'ششده ', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1285, N'مهران', 14, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1294, N'پردیس', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1298, N'حاجی اباد', 39, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1302, N'سردرو', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1305, N'خفر ', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1306, N' احمد آباد مستوفی ', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1308, N'دولت اباد', 19, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1309, N'بویین ومیاندشت ', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1310, N' خرمدره', 21, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1311, N'اشکذر', 34, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1312, N'کوهسار', 47, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1313, N'پل سفید', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1314, N'مرزیکلا ', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1315, N'نورآباد ', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1316, N'صغاد', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1317, N'چقابل', 29, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1318, N'نوکنده ', 38, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1319, N'بنارویه ', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1320, N'کامیاران ', 25, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1321, N'گلوگاه بند پي', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1322, N' خان ببین', 38, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1323, N'پیشوا ', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1324, N'بوانات ', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1325, N'ازنا', 29, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1326, N'گوگان ', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1327, N'کشکسرای', 11, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1328, N'لیکک ', 27, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1329, N'سوسنگرد ', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1330, N'بن ', 18, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1331, N'رودهن', 17, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1332, N'ایذه ', 20, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1333, N'فرمهین ', 31, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1334, N'قهستان', 39, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1339, N'گزبرخوار ', 13, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1340, N'صفاشهر', 24, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1343, N'سامان', 18, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1344, N'کشکوئیه', 26, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1345, N'کلاچای ', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1346, N'تکاب', 12, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1347, N'گلسار ', 47, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1348, N'رستم کلا', 30, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1349, N'چوبر ', 28, 0)
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1352, N'سی سخت ', 27, 0)
GO
INSERT [dbo].[City] ([Id], [Name], [ProvinceId], [Active]) VALUES (1353, N'کلاردشت ', 30, 0)
SET IDENTITY_INSERT [dbo].[City] OFF
GO
SET IDENTITY_INSERT [dbo].[Country] ON 

INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (1, N'AF', N'AFGHANISTAN', N'Afghanistan', N'AFG', 4, 93)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (2, N'AL', N'ALBANIA', N'Albania', N'ALB', 8, 355)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (3, N'DZ', N'ALGERIA', N'Algeria', N'DZA', 12, 213)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (4, N'AS', N'AMERICAN SAMOA', N'American Samoa', N'ASM', 16, 1684)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (5, N'AD', N'ANDORRA', N'Andorra', N'AND', 20, 376)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (6, N'AO', N'ANGOLA', N'Angola', N'AGO', 24, 244)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (7, N'AI', N'ANGUILLA', N'Anguilla', N'AIA', 660, 1264)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (8, N'AQ', N'ANTARCTICA', N'Antarctica', NULL, NULL, 0)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (9, N'AG', N'ANTIGUA AND BARBUDA', N'Antigua and Barbuda', N'ATG', 28, 1268)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (10, N'AR', N'ARGENTINA', N'Argentina', N'ARG', 32, 54)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (11, N'AM', N'ARMENIA', N'Armenia', N'ARM', 51, 374)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (12, N'AW', N'ARUBA', N'Aruba', N'ABW', 533, 297)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (13, N'AU', N'AUSTRALIA', N'Australia', N'AUS', 36, 61)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (14, N'AT', N'AUSTRIA', N'Austria', N'AUT', 40, 43)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (15, N'AZ', N'AZERBAIJAN', N'Azerbaijan', N'AZE', 31, 994)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (16, N'BS', N'BAHAMAS', N'Bahamas', N'BHS', 44, 1242)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (17, N'BH', N'BAHRAIN', N'Bahrain', N'BHR', 48, 973)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (18, N'BD', N'BANGLADESH', N'Bangladesh', N'BGD', 50, 880)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (19, N'BB', N'BARBADOS', N'Barbados', N'BRB', 52, 1246)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (20, N'BY', N'BELARUS', N'Belarus', N'BLR', 112, 375)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (21, N'BE', N'BELGIUM', N'Belgium', N'BEL', 56, 32)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (22, N'BZ', N'BELIZE', N'Belize', N'BLZ', 84, 501)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (23, N'BJ', N'BENIN', N'Benin', N'BEN', 204, 229)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (24, N'BM', N'BERMUDA', N'Bermuda', N'BMU', 60, 1441)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (25, N'BT', N'BHUTAN', N'Bhutan', N'BTN', 64, 975)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (26, N'BO', N'BOLIVIA', N'Bolivia', N'BOL', 68, 591)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (27, N'BA', N'BOSNIA AND HERZEGOVINA', N'Bosnia and Herzegovina', N'BIH', 70, 387)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (28, N'BW', N'BOTSWANA', N'Botswana', N'BWA', 72, 267)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (29, N'BV', N'BOUVET ISLAND', N'Bouvet Island', NULL, NULL, 0)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (30, N'BR', N'BRAZIL', N'Brazil', N'BRA', 76, 55)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (31, N'IO', N'BRITISH INDIAN OCEAN TERRITORY', N'British Indian Ocean Territory', NULL, NULL, 246)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (32, N'BN', N'BRUNEI DARUSSALAM', N'Brunei Darussalam', N'BRN', 96, 673)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (33, N'BG', N'BULGARIA', N'Bulgaria', N'BGR', 100, 359)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (34, N'BF', N'BURKINA FASO', N'Burkina Faso', N'BFA', 854, 226)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (35, N'BI', N'BURUNDI', N'Burundi', N'BDI', 108, 257)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (36, N'KH', N'CAMBODIA', N'Cambodia', N'KHM', 116, 855)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (37, N'CM', N'CAMEROON', N'Cameroon', N'CMR', 120, 237)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (38, N'CA', N'CANADA', N'Canada', N'CAN', 124, 1)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (39, N'CV', N'CAPE VERDE', N'Cape Verde', N'CPV', 132, 238)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (40, N'KY', N'CAYMAN ISLANDS', N'Cayman Islands', N'CYM', 136, 1345)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (41, N'CF', N'CENTRAL AFRICAN REPUBLIC', N'Central African Republic', N'CAF', 140, 236)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (42, N'TD', N'CHAD', N'Chad', N'TCD', 148, 235)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (43, N'CL', N'CHILE', N'Chile', N'CHL', 152, 56)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (44, N'CN', N'CHINA', N'China', N'CHN', 156, 86)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (45, N'CX', N'CHRISTMAS ISLAND', N'Christmas Island', NULL, NULL, 61)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (46, N'CC', N'COCOS (KEELING) ISLANDS', N'Cocos (Keeling) Islands', NULL, NULL, 672)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (47, N'CO', N'COLOMBIA', N'Colombia', N'COL', 170, 57)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (48, N'KM', N'COMOROS', N'Comoros', N'COM', 174, 269)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (49, N'CG', N'CONGO', N'Congo', N'COG', 178, 242)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (50, N'CD', N'CONGO, THE DEMOCRATIC REPUBLIC OF THE', N'Congo, the Democratic Republic of the', N'COD', 180, 242)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (51, N'CK', N'COOK ISLANDS', N'Cook Islands', N'COK', 184, 682)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (52, N'CR', N'COSTA RICA', N'Costa Rica', N'CRI', 188, 506)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (53, N'CI', N'COTE D''IVOIRE', N'Cote D''Ivoire', N'CIV', 384, 225)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (54, N'HR', N'CROATIA', N'Croatia', N'HRV', 191, 385)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (55, N'CU', N'CUBA', N'Cuba', N'CUB', 192, 53)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (56, N'CY', N'CYPRUS', N'Cyprus', N'CYP', 196, 357)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (57, N'CZ', N'CZECH REPUBLIC', N'Czech Republic', N'CZE', 203, 420)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (58, N'DK', N'DENMARK', N'Denmark', N'DNK', 208, 45)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (59, N'DJ', N'DJIBOUTI', N'Djibouti', N'DJI', 262, 253)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (60, N'DM', N'DOMINICA', N'Dominica', N'DMA', 212, 1767)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (61, N'DO', N'DOMINICAN REPUBLIC', N'Dominican Republic', N'DOM', 214, 1809)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (62, N'EC', N'ECUADOR', N'Ecuador', N'ECU', 218, 593)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (63, N'EG', N'EGYPT', N'Egypt', N'EGY', 818, 20)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (64, N'SV', N'EL SALVADOR', N'El Salvador', N'SLV', 222, 503)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (65, N'GQ', N'EQUATORIAL GUINEA', N'Equatorial Guinea', N'GNQ', 226, 240)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (66, N'ER', N'ERITREA', N'Eritrea', N'ERI', 232, 291)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (67, N'EE', N'ESTONIA', N'Estonia', N'EST', 233, 372)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (68, N'ET', N'ETHIOPIA', N'Ethiopia', N'ETH', 231, 251)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (69, N'FK', N'FALKLAND ISLANDS (MALVINAS)', N'Falkland Islands (Malvinas)', N'FLK', 238, 500)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (70, N'FO', N'FAROE ISLANDS', N'Faroe Islands', N'FRO', 234, 298)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (71, N'FJ', N'FIJI', N'Fiji', N'FJI', 242, 679)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (72, N'FI', N'FINLAND', N'Finland', N'FIN', 246, 358)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (73, N'FR', N'FRANCE', N'France', N'FRA', 250, 33)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (74, N'GF', N'FRENCH GUIANA', N'French Guiana', N'GUF', 254, 594)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (75, N'PF', N'FRENCH POLYNESIA', N'French Polynesia', N'PYF', 258, 689)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (76, N'TF', N'FRENCH SOUTHERN TERRITORIES', N'French Southern Territories', NULL, NULL, 0)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (77, N'GA', N'GABON', N'Gabon', N'GAB', 266, 241)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (78, N'GM', N'GAMBIA', N'Gambia', N'GMB', 270, 220)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (79, N'GE', N'GEORGIA', N'Georgia', N'GEO', 268, 995)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (80, N'DE', N'GERMANY', N'Germany', N'DEU', 276, 49)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (81, N'GH', N'GHANA', N'Ghana', N'GHA', 288, 233)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (82, N'GI', N'GIBRALTAR', N'Gibraltar', N'GIB', 292, 350)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (83, N'GR', N'GREECE', N'Greece', N'GRC', 300, 30)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (84, N'GL', N'GREENLAND', N'Greenland', N'GRL', 304, 299)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (85, N'GD', N'GRENADA', N'Grenada', N'GRD', 308, 1473)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (86, N'GP', N'GUADELOUPE', N'Guadeloupe', N'GLP', 312, 590)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (87, N'GU', N'GUAM', N'Guam', N'GUM', 316, 1671)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (88, N'GT', N'GUATEMALA', N'Guatemala', N'GTM', 320, 502)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (89, N'GN', N'GUINEA', N'Guinea', N'GIN', 324, 224)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (90, N'GW', N'GUINEA-BISSAU', N'Guinea-Bissau', N'GNB', 624, 245)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (91, N'GY', N'GUYANA', N'Guyana', N'GUY', 328, 592)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (92, N'HT', N'HAITI', N'Haiti', N'HTI', 332, 509)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (93, N'HM', N'HEARD ISLAND AND MCDONALD ISLANDS', N'Heard Island and Mcdonald Islands', NULL, NULL, 0)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (94, N'VA', N'HOLY SEE (VATICAN CITY STATE)', N'Holy See (Vatican City State)', N'VAT', 336, 39)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (95, N'HN', N'HONDURAS', N'Honduras', N'HND', 340, 504)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (96, N'HK', N'HONG KONG', N'Hong Kong', N'HKG', 344, 852)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (97, N'HU', N'HUNGARY', N'Hungary', N'HUN', 348, 36)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (98, N'IS', N'ICELAND', N'Iceland', N'ISL', 352, 354)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (99, N'IN', N'INDIA', N'India', N'IND', 356, 91)
GO
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (100, N'ID', N'INDONESIA', N'Indonesia', N'IDN', 360, 62)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (101, N'IR', N'IRAN, ISLAMIC REPUBLIC OF', N'Iran, Islamic Republic of', N'IRN', 364, 98)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (102, N'IQ', N'IRAQ', N'Iraq', N'IRQ', 368, 964)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (103, N'IE', N'IRELAND', N'Ireland', N'IRL', 372, 353)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (104, N'IL', N'ISRAEL', N'Israel', N'ISR', 376, 972)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (105, N'IT', N'ITALY', N'Italy', N'ITA', 380, 39)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (106, N'JM', N'JAMAICA', N'Jamaica', N'JAM', 388, 1876)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (107, N'JP', N'JAPAN', N'Japan', N'JPN', 392, 81)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (108, N'JO', N'JORDAN', N'Jordan', N'JOR', 400, 962)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (109, N'KZ', N'KAZAKHSTAN', N'Kazakhstan', N'KAZ', 398, 7)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (110, N'KE', N'KENYA', N'Kenya', N'KEN', 404, 254)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (111, N'KI', N'KIRIBATI', N'Kiribati', N'KIR', 296, 686)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (112, N'KP', N'KOREA, DEMOCRATIC PEOPLE''S REPUBLIC OF', N'Korea, Democratic People''s Republic of', N'PRK', 408, 850)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (113, N'KR', N'KOREA, REPUBLIC OF', N'Korea, Republic of', N'KOR', 410, 82)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (114, N'KW', N'KUWAIT', N'Kuwait', N'KWT', 414, 965)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (115, N'KG', N'KYRGYZSTAN', N'Kyrgyzstan', N'KGZ', 417, 996)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (116, N'LA', N'LAO PEOPLE''S DEMOCRATIC REPUBLIC', N'Lao People''s Democratic Republic', N'LAO', 418, 856)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (117, N'LV', N'LATVIA', N'Latvia', N'LVA', 428, 371)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (118, N'LB', N'LEBANON', N'Lebanon', N'LBN', 422, 961)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (119, N'LS', N'LESOTHO', N'Lesotho', N'LSO', 426, 266)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (120, N'LR', N'LIBERIA', N'Liberia', N'LBR', 430, 231)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (121, N'LY', N'LIBYAN ARAB JAMAHIRIYA', N'Libyan Arab Jamahiriya', N'LBY', 434, 218)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (122, N'LI', N'LIECHTENSTEIN', N'Liechtenstein', N'LIE', 438, 423)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (123, N'LT', N'LITHUANIA', N'Lithuania', N'LTU', 440, 370)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (124, N'LU', N'LUXEMBOURG', N'Luxembourg', N'LUX', 442, 352)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (125, N'MO', N'MACAO', N'Macao', N'MAC', 446, 853)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (126, N'MK', N'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF', N'Macedonia, the Former Yugoslav Republic of', N'MKD', 807, 389)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (127, N'MG', N'MADAGASCAR', N'Madagascar', N'MDG', 450, 261)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (128, N'MW', N'MALAWI', N'Malawi', N'MWI', 454, 265)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (129, N'MY', N'MALAYSIA', N'Malaysia', N'MYS', 458, 60)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (130, N'MV', N'MALDIVES', N'Maldives', N'MDV', 462, 960)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (131, N'ML', N'MALI', N'Mali', N'MLI', 466, 223)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (132, N'MT', N'MALTA', N'Malta', N'MLT', 470, 356)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (133, N'MH', N'MARSHALL ISLANDS', N'Marshall Islands', N'MHL', 584, 692)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (134, N'MQ', N'MARTINIQUE', N'Martinique', N'MTQ', 474, 596)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (135, N'MR', N'MAURITANIA', N'Mauritania', N'MRT', 478, 222)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (136, N'MU', N'MAURITIUS', N'Mauritius', N'MUS', 480, 230)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (137, N'YT', N'MAYOTTE', N'Mayotte', NULL, NULL, 269)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (138, N'MX', N'MEXICO', N'Mexico', N'MEX', 484, 52)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (139, N'FM', N'MICRONESIA, FEDERATED STATES OF', N'Micronesia, Federated States of', N'FSM', 583, 691)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (140, N'MD', N'MOLDOVA, REPUBLIC OF', N'Moldova, Republic of', N'MDA', 498, 373)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (141, N'MC', N'MONACO', N'Monaco', N'MCO', 492, 377)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (142, N'MN', N'MONGOLIA', N'Mongolia', N'MNG', 496, 976)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (143, N'MS', N'MONTSERRAT', N'Montserrat', N'MSR', 500, 1664)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (144, N'MA', N'MOROCCO', N'Morocco', N'MAR', 504, 212)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (145, N'MZ', N'MOZAMBIQUE', N'Mozambique', N'MOZ', 508, 258)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (146, N'MM', N'MYANMAR', N'Myanmar', N'MMR', 104, 95)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (147, N'NA', N'NAMIBIA', N'Namibia', N'NAM', 516, 264)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (148, N'NR', N'NAURU', N'Nauru', N'NRU', 520, 674)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (149, N'NP', N'NEPAL', N'Nepal', N'NPL', 524, 977)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (150, N'NL', N'NETHERLANDS', N'Netherlands', N'NLD', 528, 31)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (151, N'AN', N'NETHERLANDS ANTILLES', N'Netherlands Antilles', N'ANT', 530, 599)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (152, N'NC', N'NEW CALEDONIA', N'New Caledonia', N'NCL', 540, 687)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (153, N'NZ', N'NEW ZEALAND', N'New Zealand', N'NZL', 554, 64)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (154, N'NI', N'NICARAGUA', N'Nicaragua', N'NIC', 558, 505)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (155, N'NE', N'NIGER', N'Niger', N'NER', 562, 227)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (156, N'NG', N'NIGERIA', N'Nigeria', N'NGA', 566, 234)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (157, N'NU', N'NIUE', N'Niue', N'NIU', 570, 683)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (158, N'NF', N'NORFOLK ISLAND', N'Norfolk Island', N'NFK', 574, 672)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (159, N'MP', N'NORTHERN MARIANA ISLANDS', N'Northern Mariana Islands', N'MNP', 580, 1670)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (160, N'NO', N'NORWAY', N'Norway', N'NOR', 578, 47)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (161, N'OM', N'OMAN', N'Oman', N'OMN', 512, 968)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (162, N'PK', N'PAKISTAN', N'Pakistan', N'PAK', 586, 92)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (163, N'PW', N'PALAU', N'Palau', N'PLW', 585, 680)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (164, N'PS', N'PALESTINIAN TERRITORY, OCCUPIED', N'Palestinian Territory, Occupied', NULL, NULL, 970)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (165, N'PA', N'PANAMA', N'Panama', N'PAN', 591, 507)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (166, N'PG', N'PAPUA NEW GUINEA', N'Papua New Guinea', N'PNG', 598, 675)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (167, N'PY', N'PARAGUAY', N'Paraguay', N'PRY', 600, 595)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (168, N'PE', N'PERU', N'Peru', N'PER', 604, 51)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (169, N'PH', N'PHILIPPINES', N'Philippines', N'PHL', 608, 63)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (170, N'PN', N'PITCAIRN', N'Pitcairn', N'PCN', 612, 0)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (171, N'PL', N'POLAND', N'Poland', N'POL', 616, 48)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (172, N'PT', N'PORTUGAL', N'Portugal', N'PRT', 620, 351)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (173, N'PR', N'PUERTO RICO', N'Puerto Rico', N'PRI', 630, 1787)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (174, N'QA', N'QATAR', N'Qatar', N'QAT', 634, 974)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (175, N'RE', N'REUNION', N'Reunion', N'REU', 638, 262)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (176, N'RO', N'ROMANIA', N'Romania', N'ROM', 642, 40)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (177, N'RU', N'RUSSIAN FEDERATION', N'Russian Federation', N'RUS', 643, 70)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (178, N'RW', N'RWANDA', N'Rwanda', N'RWA', 646, 250)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (179, N'SH', N'SAINT HELENA', N'Saint Helena', N'SHN', 654, 290)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (180, N'KN', N'SAINT KITTS AND NEVIS', N'Saint Kitts and Nevis', N'KNA', 659, 1869)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (181, N'LC', N'SAINT LUCIA', N'Saint Lucia', N'LCA', 662, 1758)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (182, N'PM', N'SAINT PIERRE AND MIQUELON', N'Saint Pierre and Miquelon', N'SPM', 666, 508)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (183, N'VC', N'SAINT VINCENT AND THE GRENADINES', N'Saint Vincent and the Grenadines', N'VCT', 670, 1784)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (184, N'WS', N'SAMOA', N'Samoa', N'WSM', 882, 684)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (185, N'SM', N'SAN MARINO', N'San Marino', N'SMR', 674, 378)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (186, N'ST', N'SAO TOME AND PRINCIPE', N'Sao Tome and Principe', N'STP', 678, 239)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (187, N'SA', N'SAUDI ARABIA', N'Saudi Arabia', N'SAU', 682, 966)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (188, N'SN', N'SENEGAL', N'Senegal', N'SEN', 686, 221)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (189, N'CS', N'SERBIA AND MONTENEGRO', N'Serbia and Montenegro', NULL, NULL, 381)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (190, N'SC', N'SEYCHELLES', N'Seychelles', N'SYC', 690, 248)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (191, N'SL', N'SIERRA LEONE', N'Sierra Leone', N'SLE', 694, 232)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (192, N'SG', N'SINGAPORE', N'Singapore', N'SGP', 702, 65)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (193, N'SK', N'SLOVAKIA', N'Slovakia', N'SVK', 703, 421)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (194, N'SI', N'SLOVENIA', N'Slovenia', N'SVN', 705, 386)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (195, N'SB', N'SOLOMON ISLANDS', N'Solomon Islands', N'SLB', 90, 677)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (196, N'SO', N'SOMALIA', N'Somalia', N'SOM', 706, 252)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (197, N'ZA', N'SOUTH AFRICA', N'South Africa', N'ZAF', 710, 27)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (198, N'GS', N'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS', N'South Georgia and the South Sandwich Islands', NULL, NULL, 0)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (199, N'ES', N'SPAIN', N'Spain', N'ESP', 724, 34)
GO
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (200, N'LK', N'SRI LANKA', N'Sri Lanka', N'LKA', 144, 94)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (201, N'SD', N'SUDAN', N'Sudan', N'SDN', 736, 249)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (202, N'SR', N'SURINAME', N'Suriname', N'SUR', 740, 597)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (203, N'SJ', N'SVALBARD AND JAN MAYEN', N'Svalbard and Jan Mayen', N'SJM', 744, 47)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (204, N'SZ', N'SWAZILAND', N'Swaziland', N'SWZ', 748, 268)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (205, N'SE', N'SWEDEN', N'Sweden', N'SWE', 752, 46)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (206, N'CH', N'SWITZERLAND', N'Switzerland', N'CHE', 756, 41)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (207, N'SY', N'SYRIAN ARAB REPUBLIC', N'Syrian Arab Republic', N'SYR', 760, 963)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (208, N'TW', N'TAIWAN, PROVINCE OF CHINA', N'Taiwan, Province of China', N'TWN', 158, 886)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (209, N'TJ', N'TAJIKISTAN', N'Tajikistan', N'TJK', 762, 992)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (210, N'TZ', N'TANZANIA, UNITED REPUBLIC OF', N'Tanzania, United Republic of', N'TZA', 834, 255)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (211, N'TH', N'THAILAND', N'Thailand', N'THA', 764, 66)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (212, N'TL', N'TIMOR-LESTE', N'Timor-Leste', NULL, NULL, 670)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (213, N'TG', N'TOGO', N'Togo', N'TGO', 768, 228)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (214, N'TK', N'TOKELAU', N'Tokelau', N'TKL', 772, 690)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (215, N'TO', N'TONGA', N'Tonga', N'TON', 776, 676)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (216, N'TT', N'TRINIDAD AND TOBAGO', N'Trinidad and Tobago', N'TTO', 780, 1868)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (217, N'TN', N'TUNISIA', N'Tunisia', N'TUN', 788, 216)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (218, N'TR', N'TURKEY', N'Turkey', N'TUR', 792, 90)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (219, N'TM', N'TURKMENISTAN', N'Turkmenistan', N'TKM', 795, 7370)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (220, N'TC', N'TURKS AND CAICOS ISLANDS', N'Turks and Caicos Islands', N'TCA', 796, 1649)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (221, N'TV', N'TUVALU', N'Tuvalu', N'TUV', 798, 688)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (222, N'UG', N'UGANDA', N'Uganda', N'UGA', 800, 256)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (223, N'UA', N'UKRAINE', N'Ukraine', N'UKR', 804, 380)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (224, N'AE', N'UNITED ARAB EMIRATES', N'United Arab Emirates', N'ARE', 784, 971)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (225, N'GB', N'UNITED KINGDOM', N'United Kingdom', N'GBR', 826, 44)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (226, N'US', N'UNITED STATES', N'United States', N'USA', 840, 1)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (227, N'UM', N'UNITED STATES MINOR OUTLYING ISLANDS', N'United States Minor Outlying Islands', NULL, NULL, 1)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (228, N'UY', N'URUGUAY', N'Uruguay', N'URY', 858, 598)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (229, N'UZ', N'UZBEKISTAN', N'Uzbekistan', N'UZB', 860, 998)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (230, N'VU', N'VANUATU', N'Vanuatu', N'VUT', 548, 678)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (231, N'VE', N'VENEZUELA', N'Venezuela', N'VEN', 862, 58)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (232, N'VN', N'VIET NAM', N'Viet Nam', N'VNM', 704, 84)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (233, N'VG', N'VIRGIN ISLANDS, BRITISH', N'Virgin Islands, British', N'VGB', 92, 1284)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (234, N'VI', N'VIRGIN ISLANDS, U.S.', N'Virgin Islands, U.s.', N'VIR', 850, 1340)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (235, N'WF', N'WALLIS AND FUTUNA', N'Wallis and Futuna', N'WLF', 876, 681)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (236, N'EH', N'WESTERN SAHARA', N'Western Sahara', N'ESH', 732, 212)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (237, N'YE', N'YEMEN', N'Yemen', N'YEM', 887, 967)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (238, N'ZM', N'ZAMBIA', N'Zambia', N'ZMB', 894, 260)
INSERT [dbo].[Country] ([Id], [Iso], [Name], [NiceName], [Iso3], [NumCode], [PhoneCode]) VALUES (239, N'ZW', N'ZIMBABWE', N'Zimbabwe', N'ZWE', 716, 263)
SET IDENTITY_INSERT [dbo].[Country] OFF
GO
SET IDENTITY_INSERT [dbo].[Dictionary] ON 

INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36363, N'en-US', 1, N'Home')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36364, N'en-US', 2, N'Products')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36365, N'en-US', 3, N'Site Management')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36366, N'en-US', 4, N'Home')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36367, N'en-US', 5, N'Services')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36368, N'en-US', 6, N'Partners')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36369, N'en-US', 7, N'About us')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36370, N'en-US', 8, N'Contact')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36371, N'en-US', 9, N'Login')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36372, N'en-US', 10, N'Register')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36373, N'en-US', 11, N'Search here')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36374, N'en-US', 12, N'Getting started')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36375, N'en-US', 13, N'Language')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36376, N'en-US', 14, N'Country')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36377, N'en-US', 15, N'City')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36378, N'en-US', 16, N'Postcode')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36379, N'en-US', 17, N'Search by skills')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36380, N'en-US', 18, N'Let''s Work Together!')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36381, N'en-US', 19, N'Join free today')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36382, N'en-US', 20, N'Rent workers - Rent out crews - Get or sell construction jobs in your local area or internationally')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36383, N'en-US', 21, N'Profiles, looking for jobs right now')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36384, N'en-US', 22, N'Offering jobs right now')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36385, N'en-US', 23, N'International profiles and jobs')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36386, N'en-US', 24, N'See all profiles here')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36387, N'en-US', 25, N'See all jobs here')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36388, N'en-US', 26, N'Profiles and jobs')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36389, N'en-US', 27, N'Profiles')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36390, N'en-US', 28, N'Jobs')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36391, N'en-US', 29, N'Select country')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36392, N'en-US', 30, N'Free')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36393, N'en-US', 31, N'click')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36394, N'en-US', 32, N'Unlimited')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36395, N'en-US', 33, N'week')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36396, N'en-US', 34, N'month')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36397, N'en-US', 35, N'Limited profile visit')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36398, N'en-US', 36, N'Unlimited profile visit')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36399, N'en-US', 37, N'Limited to living postcode')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36400, N'en-US', 38, N'No limitation to postcode')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36401, N'en-US', 39, N'Limited to chosen postcode')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36402, N'en-US', 40, N'Limited to chosen city')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36403, N'en-US', 41, N'Limited to chosen country')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36404, N'en-US', 42, N'Access to entire profiles')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36405, N'en-US', 43, N'Limited days')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36406, N'en-US', 44, N'No time limitation')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36407, N'en-US', 45, N'No job list')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36408, N'en-US', 46, N'Receive job list')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36409, N'en-US', 47, N'No access to visited profiles')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36410, N'en-US', 48, N'Access to visited profiles')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36411, N'en-US', 49, N'Buy Now')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36412, N'en-US', 50, N'Our services')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36413, N'en-US', 51, N'Rent crew')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36414, N'en-US', 52, N'Get, buy & sell jobs')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36415, N'en-US', 53, N'Networks & Events')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36416, N'en-US', 54, N'Buy & sell used equipments')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36417, N'en-US', 55, N'Buy & sell new equipments')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36418, N'en-US', 56, N'Use')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36419, N'en-US', 57, N'As you wish')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36420, N'en-US', 58, N'Future digital access')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36421, N'en-US', 59, N'Read more about System')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36422, N'en-US', 60, N'Testimonial')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36423, N'en-US', 61, N'Sign up now and be a part of a future')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36424, N'en-US', 62, N'Sign me up')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36425, N'en-US', 63, N'Upcoming events')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36426, N'en-US', 64, N'Get in touch')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36427, N'en-US', 65, N'Address')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36428, N'en-US', 66, N'E-Mail')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36429, N'en-US', 67, N'Phone')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36430, N'en-US', 68, N'Who are we')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36431, N'en-US', 69, N'and where are we going')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36432, N'en-US', 70, N'Welcome to the club')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36433, N'en-US', 71, N'Join our next meeting')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36434, N'en-US', 72, N'The best network of the year')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36435, N'en-US', 73, N'See all genre')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36436, N'en-US', 74, N'Network')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36437, N'en-US', 75, N'Contact us')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36438, N'en-US', 76, N'Meet us here')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36439, N'en-US', 77, N'Network meetings')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36440, N'en-US', 78, N'Saturday ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36441, N'en-US', 79, N'Sunday ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36442, N'en-US', 80, N'Monday ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36443, N'en-US', 81, N'Tuesday')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36444, N'en-US', 82, N'Wednesday')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36445, N'en-US', 83, N'Thursday')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36446, N'en-US', 84, N'Friday')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36447, N'en-US', 85, N'Sign up to System today')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36448, N'en-US', 86, N'Name')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36449, N'en-US', 87, N'Subject')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36450, N'en-US', 88, N'Message')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36451, N'en-US', 89, N'Send')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36452, N'en-US', 90, N'See all members')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36453, N'en-US', 91, N'See all events')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36454, N'en-US', 92, N'See all jobs')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36455, N'en-US', 93, N'Webshop')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36456, N'en-US', 94, N'A network')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36457, N'en-US', 95, N'That supports you')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36458, N'en-US', 96, N'Start working with us')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36459, N'en-US', 97, N'Contact your local branch')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36460, N'en-US', 98, N'The best contracts')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36461, N'en-US', 99, N'Starts here')
GO
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36462, N'en-US', 100, N'Geographical location')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36463, N'en-US', 101, N'See all representatives')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36464, N'en-US', 102, N'What do you gain from your membership')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36465, N'en-US', 103, N'Join the next network meeting')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36466, N'en-US', 104, N'Password')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36467, N'en-US', 105, N'Remember me?')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36468, N'en-US', 106, N'Forgot password?')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36469, N'en-US', 107, N'Social network account log in')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36470, N'en-US', 108, N'Email is required')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36471, N'en-US', 109, N'Password is required')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36472, N'en-US', 110, N'Enter your email')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36473, N'en-US', 111, N'Email link')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36474, N'en-US', 112, N'Create a new account')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36475, N'en-US', 113, N'User name')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36476, N'en-US', 114, N'Role')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36477, N'en-US', 115, N'Confirm password')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36478, N'en-US', 116, N'Select your role')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36479, N'en-US', 117, N'Company')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36480, N'en-US', 118, N'Customer')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36481, N'en-US', 119, N'Skilled worker')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36482, N'en-US', 120, N'Admin panel')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36483, N'en-US', 121, N'All rights reserved')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36484, N'en-US', 122, N'Login with your social network account')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36485, N'en-US', 123, N'Social login')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36486, N'en-US', 124, N'Error')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36487, N'en-US', 125, N'An error occurred while processing your request')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36488, N'en-US', 126, N'Locked out')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36489, N'en-US', 127, N'This account has been locked out, please try again later')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36490, N'en-US', 128, N'Create local login')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36491, N'en-US', 129, N'Set password')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36492, N'en-US', 130, N'Change password form')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36493, N'en-US', 131, N'Change password')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36494, N'en-US', 132, N'Format')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36495, N'en-US', 133, N'Protection')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36496, N'en-US', 134, N'Type')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36497, N'en-US', 135, N'You''ve successfully authenticated with')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36498, N'en-US', 136, N'You do not have a local username/password for this site. add a local account so you can log in without an external login.')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36499, N'en-US', 137, N'Please enter a username for this site below and click the register button to finish logging in.')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36500, N'en-US', 138, N'Unsuccessful login with service')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36501, N'en-US', 139, N'Please check your email to reset your password')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36502, N'en-US', 140, N'Select your countries')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36503, N'en-US', 141, N'Reset')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36504, N'en-US', 142, N'Reset your password')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36505, N'en-US', 143, N'Your password has been reset')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36506, N'en-US', 144, N'Click here to log in')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36507, N'en-US', 145, N'Register date')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36508, N'en-US', 146, N'Roles')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36509, N'en-US', 147, N'Forgot password confirmation')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36510, N'en-US', 148, N'Spinning machine')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36511, N'en-US', 149, N'Product Definition')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36512, N'en-US', 150, N'Services')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36513, N'en-US', 151, N'Moving pictures')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36514, N'en-US', 152, N'Main text')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36515, N'en-US', 153, N'Messages')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36516, N'en-US', 154, N'Message')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36517, N'en-US', 155, N'Change passwords')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36518, N'en-US', 156, N'Managing languages')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36519, N'en-US', 157, N'Exit')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36520, N'en-US', 158, N'Download the Excel language file')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36521, N'en-US', 159, N'Upload the Excel language file')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36522, N'en-US', 160, N'Introducing')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36523, N'en-US', 161, N'Nadine Trade')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36524, N'en-US', 162, N'More information')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36525, N'en-US', 163, N'Completed project')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36526, N'en-US', 164, N'Years of experience')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36527, N'en-US', 165, N'Authentic product')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36528, N'en-US', 166, N'Return')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36529, N'en-US', 167, N'Processing, please wait ...')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36530, N'en-US', 168, N'Enter the name')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36531, N'en-US', 169, N'Enter the subject of the message')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36532, N'en-US', 170, N'Enter the message')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36533, N'en-US', 171, N'Enter the email')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36534, N'en-US', 172, N'Please enter the correct email address')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36535, N'en-US', 173, N'Message sent')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36536, N'en-US', 174, N'Double-click the row to change the information or click the pencil mark in the row')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36537, N'en-US', 175, N'Did you feel that way?')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36538, N'en-US', 176, N'Iran office')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36539, N'en-US', 177, N'Tehran')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36540, N'en-US', 178, N'Office in Turkey')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36541, N'en-US', 179, N'Istanbul')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36542, N'en-US', 180, N'Message title')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36543, N'en-US', 181, N'Send Message')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36544, N'en-US', 182, N'Details')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36545, N'en-US', 183, N'Please select a file')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36546, N'en-US', 184, N'Loading languages')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36547, N'en-US', 185, N'Select the file')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36548, N'en-US', 186, N'Supply of Consumables')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36549, N'en-US', 187, N'Repairs')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36550, N'en-US', 188, N'Installation')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36551, N'en-US', 189, N'Blogs')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36552, N'en-US', 190, N'Categories')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36553, N'en-US', 191, N'Projects')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36554, N'en-US', 192, N'Blog')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36555, N'en-US', 193, N'Textile')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36556, N'en-US', 194, N'Type 1 projects')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36557, N'en-US', 195, N'Type Two Projects')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36558, N'en-US', 196, N'Agriculture')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36559, N'en-US', 197, N'Services')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36560, N'en-US', 198, N'Installation')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36561, N'en-US', 199, N'Repairs')
GO
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36562, N'en-US', 200, N'Supply of Consumables')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36563, N'en-US', 201, N'Car Parts')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36564, N'en-US', 202, N'Spare')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36565, N'en-US', 203, N'Hospital equipment')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36566, N'en-US', 204, N'Texturing machines')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36567, N'en-US', 205, N'Dyeing machines')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36568, N'en-US', 206, N'Spinning machines')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36569, N'en-US', 207, N'Sample fabric products')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36570, N'en-US', 208, N'Luxury')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36571, N'en-US', 209, N'Crop harvesting machines')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36572, N'en-US', 210, N'Types of fertilizers')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36573, N'en-US', 211, N'Modern beds')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36574, N'en-US', 212, N'Computer equipment')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36575, N'en-US', 213, N'Hardware')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36576, N'en-US', 214, N'Software')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36577, N'en-US', 215, N'New products will be introduced soon')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36578, N'en-US', 216, N'Name')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36579, N'en-US', 217, N'E-Mail')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36580, N'en-US', 218, N'Available')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36581, N'en-US', 219, N'Unavailable')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36582, N'en-US', 220, N'Media selection')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36583, N'en-US', 221, N'Knitting machines')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36584, N'en-US', 222, N'Download Intro Movie')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36585, N'en-US', 223, N'Film selection')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36586, N'en-US', 224, N'Dyeing')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36587, N'en-US', 225, N'Video playback site link')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36588, N'en-US', 226, N'Spinning')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36589, N'en-US', 227, N'Printing tape')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36590, N'en-US', 228, N'Parts & Supplies')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36591, N'en-US', 229, N'Introducing new services')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36592, N'en-US', 230, N'Active')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36593, N'en-US', 231, N'Sample Products')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36594, N'en-US', 232, N'Services management')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36595, N'en-US', 233, N'Product Management')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36596, N'en-US', 234, N'Product Name')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36597, N'en-US', 235, N'Visit')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36598, N'en-US', 236, N'Category')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36599, N'en-US', 237, N'Image priority')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36600, N'en-US', 238, N'Definition')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36601, N'en-US', 239, N'Picture')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36602, N'en-US', 240, N'Default screen')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36603, N'en-US', 241, N'Available')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36604, N'en-US', 242, N'Add new product')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36605, N'en-US', 243, N'Are you sure ?')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36606, N'en-US', 244, N'Cancel')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36607, N'en-US', 245, N'Language')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36608, N'en-US', 246, N'Select Language...')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36609, N'en-US', 247, N'Add')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36610, N'en-US', 248, N'Change')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36611, N'en-US', 249, N'Delete')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36612, N'en-US', 250, N'Yes')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36613, N'en-US', 251, N'No')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36614, N'en-US', 252, N'The original title cannot be changed. Please right-click and select Add New.')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36615, N'en-US', 253, N'Display on homepage')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36616, N'en-US', 254, N'Select the Excel language file')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36617, N'en-US', 255, N'Upload and Save')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36618, N'en-US', 256, N'Select a photo')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36619, N'en-US', 257, N'Summary text')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36620, N'en-US', 258, N'Full text')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36621, N'en-US', 259, N'Show selected movie')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36622, N'en-US', 260, N'Generating specifications, please wait')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36623, N'en-US', 261, N'Additional Profile Management')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36624, N'en-US', 262, N'Select a category')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36625, N'en-US', 263, N'Resim yüklenirken hata oluştu')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36626, N'en-US', 264, N'Click to view additional details')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36627, N'en-US', 265, N'Loading profile, please wait')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36628, N'en-US', 266, N'The option was not found, please search for another keyword')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36629, N'en-US', 267, N'search result')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36630, N'en-US', 268, N'Product Profile Management')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36631, N'en-US', 269, N'Image caption')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36632, N'en-US', 270, N'Save')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36633, N'en-US', 271, N'All')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36634, N'en-US', 272, N'Men')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36635, N'en-US', 273, N'Women')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36636, N'en-US', 274, N'Clothing')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36637, N'en-US', 275, N'Accessories')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36638, N'en-US', 276, N'Clothing')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36639, N'en-US', 277, N'Girls')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36640, N'en-US', 278, N'Boys')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36641, N'en-US', 279, N'Girls From 4 to 14 years')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36642, N'en-US', 280, N'Boys From 4 to 14 years')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36643, N'en-US', 281, N'Girls From 0 to 4 years')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36644, N'en-US', 282, N'Boys From 0 to 4 years')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36645, N'en-US', 283, N'Shirts')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36646, N'en-US', 284, N'Shoes')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36647, N'en-US', 285, N'Dress')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36648, N'en-US', 286, N'Shirt')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36649, N'en-US', 287, N'Trouser')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36650, N'fa-IR', 1, N'خانه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36651, N'fa-IR', 2, N'محصولات')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36652, N'fa-IR', 3, N'مدیریت سایت')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36653, N'fa-IR', 4, N'صفحه اصلی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36654, N'fa-IR', 5, N'خدمات')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36655, N'fa-IR', 6, N'نمایندگی ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36656, N'fa-IR', 7, N'درباره ما')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36657, N'fa-IR', 8, N'تماس با ما')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36658, N'fa-IR', 9, N'ورود به سیستم')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36659, N'fa-IR', 10, N'عضویت')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36660, N'fa-IR', 11, N'جستجو')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36661, N'fa-IR', 12, N'شروع به کار')
GO
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36662, N'fa-IR', 13, N'زبان')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36663, N'fa-IR', 14, N'کشور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36664, N'fa-IR', 15, N'شهر')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36665, N'fa-IR', 16, N'کد پستی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36666, N'fa-IR', 17, N'تخصص')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36667, N'fa-IR', 18, N'همکاری با هم')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36668, N'fa-IR', 19, N'عضویت رایگان')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36669, N'fa-IR', 20, N'اجاره کردن نیروی کار, اجاره دادن نیروی کار, گرفتن یا واگذاری کارها در مناطق اطراف خود')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36670, N'fa-IR', 21, N'پروفایلهای جستجو کننده  کار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36671, N'fa-IR', 22, N'پیشنهادهای کاری')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36672, N'fa-IR', 23, N'تمام جستجو کننده های کار و پیشنهادهای کاری')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36673, N'fa-IR', 24, N'دیدن تمامی پروفایل ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36674, N'fa-IR', 25, N'دیدن تمامی کارها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36675, N'fa-IR', 26, N'پروفایل ها و کارها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36676, N'fa-IR', 27, N'پروفایل ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36677, N'fa-IR', 28, N'کارها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36678, N'fa-IR', 29, N'انتخاب کشور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36679, N'fa-IR', 30, N'رایگان')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36680, N'fa-IR', 31, N'کلیک')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36681, N'fa-IR', 32, N'نامحدود')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36682, N'fa-IR', 33, N'هفته')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36683, N'fa-IR', 34, N'ماه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36684, N'fa-IR', 35, N' تعداد مراجعات محدود')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36685, N'fa-IR', 36, N'تعداد مراجعات نامحدود')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36686, N'fa-IR', 37, N'محدود به کد پستی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36687, N'fa-IR', 38, N'بدون محدودیت کد پستی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36688, N'fa-IR', 39, N'محدود به کدپستی انتخاب شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36689, N'fa-IR', 40, N'محدود به شهر انتخاب شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36690, N'fa-IR', 41, N'محدود به کشور انتخاب شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36691, N'fa-IR', 42, N'دسترسی به تمامی پروفایل ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36692, N'fa-IR', 43, N'محدود به تعداد روز')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36693, N'fa-IR', 44, N'بدون محدودیت زمانی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36694, N'fa-IR', 45, N'بدون لیست کار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36695, N'fa-IR', 46, N'دریافت لیست کار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36696, N'fa-IR', 47, N'بدون دسترسی به پروفایل های بازدید شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36697, N'fa-IR', 48, N'دسترسی به پروفایل های بازدید شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36698, N'fa-IR', 49, N'خرید کن')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36699, N'fa-IR', 50, N'خدمات اصلی ما')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36700, N'fa-IR', 51, N'اجاره نیروی کار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36701, N'fa-IR', 52, N'گرفتن خرید و فروش کار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36702, N'fa-IR', 53, N'ارتباطات و رویدادها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36703, N'fa-IR', 54, N'خرید و فروش ابزارهای دست دوم')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36704, N'fa-IR', 55, N'خرید و فروش ابزار های نو')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36705, N'fa-IR', 56, N'استفاده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36706, N'fa-IR', 57, N'همانطور که شما می‌خواهید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36707, N'fa-IR', 58, N'دسترسی دیجیتالی در آینده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36708, N'fa-IR', 59, N'در مورد این محصول بیشتر بخوانید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36709, N'fa-IR', 60, N'رضایتمندی و توصیه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36710, N'fa-IR', 61, N' ثبت نام کنید و به آینده بپیوندید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36711, N'fa-IR', 62, N'ثبت نام کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36712, N'fa-IR', 63, N'رویدادهای آینده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36713, N'fa-IR', 64, N'در تماس باشید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36714, N'fa-IR', 65, N'آدرس')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36715, N'fa-IR', 66, N'پست الکترونیکی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36716, N'fa-IR', 67, N'تلفن')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36717, N'fa-IR', 68, N'ما که هستیم')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36718, N'fa-IR', 69, N'و کجا میرویم')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36719, N'fa-IR', 70, N'به باشگاه خوش آمدید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36720, N'fa-IR', 71, N'به گردهمایی بعدی ما بپیوندید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36721, N'fa-IR', 72, N'بهترین شبکه ارتباطی سال')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36722, N'fa-IR', 73, N'مشاهده تمامی روش ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36723, N'fa-IR', 74, N'شبکه ارتباطی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36724, N'fa-IR', 75, N'تماس با ما')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36725, N'fa-IR', 76, N'اینجا ما را ملاقات کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36726, N'fa-IR', 77, N'جلسه های ارتباطی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36727, N'fa-IR', 78, N'شنبه ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36728, N'fa-IR', 79, N'یکشنبه ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36729, N'fa-IR', 80, N'دوشنبه ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36730, N'fa-IR', 81, N'سه شنبه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36731, N'fa-IR', 82, N'چهارشنبه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36732, N'fa-IR', 83, N'پنجشنبه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36733, N'fa-IR', 84, N'جمعه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36734, N'fa-IR', 85, N'همین امروز در سیستم ما ثبت نام کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36735, N'fa-IR', 86, N'اسم ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36736, N'fa-IR', 87, N'موضوع')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36737, N'fa-IR', 88, N'پیغام')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36738, N'fa-IR', 89, N'ارسال')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36739, N'fa-IR', 90, N'مشاهده همه اعضا')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36740, N'fa-IR', 91, N'مشاهده همه رویدادها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36741, N'fa-IR', 92, N'مشاهده همه کارها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36742, N'fa-IR', 93, N'فروشگاه اینترنتی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36743, N'fa-IR', 94, N'یک همکاری')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36744, N'fa-IR', 95, N'که از شما پشتیبانی کند')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36745, N'fa-IR', 96, N'همکاری خود را شروع کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36746, N'fa-IR', 97, N'تماس با شعبه محلی اتان')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36747, N'fa-IR', 98, N'بهترین قرارداد')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36748, N'fa-IR', 99, N'از اینجا شروع کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36749, N'fa-IR', 100, N'موقعیت جغرافیایی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36750, N'fa-IR', 101, N'مشاهده نمایندگی ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36751, N'fa-IR', 102, N'از عضویت در این سامانه چه بدست می آورید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36752, N'fa-IR', 103, N'به جلسه ارتباطی بعدی ملحق شوید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36753, N'fa-IR', 104, N'رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36754, N'fa-IR', 105, N'مرا به خاطر بسپار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36755, N'fa-IR', 106, N'فراموش کردن رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36756, N'fa-IR', 107, N'ورود با استفاده از شبکه اجتماعی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36757, N'fa-IR', 108, N'آدرس الکترونیکی الزامی است')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36758, N'fa-IR', 109, N'رمز عبور اجباری است')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36759, N'fa-IR', 110, N'آدرس الکترونیکی خود را وارد کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36760, N'fa-IR', 111, N'لینک آدرس الکترونیکی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36761, N'fa-IR', 112, N'یک حساب کاربری جدید ایجاد کنید')
GO
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36762, N'fa-IR', 113, N'نام کاربری')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36763, N'fa-IR', 114, N'نقش')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36764, N'fa-IR', 115, N'تایید رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36765, N'fa-IR', 116, N'نقش خود را انتخاب کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36766, N'fa-IR', 117, N'شرکت')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36767, N'fa-IR', 118, N'مشتری')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36768, N'fa-IR', 119, N'نیروی کار ماهر')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36769, N'fa-IR', 120, N'پنل مدیریت')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36770, N'fa-IR', 121, N'همه حقوق محفوظ است')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36771, N'fa-IR', 122, N'با حساب شبکه اجتماعی خود وارد شوید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36772, N'fa-IR', 123, N'ورود با شبکه اجتماعی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36773, N'fa-IR', 124, N'خطا')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36774, N'fa-IR', 125, N'یک خطا در هنگام بررسی درخواست شما رخ داد')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36775, N'fa-IR', 126, N'قفل شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36776, N'fa-IR', 127, N'این حساب کاربری قفل شده است، لطفا بعدا دوباره امتحان کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36777, N'fa-IR', 128, N'ایجاد ورود کاربری محلی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36778, N'fa-IR', 129, N'تنظیم رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36779, N'fa-IR', 130, N'فرم تغییر رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36780, N'fa-IR', 131, N'تغییر رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36781, N'fa-IR', 132, N'قالب')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36782, N'fa-IR', 133, N'حفاظت')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36783, N'fa-IR', 134, N'نوع')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36784, N'fa-IR', 135, N'شما با موفقیت تهیه شده با استفاده از')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36785, N'fa-IR', 136, N'شما نام کاربری و کلمه عبور محلی برای این سایت ندارید یک حساب محلی اضافه کنید تا بتوانید بدون حساب کاربری خارجی به سیستم وارد شوید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36786, N'fa-IR', 137, N'لطفاً نام کاربری خود را برای این وبسایت وارد کنید و سپس روی دکمه ثبت نام کلیک کنید تا عمل ورود به سیستم پایان یابد')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36787, N'fa-IR', 138, N'ورود ناموفق با سرویس')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36788, N'fa-IR', 139, N'لطفآ آدرس الکترونیکی خود را جهت تغییر رمز عبور چک نمایید ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36789, N'fa-IR', 140, N'کشور خود را انتخاب نمایید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36790, N'fa-IR', 141, N'تنظیم مجدد')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36791, N'fa-IR', 142, N'تنظیم مجدد رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36792, N'fa-IR', 143, N'رمز عبور شما مجدداً تنظیم گردید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36793, N'fa-IR', 144, N'برای ورود اینجا کلیک نمایید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36794, N'fa-IR', 145, N'تاریخ ثبت نام')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36795, N'fa-IR', 146, N'نقش ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36796, N'fa-IR', 147, N'تایید رمز عبور را فراموش کرده اید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36797, N'fa-IR', 148, N'دستگاه ریسندگی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36798, N'fa-IR', 149, N'تعریف محصولات')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36799, N'fa-IR', 150, N'خدمات')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36800, N'fa-IR', 151, N'تصاویر متحرک')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36801, N'fa-IR', 152, N'متن اصلی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36802, N'fa-IR', 153, N'پیام ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36803, N'fa-IR', 154, N'پیام')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36804, N'fa-IR', 155, N'تغییر کلمه عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36805, N'fa-IR', 156, N'مدیریت زبانها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36806, N'fa-IR', 157, N'خروج')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36807, N'fa-IR', 158, N'دریافت فایل اکسل زبان ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36808, N'fa-IR', 159, N'بارگذاری فایل اکسل زبان ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36809, N'fa-IR', 160, N'آشنایی با')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36810, N'fa-IR', 161, N'نادین ترِید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36811, N'fa-IR', 162, N'اطلاعات بیشتر')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36812, N'fa-IR', 163, N'پروژه انجام شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36813, N'fa-IR', 164, N'سال تجربه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36814, N'fa-IR', 165, N'محصول معتبر')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36815, N'fa-IR', 166, N'برگشت')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36816, N'fa-IR', 167, N'در حال پردازش، لطفا صبر کنید...')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36817, N'fa-IR', 168, N'نام را وارد نمایید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36818, N'fa-IR', 169, N'عنوان پیام را وارد نمایید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36819, N'fa-IR', 170, N'پیام را وارد نمایید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36820, N'fa-IR', 171, N'ایمیل را وارد نمایید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36821, N'fa-IR', 172, N'لطفا آدرس ایمیل صحیح را وارد نمایید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36822, N'fa-IR', 173, N'پیام ارسال شد')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36823, N'fa-IR', 174, N'جهت تغییر اطلاعات بر روی سطر مورد نظر دو بار کلیک کنید یا بر روی علامت مداد در ردیف مورد نظر کلیک کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36824, N'fa-IR', 175, N'آیا مطمعن هسید؟')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36825, N'fa-IR', 176, N'دفتر ایران')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36826, N'fa-IR', 177, N'تهران')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36827, N'fa-IR', 178, N'دفتر ترکیه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36828, N'fa-IR', 179, N'استانبول')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36829, N'fa-IR', 180, N'عنوان پیام')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36830, N'fa-IR', 181, N'ارسال پیام')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36831, N'fa-IR', 182, N'جزییات')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36832, N'fa-IR', 183, N'لطفا فایل را انتخاب کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36833, N'fa-IR', 184, N'بارگذاری زبانها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36834, N'fa-IR', 185, N'فایل را انتخاب کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36835, N'fa-IR', 186, N'تامین لوازم مصرفی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36836, N'fa-IR', 187, N'تعمیرات')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36837, N'fa-IR', 188, N'نصب و راه اندازی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36838, N'fa-IR', 189, N'بلاگ ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36839, N'fa-IR', 190, N'دسته بندی ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36840, N'fa-IR', 191, N'پروژه ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36841, N'fa-IR', 192, N'بلاگ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36842, N'fa-IR', 193, N'نساجی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36843, N'fa-IR', 194, N'پروژه های نوع یک')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36844, N'fa-IR', 195, N'پروژه های نوع دو')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36845, N'fa-IR', 196, N'کشاورزی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36846, N'fa-IR', 197, N'خدمات')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36847, N'fa-IR', 198, N'نصب و راه اندازی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36848, N'fa-IR', 199, N'تعمیرات')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36849, N'fa-IR', 200, N'تامین لوازم مصرفی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36850, N'fa-IR', 201, N'قطعات اتوموبیل')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36851, N'fa-IR', 202, N'یدکی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36852, N'fa-IR', 203, N'تجهیزات بیمارستانی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36853, N'fa-IR', 204, N'دستگاه های تکسچرایزینگ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36854, N'fa-IR', 205, N'دستگاه های رنگرزی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36855, N'fa-IR', 206, N'دستگاهای ریسندگی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36856, N'fa-IR', 207, N'محصولات پارچه ای نمونه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36857, N'fa-IR', 208, N'لوکس')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36858, N'fa-IR', 209, N'ماشین آلات برداشت محصول')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36859, N'fa-IR', 210, N'انواع کود')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36860, N'fa-IR', 211, N'تخت های مدرن')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36861, N'fa-IR', 212, N'تجهیزات کام‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍یوتری')
GO
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36862, N'fa-IR', 213, N'سخت افزار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36863, N'fa-IR', 214, N'نرم افزار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36864, N'fa-IR', 215, N'محصولات جدید بزودی معرفی خواهند شد')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36865, N'fa-IR', 216, N'نام')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36866, N'fa-IR', 217, N'ایمیل')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36867, N'fa-IR', 218, N'موجود')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36868, N'fa-IR', 219, N'نا موجود')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36869, N'fa-IR', 220, N'انتخاب رسانه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36870, N'fa-IR', 221, N'دستگاهای بافندگی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36871, N'fa-IR', 222, N'دانلود فیلم معرفی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36872, N'fa-IR', 223, N'انتخاب فیلم')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36873, N'fa-IR', 224, N'رنگرزی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36874, N'fa-IR', 225, N'لینک سایت پخش فیلم')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36875, N'fa-IR', 226, N'ریسندگی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36876, N'fa-IR', 227, N'چاپ نوار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36877, N'fa-IR', 228, N'قطعات و لوازم')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36878, N'fa-IR', 229, N'معرفی خدمت جدید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36879, N'fa-IR', 230, N'فعال')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36880, N'fa-IR', 231, N'محصولات نمونه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36881, N'fa-IR', 232, N'مدیریت خدمات')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36882, N'fa-IR', 233, N'مدیریت محصولات')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36883, N'fa-IR', 234, N'نام محصول')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36884, N'fa-IR', 235, N'دفعات مشاهده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36885, N'fa-IR', 236, N'دسته بندی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36886, N'fa-IR', 237, N'اولویت نمایش')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36887, N'fa-IR', 238, N'توضیحات')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36888, N'fa-IR', 239, N'تصویر')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36889, N'fa-IR', 240, N'نمایش پیش فرض')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36890, N'fa-IR', 241, N'موجود')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36891, N'fa-IR', 242, N'افزودن محصول جدید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36892, N'fa-IR', 243, N'آیا مطمعن هستید؟')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36893, N'fa-IR', 244, N'انصراف')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36894, N'fa-IR', 245, N'زبان')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36895, N'fa-IR', 246, N'انتخاب زبان')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36896, N'fa-IR', 247, N'افزودن')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36897, N'fa-IR', 248, N'تغییر')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36898, N'fa-IR', 249, N'حذف')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36899, N'fa-IR', 250, N'بلی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36900, N'fa-IR', 251, N'خیر')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36901, N'fa-IR', 252, N'عنوان اصلی قابل تغییر نیست. لطفا کلیک راست کرده و گزینه افزودن جدید را انتخاب کنید.')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36902, N'fa-IR', 253, N'نمایش در صفحه اصلی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36903, N'fa-IR', 254, N'فایل اکسل زبانها را انتخاب کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36904, N'fa-IR', 255, N'بارگذاری و ذخیره')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36905, N'fa-IR', 256, N'انتخاب عکس')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36906, N'fa-IR', 257, N'متن خلاصه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36907, N'fa-IR', 258, N'متن کامل')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36908, N'fa-IR', 259, N'نمایش فیلم انتخاب شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36909, N'fa-IR', 260, N'در حال تولید مشخصات، لطفا منتظر بمانید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36910, N'fa-IR', 261, N'مدیریت مشخصات تکمیلی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36911, N'fa-IR', 262, N'دسته بندی را انتخاب کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36912, N'fa-IR', 263, N'خطا در بارگذاری تصویر')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36913, N'fa-IR', 264, N'جهت مشاهده مشخصات تکمیلی کلیک کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36914, N'fa-IR', 265, N'در حال بارگذاری مشخصات، لطفا منتظر بمانید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36915, N'fa-IR', 266, N'گزینه مورد نظر یافت نشد، لطفا با کلمه کلیدی دیگری جستجو کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36916, N'fa-IR', 267, N'نتیجه جستجو')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36917, N'fa-IR', 268, N'مدیریت مشخصات محصولات')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36918, N'fa-IR', 269, N'متن تصویر')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36919, N'fa-IR', 270, N'ذخیره')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36920, N'fa-IR', 271, N'همه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36921, N'fa-IR', 272, N'مردانه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36922, N'fa-IR', 273, N'زنانه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36923, N'fa-IR', 274, N'تن پوش')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36924, N'fa-IR', 275, N'اکسسوری')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36925, N'fa-IR', 276, N'تن پوش')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36926, N'fa-IR', 277, N'دخترانه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36927, N'fa-IR', 278, N'پسرانه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36928, N'fa-IR', 279, N'دخترانه از 4 تا 14 سال')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36929, N'fa-IR', 280, N'پسرانه از 4 تا 14 سال')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36930, N'fa-IR', 281, N'دخترانه از 0 تا 4 سال')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36931, N'fa-IR', 282, N'پسرانه از 0 تا 4 سال')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36932, N'fa-IR', 283, N'پیراهن')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36933, N'fa-IR', 284, N'کفش')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36934, N'fa-IR', 285, N'لباس')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36935, N'fa-IR', 286, N'پیراهن')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36936, N'fa-IR', 287, N'شلوار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36937, N'tr-TR', 1, N'Ev')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36938, N'tr-TR', 2, N'Ürünler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36939, N'tr-TR', 3, N'Site Yönetimi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36940, N'tr-TR', 4, N'Ev')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36941, N'tr-TR', 5, N'Hizmetler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36942, N'tr-TR', 6, N'Ortaklar')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36943, N'tr-TR', 7, N'Hakkımızda')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36944, N'tr-TR', 8, N'İletişim')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36945, N'tr-TR', 9, N'Oturum aç')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36946, N'tr-TR', 10, N'Kayıt ol')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36947, N'tr-TR', 11, N'Burada ara')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36948, N'tr-TR', 12, N'Başlangıç')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36949, N'tr-TR', 13, N'Dil')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36950, N'tr-TR', 14, N'ülke')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36951, N'tr-TR', 15, N'Kent')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36952, N'tr-TR', 16, N'posta kodu')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36953, N'tr-TR', 17, N'Becerilere göre ara')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36954, N'tr-TR', 18, N'Beraber çalışalım!')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36955, N'tr-TR', 19, N'Bugün ücretsiz katılın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36956, N'tr-TR', 20, N'İşçi kirala - Mürettebat kiralayın - Bölgenizdeki veya uluslararası inşaat işlerini alın veya satın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36957, N'tr-TR', 21, N'Profiller, şu anda iş arıyor')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36958, N'tr-TR', 22, N'Şu anda iş teklifi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36959, N'tr-TR', 23, N'Uluslararası profiller ve işler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36960, N'tr-TR', 24, N'Tüm profilleri burada görün')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36961, N'tr-TR', 25, N'Buradaki tüm işleri görün')
GO
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36962, N'tr-TR', 26, N'Profiller ve işler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36963, N'tr-TR', 27, N'Profiller')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36964, N'tr-TR', 28, N'Meslekler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36965, N'tr-TR', 29, N'Ülke seçin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36966, N'tr-TR', 30, N'Bedava')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36967, N'tr-TR', 31, N'Tıklayın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36968, N'tr-TR', 32, N'Sınırsız')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36969, N'tr-TR', 33, N'hafta')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36970, N'tr-TR', 34, N'ay')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36971, N'tr-TR', 35, N'Sınırlı profil ziyareti')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36972, N'tr-TR', 36, N'Sınırsız profil ziyareti')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36973, N'tr-TR', 37, N'Yaşayan posta koduyla sınırlıdır')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36974, N'tr-TR', 38, N'Posta koduyla ilgili bir sınırlama yoktur')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36975, N'tr-TR', 39, N'Seçilen posta koduyla sınırlıdır')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36976, N'tr-TR', 40, N'Seçilen şehirle sınırlı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36977, N'tr-TR', 41, N'Seçilen ülke ile sınırlıdır')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36978, N'tr-TR', 42, N'Tüm profillere erişim')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36979, N'tr-TR', 43, N'Sınırlı günler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36980, N'tr-TR', 44, N'Zaman sınırlaması yok')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36981, N'tr-TR', 45, N'İş listesi yok')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36982, N'tr-TR', 46, N'İş listesini al')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36983, N'tr-TR', 47, N'Ziyaret edilen profillere erişim yok')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36984, N'tr-TR', 48, N'Ziyaret edilen profillere erişim')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36985, N'tr-TR', 49, N'Şimdi satın al')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36986, N'tr-TR', 50, N'Hizmetlerimiz')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36987, N'tr-TR', 51, N'Mürettebat kirala')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36988, N'tr-TR', 52, N'İşleri alın, satın alın ve satın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36989, N'tr-TR', 53, N'Ağlar ve Etkinlikler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36990, N'tr-TR', 54, N'Kullanılmış ekipman alım satımı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36991, N'tr-TR', 55, N'Yeni ekipman alım satımı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36992, N'tr-TR', 56, N'kullanım')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36993, N'tr-TR', 57, N'Nasıl istersen')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36994, N'tr-TR', 58, N'Gelecekteki dijital erişim')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36995, N'tr-TR', 59, N'Sistem hakkında devamını oku')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36996, N'tr-TR', 60, N'bonservis')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36997, N'tr-TR', 61, N'Şimdi kaydolun ve geleceğin bir parçası olun')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36998, N'tr-TR', 62, N'beni kaydet')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (36999, N'tr-TR', 63, N'Yaklaşan Etkinlikler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37000, N'tr-TR', 64, N'Temasta olmak')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37001, N'tr-TR', 65, N'Adres')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37002, N'tr-TR', 66, N'E-Posta')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37003, N'tr-TR', 67, N'Telefon')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37004, N'tr-TR', 68, N'Biz Kimiz')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37005, N'tr-TR', 69, N've nereye gidiyoruz')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37006, N'tr-TR', 70, N'Kulübe hoşgeldin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37007, N'tr-TR', 71, N'Bir sonraki toplantımıza katılın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37008, N'tr-TR', 72, N'Yılın en iyi ağı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37009, N'tr-TR', 73, N'Tüm türü görün')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37010, N'tr-TR', 74, N'Ağ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37011, N'tr-TR', 75, N'Bize Ulaşın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37012, N'tr-TR', 76, N'Burada buluşalım')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37013, N'tr-TR', 77, N'Ağ toplantıları')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37014, N'tr-TR', 78, N'Cumartesi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37015, N'tr-TR', 79, N'Pazar')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37016, N'tr-TR', 80, N'Pazartesi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37017, N'tr-TR', 81, N'Salı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37018, N'tr-TR', 82, N'Çarşamba')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37019, N'tr-TR', 83, N'Perşembe')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37020, N'tr-TR', 84, N'Cuma')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37021, N'tr-TR', 85, N'Bugün sisteme kaydolun')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37022, N'tr-TR', 86, N'ad')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37023, N'tr-TR', 87, N'konu')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37024, N'tr-TR', 88, N'İleti')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37025, N'tr-TR', 89, N'Gönder')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37026, N'tr-TR', 90, N'Tüm üyeleri görün')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37027, N'tr-TR', 91, N'Tüm etkinlikleri görün')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37028, N'tr-TR', 92, N'Tüm işleri görün')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37029, N'tr-TR', 93, N'Sanal mağaza')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37030, N'tr-TR', 94, N'Ağ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37031, N'tr-TR', 95, N'Bu seni destekliyor')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37032, N'tr-TR', 96, N'Bizimle çalışmaya başlayın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37033, N'tr-TR', 97, N'Yerel şubenizle iletişim kurun')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37034, N'tr-TR', 98, N'En iyi sözleşmeler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37035, N'tr-TR', 99, N'Buradan başlıyor')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37036, N'tr-TR', 100, N'Coğrafi konum')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37037, N'tr-TR', 101, N'Tüm temsilcileri görün')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37038, N'tr-TR', 102, N'Üyeliğinizden ne kazanıyorsunuz')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37039, N'tr-TR', 103, N'Bir sonraki ağ toplantısına katılın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37040, N'tr-TR', 104, N'Parola')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37041, N'tr-TR', 105, N'Beni Hatırla?')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37042, N'tr-TR', 106, N'Parolanızı mı unuttunuz?')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37043, N'tr-TR', 107, N'Sosyal ağ hesap girişi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37044, N'tr-TR', 108, N'Email gereklidir')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37045, N'tr-TR', 109, N'Şifre gereklidir')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37046, N'tr-TR', 110, N'E-postanızı giriniz')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37047, N'tr-TR', 111, N'E-posta bağlantısı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37048, N'tr-TR', 112, N'Yeni bir hesap oluştur')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37049, N'tr-TR', 113, N'Kullanıcı adı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37050, N'tr-TR', 114, N'rol')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37051, N'tr-TR', 115, N'Şifreyi Onayla')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37052, N'tr-TR', 116, N'Rolünüzü seçin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37053, N'tr-TR', 117, N'şirket')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37054, N'tr-TR', 118, N'Müşteri')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37055, N'tr-TR', 119, N'Vasıflı işçi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37056, N'tr-TR', 120, N'Admin Paneli')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37057, N'tr-TR', 121, N'Tüm hakları Saklıdır')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37058, N'tr-TR', 122, N'Sosyal ağ hesabınızla giriş yapın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37059, N'tr-TR', 123, N'Sosyal giriş')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37060, N'tr-TR', 124, N'Hata')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37061, N'tr-TR', 125, N'İşleminiz gerçekleştirilirken bir hata oluştu')
GO
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37062, N'tr-TR', 126, N'Kilitlendi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37063, N'tr-TR', 127, N'Bu hesap kilitlendi, lütfen daha sonra tekrar deneyin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37064, N'tr-TR', 128, N'Yerel giriş oluştur')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37065, N'tr-TR', 129, N'Şifreyi belirle')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37066, N'tr-TR', 130, N'Şifre formunu değiştir')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37067, N'tr-TR', 131, N'Şifre değiştir')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37068, N'tr-TR', 132, N'Biçim')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37069, N'tr-TR', 133, N'Koruma')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37070, N'tr-TR', 134, N'tip')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37071, N'tr-TR', 135, N'İle kimlik doğrulaması başarıyla yapıldı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37072, N'tr-TR', 136, N'Bu site için yerel bir kullanıcı adınız / şifreniz yok. harici bir giriş yapmadan giriş yapabilmeniz için yerel bir hesap ekleyin.')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37073, N'tr-TR', 137, N'Lütfen aşağıya bu site için bir kullanıcı adı girin ve giriş yapmayı tamamlamak için kayıt düğmesine tıklayın.')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37074, N'tr-TR', 138, N'Hizmetle başarısız oturum açma')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37075, N'tr-TR', 139, N'Şifrenizi sıfırlamak için lütfen e-postanızı kontrol edin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37076, N'tr-TR', 140, N'Ülkenizi seçin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37077, N'tr-TR', 141, N'Sıfırla')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37078, N'tr-TR', 142, N'Şifrenizi sıfırlayın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37079, N'tr-TR', 143, N'Şifreniz sıfırlandı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37080, N'tr-TR', 144, N'Giriş yapmak için buraya tıklayın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37081, N'tr-TR', 145, N'Kayıt Tarihi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37082, N'tr-TR', 146, N'Roller')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37083, N'tr-TR', 147, N'Şifre onaylamayı unuttum')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37084, N'tr-TR', 148, N'İplik makinası')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37085, N'tr-TR', 149, N'Ürün Tanımı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37086, N'tr-TR', 150, N'Hizmetler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37087, N'tr-TR', 151, N'Hareketli görüntüler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37088, N'tr-TR', 152, N'Orijinal metin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37089, N'tr-TR', 153, N'Mesajlar')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37090, N'tr-TR', 154, N'Mesaj')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37091, N'tr-TR', 155, N'Parolaları değiştirme')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37092, N'tr-TR', 156, N'Dilleri yönetme')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37093, N'tr-TR', 157, N'Çıkış')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37094, N'tr-TR', 158, N'Excel dil dosyasını indirin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37095, N'tr-TR', 159, N'Excel dil dosyasını yükleyin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37096, N'tr-TR', 160, N'Tanıtım')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37097, N'tr-TR', 161, N'Nadine Trade')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37098, N'tr-TR', 162, N'daha fazla bilgi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37099, N'tr-TR', 163, N'Tamamlanan proje')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37100, N'tr-TR', 164, N'Yılların Deneyimi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37101, N'tr-TR', 165, N'Otantik ürün')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37102, N'tr-TR', 166, N'Dönüş')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37103, N'tr-TR', 167, N'İşleniyor .. Lütfen bekleyin ...')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37104, N'tr-TR', 168, N'Adı girin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37105, N'tr-TR', 169, N'Mesajın konusunu girin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37106, N'tr-TR', 170, N'Mesajı girin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37107, N'tr-TR', 171, N'E-postayı girin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37108, N'tr-TR', 172, N'Lütfen doğru e-posta adresini girin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37109, N'tr-TR', 173, N'Mesajı gönderildi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37110, N'tr-TR', 174, N'Bilgileri değiştirmek için satırı çift tıklayın veya satırdaki kurşun kalem işaretini tıklayın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37111, N'tr-TR', 175, N'Sen öyle mi hissettin?')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37112, N'tr-TR', 176, N'İran Ofisi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37113, N'tr-TR', 177, N'Tahran')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37114, N'tr-TR', 178, N'Türkiye Ofisi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37115, N'tr-TR', 179, N'İstanbul')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37116, N'tr-TR', 180, N'Mesaj başlığı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37117, N'tr-TR', 181, N'Mesaj gönder')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37118, N'tr-TR', 182, N'Ayrıntılar')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37119, N'tr-TR', 183, N'Lütfen bir dosya seçin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37120, N'tr-TR', 184, N'Dilleri yükleme')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37121, N'tr-TR', 185, N'Dosyayı seçin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37122, N'tr-TR', 186, N'Sarf Malzemelerinin Temini')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37123, N'tr-TR', 187, N'Tamirat')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37124, N'tr-TR', 188, N'Montaj')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37125, N'tr-TR', 189, N'Bloglar')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37126, N'tr-TR', 190, N'Kategoriler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37127, N'tr-TR', 191, N'Projeler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37128, N'tr-TR', 192, N'Blog')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37129, N'tr-TR', 193, N'Tekstil')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37130, N'tr-TR', 194, N'Tip 1 projeleri')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37131, N'tr-TR', 195, N'Tür İki Proje')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37132, N'tr-TR', 196, N'Tarım')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37133, N'tr-TR', 197, N'Hizmetler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37134, N'tr-TR', 198, N'Kurulum')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37135, N'tr-TR', 199, N'Tamirat')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37136, N'tr-TR', 200, N'Sarf Malzemelerinin Temini')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37137, N'tr-TR', 201, N'Araba parçaları')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37138, N'tr-TR', 202, N'Yedek')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37139, N'tr-TR', 203, N'Hastane ekipmanları')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37140, N'tr-TR', 204, N'Tekstüre makineleri')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37141, N'tr-TR', 205, N'Boyama makineleri')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37142, N'tr-TR', 206, N'İplik makineleri')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37143, N'tr-TR', 207, N'Örnek kumaş ürünleri')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37144, N'tr-TR', 208, N'Lüks')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37145, N'tr-TR', 209, N'Ürün hasat makineleri')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37146, N'tr-TR', 210, N'Gübre çeşitleri')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37147, N'tr-TR', 211, N'Modern yataklar')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37148, N'tr-TR', 212, N'Bilgisayar donanımı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37149, N'tr-TR', 213, N'Donanım')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37150, N'tr-TR', 214, N'yazılım')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37151, N'tr-TR', 215, N'Yeni ürünler yakında tanıtılacak')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37152, N'tr-TR', 216, N'Ad')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37153, N'tr-TR', 217, N'E-Posta')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37154, N'tr-TR', 218, N'Mevcut')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37155, N'tr-TR', 219, N'Mevcut değil')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37156, N'tr-TR', 220, N'Medya seçimi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37157, N'tr-TR', 221, N'Örgü makineleri')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37158, N'tr-TR', 222, N'Tanıtım Filmini İndir')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37159, N'tr-TR', 223, N'Film seçimi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37160, N'tr-TR', 224, N'Boyama')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37161, N'tr-TR', 225, N'Video oynatma sitesi bağlantısı')
GO
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37162, N'tr-TR', 226, N'Döndürme')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37163, N'tr-TR', 227, N'Baskı bandı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37164, N'tr-TR', 228, N'Parçalar ve Malzemeler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37165, N'tr-TR', 229, N'Yeni hizmetlere giriş')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37166, N'tr-TR', 230, N'Aktif')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37167, N'tr-TR', 231, N'Örnek Ürünler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37168, N'tr-TR', 232, N'Hizmet yönetimi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37169, N'tr-TR', 233, N'Ürün Yönetimi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37170, N'tr-TR', 234, N'Ürün adı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37171, N'tr-TR', 235, N'ziyaret')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37172, N'tr-TR', 236, N'Kategori')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37173, N'tr-TR', 237, N'Görüntü önceliği')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37174, N'tr-TR', 238, N'Tanım')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37175, N'tr-TR', 239, N'Resim')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37176, N'tr-TR', 240, N'Varsayılan ekran')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37177, N'tr-TR', 241, N'Mevcut')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37178, N'tr-TR', 242, N'Yeni ürün ekle')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37179, N'tr-TR', 243, N'Emin misin ?')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37180, N'tr-TR', 244, N'İptal etmek')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37181, N'tr-TR', 245, N'Dil')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37182, N'tr-TR', 246, N'Dil Seçin...')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37183, N'tr-TR', 247, N'Eklemek')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37184, N'tr-TR', 248, N'Değişim')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37185, N'tr-TR', 249, N'Sil')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37186, N'tr-TR', 250, N'Evet')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37187, N'tr-TR', 251, N'Hayır')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37188, N'tr-TR', 252, N'Orijinal başlık değiştirilemez. Lütfen sağ tıklayın ve Yeni Ekle''yi seçin.')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37189, N'tr-TR', 253, N'Ana sayfada görüntüle')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37190, N'tr-TR', 254, N'Excel dil dosyasını seçin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37191, N'tr-TR', 255, N'Yükle ve Kaydet')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37192, N'tr-TR', 256, N'Bir fotoğraf seçin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37193, N'tr-TR', 257, N'Özet metin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37194, N'tr-TR', 258, N'Tam metin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37195, N'tr-TR', 259, N'Seçilen filmi göster')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37196, N'tr-TR', 260, N'Üretilen özellikler, lütfen bekleyin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37197, N'tr-TR', 261, N'Ek Profil Yönetimi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37198, N'tr-TR', 262, N'Bir kategori seç')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37199, N'tr-TR', 263, N'Resim yüklenirken hata oluştu')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37200, N'tr-TR', 264, N'Ek detayları görmek için tıklayın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37201, N'tr-TR', 265, N'Profil yükleniyor, lütfen bekleyin')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37202, N'tr-TR', 266, N'Seçenek bulunamadı, lütfen başka bir anahtar kelime arayın')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37203, N'tr-TR', 267, N'Arama sonuçları')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37204, N'tr-TR', 268, N'Ürün Profili Yönetimi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37205, N'tr-TR', 269, N'Resim başlığı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37206, N'tr-TR', 270, N'Ekle')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37207, N'tr-TR', 271, N'Tüm')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37208, N'tr-TR', 272, N'Erkekler için')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37209, N'tr-TR', 273, N'Kadınsı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37210, N'tr-TR', 274, N'Giyim')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37211, N'tr-TR', 275, N'Aksesuar')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37212, N'tr-TR', 276, N'Giyim')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37213, N'tr-TR', 277, N'Kız gibi')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37214, N'tr-TR', 278, N'Çocuksu')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37215, N'tr-TR', 279, N'4 ila 14 yaş arası kızlar')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37216, N'tr-TR', 280, N'4-14 yaş arası erkekler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37217, N'tr-TR', 281, N'0-4 yaş arası kızlar')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37218, N'tr-TR', 282, N'0-4 yaş arası erkekler')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37219, N'tr-TR', 283, N'Gömlek')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37220, N'tr-TR', 284, N'Ayakkabı')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37221, N'tr-TR', 285, N'Elbise')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37222, N'tr-TR', 286, N'Gömlek')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (37223, N'tr-TR', 287, N'Pantolon')
SET IDENTITY_INSERT [dbo].[Dictionary] OFF
GO
SET IDENTITY_INSERT [dbo].[ExcelDictionary] ON 

INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (1, N'Home', N'خانه', N'Ev')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (2, N'Products', N'محصولات', N'Ürünler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (3, N'Site Management', N'مدیریت سایت', N'Site Yönetimi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (4, N'Home', N'صفحه اصلی', N'Ev')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (5, N'Services', N'خدمات', N'Hizmetler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (6, N'Partners', N'نمایندگی ها', N'Ortaklar')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (7, N'About us', N'درباره ما', N'Hakkımızda')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (8, N'Contact', N'تماس با ما', N'İletişim')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (9, N'Login', N'ورود به سیستم', N'Oturum aç')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (10, N'Register', N'عضویت', N'Kayıt ol')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (11, N'Search here', N'جستجو', N'Burada ara')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (12, N'Getting started', N'شروع به کار', N'Başlangıç')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (13, N'Language', N'زبان', N'Dil')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (14, N'Country', N'کشور', N'ülke')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (15, N'City', N'شهر', N'Kent')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (16, N'Postcode', N'کد پستی', N'posta kodu')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (17, N'Search by skills', N'تخصص', N'Becerilere göre ara')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (18, N'Let''s Work Together!', N'همکاری با هم', N'Beraber çalışalım!')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (19, N'Join free today', N'عضویت رایگان', N'Bugün ücretsiz katılın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (20, N'Rent workers - Rent out crews - Get or sell construction jobs in your local area or internationally', N'اجاره کردن نیروی کار, اجاره دادن نیروی کار, گرفتن یا واگذاری کارها در مناطق اطراف خود', N'İşçi kirala - Mürettebat kiralayın - Bölgenizdeki veya uluslararası inşaat işlerini alın veya satın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (21, N'Profiles, looking for jobs right now', N'پروفایلهای جستجو کننده  کار', N'Profiller, şu anda iş arıyor')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (22, N'Offering jobs right now', N'پیشنهادهای کاری', N'Şu anda iş teklifi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (23, N'International profiles and jobs', N'تمام جستجو کننده های کار و پیشنهادهای کاری', N'Uluslararası profiller ve işler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (24, N'See all profiles here', N'دیدن تمامی پروفایل ها', N'Tüm profilleri burada görün')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (25, N'See all jobs here', N'دیدن تمامی کارها', N'Buradaki tüm işleri görün')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (26, N'Profiles and jobs', N'پروفایل ها و کارها', N'Profiller ve işler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (27, N'Profiles', N'پروفایل ها', N'Profiller')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (28, N'Jobs', N'کارها', N'Meslekler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (29, N'Select country', N'انتخاب کشور', N'Ülke seçin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (30, N'Free', N'رایگان', N'Bedava')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (31, N'click', N'کلیک', N'Tıklayın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (32, N'Unlimited', N'نامحدود', N'Sınırsız')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (33, N'week', N'هفته', N'hafta')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (34, N'month', N'ماه', N'ay')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (35, N'Limited profile visit', N' تعداد مراجعات محدود', N'Sınırlı profil ziyareti')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (36, N'Unlimited profile visit', N'تعداد مراجعات نامحدود', N'Sınırsız profil ziyareti')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (37, N'Limited to living postcode', N'محدود به کد پستی', N'Yaşayan posta koduyla sınırlıdır')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (38, N'No limitation to postcode', N'بدون محدودیت کد پستی', N'Posta koduyla ilgili bir sınırlama yoktur')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (39, N'Limited to chosen postcode', N'محدود به کدپستی انتخاب شده', N'Seçilen posta koduyla sınırlıdır')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (40, N'Limited to chosen city', N'محدود به شهر انتخاب شده', N'Seçilen şehirle sınırlı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (41, N'Limited to chosen country', N'محدود به کشور انتخاب شده', N'Seçilen ülke ile sınırlıdır')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (42, N'Access to entire profiles', N'دسترسی به تمامی پروفایل ها', N'Tüm profillere erişim')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (43, N'Limited days', N'محدود به تعداد روز', N'Sınırlı günler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (44, N'No time limitation', N'بدون محدودیت زمانی', N'Zaman sınırlaması yok')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (45, N'No job list', N'بدون لیست کار', N'İş listesi yok')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (46, N'Receive job list', N'دریافت لیست کار', N'İş listesini al')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (47, N'No access to visited profiles', N'بدون دسترسی به پروفایل های بازدید شده', N'Ziyaret edilen profillere erişim yok')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (48, N'Access to visited profiles', N'دسترسی به پروفایل های بازدید شده', N'Ziyaret edilen profillere erişim')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (49, N'Buy Now', N'خرید کن', N'Şimdi satın al')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (50, N'Our services', N'خدمات اصلی ما', N'Hizmetlerimiz')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (51, N'Rent crew', N'اجاره نیروی کار', N'Mürettebat kirala')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (52, N'Get, buy & sell jobs', N'گرفتن خرید و فروش کار', N'İşleri alın, satın alın ve satın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (53, N'Networks & Events', N'ارتباطات و رویدادها', N'Ağlar ve Etkinlikler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (54, N'Buy & sell used equipments', N'خرید و فروش ابزارهای دست دوم', N'Kullanılmış ekipman alım satımı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (55, N'Buy & sell new equipments', N'خرید و فروش ابزار های نو', N'Yeni ekipman alım satımı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (56, N'Use', N'استفاده', N'kullanım')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (57, N'As you wish', N'همانطور که شما می‌خواهید', N'Nasıl istersen')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (58, N'Future digital access', N'دسترسی دیجیتالی در آینده', N'Gelecekteki dijital erişim')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (59, N'Read more about System', N'در مورد این محصول بیشتر بخوانید', N'Sistem hakkında devamını oku')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (60, N'Testimonial', N'رضایتمندی و توصیه', N'bonservis')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (61, N'Sign up now and be a part of a future', N' ثبت نام کنید و به آینده بپیوندید', N'Şimdi kaydolun ve geleceğin bir parçası olun')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (62, N'Sign me up', N'ثبت نام کنید', N'beni kaydet')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (63, N'Upcoming events', N'رویدادهای آینده', N'Yaklaşan Etkinlikler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (64, N'Get in touch', N'در تماس باشید', N'Temasta olmak')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (65, N'Address', N'آدرس', N'Adres')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (66, N'E-Mail', N'پست الکترونیکی', N'E-Posta')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (67, N'Phone', N'تلفن', N'Telefon')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (68, N'Who are we', N'ما که هستیم', N'Biz Kimiz')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (69, N'and where are we going', N'و کجا میرویم', N've nereye gidiyoruz')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (70, N'Welcome to the club', N'به باشگاه خوش آمدید', N'Kulübe hoşgeldin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (71, N'Join our next meeting', N'به گردهمایی بعدی ما بپیوندید', N'Bir sonraki toplantımıza katılın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (72, N'The best network of the year', N'بهترین شبکه ارتباطی سال', N'Yılın en iyi ağı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (73, N'See all genre', N'مشاهده تمامی روش ها', N'Tüm türü görün')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (74, N'Network', N'شبکه ارتباطی', N'Ağ')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (75, N'Contact us', N'تماس با ما', N'Bize Ulaşın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (76, N'Meet us here', N'اینجا ما را ملاقات کنید', N'Burada buluşalım')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (77, N'Network meetings', N'جلسه های ارتباطی', N'Ağ toplantıları')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (78, N'Saturday ', N'شنبه ', N'Cumartesi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (79, N'Sunday ', N'یکشنبه ', N'Pazar')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (80, N'Monday ', N'دوشنبه ', N'Pazartesi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (81, N'Tuesday', N'سه شنبه', N'Salı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (82, N'Wednesday', N'چهارشنبه', N'Çarşamba')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (83, N'Thursday', N'پنجشنبه', N'Perşembe')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (84, N'Friday', N'جمعه', N'Cuma')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (85, N'Sign up to System today', N'همین امروز در سیستم ما ثبت نام کنید', N'Bugün sisteme kaydolun')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (86, N'Name', N'اسم ', N'ad')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (87, N'Subject', N'موضوع', N'konu')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (88, N'Message', N'پیغام', N'İleti')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (89, N'Send', N'ارسال', N'Gönder')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (90, N'See all members', N'مشاهده همه اعضا', N'Tüm üyeleri görün')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (91, N'See all events', N'مشاهده همه رویدادها', N'Tüm etkinlikleri görün')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (92, N'See all jobs', N'مشاهده همه کارها', N'Tüm işleri görün')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (93, N'Webshop', N'فروشگاه اینترنتی', N'Sanal mağaza')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (94, N'A network', N'یک همکاری', N'Ağ')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (95, N'That supports you', N'که از شما پشتیبانی کند', N'Bu seni destekliyor')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (96, N'Start working with us', N'همکاری خود را شروع کنید', N'Bizimle çalışmaya başlayın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (97, N'Contact your local branch', N'تماس با شعبه محلی اتان', N'Yerel şubenizle iletişim kurun')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (98, N'The best contracts', N'بهترین قرارداد', N'En iyi sözleşmeler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (99, N'Starts here', N'از اینجا شروع کنید', N'Buradan başlıyor')
GO
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (100, N'Geographical location', N'موقعیت جغرافیایی', N'Coğrafi konum')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (101, N'See all representatives', N'مشاهده نمایندگی ها', N'Tüm temsilcileri görün')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (102, N'What do you gain from your membership', N'از عضویت در این سامانه چه بدست می آورید', N'Üyeliğinizden ne kazanıyorsunuz')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (103, N'Join the next network meeting', N'به جلسه ارتباطی بعدی ملحق شوید', N'Bir sonraki ağ toplantısına katılın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (104, N'Password', N'رمز عبور', N'Parola')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (105, N'Remember me?', N'مرا به خاطر بسپار', N'Beni Hatırla?')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (106, N'Forgot password?', N'فراموش کردن رمز عبور', N'Parolanızı mı unuttunuz?')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (107, N'Social network account log in', N'ورود با استفاده از شبکه اجتماعی', N'Sosyal ağ hesap girişi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (108, N'Email is required', N'آدرس الکترونیکی الزامی است', N'Email gereklidir')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (109, N'Password is required', N'رمز عبور اجباری است', N'Şifre gereklidir')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (110, N'Enter your email', N'آدرس الکترونیکی خود را وارد کنید', N'E-postanızı giriniz')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (111, N'Email link', N'لینک آدرس الکترونیکی', N'E-posta bağlantısı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (112, N'Create a new account', N'یک حساب کاربری جدید ایجاد کنید', N'Yeni bir hesap oluştur')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (113, N'User name', N'نام کاربری', N'Kullanıcı adı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (114, N'Role', N'نقش', N'rol')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (115, N'Confirm password', N'تایید رمز عبور', N'Şifreyi Onayla')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (116, N'Select your role', N'نقش خود را انتخاب کنید', N'Rolünüzü seçin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (117, N'Company', N'شرکت', N'şirket')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (118, N'Customer', N'مشتری', N'Müşteri')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (119, N'Skilled worker', N'نیروی کار ماهر', N'Vasıflı işçi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (120, N'Admin panel', N'پنل مدیریت', N'Admin Paneli')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (121, N'All rights reserved', N'همه حقوق محفوظ است', N'Tüm hakları Saklıdır')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (122, N'Login with your social network account', N'با حساب شبکه اجتماعی خود وارد شوید', N'Sosyal ağ hesabınızla giriş yapın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (123, N'Social login', N'ورود با شبکه اجتماعی', N'Sosyal giriş')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (124, N'Error', N'خطا', N'Hata')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (125, N'An error occurred while processing your request', N'یک خطا در هنگام بررسی درخواست شما رخ داد', N'İşleminiz gerçekleştirilirken bir hata oluştu')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (126, N'Locked out', N'قفل شده', N'Kilitlendi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (127, N'This account has been locked out, please try again later', N'این حساب کاربری قفل شده است، لطفا بعدا دوباره امتحان کنید', N'Bu hesap kilitlendi, lütfen daha sonra tekrar deneyin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (128, N'Create local login', N'ایجاد ورود کاربری محلی', N'Yerel giriş oluştur')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (129, N'Set password', N'تنظیم رمز عبور', N'Şifreyi belirle')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (130, N'Change password form', N'فرم تغییر رمز عبور', N'Şifre formunu değiştir')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (131, N'Change password', N'تغییر رمز عبور', N'Şifre değiştir')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (132, N'Format', N'قالب', N'Biçim')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (133, N'Protection', N'حفاظت', N'Koruma')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (134, N'Type', N'نوع', N'tip')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (135, N'You''ve successfully authenticated with', N'شما با موفقیت تهیه شده با استفاده از', N'İle kimlik doğrulaması başarıyla yapıldı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (136, N'You do not have a local username/password for this site. add a local account so you can log in without an external login.', N'شما نام کاربری و کلمه عبور محلی برای این سایت ندارید یک حساب محلی اضافه کنید تا بتوانید بدون حساب کاربری خارجی به سیستم وارد شوید', N'Bu site için yerel bir kullanıcı adınız / şifreniz yok. harici bir giriş yapmadan giriş yapabilmeniz için yerel bir hesap ekleyin.')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (137, N'Please enter a username for this site below and click the register button to finish logging in.', N'لطفاً نام کاربری خود را برای این وبسایت وارد کنید و سپس روی دکمه ثبت نام کلیک کنید تا عمل ورود به سیستم پایان یابد', N'Lütfen aşağıya bu site için bir kullanıcı adı girin ve giriş yapmayı tamamlamak için kayıt düğmesine tıklayın.')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (138, N'Unsuccessful login with service', N'ورود ناموفق با سرویس', N'Hizmetle başarısız oturum açma')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (139, N'Please check your email to reset your password', N'لطفآ آدرس الکترونیکی خود را جهت تغییر رمز عبور چک نمایید ', N'Şifrenizi sıfırlamak için lütfen e-postanızı kontrol edin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (140, N'Select your countries', N'کشور خود را انتخاب نمایید', N'Ülkenizi seçin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (141, N'Reset', N'تنظیم مجدد', N'Sıfırla')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (142, N'Reset your password', N'تنظیم مجدد رمز عبور', N'Şifrenizi sıfırlayın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (143, N'Your password has been reset', N'رمز عبور شما مجدداً تنظیم گردید', N'Şifreniz sıfırlandı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (144, N'Click here to log in', N'برای ورود اینجا کلیک نمایید', N'Giriş yapmak için buraya tıklayın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (145, N'Register date', N'تاریخ ثبت نام', N'Kayıt Tarihi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (146, N'Roles', N'نقش ها', N'Roller')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (147, N'Forgot password confirmation', N'تایید رمز عبور را فراموش کرده اید', N'Şifre onaylamayı unuttum')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (148, N'Spinning machine', N'دستگاه ریسندگی', N'İplik makinası')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (149, N'Product Definition', N'تعریف محصولات', N'Ürün Tanımı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (150, N'Services', N'خدمات', N'Hizmetler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (151, N'Moving pictures', N'تصاویر متحرک', N'Hareketli görüntüler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (152, N'Main text', N'متن اصلی', N'Orijinal metin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (153, N'Messages', N'پیام ها', N'Mesajlar')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (154, N'Message', N'پیام', N'Mesaj')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (155, N'Change passwords', N'تغییر کلمه عبور', N'Parolaları değiştirme')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (156, N'Managing languages', N'مدیریت زبانها', N'Dilleri yönetme')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (157, N'Exit', N'خروج', N'Çıkış')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (158, N'Download the Excel language file', N'دریافت فایل اکسل زبان ها', N'Excel dil dosyasını indirin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (159, N'Upload the Excel language file', N'بارگذاری فایل اکسل زبان ها', N'Excel dil dosyasını yükleyin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (160, N'Introducing', N'آشنایی با', N'Tanıtım')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (161, N'Nadine Trade', N'نادین ترِید', N'Nadine Trade')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (162, N'More information', N'اطلاعات بیشتر', N'daha fazla bilgi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (163, N'Completed project', N'پروژه انجام شده', N'Tamamlanan proje')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (164, N'Years of experience', N'سال تجربه', N'Yılların Deneyimi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (165, N'Authentic product', N'محصول معتبر', N'Otantik ürün')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (166, N'Return', N'برگشت', N'Dönüş')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (167, N'Processing, please wait ...', N'در حال پردازش، لطفا صبر کنید...', N'İşleniyor .. Lütfen bekleyin ...')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (168, N'Enter the name', N'نام را وارد نمایید', N'Adı girin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (169, N'Enter the subject of the message', N'عنوان پیام را وارد نمایید', N'Mesajın konusunu girin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (170, N'Enter the message', N'پیام را وارد نمایید', N'Mesajı girin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (171, N'Enter the email', N'ایمیل را وارد نمایید', N'E-postayı girin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (172, N'Please enter the correct email address', N'لطفا آدرس ایمیل صحیح را وارد نمایید', N'Lütfen doğru e-posta adresini girin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (173, N'Message sent', N'پیام ارسال شد', N'Mesajı gönderildi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (174, N'Double-click the row to change the information or click the pencil mark in the row', N'جهت تغییر اطلاعات بر روی سطر مورد نظر دو بار کلیک کنید یا بر روی علامت مداد در ردیف مورد نظر کلیک کنید', N'Bilgileri değiştirmek için satırı çift tıklayın veya satırdaki kurşun kalem işaretini tıklayın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (175, N'Did you feel that way?', N'آیا مطمعن هسید؟', N'Sen öyle mi hissettin?')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (176, N'Iran office', N'دفتر ایران', N'İran Ofisi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (177, N'Tehran', N'تهران', N'Tahran')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (178, N'Office in Turkey', N'دفتر ترکیه', N'Türkiye Ofisi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (179, N'Istanbul', N'استانبول', N'İstanbul')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (180, N'Message title', N'عنوان پیام', N'Mesaj başlığı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (181, N'Send Message', N'ارسال پیام', N'Mesaj gönder')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (182, N'Details', N'جزییات', N'Ayrıntılar')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (183, N'Please select a file', N'لطفا فایل را انتخاب کنید', N'Lütfen bir dosya seçin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (184, N'Loading languages', N'بارگذاری زبانها', N'Dilleri yükleme')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (185, N'Select the file', N'فایل را انتخاب کنید', N'Dosyayı seçin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (186, N'Supply of Consumables', N'تامین لوازم مصرفی', N'Sarf Malzemelerinin Temini')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (187, N'Repairs', N'تعمیرات', N'Tamirat')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (188, N'Installation', N'نصب و راه اندازی', N'Montaj')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (189, N'Blogs', N'بلاگ ها', N'Bloglar')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (190, N'Categories', N'دسته بندی ها', N'Kategoriler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (191, N'Projects', N'پروژه ها', N'Projeler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (192, N'Blog', N'بلاگ', N'Blog')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (193, N'Textile', N'نساجی', N'Tekstil')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (194, N'Type 1 projects', N'پروژه های نوع یک', N'Tip 1 projeleri')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (195, N'Type Two Projects', N'پروژه های نوع دو', N'Tür İki Proje')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (196, N'Agriculture', N'کشاورزی', N'Tarım')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (197, N'Services', N'خدمات', N'Hizmetler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (198, N'Installation', N'نصب و راه اندازی', N'Kurulum')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (199, N'Repairs', N'تعمیرات', N'Tamirat')
GO
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (200, N'Supply of Consumables', N'تامین لوازم مصرفی', N'Sarf Malzemelerinin Temini')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (201, N'Car Parts', N'قطعات اتوموبیل', N'Araba parçaları')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (202, N'Spare', N'یدکی', N'Yedek')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (203, N'Hospital equipment', N'تجهیزات بیمارستانی', N'Hastane ekipmanları')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (204, N'Texturing machines', N'دستگاه های تکسچرایزینگ', N'Tekstüre makineleri')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (205, N'Dyeing machines', N'دستگاه های رنگرزی', N'Boyama makineleri')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (206, N'Spinning machines', N'دستگاهای ریسندگی', N'İplik makineleri')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (207, N'Sample fabric products', N'محصولات پارچه ای نمونه', N'Örnek kumaş ürünleri')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (208, N'Luxury', N'لوکس', N'Lüks')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (209, N'Crop harvesting machines', N'ماشین آلات برداشت محصول', N'Ürün hasat makineleri')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (210, N'Types of fertilizers', N'انواع کود', N'Gübre çeşitleri')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (211, N'Modern beds', N'تخت های مدرن', N'Modern yataklar')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (212, N'Computer equipment', N'تجهیزات کام‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍یوتری', N'Bilgisayar donanımı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (213, N'Hardware', N'سخت افزار', N'Donanım')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (214, N'Software', N'نرم افزار', N'yazılım')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (215, N'New products will be introduced soon', N'محصولات جدید بزودی معرفی خواهند شد', N'Yeni ürünler yakında tanıtılacak')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (216, N'Name', N'نام', N'Ad')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (217, N'E-Mail', N'ایمیل', N'E-Posta')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (218, N'Available', N'موجود', N'Mevcut')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (219, N'Unavailable', N'نا موجود', N'Mevcut değil')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (220, N'Media selection', N'انتخاب رسانه', N'Medya seçimi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (221, N'Knitting machines', N'دستگاهای بافندگی', N'Örgü makineleri')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (222, N'Download Intro Movie', N'دانلود فیلم معرفی', N'Tanıtım Filmini İndir')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (223, N'Film selection', N'انتخاب فیلم', N'Film seçimi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (224, N'Dyeing', N'رنگرزی', N'Boyama')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (225, N'Video playback site link', N'لینک سایت پخش فیلم', N'Video oynatma sitesi bağlantısı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (226, N'Spinning', N'ریسندگی', N'Döndürme')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (227, N'Printing tape', N'چاپ نوار', N'Baskı bandı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (228, N'Parts & Supplies', N'قطعات و لوازم', N'Parçalar ve Malzemeler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (229, N'Introducing new services', N'معرفی خدمت جدید', N'Yeni hizmetlere giriş')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (230, N'Active', N'فعال', N'Aktif')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (231, N'Sample Products', N'محصولات نمونه', N'Örnek Ürünler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (232, N'Services management', N'مدیریت خدمات', N'Hizmet yönetimi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (233, N'Product Management', N'مدیریت محصولات', N'Ürün Yönetimi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (234, N'Product Name', N'نام محصول', N'Ürün adı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (235, N'Visit', N'دفعات مشاهده', N'ziyaret')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (236, N'Category', N'دسته بندی', N'Kategori')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (237, N'Image priority', N'اولویت نمایش', N'Görüntü önceliği')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (238, N'Definition', N'توضیحات', N'Tanım')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (239, N'Picture', N'تصویر', N'Resim')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (240, N'Default screen', N'نمایش پیش فرض', N'Varsayılan ekran')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (241, N'Available', N'موجود', N'Mevcut')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (242, N'Add new product', N'افزودن محصول جدید', N'Yeni ürün ekle')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (243, N'Are you sure ?', N'آیا مطمعن هستید؟', N'Emin misin ?')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (244, N'Cancel', N'انصراف', N'İptal etmek')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (245, N'Language', N'زبان', N'Dil')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (246, N'Select Language...', N'انتخاب زبان', N'Dil Seçin...')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (247, N'Add', N'افزودن', N'Eklemek')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (248, N'Change', N'تغییر', N'Değişim')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (249, N'Delete', N'حذف', N'Sil')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (250, N'Yes', N'بلی', N'Evet')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (251, N'No', N'خیر', N'Hayır')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (252, N'The original title cannot be changed. Please right-click and select Add New.', N'عنوان اصلی قابل تغییر نیست. لطفا کلیک راست کرده و گزینه افزودن جدید را انتخاب کنید.', N'Orijinal başlık değiştirilemez. Lütfen sağ tıklayın ve Yeni Ekle''yi seçin.')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (253, N'Display on homepage', N'نمایش در صفحه اصلی', N'Ana sayfada görüntüle')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (254, N'Select the Excel language file', N'فایل اکسل زبانها را انتخاب کنید', N'Excel dil dosyasını seçin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (255, N'Upload and Save', N'بارگذاری و ذخیره', N'Yükle ve Kaydet')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (256, N'Select a photo', N'انتخاب عکس', N'Bir fotoğraf seçin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (257, N'Summary text', N'متن خلاصه', N'Özet metin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (258, N'Full text', N'متن کامل', N'Tam metin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (259, N'Show selected movie', N'نمایش فیلم انتخاب شده', N'Seçilen filmi göster')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (260, N'Generating specifications, please wait', N'در حال تولید مشخصات، لطفا منتظر بمانید', N'Üretilen özellikler, lütfen bekleyin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (261, N'Additional Profile Management', N'مدیریت مشخصات تکمیلی', N'Ek Profil Yönetimi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (262, N'Select a category', N'دسته بندی را انتخاب کنید', N'Bir kategori seç')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (263, N'Resim yüklenirken hata oluştu', N'خطا در بارگذاری تصویر', N'Resim yüklenirken hata oluştu')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (264, N'Click to view additional details', N'جهت مشاهده مشخصات تکمیلی کلیک کنید', N'Ek detayları görmek için tıklayın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (265, N'Loading profile, please wait', N'در حال بارگذاری مشخصات، لطفا منتظر بمانید', N'Profil yükleniyor, lütfen bekleyin')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (266, N'The option was not found, please search for another keyword', N'گزینه مورد نظر یافت نشد، لطفا با کلمه کلیدی دیگری جستجو کنید', N'Seçenek bulunamadı, lütfen başka bir anahtar kelime arayın')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (267, N'search result', N'نتیجه جستجو', N'Arama sonuçları')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (268, N'Product Profile Management', N'مدیریت مشخصات محصولات', N'Ürün Profili Yönetimi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (269, N'Image caption', N'متن تصویر', N'Resim başlığı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (270, N'Save', N'ذخیره', N'Ekle')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (271, N'All', N'همه', N'Tüm')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (272, N'Men', N'مردانه', N'Erkekler için')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (273, N'Women', N'زنانه', N'Kadınsı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (274, N'Clothing', N'تن پوش', N'Giyim')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (275, N'Accessories', N'اکسسوری', N'Aksesuar')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (276, N'Clothing', N'تن پوش', N'Giyim')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (277, N'Girls', N'دخترانه', N'Kız gibi')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (278, N'Boys', N'پسرانه', N'Çocuksu')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (279, N'Girls From 4 to 14 years', N'دخترانه از 4 تا 14 سال', N'4 ila 14 yaş arası kızlar')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (280, N'Boys From 4 to 14 years', N'پسرانه از 4 تا 14 سال', N'4-14 yaş arası erkekler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (281, N'Girls From 0 to 4 years', N'دخترانه از 0 تا 4 سال', N'0-4 yaş arası kızlar')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (282, N'Boys From 0 to 4 years', N'پسرانه از 0 تا 4 سال', N'0-4 yaş arası erkekler')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (283, N'Shirts', N'پیراهن', N'Gömlek')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (284, N'Shoes', N'کفش', N'Ayakkabı')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (285, N'Dress', N'لباس', N'Elbise')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (286, N'Shirt', N'پیراهن', N'Gömlek')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [tr-TR]) VALUES (287, N'Trouser', N'شلوار', N'Pantolon')
SET IDENTITY_INSERT [dbo].[ExcelDictionary] OFF
GO
SET IDENTITY_INSERT [dbo].[FeatureType] ON 

INSERT [dbo].[FeatureType] ([Id], [CategoryId], [BaseFeatureTypeId], [Priority]) VALUES (24, 48, 1, 1)
INSERT [dbo].[FeatureType] ([Id], [CategoryId], [BaseFeatureTypeId], [Priority]) VALUES (25, 48, 2, 2)
INSERT [dbo].[FeatureType] ([Id], [CategoryId], [BaseFeatureTypeId], [Priority]) VALUES (26, 1, 2, 2)
INSERT [dbo].[FeatureType] ([Id], [CategoryId], [BaseFeatureTypeId], [Priority]) VALUES (27, 1, 1, 1)
INSERT [dbo].[FeatureType] ([Id], [CategoryId], [BaseFeatureTypeId], [Priority]) VALUES (28, 52, 1, 1)
INSERT [dbo].[FeatureType] ([Id], [CategoryId], [BaseFeatureTypeId], [Priority]) VALUES (29, 52, 2, 2)
INSERT [dbo].[FeatureType] ([Id], [CategoryId], [BaseFeatureTypeId], [Priority]) VALUES (30, 50, 1, 1)
INSERT [dbo].[FeatureType] ([Id], [CategoryId], [BaseFeatureTypeId], [Priority]) VALUES (31, 50, 2, 2)
SET IDENTITY_INSERT [dbo].[FeatureType] OFF
GO
SET IDENTITY_INSERT [dbo].[FeatureTypeDetail] ON 

INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (47, 24, 1, 1)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (48, 24, 2, 2)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (49, 25, 4, 1)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (50, 25, 5, 2)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (51, 26, 4, 1)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (52, 26, 5, 2)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (53, 27, 1, 1)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (54, 27, 2, 2)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (55, 28, 1, 1)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (56, 28, 2, 2)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (57, 29, 4, 1)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (58, 29, 5, 2)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (59, 30, 1, 1)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (60, 30, 2, 2)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (61, 31, 4, 1)
INSERT [dbo].[FeatureTypeDetail] ([Id], [FeatureTypeId], [BaseFeatureTypeDetailId], [Priority]) VALUES (62, 31, 5, 2)
SET IDENTITY_INSERT [dbo].[FeatureTypeDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[Image] ON 

INSERT [dbo].[Image] ([Id], [Title], [ImageUrl], [Priority], [LinkUrl], [ProductFeatureId]) VALUES (3173, N'', N'/Resources/Uploaded/Product/48/_c46f2bc7_1a0e_4323_adf7_4da1e6e58968_pid_green (1).png?w=960&h=726', 1, N'', N'c46f2bc7-1a0e-4323-adf7-4da1e6e58968')
INSERT [dbo].[Image] ([Id], [Title], [ImageUrl], [Priority], [LinkUrl], [ProductFeatureId]) VALUES (3174, N'', N'/Resources/Uploaded/Product/48/_11dcca88_c0bd_471e_99ed_ff17d81e5a32_pid_blue (2).png?w=800&h=600', 1, N'', N'11dcca88-c0bd-471e-99ed-ff17d81e5a32')
INSERT [dbo].[Image] ([Id], [Title], [ImageUrl], [Priority], [LinkUrl], [ProductFeatureId]) VALUES (3176, N'', N'/Resources/Uploaded/Product/48/_a978d013_8a11_4833_b6fb_9554123aec8a_pid_blue (1).png?w=960&h=726', 1, N'', N'a978d013-8a11-4833-b6fb-9554123aec8a')
INSERT [dbo].[Image] ([Id], [Title], [ImageUrl], [Priority], [LinkUrl], [ProductFeatureId]) VALUES (3177, N'', N'/Resources/Uploaded/Product/48/_d7201712_b2c3_46c8_a8da_bc3bba182b84_pid_green (2).png?w=800&h=600', 1, N'', N'd7201712-b2c3-46c8-a8da-bc3bba182b84')
INSERT [dbo].[Image] ([Id], [Title], [ImageUrl], [Priority], [LinkUrl], [ProductFeatureId]) VALUES (3182, N'', N'/Resources/Uploaded/Product/52/_d72d035d_aeb5_4d00_97f9_62f774990f35_pid_1 (1).jpg?w=2417&h=3021', 1, N'', N'd72d035d-aeb5-4d00-97f9-62f774990f35')
INSERT [dbo].[Image] ([Id], [Title], [ImageUrl], [Priority], [LinkUrl], [ProductFeatureId]) VALUES (3183, N'', N'/Resources/Uploaded/Product/52/_a1fc0b8b_e80e_4040_a1ca_85aa54b89c44_pid_5.jpg?w=5184&h=3456', 1, N'', N'a1fc0b8b-e80e-4040-a1ca-85aa54b89c44')
SET IDENTITY_INSERT [dbo].[Image] OFF
GO
SET IDENTITY_INSERT [dbo].[Invoice] ON 

INSERT [dbo].[Invoice] ([Id], [State], [TempCartId], [UserId], [Title], [Date], [TransactionNo], [Subtotal], [Tax], [Total], [AmountDue], [Finished]) VALUES (24, 0, N'00cbc8d2-c563-4d78-a43f-734d4233f715', N'71808cb5-011a-433c-befc-d26cfb9c5033', N'', CAST(N'2021-02-27T16:21:13.757' AS DateTime), N'', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[Invoice] ([Id], [State], [TempCartId], [UserId], [Title], [Date], [TransactionNo], [Subtotal], [Tax], [Total], [AmountDue], [Finished]) VALUES (25, 0, N'28c3183c-23be-4341-aaae-b6bcfd586613', N'71808cb5-011a-433c-befc-d26cfb9c5033', N'', CAST(N'2021-02-28T14:50:18.053' AS DateTime), N'12345', CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 1)
SET IDENTITY_INSERT [dbo].[Invoice] OFF
GO
SET IDENTITY_INSERT [dbo].[InvoiceStateHistory] ON 

INSERT [dbo].[InvoiceStateHistory] ([Id], [InvoiceId], [Date], [State]) VALUES (391, 24, CAST(N'2021-02-27T16:21:13.760' AS DateTime), 0)
INSERT [dbo].[InvoiceStateHistory] ([Id], [InvoiceId], [Date], [State]) VALUES (392, 24, CAST(N'2021-02-27T17:06:32.730' AS DateTime), 0)
INSERT [dbo].[InvoiceStateHistory] ([Id], [InvoiceId], [Date], [State]) VALUES (393, 25, CAST(N'2021-02-28T14:50:18.053' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[InvoiceStateHistory] OFF
GO
SET IDENTITY_INSERT [dbo].[Language] ON 

INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (175, N'South Africa', N'ZA', N'ZAF', N'Afrikaans', N'af', N'afr', N'af-ZA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (49, N'Ethiopia', N'ET', N'ETH', N'Amharic', N'am', N'amh', N'am-ET', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (200, N'U.A.E.', N'AE', N'ARE', N'Arabic', N'ar', N'ara', N'ar-AE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (9, N'Bahrain', N'BH', N'BHR', N'Arabic', N'ar', N'ara', N'ar-BH', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (4, N'Algeria', N'DZ', N'DZA', N'Arabic', N'ar', N'ara', N'ar-DZ', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (46, N'Egypt', N'EG', N'EGY', N'Arabic', N'ar', N'ara', N'ar-EG', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (90, N'Iraq', N'IQ', N'IRQ', N'Arabic', N'ar', N'ara', N'ar-IQ', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (98, N'Jordan', N'JO', N'JOR', N'Arabic', N'ar', N'ara', N'ar-JO', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (102, N'Kuwait', N'KW', N'KWT', N'Arabic', N'ar', N'ara', N'ar-KW', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (117, N'Lebanon', N'LB', N'LBN', N'Arabic', N'ar', N'ara', N'ar-LB', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (118, N'Libya', N'LY', N'LBY', N'Arabic', N'ar', N'ara', N'ar-LY', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (131, N'Morocco', N'MA', N'MAR', N'Arabic', N'ar', N'ara', N'ar-MA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (27, N'Chile', N'CL', N'CHL', N'Mapudungun', N'arn', N'arn', N'arn-CL', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (145, N'Oman', N'OM', N'OMN', N'Arabic', N'ar', N'ara', N'ar-OM', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (157, N'Qatar', N'QA', N'QAT', N'Arabic', N'ar', N'ara', N'ar-QA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (165, N'Saudi Arabia', N'SA', N'SAU', N'Arabic', N'ar', N'ara', N'ar-SA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (190, N'Syria', N'SY', N'SYR', N'Arabic', N'ar', N'ara', N'ar-SY', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (197, N'Tunisia', N'TN', N'TUN', N'Arabic', N'ar', N'ara', N'ar-TN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (209, N'Yemen', N'YE', N'YEM', N'Arabic', N'ar', N'ara', N'ar-YE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (83, N'India', N'IN', N'IND', N'Assamese', N'as', N'asm', N'as-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (32, N'Cyrillic, Azerbaijan', N'AZ', N'AZE', N'Azeri', N'az', N'aze', N'az-Cyrl-AZ', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (106, N'Latin, Azerbaijan', N'AZ', N'AZE', N'Azeri', N'az', N'aze', N'az-Latn-AZ', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (162, N'Russia', N'RU', N'RUS', N'Bashkir', N'ba', N'bak', N'ba-RU', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (12, N'Belarus', N'BY', N'BLR', N'Belarusian', N'be', N'bel', N'be-BY', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (21, N'Bulgaria', N'BG', N'BGR', N'Bulgarian', N'bg', N'bul', N'bg-BG', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (10, N'Bangladesh', N'BD', N'BGD', N'Bengali', N'bn', N'bng', N'bn-BD', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (75, N'India', N'IN', N'IND', N'Bengali', N'bn', N'bng', N'bn-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (153, N'PRC', N'CN', N'CHN', N'Tibetan', N'bo', N'bod', N'bo-CN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (58, N'France', N'FR', N'FRA', N'Breton', N'br', N'bre', N'br-FR', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (34, N'Cyrillic, Bosnia and Herzegovina', N'BA', N'BIH', N'Bosnian', N'bs', N'bsc', N'bs-Cyrl-BA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (108, N'Latin, Bosnia and Herzegovina', N'BA', N'BIH', N'Bosnian', N'bs', N'bsb', N'bs-Latn-BA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (26, N'Catalan', N'ES', N'ESP', N'Catalan', N'ca', N'cat', N'ca-ES', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (60, N'France', N'FR', N'FRA', N'Corsican', N'co', N'cos', N'co-FR', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (41, N'Czech Republic', N'CZ', N'CZE', N'Czech', N'cs', N'ces', N'cs-CZ', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (202, N'United Kingdom', N'GB', N'GBR', N'Welsh', N'cy', N'cym', N'cy-GB', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (42, N'Denmark', N'DK', N'DNK', N'Danish', N'da', N'dan', N'da-DK', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (8, N'Austria', N'AT', N'AUT', N'German', N'de', N'deu', N'de-AT', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (185, N'Switzerland', N'CH', N'CHE', N'German', N'de', N'deu', N'de-CH', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (64, N'Germany', N'DE', N'DEU', N'German', N'de', N'deu', N'de-DE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (119, N'Liechtenstein', N'LI', N'LIE', N'German', N'de', N'deu', N'de-LI', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (122, N'Luxembourg', N'LU', N'LUX', N'German', N'de', N'deu', N'de-LU', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (66, N'Germany', N'DE', N'DEU', N'Lower Sorbian', N'dsb', N'dsb', N'dsb-DE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (126, N'Maldives', N'MV', N'MDV', N'Divehi', N'dv', N'div', N'dv-MV', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (67, N'Greece', N'GR', N'GRC', N'Greek', N'el', N'ell', N'el-GR', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (25, N'Caribbean', NULL, NULL, N'English', N'en', N'eng', N'en-029', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (7, N'Australia', N'AU', N'AUS', N'English', N'en', N'eng', N'en-AU', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (15, N'Belize', N'BZ', N'BLZ', N'English', N'en', N'eng', N'en-BZ', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (24, N'Canada', N'CA', N'CAN', N'English', N'en', N'eng', N'en-CA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (204, N'United Kingdom', N'GB', N'GBR', N'English', N'en', N'eng', N'en-GB', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (92, N'Ireland', N'IE', N'IRL', N'English', N'en', N'eng', N'en-IE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (87, N'India', N'IN', N'IND', N'English', N'en', N'eng', N'en-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (96, N'Jamaica', N'JM', N'JAM', N'English', N'en', N'eng', N'en-JM', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (125, N'Malaysia', N'MY', N'MYS', N'English', N'en', N'eng', N'en-MY', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (136, N'New Zealand', N'NZ', N'NZL', N'English', N'en', N'eng', N'en-NZ', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (158, N'Republic of the Philippines', N'PH', N'PHL', N'English', N'en', N'eng', N'en-PH', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (169, N'Singapore', N'SG', N'SGP', N'English', N'en', N'eng', N'en-SG', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (196, N'Trinidad and Tobago', N'TT', N'TTO', N'English', N'en', N'eng', N'en-TT', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (205, N'United States', N'US', N'USA', N'English', N'en', N'eng', N'en-US', 0, 1)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (177, N'South Africa', N'ZA', N'ZAF', N'English', N'en', N'eng', N'en-ZA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (210, N'Zimbabwe', N'ZW', N'ZWE', N'English', N'en', N'eng', N'en-ZW', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (5, N'Argentina', N'AR', N'ARG', N'Spanish', N'es', N'spa', N'es-AR', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (18, N'Bolivia', N'BO', N'BOL', N'Spanish', N'es', N'spa', N'es-BO', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (28, N'Chile', N'CL', N'CHL', N'Spanish', N'es', N'spa', N'es-CL', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (29, N'Colombia', N'CO', N'COL', N'Spanish', N'es', N'spa', N'es-CO', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (30, N'Costa Rica', N'CR', N'CRI', N'Spanish', N'es', N'spa', N'es-CR', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (43, N'Dominican Republic', N'DO', N'DOM', N'Spanish', N'es', N'spa', N'es-DO', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (45, N'Ecuador', N'EC', N'ECU', N'Spanish', N'es', N'spa', N'es-EC', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (178, N'Spain, International Sort', N'ES', N'ESP', N'Spanish', N'es', N'spa', N'es-ES', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (70, N'Guatemala', N'GT', N'GTM', N'Spanish', N'es', N'spa', N'es-GT', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (71, N'Honduras', N'HN', N'HND', N'Spanish', N'es', N'spa', N'es-HN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (128, N'Mexico', N'MX', N'MEX', N'Spanish', N'es', N'spa', N'es-MX', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (137, N'Nicaragua', N'NI', N'NIC', N'Spanish', N'es', N'spa', N'es-NI', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (146, N'Panama', N'PA', N'PAN', N'Spanish', N'es', N'spa', N'es-PA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (149, N'Peru', N'PE', N'PER', N'Spanish', N'es', N'spa', N'es-PE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (156, N'Puerto Rico', N'PR', N'PRI', N'Spanish', N'es', N'spa', N'es-PR', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (147, N'Paraguay', N'PY', N'PRY', N'Spanish', N'es', N'spa', N'es-PY', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (47, N'El Salvador', N'SV', N'SLV', N'Spanish', N'es', N'spa', N'es-SV', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (206, N'United States', N'US', N'USA', N'Spanish', N'es', N'spa', N'es-US', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (207, N'Uruguay', N'UY', N'URY', N'Spanish', N'es', N'spa', N'es-UY', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (16, N'Bolivarian Republic of Venezuela', N'VE', N'VEN', N'Spanish', N'es', N'spa', N'es-VE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (48, N'Estonia', N'EE', N'EST', N'Estonian', N'et', N'est', N'et-EE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (11, N'Basque', N'ES', N'ESP', N'Basque', N'eu', N'eus', N'eu-ES', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (89, N'IRAN, ISLAMIC REPUBLIC OF', N'IR', N'IRN', N'پارسی', N'fa', N'fas', N'fa-IR', 0, 1)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (51, N'Finland', N'FI', N'FIN', N'Finnish', N'fi', N'fin', N'fi-FI', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (150, N'Philippines', N'PH', N'PHL', N'Filipino', N'fil', N'fil', N'fil-PH', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (50, N'Faroe Islands', N'FO', N'FRO', N'Faroese', N'fo', N'fao', N'fo-FO', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (13, N'Belgium', N'BE', N'BEL', N'French', N'fr', N'fra', N'fr-BE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (23, N'Canada', N'CA', N'CAN', N'French', N'fr', N'fra', N'fr-CA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (187, N'Switzerland', N'CH', N'CHE', N'French', N'fr', N'fra', N'fr-CH', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (57, N'France', N'FR', N'FRA', N'French', N'fr', N'fra', N'fr-FR', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (123, N'Luxembourg', N'LU', N'LUX', N'French', N'fr', N'fra', N'fr-LU', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (130, N'Monaco', N'MC', N'MCO', N'French', N'fr', N'fra', N'fr-MC', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (134, N'Netherlands', N'NL', N'NLD', N'Frisian', N'fy', N'fry', N'fy-NL', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (91, N'Ireland', N'IE', N'IRL', N'Irish', N'ga', N'gle', N'ga-IE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (203, N'United Kingdom', N'GB', N'GBR', N'Scottish Gaelic', N'gd', N'gla', N'gd-GB', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (62, N'Galician', N'ES', N'ESP', N'Galician', N'gl', N'glg', N'gl-ES', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (61, N'France', N'FR', N'FRA', N'Alsatian', N'gsw', N'gsw', N'gsw-FR', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (77, N'India', N'IN', N'IND', N'Gujarati', N'gu', N'guj', N'gu-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (112, N'Latin, Nigeria', N'NG', N'NGA', N'Hausa', N'ha', N'hau', N'ha-Latn-NG', 0, 0)
GO
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (94, N'Israel', N'IL', N'ISR', N'Hebrew', N'he', N'heb', N'he-IL', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (74, N'India', N'IN', N'IND', N'Hindi', N'hi', N'hin', N'hi-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (107, N'Latin, Bosnia and Herzegovina', N'BA', N'BIH', N'Croatian', N'hr', N'hrb', N'hr-BA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (31, N'Croatia', N'HR', N'HRV', N'Croatian', N'hr', N'hrv', N'hr-HR', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (65, N'Germany', N'DE', N'DEU', N'Upper Sorbian', N'hsb', N'hsb', N'hsb-DE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (72, N'Hungary', N'HU', N'HUN', N'Hungarian', N'hu', N'hun', N'hu-HU', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (6, N'Armenia', N'AM', N'ARM', N'Armenian', N'hy', N'hye', N'hy-AM', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (88, N'Indonesia', N'ID', N'IDN', N'Indonesian', N'id', N'ind', N'id-ID', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (139, N'Nigeria', N'NG', N'NGA', N'Igbo', N'ig', N'ibo', N'ig-NG', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (154, N'PRC', N'CN', N'CHN', N'Yi', N'ii', N'iii', N'ii-CN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (73, N'Iceland', N'IS', N'ISL', N'Icelandic', N'is', N'isl', N'is-IS', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (186, N'Switzerland', N'CH', N'CHE', N'Italian', N'it', N'ita', N'it-CH', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (95, N'Italy', N'IT', N'ITA', N'Italian', N'it', N'ita', N'it-IT', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (188, N'Syllabics, Canada', N'CA', N'CAN', N'Inuktitut', N'iu', N'iku', N'iu-Cans-CA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (110, N'Latin, Canada', N'CA', N'CAN', N'Inuktitut', N'iu', N'iku', N'iu-Latn-CA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (97, N'Japan', N'JP', N'JPN', N'Japanese', N'ja', N'jpn', N'ja-JP', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (63, N'Georgia', N'GE', N'GEO', N'Georgian', N'ka', N'kat', N'ka-GE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (99, N'Kazakhstan', N'KZ', N'KAZ', N'Kazakh', N'kk', N'kaz', N'kk-KZ', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (68, N'Greenland', N'GL', N'GRL', N'Greenlandic', N'kl', N'kal', N'kl-GL', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (22, N'Cambodia', N'KH', N'KHM', N'Khmer', N'km', N'khm', N'km-KH', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (81, N'India', N'IN', N'IND', N'Kannada', N'kn', N'kan', N'kn-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (86, N'India', N'IN', N'IND', N'Konkani', N'kok', N'kok', N'kok-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (101, N'Korea', N'KR', N'KOR', N'Korean', N'ko', N'kor', N'ko-KR', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (103, N'Kyrgyzstan', N'KG', N'KGZ', N'Kyrgyz', N'ky', N'kir', N'ky-KG', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (121, N'Luxembourg', N'LU', N'LUX', N'Luxembourgish', N'lb', N'ltz', N'lb-LU', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (104, N'Lao P.D.R.', N'LA', N'LAO', N'Lao', N'lo', N'lao', N'lo-LA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (120, N'Lithuania', N'LT', N'LTU', N'Lithuanian', N'lt', N'lit', N'lt-LT', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (116, N'Latvia', N'LV', N'LVA', N'Latvian', N'lv', N'lav', N'lv-LV', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (135, N'New Zealand', N'NZ', N'NZL', N'Maori', N'mi', N'mri', N'mi-NZ', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (56, N'Former Yugoslav Republic of Macedonia', N'MK', N'MKD', N'Macedonian', N'mk', N'mkd', N'mk-MK', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (82, N'India', N'IN', N'IND', N'Malayalam', N'ml', N'mym', N'ml-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (35, N'Cyrillic, Mongolia', N'MN', N'MNG', N'Mongolian', N'mn', N'mon', N'mn-MN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (192, N'Traditional Mongolian, PRC', N'CN', N'CHN', N'Mongolian', N'mn', N'mon', N'mn-Mong-CN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (129, N'Mohawk', N'CA', N'CAN', N'Mohawk', N'moh', N'moh', N'moh-CA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (84, N'India', N'IN', N'IND', N'Marathi', N'mr', N'mar', N'mr-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (20, N'Brunei Darussalam', N'BN', N'BRN', N'Malay', N'ms', N'msa', N'ms-BN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (124, N'Malaysia', N'MY', N'MYS', N'Malay', N'ms', N'msa', N'ms-MY', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (127, N'Malta', N'MT', N'MLT', N'Maltese', N'mt', N'mlt', N'mt-MT', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (140, N'Norway', N'NO', N'NOR', N'Norwegian, Bokmål', N'nb', N'nob', N'nb-NO', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (132, N'Nepal', N'NP', N'NPL', N'Nepali', N'ne', N'nep', N'ne-NP', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (14, N'Belgium', N'BE', N'BEL', N'Dutch', N'nl', N'nld', N'nl-BE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (133, N'Netherlands', N'NL', N'NLD', N'Dutch', N'nl', N'nld', N'nl-NL', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (142, N'Norway', N'NO', N'NOR', N'Norwegian, Nynorsk', N'nn', N'nno', N'nn-NO', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (176, N'South Africa', N'ZA', N'ZAF', N'Sesotho sa Leboa', N'nso', N'nso', N'nso-ZA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (59, N'France', N'FR', N'FRA', N'Occitan', N'oc', N'oci', N'oc-FR', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (78, N'India', N'IN', N'IND', N'Oriya', N'or', N'ori', N'or-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (76, N'India', N'IN', N'IND', N'Punjabi', N'pa', N'pan', N'pa-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (151, N'Poland', N'PL', N'POL', N'Polish', N'pl', N'pol', N'pl-PL', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (2, N'Afghanistan', N'AF', N'AFG', N'Dari', N'prs', N'prs', N'prs-AF', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (1, N'Afghanistan', N'AF', N'AFG', N'Pashto', N'ps', N'pus', N'ps-AF', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (19, N'Brazil', N'BR', N'BRA', N'Portuguese', N'pt', N'por', N'pt-BR', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (152, N'Portugal', N'PT', N'PRT', N'Portuguese', N'pt', N'por', N'pt-PT', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (69, N'Guatemala', N'GT', N'GTM', N'K''iche', N'qut', N'qut', N'qut-GT', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (17, N'Bolivia', N'BO', N'BOL', N'Quechua', N'quz', N'qub', N'quz-BO', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (44, N'Ecuador', N'EC', N'ECU', N'Quechua', N'quz', N'que', N'quz-EC', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (148, N'Peru', N'PE', N'PER', N'Quechua', N'quz', N'qup', N'quz-PE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (184, N'Switzerland', N'CH', N'CHE', N'Romansh', N'rm', N'roh', N'rm-CH', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (159, N'Romania', N'RO', N'ROU', N'Romanian', N'ro', N'ron', N'ro-RO', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (160, N'Russia', N'RU', N'RUS', N'Russian', N'ru', N'rus', N'ru-RU', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (164, N'Rwanda', N'RW', N'RWA', N'Kinyarwanda', N'rw', N'kin', N'rw-RW', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (163, N'Russia', N'RU', N'RUS', N'Yakut', N'sah', N'sah', N'sah-RU', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (85, N'India', N'IN', N'IND', N'Sanskrit', N'sa', N'san', N'sa-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (53, N'Finland', N'FI', N'FIN', N'Sami, Northern', N'se', N'smg', N'se-FI', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (141, N'Norway', N'NO', N'NOR', N'Sami, Northern', N'se', N'sme', N'se-NO', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (181, N'Sweden', N'SE', N'SWE', N'Sami, Northern', N'se', N'smf', N'se-SE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (179, N'Sri Lanka', N'LK', N'LKA', N'Sinhala', N'si', N'sin', N'si-LK', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (170, N'Slovakia', N'SK', N'SVK', N'Slovak', N'sk', N'slk', N'sk-SK', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (171, N'Slovenia', N'SI', N'SVN', N'Slovenian', N'sl', N'slv', N'sl-SI', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (144, N'Norway', N'NO', N'NOR', N'Sami, Southern', N'sma', N'sma', N'sma-NO', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (183, N'Sweden', N'SE', N'SWE', N'Sami, Southern', N'sma', N'smb', N'sma-SE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (143, N'Norway', N'NO', N'NOR', N'Sami, Lule', N'smj', N'smj', N'smj-NO', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (182, N'Sweden', N'SE', N'SWE', N'Sami, Lule', N'smj', N'smk', N'smj-SE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (55, N'Finland', N'FI', N'FIN', N'Sami, Inari', N'smn', N'smn', N'smn-FI', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (54, N'Finland', N'FI', N'FIN', N'Sami, Skolt', N'sms', N'sms', N'sms-FI', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (3, N'Albania', N'AL', N'ALB', N'Albanian', N'sq', N'sqi', N'sq-AL', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (33, N'Cyrillic, Bosnia and Herzegovina', N'BA', N'BIH', N'Serbian', N'sr', N'srn', N'sr-Cyrl-BA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (38, N'Cyrillic, Serbia and Montenegro (Former', N'CS', N'SCG', N'Serbian )', N'sr', N'srp', N'sr-Cyrl-CS', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (36, N'Cyrillic, Montenegro', N'ME', N'MNE', N'Serbian', N'sr', N'srp', N'sr-Cyrl-ME', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (37, N'Cyrillic, Serbia', N'RS', N'SRB', N'Serbian', N'sr', N'srp', N'sr-Cyrl-RS', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (109, N'Latin, Bosnia and Herzegovina', N'BA', N'BIH', N'Serbian', N'sr', N'srs', N'sr-Latn-BA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (114, N'Latin, Serbia and Montenegro (Former', N'CS', N'SCG', N'Serbian )', N'sr', N'srp', N'sr-Latn-CS', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (111, N'Latin, Montenegro', N'ME', N'MNE', N'Serbian', N'sr', N'srp', N'sr-Latn-ME', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (113, N'Latin, Serbia', N'RS', N'SRB', N'Serbian', N'sr', N'srp', N'sr-Latn-RS', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (52, N'Finland', N'FI', N'FIN', N'Swedish', N'sv', N'swe', N'sv-FI', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (180, N'Sweden', N'SE', N'SWE', N'Swedish', N'sv', N'swe', N'sv-SE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (100, N'Kenya', N'KE', N'KEN', N'Kiswahili', N'sw', N'swa', N'sw-KE', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (189, N'Syria', N'SY', N'SYR', N'Syriac', N'syr', N'syr', N'syr-SY', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (79, N'India', N'IN', N'IND', N'Tamil', N'ta', N'tam', N'ta-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (80, N'India', N'IN', N'IND', N'Telugu', N'te', N'tel', N'te-IN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (39, N'Cyrillic, Tajikistan', N'TJ', N'TAJ', N'Tajik', N'tg', N'tgk', N'tg-Cyrl-TJ', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (191, N'Thailand', N'TH', N'THA', N'Thai', N'th', N'tha', N'th-TH', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (199, N'Turkmenistan', N'TM', N'TKM', N'Turkmen', N'tk', N'tuk', N'tk-TM', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (172, N'South Africa', N'ZA', N'ZAF', N'Setswana', N'tn', N'tsn', N'tn-ZA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (198, N'Turkey', N'TR', N'TUR', N'Türkçe', N'tr', N'tur', N'tr-TR', 0, 1)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (161, N'Russia', N'RU', N'RUS', N'Tatar', N'tt', N'tat', N'tt-RU', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (105, N'Latin, Algeria', N'DZ', N'DZA', N'Tamazight', N'tzm', N'tzm', N'tzm-Latn-DZ', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (155, N'PRC', N'CN', N'CHN', N'Uyghur', N'ug', N'uig', N'ug-CN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (201, N'Ukraine', N'UA', N'UKR', N'Ukrainian', N'uk', N'ukr', N'uk-UA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (93, N'Islamic Republic of Pakistan', N'PK', N'PAK', N'Urdu', N'ur', N'urd', N'ur-PK', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (40, N'Cyrillic, Uzbekistan', N'UZ', N'UZB', N'Uzbek', N'uz', N'uzb', N'uz-Cyrl-UZ', 0, 0)
GO
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (115, N'Latin, Uzbekistan', N'UZ', N'UZB', N'Uzbek', N'uz', N'uzb', N'uz-Latn-UZ', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (208, N'Vietnam', N'VN', N'VNM', N'Vietnamese', N'vi', N'vie', N'vi-VN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (166, N'Senegal', N'SN', N'SEN', N'Wolof', N'wo', N'wol', N'wo-SN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (173, N'South Africa', N'ZA', N'ZAF', N'isiXhosa', N'xh', N'xho', N'xh-ZA', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (138, N'Nigeria', N'NG', N'NGA', N'Yoruba', N'yo', N'yor', N'yo-NG', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (167, N'Simplified, PRC', N'CN', N'CHN', N'Chinese', N'zh', N'zho', N'zh-CN', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (193, N'Traditional, Hong Kong S.A.R.', N'HK', N'HKG', N'Chinese', N'zh', N'zho', N'zh-HK', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (194, N'Traditional, Macao S.A.R.', N'MO', N'MAC', N'Chinese', N'zh', N'zho', N'zh-MO', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (168, N'Simplified, Singapore', N'SG', N'SGP', N'Chinese', N'zh', N'zho', N'zh-SG', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (195, N'Traditional, Taiwan', N'TW', N'TWN', N'Chinese', N'zh', N'zho', N'zh-TW', 0, 0)
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (174, N'South Africa', N'ZA', N'ZAF', N'isiZulu', N'zu', N'zul', N'zu-ZA', 0, 0)
SET IDENTITY_INSERT [dbo].[Language] OFF
GO
SET IDENTITY_INSERT [dbo].[Message] ON 

INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (237, NULL, N'2dc3a518-df1e-46b4-ab83-1eb9088d754f', N'4ed70a52-6181-4055-a16c-a01986a1987d', N'TEST', 179, N'', 1, NULL, CAST(N'2014-11-26T17:44:40.613' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (246, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'تست', 0, N'test 12', 1, NULL, CAST(N'2018-12-15T00:37:39.020' AS DateTime), N'a@yahoo.com')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (371, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p>Greetings!<br>I wanted to know whether or not I can participate in this conference as an audience member as I have no paper to submit as of now, but i would seriously like to attend this conference to increase my knowledge. if yes, so can you please guide me to the process of registering myself.<br>Regards,<br>Mamoona Asif Mir.</p>', 0, N'ICSLS-2019', 1, NULL, CAST(N'2019-04-13T12:38:03.067' AS DateTime), N'mir.mamoona@yahoo.com')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (372, NULL, N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'00000000-0000-0000-0000-000000000000', N'<p>Dear Mamoona,</p><p>Thank you for interesting to participate. please clarify which conference would you like to attend? all details are in conference pages. you can participate as an audience.</p><p><br></p><p>Kind regards,</p><p>Executive Editorial</p><p><br></p>', 0, NULL, 0, NULL, CAST(N'2019-04-13T23:18:19.060' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (373, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'As i am a student co-author participating from pakistan i need to know the payment datails for the submission of my conference fee.kindly enlighten me.', 0, N'Guidance needed', 1, NULL, CAST(N'2019-04-14T14:01:54.523' AS DateTime), N'std_19769@iobm.edu.pk')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (374, NULL, N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'00000000-0000-0000-0000-000000000000', N'<p>Dear Author,</p><p>Thank s for contacting. If you are willing to participate in ICMS you should pay 180 euro as an student who participates alone as presenter. other wise, you are going to participate with your supervisor or presenter of article, you will pay 120 euro.</p><p>Kind regards,</p><p>Executive editorial</p><p>&nbsp;</p>', 0, NULL, 0, NULL, CAST(N'2019-04-14T17:15:38.563' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (380, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p>To whom it may concern,</p><p>To whom it may concern,</p><p>I am writing regarding the PMBE Conference. I would like to ask you if I could still submit my abstracts for the conference to be held in Istanbul, Turkey.&nbsp;</p><p>I am terribly sorry if you are getting multiple copies of this e-mail.</p><p>Kindest Regards,</p><p>Mahmure Ovul Arioglu, PhD.</p><p><br></p><p><br></p>', 0, N'PMBEConference', 1, NULL, CAST(N'2019-04-15T08:58:25.287' AS DateTime), N'ovul@marmara.edu.tr')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (381, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p><span style="font-size: 23.66px;">How to pay 260 Euro and what is the account number.</span></p><p><span style="font-size: 23.66px;">Thank you</span></p><p><span style="font-size: 23.66px;"><br></span><br></p>', 0, N'How to pay 260 Euro and what is the account number', 1, NULL, CAST(N'2019-04-15T15:04:37.993' AS DateTime), N'PMBEConference@gmail.com')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (382, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p>Hello,</p><p>I''m unable to login on the portal. Is there any assistance?</p><p><br></p>', 0, N'Portal', 1, NULL, CAST(N'2019-04-16T09:10:53.580' AS DateTime), N'edwardowusu@minister.com')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (383, NULL, N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'00000000-0000-0000-0000-000000000000', N'<p>Dear Mahmure,</p><p>Please contact conference secretary through PMBEConference@gmail.com.&nbsp;</p><p>Regards,</p><p>Executive Editorial</p>', 0, NULL, 0, NULL, CAST(N'2019-04-16T22:57:07.780' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (384, NULL, N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'00000000-0000-0000-0000-000000000000', N'<p>Dear Edwardo,</p><p>There is any problem in portal. Please sign again or reset your password.&nbsp;</p><p>Your username is:&nbsp;&nbsp;eddyowusu</p><p><br></p><p>Kind regards,</p><p>Executive editorial,</p><p><br></p>', 0, NULL, 0, NULL, CAST(N'2019-04-16T23:05:53.530' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (385, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p>Is it possible to attend May 24th conference is it too late to register?&nbsp;<span style="font-size: 18px;">Thank you,&nbsp;</span><span style="font-size: 18px;">Katie Costa, EL specialist, Durham, NC, USA</span></p><p><br></p>', 0, N'late registration', 1, NULL, CAST(N'2019-04-17T09:01:48.523' AS DateTime), N'mkatiecosta@gmail.com')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (386, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p>My name is Piotr Masloch - I have one question: will be possible to send abstract while two days? I know, that is very late, but I woul like come for the conference.</p><p>Regards</p><p>Piotr Masloch<br></p><p><br></p>', 0, N'ICMS question', 1, NULL, CAST(N'2019-04-17T15:49:38.677' AS DateTime), N'p.masloch@akademia.mil.pl')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (387, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p>My name is Piotr Masloch - I have one question: will be possible to send abstract while two days? I know, that is very late, but I woul like come for the conference.</p><p>Regards</p><p>Piotr Masloch<br></p><p><br></p>', 0, N'ICMS question', 1, NULL, CAST(N'2019-04-17T15:50:11.333' AS DateTime), N'p.masloch@akademia.mil.pl')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (388, NULL, N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'00000000-0000-0000-0000-000000000000', N'<p>Dear Katie,</p><p>Please contact Conference Editorial Secretaries by pmbeconference@gmail.com</p><p><br></p><p>Executive Editorial</p><p><br></p>', 0, NULL, 0, NULL, CAST(N'2019-04-19T12:09:29.043' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (389, NULL, N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'00000000-0000-0000-0000-000000000000', N'<p>Dear Piotr,</p><p>Please contact Conference Editorial Secretaries by pmbeconference@gmail.com</p><p><br></p><p>Executive Editorial</p><p><br></p>', 0, NULL, 0, NULL, CAST(N'2019-04-19T12:11:35.237' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (390, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p class="MsoNormal" style="margin-bottom:8.0pt;line-height:12.0pt;text-autospace:
none"><span lang="SQ">Dear Mrs/Mr<o:p></o:p></span></p><p class="MsoNormal" style="margin-bottom:8.0pt;line-height:12.0pt;text-autospace:
none"><span lang="SQ" style="font-family:&quot;Segoe UI&quot;,&quot;sans-serif&quot;;mso-ansi-language:
SQ">I work in the Ministry of Economic Development in the finance department.
Our job, although mostly relates to the budget management of expenditure and
revenues, often requires additional skills for evaluating the general policy
and technical developments as well as specific projects/programs. As such, a
wider set of skills and knowledge is usually very useful for this
position.&nbsp;<o:p></o:p></span></p><p class="MsoNormal" style="margin-bottom:8.0pt;line-height:12.0pt;text-autospace:
none"><span lang="SQ" style="font-family:&quot;Segoe UI&quot;,&quot;sans-serif&quot;;mso-ansi-language:
SQ">It is these reasons that motivated me for attending the ICMS conference,
not to present any research paper but to listen and learn from the latest
research trends.&nbsp;&nbsp;My institution covers the expenses provided that I
have an invitation. So, I would be grateful if you can send me an invitation to
the event.&nbsp;<o:p></o:p></span></p><p class="MsoNormal" style="margin-bottom:8.0pt;line-height:12.0pt;text-autospace:
none"><span lang="SQ">Please direct it to:<o:p></o:p></span></p><p class="MsoNormal" style="margin-bottom:8.0pt;line-height:12.0pt;text-autospace:
none"><span lang="SQ" style="font-family:&quot;Segoe UI&quot;,&quot;sans-serif&quot;;mso-ansi-language:
SQ">&nbsp;Mimoza Berisha Karaqica</span><span lang="SQ"><o:p></o:p></span></p><p class="MsoNormal" style="margin-bottom:8.0pt;line-height:12.0pt;text-autospace:
none"><span lang="SQ">Ministry for Economic
Development<o:p></o:p></span></p><p class="MsoNormal" style="margin-bottom:8.0pt;line-height:12.0pt;text-autospace:
none"><span lang="SQ">Government of Republic of
Kosovo<o:p></o:p></span></p><p class="MsoNormal" style="margin-bottom:8.0pt;line-height:12.0pt;text-autospace:
none"><span lang="SQ" style="font-family:&quot;Segoe UI&quot;,&quot;sans-serif&quot;;mso-ansi-language:
SQ">Looking forward to hearing from you.&nbsp;<o:p></o:p></span></p><p>















</p><p class="MsoNormal" style="margin-bottom:8.0pt;line-height:12.0pt;text-autospace:
none"><span lang="SQ" style="font-family:&quot;Segoe UI&quot;,&quot;sans-serif&quot;;mso-ansi-language:
SQ">Thank you in advance.&nbsp;<o:p></o:p></span></p>', 0, N'attending the conference', 1, NULL, CAST(N'2019-04-19T13:05:24.397' AS DateTime), N'mimoza.berisha@rks-gov.net')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (391, NULL, N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'00000000-0000-0000-0000-000000000000', N'<p>Dear Mimoza,</p><p>Thanks for your message. kindly contact conference secretaries by pmbeconference@gmail.com.</p><p><br></p><p>Executive Editorial,</p><p>European Knowledge Development (WebShop)</p>', 0, NULL, 0, NULL, CAST(N'2019-04-19T19:57:47.073' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (393, NULL, N'c1ddec40-1061-4e44-b436-a2ff2394bff9', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p>Dear Organizer,</p><p>My paper has been accepted for presentation. However, I could not pay the registration fee as I cannot find the link to pay. I wonder if you could help. The deadline is over in less than 2 hours it seems.</p><p>Best, Esmaeel Abdollahzadeh</p>', 0, NULL, 1, NULL, CAST(N'2019-04-20T00:27:07.223' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (394, NULL, N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'c1ddec40-1061-4e44-b436-a2ff2394bff9', N'<p>Dear Esmaeel,</p><p>Thanks for contact. The account information is included in your acceptance letter.&nbsp;</p><p>Do not hesitate to contact if you have any inquiry.</p><p>Executive editorial,</p><p>WebShop Group</p><p>&nbsp;</p>', 0, NULL, 0, NULL, CAST(N'2019-04-20T20:30:57.500' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (396, NULL, N'06df82f9-5a96-4a0f-b91d-e35e8357c853', N'868579ce-0d73-4664-89e9-a9584a26e192', N'<p>1- * Hamideh Seifi Shojai&nbsp; &nbsp;</p><p><span style="font-family: &quot;Times New Roman&quot;, serif; font-size: 10pt;">*</span>Email: H.S.Shojaei@gmail.com</p><p><span style="font-family: &quot;Times New Roman&quot;, serif; font-size: 13.3333px;">*</span><b><i><span style="font-size: 12px; line-height: 115%; font-family: Calibri, sans-serif;">Young Researchers and Elite Club, Tabriz Branch,
Islamic Azad University, Tabriz, Iran</span></i></b></p><p><b><i><span style="font-size: 12px; line-height: 115%; font-family: Calibri, sans-serif;"><br></span></i></b><br></p><p>2- Hossein Boudaghi Khajeh Noubar</p><p>Email: H_Budaghi@yahoo.com</p><p><b><i><span style="font-size:8.0pt;line-height:115%;
font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
Calibri;mso-fareast-theme-font:minor-latin;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;mso-ansi-language:EN-US;mso-fareast-language:
EN-US;mso-bidi-language:FA">Associate Prof., &nbsp;Faculty of Management, Islamic Azad
University, Tabriz, Iran.</span></i></b></p><p><b><i><span style="font-size:8.0pt;line-height:115%;
font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
Calibri;mso-fareast-theme-font:minor-latin;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;mso-ansi-language:EN-US;mso-fareast-language:
EN-US;mso-bidi-language:FA"><br></span></i></b></p><p>3- Arezoo Sadri<b><i><span style="font-size:8.0pt;line-height:115%;
font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
Calibri;mso-fareast-theme-font:minor-latin;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;mso-ansi-language:EN-US;mso-fareast-language:
EN-US;mso-bidi-language:FA"><br></span></i></b><br></p><u><span style="font-size:10.0pt;line-height:115%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;
mso-ascii-theme-font:major-bidi;mso-fareast-font-family:Calibri;mso-fareast-theme-font:
minor-latin;mso-hansi-theme-font:major-bidi;mso-bidi-theme-font:major-bidi;
mso-ansi-language:IT;mso-fareast-language:EN-US;mso-bidi-language:FA"></span></u>', 0, NULL, 1, NULL, CAST(N'2019-04-24T12:14:06.440' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (397, NULL, N'868579ce-0d73-4664-89e9-a9584a26e192', N'06df82f9-5a96-4a0f-b91d-e35e8357c853', N'<p>Dear Hamideh,</p><p>Kindly send your manuscript in word format.</p><p>Kind Regards,</p><p>Executive Editor</p>', 0, NULL, 1, NULL, CAST(N'2019-04-24T17:33:18.207' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (400, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p>Good morning !&nbsp;</p><p>I am a conference participant on May 24, Istanbul. How can I talk to somebody regarding the application fee to the conference?</p><p><br></p><p>Thank you.</p>', 0, N'Conference on Second Language Studies', 1, NULL, CAST(N'2019-04-29T12:11:35.010' AS DateTime), N'shaimakhanova@gmail.com')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (401, NULL, N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'00000000-0000-0000-0000-000000000000', N'<p>Dear Author,</p><p>You can contact conference secretaries through pmbeconference@gmail.com for ICMS and ICSLSconference@gmail.com for ICSLS conference.</p><p><br></p><p>Executive Editorial,</p><p>www.WebShop.com</p><p><br></p>', 0, NULL, 0, NULL, CAST(N'2019-04-30T00:01:22.273' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (402, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p><a href="/Resources/Uploaded/20190503011258RutvaShah_Abstract..docx?CT=application_vnd.openxmlformats_officedocument.wordprocessingml.document.png"></a><a href="/Resources/Uploaded/20190503011258RutvaShah_Abstract..docx?CT=application_vnd.openxmlformats_officedocument.wordprocessingml.document.png"></a><span style="font-size: 16px;">Respected Sir/Ma''am,</span></p><p><span style="font-size: 16px;">I''m a final year student of Bachelors of Business Administration (Honors) at School of Liberal Studies, Pandit Deendayal Petroleum University, India.</span></p><p><span style="font-size: 16px;">With a lot of hard work and dedication, I''ve done detailed research under the title ''Unorganized Retailers in India and their Appetite for advertisement in Organised way.'' The research gives an insight into the challenges faced by the unorganized retailers and their understanding of promotion and advertising and it''s effective use in their business venture.</span></p><p><span style="font-size: 16px;">After completing my research, I''ve landed on this conference page today, which is after the deadline of the Abstract Submission. But, keeping in mind the quality of the research done and the relevance of the topic with that of the objective of the conference, I request you to please accept my abstract for the ''5th International Conference on Management Studies'' to be held at Istanbul on May 24, 2019.</span></p><p><span style="font-size: 16px;">Herewith, I''ve attached a copy of my abstract for further reviewing. Anticipating a prompt and positive response.</span></p><p><span style="font-size: 16px;">-Regards,</span></p><p><span style="font-size: 16px;">Rutva Shah,</span></p><p><span style="font-size: 16px;"><br></span><span style="font-size: 16px;">+91 9574752888 , rutvakshah3@gmail.com</span></p><p><span style="font-size: 1.3em;"><br></span></p><p><span style="font-size: 1.3em;"><br></span></p><p class="MsoNormal"><span style="font-size:20.0pt;mso-bidi-font-size:15.0pt;
line-height:115%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;">Abstract:<o:p></o:p></span></p><p class="MsoNormal"><span style="font-size: 14pt; line-height: 115%; font-family: &quot;Times New Roman&quot;, serif; color: rgb(34, 34, 34); background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">After the financial reforms
of 1991, the Indian economy has observed a paradigm shift. The entry of global
players in the market, growing acceptance of the modern retail, deployment of
new and advanced technologies, and rising competition in the regional markets
have led to eloquent changes in the business dynamics. Amidst the kaleidoscopic
variations, the Indian retail Industry is inching its way towards becoming the
next burgeon platform with its immense potential as India has the second
largest population with the affluent middle class and rapid urbanization with
solid growth of the internet. India today is standing at a threshold of retail
revolution with the sector accounting for over 10% of the country’s GDP and
India being the world’s fifth largest global destination in retail space. It is
expected that the retail industry in India would grow to US$ 1,200 Billion by
2021 from US$ 672 Billion in 2017. The retail industry in India is majorly
classified under these two segments: (i) Organized retail &amp; (ii)
Unorganized retail, with these two contributing the highest to the employment
generation in a country with a population over 1.35 Billion.<o:p></o:p></span></p><p class="MsoNormal"><span style="font-size: 14pt; line-height: 115%; font-family: &quot;Times New Roman&quot;, serif; color: rgb(34, 34, 34); background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">The purpose of this
paper is to seek knowledge about the functionality of the retail sector,
especially the unorganized retailers and how they cope up with the tough
competition from the organized retailing as it is the sector generating largest
employment and entrepreneurship opportunities for the new workforce being added
continuously. This paper largely focuses on checking the appetite of the
unorganized retailers for advertisements and knowing their perspective about
marketing, advertising, and promotional strategies and the mediums adopted by
them and their effectiveness.<o:p></o:p></span></p><p class="MsoNormal"><span style="font-size: 14pt; line-height: 115%; font-family: &quot;Times New Roman&quot;, serif; color: rgb(34, 34, 34); background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">The unorganized
retail sector in India faces a lot of challenges like lack of technology,
limited storage space, low investment capacities and many more but at the same
time it is full of opportunities because of huge population spread all across
the nation catering the demand and sales needs of such ventures using effective
advertising strategies and mediums.<o:p></o:p></span></p><p>







<span style="font-size: 14pt; line-height: 115%; font-family: &quot;Times New Roman&quot;, serif; color: rgb(34, 34, 34); background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">Keywords: Indian Retail Industry, Organised Sector, Unorganized Sector,
Marketing and Advertising, Indian Economy.</span><span style="font-size: 1.3em;"><br></span></p>', 0, N'Submission of Abstract for the ICMS 2019.', 1, NULL, CAST(N'2019-05-03T01:16:19.587' AS DateTime), N'rutvakshah3@gmail.com')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (403, NULL, N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'00000000-0000-0000-0000-000000000000', N'<p>Dear Rutva,</p><p>Please end your abstract to PMBEConference@gmail.com in next 24 hours.</p><p>Kind regards</p><p>Executive Editorial</p>', 0, NULL, 0, NULL, CAST(N'2019-05-04T23:13:35.140' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (404, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p>Is the deadline still open for prposals for the conference?</p>', 0, N'conference', 1, NULL, CAST(N'2019-05-12T08:21:15.533' AS DateTime), N'mvanwells@yahoo.com')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (405, NULL, N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'00000000-0000-0000-0000-000000000000', N'<p>Dear Author,</p><p>The registration for oral presentation is closed. You can submit just for virtual presentation. The certificate is the same as oral presentation.</p><p>Regards,</p><p>Assistant editorial&nbsp;</p>', 0, NULL, 0, NULL, CAST(N'2019-05-16T17:04:30.310' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (406, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p>Hello Dear WebShop Team,</p><p>I am from Kazakhstan and I am EFL teacher at a secondary school for gifted and talented students. I completed my Master''s Degree at UCL Institute of Education. I am writing to know if it is possible to be published with you. If yes, what are the steps of being published. </p><p>Looking forward to hearing from you.</p><p>Kind regards,</p><p>Guldana Imankenova</p>', 0, N'Publish with You', 1, NULL, CAST(N'2019-05-18T11:43:19.427' AS DateTime), N'gimankenova@bk.ru')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (407, NULL, N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'00000000-0000-0000-0000-000000000000', N'<p>Dear Guldana,</p><p>Thanks for contac<span style="font-size: 1em;">t. Please send your message to&nbsp;</span><span style="font-family: &quot;Times New Roman&quot;, serif; font-size: 16px; text-align: justify; color: rgb(31, 73, 125);"><span style="font-weight: 700;">LTRQSUBMISSIONS@GMAIL.COM</span></span><span style="font-family: &quot;Times New Roman&quot;, serif; font-size: 16px; text-align: justify;">&nbsp;</span></p><p><span style="font-family: &quot;Times New Roman&quot;, serif; font-size: 16px; text-align: justify;">Regards,</span></p><p style="text-align: justify; "><font face="Times New Roman, serif"><span style="font-size: 16px;">WebShop Group</span></font></p>', 0, NULL, 0, NULL, CAST(N'2019-05-18T17:33:43.727' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (408, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p>Konferansa katılım sağlamak için geç mi kaldık?</p>', 0, N'Katılım', 1, NULL, CAST(N'2019-05-21T11:31:24.970' AS DateTime), N'guleremektup@gmail.com')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (409, NULL, N'06df82f9-5a96-4a0f-b91d-e35e8357c853', N'868579ce-0d73-4664-89e9-a9584a26e192', N'<p class="MsoNormal" align="center" style="text-align:center;line-height:150%"><b><span style="font-size:12.0pt;line-height:150%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;
mso-fareast-font-family:&quot;Times New Roman&quot;">Evaluation of the Barriers to Achieve
a Powerful Brand Using AHP Technique</span></b><b><span style="font-size:12.0pt;
line-height:150%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;mso-ascii-theme-font:
major-bidi;mso-hansi-theme-font:major-bidi;mso-bidi-theme-font:major-bidi"><o:p></o:p></span></b></p>', 0, NULL, 1, NULL, CAST(N'2019-05-30T13:07:34.727' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (410, NULL, N'06df82f9-5a96-4a0f-b91d-e35e8357c853', N'868579ce-0d73-4664-89e9-a9584a26e192', N'<p class="MsoNormal" align="center" style="text-align:center;line-height:150%"><b><span style="font-size:12.0pt;line-height:150%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;
mso-fareast-font-family:&quot;Times New Roman&quot;">Evaluation of the Barriers to Achieve
a Powerful Brand Using AHP Technique</span></b><b><span style="font-size:12.0pt;
line-height:150%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;mso-ascii-theme-font:
major-bidi;mso-hansi-theme-font:major-bidi;mso-bidi-theme-font:major-bidi"><o:p></o:p></span></b></p>', 0, NULL, 1, NULL, CAST(N'2019-05-30T13:09:11.323' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (412, NULL, N'868579ce-0d73-4664-89e9-a9584a26e192', N'06df82f9-5a96-4a0f-b91d-e35e8357c853', N'<p>Dear Shojai,</p><p>Kindly send your manuscript by registering in the WebShop author panel or send it through mbrqsubmissions@gmail.com or info@WebShop.com.</p><p>Kind regards,</p><p>Editor in Chief&nbsp;</p>', 0, NULL, 1, NULL, CAST(N'2019-06-01T17:17:18.867' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (413, NULL, N'868579ce-0d73-4664-89e9-a9584a26e192', N'06df82f9-5a96-4a0f-b91d-e35e8357c853', N'<p>Dear Shojai,</p><p>Kindly send your manuscript by registering in the WebShop author panel or send it through mbrqsubmissions@gmail.com or info@WebShop.com.</p><p>Kind regards,</p><p>Editor in Chief&nbsp;</p>', 0, NULL, 1, NULL, CAST(N'2019-06-01T17:17:29.103' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (414, NULL, N'868579ce-0d73-4664-89e9-a9584a26e192', N'06df82f9-5a96-4a0f-b91d-e35e8357c853', N'<p>Dear Shojai,</p><p>Kindly send your manuscript by registering in the WebShop author panel or send it through mbrqsubmissions@gmail.com or info@WebShop.com.</p><p>Kind regards,</p><p>Editor in Chief&nbsp;</p>', 0, NULL, 1, NULL, CAST(N'2019-06-01T17:19:14.087' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (423, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p>Dear&nbsp;</p><p>Plz let me know kindly the registeration fee. Thank you</p>', 0, N'Registration ', 1, NULL, CAST(N'2019-06-08T19:06:59.823' AS DateTime), N'naeini.j@gmail.com')
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (447, NULL, N'8b527e53-f9fb-4e9e-9194-9e2a2bd20bc5', N'868579ce-0d73-4664-89e9-a9584a26e192', N'wqerqwerqwer', 0, NULL, 1, NULL, CAST(N'2019-08-12T15:50:47.913' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (448, NULL, N'868579ce-0d73-4664-89e9-a9584a26e192', N'8b527e53-f9fb-4e9e-9194-9e2a2bd20bc5', N'<p>qwqwqwqw</p><p>qw</p><p>qw</p><p>qw</p><p>qw</p><p>qw</p><p><br></p>', 0, NULL, 0, NULL, CAST(N'2019-08-12T15:51:17.013' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [LanguageId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (453, NULL, N'00000000-0000-0000-0000-000000000000', N'70d732a9-3fb4-47b7-a5df-b737a3980158', N'<p>&nbsp;تستستت&nbsp;</p>', 0, N'تست', 1, NULL, CAST(N'2019-09-27T01:16:59.507' AS DateTime), N'pournaeim@gmail.com')
SET IDENTITY_INSERT [dbo].[Message] OFF
GO
SET IDENTITY_INSERT [dbo].[News] ON 

INSERT [dbo].[News] ([Id], [Title], [Body], [HtmlBody], [PictureName], [PictureType], [PictureContentUrl], [Priority], [Type]) VALUES (1, N'Start to publish online', N'<p><strong><span style="font-size: 10pt; font-family: ''Times New Roman'', serif;">WebShop Journals Start to Publish online</span></strong></p>
<div><strong><span style="font-size: 10pt; font-family: ''Times New Roman'', serif;"><br />
</span></strong></div>', N'<p><span style="font-size: 11pt; font-family: Arial;">&nbsp;WebShop decides to publish the journals online since 2018.</span></p>', N'1.png', N'image/png', N'/Resources/Uploaded/News/Images/201811142207271.png?CT=image_png.png', 1, 0)
INSERT [dbo].[News] ([Id], [Title], [Body], [HtmlBody], [PictureName], [PictureType], [PictureContentUrl], [Priority], [Type]) VALUES (2, N'​Call for Paper for MBRQ', NULL, N'<p>&nbsp;</p>
<div>&nbsp;</div>
<div>&nbsp;</div>', N'Admin_1.jpg', N'image/jpeg', N'/Resources/Uploaded/News/Images/20181114220727Admin_1.jpg?CT=image_jpeg.png', 2, 1)
INSERT [dbo].[News] ([Id], [Title], [Body], [HtmlBody], [PictureName], [PictureType], [PictureContentUrl], [Priority], [Type]) VALUES (3, N'Call for papers for Materials Development', NULL, N'<p>&nbsp;</p>

<h1 style="text-align: center;"><span style="color: #4f81bd;">Special Issue of Language Teaching Research Quarterly</span></h1>
            <h2 style="text-align: center;"><span style="color: windowtext;">Future Perspectives and Challenges of </span><span style="color: windowtext;">Materials Development</span></h2>
            <p style="text-align: center;"><span style="font-size: 16pt;">In Honor of Brian Tomlinson’s Contribution to Materials Development Research</span></p>
            <p style="text-align: center;"><span>Editors:</span></p>
            <p style="text-align: center;"><span>Christine Coombe</span></p>
            <p style="text-align: center;"><span>Hassan Mohebbi</span></p>
            <p style="text-align: center;">&nbsp;</p>
            <p style="text-align: center;"><span>Submission Deadline: August 2019</span></p>
            <p style="text-align: center;"><span>Publication: October 2019</span></p>
            <p style="text-align: center;"><a href="http://www.WebShop.com"><span>www.WebShop.com</span></a></p><p style="text-align: center;"><span>&nbsp;</span></p>
<p style="text-align: justify;">This special issue brings together cutting edge research and reviews focusing on future perspectives and challenges of Materials Development. Despite a great number of studies investigating Materials Development from different aspects, there are various unresolved issues which need further research. Research papers for this special issue may include any aspect of Materials Development and indeed any topic related to the issue<strong>. Submissions should be approximately 6500 words including references. Experimental research, theoretical seminal paper, critical review, and meta-analysis are welcomed investigating issues related to </strong>Materials Development<strong>.</strong></p>
<p style="text-align: justify;">&nbsp;</p>
<p style="text-align: justify;"><strong>Deadline for submission</strong></p>
<p style="text-align: justify;">This Call for Papers is open from now <strong>until August 1, 2019</strong>. All submissions will undergo rigorous peer review. The accepted papers will be published free of charge. The Special issue will be published in October 2019.</p>
<p style="text-align: justify;"><strong>Guest Editors</strong></p>
<p style="text-align: justify;">Christine Coombe, Dubai Men''s College</p>
<p style="text-align: justify;">Hassan Mohebbi, University of Tehran&nbsp;</p>
<p style="text-align: justify;"><strong>Submission Instructions</strong></p>
<p style="text-align: justify;">The complete manuscript should be email to the journal: LTRQSubmissions@gmail.com. Before submitting your manuscript, please ensure you have carefully read the <span class="underline">submission guidelines</span> for <em><span>Language Teaching Research Quarterly</span></em>. In addition, indicate within your cover letter that you wish your manuscript to be considered as part of the special issue on Materials Development. </p>
<p><span>&nbsp;</span></p>', N'', N'application/octet-stream', N'', 2, 1)
INSERT [dbo].[News] ([Id], [Title], [Body], [HtmlBody], [PictureName], [PictureType], [PictureContentUrl], [Priority], [Type]) VALUES (4, N'Challenges of WebShopk-based Language Teaching and Testing', NULL, N'<br><h1 style="text-align: center;"><span style="color: #1f497d;">Special Issue of Language Teaching Research Quarterly</span></h1>
            <h2 style="text-align: center;"><span style="color: windowtext;">Future Perspectives and Challenges of WebShopk-based Language Teaching and Testing</span></h2>
            <p style="text-align: center;"><span style="font-size: 16pt;">In Honor of Rod Ellis’s Contribution to TBLT Research</span></p>
            <p style="text-align: center;"><span>Editors:</span></p>
            <p style="text-align: center;"><span>Christine Coombe</span></p>
            <p style="text-align: center;"><span>Hassan Mohebbi</span></p>
            <p style="text-align: center;">&nbsp;</p>
            <p style="text-align: center;"><span>Submission Deadline: June 2019</span></p>
            <p style="text-align: center;"><span>Publication: September 2019</span></p>
            <p style="text-align: center;"><a href="http://www.WebShop.com"><span>www.WebShop.com</span></a></p>
            
        
    

<span></span><p style="text-align: center;"><span></span></p><p style="text-align: center;"><span>&nbsp;</span></p>
<p style="text-align: justify;">This special issue brings together cutting edge research and reviews highlighting the issues related to future perspectives and challenges of WebShopk-based Language Teaching and Testing. Despite a great number of studies investigating TBLT from different aspects, there are various unresolved issues which need further research. Research papers for this special issue may include any aspect of TBLT related to second language teaching, learning, and testing<strong>. Submissions should be approximately 6500 words including references. Experimental research, theoretical seminal paper, critical review, and meta-analysis are welcomed investigating issues related to TBLT.</strong></p>
<p style="text-align: justify;"><strong>Deadline for submission</strong></p>
<p style="text-align: justify;">This Call for Papers is open from now <strong>until March 1, 2019</strong>. All submissions will undergo rigorous peer review. The accepted papers will be published free of charge. The Special issue will be published in May 2019.</p>
<p style="text-align: justify;"><strong>Guest Editors</strong></p>
<p style="text-align: justify;">Christine Coombe, Dubai Men''s College</p>
<p style="text-align: justify;">Hassan Mohebbi, University of Tehran&nbsp;</p>
<p style="text-align: justify;"><strong>Submission Instructions</strong></p>
<p style="text-align: justify;">The complete manuscript should be email to the journal: LTRQSubmissions@gmail.com. Before submitting your manuscript, please ensure you have carefully read the <span class="underline">submission guidelines</span> for <em><span>Language Teaching Research Quarterly</span></em>. In addition, indicate within your cover letter that you wish your manuscript to be considered as part of the special issue on WebShopk-based Language Teaching and Testing. </p>
<p><span>&nbsp;</span></p>', NULL, NULL, N'', 3, 1)
INSERT [dbo].[News] ([Id], [Title], [Body], [HtmlBody], [PictureName], [PictureType], [PictureContentUrl], [Priority], [Type]) VALUES (5, N'Forthcoming special issue- Andrew Cohen-2020', N'<p><br></p><h1 align="center" style="font-family: Arial, Helvetica, sans-serif; color: rgb(0, 0, 0); text-align: center;"><br></h1>', N'<h1 align="center" style="text-align:center"><span style="mso-fareast-font-family:
&quot;Times New Roman&quot;;color:windowtext">Forthcoming Special Issue of Language
Teaching Research Quarterly (Publication: April, 2020)<o:p></o:p></span></h1>

<p class="MsoNormal" align="center" style="mso-margin-top-alt:auto;mso-margin-bottom-alt:
auto;text-align:center"><b><span style="font-size:14.0pt;line-height:115%;
font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;;
color:#C55A11">Pathways to the Successful Teaching and Learning of an L2 <o:p></o:p></span></b></p>

<p class="MsoNormal" align="center" style="mso-margin-top-alt:auto;mso-margin-bottom-alt:
auto;text-align:center"><b><span style="font-size:14.0pt;line-height:115%;
font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;;
color:#C00000">&nbsp;In Honor of Andrew
Cohen’s Contributions to L2 Teaching and Learning Research<o:p></o:p></span></b></p>

<p class="MsoNormal" align="center" style="mso-margin-top-alt:auto;mso-margin-bottom-alt:
auto;text-align:center;line-height:normal"><b><span style="font-size:10.0pt;
font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;;
color:#C55A11"><o:p>&nbsp;</o:p></span></b></p>

<p class="MsoNormal" align="center" style="mso-margin-top-alt:auto;mso-margin-bottom-alt:
auto;text-align:center;line-height:normal"><b><span style="font-size:10.0pt;
font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;">Editors:<o:p></o:p></span></b></p>

<p class="MsoNormal" align="center" style="mso-margin-top-alt:auto;mso-margin-bottom-alt:
auto;text-align:center;line-height:normal"><b><span style="font-size:10.0pt;
font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;">Christine
Coombe &amp; Hassan Mohebbi<o:p></o:p></span></b></p>

<p class="MsoNormal" style="mso-margin-top-alt:auto;mso-margin-bottom-alt:auto;
line-height:normal"><b><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;
mso-ascii-theme-font:major-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:major-bidi;mso-bidi-theme-font:major-bidi;color:#002060">Invited
Contributors:<span lang="AR-SA" dir="RTL"><o:p></o:p></span></span></b></p>

<p class="MsoListParagraphCxSpFirst" style="margin-bottom:0in;margin-bottom:.0001pt;
mso-add-space:auto;text-align:justify;text-justify:kashida;text-kashida:0%;
text-indent:-.25in;mso-list:l0 level1 lfo1"><!--[if !supportLists]--><span style="font-size:12.0pt;line-height:115%;font-family:Wingdings;mso-fareast-font-family:
Wingdings;mso-bidi-font-family:Wingdings">§<span style="font-variant-numeric: normal; font-variant-east-asian: normal; font-stretch: normal; font-size: 7pt; line-height: normal; font-family: &quot;Times New Roman&quot;;">&nbsp; </span></span><!--[endif]--><span dir="LTR"></span><b><span style="font-size:12.0pt;line-height:115%;font-family:
&quot;Times New Roman&quot;,&quot;serif&quot;;mso-ascii-theme-font:major-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:major-bidi;mso-bidi-theme-font:major-bidi">Encouraging
learners to become more informed consumers of L2 learning</span></b><span style="font-size:12.0pt;line-height:115%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;
mso-ascii-theme-font:major-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:major-bidi;mso-bidi-theme-font:major-bidi"> – Cynthia
White (Massey U., Palmerston North, NZ),<o:p></o:p></span></p>

<p class="MsoListParagraphCxSpMiddle" style="margin-bottom:0in;margin-bottom:
.0001pt;mso-add-space:auto;text-align:justify;text-justify:kashida;text-kashida:
0%"><span style="font-size:12.0pt;line-height:115%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;
mso-fareast-font-family:&quot;Times New Roman&quot;"><o:p>&nbsp;</o:p></span></p><p class="MsoListParagraphCxSpMiddle" style="margin-bottom:0in;margin-bottom:
.0001pt;mso-add-space:auto;text-align:justify;text-justify:kashida;text-kashida:
0%"><b style="font-size: 1em; text-align: left;"><span style="font-size:12.0pt;line-height:115%;font-family:
&quot;Times New Roman&quot;,&quot;serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;">Helping to
maximize learners’ motivation for L2 learning</span></b><span style="text-align: left; font-size: 12pt; line-height: 115%; font-family: &quot;Times New Roman&quot;, serif;"> – Kata Csizér Wein &amp;&nbsp;</span><span style="text-align: left; font-size: 12pt; line-height: 115%; font-family: &quot;Times New Roman&quot;, serif;"><span style="color: rgb(29, 34, 40); font-family: &quot;Times New Roman&quot;;">E</span>va Illés </span><span style="text-align: left; font-size: 12pt; line-height: 115%; font-family: &quot;Times New Roman&quot;, serif;">(</span><span style="font-size: 1em; text-align: left; line-height: 115%;"><span style="color: rgb(29, 34, 40); font-family: &quot;Times New Roman&quot;; font-size: 16px;">Eoetvoes</span><font face="Times New Roman, serif"><span style="font-size: 12pt;"><span style="font-size: 14px; font-family: &quot;Times New Roman&quot;;">&nbsp;</span>University, Budapest,
Hungary),</span></font></span></p>

<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;text-align:
justify;text-justify:kashida;text-kashida:0%"><span style="font-size:12.0pt;
line-height:115%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;mso-fareast-font-family:
&quot;Times New Roman&quot;"><o:p>&nbsp;</o:p></span></p>

<p class="MsoListParagraphCxSpFirst" style="margin-bottom:0in;margin-bottom:.0001pt;
mso-add-space:auto;text-align:justify;text-justify:kashida;text-kashida:0%;
text-indent:-.25in;mso-list:l0 level1 lfo1"><!--[if !supportLists]--><span style="font-size:12.0pt;line-height:115%;font-family:Wingdings;mso-fareast-font-family:
Wingdings;mso-bidi-font-family:Wingdings">§<span style="font-variant-numeric: normal; font-variant-east-asian: normal; font-stretch: normal; font-size: 7pt; line-height: normal; font-family: &quot;Times New Roman&quot;;">&nbsp; </span></span><!--[endif]--><span dir="LTR"></span><b><span style="font-size:12.0pt;line-height:115%;font-family:
&quot;Times New Roman&quot;,&quot;serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;">Assisting
learners in orchestrating their inner voice for L2 learning</span></b><span style="font-size:12.0pt;line-height:115%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;
mso-fareast-font-family:&quot;Times New Roman&quot;"> – Brian Tomlinson (Leeds
Metropolitan University, UK),<o:p></o:p></span></p>

<p class="MsoListParagraphCxSpMiddle" style="margin-bottom:0in;margin-bottom:
.0001pt;mso-add-space:auto;text-align:justify;text-justify:kashida;text-kashida:
0%"><span style="font-size:12.0pt;line-height:115%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;
mso-fareast-font-family:&quot;Times New Roman&quot;"><o:p>&nbsp;</o:p></span></p>

<p class="MsoListParagraphCxSpLast" style="margin-bottom:0in;margin-bottom:.0001pt;
mso-add-space:auto;text-align:justify;text-justify:kashida;text-kashida:0%;
text-indent:-.25in;mso-list:l0 level1 lfo1"><!--[if !supportLists]--><span style="font-size:12.0pt;line-height:115%;font-family:Wingdings;mso-fareast-font-family:
Wingdings;mso-bidi-font-family:Wingdings">§<span style="font-variant-numeric: normal; font-variant-east-asian: normal; font-stretch: normal; font-size: 7pt; line-height: normal; font-family: &quot;Times New Roman&quot;;">&nbsp; </span></span><!--[endif]--><span dir="LTR"></span><b><span style="font-size:12.0pt;line-height:115%;font-family:
&quot;Times New Roman&quot;,&quot;serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;">Promoting
advantageous ways for learners to focus on form</span></b><span style="font-size:12.0pt;line-height:115%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;
mso-fareast-font-family:&quot;Times New Roman&quot;"> – Bill VanPatten (Independent Scholar,
Chowchilla, CA, US),<o:p></o:p></span></p>

<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;text-align:
justify;text-justify:kashida;text-kashida:0%"><span style="font-size:12.0pt;
line-height:115%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;mso-fareast-font-family:
&quot;Times New Roman&quot;"><o:p>&nbsp;</o:p></span></p>

<p class="MsoListParagraph" style="margin-bottom:0in;margin-bottom:.0001pt;
mso-add-space:auto;text-align:justify;text-justify:kashida;text-kashida:0%;
text-indent:-.25in;mso-list:l0 level1 lfo1"><!--[if !supportLists]--><span style="font-size:12.0pt;line-height:115%;font-family:Wingdings;mso-fareast-font-family:
Wingdings;mso-bidi-font-family:Wingdings">§<span style="font-variant-numeric: normal; font-variant-east-asian: normal; font-stretch: normal; font-size: 7pt; line-height: normal; font-family: &quot;Times New Roman&quot;;">&nbsp; </span></span><!--[endif]--><span dir="LTR"></span><b><span style="font-size:12.0pt;line-height:115%;font-family:
&quot;Times New Roman&quot;,&quot;serif&quot;;mso-fareast-font-family:&quot;Times New Roman&quot;">Finding
ways to help L2 learners avoid attrition</span></b><span style="font-size:12.0pt;
line-height:115%;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;mso-fareast-font-family:
&quot;Times New Roman&quot;"> – Kathleen Bardovi-Harlig (Indiana University, US)<o:p></o:p></span></p>

<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal"><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;
mso-fareast-font-family:&quot;Times New Roman&quot;">&nbsp;<o:p></o:p></span></p>

<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal"><span style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,&quot;serif&quot;;
mso-fareast-font-family:&quot;Times New Roman&quot;"><o:p>&nbsp;</o:p></span></p>', NULL, NULL, NULL, 1, 1)
SET IDENTITY_INSERT [dbo].[News] OFF
GO
SET IDENTITY_INSERT [dbo].[Order] ON 

INSERT [dbo].[Order] ([Id], [InvoiceId], [ProductFeatureId], [Date], [State], [Price], [Quantity], [RecipientTypeId], [OccasionId]) VALUES (161, 24, N'c46f2bc7-1a0e-4323-adf7-4da1e6e58968', CAST(N'2021-02-27T17:28:38.213' AS DateTime), 0, CAST(2.00 AS Decimal(18, 2)), 1, NULL, NULL)
INSERT [dbo].[Order] ([Id], [InvoiceId], [ProductFeatureId], [Date], [State], [Price], [Quantity], [RecipientTypeId], [OccasionId]) VALUES (164, 25, N'a978d013-8a11-4833-b6fb-9554123aec8a', CAST(N'2021-02-28T14:50:18.427' AS DateTime), 0, CAST(1.00 AS Decimal(18, 2)), 1, NULL, NULL)
INSERT [dbo].[Order] ([Id], [InvoiceId], [ProductFeatureId], [Date], [State], [Price], [Quantity], [RecipientTypeId], [OccasionId]) VALUES (165, 25, N'c46f2bc7-1a0e-4323-adf7-4da1e6e58968', CAST(N'2021-02-28T14:50:21.580' AS DateTime), 0, CAST(2.00 AS Decimal(18, 2)), 1, NULL, NULL)
INSERT [dbo].[Order] ([Id], [InvoiceId], [ProductFeatureId], [Date], [State], [Price], [Quantity], [RecipientTypeId], [OccasionId]) VALUES (166, 25, N'11dcca88-c0bd-471e-99ed-ff17d81e5a32', CAST(N'2021-02-28T14:50:27.470' AS DateTime), 0, CAST(22.00 AS Decimal(18, 2)), 1, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Order] OFF
GO
SET IDENTITY_INSERT [dbo].[PageContent] ON 

INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (1, N'<p>&nbsp;ایوان دیزاین متشکل از تیمی از مهندسین معمار با سالها تجربه موفق بین المللی درمدیریت، طراحی و اجرای پروژه های بسیار لوکس داخل و خارج از کشور میباشد. پروژه های ما درایران، امارات متحده عربی و جمهوری آذربایجان با کاربری های گوناگونی شامل مراکز خرید، هتلهای 4 و 5 ستاره، رستورانهای 5 ستاره، مجتمع های مسکونی لاکچری و ویلاهای شخصی جزو پروژه های بسیار خاص و موفق میباشند...<br></p>', NULL, 1, 89)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (2, N'<p><img style="width: 378px;" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAXoAAACFCAMAAABizcPaAAAAllBMVEWqsqsAAAD///+Yn5mut69kaWWtta6xubJ6enqtra0sLCzt7e2EhIRoaGiTmpTFxcX4+PjNzc2fpqBeXl6mpqbm5uakrKWYmJhYWFihoaG7u7ttbW1+fn7g4OA5OTlAQ0AwMjCHjohzeXQiIiIQEBBrcGyRkZG+vr7U1NRTU1MVFhVKSko7PjshISFFSEVYXFmJkIp+hH+QuCXKAAAOS0lEQVR4nO1dCVvyOBCmUBoV5RKK4odyiyfw///c9pxMkkkPNImuvM8+u/tQhOnLdDJXJo1mhNHL2jvDGtYvo5j1RrM5cC3KX8Qgpv7MvBMMIurj/7YPrTOs4dCOOW82RtG/uyw4wyJYNyJ91HiJdJ41zrAKFun9SyPybbqBa1H+GoJI7deNSPVbZ+otI2hFtJ+pd4E/SH26yrmW4o9RH/iMBWGrG6E1bPjM913e9JepjzXIT/75CZpUgICFi/bTK49n1vP9suWQ/S9QH8RKFLYOi+MywnFxaIXMsSJpEbDhZk4GlPuD7zuS6UTqAxZ0l3vlbh4jRYouGRL2VPhs8VgQzrdDJzHNSdRHOrR80t/K03L4k9gP2PFVL2yq+kMH5NenPmCN5VXJrXjzZeOnsM+6qzJpY823v1LVpT5grZcKdxLhpfUTyA+CfTVxvYNtxa9JPesWGBoZ713n5Pstqf4zf5hcPvd6ven99Z0k7t6y4teing0/qxMf49OFDcUCL7E0V9tdU0BneiNcD61yX4P6gLXrER/DgQ3lEAS+mDUpXOJ1y2pcWZ161vqoz3wUuHSdKT5Dq9J1nyQ+Rg+R37Xo41emnm1oah8friejCJPrhye6ru6qEsC4dXwba4lPNJ8Le7DHfUXqgwaxvL5NBh3xHvq7+1v1fXO7NjQD467NqJD4WO43rvfWZK1GfTBUgpKbZ919DC4U8lv2Y3X0lCpGfrZTzM8W3j20xX0l6v2uROXrSG86Y0zluH1h3WlewDMni3ofv3orvzqFe7MmYgXq/YNE/LSQ91T1JfKXdrkPhvkXv8uS5c+kzD30wzxZErUC9f5CZLHUcqboiYuuXe5Z7rU8KmLlAt0p2gKi2jGP5dRLOn9TbGowtsIf2uQeDP1KEYq7AR35EvwqQytCllIfiHa+gq3hmAmRwNEa99zcKPQ2eS5toFy7t2pyyqjndxHjSr2VYgiB+sGW78CetOw2efy004trRdJSrccW+7Ym8UiR0gfZDvfwoG4Jgf6BNJS42d2ubKh9CfXsHTH3rz7zzeYz+gBLfhvLimdXlDzjXBjqd4GldmFBSYqpF/JP16cwL7aPf1rRplzpCYvSBAf+hZY2MzlzC4IWUi8ssScy32zu0IfY8NvYW7F5nEX0zi81FzuZoBZymMXUf9XapMB6b8PcZ19VnDLTIYu49uZ1pIh6lIDybk5nHgXpUYhj/En2l8VKX4J8LTBvcQqox+ZGCQrrAQVXR9Nqn3sGhGOp5PWuiCcjM1fmM5gF1DNUya8ewtJARQvjt5R+zVoVAqXlgXvtuzYOqQ+OXEJCg+qhzz9rY9aKBlneg/AKrlXqCec+E/XduMXRU+/zYOpk54ajx+/W8A1ttNpSjfrmo6WnU0t9wIv5r19nvtl8gI9rG1X7vCxIiFCR+uxtxnNoWuoZV3o6NKkJZHKM6hNLU3aUX1CR+swfMx7Q6qhHlv5LfiUHz+aYjavS77g4nfpZJqUr6hmvMtXNVuoAH3hlcgXLMq33p1OfPZ9m7WJDSz3KFVP6cxJG8JEGo/Q8GKHqChWpz3TEeDyrod7n9fzvUnqk9gYVKqeecoerUp92X7yZ9i411DOoL9Hx+Hg32OlyJJ3ZYDCjfjC49Q9zd5W79V+hPr1341lWmnpkb9R76EzydeDqWnF+eAPprZIcnMGHmkui5U0glFdWlfq0kGW8SqihfqmVrf8giP4o3ONIuKZUI6A4Z857+PVaD8VNJZCdKsLzZbivbFhai41fk/x1c7eV2/reF6hPI5pPN8ssA9GkB3dCSP+WXRsT10Tt4xbHHPWt9At+q4eTy6+Idk8InzcTdchrYsMjvGouSg/TL5icTr1Tv56HsqJ/o5sVldynZnukkLyFNdhclJ5V1h4ITv8R4hFvcxrN+lANF4NCntZ5u9zNerzyMBZW2G1vtuPPBw7J4FVz2fCsyjAnON0993pI81eDXo9ql86WM+O9OCT1fFOAYKo5u5klzaz7Kr4BuJbrW9Zhd409fHhszBnSXHZNcQeVS8hekabjzCUPqITICJQePPaY+7TvGG6JN1nEFkjaRwPrgblCRJ6vp1ycatRnXTzG6+K0wQHxsEjQ1IESspP8Z4AKIP+xxsQGpvxdr8a9S00HRTn1mXqY77skqQ9z6YRGXXAsUZgK3ObXcOs08czD5hSDqQRCa+pQ77Y2G1JE8vZoInkDHntJ8z24QebuKDf2tMUppz5raDDfA0VRz916oUoCGkvIC0FuSQEddmiH5u4o84zfSAFKqc+UaO2mD4c34Ai5+vxFqlQLzg+9LxgAjr1B/yG3OGRds5T6LEVlPKAqo15Yq4pEhnWgJLsPuTeD1Pv7ArUvoz7PhlhoUPwfUg8ZbypeKqM+s4g29pV8k8GBMLWkx9SGweERYX3q890ANraVFC+zQiYEZCZEhmW2pHEEvCST1IPaE70UxdTnHSs22utp5xJqVEL2DKImQrMh3NL1rWeAOoDRm4IWaVWaYurz/fpWdusX+/VCEgoyT/iGZqK6CD9WRzX8kKEwrFbah7CQ+jy1+eJuByHf0oAFg7bJJ/Si95ouZjD7D9F94W3lgDZ/l2G3mWe95Se0iHrwFYzKxoUk02cQPQnUgdC8BBTnjR8HWGyu9okREksWkD4zbUwZkVMqox5cBRt72Bo66sEkCw8sLzUMxFfeZqhGlTukufnHKX9YEsw3uYBpE/VeTz1sv9i7nJHgw04eYZ1CJcDb59l4N4KHo4N3bLze78bjHriRW+rGzVffNO0sqKIjbn6AiMP8lqNcRJJ6MJVinY0qiseIDVBfc01YqeH3Mb6tB29Hws9dv8OBtQryetZmsmiWWS62+FDyYUkYaeClKdwKthasgIW9kWigyV3ZfiTe4rK2N7FK0wIFokjpMKr2faPIjyD8PbdYNsaeMLQjqTCXPeY7vdbWZkBp+3Bgf77cVCHMm0jAm6R6yrUPzRpnfqNSchcLJIl2pEkH7Sv8sDmlTaP10GisOL+Sbq/wItaXfhi5dQ20y3wJKIEwOGw9oVJ7PTwm773hfs4l6oFSE/BTLu2tXAoab8HrWU1kC8tXYltj9YJQGCX9PhlgmcZTsX/U8lRIXZM3dB+Q5eVZ73J02aPLIp3B9PJyKo9hjMF7c6wNAFSnSX+8XFxvt9vrG2XZsj1PWre1gY8E+epuZQ54ICwMIACwQ7UDRV+sGpsYug093OKQc2NOAZ+MY20cVHIrQYVRzCsH43+129j4WRjfpfbQXW+h5CzeS1gyw351dDHtvcLmzW/YKx6Du0aGt+oTYGFbb3Y+D27G7Ot3i3PZThssI4N/nrlGED18v7unTiz5PIauzjeoslH/ixNZUvAWX1uZQflOfTY8ooOp4mOpugFzdDJSo3AyCFcNav9vTfANJZYGeJJIj2MLh8MwDBjz3R5iVkA9OmyipLGpAvjD7kjpfx4KRhH5fDbrl2eDoAyDC0v/I1FxAJdmNGFVoES/fffmp6Jw7Bwam/WlSQko5fZxZj5H8YhR5IVRW/IqAieT/8LZqhVRfcToyW4OLl+dD4/nKBmsi4/lOVHv8VBjKw11vwVA/ZD5HHBZGCd9UkZBGJvAvRv/DDbMqN+3EdBvg6f/nzAwVdihzZ+sYfuM9j6jXgA3yUGIX697dEBfaGE4wtPEap5l+P+FQj3aVIEy9zFqHZgh9ofww0oC6cifPwyVetQyIB1WohzopIdY+dygjyw79fjvQKUeGQeZ+6pepjRBGB3Qc8oJnv9XENR7qCNFsjneuoLVeZaO6TxqH6O/DYp67IIHQ7nGc19odvoj2aLgan9QrU79N0BRLwSeQUM5yF1//GPvQX7vGh//ePZuMEjqvQXOdPnEYe539/IJlvShp0JTl+7c2j8Kmnpx2y5uHkVY311M7i+n08v7ycUdbUk2OHtw9itFaKgXG5794Zx+WzFWLYH5VvlffDvmDzc5brOes/iVB9CUdfIGB5JpqfdWYluUeD59NWx8oZczLP+L74fYu/gcM57sloEygjhMySp01HtzMZ3pl/USyfgMhcpIEDqJpeQyT9wCmyxS2ZaxZEekbleMYWipl7lvsFYN/+SpJeaIHTGvUB/nN5KdSlmbRFL0d2NvCqj3rqQu0IC1CF+Hwr4l9Rap0YElJNRf397e3lykHnH8YrI38h9c1s2RNI0C6tWNFgELNx8Ff5BgtVSaunwXK2yChNtMYRIjH/sLV2Bl+rkRcoEi6j2vpVSyI9VvKzEWx3wjK3xD3F1jGQn12bSVpOSQyD7K1tbkv/TYWgsopp46HjmIdH/Rflfeun5qLxqM6OpyGUlh6v/xFTXR9quVwzXWK6Xe25MdcnEXXdhdLDftfYT2ZrnohnE3HfXWxlPJV5hEQn1atJnHtZ5sX3iy0g56DtdYr5x6bzXU1bODCGmpMf4/zZuY2xA2oX48i9ARjAtMIdgV/bVZlFIvh0a1EDRqRgPfDdG5nEHREjayu1pjvUrUn7zlJXC4vmaQ/XqIW7MJEM7WWK8a9XFoWp/8yBdS12LbSKjfPsRIN5TCiJO+2zXWq0p9tNzW3IERsOFPSM5jvz6Z2QADA5LOIuUUWpuoSn1E/rA6+QHr/gTiRecyrSwLV4gKgz1Up97znhZ+lRU3YMHxpCSzAQjUJ3tRH/GVX0N9hHaX9t4R7+zg2KvBEKhPsjiv+Mpvoj7CfhHSW5EiL5+Fx4oZNktAIVXas9sXrvwy6iOs9ss4emVpMBUHViyObpcvpbk120gI7idIvcmtcOX3UZ/i6jNOIUTYtPefDkOTIlD5enTlt1L/GyANN0Ebu87UG8btoJfjefQgXxnQA90s4X9O/U/GmXpnOFPvDGfqneFMvTOcqXeGM/XO0HDTb3iGd/kfr70wHh72JDwAAAAASUVORK5CYII=" data-filename="CC BY.png"><br></p>', NULL, 2, 89)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (3, N'&nbsp;', NULL, 3, 89)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (4, N'<span style="color: #242424; font-size: 12px; line-height: 14.40000057220459px; background-color: #ffffff;">The International Journal of Organizational Leadership is published by Industral Management Institute, Ardabil branch, Iran.</span><br />', N'', 4, 89)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (5, N'English is undeniably the most important language in our era. This site is for those who cherish English and want to acquire it. Especially those who are trying to take IELTS and TOEFL exams. English poetry and etymology will also be included to add variety to the site. We hope you will enjoy your presence in our site. ', N'English is undeniably the most important language in our era. This site is for those who cherish English and want to acquire it. Especially those who are trying to take IELTS and TOEFL exams. English poetry and etymology will also be included to add variety to the site. We hope you will enjoy your presence in our site. ', 5, 89)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (6, N'<div class="clients-carousel">
                <div class="col-md-3 col-xs-6">
                    <a href="#">
                        <figure>
                            <img src="/Resources/Images/clients-logo/clients-logo1.png" alt="">
                        </figure>
                    </a>
                </div>
                <!-- End clients item-->
                <!-- Start clients item-->
                <div class="col-md-3 col-xs-6">
                    <a href="#">
                        <figure>
                            <img src="/Resources/Images/clients-logo/clients-logo2.png" alt="">
                        </figure>
                    </a>
                </div>
                <!-- End clients item-->
                <!-- Start clients item-->
                <div class="col-md-3 col-xs-6">
                    <a href="#">
                        <figure>
                            <img src="/Resources/Images/clients-logo/clients-logo3.png" alt="">
                        </figure>
                    </a>
                </div>
                <!-- End clients item-->
                <!-- Start clients item-->
                <div class="col-md-3 col-xs-6">
                    <a href="#">
                        <figure>
                            <img src="/Resources/Images/clients-logo/clients-logo4.png" alt="">
                        </figure>
                    </a>
                </div>
                <!-- End clients item-->
                <!-- Start clients item-->
                <div class="col-md-3 col-xs-6">
                    <a href="#">
                        <figure>
                            <img src="/Resources/Images/clients-logo/clients-logo5.png" alt="">
                        </figure>
                    </a>
                </div>
                <!-- End clients item-->
                <!-- Start clients item-->
                <div class="col-md-3 col-xs-6">
                    <a href="#">
                        <figure>
                            <img src="/Resources/Images/clients-logo/clients-logo6.png" alt="">
                        </figure>
                    </a>
                </div>
                <!-- End clients item-->
                <!-- Start clients item-->
                <div class="col-md-3 col-xs-6">
                    <a href="#">
                        <figure>
                            <img src="/Resources/Images/clients-logo/clients-logo7.png" alt="">
                        </figure>
                    </a>
                </div>
                <!-- End clients item-->
                <!-- Start clients item-->
                <div class="col-md-3 col-xs-6">
                    <a href="#">
                        <figure>
                            <img src="/Resources/Images/clients-logo/clients-logo8.png" alt="">
                        </figure>
                    </a>
                </div>
                <!-- End clients item-->
            </div>', NULL, 6, 89)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (7, N'En', N'En', 1, 205)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (8, N'TR', N'TR', 1, 198)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (9, N'En', N'En', 2, 205)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (10, N'TR', N'TR', 2, 198)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (11, N'En', N'En', 3, 205)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (12, N'TR', N'TR', 3, 198)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (13, N'En', N'En', 4, 205)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (14, N'TR', N'TR', 4, 198)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (15, N'<div style="direction: ltr;"><span style="font-size: 1rem;">Nadine Tread is a highly experienced business team with many years of successful international experience in managing the supply of all kinds of industrial products and devices and their import and export. Our services range from our beloved country of Iran to Turkey and Azerbaijan and most European countries</span></div>', N'<div style="direction: ltr;"><span style="font-size: 1rem;">Nadine Tread is a highly experienced business team with many years of successful international experience in managing the supply of all kinds of industrial products and devices and their import and export. Our services range from our beloved country of Iran to Turkey and Azerbaijan and most European countries</span></div>', 5, 205)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (16, N'Nadine Tread, her türlü endüstriyel ürün ve cihazın tedarikini ve ithalat ve ihracatını yönetmede uzun yıllara dayanan uluslararası deneyime sahip son derece deneyimli bir iş ekibidir. Hizmetlerimiz, sevgili İran ülkemizden Türkiye ve Azerbaycan''a ve çoğu Avrupa ülkesine kadar uzanmaktadır.', N'<div align="left">Nadine Tread, her türlü endüstriyel ürün ve cihazın tedarikini ve ithalat ve ihracatını yönetmede uzun yıllara dayanan uluslararası deneyime sahip son derece deneyimli bir iş ekibidir. Hizmetlerimiz, sevgili İran ülkemizden Türkiye ve Azerbaycan''a ve çoğu Avrupa ülkesine kadar uzanmaktadır.</div>', 5, 198)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (17, N'En', N'En', 6, 205)
INSERT [dbo].[PageContent] ([Id], [Content], [Subject], [Type], [LanguageId]) VALUES (18, N'TR', N'TR', 6, 198)
SET IDENTITY_INSERT [dbo].[PageContent] OFF
GO
SET IDENTITY_INSERT [dbo].[Person] ON 

INSERT [dbo].[Person] ([Id], [UserId], [LanguageId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ProfilePictureUrl], [CountryId]) VALUES (224, N'70d732a9-3fb4-47b7-a5df-b737a3980158', NULL, N'administrator', N'Admin ', N'0912', N'12312', N'', 0, NULL, N'', NULL, N'admin address', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Person] ([Id], [UserId], [LanguageId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ProfilePictureUrl], [CountryId]) VALUES (232, N'70865ade-87a2-45cb-8dd8-61acbc08ceb0', NULL, N'اکبر محمد', N'نعیم', NULL, NULL, NULL, 0, NULL, NULL, NULL, N'سی متری جی - خیابان سادات - خیابان بیدوا پ 124 - زنگ چهارم', NULL, N'تهران', N'تهران', N'1351773497', NULL, 101)
INSERT [dbo].[Person] ([Id], [UserId], [LanguageId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ProfilePictureUrl], [CountryId]) VALUES (233, N'71808cb5-011a-433c-befc-d26cfb9c5033', NULL, N'Ebi', N'aaaa', NULL, NULL, NULL, 0, NULL, NULL, NULL, N'سی متری جی - خیابان سادات - خیابان بیدوا پ 124 - زنگ چهارم', NULL, N'تهران', N'تهران', N'1351773497', NULL, 101)
SET IDENTITY_INSERT [dbo].[Person] OFF
GO
SET IDENTITY_INSERT [dbo].[Product] ON 

INSERT [dbo].[Product] ([Id], [CategoryId], [IsPackage], [Name], [QuantityUnitId], [Description], [Date], [ProductionDate], [ExpiryDate], [OccasionId]) VALUES (2217, 48, 0, N'Casual Clothes', 1, NULL, CAST(N'2021-02-04T00:00:00.000' AS DateTime), CAST(N'2021-02-04T00:00:00.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Product] ([Id], [CategoryId], [IsPackage], [Name], [QuantityUnitId], [Description], [Date], [ProductionDate], [ExpiryDate], [OccasionId]) VALUES (2219, 52, 0, N'rrr', 1, NULL, CAST(N'2021-03-03T00:00:00.000' AS DateTime), CAST(N'2021-03-03T00:00:00.000' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[Product] OFF
GO
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'6a267e0c-c8a8-43e1-894e-1f221cc02093', N'00000000-0000-0000-0000-000000000000', 2217, NULL, NULL, NULL, 1, NULL, NULL, NULL)
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'3e81ec35-7e30-4e83-8fe7-2ca7d4db2230', N'f0a50413-791f-48de-b325-c9963412f05a', 2219, 58, NULL, NULL, 5, NULL, NULL, NULL)
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'39fcb1b6-6c60-4988-9a7b-32f80c545fa5', N'34ed80cc-9e4d-46a6-9b3a-de7b12a751f9', 2219, 57, NULL, NULL, 6, NULL, NULL, NULL)
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'c46f2bc7-1a0e-4323-adf7-4da1e6e58968', N'4935c26e-487b-4add-a0a4-b39c0f53fa48', 2217, 50, CAST(2.00 AS Decimal(18, 2)), 22, 5, N'/Resources/Images/pic/none-icon.png', 1, NULL)
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'9be955cc-d5c2-43c7-9040-5efbc811a5a7', N'6a267e0c-c8a8-43e1-894e-1f221cc02093', 2217, 48, NULL, NULL, 3, NULL, NULL, NULL)
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'd72d035d-aeb5-4d00-97f9-62f774990f35', N'f0a50413-791f-48de-b325-c9963412f05a', 2219, 57, CAST(100.00 AS Decimal(18, 2)), 10000, 4, N'/Resources/Uploaded/Product/52/_2219_PIID_d72d035d_aeb5_4d00_97f9_62f774990f35.png?w=29&h=29', 1, NULL)
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'a1fc0b8b-e80e-4040-a1ca-85aa54b89c44', N'34ed80cc-9e4d-46a6-9b3a-de7b12a751f9', 2219, 58, CAST(2000.00 AS Decimal(18, 2)), 20, 7, N'/Resources/Uploaded/Product/52/_2219_PIID_a1fc0b8b_e80e_4040_a1ca_85aa54b89c44.png?w=29&h=29', 1, NULL)
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'a978d013-8a11-4833-b6fb-9554123aec8a', N'4935c26e-487b-4add-a0a4-b39c0f53fa48', 2217, 49, CAST(1.00 AS Decimal(18, 2)), 11, 4, N'/Resources/Uploaded/Product/48/_2217_PIID_a978d013_8a11_4833_b6fb_9554123aec8a.png?w=29&h=29', 1, NULL)
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'b373d253-7052-4913-af8d-a3be96fecf03', N'00000000-0000-0000-0000-000000000000', 2219, NULL, NULL, NULL, 1, NULL, NULL, NULL)
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'4935c26e-487b-4add-a0a4-b39c0f53fa48', N'6a267e0c-c8a8-43e1-894e-1f221cc02093', 2217, 47, NULL, NULL, 2, NULL, NULL, NULL)
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'd7201712-b2c3-46c8-a8da-bc3bba182b84', N'9be955cc-d5c2-43c7-9040-5efbc811a5a7', 2217, 50, CAST(33.00 AS Decimal(18, 2)), 333, 7, N'/Resources/Uploaded/Product/48/_2217_PIID_d7201712_b2c3_46c8_a8da_bc3bba182b84.png?w=29&h=29', 1, NULL)
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'f0a50413-791f-48de-b325-c9963412f05a', N'b373d253-7052-4913-af8d-a3be96fecf03', 2219, 55, NULL, NULL, 2, NULL, NULL, NULL)
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'34ed80cc-9e4d-46a6-9b3a-de7b12a751f9', N'b373d253-7052-4913-af8d-a3be96fecf03', 2219, 56, NULL, NULL, 3, NULL, NULL, NULL)
INSERT [dbo].[ProductFeature] ([Id], [ParentId], [ProductId], [FeatureTypeDetailId], [Price], [Quantity], [Priority], [IconUrl], [Showcase], [Description]) VALUES (N'11dcca88-c0bd-471e-99ed-ff17d81e5a32', N'9be955cc-d5c2-43c7-9040-5efbc811a5a7', 2217, 49, CAST(22.00 AS Decimal(18, 2)), 222, 6, N'/Resources/Images/pic/none-icon.png', 1, NULL)
GO
SET IDENTITY_INSERT [dbo].[Province] ON 

INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (10, N'اردبيل', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (11, N'آذربايجان شرقي', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (12, N'آذربايجان غربي', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (13, N'اصفهان', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (14, N'ايلام', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (15, N'كرمانشاه', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (16, N'بوشهر', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (17, N'تهران', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (18, N'چهار محال و بختياري', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (19, N'خراسان رضوی', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (20, N'خوزستان', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (21, N'زنجان', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (22, N'سمنان', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (23, N'سیستان و بلوچستان', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (24, N'فارس', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (25, N'كردستان', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (26, N'كرمان', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (27, N'كهكيلويه و بوير احمد', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (28, N'گيلان', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (29, N'لرستان', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (30, N'مازندران', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (31, N'مركزي', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (32, N'هرمزگان', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (33, N'همدان', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (34, N'يزد', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (35, N'قم', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (36, N'كاشان', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (37, N'قزوين', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (38, N'گلستان', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (39, N'خراسان جنوبي', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (40, N'خراسان شمالي', 101)
INSERT [dbo].[Province] ([Id], [Name], [CountryId]) VALUES (47, N'البرز', 101)
SET IDENTITY_INSERT [dbo].[Province] OFF
GO
SET IDENTITY_INSERT [dbo].[QuantityUnit] ON 

INSERT [dbo].[QuantityUnit] ([Id], [Name], [QuantityDetail]) VALUES (1, N'Meter     ', NULL)
SET IDENTITY_INSERT [dbo].[QuantityUnit] OFF
GO
SET IDENTITY_INSERT [dbo].[RefrenceWord] ON 

INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (1, N'Home')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (2, N'Products')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (3, N'Site Management')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (4, N'Home')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (5, N'Services')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (6, N'Partners')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (7, N'About us')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (8, N'Contact')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (9, N'Login')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (10, N'Register')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (11, N'Search here')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (12, N'Getting started')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (13, N'Language')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (14, N'Country')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (15, N'City')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (16, N'Postcode')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (17, N'Search by skills')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (18, N'Let''s Work Together!')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (19, N'Join free today')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (20, N'Rent workers - Rent out crews - Get or sell construction jobs in your local area or internationally')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (21, N'Profiles, looking for jobs right now')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (22, N'Offering jobs right now')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (23, N'International profiles and jobs')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (24, N'See all profiles here')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (25, N'See all jobs here')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (26, N'Profiles and jobs')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (27, N'Profiles')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (28, N'Jobs')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (29, N'Select country')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (30, N'Free')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (31, N'click')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (32, N'Unlimited')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (33, N'week')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (34, N'month')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (35, N'Limited profile visit')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (36, N'Unlimited profile visit')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (37, N'Limited to living postcode')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (38, N'No limitation to postcode')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (39, N'Limited to chosen postcode')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (40, N'Limited to chosen city')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (41, N'Limited to chosen country')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (42, N'Access to entire profiles')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (43, N'Limited days')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (44, N'No time limitation')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (45, N'No job list')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (46, N'Receive job list')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (47, N'No access to visited profiles')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (48, N'Access to visited profiles')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (49, N'Buy Now')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (50, N'Our services')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (51, N'Rent crew')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (52, N'Get, buy & sell jobs')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (53, N'Networks & Events')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (54, N'Buy & sell used equipments')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (55, N'Buy & sell new equipments')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (56, N'Use')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (57, N'As you wish')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (58, N'Future digital access')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (59, N'Read more about System')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (60, N'Testimonial')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (61, N'Sign up now and be a part of a future')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (62, N'Sign me up')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (63, N'Upcoming events')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (64, N'Get in touch')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (65, N'Address')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (66, N'E-Mail')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (67, N'Phone')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (68, N'Who are we')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (69, N'and where are we going')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (70, N'Welcome to the club')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (71, N'Join our next meeting')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (72, N'The best network of the year')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (73, N'See all genre')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (74, N'Network')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (75, N'Contact us')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (76, N'Meet us here')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (77, N'Network meetings')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (78, N'Saturday ')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (79, N'Sunday ')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (80, N'Monday ')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (81, N'Tuesday')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (82, N'Wednesday')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (83, N'Thursday')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (84, N'Friday')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (85, N'Sign up to System today')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (86, N'Name')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (87, N'Subject')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (88, N'Message')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (89, N'Send')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (90, N'See all members')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (91, N'See all events')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (92, N'See all jobs')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (93, N'Webshop')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (94, N'A network')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (95, N'That supports you')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (96, N'Start working with us')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (97, N'Contact your local branch')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (98, N'The best contracts')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (99, N'Starts here')
GO
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (100, N'Geographical location')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (101, N'See all representatives')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (102, N'What do you gain from your membership')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (103, N'Join the next network meeting')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (104, N'Password')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (105, N'Remember me?')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (106, N'Forgot password?')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (107, N'Social network account log in')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (108, N'Email is required')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (109, N'Password is required')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (110, N'Enter your email')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (111, N'Email link')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (112, N'Create a new account')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (113, N'User name')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (114, N'Role')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (115, N'Confirm password')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (116, N'Select your role')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (117, N'Company')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (118, N'Customer')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (119, N'Skilled worker')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (120, N'Admin panel')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (121, N'All rights reserved')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (122, N'Login with your social network account')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (123, N'Social login')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (124, N'Error')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (125, N'An error occurred while processing your request')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (126, N'Locked out')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (127, N'This account has been locked out, please try again later')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (128, N'Create local login')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (129, N'Set password')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (130, N'Change password form')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (131, N'Change password')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (132, N'Format')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (133, N'Protection')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (134, N'Type')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (135, N'You''ve successfully authenticated with')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (136, N'You do not have a local username/password for this site. add a local account so you can log in without an external login.')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (137, N'Please enter a username for this site below and click the register button to finish logging in.')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (138, N'Unsuccessful login with service')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (139, N'Please check your email to reset your password')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (140, N'Select your countries')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (141, N'Reset')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (142, N'Reset your password')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (143, N'Your password has been reset')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (144, N'Click here to log in')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (145, N'Register date')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (146, N'Roles')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (147, N'Forgot password confirmation')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (148, N'Spinning machine')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (149, N'Product Definition')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (150, N'Services')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (151, N'Moving pictures')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (152, N'Main text')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (153, N'Messages')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (154, N'Message')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (155, N'Change passwords')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (156, N'Managing languages')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (157, N'Exit')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (158, N'Download the Excel language file')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (159, N'Upload the Excel language file')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (160, N'Introducing')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (161, N'Nadine Trade')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (162, N'More information')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (163, N'Completed project')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (164, N'Years of experience')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (165, N'Authentic product')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (166, N'Return')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (167, N'Processing, please wait ...')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (168, N'Enter the name')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (169, N'Enter the subject of the message')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (170, N'Enter the message')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (171, N'Enter the email')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (172, N'Please enter the correct email address')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (173, N'Message sent')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (174, N'Double-click the row to change the information or click the pencil mark in the row')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (175, N'Did you feel that way?')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (176, N'Iran office')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (177, N'Tehran')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (178, N'Office in Turkey')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (179, N'Istanbul')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (180, N'Message title')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (181, N'Send Message')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (182, N'Details')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (183, N'Please select a file')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (184, N'Loading languages')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (185, N'Select the file')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (186, N'Supply of Consumables')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (187, N'Repairs')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (188, N'Installation')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (189, N'Blogs')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (190, N'Categories')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (191, N'Projects')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (192, N'Blog')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (193, N'Textile')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (194, N'Type 1 projects')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (195, N'Type Two Projects')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (196, N'Agriculture')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (197, N'Services')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (198, N'Installation')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (199, N'Repairs')
GO
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (200, N'Supply of Consumables')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (201, N'Car Parts')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (202, N'Spare')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (203, N'Hospital equipment')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (204, N'Texturing machines')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (205, N'Dyeing machines')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (206, N'Spinning machines')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (207, N'Sample fabric products')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (208, N'Luxury')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (209, N'Crop harvesting machines')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (210, N'Types of fertilizers')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (211, N'Modern beds')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (212, N'Computer equipment')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (213, N'Hardware')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (214, N'Software')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (215, N'New products will be introduced soon')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (216, N'Name')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (217, N'E-Mail')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (218, N'Available')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (219, N'Unavailable')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (220, N'Media selection')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (221, N'Knitting machines')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (222, N'Download Intro Movie')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (223, N'Film selection')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (224, N'Dyeing')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (225, N'Video playback site link')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (226, N'Spinning')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (227, N'Printing tape')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (228, N'Parts & Supplies')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (229, N'Introducing new services')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (230, N'Active')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (231, N'Sample Products')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (232, N'Services management')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (233, N'Product Management')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (234, N'Product Name')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (235, N'Visit')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (236, N'Category')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (237, N'Image priority')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (238, N'Definition')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (239, N'Picture')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (240, N'Default screen')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (241, N'Available')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (242, N'Add new product')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (243, N'Are you sure ?')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (244, N'Cancel')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (245, N'Language')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (246, N'Select Language...')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (247, N'Add')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (248, N'Change')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (249, N'Delete')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (250, N'Yes')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (251, N'No')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (252, N'The original title cannot be changed. Please right-click and select Add New.')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (253, N'Display on homepage')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (254, N'Select the Excel language file')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (255, N'Upload and Save')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (256, N'Select a photo')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (257, N'Summary text')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (258, N'Full text')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (259, N'Show selected movie')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (260, N'Generating specifications, please wait')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (261, N'Additional Profile Management')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (262, N'Select a category')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (263, N'Resim yüklenirken hata oluştu')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (264, N'Click to view additional details')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (265, N'Loading profile, please wait')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (266, N'The option was not found, please search for another keyword')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (267, N'search result')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (268, N'Product Profile Management')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (269, N'Image caption')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (270, N'Save')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (271, N'All')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (272, N'Men')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (273, N'Women')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (274, N'Clothing')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (275, N'Accessories')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (276, N'Clothing')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (277, N'Girls')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (278, N'Boys')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (279, N'Girls From 4 to 14 years')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (280, N'Boys From 4 to 14 years')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (281, N'Girls From 0 to 4 years')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (282, N'Boys From 0 to 4 years')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (283, N'Shirts')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (284, N'Shoes')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (285, N'Dress')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (286, N'Shirt')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (287, N'Trouser')
SET IDENTITY_INSERT [dbo].[RefrenceWord] OFF
GO
SET IDENTITY_INSERT [dbo].[SiteInfo] ON 

INSERT [dbo].[SiteInfo] ([Id], [SiteName]) VALUES (1, N'Error From Google ReCaptcha - 2/20/2021 1:44:58 PM')
INSERT [dbo].[SiteInfo] ([Id], [SiteName]) VALUES (2, N'Error From Google ReCaptcha - 2/20/2021 2:12:43 PM')
INSERT [dbo].[SiteInfo] ([Id], [SiteName]) VALUES (3, N'Error From Google ReCaptcha - 2/20/2021 2:15:23 PM')
INSERT [dbo].[SiteInfo] ([Id], [SiteName]) VALUES (4, N'Error From Google ReCaptcha - 2/20/2021 2:16:08 PM')
INSERT [dbo].[SiteInfo] ([Id], [SiteName]) VALUES (5, N'Error From Google ReCaptcha - 2/20/2021 2:17:11 PM')
SET IDENTITY_INSERT [dbo].[SiteInfo] OFF
GO
SET IDENTITY_INSERT [dbo].[SundryImage] ON 

INSERT [dbo].[SundryImage] ([Id], [Title], [Type], [ImageUrl], [LanguageId], [Priority], [LinkUrl], [ObjectId], [PackageItemType], [BannerImageUrl], [BannerImageTitle]) VALUES (25, N'<table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="border-width: initial; border-style: none;">
 <tbody><tr style="mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes;
  height:22.0pt">
  <td width="99" valign="top" style="width: 73.9pt; border-width: 1pt; border-style: solid; border-color: windowtext; padding: 0in 5.4pt; height: 22pt;">
  <h1 style="margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal">OYA TARZ</h1><p class="MsoNormal" align="center" style="margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal"><o:p></o:p></p>
  </td>
 </tr>
</tbody></table>', 0, N'/Resources/Uploaded/Images/___b3e57af2_bfec_4235_9bc9_51a9b17acace_Image (37).jpg?w=1170&h=600&col=1', 205, 10, NULL, 0, -1, N'', N'<p><br></p>')
INSERT [dbo].[SundryImage] ([Id], [Title], [Type], [ImageUrl], [LanguageId], [Priority], [LinkUrl], [ObjectId], [PackageItemType], [BannerImageUrl], [BannerImageTitle]) VALUES (26, N'<h2><span style="background-color: rgb(181, 214, 165);">Shopping OYA TARZ</span></h2>', 0, N'/Resources/Uploaded/Images/_6.jpg?w=3096&h=2844&col=0', 205, 2, NULL, 0, -1, N'', NULL)
INSERT [dbo].[SundryImage] ([Id], [Title], [Type], [ImageUrl], [LanguageId], [Priority], [LinkUrl], [ObjectId], [PackageItemType], [BannerImageUrl], [BannerImageTitle]) VALUES (28, N'<h1>Boys From 4 to 14 years<br></h1>', 1, N'/Resources/Uploaded/Images/_________________test2.png?w=560&h=424&col=2', 205, 1, NULL, 50, 3, N'/Resources/Uploaded/Images/__16.jpg?w=5184&h=3456', N'<p><br></p>')
INSERT [dbo].[SundryImage] ([Id], [Title], [Type], [ImageUrl], [LanguageId], [Priority], [LinkUrl], [ObjectId], [PackageItemType], [BannerImageUrl], [BannerImageTitle]) VALUES (31, N'<h1><span style="background-color: rgb(255, 198, 156);">Trouser</span></h1>', 1, N'/Resources/Uploaded/Images/_1.jpg?w=5184&h=3456&col=1', 205, 2, NULL, 1062, 3, N'/Resources/Uploaded/Images/__15.jpg?w=5184&h=3456', N'<p><br></p>')
INSERT [dbo].[SundryImage] ([Id], [Title], [Type], [ImageUrl], [LanguageId], [Priority], [LinkUrl], [ObjectId], [PackageItemType], [BannerImageUrl], [BannerImageTitle]) VALUES (32, N'<h1><b>SHIRT</b></h1>', 1, N'/Resources/Uploaded/Images/__IMG_6129.JPG?w=5184&h=3456&col=2', 205, 3, NULL, 1061, 3, N'', N'<p><br></p>')
INSERT [dbo].[SundryImage] ([Id], [Title], [Type], [ImageUrl], [LanguageId], [Priority], [LinkUrl], [ObjectId], [PackageItemType], [BannerImageUrl], [BannerImageTitle]) VALUES (33, N'<p><span style="font-size: 36px; font-family: Impact;"><b>TROUSER</b></span></p>', 1, N'/Resources/Uploaded/Images/______4479c004_fe4f_4a66_b329_9d6742bd1903_test1.png?w=960&h=726&col=1', 205, 4, NULL, 1062, 3, N'', N'<p><br></p>')
INSERT [dbo].[SundryImage] ([Id], [Title], [Type], [ImageUrl], [LanguageId], [Priority], [LinkUrl], [ObjectId], [PackageItemType], [BannerImageUrl], [BannerImageTitle]) VALUES (36, N'<h4>afds </h4>', 0, N'/Resources/Uploaded/Images/_1.jpg?w=5184&h=3456&col=0', 205, 1, NULL, 0, -1, N'', NULL)
INSERT [dbo].[SundryImage] ([Id], [Title], [Type], [ImageUrl], [LanguageId], [Priority], [LinkUrl], [ObjectId], [PackageItemType], [BannerImageUrl], [BannerImageTitle]) VALUES (37, N'<p><br></p>', 0, N'/Resources/Uploaded/Images/_Image (17).jpg?w=2048&h=829&col=0', 205, 1, NULL, 0, -1, N'', NULL)
SET IDENTITY_INSERT [dbo].[SundryImage] OFF
GO
ALTER TABLE [dbo].[AspNetRoles] ADD  CONSTRAINT [DF_AspNetRoles_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF_AspNetUsers_LockoutEndDateUtc]  DEFAULT ('2018-01-01T00:00:00.000') FOR [LockoutEndDateUtc]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF_AspNetUsers_RegisterDate]  DEFAULT ('2018-01-01T00:00:00.000') FOR [RegisterDate]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF_AspNetUsers_LastSignIn]  DEFAULT ('2018-01-01T00:00:00.000') FOR [LastSignIn]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT ((0)) FOR [AllowAcceptReject]
GO
ALTER TABLE [dbo].[Category] ADD  CONSTRAINT [DF_Category_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
GO
ALTER TABLE [dbo].[City] ADD  CONSTRAINT [DF_City_Active]  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [DF__Country__Iso3__4E9398CC]  DEFAULT (NULL) FOR [Iso3]
GO
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [DF__Country__NumCode__4F87BD05]  DEFAULT (NULL) FOR [NumCode]
GO
ALTER TABLE [dbo].[Image] ADD  CONSTRAINT [DF_Image_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Language] ADD  CONSTRAINT [DF_Language_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
GO
ALTER TABLE [dbo].[Language] ADD  CONSTRAINT [DF_Language_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[LocalLink] ADD  CONSTRAINT [DF_LocalLinks_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Message] ADD  CONSTRAINT [DF_Messages_Road]  DEFAULT ((0)) FOR [Visited]
GO
ALTER TABLE [dbo].[Message] ADD  CONSTRAINT [DF_Messages_Type]  DEFAULT ((0)) FOR [Type]
GO
ALTER TABLE [dbo].[Package] ADD  CONSTRAINT [DF_Package_Discount]  DEFAULT ((0)) FOR [DiscountId]
GO
ALTER TABLE [dbo].[PackageDetail] ADD  CONSTRAINT [DF_PackageDetail_Number]  DEFAULT ((1)) FOR [Number]
GO
ALTER TABLE [dbo].[Person] ADD  CONSTRAINT [DF_A0D4FE3A8E1C4519B8E29BC7F53AC475_Sex]  DEFAULT ((0)) FOR [Sex]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_IsPackage]  DEFAULT ((0)) FOR [IsPackage]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_Date]  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[Statistics] ADD  CONSTRAINT [DF_Reference_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Statistics] ADD  CONSTRAINT [DF_Reference_VisitCount]  DEFAULT ((1)) FOR [VisitCount]
GO
ALTER TABLE [dbo].[SundryImage] ADD  CONSTRAINT [DF_SundryImage_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[SundryImage] ADD  CONSTRAINT [DF_SundryImage_TabMenuType]  DEFAULT ((-1)) FOR [PackageItemType]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[BaseFeatureTypeDetail]  WITH CHECK ADD  CONSTRAINT [FK_BaseFeatureTypeDetail_BaseFeatureType] FOREIGN KEY([BaseFeatureTypeId])
REFERENCES [dbo].[BaseFeatureType] ([Id])
GO
ALTER TABLE [dbo].[BaseFeatureTypeDetail] CHECK CONSTRAINT [FK_BaseFeatureTypeDetail_BaseFeatureType]
GO
ALTER TABLE [dbo].[CategoryField]  WITH CHECK ADD  CONSTRAINT [FK_CategoryField_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([Id])
GO
ALTER TABLE [dbo].[CategoryField] CHECK CONSTRAINT [FK_CategoryField_Category]
GO
ALTER TABLE [dbo].[City]  WITH CHECK ADD  CONSTRAINT [FK_ProvinceCity] FOREIGN KEY([ProvinceId])
REFERENCES [dbo].[Province] ([Id])
GO
ALTER TABLE [dbo].[City] CHECK CONSTRAINT [FK_ProvinceCity]
GO
ALTER TABLE [dbo].[Dictionary]  WITH CHECK ADD  CONSTRAINT [FK_Dictionary_Language] FOREIGN KEY([CultureInfoCode])
REFERENCES [dbo].[Language] ([CultureInfoCode])
GO
ALTER TABLE [dbo].[Dictionary] CHECK CONSTRAINT [FK_Dictionary_Language]
GO
ALTER TABLE [dbo].[Discount]  WITH CHECK ADD  CONSTRAINT [FK_Discount_DiscountType] FOREIGN KEY([DiscountTypeId])
REFERENCES [dbo].[DiscountType] ([Id])
GO
ALTER TABLE [dbo].[Discount] CHECK CONSTRAINT [FK_Discount_DiscountType]
GO
ALTER TABLE [dbo].[DiscountDetail]  WITH CHECK ADD  CONSTRAINT [FK_DiscountDetail_Discount] FOREIGN KEY([DiscountId])
REFERENCES [dbo].[Discount] ([Id])
GO
ALTER TABLE [dbo].[DiscountDetail] CHECK CONSTRAINT [FK_DiscountDetail_Discount]
GO
ALTER TABLE [dbo].[FeatureType]  WITH CHECK ADD  CONSTRAINT [FK_FeatureType_BaseFeatureType] FOREIGN KEY([BaseFeatureTypeId])
REFERENCES [dbo].[BaseFeatureType] ([Id])
GO
ALTER TABLE [dbo].[FeatureType] CHECK CONSTRAINT [FK_FeatureType_BaseFeatureType]
GO
ALTER TABLE [dbo].[FeatureType]  WITH CHECK ADD  CONSTRAINT [FK_FeatureType_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([Id])
GO
ALTER TABLE [dbo].[FeatureType] CHECK CONSTRAINT [FK_FeatureType_Category]
GO
ALTER TABLE [dbo].[FeatureTypeDetail]  WITH CHECK ADD  CONSTRAINT [FK_FeatureTypeDetail_BaseFeatureTypeDetail] FOREIGN KEY([BaseFeatureTypeDetailId])
REFERENCES [dbo].[BaseFeatureTypeDetail] ([Id])
GO
ALTER TABLE [dbo].[FeatureTypeDetail] CHECK CONSTRAINT [FK_FeatureTypeDetail_BaseFeatureTypeDetail]
GO
ALTER TABLE [dbo].[FeatureTypeDetail]  WITH CHECK ADD  CONSTRAINT [FK_FeatureTypeDetail_FeatureType] FOREIGN KEY([FeatureTypeId])
REFERENCES [dbo].[FeatureType] ([Id])
GO
ALTER TABLE [dbo].[FeatureTypeDetail] CHECK CONSTRAINT [FK_FeatureTypeDetail_FeatureType]
GO
ALTER TABLE [dbo].[InvoiceStateHistory]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceStateHistory_Invoice] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[Invoice] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[InvoiceStateHistory] CHECK CONSTRAINT [FK_InvoiceStateHistory_Invoice]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Invoice] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[Invoice] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Invoice]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_ProductFeature] FOREIGN KEY([ProductFeatureId])
REFERENCES [dbo].[ProductFeature] ([Id])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_ProductFeature]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_RecipientType] FOREIGN KEY([RecipientTypeId])
REFERENCES [dbo].[RecipientType] ([Id])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_RecipientType]
GO
ALTER TABLE [dbo].[Package]  WITH CHECK ADD  CONSTRAINT [FK_Package_Occasion1] FOREIGN KEY([OccasionId])
REFERENCES [dbo].[Occasion] ([Id])
GO
ALTER TABLE [dbo].[Package] CHECK CONSTRAINT [FK_Package_Occasion1]
GO
ALTER TABLE [dbo].[Package]  WITH CHECK ADD  CONSTRAINT [FK_Package_Product] FOREIGN KEY([Id])
REFERENCES [dbo].[Product] ([Id])
GO
ALTER TABLE [dbo].[Package] CHECK CONSTRAINT [FK_Package_Product]
GO
ALTER TABLE [dbo].[PackageDetail]  WITH CHECK ADD  CONSTRAINT [FK_PackageDetail_Package] FOREIGN KEY([PackageId])
REFERENCES [dbo].[Package] ([Id])
GO
ALTER TABLE [dbo].[PackageDetail] CHECK CONSTRAINT [FK_PackageDetail_Package]
GO
ALTER TABLE [dbo].[PackageDetail]  WITH CHECK ADD  CONSTRAINT [FK_PackageDetail_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
GO
ALTER TABLE [dbo].[PackageDetail] CHECK CONSTRAINT [FK_PackageDetail_Product]
GO
ALTER TABLE [dbo].[PackageOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_PackageOrderDetail_Order] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Order] ([Id])
GO
ALTER TABLE [dbo].[PackageOrderDetail] CHECK CONSTRAINT [FK_PackageOrderDetail_Order]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_AspNetUsers]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_Country]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([Id])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_Category]
GO
ALTER TABLE [dbo].[Product]  WITH NOCHECK ADD  CONSTRAINT [FK_Product_Occasion] FOREIGN KEY([OccasionId])
REFERENCES [dbo].[Occasion] ([Id])
GO
ALTER TABLE [dbo].[Product] NOCHECK CONSTRAINT [FK_Product_Occasion]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_QuantityUnit] FOREIGN KEY([QuantityUnitId])
REFERENCES [dbo].[QuantityUnit] ([Id])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_QuantityUnit]
GO
ALTER TABLE [dbo].[ProductCategoryField]  WITH CHECK ADD  CONSTRAINT [FK_ProductCategoryField_CategoryField] FOREIGN KEY([CategoryFieldId])
REFERENCES [dbo].[CategoryField] ([Id])
GO
ALTER TABLE [dbo].[ProductCategoryField] CHECK CONSTRAINT [FK_ProductCategoryField_CategoryField]
GO
ALTER TABLE [dbo].[ProductCategoryField]  WITH CHECK ADD  CONSTRAINT [FK_ProductCategoryField_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductCategoryField] CHECK CONSTRAINT [FK_ProductCategoryField_Product]
GO
ALTER TABLE [dbo].[ProductDiscount]  WITH CHECK ADD  CONSTRAINT [FK_ProductDiscount_DiscountDetail] FOREIGN KEY([DiscountDetailId])
REFERENCES [dbo].[DiscountDetail] ([Id])
GO
ALTER TABLE [dbo].[ProductDiscount] CHECK CONSTRAINT [FK_ProductDiscount_DiscountDetail]
GO
ALTER TABLE [dbo].[ProductDiscount]  WITH CHECK ADD  CONSTRAINT [FK_ProductDiscount_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
GO
ALTER TABLE [dbo].[ProductDiscount] CHECK CONSTRAINT [FK_ProductDiscount_Product]
GO
ALTER TABLE [dbo].[ProductFeature]  WITH CHECK ADD  CONSTRAINT [FK_ProductFeature_FeatureTypeDetail] FOREIGN KEY([FeatureTypeDetailId])
REFERENCES [dbo].[FeatureTypeDetail] ([Id])
GO
ALTER TABLE [dbo].[ProductFeature] CHECK CONSTRAINT [FK_ProductFeature_FeatureTypeDetail]
GO
ALTER TABLE [dbo].[ProductFeature]  WITH CHECK ADD  CONSTRAINT [FK_ProductFeature_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductFeature] CHECK CONSTRAINT [FK_ProductFeature_Product]
GO
ALTER TABLE [dbo].[Province]  WITH CHECK ADD  CONSTRAINT [FK_CountryProvince] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO
ALTER TABLE [dbo].[Province] CHECK CONSTRAINT [FK_CountryProvince]
GO
/****** Object:  StoredProcedure [dbo].[SpGetAllProductFeatureFeatureTypeDetail]    Script Date: 3/7/2021 8:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[SpGetAllProductFeatureFeatureTypeDetail] 
	-- Add the parameters for the stored procedure here
	@ProductFeatureId uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     
;with name_tree as 
(
   select Id, parentId,FeatureTypeDetailId
   from  ProductFeature
   where Id = @ProductFeatureId -- this is the starting point you want in your recursion
   union all
   select C.Id, C.parentId,c.FeatureTypeDetailId
   from ProductFeature c
   join name_tree p on C.Id = P.parentId  -- this is the recursion
   -- Since your parent Id is not NULL the recursion will happen continously.
   -- For that we apply the condition C.Id<>C.parentId 
    AND C.Id<>C.parentId 
) 
-- Here you can insert directly to a temp table without CREATE TABLE synthax
select FeatureTypeDetailId,[Name]
--INTO #TEMP
from name_tree inner join ViewFeatureTypeDetail on name_tree.FeatureTypeDetailId=ViewFeatureTypeDetail.Id
OPTION (MAXRECURSION 0)

 
END
GO
/****** Object:  StoredProcedure [dbo].[SpGetChildrenOfCategory]    Script Date: 3/7/2021 8:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE  [dbo].[SpGetChildrenOfCategory] 
	-- Add the parameters for the stored procedure here
	@CategoryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     
;with name_tree as 
(
   select Id,parentId
   from Category
   where Id = @CategoryId -- this is the starting point you want in your recursion
   union all
   select c.Id,c.parentId
   from Category c
   join name_tree p on c.parentId  = P.Id    -- this is the recursion
   -- Since your parent Id is not NULL the recursion will happen continously.
   -- For that we apply the condition C.Id<>C.parentId 
    AND p.Id<> p.parentId 
) 
-- Here you can insert directly to a temp table without CREATE TABLE synthax
select id
--INTO #TEMP
from name_tree
OPTION (MAXRECURSION 0)

 
END
GO
/****** Object:  StoredProcedure [dbo].[SpGetOrderProductFeature]    Script Date: 3/7/2021 8:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SpGetOrderProductFeature] 
	  
	  @featureDetailCombinationList nvarchar(max),
	  @delimiter varchar(max),
	  @parentIdList nvarchar(max)
 as

BEGIN
 
	SET NOCOUNT ON;
	DECLARE @finalResult TABLE(Id uniqueidentifier not null, DetailIdPath nvarchar(max));

	declare @parentId nvarchar(max)
	declare @featureDetailTable table(detailId nvarchar(max)) 
	insert into @featureDetailTable SELECT * FROM dbo.SplitString(@featureDetailCombinationList, N',')
	DECLARE ParentIdCursor CURSOR FOR 
    SELECT * FROM dbo.SplitString(@parentIdList, N',')
	OPEN ParentIdCursor 
	 
	FETCH NEXT FROM ParentIdCursor INTO @parentId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		WITH  ViewProductFeatureTree (
								FeatureTypeDetailId,
								BaseFeatureTypeDetailId,
								DetailIdPath,
								Id, 
								ParentId,
								Price,
								FeatureTypeDetailPriority) 
		AS 
		( 
			SELECT
			FeatureTypeDetailId,
			BaseFeatureTypeDetailId,
			'' + convert(varchar(max),BaseFeatureTypeDetailId), 
			Id, 
			ParentId, 
			Price,
			FeatureTypeDetailPriority
   
			FROM ViewProductFeature 
			WHERE ParentId = CONVERT(uniqueidentifier, @parentId) 
   
			UNION ALL
			SELECT
				vpf.FeatureTypeDetailId,
				vpf.BaseFeatureTypeDetailId
				(convert(varchar(max),pft.BaseFeatureTypeDetailId) + @delimiter + convert(varchar(max), vpf.BaseFeatureTypeDetailId)) as DetailIdPath, 
				vpf.Id, 
				vpf.ParentId, 
				vpf.Price,
				vpf.FeatureTypeDetailPriority
	 
			FROM ViewProductFeature vpf, ViewProductFeatureTree pft 
			WHERE vpf.ParentId = pft.Id
		) 
		  
		insert into @finalResult SELECT Id, DetailIdPath FROM ViewProductFeatureTree 
		  
		FETCH NEXT FROM ParentIdCursor INTO @parentId
	END

	CLOSE ParentIdCursor
	DEALLOCATE ParentIdCursor

	if len(@featureDetailCombinationList) > 0 
	begin
		select wsp.* from @finalResult fr 
		inner join ViewShopProduct wsp on fr.Id = wsp.Id
		WHERE  Exists  (select * from @featureDetailTable where detailId = DetailIdPath)
		end
	else
	begin
		select wsp.* from @finalResult fr 
		inner join ViewShopProduct wsp on fr.Id = wsp.Id
	 
	end
 
END
GO
/****** Object:  StoredProcedure [dbo].[SpGetParentsOfCategory]    Script Date: 3/7/2021 8:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[SpGetParentsOfCategory] 
	-- Add the parameters for the stored procedure here
	@CategoryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     
;with name_tree as 
(
   select Id, parentId
   from Category
   where Id = @CategoryId -- this is the starting point you want in your recursion
   union all
   select C.Id, C.parentId
   from Category c
   join name_tree p on C.Id = P.parentId  -- this is the recursion
   -- Since your parent Id is not NULL the recursion will happen continously.
   -- For that we apply the condition C.Id<>C.parentId 
    AND C.Id<>C.parentId 
) 
-- Here you can insert directly to a temp table without CREATE TABLE synthax
select parentId
--INTO #TEMP
from name_tree
OPTION (MAXRECURSION 0)

 
END
GO
/****** Object:  StoredProcedure [dbo].[SpGetProductFeaturesByFilter]    Script Date: 3/7/2021 8:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SpGetProductFeaturesByFilter] 
	  @groupedIconList xml output,
	  @firstIconPriority int,
	  @featureDetailCombinationList nvarchar(max),
	  @delimiter varchar(max),
	  @parentIdList nvarchar(max),
	  @minPrice Decimal(18,2),
	  @maxPrice Decimal(18,2)
 as

BEGIN
 declare @xmlData xml
	SET @groupedIconList = (
		SELECT * from  dbo.GetProductIconGroupByFilter(
			@firstIconPriority ,
			@featureDetailCombinationList ,
			@delimiter ,
			@parentIdList ,
			@minPrice ,
			@maxPrice)
		FOR XML raw('groupedIcons'), TYPE) 
 
	SET NOCOUNT ON;
	DECLARE @finalResult TABLE(Id uniqueidentifier not null, DetailIdPath nvarchar(max));

	declare @parentId nvarchar(max)
	declare @featureDetailTable table(detailId nvarchar(max)) 
	insert into @featureDetailTable SELECT * FROM dbo.SplitString(@featureDetailCombinationList, N',')
	DECLARE ParentIdCursor CURSOR FOR 
    SELECT * FROM dbo.SplitString(@parentIdList, N',')
	OPEN ParentIdCursor 
	 
	FETCH NEXT FROM ParentIdCursor INTO @parentId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		WITH  ViewProductFeatureTree (
								FeatureTypeDetailId,
								BaseFeatureTypeDetailId,
								DetailIdPath,
								Id, 
								ParentId,
								Price,
								FeatureTypeDetailPriority) 
		AS 
		( 
			SELECT
			FeatureTypeDetailId,
			BaseFeatureTypeDetailId,
			'' + convert(varchar(max),BaseFeatureTypeDetailId), 
			Id, 
			ParentId, 
			Price,
			FeatureTypeDetailPriority
   
			FROM ViewProductFeature 
			WHERE ParentId = CONVERT(uniqueidentifier, @parentId) 
   
			UNION ALL
			SELECT
				vpf.FeatureTypeDetailId,
				vpf.BaseFeatureTypeDetailId,
				(convert(varchar(max),pft.BaseFeatureTypeDetailId) + @delimiter + convert(varchar(max), vpf.BaseFeatureTypeDetailId)) as DetailIdPath, 
				vpf.Id, 
				vpf.ParentId, 
				vpf.Price,
				vpf.FeatureTypeDetailPriority
	 
			FROM ViewProductFeature vpf, ViewProductFeatureTree pft 
			WHERE vpf.ParentId = pft.Id  and vpf.Price >= @minPrice and vpf.Price <= @maxPrice and vpf.FeatureTypeDetailPriority = @firstIconPriority
		) 
		  
		insert into @finalResult SELECT Id, DetailIdPath FROM ViewProductFeatureTree 
		  
		FETCH NEXT FROM ParentIdCursor INTO @parentId
	END

	CLOSE ParentIdCursor
	DEALLOCATE ParentIdCursor

	if len(@featureDetailCombinationList) > 0 
	begin
		select wsp.* from @finalResult fr 
		inner join ViewShopProduct wsp on fr.Id = wsp.Id
		WHERE  Exists  (select * from @featureDetailTable where detailId = DetailIdPath)
		end
	else
	begin
		select wsp.* from @finalResult fr 
		inner join ViewShopProduct wsp on fr.Id = wsp.Id
	 
	end
 
END
GO
/****** Object:  StoredProcedure [dbo].[SpGetProductFeaturesByProductFilter]    Script Date: 3/7/2021 8:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SpGetProductFeaturesByProductFilter] 
	
	  @featureDetailCombination nvarchar(max),
	  @delimiter varchar(max),
	  @parentId nvarchar(max),
	  @minPrice Decimal(18,2),
	  @maxPrice Decimal(18,2)
 as

BEGIN
	SET NOCOUNT ON;
	DECLARE @finalResult TABLE(Id uniqueidentifier not null, DetailIdPath nvarchar(max))
	
	declare @featureDetailTable table(detailId nvarchar(max)) 
	insert into @featureDetailTable SELECT * FROM dbo.SplitString(@featureDetailCombination, N',')
   
	;WITH  ViewProductFeatureTree (
									FeatureTypeDetailId,
									DetailIdPath,
									Id, 
									ParentId,
									Price,
									FeatureTypeDetailPriority
								) 
		AS 
		( 
			SELECT
			FeatureTypeDetailId,
			'' + convert(varchar(max),FeatureTypeDetailId), 
			Id, 
			ParentId, 
			Price,
			FeatureTypeDetailPriority
   
			FROM ViewProductFeature 
			WHERE ParentId = CONVERT(uniqueidentifier, @parentId) 
   
			UNION ALL
			SELECT
				vpf.FeatureTypeDetailId,
				(convert(varchar(max),pft.FeatureTypeDetailId) + @delimiter + convert(varchar(max), vpf.FeatureTypeDetailId)) as DetailIdPath, 
				vpf.Id, 
				vpf.ParentId, 
				vpf.Price,
				vpf.FeatureTypeDetailPriority
	 
			FROM ViewProductFeature vpf, ViewProductFeatureTree pft 
			WHERE vpf.ParentId = pft.Id  and vpf.Price >= @minPrice and vpf.Price <= @maxPrice  
		) 
		  
		insert into @finalResult SELECT Id, DetailIdPath FROM ViewProductFeatureTree 
		  
	 select wsp.* from @finalResult fr 
		inner join ViewShopProduct wsp on fr.Id = wsp.Id
		WHERE  Exists  (select * from @featureDetailTable where detailId = DetailIdPath)
	 
	 
 
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sum of products price' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Invoice', @level2type=N'COLUMN',@level2name=N'Subtotal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tax + Subtotal + Shipping' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Invoice', @level2type=N'COLUMN',@level2name=N'Total'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Final Payment amount after discount on total' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Invoice', @level2type=N'COLUMN',@level2name=N'AmountDue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Paid = 1,  Not Paid = 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Invoice', @level2type=N'COLUMN',@level2name=N'Finished'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Article States' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Message', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = Registered,
1 = ...,' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Order', @level2type=N'COLUMN',@level2name=N'State'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = Home Page,
1 = Tab Menu Item,
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SundryImage', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'New = 0,
 Discount = 1,
 Papular = 2,
 Category= 3,' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SundryImage', @level2type=N'COLUMN',@level2name=N'PackageItemType'
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
         Configuration = "(H (1[75] 4) )"
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
         Configuration = "(V (4) )"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 13
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CategoryField"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Category"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewCategoryField'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewCategoryField'
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
         Configuration = "(H (1[50] 4[25] 3) )"
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
         Configuration = "(H (1[47] 4) )"
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
      ActivePaneConfig = 1
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "BaseFeatureType"
            Begin Extent = 
               Top = 15
               Left = 341
               Bottom = 128
               Right = 511
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FeatureType"
            Begin Extent = 
               Top = 75
               Left = 49
               Bottom = 205
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1740
         Width = 1650
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1425
         Table = 1530
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewFeatureType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewFeatureType'
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
         Configuration = "(H (1[50] 4[25] 3) )"
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
         Configuration = "(H (1[66] 3) )"
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
         Configuration = "(H (1[75] 4) )"
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
      ActivePaneConfig = 4
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "FeatureTypeDetail"
            Begin Extent = 
               Top = 115
               Left = 43
               Bottom = 245
               Right = 260
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BaseFeatureTypeDetail"
            Begin Extent = 
               Top = 1
               Left = 527
               Bottom = 131
               Right = 714
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 2100
         Width = 1500
         Width = 2100
         Width = 1650
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 2130
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewFeatureTypeDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewFeatureTypeDetail'
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
         Begin Table = "Person_3"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 335
               Right = 238
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "Message"
            Begin Extent = 
               Top = 19
               Left = 435
               Bottom = 329
               Right = 609
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person_1"
            Begin Extent = 
               Top = 85
               Left = 738
               Bottom = 335
               Right = 938
            End
            DisplayFlags = 280
            TopColumn = 7
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewMessage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewMessage'
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
         Configuration = "(H (1[50] 4[25] 3) )"
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
         Configuration = "(H (4[50] 3) )"
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
         Configuration = "(H (1[19] 4) )"
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
         Configuration = "(V (4) )"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 9
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Order"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 218
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ProductFeature"
            Begin Extent = 
               Top = 167
               Left = 538
               Bottom = 385
               Right = 731
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Product"
            Begin Extent = 
               Top = 215
               Left = 412
               Bottom = 345
               Right = 584
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "Invoice"
            Begin Extent = 
               Top = 11
               Left = 38
               Bottom = 325
               Right = 209
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "Image"
            Begin Extent = 
               Top = 44
               Left = 696
               Bottom = 174
               Right = 876
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2310
         Alias = 1290
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewOrder'
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
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Person"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 238
            End
            DisplayFlags = 280
            TopColumn = 15
         End
         Begin Table = "AspNetUsers"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AspNetUserRoles"
            Begin Extent = 
               Top = 6
               Left = 276
               Bottom = 102
               Right = 446
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AspNetRoles"
            Begin Extent = 
               Top = 102
               Left = 276
               Bottom = 198
               Right = 446
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Country"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 208
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Ali' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewPersonInRole'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'as = 900
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewPersonInRole'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewPersonInRole'
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
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[56] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[66] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4[50] 3) )"
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
         Configuration = "(H (1[13] 4) )"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[29] 2) )"
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
         Configuration = "(V (4) )"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2) )"
      End
      ActivePaneConfig = 13
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Category"
            Begin Extent = 
               Top = 207
               Left = 24
               Bottom = 343
               Right = 194
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Product"
            Begin Extent = 
               Top = 98
               Left = 442
               Bottom = 331
               Right = 614
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "QuantityUnit"
            Begin Extent = 
               Top = 90
               Left = 715
               Bottom = 280
               Right = 885
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 19
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2400
         Alias = 1725
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewProduct'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewProduct'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewProduct'
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
         Configuration = "(H (1[21] 4[56] 3) )"
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
         Configuration = "(H (1[58] 4) )"
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
      ActivePaneConfig = 1
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Category"
            Begin Extent = 
               Top = 30
               Left = 271
               Bottom = 160
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CategoryField"
            Begin Extent = 
               Top = 13
               Left = 30
               Bottom = 143
               Right = 200
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Product"
            Begin Extent = 
               Top = 54
               Left = 471
               Bottom = 299
               Right = 643
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ProductCategoryField"
            Begin Extent = 
               Top = 30
               Left = 676
               Bottom = 143
               Right = 848
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1425
         Table = 1950
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewProductCategoryField'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewProductCategoryField'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewProductCategoryField'
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
         Configuration = "(H (1[64] 4[15] 3) )"
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
         Configuration = "(H (1[56] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4[72] 3) )"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3) )"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[20] 4) )"
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
         Configuration = "(V (4) )"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 4
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "BaseFeatureType"
            Begin Extent = 
               Top = 12
               Left = 26
               Bottom = 125
               Right = 196
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FeatureTypeDetail"
            Begin Extent = 
               Top = 20
               Left = 482
               Bottom = 160
               Right = 652
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FeatureType"
            Begin Extent = 
               Top = 23
               Left = 235
               Bottom = 162
               Right = 405
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BaseFeatureTypeDetail"
            Begin Extent = 
               Top = 286
               Left = 161
               Bottom = 416
               Right = 348
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ProductFeature"
            Begin Extent = 
               Top = 11
               Left = 730
               Bottom = 270
               Right = 923
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Product"
            Begin Extent = 
               Top = 23
               Left = 1013
               Bottom = 261
               Right = 1185
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 18
     ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewProductFeature'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 4230
         Alias = 2775
         Table = 1620
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewProductFeature'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewProductFeature'
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
         Configuration = "(H (1[50] 4[25] 3) )"
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
         Configuration = "(H (1[56] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4[50] 3) )"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3) )"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[26] 4) )"
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
         Configuration = "(V (4) )"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2) )"
      End
      ActivePaneConfig = 8
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = -31
      End
      Begin Tables = 
         Begin Table = "BaseFeatureType"
            Begin Extent = 
               Top = 385
               Left = 661
               Bottom = 498
               Right = 831
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FeatureTypeDetail"
            Begin Extent = 
               Top = 118
               Left = 553
               Bottom = 261
               Right = 723
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FeatureType"
            Begin Extent = 
               Top = 244
               Left = 901
               Bottom = 357
               Right = 1071
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BaseFeatureTypeDetail"
            Begin Extent = 
               Top = 376
               Left = 329
               Bottom = 506
               Right = 516
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ProductFeature"
            Begin Extent = 
               Top = 21
               Left = 297
               Bottom = 279
               Right = 490
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Product"
            Begin Extent = 
               Top = 2
               Left = 847
               Bottom = 225
               Right = 1019
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "Category"
            Begin Extent = 
               Top = 52
               Left = 1174
               Bottom = 182
               Right =' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewProductFeatureFullInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' 1344
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Image"
            Begin Extent = 
               Top = 258
               Left = 29
               Bottom = 435
               Right = 209
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 22
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1770
         Alias = 2190
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewProductFeatureFullInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewProductFeatureFullInfo'
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
         Configuration = "(H (1[50] 4[25] 3) )"
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
         Configuration = "(H (1[56] 3) )"
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
         Configuration = "(V (3) )"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[39] 4) )"
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
      ActivePaneConfig = 4
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Image"
            Begin Extent = 
               Top = 9
               Left = 9
               Bottom = 176
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ProductFeature"
            Begin Extent = 
               Top = 41
               Left = 266
               Bottom = 297
               Right = 459
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FeatureTypeDetail"
            Begin Extent = 
               Top = 33
               Left = 554
               Bottom = 174
               Right = 724
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FeatureType"
            Begin Extent = 
               Top = 50
               Left = 805
               Bottom = 196
               Right = 975
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Product"
            Begin Extent = 
               Top = 193
               Left = 14
               Bottom = 438
               Right = 186
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "Category"
            Begin Extent = 
               Top = 314
               Left = 266
               Bottom = 468
               Right = 436
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BaseFeatureType"
            Begin Extent = 
               Top = 119
               Left = 1030
               Bottom = 232
               Right = 1200
            End
  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewShopProduct'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'          DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BaseFeatureTypeDetail"
            Begin Extent = 
               Top = 288
               Left = 764
               Bottom = 418
               Right = 951
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 26
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 2505
         Alias = 2190
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewShopProduct'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewShopProduct'
GO
