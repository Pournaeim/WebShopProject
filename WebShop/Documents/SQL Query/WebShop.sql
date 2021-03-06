USE [WebShop]
GO
/****** Object:  Table [dbo].[Journal]    Script Date: 10/24/2018 2:06:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Journal](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[SubjectId] [int] NULL,
	[ImageUrl] [nvarchar](max) NULL,
	[DisplayByDefault] [bit] NULL,
	[Priority] [nvarchar](max) NULL,
	[Type] [tinyint] NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Magazins] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 10/24/2018 2:06:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
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
	[ORCID] [nvarchar](max) NULL,
	[ProfilePictureUrl] [nvarchar](max) NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ArticleAuthor]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArticleAuthor](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AuthorId] [nvarchar](128) NOT NULL,
	[ArticleId] [int] NOT NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_ArticleAuthor] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ArticleEditor]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArticleEditor](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ArticleId] [int] NOT NULL,
	[EditorId] [nvarchar](128) NOT NULL,
	[ArticleEditState] [int] NOT NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_ArticlesEditors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubjectField]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubjectField](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[JournalId] [int] NOT NULL,
 CONSTRAINT [PK_JournalArea] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ArticleType]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArticleType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_ArticleType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Article]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Article](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ArticleTypeId] [int] NULL,
	[ArticleCode] [nvarchar](max) NULL,
	[ArticleCodeCounter] [int] NOT NULL,
	[ArticleTitle] [nvarchar](max) NOT NULL,
	[Abstract] [nvarchar](max) NOT NULL,
	[ISSNDOI] [nvarchar](max) NULL,
	[Keywords] [nvarchar](max) NOT NULL,
	[JournalId] [int] NULL,
	[FieldId] [int] NULL,
	[ArticleUrl] [nvarchar](max) NULL,
	[ArticleState] [int] NULL,
	[ArticleStateUpdateDate] [datetime] NULL,
	[VisitCount] [int] NULL,
	[DownloadCount] [int] NULL,
	[EditorVersionUrl] [nvarchar](max) NULL,
	[UploadDate] [datetime] NULL,
	[Restricted] [bit] NULL,
	[Description] [nvarchar](max) NULL,
	[ImageUrl] [nvarchar](max) NULL,
	[Deleted] [bit] NULL,
	[CheckListUrl] [nvarchar](max) NULL,
	[OtherAuthorNames] [nvarchar](max) NULL,
	[OtherAuthorEmails] [nvarchar](max) NULL,
	[AssistantOtherAuthors] [nvarchar](max) NULL,
	[DOI] [nvarchar](max) NULL,
	[SuggestedReviewerNames] [nvarchar](max) NULL,
	[SuggestedReviewerEmails] [nvarchar](max) NULL,
	[PublishDate] [datetime] NULL,
 CONSTRAINT [PK_Article] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewArticleEditor]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewArticleEditor]
AS
SELECT DISTINCT 
                         dbo.ArticleEditor.Id, dbo.Article.Id AS ArticleId, dbo.Article.ArticleCode, dbo.Article.ArticleTitle, dbo.Article.ArticleState, dbo.ArticleEditor.ArticleEditState, dbo.Article.ArticleStateUpdateDate, dbo.Journal.Id AS JournalId, 
                         dbo.Article.ImageUrl, dbo.Article.VisitCount, dbo.Journal.Name AS Journal, dbo.Article.ArticleUrl, dbo.ArticleAuthor.AuthorId, dbo.Article.DownloadCount, CONVERT(nvarchar(512), N'') AS ArticleStateDesc, 
                         dbo.Article.EditorVersionUrl, dbo.Article.UploadDate, Person_2.UserId AS AuthorUserId, Person_2.LastName + N' ' + Person_2.FirstName AS AuthorName, dbo.Article.ArticleCodeCounter, dbo.Article.Restricted, 
                         dbo.Article.Description, dbo.ArticleEditor.EditorId, dbo.Article.Deleted, CONVERT(nvarchar(512), N'') AS ArticleEditStateDesc, Person_1.LastName + N' ' + Person_1.FirstName AS Editor, CONVERT(nvarchar(36), N'') 
                         AS CheckListUrlId, dbo.Journal.SubjectId, dbo.Article.ArticleTypeId, dbo.Article.Abstract, dbo.Article.ISSNDOI, dbo.Article.Keywords, dbo.Article.OtherAuthorNames, dbo.Article.OtherAuthorEmails, dbo.Article.AssistantOtherAuthors, 
                         dbo.Article.DOI, dbo.Article.SuggestedReviewerNames, dbo.Article.SuggestedReviewerEmails, dbo.ArticleType.Name AS ArticleType, dbo.Article.FieldId, dbo.SubjectField.Name AS Field, 
                         Person_1.LastName + N' ' + Person_1.FirstName AS Reviewer
FROM            dbo.Person AS Person_1 RIGHT OUTER JOIN
                         dbo.ArticleEditor INNER JOIN
                         dbo.ArticleType INNER JOIN
                         dbo.Journal INNER JOIN
                         dbo.Article ON dbo.Journal.Id = dbo.Article.JournalId INNER JOIN
                         dbo.ArticleAuthor ON dbo.Article.Id = dbo.ArticleAuthor.ArticleId ON dbo.ArticleType.Id = dbo.Article.ArticleTypeId ON dbo.ArticleEditor.ArticleId = dbo.Article.Id INNER JOIN
                         dbo.SubjectField ON dbo.Article.FieldId = dbo.SubjectField.Id LEFT OUTER JOIN
                         dbo.Person AS Person_2 ON dbo.ArticleAuthor.AuthorId = Person_2.UserId ON Person_1.UserId = dbo.ArticleEditor.EditorId
WHERE        (dbo.Article.Deleted <> 1) OR
                         (dbo.Article.Deleted IS NULL)
GO
/****** Object:  Table [dbo].[Subject]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subject](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ParentId] [int] NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_Subjects_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ArticleReviewer]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArticleReviewer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ArticleId] [int] NOT NULL,
	[ReviewerId] [nvarchar](128) NOT NULL,
	[ArticleReviewState] [int] NULL,
	[CheckListUrl] [nvarchar](max) NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_ArticlesReviewers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewArticleReviewer]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewArticleReviewer]
AS
SELECT DISTINCT 
                         dbo.ArticleReviewer.Id, dbo.Article.Id AS ArticleId, dbo.Article.ArticleTitle, dbo.Article.ArticleCode, dbo.Article.ArticleState, dbo.ArticleReviewer.ArticleReviewState, dbo.Article.ArticleStateUpdateDate, dbo.Article.ArticleUrl, 
                         dbo.Article.JournalId, dbo.Article.Keywords, dbo.Article.ISSNDOI, dbo.ArticleReviewer.ReviewerId, dbo.Journal.Name AS Journal, dbo.Person.UserId, dbo.Person.LastName + N' ' + dbo.Person.FirstName AS ReviewerName, 
                         dbo.Person.MobilePhone, dbo.Person.Tel, dbo.Person.Identifier, dbo.Person.Sex, dbo.Person.BirthDate, dbo.Person.AcademicInfoNames, dbo.Subject.Name AS Subject, CONVERT(nvarchar(512), N'') AS ArticleStateDesc, 
                         dbo.Article.EditorVersionUrl, dbo.ArticleAuthor.AuthorId, CONVERT(nvarchar(512), N'') AS ArticleReviewStateDesc, dbo.Article.UploadDate, dbo.Article.ArticleCodeCounter, dbo.Article.Restricted, dbo.Article.Description, 
                         dbo.Article.ImageUrl, dbo.Article.Deleted, dbo.Journal.SubjectId, dbo.Article.SuggestedReviewerEmails, dbo.Article.SuggestedReviewerNames, dbo.Article.DOI, dbo.Article.AssistantOtherAuthors, dbo.Article.OtherAuthorEmails, 
                         dbo.Article.OtherAuthorNames, dbo.Article.CheckListUrl, dbo.Article.DownloadCount, dbo.Article.VisitCount, dbo.Article.Abstract, dbo.Article.ArticleTypeId, dbo.ArticleType.Name AS ArticleType, dbo.Person.StreetLine1, 
                         dbo.Person.StreetLine2, dbo.Person.City, dbo.Person.State, dbo.Article.FieldId, dbo.SubjectField.Name AS Field
FROM            dbo.ArticleReviewer INNER JOIN
                         dbo.Article ON dbo.ArticleReviewer.ArticleId = dbo.Article.Id INNER JOIN
                         dbo.Person ON dbo.ArticleReviewer.ReviewerId = dbo.Person.UserId INNER JOIN
                         dbo.ArticleType ON dbo.Article.ArticleTypeId = dbo.ArticleType.Id INNER JOIN
                         dbo.Journal ON dbo.Article.JournalId = dbo.Journal.Id INNER JOIN
                         dbo.ArticleAuthor ON dbo.Article.Id = dbo.ArticleAuthor.ArticleId INNER JOIN
                         dbo.Subject ON dbo.Journal.SubjectId = dbo.Subject.Id INNER JOIN
                         dbo.SubjectField ON dbo.Article.FieldId = dbo.SubjectField.Id
WHERE        (dbo.Article.Deleted <> 1) OR
                         (dbo.Article.Deleted IS NULL)
GO
/****** Object:  Table [dbo].[Message]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Message](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ArticleId] [int] NULL,
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
/****** Object:  View [dbo].[ViewMessage]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewMessage]
AS
SELECT DISTINCT 
                         dbo.Message.Id, dbo.Article.ArticleCode, dbo.Article.ArticleTitle, dbo.Article.ArticleUrl, dbo.Article.ArticleState, dbo.Article.Keywords, dbo.Message.Sender, dbo.Message.Receiver, dbo.Message.MessageText, 
                         dbo.Message.OrderNumber, Person_1.LastName + N' ' + Person_1.FirstName AS SenderName, Person_1.MobilePhone AS SenderMobilePhone, Person_1.Tel AS SenderTel, 
                         Person_3.LastName + N' ' + Person_3.FirstName AS ReceiverName, Person_3.MobilePhone AS ReceiverMobilePhone, Person_3.Tel AS ReceiverTel, dbo.Message.Title, dbo.Message.Visited, dbo.Message.Type, 
                         dbo.Article.Restricted, dbo.Article.UploadDate, dbo.Article.Description, dbo.Article.ImageUrl, dbo.Article.Deleted, dbo.Message.MessageDate, dbo.Message.ArticleId, dbo.Message.PublicUserEmail
FROM            dbo.Article RIGHT OUTER JOIN
                         dbo.Person AS Person_1 INNER JOIN
                         dbo.Message ON Person_1.UserId = dbo.Message.Sender INNER JOIN
                         dbo.Person AS Person_3 ON dbo.Message.Receiver = Person_3.UserId ON dbo.Article.Id = dbo.Message.ArticleId
WHERE        (dbo.Article.Deleted <> 1) OR
                         (dbo.Article.Deleted IS NULL)
GO
/****** Object:  View [dbo].[ViewReviewersCombinedResult]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewReviewersCombinedResult]
AS
SELECT        dbo.ViewMessage.Id, dbo.ViewMessage.ArticleId, dbo.ViewArticleEditor.EditorId, dbo.ViewArticleEditor.Editor, dbo.ViewArticleReviewer.ReviewerId, dbo.ViewArticleReviewer.ReviewerName AS Reviewer, 
                         dbo.ViewMessage.MessageText, dbo.ViewMessage.MessageDate, dbo.ViewMessage.ArticleState, dbo.ViewMessage.ArticleTitle, dbo.ViewMessage.ArticleCode, dbo.ViewMessage.Visited, dbo.ViewArticleReviewer.Journal, 
                         dbo.ViewMessage.Type, dbo.ViewMessage.ArticleUrl, dbo.ViewArticleReviewer.FieldId, dbo.ViewArticleReviewer.Field, dbo.ViewArticleReviewer.ArticleType, dbo.ViewArticleReviewer.DOI, 
                         dbo.ViewArticleReviewer.ArticleReviewState, dbo.ViewArticleReviewer.ArticleReviewStateDesc
FROM            dbo.ViewArticleEditor INNER JOIN
                         dbo.ViewArticleReviewer ON dbo.ViewArticleEditor.ArticleId = dbo.ViewArticleReviewer.ArticleId INNER JOIN
                         dbo.ViewMessage ON dbo.ViewArticleReviewer.ReviewerId = dbo.ViewMessage.Sender
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 10/24/2018 2:06:13 AM ******/
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
/****** Object:  View [dbo].[ViewArticle]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewArticle]
AS
SELECT DISTINCT 
                         dbo.Article.Id, dbo.Article.ArticleCode, dbo.Article.ArticleTitle, dbo.Article.ArticleUrl, dbo.Journal.Name AS Journal, dbo.ArticleAuthor.AuthorId, dbo.Article.DownloadCount, dbo.Article.VisitCount, dbo.Article.ArticleState, 
                         CONVERT(nvarchar(512), N'') AS ArticleStateDesc, dbo.Article.EditorVersionUrl, dbo.Article.UploadDate, dbo.Person.UserId AS AuthorUserId, dbo.Person.LastName + N' ' + dbo.Person.FirstName AS AuthorName, 
                         dbo.Article.ArticleCodeCounter, dbo.Article.Restricted, dbo.Article.Description, dbo.Article.ImageUrl, CONVERT(nvarchar(512), N'') AS FirstReviewer, CONVERT(nvarchar(512), N'') AS SecondReviewer, CONVERT(nvarchar(512), 
                         N'') AS ThirdReviewer, dbo.Article.Deleted, CONVERT(nvarchar(36), N'') AS CheckListUrlId, CONVERT(nvarchar(36), N'') AS FirstReviewerId, CONVERT(nvarchar(36), N'') AS SecondReviewerId, CONVERT(nvarchar(36), N'') 
                         AS ThirdReviewerId, dbo.Article.CheckListUrl, dbo.Article.OtherAuthorNames, dbo.Article.AssistantOtherAuthors, CONVERT(bit, 0) AS Accepted2Reviewer, dbo.Article.DOI, dbo.AspNetUsers.Email, dbo.Journal.SubjectId, 
                         dbo.Article.JournalId, dbo.Article.SuggestedReviewerEmails, dbo.Article.ArticleTypeId, dbo.Article.OtherAuthorEmails, dbo.Article.SuggestedReviewerNames, dbo.Article.Keywords, dbo.Article.Abstract, dbo.Article.ISSNDOI, 
                         dbo.ArticleType.Name AS ArticleType, dbo.Article.PublishDate, dbo.Person.FirstName, dbo.Person.LastName, dbo.Person.AcademicInfoNames, dbo.Person.AcademicInfoValues, dbo.Article.FieldId, 
                         dbo.SubjectField.Name AS Field
FROM            dbo.ArticleType INNER JOIN
                         dbo.Journal INNER JOIN
                         dbo.ArticleAuthor INNER JOIN
                         dbo.Article ON dbo.ArticleAuthor.ArticleId = dbo.Article.Id ON dbo.Journal.Id = dbo.Article.JournalId ON dbo.ArticleType.Id = dbo.Article.ArticleTypeId INNER JOIN
                         dbo.AspNetUsers INNER JOIN
                         dbo.Person ON dbo.AspNetUsers.Id = dbo.Person.UserId ON dbo.ArticleAuthor.AuthorId = dbo.Person.UserId INNER JOIN
                         dbo.SubjectField ON dbo.Article.FieldId = dbo.SubjectField.Id
WHERE        (dbo.Article.Deleted <> 1) OR
                         (dbo.Article.Deleted IS NULL)
GO
/****** Object:  Table [dbo].[ArticleAccessRight]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArticleAccessRight](
	[Id] [int] NOT NULL,
	[ArticleId] [int] NOT NULL,
	[PersonId] [int] NOT NULL,
	[AccessRight] [tinyint] NOT NULL,
 CONSTRAINT [PK_ArticleAccessRights] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewArticlePersonAccessRight]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewArticlePersonAccessRight]
AS
SELECT        dbo.ArticleAccessRight.Id, dbo.Person.Id AS PersonIn, dbo.ArticleAccessRight.ArticleId, dbo.ArticleAccessRight.PersonId, dbo.ArticleAccessRight.AccessRight, dbo.ViewArticle.ArticleCode, dbo.ViewArticle.ArticleTitle, 
                         dbo.ViewArticle.ArticleUrl, dbo.ViewArticle.Journal, dbo.ViewArticle.JournalId, dbo.ViewArticle.AuthorId, dbo.ViewArticle.SubjectId, dbo.ViewArticle.DownloadCount, dbo.ViewArticle.VisitCount, dbo.ViewArticle.ArticleState, 
                         dbo.ViewArticle.ArticleStateDesc, dbo.ViewArticle.EditorVersionUrl, dbo.ViewArticle.UploadDate, dbo.ViewArticle.AuthorUserId, dbo.ViewArticle.AuthorName, dbo.ViewArticle.ArticleCodeCounter, dbo.Person.UserId, 
                         dbo.Person.LastName + N' ' + dbo.Person.FirstName AS Name, CONVERT(nvarchar(20), N'') AS AccessRightDescription, dbo.ViewArticle.Restricted, dbo.ViewArticle.Description, dbo.ViewArticle.ImageUrl, dbo.ViewArticle.Deleted, 
                         dbo.Person.AcademicInfoNames, dbo.Person.AcademicInfoValues
FROM            dbo.ViewArticle INNER JOIN
                         dbo.ArticleAccessRight ON dbo.ViewArticle.Id = dbo.ArticleAccessRight.ArticleId INNER JOIN
                         dbo.Person ON dbo.ArticleAccessRight.PersonId = dbo.Person.Id
WHERE        (dbo.ViewArticle.Deleted <> 1) OR
                         (dbo.ViewArticle.Deleted IS NULL)
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 10/24/2018 2:06:13 AM ******/
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
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 10/24/2018 2:06:13 AM ******/
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
/****** Object:  View [dbo].[ViewPersonInRole]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewPersonInRole]
AS
SELECT        dbo.Person.LastName + N' ' + dbo.Person.FirstName AS Name, dbo.Person.Identifier, dbo.Person.Sex, dbo.Person.BirthDate, dbo.Person.AcademicInfoNames, dbo.Person.UserId, dbo.Person.Id, 
                         dbo.Person.AcademicInfoValues, dbo.AspNetUsers.UserName, dbo.AspNetUsers.Email, dbo.AspNetUsers.RegisterDate, dbo.AspNetRoles.Name AS RoleName, dbo.AspNetUserRoles.RoleId, dbo.AspNetUsers.UserDefiner, 
                         dbo.AspNetUsers.LastSignIn, dbo.Person.StreetLine1, dbo.Person.StreetLine2, dbo.Person.City, dbo.Person.State, dbo.Person.ZipCode, dbo.Person.ProfilePictureUrl, dbo.Person.FirstName, dbo.Person.LastName, 
                         dbo.AspNetUsers.PhoneNumber, dbo.Person.ORCID
FROM            dbo.Person INNER JOIN
                         dbo.AspNetUsers ON dbo.Person.UserId = dbo.AspNetUsers.Id INNER JOIN
                         dbo.AspNetUserRoles ON dbo.AspNetUsers.Id = dbo.AspNetUserRoles.UserId INNER JOIN
                         dbo.AspNetRoles ON dbo.AspNetUserRoles.RoleId = dbo.AspNetRoles.Id
GO
/****** Object:  View [dbo].[ViewReviewerKnownEditor]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewReviewerKnownEditor]
AS
SELECT        dbo.ArticleEditor.ArticleId, dbo.ArticleReviewer.ReviewerId, dbo.ViewPersonInRole.UserName, dbo.ViewPersonInRole.Name, dbo.ViewPersonInRole.RoleId, dbo.ViewPersonInRole.RoleName, dbo.ViewPersonInRole.UserId, 
                         dbo.ViewPersonInRole.Id
FROM            dbo.ArticleEditor INNER JOIN
                         dbo.ArticleReviewer ON dbo.ArticleEditor.ArticleId = dbo.ArticleReviewer.ArticleId INNER JOIN
                         dbo.ViewPersonInRole ON dbo.ArticleEditor.EditorId = dbo.ViewPersonInRole.Id
WHERE        (dbo.ViewPersonInRole.RoleId = 'da581de4-1f6d-4cdf-bae1-861cf666aa5a')
GO
/****** Object:  Table [dbo].[UserDefiner]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserDefiner](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DefinerId] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_UserDefiner] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewArticleAssistant]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewArticleAssistant]
AS
SELECT DISTINCT 
                         dbo.Article.Id, dbo.Article.ArticleCode, dbo.Article.ArticleTitle, dbo.Article.ArticleUrl, dbo.Journal.Name AS Journal, dbo.Journal.Id AS JournalId, dbo.ArticleAuthor.AuthorId, dbo.Article.DownloadCount, dbo.Article.VisitCount, 
                         dbo.Article.ImageUrl, dbo.Article.ArticleState, CONVERT(nvarchar(512), N'') AS ArticleStateDesc, dbo.Article.EditorVersionUrl, dbo.Article.UploadDate, dbo.Person.UserId AS AuthorUserId, 
                         dbo.Person.LastName + N' ' + dbo.Person.FirstName AS AuthorName, dbo.Article.ArticleCodeCounter, dbo.Article.Restricted, dbo.Article.Description, dbo.Journal.ImageUrl AS JournalInstanceImage, CONVERT(nvarchar(512), N'') 
                         AS FirstReviewer, CONVERT(nvarchar(512), N'') AS SecondReviewer, CONVERT(nvarchar(512), N'') AS ThirdReviewer, dbo.Article.Deleted, dbo.ArticleEditor.EditorId, CONVERT(nvarchar(36), N'') AS CheckListUrlId, 
                         CONVERT(nvarchar(36), N'') AS FirstReviewerId, CONVERT(nvarchar(36), N'') AS SecondReviewerId, CONVERT(nvarchar(36), N'') AS ThirdReviewerId, dbo.Article.CheckListUrl, dbo.Article.OtherAuthorNames, 
                         dbo.Article.AssistantOtherAuthors, CONVERT(bit, 0) AS Accepted2Reviewer, dbo.ArticleEditor.ArticleEditState, dbo.Article.DOI, dbo.AspNetUsers.Email AS AuthorEmail, dbo.Journal.SubjectId, dbo.Article.OtherAuthorEmails, 
                         dbo.UserDefiner.DefinerId, dbo.Journal.Priority, dbo.Article.ArticleStateUpdateDate, dbo.Article.Keywords, dbo.Article.ISSNDOI, dbo.Article.Abstract, dbo.Article.SuggestedReviewerNames, dbo.Article.SuggestedReviewerEmails, 
                         dbo.Article.ArticleTypeId, dbo.ArticleType.Name AS ArticleType, dbo.Article.PublishDate, dbo.Article.FieldId, dbo.SubjectField.Name AS Field
FROM            dbo.AspNetUsers INNER JOIN
                         dbo.Person ON dbo.AspNetUsers.Id = dbo.Person.UserId INNER JOIN
                         dbo.ArticleType INNER JOIN
                         dbo.Journal INNER JOIN
                         dbo.ArticleAuthor INNER JOIN
                         dbo.Article ON dbo.ArticleAuthor.ArticleId = dbo.Article.Id ON dbo.Journal.Id = dbo.Article.JournalId INNER JOIN
                         dbo.ArticleEditor ON dbo.Article.Id = dbo.ArticleEditor.ArticleId ON dbo.ArticleType.Id = dbo.Article.ArticleTypeId ON dbo.Person.UserId = dbo.ArticleAuthor.AuthorId INNER JOIN
                         dbo.SubjectField ON dbo.Article.FieldId = dbo.SubjectField.Id INNER JOIN
                         dbo.UserDefiner ON dbo.ArticleEditor.EditorId = dbo.UserDefiner.UserId
WHERE        (dbo.Article.Deleted <> 1) OR
                         (dbo.Article.Deleted IS NULL)
GO
/****** Object:  Table [dbo].[JournalUser]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JournalUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[JournalId] [int] NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_MagazinsUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JournalUserActiveField]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JournalUserActiveField](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[JournalUserId] [int] NOT NULL,
	[SubjectFieldId] [int] NOT NULL,
 CONSTRAINT [PK_JournalUserActiveField] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewArticleEditorInChief]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewArticleEditorInChief]
AS
SELECT DISTINCT 
                         dbo.Article.Id, dbo.Article.ArticleCode, dbo.Article.ArticleTitle, dbo.Article.ArticleState, dbo.ArticleEditor.ArticleEditState, dbo.ArticleReviewer.ArticleReviewState, dbo.Article.ArticleUrl, dbo.Journal.Name AS Journal, 
                         dbo.Journal.Id AS JournalId, dbo.ArticleAuthor.AuthorId, dbo.Subject.Name AS Subject, dbo.Article.DownloadCount, dbo.Article.VisitCount, dbo.Article.ImageUrl, CONVERT(nvarchar(512), N'') AS ArticleStateDesc, 
                         dbo.Article.EditorVersionUrl, dbo.Article.UploadDate, dbo.Person.LastName + N' ' + dbo.Person.FirstName AS AuthorName, dbo.Article.ArticleCodeCounter, dbo.Person.Id AS PersonId, dbo.Article.Restricted, 
                         dbo.Article.Description, dbo.Article.Deleted, dbo.Journal.SubjectId, dbo.Article.Abstract, dbo.Article.ISSNDOI, dbo.Article.Keywords, dbo.Article.OtherAuthorNames, dbo.Article.OtherAuthorEmails, dbo.Article.AssistantOtherAuthors, 
                         dbo.Article.DOI, dbo.Article.SuggestedReviewerNames, dbo.Article.SuggestedReviewerEmails, dbo.Article.ArticleTypeId, dbo.ArticleType.Name AS ArticleType, dbo.JournalUser.UserId, dbo.Article.FieldId, 
                         dbo.SubjectField.Name AS Field, dbo.AspNetUsers.Email, dbo.AspNetUsers.UserName
FROM            dbo.ArticleType INNER JOIN
                         dbo.ArticleAuthor INNER JOIN
                         dbo.Article INNER JOIN
                         dbo.Journal ON dbo.Article.JournalId = dbo.Journal.Id INNER JOIN
                         dbo.Subject ON dbo.Journal.SubjectId = dbo.Subject.Id ON dbo.ArticleAuthor.ArticleId = dbo.Article.Id ON dbo.ArticleType.Id = dbo.Article.ArticleTypeId INNER JOIN
                         dbo.Person ON dbo.ArticleAuthor.AuthorId = dbo.Person.UserId INNER JOIN
                         dbo.JournalUser ON dbo.Journal.Id = dbo.JournalUser.JournalId INNER JOIN
                         dbo.JournalUserActiveField ON dbo.JournalUser.Id = dbo.JournalUserActiveField.JournalUserId AND dbo.Article.FieldId = dbo.JournalUserActiveField.SubjectFieldId INNER JOIN
                         dbo.SubjectField ON dbo.JournalUserActiveField.SubjectFieldId = dbo.SubjectField.Id INNER JOIN
                         dbo.AspNetUsers ON dbo.JournalUser.UserId = dbo.AspNetUsers.Id LEFT OUTER JOIN
                         dbo.ArticleReviewer ON dbo.Article.Id = dbo.ArticleReviewer.ArticleId LEFT OUTER JOIN
                         dbo.ArticleEditor ON dbo.Article.Id = dbo.ArticleEditor.ArticleId
WHERE        (dbo.Article.Deleted <> 1) OR
                         (dbo.Article.Deleted IS NULL)
GO
/****** Object:  View [dbo].[ViewAuthorEditorChiefEditorInJournal]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewAuthorEditorChiefEditorInJournal]
AS
SELECT DISTINCT TOP (100) PERCENT dbo.Person.UserId, dbo.Person.FirstName + ' ' + dbo.Person.LastName AS Name, dbo.JournalUser.JournalId
FROM            dbo.Person INNER JOIN
                         dbo.Journal INNER JOIN
                         dbo.JournalUser ON dbo.Journal.Id = dbo.JournalUser.JournalId ON dbo.Person.UserId = dbo.JournalUser.UserId
UNION
SELECT DISTINCT TOP (100) PERCENT Person_2.UserId, Person_2.FirstName + ' ' + Person_2.LastName AS Name, dbo.Article.JournalId
FROM            dbo.Article INNER JOIN
                         dbo.ArticleAuthor ON dbo.Article.Id = dbo.ArticleAuthor.ArticleId INNER JOIN
                         dbo.Person AS Person_2 ON dbo.ArticleAuthor.AuthorId = Person_2.UserId
UNION
SELECT DISTINCT TOP (100) PERCENT Person_1.UserId, Person_1.FirstName + ' ' + Person_1.LastName AS Name, Articles_1.JournalId
FROM            dbo.Article AS Articles_1 INNER JOIN
                         dbo.ArticleEditor ON Articles_1.Id = dbo.ArticleEditor.ArticleId INNER JOIN
                         dbo.Person AS Person_1 ON dbo.ArticleEditor.EditorId = Person_1.UserId
GO
/****** Object:  View [dbo].[ViewEditorByAuthor]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewEditorByAuthor]
AS
SELECT DISTINCT TOP (100) PERCENT dbo.Person.Id, dbo.ArticleAuthor.AuthorId, dbo.Person.FirstName + N' ' + dbo.Person.LastName AS Name
FROM            dbo.ArticleAuthor INNER JOIN
                         dbo.ArticleEditor ON dbo.ArticleAuthor.ArticleId = dbo.ArticleEditor.ArticleId INNER JOIN
                         dbo.Person ON dbo.ArticleEditor.EditorId = dbo.Person.Id
GO
/****** Object:  View [dbo].[ViewEditorJournal]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewEditorJournal]
AS
SELECT DISTINCT dbo.Person.Id, dbo.Person.FirstName + ' ' + dbo.Person.LastName AS Name, dbo.Article.JournalId, dbo.JournalUser.UserId
FROM            dbo.ArticleEditor INNER JOIN
                         dbo.Article ON dbo.ArticleEditor.ArticleId = dbo.Article.Id INNER JOIN
                         dbo.Person ON dbo.ArticleEditor.EditorId = dbo.Person.UserId INNER JOIN
                         dbo.JournalUser ON dbo.Person.UserId = dbo.JournalUser.UserId
GO
/****** Object:  Table [dbo].[Attachment]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attachment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ArticleId] [int] NULL,
	[Description] [nvarchar](max) NULL,
	[AttachUrl] [nvarchar](max) NULL,
	[UploaderId] [int] NULL,
	[UploadDate] [datetime] NULL,
 CONSTRAINT [PK_Attachment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewEditorSendMessageUploadFile]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewEditorSendMessageUploadFile]
AS
SELECT        dbo.Message.Id, dbo.Article.ArticleCode, dbo.Article.ArticleTitle, dbo.Article.Abstract, dbo.Article.ArticleUrl, dbo.Article.ArticleState, dbo.Article.Keywords, dbo.ArticleAuthor.AuthorId, dbo.Message.Sender, dbo.Message.Receiver, 
                         dbo.Message.MessageText, dbo.Message.OrderNumber, dbo.ArticleReviewer.ReviewerId, dbo.Person.FirstName AS AuthorFirstName, dbo.Person.LastName AS AuthorLastName, 
                         dbo.Person.MobilePhone AS AuthorMobilePhone, dbo.Person.Tel AS AuthorTel, Person_2.FirstName AS ReviewerFirstName, Person_2.LastName AS ReviewerLastName, Person_2.MobilePhone AS ReviewerMobilePhone, 
                         Person_2.Tel AS ReviewerTel, Person_1.FirstName AS SenderFirstName, Person_1.LastName AS SenderLastName, Person_1.MobilePhone AS SenderMobilePhone, Person_1.Tel AS SenderTel, 
                         Person_3.FirstName AS ReceiverFirstName, Person_3.LastName AS ReceiverLastName, Person_3.MobilePhone AS ReceiverMobilePhone, Person_3.Tel AS ReceiverTel, dbo.Message.Title, dbo.Message.ArticleId, 
                         dbo.Message.Visited, dbo.Message.Type, dbo.Article.EditorVersionUrl AS Expr1, dbo.Attachment.AttachUrl, dbo.Attachment.Description AS AttachmentDescription, dbo.Article.EditorVersionUrl, 
                         dbo.ArticleReviewer.ArticleReviewState, dbo.Article.JournalId, dbo.Article.ArticleCodeCounter, dbo.Article.Restricted, dbo.Article.UploadDate, dbo.Article.Description, dbo.Article.ImageUrl, dbo.Article.Deleted, 
                         dbo.ArticleReviewer.CheckListUrl
FROM            dbo.Article INNER JOIN
                         dbo.Attachment ON dbo.Article.Id = dbo.Attachment.ArticleId RIGHT OUTER JOIN
                         dbo.Person INNER JOIN
                         dbo.ArticleAuthor ON dbo.Person.Id = dbo.ArticleAuthor.AuthorId RIGHT OUTER JOIN
                         dbo.Person AS Person_3 INNER JOIN
                         dbo.Message ON Person_3.Id = dbo.Message.Receiver INNER JOIN
                         dbo.Person AS Person_1 ON dbo.Message.Sender = Person_1.Id ON dbo.ArticleAuthor.ArticleId = dbo.Message.ArticleId LEFT OUTER JOIN
                         dbo.Person AS Person_2 INNER JOIN
                         dbo.ArticleReviewer ON Person_2.Id = dbo.ArticleReviewer.ReviewerId ON dbo.Message.ArticleId = dbo.ArticleReviewer.ArticleId ON dbo.Article.Id = dbo.Message.ArticleId
WHERE        (dbo.Article.Deleted <> 1) OR
                         (dbo.Article.Deleted IS NULL)
GO
/****** Object:  View [dbo].[ViewJournal]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewJournal]
AS
SELECT DISTINCT dbo.Journal.Id, dbo.Journal.Name, dbo.Journal.SubjectId, dbo.Subject.Name AS Subject, dbo.Journal.Priority, dbo.Journal.ImageUrl, dbo.Journal.Description, dbo.Journal.DisplayByDefault
FROM            dbo.Subject INNER JOIN
                         dbo.Journal ON dbo.Subject.Id = dbo.Journal.SubjectId
GO
/****** Object:  View [dbo].[ViewSubjectField]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewSubjectField]
AS
SELECT        dbo.SubjectField.Id, dbo.SubjectField.JournalId, dbo.SubjectField.Name, dbo.Journal.Name AS Journal, dbo.Journal.SubjectId
FROM            dbo.SubjectField INNER JOIN
                         dbo.Journal ON dbo.SubjectField.JournalId = dbo.Journal.Id
GO
/****** Object:  Table [dbo].[JournalPage]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JournalPage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[JournalId] [int] NOT NULL,
	[Caption] [nvarchar](max) NULL,
	[HTMLContent] [nvarchar](max) NULL,
	[Priority] [int] NOT NULL,
 CONSTRAINT [PK_JornalWebPages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewJournalPage]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewJournalPage]
AS
SELECT        dbo.JournalPage.Id, dbo.JournalPage.JournalId, dbo.JournalPage.Caption, dbo.JournalPage.HTMLContent, dbo.Journal.Name AS Journal, dbo.Journal.SubjectId, dbo.JournalPage.Priority, dbo.Journal.Priority
FROM            dbo.JournalPage INNER JOIN
                         dbo.Journal ON dbo.JournalPage.JournalId = dbo.Journal.Id
GO
/****** Object:  View [dbo].[ViewJournalUserActiveField]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewJournalUserActiveField]
AS
SELECT DISTINCT 
                         dbo.JournalUserActiveField.Id, dbo.JournalUser.UserId, dbo.JournalUser.JournalId, dbo.AspNetUsers.UserName, dbo.AspNetUserRoles.RoleId, dbo.AspNetRoles.Name AS RoleName, dbo.AspNetUsers.Email, 
                         dbo.SubjectField.Name, dbo.JournalUserActiveField.SubjectFieldId, dbo.JournalUserActiveField.JournalUserId
FROM            dbo.JournalUserActiveField INNER JOIN
                         dbo.SubjectField ON dbo.JournalUserActiveField.SubjectFieldId = dbo.SubjectField.Id INNER JOIN
                         dbo.JournalUser INNER JOIN
                         dbo.AspNetUserRoles INNER JOIN
                         dbo.AspNetUsers ON dbo.AspNetUserRoles.UserId = dbo.AspNetUsers.Id INNER JOIN
                         dbo.AspNetRoles ON dbo.AspNetUserRoles.RoleId = dbo.AspNetRoles.Id ON dbo.JournalUser.UserId = dbo.AspNetUsers.Id ON dbo.JournalUserActiveField.JournalUserId = dbo.JournalUser.Id
GO
/****** Object:  View [dbo].[ViewJournalUserInfo]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewJournalUserInfo]
AS
SELECT DISTINCT 
                         dbo.Journal.Name, dbo.Journal.Id, dbo.JournalUser.UserId, dbo.Person.FirstName, dbo.Person.LastName, dbo.Person.Id AS PersonId, dbo.Subject.Name AS Subject, dbo.Journal.SubjectId, dbo.Journal.ImageUrl, 
                         dbo.JournalUser.JournalId, dbo.Journal.Priority, dbo.AspNetUsers.UserName, dbo.AspNetUserRoles.RoleId, dbo.AspNetRoles.Name AS RoleName, dbo.AspNetUsers.Email
FROM            dbo.AspNetUserRoles INNER JOIN
                         dbo.AspNetUsers ON dbo.AspNetUserRoles.UserId = dbo.AspNetUsers.Id INNER JOIN
                         dbo.AspNetRoles ON dbo.AspNetUserRoles.RoleId = dbo.AspNetRoles.Id INNER JOIN
                         dbo.Person ON dbo.AspNetUsers.Id = dbo.Person.UserId INNER JOIN
                         dbo.JournalUser INNER JOIN
                         dbo.Journal ON dbo.JournalUser.JournalId = dbo.Journal.Id INNER JOIN
                         dbo.Subject ON dbo.Journal.SubjectId = dbo.Subject.Id ON dbo.AspNetUsers.Id = dbo.JournalUser.UserId
GO
/****** Object:  View [dbo].[ViewMostVisitedArticle]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewMostVisitedArticle]
AS
SELECT        TOP (3) VisitCount, ArticleTitle, Id, ImageUrl, UploadDate, Restricted, Description, Deleted
FROM            dbo.Article
WHERE        (Deleted <> 1) OR
                         (Deleted IS NULL)
ORDER BY VisitCount DESC
GO
/****** Object:  Table [dbo].[News]    Script Date: 10/24/2018 2:06:13 AM ******/
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
	[Priority] [datetime] NULL,
 CONSTRAINT [PK_ADMSNews] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewNew]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewNew]
AS
SELECT        TOP (6) Id, PictureName, Priority, Title, Body
FROM            dbo.News
ORDER BY Priority DESC
GO
/****** Object:  View [dbo].[ViewSupplementarie]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewSupplementarie]
AS
SELECT        dbo.Attachment.UploaderId, dbo.Attachment.Id, dbo.Attachment.ArticleId, dbo.Attachment.Description, dbo.Attachment.AttachUrl, dbo.Person.FirstName + ' ' + dbo.Person.LastName AS Uploader, dbo.Attachment.UploadDate
FROM            dbo.Attachment LEFT OUTER JOIN
                         dbo.Person ON dbo.Attachment.UploaderId = dbo.Person.Id
GO
/****** Object:  View [dbo].[ViewUserDefiner]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewUserDefiner]
AS
SELECT        dbo.UserDefiner.Id, dbo.UserDefiner.DefinerId, dbo.UserDefiner.UserId, dbo.AspNetUsers.UserName, dbo.AspNetUsers.Email, dbo.AspNetRoles.Name AS RoleName, dbo.AspNetUserRoles.RoleId
FROM            dbo.AspNetUsers INNER JOIN
                         dbo.UserDefiner ON dbo.AspNetUsers.Id = dbo.UserDefiner.UserId INNER JOIN
                         dbo.AspNetUserRoles ON dbo.AspNetUsers.Id = dbo.AspNetUserRoles.UserId INNER JOIN
                         dbo.AspNetRoles ON dbo.AspNetUserRoles.RoleId = dbo.AspNetRoles.Id
GO
/****** Object:  View [dbo].[ViewUserRole]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewUserRole]
AS
SELECT        dbo.AspNetRoles.Id, dbo.AspNetUserRoles.UserId, dbo.AspNetRoles.Name AS RoleName, dbo.AspNetUsers.UserName
FROM            dbo.AspNetUserRoles INNER JOIN
                         dbo.AspNetRoles ON dbo.AspNetUserRoles.RoleId = dbo.AspNetRoles.Id INNER JOIN
                         dbo.AspNetUsers ON dbo.AspNetUserRoles.UserId = dbo.AspNetUsers.Id
GO
/****** Object:  Table [dbo].[Volume]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Volume](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ParentId] [int] NULL,
	[Name] [nvarchar](max) NULL,
	[No] [nvarchar](max) NULL,
	[Desc1] [nvarchar](max) NULL,
	[Desc2] [nvarchar](max) NULL,
	[Type] [tinyint] NOT NULL,
	[JournalId] [int] NULL,
	[ArticleId] [int] NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Volume] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ViewVolume]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewVolume]
AS
SELECT DISTINCT 
                         dbo.Volume.Id, dbo.Volume.ParentId, dbo.Volume.Name, dbo.Volume.No, dbo.Volume.Desc1, dbo.Volume.Desc2, dbo.Volume.Type, dbo.Volume.ArticleId, dbo.Volume.Description, dbo.Article.ArticleTypeId, dbo.Article.ArticleCode, 
                         dbo.Article.ArticleTitle, dbo.Article.Abstract, dbo.Article.ISSNDOI, dbo.Article.Keywords, dbo.Article.ArticleUrl, dbo.Article.ArticleState, dbo.Article.ArticleStateUpdateDate, dbo.Article.VisitCount, dbo.Article.DownloadCount, 
                         dbo.Article.EditorVersionUrl, dbo.Article.UploadDate, dbo.Article.Restricted, dbo.Article.ImageUrl AS ArticleImageUrl, dbo.Article.Deleted, dbo.Article.CheckListUrl, dbo.Article.OtherAuthorNames, dbo.Article.OtherAuthorEmails, 
                         dbo.Article.AssistantOtherAuthors, dbo.Article.DOI, dbo.Article.SuggestedReviewerNames, dbo.Article.SuggestedReviewerEmails, dbo.Journal.SubjectId, dbo.Journal.Name AS Journal, dbo.Journal.ImageUrl AS JournalImageUrl, 
                         dbo.Journal.Priority, dbo.Subject.Name AS Subject, dbo.ArticleType.Name AS ArticleType, dbo.Volume.JournalId, dbo.Article.PublishDate, dbo.Person.ORCID, dbo.Article.FieldId, dbo.SubjectField.Name AS Field
FROM            dbo.Subject INNER JOIN
                         dbo.Journal ON dbo.Subject.Id = dbo.Journal.SubjectId INNER JOIN
                         dbo.Article ON dbo.Journal.Id = dbo.Article.JournalId INNER JOIN
                         dbo.ArticleType ON dbo.Article.ArticleTypeId = dbo.ArticleType.Id INNER JOIN
                         dbo.ArticleAuthor ON dbo.Article.Id = dbo.ArticleAuthor.ArticleId INNER JOIN
                         dbo.Person ON dbo.ArticleAuthor.AuthorId = dbo.Person.UserId INNER JOIN
                         dbo.SubjectField ON dbo.Article.FieldId = dbo.SubjectField.Id RIGHT OUTER JOIN
                         dbo.Volume ON dbo.Article.Id = dbo.Volume.ArticleId
GO
/****** Object:  View [dbo].[ViewVolumeIssue]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewVolumeIssue]
AS
SELECT        TOP (100) PERCENT dbo.Volume.JournalId AS Id, CONVERT(int, dbo.Volume.Desc1) AS Desc1Int, dbo.Article.ArticleState, dbo.Article.Deleted, COUNT(dbo.Article.Id) AS ArticleCounts, dbo.Journal.Name AS Caption, 
                         dbo.Journal.SubjectId, dbo.Volume.No, dbo.Volume.Type
FROM            dbo.Volume INNER JOIN
                         dbo.Article ON dbo.Volume.JournalId = dbo.Article.JournalId INNER JOIN
                         dbo.Journal ON dbo.Journal.Id = dbo.Article.JournalId
GROUP BY dbo.Volume.JournalId, CONVERT(int, dbo.Volume.Desc1), dbo.Volume.Type, dbo.Article.ArticleState, dbo.Article.Deleted, dbo.Journal.Name, dbo.Journal.SubjectId, dbo.Volume.No
HAVING        (dbo.Volume.Type = 1) AND (dbo.Article.ArticleState = 14)
ORDER BY Desc1Int DESC
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 10/24/2018 2:06:13 AM ******/
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
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 10/24/2018 2:06:13 AM ******/
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
/****** Object:  Table [dbo].[City]    Script Date: 10/24/2018 2:06:13 AM ******/
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
/****** Object:  Table [dbo].[Country]    Script Date: 10/24/2018 2:06:13 AM ******/
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
/****** Object:  Table [dbo].[Dictionary]    Script Date: 10/24/2018 2:06:13 AM ******/
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
/****** Object:  Table [dbo].[ExcelDictionary]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExcelDictionary](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[en-US] [nvarchar](255) NULL,
	[fa-IR] [nvarchar](255) NULL,
	[Orig] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Image]    Script Date: 10/24/2018 2:06:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Image](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Type] [tinyint] NOT NULL,
	[ImageUrl] [nvarchar](max) NULL,
	[JournalId] [int] NULL,
	[Priority] [int] NOT NULL,
 CONSTRAINT [PK_WebShopImage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Language]    Script Date: 10/24/2018 2:06:13 AM ******/
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
/****** Object:  Table [dbo].[PageContent]    Script Date: 10/24/2018 2:06:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PageContent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Content] [nvarchar](max) NULL,
	[Type] [nvarchar](max) NULL,
	[journalId] [int] NULL,
 CONSTRAINT [PK_FirstPageContent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Province]    Script Date: 10/24/2018 2:06:14 AM ******/
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
/****** Object:  Table [dbo].[Reference]    Script Date: 10/24/2018 2:06:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reference](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Address] [nvarchar](max) NULL,
	[ArticleId] [int] NULL,
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
/****** Object:  Table [dbo].[RefrenceWord]    Script Date: 10/24/2018 2:06:14 AM ******/
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
/****** Object:  Table [dbo].[SiteInfo]    Script Date: 10/24/2018 2:06:14 AM ******/
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
INSERT [dbo].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'201803020854365_Initial', N'WebShop.Migrations.Configuration', 0x1F8B0800000000000400DD5CDB6EE4B8117D0F907F10F49404DE962F99C1C4E8DE85B76D6F8CF88669CF226F03B6C46E0B23515A89F2DA08F6CBF6219F945F4851B7166F12D5ADBE7831C0A025164F158B5564B154F4FF7EFFEFF887D730B05E7092FA1199D827A363DBC2C48D3C9F2C27764617DF7DB27FF8FECF7F1A5F79E1ABF5734577C6E8A0274927F633A5F1B9E3A4EE330E513A0A7D3789D26841476E143AC88B9CD3E3E37F3827270E06081BB02C6BFC3923D40F71FE008FD388B838A6190AEE220F0769F91E5A6639AA758F429CC6C8C513FBE2F16E362AC86CEB22F0118830C3C1C2B61021114514043CFF92E2194D22B29CC5F002054F6F3106BA050A525C0A7EBE22371DC3F1291B83B3EA5841B9594AA3B027E0C959A91447ECBE966AED5A69A0B62B502F7D63A3CE5537B16F3C9CBFFA1C05A00091E1F9344818F1C4BEAB595CA4F13DA6A3AAE3A880BC4E00EED728F9366A221E59C6FD8E6A233A1D1DB37F47D6340B6896E009C1194D5070643D66F3C077FF85DF9EA26F984CCE4EE68BB34F1F3E22EFECE3DFF1D987E64861AC40C7BD80578F4914E30464C38B7AFCB6E5F0FD1CB163DDADD1A7D00AD812F8836DDDA1D75B4C96F4193CE5F4936D5DFBAFD8ABDE94C6F585F8E03ED08926193CDE674180E601AEDB9D569EECFF16AEA71F3E0EC2F51EBDF8CB7CEA05FEE03809F8D5671CE4ADE9B31F17EEC5CDF7D792EC3A8942F6CCDB57D1FA75166589CB061369499E50B2C494976EECAC8CD7C8A419D4F0665DA11EBE69334965F35692B201ADE309158B5D7B4325EF76F91A5BDC451CC3E4E5A6C534D266708D5D6A24743BB258E3CA584E4C8D85C020FEC86BDF255EF884A955CB187E1A31EEB02ABCF4538A934B44EBB596FD7EF2C3FE42DFA294DE464B9F0C827691D167B6B814D63285216D5D1B5721F28301B61C032E10E62DFC24C4B56DFD18818323D25B4D8F284D61C5F5FE89D2E7AD2B6886DD2C8185604651186F9DDBE37344F07D16CE77E0080D5E834DCDD3AFD1357269945C11D66B63BCDBC8FD1665F48A78CCA9BE5057F631438041C4B9705D9CA6D760CCD89B46708AA9006F083D3BED0DC7F6837D877CD300F9A13AE61376AEAF15E92AEE535348B19F864C15FFB5899A2FB466A256A47A510B8A4E514BB2BEA2323033494B4ABDA03941A79C05D56011753E43C387D439ECE1C7D49B854CBAB5A0A1C619AC90F8270CE10E2C63DE23A2108F90D50C98AC1BFB08D1F2E9634CB7BE37E59C7E46413634ABB5BC215F0486F7861CF6F0BD2117135EBFF81E8B4A0C0E9A1531C01BD1ABCFB0DD3E2748B66B77E086B96BE6BB590374EE7291A691EBE75EA048319609225E7E88E1ACEE6C51311A31E304030343F7D996076F606CB668540FE412079862EBC22D52B05394BAC893D50803F27A0856EDA80AC15699275EB8BF493CC1D271C23A2176084AC1537D4265B7F089EBC728E8D492D0D3700B6363AF79882D9738C68431ECD484097375A2890950F31126A54B4363A76171ED86A8895A7573DE15C2AEE65DCAFFECC4263B62678D5D96F1DB560CB35D633B30CE76959808A04D9AEEC340CBB38AA901880797433350E1C4A431D032A4DA8981F21ADB8381F22A7977065A1C514DE75F38AF1E9A79F207E5DD6FEBADEADA836D72FA3830D32C624FE84311FB34209BE7E59C35E257AA389C819CE5F92C2D435DD14418F80C533E65B38A779571A8D30E221A511BE0CAD03A40CBCFAD1290E4503D84AB7279ADD29551440FD82AEFD60A5BAEFD026CC30664ECE667E706A1FEE3B4689C46A78F7A64B53548466E745868E0280C425CBCF8811B28459797951563120BF789861B032B27A345411D91AB4649D56006D752659ADD5A5205647D42B28DB424844F1A2D5583195C4BA58D762B491114F4080B365211BF850FE46C55A6A3DE6DEAB6B15394A1952FC68EA65E6D7C87E2D827CB46FD5AF9C69A15C56BD3EF66FD8BBBC202C37153458D572D6DCD8946095A62A1155883A4D77E92D24B44D11CB13CCFD40B2532E5DEAA59FE2B96CDED539EC46A1FA8A8D9EFD2F41A4512DC262B472165E76B185AC842993C7FAE987875778B1512A200258A94FD340AB290E8232B7DEFE2C35DB37FF14646183B82FC52E424A9498A6F799D1BCD88EC0D9BCE4E1DB1AC3F437A089D9EAB78B3A9695D0CAA47A952524D145D9A6A6F33A60B5DCC66490C07FB4F5227C2763CA9AEFC6942D42F7BCC3157D9C3CD34D7628E2894F734218526734C55914F1358D56E8E5ED6F33401CB573D311A25211258A3CD1C95AFDA6962F22DE68842694E135268EA2165B3008713B2D9B0169E46A36A0A730E72C94D135D6EED61FD72F10DE70172F31AD80A99C5B61EBE25D7E770AE25379B63AF8A75C49DE880F77DED81AFFFC65F240336DBF93518DBD95686091C1A350F4DA0C6EB9E586555830456BE3F4833D29E88FB9B5191FCD9CC8C3418FAB5862B13E0979AD6DA063D26F7ED9F5BCEDB6A1FF478FD8C75AB26219D8445929A7B7D22164EBEE3F214DA7D9D4B3A961624B655A911B6F23788DCC2112318CD7E09A6818FD9C25D11DC21E22F704A8B7A17FBF4F8E454B818763897B49C34F502C5295E77538B9FB31D94AE911794B8CF28910B4936B8C8B4029572F437C4C3AF13FB3F79AFF33CDDC37EE5AF8FAC9BF40BF17FC9A0E129C9B0F59B5C183BCCC58EF6B3E9815EC331D7EACDBFBF165D8FAC87043CE6DC3A1674B9CE0CF397737A495374DD409AB5AFECBC5F87126EC754B87F09D1EB5F9B60EBDE80F1E0371DEC06CCDA68FA1B301B8D98BBE5A29C13613959FF52CBDCA7835C68D968BCCA4B2B1B212A2EA60C8537880A75174FD6C1D25E3A5199B5C960D59750D6114D7B01C527FDC1C4EB27E68B78D5738F1BB5E228B98B053DD77367F9FE46B5BCFBDED9A52AFF8D1C5DAEE4EF01B741B5FE1A96F1CE0ADD078B2D1475EC8361EFD3B4B75EBC7E28F5EAAB4AA2FD96A9EFB232BDE55BE41FAA20FD004A28152561FB2F3BDFB5ADE9D2DF075EBBDBAFB8FCC08CAD2C14DC7F09F9AE8D4D97243F7063EB55287E60B6B6AFFD73CF9666BC85EEBDEC5BAE60D37CC65265D2BBCABA8BCF0E70C29F476004454459DCC655D711B6D54077305C91E899EA0B1845C692E3487C258A76B6FDC65A6EF8AD832D69DAD96ACA7EDB7897EB7F2BEF92A69DB7A698761F05E9CA7256D525818E75ACADF2EE3D15A07323E9B8EFD015B3B6D624BCA77AF34194C2798FE60BFBFB292F1F442543BA4E8F7272F96339EC9D8DBF900AFB77EA2F5710ECEFA512EC72BB664D73431651B5790B1255244286E60E53E4C1967A91507F815C0ACD2CC79CFF39813C6FC7BE74CCB177431E321A6714868CC379C025BC5810D0C63FAF99E7651E3FC4EC291D620820A6CF72F30FE4C7CC0FBC5AEE6B454E4803C1A28B32A3CBE692B2CCEEF2AD46BA8F882150A9BE3A287AC2611C0058FA4066E805AF231B98DF2D5E22F76D9501D481744F04AFF6F1A58F96090AD31263D51F1EC186BDF0F5FBFF03AC0FAD6628580000, N'6.1.3-40302')
INSERT [dbo].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'201803021000474_LastSignIn', N'WebShop.Migrations.Configuration', 0x1F8B0800000000000400DD5CDB6EE4B8117D0F907F10F49404DE962F99C1C4E8DE85B76D6F8CF88669CF226F03B6C46E1323515A89F2DA08F6CBF6219F945F08A95BF32A51DDEA8B170B2CDC64F154B15845164BC5F9DFEFFF1DFFF01A85CE0B4C3314E3897B323A761D88FD384078397173B2F8EE93FBC3F77FFED3F82A885E9D9F6BBA33464747E26CE23E13929C7B5EE63FC30864A308F9699CC50B32F2E3C80341EC9D1E1FFFC33B39F12085702996E38C3FE798A008163FE8CF698C7D98901C84777100C3AC6AA73DB302D5B90711CC12E0C3897BF178371B9564AE731122404598C170E13A00E3980042053CFF92C1194963BC9C25B401844F6F09A4740B1066B012FC7C456E3B87E35336076F35B086F2F38CC4514FC093B34A299E3C7C2DD5BA8DD2A8DAAEA87AC91B9B75A1BA897B13C0A2E9731C5205C80CCFA761CA8827EE5DC3E2224BEE2119D5034725E4754AE17E8DD36F231EF1C8B11E77D418D1E9E898FD77E44CF390E4299C609893148447CE633E0F91FF2FF8F6147F83787276325F9C7DFAF01104671FFF0ECF3EF033A573A57442036D7A4CE304A65436B868E6EF3A9E38CE930736C3B831A556A82D517F709D3BF07A0BF1923C534F39FDE43AD7E81506754B655C5F30A2EE43079134A73FEFF33004F31036FD5E2B4FF6FF16AEA71F3E0EC2F51EBCA065B1F4127FEA3829F5ABCF302C7AB3679494EE25ACF7D78AEC3A8D23F65BB4AFB2F7EB2CCE539F4D2636923C8174098928DDD85B19AF954933A8E1CDBA463D7CD36692AAE6AD2565135AC7136A16BBF6865ADEEDF2B5B6B88B24A18B579816D3489BC171A7D4481A76E4B0CE95B19CD81A0BA693F823EF7D9770813053AB9131FDD38A718755C125CA084C2F0169F65AF6F7138AFA0B7D0B3232434B7C833786BAC8C933DB594A5399D2F96C5D15571140E100E78D05171AE32D501AC1C6B07E8CA97703DC5B4D8F20CBE8761BFC1364CF5B57D00CFA794A7781190151B2756E8FCF3186F77934DF811770BC065B9AA75FE36BE09338BDC26CD4C678B7B1FF2DCEC9150E98537D21BEEA639600838873E1FB30CBAEA931C3601AD32B4C0D7883C9D9696F387618EC3BDE9B860045FA804F3AB6BED6A4ABA04F4FA1047E06325DF0D726EA6DBC44D84ED49AD42C6A49D1296A45D6575406662769456916B420E894B3A41A2C9C2E5668F878BA803DFC807AB378C9B417706A9CD11D12FE0469AC43B7B1E011101A8CE0D50AD8EC1BFB88CF8AE5634CB77E36159C7E06613E34ABB5BCA1D80486F78602F6F0BDA1109336BFA080452516B7CC9A98C25BD1EB2FB0DD3E2749B66B7710A6B96BE6BBD9034CEE729165B18F0A2FD0E417ABEC90283F8DE19CEE5451391B39DD4427460D1DB1238FB6D0B9B9B2513DE04B1842029D0BBFCCBF4E41E6834055239D50D043B0FA44D508B64A3B89C2FD4DE1492D1DA66C106097A08C7A2AC244750B847D9480B0534BD248CB238CCDBDE121F75CC20462C6B0531336CCF559262640C3475A942E0D8D3DCEE2DA0DD110B59AD6BC2B845DADBB92FCD9894D76C4CE06BBACE2B7AD1866BBC676609CED2AB111C09831DD87815677155B03902F2E8766A0D28DC960A05548B513031535B607031555F2EE0CB4BCA2DAAEBF745F3D34F3142FCABB3FD65BD5B507DB14F47160A659C69E740C01ECBB806A9E9773D6095F89E67246E5ACEE675915EACA26C2C0679088299B55BCAB8D43BD7610D988DA005786D6015A7D6B55801487EA215C9DCB6B95AE8A227AC0D679B756D86AEF9760391B50B1F96FCE1CA1F9CBB46C9C56B78F66668D3528466E7559E0703406216F5EE2C42D9462CACBAA8AB18985FB44C3DCC4AAC568515047E46A50523D99C1B5549B66B7967401599F906C232D49E193414BF56406D75265A3DD4AD204053DC2828D54241EE103395B9DE9684E9BA66FEC95356855C3D83314AB8DEF409220BCE48AD7AA16675656AE4DBF9BF5AFEC8A4A0CCFCF34055E8DB40D2712A76009A55ECA9A4A7A8DD28C5C0202E680E579A641A49069CF56C3F65FB3E48F4F7511EB73A0A6667F57A6C755480887AC1A855483AFE9D42216CA14F973CDC2EB873BAC8A108420D5A4ECA7719847D81C599947971FEEF8F1658B8A30F624F995C849519312DF8A3AB75A11D51B365D9D2662597F85CC10263DD7F126AF69530C6A46A953523C8A294DB5B71533852E76AB248783FD17A913613B9ED494FDF0104D638F3516CA7A8495167AEC11F9DA1E1E8F6FB747D395F7F0A8BA7E7BF4AA928707AC9A7A6270C5200A18D7678F2AD6EBF098628F3DA25494C3434A5D3DA4E44B6F0421F98EB5F00C1AD553D873508B6D7874B5B787DDAB653782F9ABDD6B606B6496FB7AF8965A9923B896DA6D8FBD2AD391CFA0033EF18D57BDFE477E9906D8ECCC37606CE740192664E0AA1D7820AEB9275655CFA08055ED076946C6BB707F332AD33E9B999101C3BCD7080502E256D35AD560C614BEFA0BDB795BD58319AF9FB16ED524943BB04CD2706FEEC2D29D775CDD3FBB5F712917D292C4756A35D2A3FC8DC66CD188118C66BF84D31041B671D7047700A305CC4859E9E29E1E9F9C4AEFC10EE76D96976541A8B9BF9B1E68896BB683A235FC0252FF19A46A09C906EF9756A04A76FE0607F075E2FEA718755E247AD85F45F39173937DC1E8979C763CA539747E534B628779CFD17E2B3DD0D737F65ABDF9F7D772E891F390528F39778E255DAEB3C2E29B9C5ED29443379066ED973AEFD7A1A4473135EE5F22F0FA571E6CDD872F01FD9B0CF3F0656D28F3C3978DA62B3C6ED12E88B497ACFF96658EC820EF58369AAFF6ADCA46889AF72843E10DA242D37B9375B08C6F4D74666D3359FDDB93754433BE3B41B83F98FCEAC47E07AF47EEF194D6DC2377B19B177AEEACDADFA88477DFC7BA52DCBF91A3AB05FC3DE03628D25FC332DE597DFB608185A67C7D30EC7D9AF6D66BD60FA54C7D5540B4DFEAF45D16A4B77C82FC43D5A11F40E5A4A6126CFFD5E6BBB63553EEFBC04B76FBD5941F98B155F581FBAF1CDFB5B19932E4076E6CBDEAC30FCCD6F6757EEED9D2AC8FD0BD577BAB856B866F58BA347A573577F9CD81DEF0E731358232A22C1FE1EACB07DB4A9F3B18AE48CC4CCD758B3263C57114BE0A453BDB7E73AD0EFCD6C95634ED6C0DD5BE6DBCABFDBF957745D3CEDB5043BB8F3A746D15ABEE6D40C73ED65670F79EEACE8599743C73E88A595B0B12DE5399F9204A11BCC7F079FDFD54950FA292215DA74715B9FAA59C9E9DDCBF8A4ACFEF0C2D5710ECDF48C5D0174ECD86E6062FE2FAF09624AA49A40CCD1D2420A047EA454AD002F88476B31C73F1AF0814793BF6A5630E831BFC9093242774CA309A8742C28B05016DFC8B527951E6F143C27E65434C818A89586EFE01FF98A33068E4BED6E4840C102CBAA832BA6C2D09CBEC2EDF1AA4FB185B0255EA6B82A22718252105CB1EF00CBCC07564A3E6770B97C07F5B65004D20DD0B21AA7D7C89C03205515661ACC6D39FD48683E8F5FBFF0323C6016F1C580000, N'6.1.3-40302')
INSERT [dbo].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'201803021003043_UserDefiner', N'WebShop.Migrations.Configuration', 0x1F8B0800000000000400DD5C5B6FE3B8157E2FD0FF20E8A92DB2562E9DC134B0779175926DD0DC30CE2CFA36A025DA2146A2BC12954D50EC2FDB87FEA4FE851EEA66F1A68B2D5BCE628145CCCB770E0F3F92874787F3BFDFFF3BFEE135F0AD171CC524A413FB64746C5B98BAA147E87262276CF1DD27FB87EFFFFCA7F19517BC5A3F17EDCE783BE849E389FDCCD8EADC7162F71907281E05C48DC2385CB0911B060EF242E7F4F8F81FCEC9898301C2062CCB1A7F4E2823014E7FC0CF69485DBC6209F2EF420FFB715E0E35B314D5BA47018E57C8C513FBE2F16E36CA9AD9D6854F10A830C3FEC2B610A521430C143CFF12E3198B42BA9CADA000F94F6F2B0CED16C88F71AEF8F9BA79DB311C9FF23138EB8E05949BC42C0C3A029E9CE54671E4EE1B99D62E8D0666BB02F3B2373EEAD47413FBC6C369D1E7D00703C802CFA77EC41B4FECBB52C445BCBAC76C54741C6590D711C0FD1A46DF4655C423AB75BFA39244A7A363FEDF91354D7C9644784271C222E41F598FC9DC27EEBFF0DB53F80DD3C9D9C97C71F6E9C347E49D7DFC3B3EFB501D298C15DA090550F418852B1C816E78518EDFB61CB19F23772CBB55FA6456012EC17AB0AD3BF47A8BE9923DC34A39FD645BD7E4157B45494EAE2F94C0F2814E2C4AE0E77DE2FB68EEE3B2DEA995C9FF5F23F5F4C3C75EA4DEA317B24CA75E920F0B278275F519FB696DFC4C56D9F212E6FB6BDEEC3A0A03FE5BE45756FB75162691CB07131A9B3CA1688999A8DDD85993B715A53954FFB42E500F9FDA5C5395DEDAA67C409BAC8442C4BE5743A1EF6EE5B666DCC56A059397528B5BA48E7095536A24753BB278E59A2C276DC94261107FE4BD8F1BE7122F08E5A6350A873F5B096F60165E9298813CC4CAFD96FFFD4482EE8ADFA298CDC892DED0ADA12E12F6CC77978C2E5318CFCE4D711520E2F770E6B490027EDE8244012EC9F563082B1CD1CE667A44710C5BAEF74F143FEFDC4033EC2611EC04338682D5CEA53D3E8714DF27C17C0FABA022ABB7A979FA35BC462E0BA32BCA7B6D8D771BBADFC2845D518F2FAA2FCC55D7584B805ED4B9705D1CC7D74066EC4D43B8C6148037949D9D6EB4E70DEDF34D7D4402BDD3271D5D5F8BA66BC74FDF4271FE0CCD740E609DAAB7E192D076AA164DCDAA662D1A55CD9B75559583B5D3346F6956346DD0A867D6AA37973A9DA1FE7DEA14F6F09DEAED7C26D35E5031E30C7648FC13065F07B631EF11317046E87A06DAEC1B43F868E9F471A13B3F9B52493F233FE95BD446AB21DD04FA5F0D29ECE1AF86544D287E211EF74A5ADC348BC600DFAABDFE12DBBCE624CDF6BD1C84610E715F1AEE767C11C7A14BD255A08931E61122517FF0E1ACE67051361A39E4040303A2137EE441098CCD9649F5402FB18F19B62EDC2C063B45B18B3CD58C3020AF8362C589AA516C1D7A1295FB9B2213988E23DE09F14B500C2B9550A62E0B425DB2427EA395A49E2D8F303EF652865C7389579872818D9668235C1F69E20A9472A44969B2D0D8A930AE9E8806AFD534E74D2EEC7ADE9500D05E38D9E03B1B7899FB6F3B2166BDC5F640CE7A93B451C018351D82A0F95DA52D01E48BCBA11154BA3119089ABB547B21A868B101082A9AE4DD1134BBA2B69D7FE9BE7A68F4142FCAFB3FD66BCD350037057B1C183533DF13FA30C4BF0BA8F4BC9CF34AFCCA349733D033BF9FC5B9AB2B538483CF301343366B7F57EB873AF5203289EA00D7446B00CDBFB72A40CA82EAA05C11CBABD52EF7223AC01671B75AD87CEF97602B1C50B1ABDF9D2B0DCD5FA76572B6BA7D94232BD9A090BCD565A182A32184BC7989036F6114535C56354C1B5FB88B375C19583E1935066AF05C0D462A06D3BB950A6A365B49E7907571C9B6B292E43E19AC540CA6772BE51C6D3692C629E8E0166C6522F108EF69B115918EF2B429EBC64E968796178C1D43C2DAF80EAD56842E2B096C798935CBB2D7A6DFCDBA6777051986E3C69A24AF52DB52120B23B4C4522D88064DAF4914B34BC4D01CF138CFD40B9466DAB3D5B0FD1722ABC7A73A89C53950B4E67FE7D4AB64490887ACEA85E49DAF6168017765D2F8B966E2F5DD2D9E49887C146942F6D3D04F026AF6ACCCBDB30F77D5FE59898A307624FD15CF493193E2DF8A366F3523EA6AD876764A8F65F319324398EC5CF89B554B9B7C50334A1192AAA298C25483CD98C97569374BB23BD87D921A1176B39284D41F799ACB8A0E732DA4F708332ED4B447ACE6F854F1AAE5EDD174693E55545D7D7BF43CA3A70A981775C4A82485286095BAF6A862DE4E1553AC698F2825E75421A5AA0E5A5653700425AB151BE1192CAA6FD15E829A745345576B3BF05E4DBF11E8AF566F80ADD159AEEBB0B6D40C1D6169A9D5DDF629F5D45F971ECC39A2B94FF571F467E180EDCE7E03C6EE0E96ED5D874AD64315A852DC112BCF6B50C0F2F283A491F14EDC9D4659F8673B1A1930CC7B8D9028206E35B5D90D664CE1EBBFB09DD7653F98F1BA9175A79450EEC27293527A792796EEBEE3FC1EDAFCA24BB998664D6CAB30231CE56FE0B30523DE6034FBC59FFA04F38DBB6870872859E09865192FF6E9F1C9A9F436EC70DE693971ECF99A7BBCE9B19638677B485EA32F28729F51A4A6926CF196690DAA44E96FA8875F27F67FD25EE769C087FF95161F5937F1174A7E49A0E2294AB0F59B9A1ADBCFDB8EFADBE981BEC4696FD59B7F7FCDBA1E590F11AC9873EB58B2E526332CBECFE9A44DD6750B6D367EB5F37E1794E6814C81FD9700BDFEB50AB8E923180FFE66FD3C82D918CAFC0866ABE10A0F5DB49322ED279BBF6B9913D6CB9B96ADC6AB7DB7B215A2E66D4A5F78BD98D0F4F664132CE3BB131DADDB0C56FF0E6513D58C6F5008ED0E26BF4069BF8B173D073CA93577C97DECE8A99D1B33F8B74AE71DFA685712FDB75AE86A327F07B82D12F63760C63BCB75EFCDB9D0A4B2F7EAB80C45ED9DE7AF1F4ACAFA3A9968D84CF57D26A7D77C8EFC43E5A41F4016A5262B6CF8CCF37D73CD14FF3EF0F4DD6EF9E50746B63C5770F82CF27D93CD14253F70B275CA153F30AE0D757E0ECCB4D647E8E099DF6A129BE13B962E94DE94D99D7D77801BFE3C0412641E65F620579F4A589706DD2070DDC42CD49CC3280B56168E225769512FB6DB58F303BF76B0799B7AB186CCDF3AD9F9FE5F2B3B6F532FDB904F3B444EBA36A355F74EA0611FAB4BBE7B4F39E8C2481A9E3C34F9ACB54909EF29E5BC17A308ABC7F089FDFD6498F762923E974E878C72F56B399C9D957F2515CEEF982CD710FCDF4CA5D8154ECDB2CD0D5D84C5E12D6954349122347798210F8ED48B889105721954F31873FA2F0AA4713BFEA5638EBD1BFA90B055C260C83898FB42C08B3B0175F2D3B47951E7F1C38AFF8AFB1802A849786CFE81FE9810DF2BF5BED6C4840C10DCBBC823BA7C2E198FEC2EDF4AA4FB90B604CACD573A454F3858F900163FD0197AC19BE806F4BBC54BE4BEAD23802690E68910CD3EBE246819A120CE31D6FDE12770D80B5EBFFF3F78296AC22C580000, N'6.1.3-40302')
INSERT [dbo].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'201810061313270_AllowAcceptReject', N'WebShop.Migrations.Configuration', 0x1F8B0800000000000400DD5C596FE4B8117E0F90FF20E82909BC2D1F99C1C468EFA2B76D27467C61DAB3C8DB802DB1DBCC4854AF44796C04F96579C84FCA5F4851578B97AE561F5E2CB070F3F8AA58FC48164BC5F9DF7FFE3BFEE935F0AD171CC524A417F6C9E8D8B63075438FD0E5859DB0C50F9FEC9F7EFCFDEFC6575EF06AFD52B43BE3EDA0278D2FEC67C656E78E13BBCF3840F128206E14C6E1828DDC307090173AA7C7C77F714E4E1C0C10366059D6F87342190970FA037E4E43EAE2154B907F177AD88FF372A899A5A8D63D0A70BC422EBEB0278F77B351D6CCB6263E41A0C20CFB0BDB4294860C3150F0FC4B8C672C0AE972B68202E43FBDAD30B45B203FC6B9E2E7EBE66DC7707CCAC7E0AC3B16506E12B330E8087872961BC591BBF732AD5D1A0DCC7605E6656F7CD4A9E92EEC1B0FA7459F431F0C200B3C9FFA116F7C61DF952226F1EA1EB351D17194415E4700F73D8CBE8DAA884756EB7E4725894E47C7FCBF236B9AF82C89F005C5098B907F643D26739FB87FC76F4FE1374C2FCE4EE68BB34F1F3E22EFECE39FF1D987EA4861ACD04E2880A2C7285CE10874C38B72FCB6E588FD1CB963D9ADD227B30A7009D6836DDDA1D75B4C97EC1956CAE927DBBA26AFD82B4A72727DA104960F746251023FEF13DF47731F97F54EAD4CFEFF1AA9A71F3E0E22F51EBD90653AF5927C583811ACABCFD84F6BE367B2CA969730DF5FF366D75118F0DF22BFB2DAAFB330895C3E98D0D8E409454BCC44EDC6CE9ABCAD28CDA186A775817AF8D4E69AAAF4D636E503EAB3120A11BB5E0D85BEDB95DB9A7193D50A262FA516B7481DE12AA7D448EA7664F1CA35594EDA9285C2207ECB7BDFC4F7C3EF13977B029FF13FB1CB0A157E0E8107887606E4D6BEC40B42F95C1947037FB61A4D0355F192C40CE421566EE0FCEF271274B7C42D8AD98C2CE90DDD186A92B067BE5D65FC9BC278B66E8AAB00117F8043AC8514701C17240AB0B729551E511CC31EEEFD0DC5CF5B37D00CBB49045BCB8CA160B575698FCF21C5F74930DFC12AA8C81A6C6A9EBE87D7C86561744579AF8DF16E43F75B98B02BEAF145F585B9EA1A6B0930883A7CC38BE36B2033F6A621DC8B0AC01BCACE4E7BED79FB7622A73E2281DE8B94CEC2AF45D3B527A96FA1789386663A8FB24ED5DB7049683B558BA66655B3168DAAE6CDBAAACAC1DA699AB7342B9A3668D4336B35988F9ECED0F04E7A0A7BF85EFA664E98692FA89871063B24FE2B065F07B631EF11317046E87A06DAEC1BFB70FAD2E9E342B77E36A5927E417E32B4A85EAB21DD04865F0D29ECE1AF86544D287E211EF74A5A5C5D8BC600DFAABDFE56DCBCE624CD76BD1C8461EE5AF86EF600D37299C471E892741568829679C849D41F7C38AB39FE948D468E61C1C080E8841F79500263B365523DD04BEC6386AD899B0575A7287691A79A1106E47550AC3851358AAD6359A2727F526402D371C43B217E098A61A512CAD46541A84B56C86FB492D4B3E511C6C75ECA906B2EF10A532EB0D1126D84EB43575C81528E34294D161A3B15C6D513D1E0B59AE6BCC9855DCFBB1251DA09271B7C67032F73FF6D2BC4ACB7D80EC8596F92360A18C3B0FB20687E57694B00F9E2726804956E4C0682E62ED54E082A5A6C0F04154DF2EE089A5D51DBCEBF745F3D347A8A17E5DD1FEBB5E6DA0337057B1C183533DF13FA30C4BF0BA8F4BC9CF34AFCCA349733D033BF9FC5B9AB2B538483CF301343366B7F57EB873AF5203289EA00D7446B00CD3FE02A40CA82EAA05C11CBABD52EF7223AC01671B75AD87CEF97602B1C50B1AB1FB22B0DCD9FBB6572B6BA7D94232BD9A090BCD565A182A32184BC7989036F6114535C56354C1B5FB88B375C19583E1935066AF05C0D462A0633B8950A6A365B49E7907571C936B292E43E19AC540C66702BE51C6D3692C629E8E0166C6422F1081F68B115918EF2B429EBC64E96D896178C1D4306DCF80EAD56842E2B1971798935CBD2E1A63FCCBAA78B051986E3C69AACB152DB52120B23B4C4522D88064DAF4914B34BC4D01CF138CFD40B9466DAB3D5B0FD1722ABC7A73A89C53950B4E67FE7D4ABA45D0887ACEA85E49DAF6168017765D2F8B966E2F5DD2D9E9A887C146942F6D3D04F026AF6ACCCBDB30F77D5FE59898A307624FD15CF493193E2DF8A366F3523EA6AD874764A8FA5FF0C99214C762EFCCDAAA54D3EA819A5084955514C61AABDCD98C97569374BB23BD87D921A11B6B39234B94455304D757B6C21AD48A65059D1814742EA90C026A1A63D62357FA88A572DEF604B4D0A91604C4D7D7BF43C5BA80A981775C4A8249C286095BAF6A8624E501553AC698F2825FE5421A5AA0E5A56D37B0425AB15BDF00C16D5B7682F414DE8A9A2ABB51D78AFA6F608F457AB7B606B7496EB3AAC2D35FB47585A6A75B77D4AF528D6A507734669EE6A43B81559A86133BFC280B19D436B18B7A492515105AA1477C4CA732614B0BCFC206964BC6F77A751165ADA8C46060CF35E232421885B4D6DE6841953C82C10B6F3BACC0A335E37B26E9512CA3D5B6E524A2FEFDBD2BD7A9CDF719B9F9F2997DEAC896D156684A3FC0D7CB660C41B8C66BFFA539F60BE71170DEE10250B1CB32C9BC63E3D3E39951EB21DCEA332278E3D5F132330BD2C13E76C078971F40545EE338AD434950D1E5EAD41952F0037D4C3AF17F6BFD25EE7693089FF95161F5937F1174A7E4DA0E2294AB0F56F35ED76988728F537DF037D36D4DEAA37FFF89A753DB21E225831E7D6B164CB3E332C3E26EAA44DD675036D7A3F317ABF0BCAF89A674ED8102F790A45FF10A0D73F5601FBBED6F1E06F36CC6B9DDE50E6D73A1B0D577891A39D616973EAFF00A7CFECEA1EDF6C345EED039B8D10358F6886C21BC484A647327DB08C0F6474B46E3358FD83993EAA191FCB10DA6F53E977EC173DF778EC6B2EA6BB381E523B373E35D828EF78DF7E82F22261A385AEBE3AE800B7C1CB821ECC786749F983792A9A9CFBC1B0F749EDAD27DA1F4A6EFD3AEB69BF29F5BBCCA2AFF96EFA9B4A9E3F80744F4DFADAFE53E477CD355330FDC0F38CBB25C21F18D9F2A4C6FDA7BBEF9A6CA690FB8193AD5352FB81716D5FE7E79E99D6FA08DD7B8ABA9A6D67F828A68BCB37A5A0671F31E0863F0F8104994799BD1CD6E73CD6E56B37085C37310B35275BCA829585A3C8555AD48BED36D6FCC0AF1D6CDEA65EAC2145B94E76BEFFD7CACEDBD4CB3624FEEE23795E9B7AAB7BD0D0B08FD56509BEA7647961240D6F339A7CD6DA0C87F7941B3F885184D563F85EFF7E52E10731C9904BA743EABBFAE91DCECECABF0F0BE7774C966B08FEAFC552EC0AA766D9E6862EC2E2F096342A9A48119A3BCC900747EA246264815C06D53CC69CFED30769DC8E7FE99863EF863E246C953018320EE6BE10F0E24E409DFC34BF5FD479FCB0E2BFE22186006A121E9B7FA03F27C4F74ABDAF3531210304F72EF2882E9F4BC623BBCBB712E93EA42D8172F3954ED1130E563E80C50F74865E701FDD807EB77889DCB77504D004D23C11A2D9C797042D2314C439C6BA3FFC040E7BC1EB8FFF07A00066A926590000, N'6.1.3-40302')
SET IDENTITY_INSERT [dbo].[Article] ON 

INSERT [dbo].[Article] ([Id], [ArticleTypeId], [ArticleCode], [ArticleCodeCounter], [ArticleTitle], [Abstract], [ISSNDOI], [Keywords], [JournalId], [FieldId], [ArticleUrl], [ArticleState], [ArticleStateUpdateDate], [VisitCount], [DownloadCount], [EditorVersionUrl], [UploadDate], [Restricted], [Description], [ImageUrl], [Deleted], [CheckListUrl], [OtherAuthorNames], [OtherAuthorEmails], [AssistantOtherAuthors], [DOI], [SuggestedReviewerNames], [SuggestedReviewerEmails], [PublishDate]) VALUES (8036, 1, N'JYSB-2018-10-8036', 0, N'Electronic Next Generation', N'<div style="text-align: center;"><span style="font-family: comic sans ms, sans-serif;"><font size="6"><span style="font-style: italic;"><span style="font-weight: bold;"><br></span></span></font></span></div><div style="text-align: center;"><span style="font-family: comic sans ms, sans-serif;"><font size="6"><span style="font-style: italic;"><span style="font-weight: bold;">Electronic Next Generation<br></span></span></font></span></div>', NULL, N'k1,k2,k3', 7016, 27, N'/Resources/Uploaded/Articles/284025717efe4866b2fbbbf2c77b03af/20181010112535Einstein1921_by_F_Schmutzer_2.jpg?CT=image_jpeg.png', 1, CAST(N'2018-10-16T15:40:53.410' AS DateTime), 0, 0, NULL, CAST(N'2018-10-10T11:25:35.360' AS DateTime), 0, NULL, NULL, 0, N'', N'akbar - a1', N'pournaeim@gmail.com', NULL, NULL, N'rev1,rev2', N'pournaeim@gmail.com,pournaeim@gmail.com', NULL)
INSERT [dbo].[Article] ([Id], [ArticleTypeId], [ArticleCode], [ArticleCodeCounter], [ArticleTitle], [Abstract], [ISSNDOI], [Keywords], [JournalId], [FieldId], [ArticleUrl], [ArticleState], [ArticleStateUpdateDate], [VisitCount], [DownloadCount], [EditorVersionUrl], [UploadDate], [Restricted], [Description], [ImageUrl], [Deleted], [CheckListUrl], [OtherAuthorNames], [OtherAuthorEmails], [AssistantOtherAuthors], [DOI], [SuggestedReviewerNames], [SuggestedReviewerEmails], [PublishDate]) VALUES (9036, 3, N'JYSB-2018-10-9036', 0, N'qqqqqqqqqqqqq', N'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq<div>wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww</div><div>eeeeeeeeeeeeeeeeeeeeee</div>', NULL, N'a', 7015, 25, N'/Resources/Uploaded/Articles/284025717efe4866b2fbbbf2c77b03af/20181023184531packages.config?CT=application_xml.png', 1, CAST(N'2018-10-23T18:57:32.940' AS DateTime), 0, 0, NULL, CAST(N'2018-10-23T17:44:13.297' AS DateTime), 0, NULL, NULL, 0, N'', N'a', N'pournaeim@gmail.com', NULL, NULL, N'r', N'pournaeim@gmail.com', NULL)
SET IDENTITY_INSERT [dbo].[Article] OFF
SET IDENTITY_INSERT [dbo].[ArticleAuthor] ON 

INSERT [dbo].[ArticleAuthor] ([Id], [AuthorId], [ArticleId], [Date]) VALUES (8016, N'28402571-7efe-4866-b2fb-bbf2c77b03af', 8036, CAST(N'2018-10-10T11:25:35.360' AS DateTime))
INSERT [dbo].[ArticleAuthor] ([Id], [AuthorId], [ArticleId], [Date]) VALUES (9016, N'28402571-7efe-4866-b2fb-bbf2c77b03af', 9036, CAST(N'2018-10-23T17:44:13.297' AS DateTime))
SET IDENTITY_INSERT [dbo].[ArticleAuthor] OFF
SET IDENTITY_INSERT [dbo].[ArticleEditor] ON 

INSERT [dbo].[ArticleEditor] ([Id], [ArticleId], [EditorId], [ArticleEditState], [Date]) VALUES (8064, 8036, N'4391d79f-f5b6-4309-bd93-b251a83774a2', 4, CAST(N'2018-10-15T09:57:21.497' AS DateTime))
SET IDENTITY_INSERT [dbo].[ArticleEditor] OFF
SET IDENTITY_INSERT [dbo].[ArticleReviewer] ON 

INSERT [dbo].[ArticleReviewer] ([Id], [ArticleId], [ReviewerId], [ArticleReviewState], [CheckListUrl], [Date]) VALUES (4061, 8036, N'ce24fef9-3e1f-4dfe-be40-1dc7e81d9e05', 8, NULL, CAST(N'2018-10-15T09:57:35.100' AS DateTime))
SET IDENTITY_INSERT [dbo].[ArticleReviewer] OFF
SET IDENTITY_INSERT [dbo].[ArticleType] ON 

INSERT [dbo].[ArticleType] ([Id], [Name]) VALUES (1, N'Original research')
INSERT [dbo].[ArticleType] ([Id], [Name]) VALUES (2, N'Review')
INSERT [dbo].[ArticleType] ([Id], [Name]) VALUES (3, N'Letter to Editor')
SET IDENTITY_INSERT [dbo].[ArticleType] OFF
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'291d6069-44a3-4960-86d3-b91bda430e71', N'Assistant')
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'4d7951d8-8eda-4452-8ff1-dfc9076d8bbe', N'Reviewer')
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'58c326dd-38ea-4d3c-92f9-3935e3763e68', N'Editor In Chief')
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'652a69dc-d46c-4cbf-ba28-8e7759b37752', N'Admin')
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'da581de4-1f6d-4cdf-bae1-861cf666aa5a', N'Editor')
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'f3b628a1-ab7d-48dc-811d-d509e645d7f0', N'Author')
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'f522e425-0407-4fe5-894e-93dbdcfd1a2c', N'Member')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'0d8da45b-11b3-4047-a4ff-800c878c2fee', N'4d7951d8-8eda-4452-8ff1-dfc9076d8bbe')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'238abeb3-01a1-4764-812e-54d3c292181d', N'58c326dd-38ea-4d3c-92f9-3935e3763e68')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'28402571-7efe-4866-b2fb-bbf2c77b03af', N'f3b628a1-ab7d-48dc-811d-d509e645d7f0')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'2f3c31d0-d3fb-43a4-aeb8-e413a6556d9e', N'58c326dd-38ea-4d3c-92f9-3935e3763e68')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'da581de4-1f6d-4cdf-bae1-861cf666aa5a')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'5ba84549-a275-4216-a7bf-dab050a342c4', N'4d7951d8-8eda-4452-8ff1-dfc9076d8bbe')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'58c326dd-38ea-4d3c-92f9-3935e3763e68')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'91b4e59a-1d4a-4556-bf11-fb0b685d7ab6', N'291d6069-44a3-4960-86d3-b91bda430e71')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'c87419bb-de56-48ae-abba-c56a2692d4cb', N'652a69dc-d46c-4cbf-ba28-8e7759b37752')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'ce24fef9-3e1f-4dfe-be40-1dc7e81d9e05', N'4d7951d8-8eda-4452-8ff1-dfc9076d8bbe')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'e2e85ad2-7468-493a-a8ef-f4dd401c88db', N'58c326dd-38ea-4d3c-92f9-3935e3763e68')
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'0d8da45b-11b3-4047-a4ff-800c878c2fee', N'pournaeim@gmail.com', 1, N'AIQE8xFyEVC7szTZbN0CYT5wnWcAXPWtEIKtukfW84ojDHqFsK9mtvP5sTK12XNk3Q==', N'e566b77d-6ffc-459d-8fc0-273712ee2bf1', N'2', 0, 0, NULL, 0, 0, N'R2', CAST(N'2018-10-11T13:08:31.070' AS DateTime), NULL, CAST(N'2018-10-11T13:08:31.070' AS DateTime), NULL, 0)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'238abeb3-01a1-4764-812e-54d3c292181d', N'pournaeim@gmail.com', 0, N'AN2OV93C+R9jr7FlZn8D8MBg2cdGfSQUR/PoR4wK9eAh1ZcIhEB99O/yc8yQnFaQlg==', N'cae0dd4a-7eb8-4520-b787-e521b7333c97', NULL, 0, 0, NULL, 0, 0, N'Eic3', CAST(N'2018-10-16T10:14:58.693' AS DateTime), NULL, CAST(N'2018-10-16T10:14:58.693' AS DateTime), NULL, 1)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'28402571-7efe-4866-b2fb-bbf2c77b03af', N'pournaeim@gmail.com', 1, N'ABbwkDIMApgVB+fRqiSjbwxbhXJXciHQSdmn7sWCj0qwOpUqsYyEl6nzUdbuKxDoFg==', N'68842875-a690-4e07-a108-9876be4ac80c', N'0', 0, 0, NULL, 0, 0, N'Author1', CAST(N'2018-10-10T07:46:26.173' AS DateTime), NULL, CAST(N'2018-10-10T07:46:26.173' AS DateTime), NULL, 0)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'2f3c31d0-d3fb-43a4-aeb8-e413a6556d9e', N'pournaeim@gmail.com', 1, N'AM/5lJQ9U1aMy30pvBuY/xDYmnkZCTcyvgTJL+72RMEstie4ThEK1NDmGAdIAS4Znw==', N'00759985-a3a2-4fe9-8726-cecec6862014', N'-', 0, 0, NULL, 0, 0, N'Eic2', CAST(N'2018-10-10T03:47:20.983' AS DateTime), NULL, CAST(N'2018-10-10T03:47:20.983' AS DateTime), NULL, 1)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'pournaeim@gmail.com', 1, N'ABCwNjtBQqOmdtQUTMjqmk01w0V3pInzGm7m4hjQeDS64heJ2M3UtObkctnxVb0bJA==', N'fea37b7c-4bd7-4795-a6dc-9b6663dc89b0', N'1', 0, 0, NULL, 0, 0, N'E1', CAST(N'2018-10-10T08:11:52.463' AS DateTime), NULL, CAST(N'2018-10-10T08:11:52.463' AS DateTime), NULL, 1)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'5ba84549-a275-4216-a7bf-dab050a342c4', N'pournaeim@gmail.com', 1, N'AHx7YNpSshadxGg5Ofcop6jgjOWyglAbEARrxIrZ2JZBJgK7pMx+FjxzNsIZSs8QRA==', N'2109271c-5be5-480c-94da-821956cc9a11', N'3', 0, 0, NULL, 0, 0, N'R3', CAST(N'2018-10-11T13:09:07.037' AS DateTime), NULL, CAST(N'2018-10-11T13:09:07.037' AS DateTime), NULL, 0)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'pournaeim@gmail.com', 1, N'AHi7qauOIscD6AhZNhbD49XkGsAawGOClGp9CvPIXKS25BkIiVFch9pOC6uULRL5qQ==', N'3c3fbf7d-cbd0-440e-b9ad-e5e645c64cfe', N'-', 0, 0, NULL, 0, 0, N'Eic1', CAST(N'2018-10-10T03:24:53.143' AS DateTime), NULL, CAST(N'2018-10-10T03:24:53.143' AS DateTime), NULL, 1)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'91b4e59a-1d4a-4556-bf11-fb0b685d7ab6', N'pournaeim@gmail.com', 1, N'AKJ0XZFccboXMREsNOT4ANpN6DP5YOvqL3VS0UsMkozfr8IsMqXZbdBYH/wllsnoHw==', N'3b82306f-5909-448e-81a9-6228d32f3e71', N'aaaaaaaaaa', 0, 0, NULL, 0, 0, N'assiatant1', CAST(N'2018-10-16T12:11:24.607' AS DateTime), NULL, CAST(N'2018-10-16T12:11:24.607' AS DateTime), NULL, 0)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'c87419bb-de56-48ae-abba-c56a2692d4cb', N'pournaeim@gmail.com', 1, N'AB6lefHRYQg/Qsq0R6IhWZzKyde8aLGMnhQyyF8cPFrYJHzyZOisnWkH4EtFcjmUAA==', N'1c5ae905-6c98-4845-9fb4-8472cd9f812d', N'1111111111', 0, 0, CAST(N'2018-08-07T17:48:51.127' AS DateTime), 0, 0, N'admin', CAST(N'2018-06-25T12:15:04.337' AS DateTime), NULL, CAST(N'2018-06-25T12:15:04.340' AS DateTime), NULL, 0)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'ce24fef9-3e1f-4dfe-be40-1dc7e81d9e05', N'pournaeim@gmail.com', 1, N'AABAyQXU5tCy6fXyJS7AwZuFnOCbV2dlrxud4nk79fP2M1Tx/ZKBIuYnuMvT/8cz5A==', N'8edd2521-bd64-46ef-86be-16ed70ee466f', N'r1', 0, 0, NULL, 0, 0, N'R1', CAST(N'2018-10-11T13:08:03.953' AS DateTime), NULL, CAST(N'2018-10-11T13:08:03.953' AS DateTime), NULL, 0)
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [RegisterDate], [AuthenticationCode], [LastSignIn], [UserDefiner], [AllowAcceptReject]) VALUES (N'e2e85ad2-7468-493a-a8ef-f4dd401c88db', N'pournaeim@gmail.com', 0, N'AHtJUKQsP32jqhucwUEyuUjwDJmPnznFYxrHHKIQrwSD/AcibtfQFl3b4gSoMfl4Sg==', N'92085a8b-32c0-456f-a6c2-5698033733cb', NULL, 0, 0, NULL, 0, 0, N'Eic4', CAST(N'2018-10-16T10:15:59.680' AS DateTime), NULL, CAST(N'2018-10-16T10:15:59.680' AS DateTime), NULL, 1)
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
SET IDENTITY_INSERT [dbo].[Dictionary] ON 

INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19362, N'en-US', 1, N'Home')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19363, N'en-US', 2, N'Services')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19364, N'en-US', 3, N'Partners')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19365, N'en-US', 4, N'About us')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19366, N'en-US', 5, N'Contact')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19367, N'en-US', 6, N'Login')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19368, N'en-US', 7, N'Register')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19369, N'en-US', 8, N'Search here')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19370, N'en-US', 9, N'Getting started')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19371, N'en-US', 10, N'Language')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19372, N'en-US', 11, N'Country')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19373, N'en-US', 12, N'City')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19374, N'en-US', 13, N'Postcode')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19375, N'en-US', 14, N'Search by skills')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19376, N'en-US', 15, N'Let''s Work Together!')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19377, N'en-US', 16, N'Join free today')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19378, N'en-US', 17, N'Rent workers - Rent out crews - Get or sell construction jobs in your local area or internationally')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19379, N'en-US', 18, N'Profiles, looking for jobs right now')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19380, N'en-US', 19, N'Offering jobs right now')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19381, N'en-US', 20, N'International profiles and jobs')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19382, N'en-US', 21, N'See all profiles here')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19383, N'en-US', 22, N'See all jobs here')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19384, N'en-US', 23, N'Profiles and jobs')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19385, N'en-US', 24, N'Profiles')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19386, N'en-US', 25, N'Jobs')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19387, N'en-US', 26, N'Select country')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19388, N'en-US', 27, N'Free')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19389, N'en-US', 28, N'click')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19390, N'en-US', 29, N'Unlimited')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19391, N'en-US', 30, N'week')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19392, N'en-US', 31, N'month')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19393, N'en-US', 32, N'Limited profile visit')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19394, N'en-US', 33, N'Unlimited profile visit')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19395, N'en-US', 34, N'Limited to living postcode')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19396, N'en-US', 35, N'No limitation to postcode')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19397, N'en-US', 36, N'Limited to chosen postcode')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19398, N'en-US', 37, N'Limited to chosen city')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19399, N'en-US', 38, N'Limited to chosen country')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19400, N'en-US', 39, N'Access to entire profiles')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19401, N'en-US', 40, N'Limited days')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19402, N'en-US', 41, N'No time limitation')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19403, N'en-US', 42, N'No job list')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19404, N'en-US', 43, N'Receive job list')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19405, N'en-US', 44, N'No access to visited profiles')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19406, N'en-US', 45, N'Access to visited profiles')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19407, N'en-US', 46, N'Buy Now')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19408, N'en-US', 47, N'Our services')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19409, N'en-US', 48, N'Rent crew')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19410, N'en-US', 49, N'Get, buy & sell jobs')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19411, N'en-US', 50, N'Networks & Events')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19412, N'en-US', 51, N'Buy & sell used equipments')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19413, N'en-US', 52, N'Buy & sell new equipments')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19414, N'en-US', 53, N'Use')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19415, N'en-US', 54, N'As you wish')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19416, N'en-US', 55, N'Future digital access')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19417, N'en-US', 56, N'Read more about System')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19418, N'en-US', 57, N'Testimonial')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19419, N'en-US', 58, N'Sign up now and be a part of a future')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19420, N'en-US', 59, N'Sign me up')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19421, N'en-US', 60, N'Upcoming events')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19422, N'en-US', 61, N'Get in touch')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19423, N'en-US', 62, N'Address')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19424, N'en-US', 63, N'E-Mail')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19425, N'en-US', 64, N'Phone')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19426, N'en-US', 65, N'Who are we')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19427, N'en-US', 66, N'and where are we going')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19428, N'en-US', 67, N'Welcome to the club')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19429, N'en-US', 68, N'Join our next meeting')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19430, N'en-US', 69, N'The best network of the year')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19431, N'en-US', 70, N'See all genre')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19432, N'en-US', 71, N'Network')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19433, N'en-US', 72, N'Contact us')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19434, N'en-US', 73, N'Meet us here')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19435, N'en-US', 74, N'Network meetings')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19436, N'en-US', 75, N'Saturday ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19437, N'en-US', 76, N'Sunday ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19438, N'en-US', 77, N'Monday ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19439, N'en-US', 78, N'Tuesday')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19440, N'en-US', 79, N'Wednesday')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19441, N'en-US', 80, N'Thursday')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19442, N'en-US', 81, N'Friday')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19443, N'en-US', 82, N'Sign up to System today')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19444, N'en-US', 83, N'Name')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19445, N'en-US', 84, N'Subject')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19446, N'en-US', 85, N'Message')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19447, N'en-US', 86, N'Send')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19448, N'en-US', 87, N'See all members')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19449, N'en-US', 88, N'See all events')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19450, N'en-US', 89, N'See all jobs')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19451, N'en-US', 90, N'Webshop')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19452, N'en-US', 91, N'A network')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19453, N'en-US', 92, N'That supports you')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19454, N'en-US', 93, N'Start working with us')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19455, N'en-US', 94, N'Contact your local branch')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19456, N'en-US', 95, N'The best contracts')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19457, N'en-US', 96, N'Starts here')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19458, N'en-US', 97, N'Geographical location')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19459, N'en-US', 98, N'See all representatives')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19460, N'en-US', 99, N'What do you gain from your membership')
GO
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19461, N'en-US', 100, N'Join the next network meeting')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19462, N'en-US', 101, N'Password')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19463, N'en-US', 102, N'Remember me?')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19464, N'en-US', 103, N'Forgot password?')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19465, N'en-US', 104, N'Social network account log in')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19466, N'en-US', 105, N'Email is required')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19467, N'en-US', 106, N'Password is required')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19468, N'en-US', 107, N'Enter your email')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19469, N'en-US', 108, N'Email link')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19470, N'en-US', 109, N'Create a new account')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19471, N'en-US', 110, N'User name')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19472, N'en-US', 111, N'Role')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19473, N'en-US', 112, N'Confirm password')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19474, N'en-US', 113, N'Select your role')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19475, N'en-US', 114, N'Company')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19476, N'en-US', 115, N'Customer')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19477, N'en-US', 116, N'Skilled worker')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19478, N'en-US', 117, N'Admin panel')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19479, N'en-US', 118, N'All rights reserved')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19480, N'en-US', 119, N'Login with your social network account')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19481, N'en-US', 120, N'Social login')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19482, N'en-US', 121, N'Error')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19483, N'en-US', 122, N'An error occurred while processing your request')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19484, N'en-US', 123, N'Locked out')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19485, N'en-US', 124, N'This account has been locked out, please try again later')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19486, N'en-US', 125, N'You do not have a local username/password for this site. add a local account so you can log in without an external login.')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19487, N'en-US', 126, N'Create local login')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19488, N'en-US', 127, N'Set password')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19489, N'en-US', 128, N'Change password form')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19490, N'en-US', 129, N'Change password')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19491, N'en-US', 130, N'Format')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19492, N'en-US', 131, N'Protection')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19493, N'en-US', 132, N'Type')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19494, N'en-US', 133, N'You''ve successfully authenticated with')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19495, N'en-US', 134, N'Please enter a username for this site below and click the register button to finish logging in.')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19496, N'en-US', 135, N'Unsuccessful login with service')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19497, N'en-US', 136, N'Please check your email to reset your password')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19498, N'en-US', 137, N'Select your countries')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19499, N'en-US', 138, N'Reset')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19500, N'en-US', 139, N'Reset your password')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19501, N'en-US', 140, N'Your password has been reset')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19502, N'en-US', 141, N'Click here to log in')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19503, N'en-US', 142, N'Register date')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19504, N'en-US', 143, N'Roles')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19505, N'en-US', 144, N'Forgot password confirmation')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19506, N'fa-IR', 1, N'صفحه اصلی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19507, N'fa-IR', 2, N'خدمات')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19508, N'fa-IR', 3, N'نمایندگی ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19509, N'fa-IR', 4, N'درباره ما')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19510, N'fa-IR', 5, N'تماس با ما')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19511, N'fa-IR', 6, N'ورود به سیستم')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19512, N'fa-IR', 7, N'عضویت')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19513, N'fa-IR', 8, N'جستجو')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19514, N'fa-IR', 9, N'شروع به کار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19515, N'fa-IR', 10, N'زبان')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19516, N'fa-IR', 11, N'کشور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19517, N'fa-IR', 12, N'شهر')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19518, N'fa-IR', 13, N'کد پستی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19519, N'fa-IR', 14, N'تخصص')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19520, N'fa-IR', 15, N'همکاری با هم')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19521, N'fa-IR', 16, N'عضویت رایگان')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19522, N'fa-IR', 17, N'اجاره کردن نیروی کار, اجاره دادن نیروی کار, گرفتن یا واگذاری کارها در مناطق اطراف خود')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19523, N'fa-IR', 18, N'پروفایلهای جستجو کننده  کار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19524, N'fa-IR', 19, N'پیشنهادهای کاری')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19525, N'fa-IR', 20, N'تمام جستجو کننده های کار و پیشنهادهای کاری')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19526, N'fa-IR', 21, N'دیدن تمامی پروفایل ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19527, N'fa-IR', 22, N'دیدن تمامی کارها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19528, N'fa-IR', 23, N'پروفایل ها و کارها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19529, N'fa-IR', 24, N'پروفایل ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19530, N'fa-IR', 25, N'کارها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19531, N'fa-IR', 26, N'انتخاب کشور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19532, N'fa-IR', 27, N'رایگان')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19533, N'fa-IR', 28, N'کلیک')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19534, N'fa-IR', 29, N'نامحدود')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19535, N'fa-IR', 30, N'هفته')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19536, N'fa-IR', 31, N'ماه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19537, N'fa-IR', 32, N' تعداد مراجعات محدود')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19538, N'fa-IR', 33, N'تعداد مراجعات نامحدود')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19539, N'fa-IR', 34, N'محدود به کد پستی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19540, N'fa-IR', 35, N'بدون محدودیت کد پستی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19541, N'fa-IR', 36, N'محدود به کدپستی انتخاب شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19542, N'fa-IR', 37, N'محدود به شهر انتخاب شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19543, N'fa-IR', 38, N'محدود به کشور انتخاب شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19544, N'fa-IR', 39, N'دسترسی به تمامی پروفایل ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19545, N'fa-IR', 40, N'محدود به تعداد روز')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19546, N'fa-IR', 41, N'بدون محدودیت زمانی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19547, N'fa-IR', 42, N'بدون لیست کار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19548, N'fa-IR', 43, N'دریافت لیست کار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19549, N'fa-IR', 44, N'بدون دسترسی به پروفایل های بازدید شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19550, N'fa-IR', 45, N'دسترسی به پروفایل های بازدید شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19551, N'fa-IR', 46, N'خرید کن')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19552, N'fa-IR', 47, N'خدمات اصلی ما')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19553, N'fa-IR', 48, N'اجاره نیروی کار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19554, N'fa-IR', 49, N'گرفتن خرید و فروش کار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19555, N'fa-IR', 50, N'ارتباطات و رویدادها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19556, N'fa-IR', 51, N'خرید و فروش ابزارهای دست دوم')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19557, N'fa-IR', 52, N'خرید و فروش ابزار های نو')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19558, N'fa-IR', 53, N'استفاده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19559, N'fa-IR', 54, N'همانطور که شما می‌خواهید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19560, N'fa-IR', 55, N'دسترسی دیجیتالی در آینده')
GO
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19561, N'fa-IR', 56, N'در مورد این درس بیشتر بخوانید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19562, N'fa-IR', 57, N'رضایتمندی و توصیه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19563, N'fa-IR', 58, N' ثبت نام کنید و به آینده بپیوندید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19564, N'fa-IR', 59, N'ثبت نام کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19565, N'fa-IR', 60, N'رویدادهای آینده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19566, N'fa-IR', 61, N'در تماس باشید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19567, N'fa-IR', 62, N'آدرس')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19568, N'fa-IR', 63, N'پست الکترونیکی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19569, N'fa-IR', 64, N'تلفن')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19570, N'fa-IR', 65, N'ما که هستیم')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19571, N'fa-IR', 66, N'و کجا میرویم')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19572, N'fa-IR', 67, N'به باشگاه خوش آمدید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19573, N'fa-IR', 68, N'به گردهمایی بعدی ما بپیوندید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19574, N'fa-IR', 69, N'بهترین شبکه ارتباطی سال')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19575, N'fa-IR', 70, N'مشاهده تمامی روش ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19576, N'fa-IR', 71, N'شبکه ارتباطی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19577, N'fa-IR', 72, N'تماس با ما')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19578, N'fa-IR', 73, N'اینجا ما را ملاقات کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19579, N'fa-IR', 74, N'جلسه های ارتباطی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19580, N'fa-IR', 75, N'شنبه ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19581, N'fa-IR', 76, N'یکشنبه ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19582, N'fa-IR', 77, N'دوشنبه ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19583, N'fa-IR', 78, N'سه شنبه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19584, N'fa-IR', 79, N'چهارشنبه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19585, N'fa-IR', 80, N'پنجشنبه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19586, N'fa-IR', 81, N'جمعه')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19587, N'fa-IR', 82, N'همین امروز در سیستم ما ثبت نام کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19588, N'fa-IR', 83, N'اسم ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19589, N'fa-IR', 84, N'موضوع')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19590, N'fa-IR', 85, N'پیغام')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19591, N'fa-IR', 86, N'ارسال')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19592, N'fa-IR', 87, N'مشاهده همه اعضا')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19593, N'fa-IR', 88, N'مشاهده همه رویدادها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19594, N'fa-IR', 89, N'مشاهده همه کارها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19595, N'fa-IR', 90, N'فروشگاه اینترنتی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19596, N'fa-IR', 91, N'یک همکاری')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19597, N'fa-IR', 92, N'که از شما پشتیبانی کند')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19598, N'fa-IR', 93, N'همکاری خود را شروع کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19599, N'fa-IR', 94, N'تماس با شعبه محلی اتان')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19600, N'fa-IR', 95, N'بهترین قرارداد')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19601, N'fa-IR', 96, N'از اینجا شروع کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19602, N'fa-IR', 97, N'موقعیت جغرافیایی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19603, N'fa-IR', 98, N'مشاهده نمایندگی ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19604, N'fa-IR', 99, N'از عضویت در این سامانه چه بدست می آورید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19605, N'fa-IR', 100, N'به جلسه ارتباطی بعدی ملحق شوید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19606, N'fa-IR', 101, N'رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19607, N'fa-IR', 102, N'مرا به خاطر بسپار')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19608, N'fa-IR', 103, N'فراموش کردن رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19609, N'fa-IR', 104, N'ورود با استفاده از شبکه اجتماعی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19610, N'fa-IR', 105, N'آدرس الکترونیکی الزامی است')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19611, N'fa-IR', 106, N'رمز عبور اجباری است')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19612, N'fa-IR', 107, N'آدرس الکترونیکی خود را وارد کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19613, N'fa-IR', 108, N'لینک آدرس الکترونیکی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19614, N'fa-IR', 109, N'یک حساب کاربری جدید ایجاد کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19615, N'fa-IR', 110, N'نام کاربری')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19616, N'fa-IR', 111, N'نقش')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19617, N'fa-IR', 112, N'تایید رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19618, N'fa-IR', 113, N'نقش خود را انتخاب کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19619, N'fa-IR', 114, N'شرکت')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19620, N'fa-IR', 115, N'مشتری')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19621, N'fa-IR', 116, N'نیروی کار ماهر')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19622, N'fa-IR', 117, N'پنل مدیریتی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19623, N'fa-IR', 118, N'همه حقوق محفوظ است')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19624, N'fa-IR', 119, N'با حساب شبکه اجتماعی خود وارد شوید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19625, N'fa-IR', 120, N'ورود با شبکه اجتماعی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19626, N'fa-IR', 121, N'خطا')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19627, N'fa-IR', 122, N'یک خطا در هنگام بررسی درخواست شما رخ داد')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19628, N'fa-IR', 123, N'قفل شده')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19629, N'fa-IR', 124, N'این حساب کاربری قفل شده است، لطفا بعدا دوباره امتحان کنید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19630, N'fa-IR', 125, N'شما نام کاربری و کلمه عبور محلی برای این سایت ندارید یک حساب محلی اضافه کنید تا بتوانید بدون حساب کاربری خارجی به سیستم وارد شوید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19631, N'fa-IR', 126, N'ایجاد ورود کاربری محلی')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19632, N'fa-IR', 127, N'تنظیم رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19633, N'fa-IR', 128, N'فرم تغییر رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19634, N'fa-IR', 129, N'تغییر رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19635, N'fa-IR', 130, N'قالب')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19636, N'fa-IR', 131, N'حفاظت')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19637, N'fa-IR', 132, N'نوع')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19638, N'fa-IR', 133, N'شما با موفقیت تهیه شده با استفاده از')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19639, N'fa-IR', 134, N'لطفاً نام کاربری خود را برای این وبسایت وارد کنید و سپس روی دکمه ثبت نام کلیک کنید تا عمل ورود به سیستم پایان یابد')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19640, N'fa-IR', 135, N'ورود ناموفق با سرویس')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19641, N'fa-IR', 136, N'لطفآ آدرس الکترونیکی خود را جهت تغییر رمز عبور چک نمایید ')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19642, N'fa-IR', 137, N'کشور خود را انتخاب نمایید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19643, N'fa-IR', 138, N'تنظیم مجدد')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19644, N'fa-IR', 139, N'تنظیم مجدد رمز عبور')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19645, N'fa-IR', 140, N'رمز عبور شما مجدداً تنظیم گردید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19646, N'fa-IR', 141, N'برای ورود اینجا کلیک نمایید')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19647, N'fa-IR', 142, N'تاریخ ثبت نام')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19648, N'fa-IR', 143, N'نقش ها')
INSERT [dbo].[Dictionary] ([Id], [CultureInfoCode], [RefrenceWordId], [Value]) VALUES (19649, N'fa-IR', 144, N'تایید رمز عبور را فراموش کرده اید')
SET IDENTITY_INSERT [dbo].[Dictionary] OFF
SET IDENTITY_INSERT [dbo].[ExcelDictionary] ON 

INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (1, N'Home', N'صفحه اصلی', N'Home')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (2, N'Services', N'خدمات', N'Services')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (3, N'Partners', N'نمایندگی ها', N'Partners')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (4, N'About us', N'درباره ما', N'About Us')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (5, N'Contact', N'تماس با ما', N'Contact')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (6, N'Login', N'ورود به سیستم', N'Login')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (7, N'Register', N'عضویت', N'Register')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (8, N'Search here', N'جستجو', N'Search Here')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (9, N'Getting started', N'شروع به کار', N'Getting Started')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (10, N'Language', N'زبان', N'Language')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (11, N'Country', N'کشور', N'Country')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (12, N'City', N'شهر', N'City')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (13, N'Postcode', N'کد پستی', N'Postcode')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (14, N'Search by skills', N'تخصص', N'Expertise')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (15, N'Let''s Work Together!', N'همکاری با هم', N'Let''s Work Together!')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (16, N'Join free today', N'عضویت رایگان', N'Join Free Today')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (17, N'Rent workers - Rent out crews - Get or sell construction jobs in your local area or internationally', N'اجاره کردن نیروی کار, اجاره دادن نیروی کار, گرفتن یا واگذاری کارها در مناطق اطراف خود', N'Rent Management - Find Certificate Management - Get Or Sell Tasks In Your Local Area')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (18, N'Profiles, looking for jobs right now', N'پروفایلهای جستجو کننده  کار', N'Profiles, Looking For Jobs Right Now')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (19, N'Offering jobs right now', N'پیشنهادهای کاری', N'Offering Jobs Right Now')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (20, N'International profiles and jobs', N'تمام جستجو کننده های کار و پیشنهادهای کاری', N'International Profiles And Jobs')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (21, N'See all profiles here', N'دیدن تمامی پروفایل ها', N'See All Profiles Here')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (22, N'See all jobs here', N'دیدن تمامی کارها', N'See All Jobs Here')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (23, N'Profiles and jobs', N'پروفایل ها و کارها', N'Profiles And Jobs')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (24, N'Profiles', N'پروفایل ها', N'Profiles')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (25, N'Jobs', N'کارها', N'Jobs')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (26, N'Select country', N'انتخاب کشور', N'Select Country')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (27, N'Free', N'رایگان', N'Free')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (28, N'click', N'کلیک', N'click')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (29, N'Unlimited', N'نامحدود', N'Unlimited')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (30, N'week', N'هفته', N'week')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (31, N'month', N'ماه', N'month')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (32, N'Limited profile visit', N' تعداد مراجعات محدود', N'Limited Profile Visit')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (33, N'Unlimited profile visit', N'تعداد مراجعات نامحدود', N'Unlimited Profile Visit')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (34, N'Limited to living postcode', N'محدود به کد پستی', N'Limited To Living Postcode')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (35, N'No limitation to postcode', N'بدون محدودیت کد پستی', N'No Limitation To Postcode')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (36, N'Limited to chosen postcode', N'محدود به کدپستی انتخاب شده', N'Limited To Chosen Postcode')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (37, N'Limited to chosen city', N'محدود به شهر انتخاب شده', N'Limited To Chosen City')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (38, N'Limited to chosen country', N'محدود به کشور انتخاب شده', N'Limited To Chosen Country')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (39, N'Access to entire profiles', N'دسترسی به تمامی پروفایل ها', N'Access To Entire Profiles')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (40, N'Limited days', N'محدود به تعداد روز', N'Limited Days')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (41, N'No time limitation', N'بدون محدودیت زمانی', N'No Time Limitation')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (42, N'No job list', N'بدون لیست کار', N'No Job/Labor List')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (43, N'Receive job list', N'دریافت لیست کار', N'Receive Job/Labor List')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (44, N'No access to visited profiles', N'بدون دسترسی به پروفایل های بازدید شده', N'No Access To Visited Profiles')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (45, N'Access to visited profiles', N'دسترسی به پروفایل های بازدید شده', N'Access To Visited Profiles')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (46, N'Buy Now', N'خرید کن', N'Buy Now')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (47, N'Our services', N'خدمات اصلی ما', N'Our Main Services')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (48, N'Rent crew', N'اجاره نیروی کار', N'Rent Crew')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (49, N'Get, buy & sell jobs', N'گرفتن خرید و فروش کار', N'Get, Buy & Sell Jobs')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (50, N'Networks & Events', N'ارتباطات و رویدادها', N'Networks & Events')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (51, N'Buy & sell used equipments', N'خرید و فروش ابزارهای دست دوم', N'Buy & Sell Used Equipments')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (52, N'Buy & sell new equipments', N'خرید و فروش ابزار های نو', N'Buy & Sell New Equipments')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (53, N'Use', N'استفاده', N'Use')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (54, N'As you wish', N'همانطور که شما می‌خواهید', N'As You Wish')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (55, N'Future digital access', N'دسترسی دیجیتالی در آینده', N'Future Digital Access')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (56, N'Read more about System', N'در مورد این درس بیشتر بخوانید', N'Read More About Cookiejar')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (57, N'Testimonial', N'رضایتمندی و توصیه', N'Testimonial')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (58, N'Sign up now and be a part of a future', N' ثبت نام کنید و به آینده بپیوندید', N'Sign Up Now And Be A Part Of A Future')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (59, N'Sign me up', N'ثبت نام کنید', N'Sign Me')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (60, N'Upcoming events', N'رویدادهای آینده', N'Upcoming Events')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (61, N'Get in touch', N'در تماس باشید', N'Get In Touch')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (62, N'Address', N'آدرس', N'Address')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (63, N'E-Mail', N'پست الکترونیکی', N'E-Mail')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (64, N'Phone', N'تلفن', N'Phone')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (65, N'Who are we', N'ما که هستیم', N'Who Are We')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (66, N'and where are we going', N'و کجا میرویم', N'And Where Are We Going')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (67, N'Welcome to the club', N'به باشگاه خوش آمدید', N'Welcome To The Club')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (68, N'Join our next meeting', N'به گردهمایی بعدی ما بپیوندید', N'Join Our Next Meeting')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (69, N'The best network of the year', N'بهترین شبکه ارتباطی سال', N'The Best Network Of The Year')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (70, N'See all genre', N'مشاهده تمامی روش ها', N'See All Genre')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (71, N'Network', N'شبکه ارتباطی', N'Network')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (72, N'Contact us', N'تماس با ما', N'Contact Us')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (73, N'Meet us here', N'اینجا ما را ملاقات کنید', N'Meet Us Here')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (74, N'Network meetings', N'جلسه های ارتباطی', N'Network Meetings')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (75, N'Saturday ', N'شنبه ', N'Saturday ')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (76, N'Sunday ', N'یکشنبه ', N'Sunday ')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (77, N'Monday ', N'دوشنبه ', N'Monday ')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (78, N'Tuesday', N'سه شنبه', N'Tuesday')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (79, N'Wednesday', N'چهارشنبه', N'Wednesday')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (80, N'Thursday', N'پنجشنبه', N'Thursday')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (81, N'Friday', N'جمعه', N'Friday')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (82, N'Sign up to System today', N'همین امروز در سیستم ما ثبت نام کنید', N'Sign Up To Cookiejar Today')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (83, N'Name', N'اسم ', N'Name')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (84, N'Subject', N'موضوع', N'Subject')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (85, N'Message', N'پیغام', N'Message')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (86, N'Send', N'ارسال', N'Send')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (87, N'See all members', N'مشاهده همه اعضا', N'See All Members')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (88, N'See all events', N'مشاهده همه رویدادها', N'See All Events')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (89, N'See all jobs', N'مشاهده همه کارها', N'See All Jobs')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (90, N'Webshop', N'فروشگاه اینترنتی', N'Web Shop')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (91, N'A network', N'یک همکاری', N'A Cooperation')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (92, N'That supports you', N'که از شما پشتیبانی کند', N'That Supports You')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (93, N'Start working with us', N'همکاری خود را شروع کنید', N'Start Your Cooperation')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (94, N'Contact your local branch', N'تماس با شعبه محلی اتان', N'Contact Your Local Branch')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (95, N'The best contracts', N'بهترین قرارداد', N'The Best Contracts')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (96, N'Starts here', N'از اینجا شروع کنید', N'Starts Here')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (97, N'Geographical location', N'موقعیت جغرافیایی', N'Geographical Location')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (98, N'See all representatives', N'مشاهده نمایندگی ها', N'See All Representatives')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (99, N'What do you gain from your membership', N'از عضویت در این سامانه چه بدست می آورید', N'What Do You Gain From Buying Indicative Here?')
GO
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (100, N'Join the next network meeting', N'به جلسه ارتباطی بعدی ملحق شوید', N'Join To The Next Network Meeting')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (101, N'Password', N'رمز عبور', N'Password')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (102, N'Remember me?', N'مرا به خاطر بسپار', N'Remember Me?')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (103, N'Forgot password?', N'فراموش کردن رمز عبور', N'Forgot Password?')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (104, N'Social network account log in', N'ورود با استفاده از شبکه اجتماعی', N'Social Network Account Log In')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (105, N'Email is required', N'آدرس الکترونیکی الزامی است', N'The Email Is Required.')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (106, N'Password is required', N'رمز عبور اجباری است', N'The Password Is Required.')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (107, N'Enter your email', N'آدرس الکترونیکی خود را وارد کنید', N'Enter Your Email')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (108, N'Email link', N'لینک آدرس الکترونیکی', N'Email Link')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (109, N'Create a new account', N'یک حساب کاربری جدید ایجاد کنید', N'Create A New Account')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (110, N'User name', N'نام کاربری', N'User Name')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (111, N'Role', N'نقش', N'Role')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (112, N'Confirm password', N'تایید رمز عبور', N'Confirm Password')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (113, N'Select your role', N'نقش خود را انتخاب کنید', N'Select Your Role')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (114, N'Company', N'شرکت', N'Company')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (115, N'Customer', N'مشتری', N'Customer')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (116, N'Skilled worker', N'نیروی کار ماهر', N'Skilled Worker')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (117, N'Admin panel', N'پنل مدیریتی', N'Admin Panel')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (118, N'All rights reserved', N'همه حقوق محفوظ است', N'All Rights Reserved')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (119, N'Login with your social network account', N'با حساب شبکه اجتماعی خود وارد شوید', N'Login With Your Social Network Account')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (120, N'Social login', N'ورود با شبکه اجتماعی', N'Social Login')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (121, N'Error', N'خطا', N'Error')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (122, N'An error occurred while processing your request', N'یک خطا در هنگام بررسی درخواست شما رخ داد', N'An Error Occurred While Processing Your Request')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (123, N'Locked out', N'قفل شده', N'Locked Out')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (124, N'This account has been locked out, please try again later', N'این حساب کاربری قفل شده است، لطفا بعدا دوباره امتحان کنید', N'This Account Has Been Locked Out, Please Try Again Later')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (126, N'Create local login', N'ایجاد ورود کاربری محلی', N'Create Local Login')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (127, N'Set password', N'تنظیم رمز عبور', N'Set Password')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (128, N'Change password form', N'فرم تغییر رمز عبور', N'Change Password Form')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (129, N'Change password', N'تغییر رمز عبور', N'Change Password')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (130, N'Format', N'قالب', N'Format')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (131, N'Protection', N'حفاظت', N'Protection')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (132, N'Type', N'نوع', N'Type')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (133, N'You''ve successfully authenticated with', N'شما با موفقیت تهیه شده با استفاده از', N'You''ve Successfully Authenticated With')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (125, N'You do not have a local username/password for this site. add a local account so you can log in without an external login.', N'شما نام کاربری و کلمه عبور محلی برای این سایت ندارید یک حساب محلی اضافه کنید تا بتوانید بدون حساب کاربری خارجی به سیستم وارد شوید', N'You Do Not Have A Local Username/Password For This Site. Add A Local Account So You Can Log In Without An External Login.')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (134, N'Please enter a username for this site below and click the register button to finish logging in.', N'لطفاً نام کاربری خود را برای این وبسایت وارد کنید و سپس روی دکمه ثبت نام کلیک کنید تا عمل ورود به سیستم پایان یابد', N'Please Enter E-Mail For This Site Below And Click The Register Button To Finish Logging In.')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (135, N'Unsuccessful login with service', N'ورود ناموفق با سرویس', N'Unsuccessful Login With Service')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (136, N'Please check your email to reset your password', N'لطفآ آدرس الکترونیکی خود را جهت تغییر رمز عبور چک نمایید ', N'Please Check Your Email To Reset Your Password')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (137, N'Select your countries', N'کشور خود را انتخاب نمایید', N'Select Your Countries')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (138, N'Reset', N'تنظیم مجدد', N'Reset')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (139, N'Reset your password', N'تنظیم مجدد رمز عبور', N'Reset Your Password')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (140, N'Your password has been reset', N'رمز عبور شما مجدداً تنظیم گردید', N'Your Password Has Been Reset')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (141, N'Click here to log in', N'برای ورود اینجا کلیک نمایید', N'Click Here To Log In')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (142, N'Register date', N'تاریخ ثبت نام', N'Register Date')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (143, N'Roles', N'نقش ها', N'Roles')
INSERT [dbo].[ExcelDictionary] ([Id], [en-US], [fa-IR], [Orig]) VALUES (144, N'Forgot password confirmation', N'تایید رمز عبور را فراموش کرده اید', N'Forgot Password Confirmation')
SET IDENTITY_INSERT [dbo].[ExcelDictionary] OFF
SET IDENTITY_INSERT [dbo].[Image] ON 

INSERT [dbo].[Image] ([Id], [Title], [Type], [ImageUrl], [JournalId], [Priority]) VALUES (1, N'', 0, N'/Resources/Uploaded/Images/1.jpg', NULL, 1)
INSERT [dbo].[Image] ([Id], [Title], [Type], [ImageUrl], [JournalId], [Priority]) VALUES (2, N'', 0, N'/Resources/Uploaded/Images/2.jpg', NULL, 2)
INSERT [dbo].[Image] ([Id], [Title], [Type], [ImageUrl], [JournalId], [Priority]) VALUES (3, N'', 0, N'/Resources/Uploaded/Images/3.jpg', NULL, 3)
INSERT [dbo].[Image] ([Id], [Title], [Type], [ImageUrl], [JournalId], [Priority]) VALUES (4, N'', 0, N'/Resources/Uploaded/Images/4.jpg', NULL, 4)
INSERT [dbo].[Image] ([Id], [Title], [Type], [ImageUrl], [JournalId], [Priority]) VALUES (5, N'', 0, N'/Resources/Uploaded/Images/20180921220249banner_1024.jpg?CT=image_jpeg.png', NULL, 5)
INSERT [dbo].[Image] ([Id], [Title], [Type], [ImageUrl], [JournalId], [Priority]) VALUES (6, N'', 0, N'/Resources/Uploaded/Images/6.jpg', NULL, 6)
INSERT [dbo].[Image] ([Id], [Title], [Type], [ImageUrl], [JournalId], [Priority]) VALUES (7, N'', 0, N'/Resources/Uploaded/Images/7.jpg', NULL, 7)
SET IDENTITY_INSERT [dbo].[Image] OFF
SET IDENTITY_INSERT [dbo].[Journal] ON 

INSERT [dbo].[Journal] ([Id], [Name], [SubjectId], [ImageUrl], [DisplayByDefault], [Priority], [Type], [Description]) VALUES (6014, N'Journal of Biostructures', 2, N'/Resources/Uploaded/Journals/Images/20180902160010journal of biostructure cover.png?CT=image_png.png', 1, N'xxxx-xxxx', NULL, N'<h2><br></h2>')
INSERT [dbo].[Journal] ([Id], [Name], [SubjectId], [ImageUrl], [DisplayByDefault], [Priority], [Type], [Description]) VALUES (7015, N'Journal of Medical Geography', 2, N'/Resources/Uploaded/Journals/Images/20180902123418medical geography 1.png?CT=image_png.png', 1, N'xxxx-xxxx', NULL, N'<br>')
INSERT [dbo].[Journal] ([Id], [Name], [SubjectId], [ImageUrl], [DisplayByDefault], [Priority], [Type], [Description]) VALUES (7016, N'International Journal of Optimization in Electrical Engineering', 1023, N'/Resources/Uploaded/Journals/Images/20180916145542photo_2018-09-02_16-20-13.jpg?CT=image_jpeg.png', 1, N'xxxx-xxxx', NULL, NULL)
SET IDENTITY_INSERT [dbo].[Journal] OFF
SET IDENTITY_INSERT [dbo].[SubjectField] ON 

INSERT [dbo].[SubjectField] ([Id], [Name], [JournalId]) VALUES (24, N'Journal of Biostructures', 6014)
INSERT [dbo].[SubjectField] ([Id], [Name], [JournalId]) VALUES (25, N'Journal of Medical Geography', 7015)
INSERT [dbo].[SubjectField] ([Id], [Name], [JournalId]) VALUES (26, N'Power electric', 7016)
INSERT [dbo].[SubjectField] ([Id], [Name], [JournalId]) VALUES (27, N'Electronic', 7016)
SET IDENTITY_INSERT [dbo].[SubjectField] OFF
SET IDENTITY_INSERT [dbo].[JournalPage] ON 

INSERT [dbo].[JournalPage] ([Id], [JournalId], [Caption], [HTMLContent], [Priority]) VALUES (1024, 6014, N'Journal’s Aim and Scope', N'<div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" style="font-size: small;">International Journal of Economics and Financial Research is an international peer reviewed and open access journal published by ARPG. &nbsp;IJFER promotes and publishes high quality genuine research that contributes significantly to the fields of economics and finance. IJFER covers both theoretical and applied issues in the fields of social economics. &nbsp;This peer reviewed journal is published on monthly basis.</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2"><br></font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2" color="#ff0000">The scope of the journal includes but not limited to:</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2"><br></font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Financial Economics</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Environmental and Ecological Economics</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Economic History</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Economic Systems</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Industrial Organization</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Labor and Demographic Economics</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Law and Economics</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Mathematical and Quantitative Methods</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Macroeconomic and Monetary Economics</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Methodology and History of Economic Thought</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">International Economics</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Technological Change and Growth</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Microeconomics</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Health</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Educational Economic&nbsp;</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Welfare</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Public Economics</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Economic Development</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Urban</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Agricultural and Natural Resource Economics</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Rural and Regional Economics</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Industrial Economics</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Market Economics</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px; text-align: justify;"><font face="trebuchet ms" size="2">Transport Economics</font></div>', 0)
INSERT [dbo].[JournalPage] ([Id], [JournalId], [Caption], [HTMLContent], [Priority]) VALUES (1025, 6014, N'Instructions', N'<div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; text-align: justify;"><div><font face="trebuchet ms" size="2">Respected authors may submit their manuscript through online submission system. For this, they are supposed to follow some easy steps.</font></div><div><font face="trebuchet ms" size="2"><br></font></div><div><font face="trebuchet ms" size="2">a.</font><span style="white-space: pre;"><font face="trebuchet ms" size="2"><span style="white-space: normal;">	</span></font></span><font face="trebuchet ms" size="2">Go to the desired journal’s webpage.</font></div><div><font face="trebuchet ms" size="2">b.</font><span style="white-space: pre;"><font face="trebuchet ms" size="2"><span style="white-space: normal;">	</span></font></span><font face="trebuchet ms" size="2">Click Submit Manuscripts button located on the right side of the page.</font></div><div><font face="trebuchet ms" size="2">c.</font><span style="white-space: pre;"><font face="trebuchet ms" size="2"><span style="white-space: normal;">	</span></font></span><font face="trebuchet ms" size="2">Fill online submission form, attach manuscript and then click Submit button at the end of the page.</font></div><div><font face="trebuchet ms" size="2"><br></font></div><div><font face="trebuchet ms" size="2"><span style="font-weight: 700;">Note</span>: Authors are requested to submit the manuscript in MS Word not in PDF or any other format.</font></div><div><font face="trebuchet ms" size="2"><br></font></div><div><font face="trebuchet ms" size="2">Authors also may submit their manuscripts by email as an attachment to&nbsp;<font color="#0000ff">editor@arpgweb.com, info@arpgweb.com</font></font></div><div><font face="trebuchet ms" size="2"><span style="font-weight: 700;">Gmail</span>:&nbsp;<font color="#0000ff">editorarpg@gmail.com; infoarpg@gmail.com</font></font></div></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; text-align: justify;"><font face="trebuchet ms" size="2"><br><div style="text-align: center;"><span style="font-weight: 700;"><font color="#ff0000">Manuscript Submission by Email<br></font></span></div><div>Authors also may submit their manuscript by email as an attachment to&nbsp;<font color="#3300cc">editor@arpgweb.com, info@arpgweb.com.</font></div></font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; text-align: justify;"><font face="trebuchet ms" size="2"><br></font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; text-align: center;"><div><font face="trebuchet ms" size="2" color="#ff0000">Paper Language</font></div><div style="text-align: justify;"><font face="trebuchet ms" size="2">Authors are asked to submit the manuscript written in English language. Manuscripts written in other language are not acceptable.</font></div></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; text-align: center;"><font face="trebuchet ms" size="2"><br></font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; text-align: center;"><font face="trebuchet ms" size="2" color="#ff0000">Reviewers Suggestion</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; text-align: justify;"><font face="trebuchet ms" size="2">Authors should suggest two potential reviewers. May be the editor make contact with the potential reviewers but it is not sure. While suggesting potential reviewers authors must keep some points in mind.</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><div style="text-align: justify;"><div><font face="trebuchet ms" size="2">Authors should suggest two potential reviewers who may be contacted by the editor if needed. While suggesting potential reviewers authors must keep some points in mind.</font></div><div><font face="trebuchet ms" size="2"><br></font></div><div><span style="font-weight: 700;"><font face="trebuchet ms" size="2">a.</font></span><span class="Apple-tab-span" style="white-space: pre;"><span style="line-height: normal;"></span></span><font face="trebuchet ms" size="2">Suggested reviewers should not be from co-authors.</font></div><div><span style="font-weight: 700;"><font face="trebuchet ms" size="2">b.</font></span><span class="Apple-tab-span" style="white-space: pre;"><span style="line-height: normal;"></span></span><font face="trebuchet ms" size="2">Suggested reviewers should not be from authors’ university.</font></div><div><span style="font-weight: 700;"><font face="trebuchet ms" size="2">c.</font></span><span class="Apple-tab-span" style="white-space: pre;"><span style="line-height: normal;"></span></span><font face="trebuchet ms" size="2">Suggested reviewers should not have any publication with authors during the last 5 years.</font></div><div><span style="font-weight: 700;"><font face="trebuchet ms" size="2">d.</font></span><span class="Apple-tab-span" style="white-space: pre;"><span style="line-height: normal;"></span></span><font face="trebuchet ms" size="2">Suggested reviewers must have expertise in the respective field of study.<br><br></font><span style="font-weight: 700; text-align: center;"><span style="font-weight: 700; line-height: 18px;"><font color="#009900" size="2" face="times new roman"><a href="http://arpgweb.com/index.php?ic=contents&amp;id=26" title="" target="" style="color: rgb(51, 122, 183);">Publication Fee<br></a></font></span></span></div><div><br></div></div></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; text-align: center;"><div><font face="trebuchet ms" size="2" color="#ff0000"><span style="font-weight: 700;">Manuscript&nbsp;</span><span style="line-height: normal; text-align: justify;"><span style="font-weight: 700;">Preparation</span></span></font></div><div style="text-align: justify;"><div><font face="trebuchet ms" size="2"><span style="font-weight: 700;"><font color="#ff0000">Title</font>:</span>&nbsp;Paper must contain full title, author,s full name, email address, affiliation and contact number.</font></div><div><font face="trebuchet ms" size="2"><span style="font-weight: 700;"><font color="#ff0000">Abstract</font>:</span>&nbsp;The Abstract of the manuscript should state the scope of the experiment and indicate significant data and point out major findings and conclusion. Submitted manuscript should be in MS Word and must have an abstract not more than&nbsp;<span style="font-weight: 700;">350</span>&nbsp;words. Abstract should include background, experiment and conclusion.</font></div><div><font face="trebuchet ms" size="2"><span style="font-weight: 700;"><font color="#ff0000">Keywords</font>:&nbsp;</span>After abstract 4-6 key words must be added.</font></div><div><div><font face="trebuchet ms" size="2"><span style="font-weight: 700;"><font color="#ff0000">Introduction</font>:</span>&nbsp;An introduction should include a clear statement of the problem, the relevant literature on the subject and the proposed approach or solution. It should be easy and understandable.</font></div><div><font face="trebuchet ms" size="2"><span style="line-height: normal;"><span style="font-weight: 700;"><font color="#ff0000">Materials and methods</font>:&nbsp;</span>There should be&nbsp;</span>clearly explained&nbsp;<span style="line-height: normal;">Materials and methods&nbsp;</span>to allow possible replication of the research. The true new research method should be described in detail; previously published methods should be cited and important modifications of published methods should be mentioned in detail.</font></div><div><font face="trebuchet ms" size="2"><span style="font-weight: 700;"><font color="#ff0000">Results</font>:</span>&nbsp;The results should be presented clearly and precisely. The results should be written in the past tense when describing author’s findings. Previously published findings should be written in the present tense.&nbsp;</font></div><div><font face="trebuchet ms" size="2"><span style="font-weight: 700;"><font color="#ff0000">Discussion</font>:</span>&nbsp;The Discussion should interpret the findings in view of the results obtained in this and in the past studies on this topic.&nbsp;</font></div><div><font face="trebuchet ms" size="2"><span style="font-weight: 700;"><font color="#ff0000">Conclusion</font>:</span>&nbsp;State the conclusions in a few sentences at the end of the paper. The Results and Discussion section may include subheadings, and if appropriate, both sections can be combined.</font></div><font face="trebuchet ms" size="2"><span style="font-weight: 700;"><font color="#ff0000">Abbreviation</font>:</span>&nbsp;Abbreviated words should be written in full by mentioning in the parenthesis.<br><span style="line-height: normal;"><span style="font-weight: 700;"><font color="#ff0000">Illustration</font>:</span>&nbsp;</span>Illustrations should be submitted sequentially with numbered figures. It should not be inserted in the manuscript but supplied after the main body of the text.<br><span style="font-weight: 700;"><font color="#ff0000">Tables</font>:</span>&nbsp;Tables should be added with number and short heading.&nbsp;<br><span style="font-weight: 700;"><font color="#ff0000">Footnotes</font>:&nbsp;</span>These should be numbered consecutively in the text.</font></div><div><font face="trebuchet ms" size="2"><span style="line-height: normal;"><span style="font-weight: 700;"><font color="#ff0000">Acknowledgments</font>:</span>&nbsp;</span>Acknowledgments should be included at the end of the paper and before the references.<br><span style="font-weight: 700;"><font color="#ff0000">Appendix</font>:&nbsp;</span>It should be added at the end of the manuscript.</font></div><div><font face="trebuchet ms" size="2"><span style="font-weight: 700;"><font color="#ff0000">Reference</font>:</span>&nbsp;All references should be listed at the end of the paper. All references should be completed as quoted in the following examples:</font></div><div><span style="font-weight: 700;"><font face="trebuchet ms" size="2"><br></font></span></div><div><span style="font-weight: 700;"><font face="trebuchet ms" size="2" color="#ff0000">Example for Journal Reference:</font></span></div><div><font face="trebuchet ms" size="2">Buckner, V. J. E., Castille, C. M.and Sheets, T. L. (2012). The Five Factor Model of personality and employees’ excessive use of technology. Computers in Human Behavior, 28(5): 1947-53.</font></div><div><font face="trebuchet ms" size="2"><font color="#ff0000"><span style="font-weight: 700;">Example for Book Reference:</span><br></font>Iucu, R. and PÄƒcurari, O. (2001). Initial and continuous training. Humanitas: Bucharest.<br><font color="#ff0000"><span style="font-weight: 700;">Example for Conference Reference:&nbsp;</span><br></font>Enache, R. and Herseni, I. (2010)."Reform and quality in Romanian teacher training".UNESCO Sub-regional Conference of the Countries from South East Europe Quality Education for All Through Improving Teacher Training, 22-24 aprilie 2010.Sofia. ISBN: 978-954-326-120-8. pp: 74-84.</font></div></div></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; text-align: justify;"><font face="trebuchet ms" size="2"><br></font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; text-align: center;"><font face="trebuchet ms" size="2" color="#ff0000">Submission Status</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; text-align: justify;"><div><div><font face="trebuchet ms" size="2">After the submission author may inquire the status of the submission by email on&nbsp;<font color="#0000ff">status@arpgweb.com. statusarpg@gmail.com</font></font></div><div><font face="trebuchet ms" size="2"><br></font></div><div><font face="trebuchet ms" size="2">For status inquiry authors need to send the title of the manuscript and mention the journal in which they have submitted the manuscript.&nbsp;</font></div><div><font face="trebuchet ms" size="2">Authors’ mail will be responded in a short time. They will be informed about manuscript status and provided the paper id for future correspondence.&nbsp;</font></div></div><div><font face="trebuchet ms" size="2">Authors also may know the status of their submission through online system by logging in where they may view the status of their submission.</font></div></div>', 0)
INSERT [dbo].[JournalPage] ([Id], [JournalId], [Caption], [HTMLContent], [Priority]) VALUES (1026, 6014, N'Editorial Board', N'<h2 class="title-border-left" style="font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; color: rgb(0, 0, 0); margin-right: 0px; margin-left: 0px; padding: 5px 0px; font-size: 30px;">Editorial Board of Journal of Biostructures</h2><div align="center" class="row" style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"></div><div align="center" class="row" style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"></div>', 0)
INSERT [dbo].[JournalPage] ([Id], [JournalId], [Caption], [HTMLContent], [Priority]) VALUES (1027, 6014, N'Open Access License', N'<h1 style="margin-top: 20px; padding: 5px 0px; font-size: 36px; line-height: 1.1;">About</h1><div style="text-align: justify;"><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><span style="font-size: small;"><font face="trebuchet ms">Academic Research Publishing Group (ARPG) is a publisher of peer reviewed international journals. It aims to promote research the World over in numerous disciplines including science, engineering, management, technology, social sciences, economics, language and literature. ARPG is an open access publisher because all journals of international repute provide free access to the complete text of articles just on single click. ARPG publishes articles after they are peer reviewed and edited by some World’s leading researchers, authors and scholars. ARPG allows anyone in the World to adapt copy and use the work printed. The original work and sources are cited properly.&nbsp;</font></span></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">ARPG publishes manuscripts after they are peer reviewed and edited by some of the World’s leading researchers and editors. ARPG allows anyone in the World to adapt, copy and use the work printed. The original work and sources are cited properly</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms"><br></font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms" color="#ff3300">Open Access</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">Academic Research Publishing Group (ARPG) is an open access publisher of peer reviewed international journals. It provides free access to its users to the full text of articles. All our publications are free access and easy to track on just single click. ARPG provides instant visibility of the published manuscript after they are accepted after peer review.</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms"><br></font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">All our journals are open access, which means that all contents are freely available without charge to the users. The users are allowed freely to read, copy, download, print, search and distribute the full text of the articles. They don’t need any prior permission from the publisher and the authors.</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms"><br></font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">The modest open access publication costs are usually covered by the author’s institution or research funds. ARPG Open access journals are not different from traditional subscription-based journals; they undergo the same peer-review and quality control process as any other scholarly journals.<br><br></font><div><font size="2" face="trebuchet ms"><span style="font-weight: 700; color: rgb(255, 51, 0);">Open Access License</span><br><div><font color="#000000"><br>Academic Research Publishing Group publishes its work open access under license</font>&nbsp;<a href="http://creativecommons.org/licenses/by/4.0/" target="_blank" title="" style="color: rgb(15, 90, 156);">Creative Commons licenses</a>&nbsp;to ensure the complete open access availability of the published work.<font color="#000000"><br><br></font><img src="https://www.arpgweb.com/images/149882235194477.png"><font color="#000000">&nbsp;CC BY:&nbsp;<a href="https://creativecommons.org/licenses/by/4.0/" title="" target="_blank" style="color: rgb(51, 122, 183);">Creative Commons Attribution License 4.0</a><br><br></font></div><div><font color="#000000">You are free to:</font></div><div><font color="#000000">Share — copy and redistribute the material in any medium or format</font></div><div><font color="#000000">Adapt — remix, transform, and build upon the material</font></div><div><font color="#000000">For any purpose, even commercially.<br><br></font></div><div><font color="#000000">The licensor cannot revoke these freedoms as long as you follow the license terms.</font></div></font></div><div><font size="2" face="trebuchet ms" color="#ff3300"><br></font></div><font size="2" face="trebuchet ms"><br></font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms" color="#ff3300">Aim of ARPG</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">It aims to promote to research the World over in numerous disciplines including science, engineering, management, education, technology, agriculture, health science, social sciences, economics, Biotechnology, language and literature.</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms"><br></font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">ARPG’s major aims are:</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms"><br></font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">1. Coverage to all disciplines.<br>2. Fast review and publication.</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">3. To provide immediate access.</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">4. To provide higher and international visibility.</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">5. To give foot review.</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">6. To provide easy tracking.</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">7. To serve at minimal cost.</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">8. To ensure online submission of manuscripts.</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">9. To ensure high quality research in all disciplines.</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms"><br></font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms" color="#ff3300">Benefits of publishing with ARPG Journals</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">Articles will obtain more citations.&nbsp;</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">Articles will be freely available without subscription or price barriers.&nbsp;</font></div><div style="color: rgb(0, 0, 0); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;"><font size="2" face="trebuchet ms">Articles will be peer-reviewed and published very fast.&nbsp;</font></div><div><font size="2" face="trebuchet ms"><br></font></div></div>', 0)
INSERT [dbo].[JournalPage] ([Id], [JournalId], [Caption], [HTMLContent], [Priority]) VALUES (2028, 7015, N'Aims and scope of journal', N'<p class="norm" style="font-size: 12.96px; color: rgb(0, 0, 0); font-family: Verdana, arial, Helvetica, sans-serif;"><span class="journalname" style="font-style: italic;">Journal of Medical Geography</span>&nbsp;seeks to cover basic and clinical studies in all aspects of human Health in different regions, including experimental models specific to human diseases in various parts of the world..</p><p class="norm" style="font-size: 12.96px; color: rgb(0, 0, 0); font-family: Verdana, arial, Helvetica, sans-serif;">Topics of particular interest within the journal’s scope include, but are not limited to, those listed below:</p><div><font color="#000000" face="Verdana, arial, Helvetica, sans-serif">-</font></div><div><font color="#000000" face="Verdana, arial, Helvetica, sans-serif">-</font></div><div><font color="#000000" face="Verdana, arial, Helvetica, sans-serif">-</font></div><div><font color="#000000" face="Verdana, arial, Helvetica, sans-serif">-</font></div><div><font color="#000000" face="Verdana, arial, Helvetica, sans-serif">-</font></div><div><br></div><div><font color="#000000" face="Verdana, arial, Helvetica, sans-serif"><br></font></div><p class="norm" style="font-size: 12.96px; color: rgb(0, 0, 0); font-family: Verdana, arial, Helvetica, sans-serif;">The journal publishes peer-reviewed&nbsp;<span class="b" style="font-weight: bold;">Original Articles</span>,&nbsp;<span class="b" style="font-weight: bold;">Case Reports</span>&nbsp;and&nbsp;<span class="b" style="font-weight: bold;">Reviews</span>. In addition,&nbsp;<span class="b" style="font-weight: bold;">Research Summaries</span>&nbsp;are provided for selected articles.&nbsp;<span class="b" style="font-weight: bold;">Editorial</span>&nbsp;articles are brief comments written by the editor(s) of the journal or by guest editor(s) of Special Features based on the contents of the current issue or topical subjects that fall within the scope of the journal.&nbsp;<span class="b" style="font-weight: bold;">Letters to the Editor&nbsp;</span>present preliminary reports of unusual urgency, significance and interest, whose subjects may be republished in expanded form.</p><p class="norm" style="font-size: 12.96px; color: rgb(0, 0, 0); font-family: Verdana, arial, Helvetica, sans-serif;">Reviews can be submitted by authors without invitation but authors are encouraged to submit an abstract of the review to the Editorial Office (xxxx@xxxxx.com) to consider for suitability prior to submission of a full article. Submissions of Review articles from outstanding graduate students are also encouraged under the following conditions:</p><ul style="color: rgb(0, 0, 0); font-family: Verdana, arial, Helvetica, sans-serif; font-size: 14.4px;"><li style="font-size: 12.96px;">An abstract of the review should be submitted to the Editorial Office (<a href="mailto:cti.office@wehi.edu.au" style="color: rgb(63, 106, 179);">x</a>xxxx.@xxxxx.com) to consider for suitability prior to the submission of a full article</li><li style="font-size: 12.96px;">The student''s supervisor who has most expertise in the area being reviewed must be a participatory co-author on the paper</li><li style="font-size: 12.96px;">The article should encompass a critical assessment of an area: the timeliness of this assessment should be explicitly justified</li></ul><a href="https://www.nature.com/cti/about/index.html#top" class="backtotop" style="color: rgb(255, 255, 255); float: right; margin-top: 5px; margin-right: 10px; margin-left: 7px; padding-left: 10px; font-size: 10.08px; background: url(&quot;/common/images/arrow_white_up.gif&quot;) 0px 0.6em no-repeat rgb(255, 255, 255); font-family: Verdana, arial, Helvetica, sans-serif;">Top</a>', 1)
INSERT [dbo].[JournalPage] ([Id], [JournalId], [Caption], [HTMLContent], [Priority]) VALUES (2029, 7015, N'Guides for Author', N'<p class="norm" style="font-size: 12.96px; color: rgb(0, 0, 0); font-family: Verdana, arial, Helvetica, sans-serif;"><br></p>', 0)
INSERT [dbo].[JournalPage] ([Id], [JournalId], [Caption], [HTMLContent], [Priority]) VALUES (2030, 7015, N'Ehtical code', N'<div><span style="color: rgb(0, 0, 0); font-family: Verdana, arial, Helvetica, sans-serif; font-size: 12.96px;"><br></span></div>', 3)
INSERT [dbo].[JournalPage] ([Id], [JournalId], [Caption], [HTMLContent], [Priority]) VALUES (2031, 7015, N'Journal Policies', NULL, 0)
INSERT [dbo].[JournalPage] ([Id], [JournalId], [Caption], [HTMLContent], [Priority]) VALUES (2032, 7015, N'Contact us', NULL, 2)
INSERT [dbo].[JournalPage] ([Id], [JournalId], [Caption], [HTMLContent], [Priority]) VALUES (2033, 7015, N'Peer Review Policy', NULL, 0)
INSERT [dbo].[JournalPage] ([Id], [JournalId], [Caption], [HTMLContent], [Priority]) VALUES (2034, 7016, N'Aims and scope ', N'<p class="MsoNormal" style="text-align:justify;direction:ltr;unicode-bidi:embed"><span style="font-size: medium; background-color: initial;">International Journal of Optimization in Electrical
Engineering (IJOEE), commencing from September, 2018, is a newly established
international academic journal in English and is published quarterly. It is
sponsored by Islamic Azad University.</span><br></p>

<p class="MsoNormal" style="text-align:justify;direction:ltr;unicode-bidi:embed"><span style="font-size: medium;">IJOEE publishes original, peer-reviewed, high-quality
academic papers and review articles by international researchers. Its aim is to
be one of the international academic journals with high reputation in this
field.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify;direction:ltr;unicode-bidi:embed"><span style="font-size: medium;">Innovation in optimization is an essential attribute
of all papers but engineering applicability is equally vital.<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify;direction:ltr;unicode-bidi:embed"><span style="font-size: medium;">IJOEE scope includes all branches of the electrical
engineering, especially in power systems. It is mainly focused on the following
aspects but not limited:<o:p></o:p></span></p>

<p class="MsoNormal" style="text-align:justify;direction:ltr;unicode-bidi:embed"><ul><li>Renewable Energy Systems<br></li><li>Power Electronics on Power System Applications<br></li><li>Control<br></li><li>Electrical machines and transformers<br></li><li>Power Systems and Its Applications<br></li><li>All methods and algorithms of mathematical
optimization<br></li><li>Artificial Intelligence<br></li><li>Soft-computing<br></li><li>Multi-objective optimization<br></li><li>Fuzzy set and System<br></li><li>Neural network<br></li></ul></p>



















', 1)
INSERT [dbo].[JournalPage] ([Id], [JournalId], [Caption], [HTMLContent], [Priority]) VALUES (2035, 7016, N'Editorial Board', N'<h2 style="text-align:justify;direction:ltr;unicode-bidi:embed"><span style="font-family: garamond, serif;"><span style="font-size: medium;">Prof. Ebrahim Babaei<br></span><span style="font-size: medium;">Prof. Mehrdad Tarafdarhagh<br></span><span style="font-size: medium;">Prof. Kazemikargar<br></span><span style="font-size: medium;">Prof. Hamid Javadi<br></span><span style="font-size: medium;">Prof. Hossein Shayeghi<br></span><span style="font-size: medium;">Dr. Adel Akbarimajd<br></span><span style="font-size: medium;">Dr. Aref Jalili<br></span><span style="font-size: medium;">Dr. Hossein Torkaman<br></span><span style="font-size: medium;">Dr. Davar Mirabbasi<br></span><span style="font-size: medium;">Dr. Mansour Hosseinifirouz<br></span><span style="font-size: medium;">Dr. Gholamreza Aghajani<br></span><span style="font-size: medium;">Dr. Noradin Ghadimi<br></span><span style="font-size: medium;">Dr. Oveis Abedinia<br></span><span style="font-size: medium;"><o:p>&nbsp;<br></o:p></span><o:p style="font-size: medium;">&nbsp;<br></o:p><o:p style="font-size: medium;">&nbsp;</o:p></span></h2><p class="MsoNormal" style="text-align:justify;direction:ltr;unicode-bidi:embed">





























</p>', 2)
INSERT [dbo].[JournalPage] ([Id], [JournalId], [Caption], [HTMLContent], [Priority]) VALUES (2036, 7016, N'Guides for Author', N'<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><span style="color: black; font-weight: bold; font-style: italic;">Article
types</span><span style="font-weight: bold; font-size: 10.5pt; font-family: Arial, sans-serif; color: black;"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><span style="color:black">Suitable
research for&nbsp;</span><b><span style="color: rgb(0, 32, 96); background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">International
Journal of Optimization in Electrical Engineering</span></b><b><span style="font-size: 10.5pt; font-family: Arial, sans-serif; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">&nbsp;</span></b><span style="color:black">may be of
qualitative or quantitative orientation or&nbsp;mixed-methods. Submissions
should not only be methodologically&nbsp;sound,&nbsp;but also have significant
innovative implications for researchers and practitioners.&nbsp;All articles
are restricted to a maximum of 7500 words, including title, abstract, notes,
references, tables, appendix, etc.</span><span style="font-size:10.5pt;
font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b><span style="color:black">&nbsp;</span></b><span style="font-size:10.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><span style="color: black; font-weight: bold; font-style: italic;">Peer
review policy</span><span style="font-weight: bold; font-size: 10.5pt; font-family: Arial, sans-serif; color: black;"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b><span style="color:#002060">International
Journal of Optimization in Electrical Engineering </span></b><span style="color:black">has two-stage reviewing procedure. All articles are first
reviewed by the editor-in-chief and editors to determine their suitability for
external review. Articles accepted for external review are submitted to a
strictly double-blind peer review. Each manuscript is reviewed by at least two
external referees. All manuscripts are reviewed as rapidly as
possible.&nbsp;Final&nbsp;editorial decision on acceptance, acceptance with
minor revisions, or rejection is generally reached within 4-6 weeks after
submission.</span><span style="font-size:10.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;
color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b><span style="color:black">&nbsp;</span></b><span style="font-size:10.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><span style="color: black; font-weight: bold; font-style: italic;">Plagiarism</span><span style="font-size:10.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b><span style="color:#002060">International
Journal of Optimization in Electrical Engineering </span></b><span style="color:black">takes issues of copyright infringement, plagiarism or other
breaches of best practice in publication very seriously. We seek to protect the
rights of our authors and we always investigate claims of plagiarism or misuse
of published articles. Equally, we do aim to protect the reputation of the
journal against malpractice. Submitted articles are checked with software. The
major plagiarised submissions are desk rejected and the author is not allowed
to submit any manuscript for three years. We also reserve the right to take up
the matter with the dean or head ofdepartment&nbsp;of the author''s institution
and/or relevant academic bodies or societies.</span><span style="font-size:
10.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b><span style="color:black"><br></span></b></p><p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b><span style="color: black; font-style: italic;">Authorship</span></b><span style="font-size:10.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><span style="color:black">Papers
should only be submitted for consideration once the authorization of all
contributing authors has been gathered. No Change is made in contributing
authors’ order or name after submission.</span><span style="font-size:10.5pt;
font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b><span style="color:black"><br></span></b></p><p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b><span style="color: black; font-style: italic;">Reference
Style</span></b><span style="font-size:10.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;
color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b><span style="color:#002060">International
Journal of Optimization in Electrical Engineering</span></b><span style="color:black">&nbsp;adheres to the APA reference style.&nbsp;</span><a href="http://apastyle.org/"><span style="color: windowtext;">Click here</span></a><span style="color:black">&nbsp;to
review the guidelines on APA to ensure your manuscript conforms to this reference
style.</span><span style="font-size:10.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;
color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b><span style="color:black"><br></span></b></p><p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b><span style="color: black; font-style: italic;">Acknowledgments</span></b><span style="font-size:10.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><span style="color:black">Any
acknowledgments should appear first at the end of your article prior to your
Declaration of Conflicting Interests (if applicable), any notes and your
References.</span><span style="font-size:10.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;
color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b><span style="color:black">&nbsp;</span></b></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><span style="font-style: italic;"><b><span style="color:black">&nbsp;</span></b><b style="background-color: initial;"><span style="color:black">Journal
contributor’s publishing agreement&nbsp; &nbsp;</span></b></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><span style="color:black">Before
publication&nbsp;</span><b><span style="color:#002060">International Journal of
Optimization in Electrical Engineering</span></b><span style="color:black">&nbsp;requires
the author as the rights holder to sign a Journal Contributor’s Publishing
Agreement. The Journal Contributor’s Publishing Agreement is an exclusive
license agreement which means that the author retains copyright in the work but
grants the journal the sole and exclusive right and license to publish for the
full legal term of copyright.</span><span style="font-size:10.5pt;font-family:
&quot;Arial&quot;,&quot;sans-serif&quot;;color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b><span style="color:black"><br></span></b></p><p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><span style="font-style: italic;"><b><span style="color:black">After
acceptance:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></b><span style="font-size:10.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black"><o:p></o:p></span></span></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><b style="background-color: initial;"><span style="color:black">Proofs</span></b><br></p>

<p class="MsoNormal" dir="LTR" style="margin-bottom: 7.5pt; text-align: justify; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; direction: ltr; unicode-bidi: embed;"><span style="color:black">We
will email a PDF of the proofs to the corresponding author.</span><span style="font-size:10.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black"><o:p></o:p></span></p>

<p class="MsoNormal" dir="LTR" style="text-align:justify;direction:ltr;unicode-bidi:
embed"><span style="font-size:14.0pt"><o:p>&nbsp;</o:p></span></p>

<p class="MsoNormal" dir="LTR" style="text-align:justify;direction:ltr;unicode-bidi:
embed"><b>&nbsp;</b></p>', 3)
SET IDENTITY_INSERT [dbo].[JournalPage] OFF
SET IDENTITY_INSERT [dbo].[JournalUser] ON 

INSERT [dbo].[JournalUser] ([Id], [JournalId], [UserId], [Date]) VALUES (17177, 7016, N'4391d79f-f5b6-4309-bd93-b251a83774a2', NULL)
INSERT [dbo].[JournalUser] ([Id], [JournalId], [UserId], [Date]) VALUES (18177, 7016, N'ce24fef9-3e1f-4dfe-be40-1dc7e81d9e05', NULL)
INSERT [dbo].[JournalUser] ([Id], [JournalId], [UserId], [Date]) VALUES (18178, 7016, N'0d8da45b-11b3-4047-a4ff-800c878c2fee', NULL)
INSERT [dbo].[JournalUser] ([Id], [JournalId], [UserId], [Date]) VALUES (18179, 7016, N'5ba84549-a275-4216-a7bf-dab050a342c4', NULL)
INSERT [dbo].[JournalUser] ([Id], [JournalId], [UserId], [Date]) VALUES (19177, 7016, N'91b4e59a-1d4a-4556-bf11-fb0b685d7ab6', NULL)
INSERT [dbo].[JournalUser] ([Id], [JournalId], [UserId], [Date]) VALUES (20188, 7016, N'6d3be45e-015b-4648-9779-7af68b5ad1b1', CAST(N'2018-10-23T17:27:54.723' AS DateTime))
INSERT [dbo].[JournalUser] ([Id], [JournalId], [UserId], [Date]) VALUES (20189, 7015, N'6d3be45e-015b-4648-9779-7af68b5ad1b1', CAST(N'2018-10-23T17:27:54.723' AS DateTime))
INSERT [dbo].[JournalUser] ([Id], [JournalId], [UserId], [Date]) VALUES (20190, 6014, N'2f3c31d0-d3fb-43a4-aeb8-e413a6556d9e', CAST(N'2018-10-23T17:28:31.473' AS DateTime))
INSERT [dbo].[JournalUser] ([Id], [JournalId], [UserId], [Date]) VALUES (20191, 7015, N'2f3c31d0-d3fb-43a4-aeb8-e413a6556d9e', CAST(N'2018-10-23T17:28:31.473' AS DateTime))
SET IDENTITY_INSERT [dbo].[JournalUser] OFF
SET IDENTITY_INSERT [dbo].[JournalUserActiveField] ON 

INSERT [dbo].[JournalUserActiveField] ([Id], [JournalUserId], [SubjectFieldId]) VALUES (1017, 20188, 27)
INSERT [dbo].[JournalUserActiveField] ([Id], [JournalUserId], [SubjectFieldId]) VALUES (1018, 20189, 25)
INSERT [dbo].[JournalUserActiveField] ([Id], [JournalUserId], [SubjectFieldId]) VALUES (1019, 20190, 24)
INSERT [dbo].[JournalUserActiveField] ([Id], [JournalUserId], [SubjectFieldId]) VALUES (1020, 20191, 25)
SET IDENTITY_INSERT [dbo].[JournalUserActiveField] OFF
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
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (89, N'Iran', N'IR', N'IRN', N'فارسی', N'fa', N'fas', N'fa-IR', 0, 0)
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
INSERT [dbo].[Language] ([Id], [Country], [TwoLetterCountryCode], [ThreeLetterCountryCode], [Language], [TwoLetterLangCode], [ThreeLetterLangCode], [CultureInfoCode], [IsDefault], [IsActive]) VALUES (198, N'Turkey', N'TR', N'TUR', N'Turkish', N'tr', N'tur', N'tr-TR', 0, 0)
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
SET IDENTITY_INSERT [dbo].[Message] ON 

INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4040, 8036, N'ce24fef9-3e1f-4dfe-be40-1dc7e81d9e05', N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'correciotn', 0, NULL, 0, 9, CAST(N'2018-10-15T09:58:07.077' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4041, 8036, N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'editor correction', 0, NULL, 1, 5, CAST(N'2018-10-15T10:20:45.173' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4042, 8036, N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'<div class="col-xs-12">
    <div class="row text-left">
        <b>International Journal of Optimization in Electrical Engineering</b>
        <hr>
    </div>
    <div class="row">
        <div class="col-xs-6 text-left">
            <b>Article Title: </b>
            Electronic Next Generation
        </div>

        <div class="col-xs-3">
            <b>Article Type: </b>
            Original research
        </div>

        <div class="col-xs-3">
            <b>Field: </b>
            Electronic
        </div>
        <hr>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <b>Reviewers:</b>
        </div>
        <div class=" col-xs-offset-1 col-xs-11">
                <details open="">
                    <summary>
                        <b> R_1 R1 (</b> 10/15/2018 9:58:07 AM<b> )</b>
                    </summary>
                    <div class="col-xs-12">
                        correciotn
                    </div>

                </details>
                <hr>

        </div>
    </div>
</div>


<script type="text/javascript">

    $(document).ready(function () {

        callInitialFunctions();
    })

    function callInitialFunctions() { }


</script>

', 0, NULL, 1, 20, CAST(N'2018-10-15T18:15:19.557' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4043, 8036, N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'<div class="col-xs-12">
    <div class="row text-left">
        <b>International Journal of Optimization in Electrical Engineering</b>
        <hr>
    </div>
    <div class="row">
        <div class="col-xs-6 text-left">
            <b>Article Title: </b>
            Electronic Next Generation
        </div>

        <div class="col-xs-3">
            <b>Article Type: </b>
            Original research
        </div>

        <div class="col-xs-3">
            <b>Field: </b>
            Electronic
        </div>
        <hr>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <b>Reviewers:</b>
        </div>
        <div class=" col-xs-offset-1 col-xs-11">
                <details open="">
                    <summary>
                        <b> R_1 R1 (</b> 10/15/2018 9:58:07 AM<b> )</b>
                    </summary>
                    <div class="col-xs-12">
                        correciotn
                    </div>

                </details>
                <hr>

        </div>
    </div>
</div>


', 0, NULL, 1, 20, CAST(N'2018-10-15T18:23:05.483' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4044, 8036, N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'<div class="col-xs-12">
    <div class="row text-left">
        <b style="color: rgb(39, 78, 19);">QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ</b><hr>
    </div>
    <div class="row">
        <div class="col-xs-6 text-left">
            <b>Article Title: </b>
            Electronic Next Generation
        </div>

        <div class="col-xs-3">
            <b>Article Type: </b>
            Original research
        </div>

        <div class="col-xs-3">
            <b>Field: </b>
            Electronic
        </div>
        <hr>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <b>Reviewers:</b>
        </div>
        <div class=" col-xs-offset-1 col-xs-11">
                <details open="">
                    <summary>
                        <b> R_1 R1 (</b> 10/15/2018 9:58:07 AM<b> )</b>
                    </summary>
                    <div class="col-xs-12">
                        correciotn
                    </div>

                </details>
                <hr>

        </div>
    </div>
</div>

', 0, NULL, 1, 5, CAST(N'2018-10-15T18:30:32.007' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4045, 8036, N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'ce24fef9-3e1f-4dfe-be40-1dc7e81d9e05', N'<span style="font-weight: 700;">Accept Message</span>', 0, NULL, 1, 4, CAST(N'2018-10-15T18:32:11.973' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4046, 8036, N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'<div class="col-xs-12">
    <div class="row text-left">
        <span style="background-color: rgb(255, 255, 0);">International Journal of Optimization in Electrical Engineering</span>
        <hr>
    </div>
    <div class="row">
        <div class="col-xs-6 text-left">
            <b>Article Title: </b>
            Electronic Next Generation
        </div>

        <div class="col-xs-3">
            <b>Article Type: </b>
            Original research
        </div>

        <div class="col-xs-3">
            <b>Field: </b>
            Electronic
        </div>
        <hr>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <b>Reviewers:</b>
        </div>
        <div class=" col-xs-offset-1 col-xs-11">
                <details>
                    <summary>
                        <b> R_1 R1 (</b> 10/15/2018 9:58:07 AM<b> )</b>
                    </summary>
                    <div class="col-xs-12">
                        correciotn
                    </div>

                </details>
                <hr>

        </div>
    </div>
</div>

', 0, NULL, 1, 3, CAST(N'2018-10-15T18:42:32.583' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4047, 8036, N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'<div class="col-xs-12">
    <div class="row text-left">
        <span style="background-color: rgb(255, 255, 0);">International Journal of Optimization in Electrical Engineering</span>
        <hr>
    </div>
    <div class="row">
        <div class="col-xs-6 text-left">
            <b>Article Title: </b>
            Electronic Next Generation
        </div>

        <div class="col-xs-3">
            <b>Article Type: </b>
            Original research
        </div>

        <div class="col-xs-3">
            <b>Field: </b>
            Electronic
        </div>
        <hr>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <b>Reviewers:</b>
        </div>
        <div class=" col-xs-offset-1 col-xs-11">
                <details>
                    <summary>
                        <b> R_1 R1 (</b> 10/15/2018 9:58:07 AM<b> )</b>
                    </summary>
                    <div class="col-xs-12">
                        correciotn
                    </div>

                </details>
                <hr>

        </div>
    </div>
</div>

', 0, NULL, 1, 3, CAST(N'2018-10-15T18:43:27.803' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4048, 8036, N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'<div class="row text-left"><b>International Journal of Optimization in Electrical Engineering</b><hr></div><div class="row"><div class="col-xs-6 text-left" style="width: 576.469px;"><b>Article Title:&nbsp;</b>Electronic Next Generation</div><div class="col-xs-3" style="width: 288.234px;"><b>Article Type:&nbsp;</b>Original research</div><div class="col-xs-3" style="width: 288.234px;"><b>Field:&nbsp;</b>Electronic</div><hr></div><div class="row"><div class="col-xs-12" style="width: 1152.94px;"><b>Reviewers:</b></div><div class=" col-xs-offset-1 col-xs-11" style="width: 1056.86px; margin-left: 96.0781px;"><details open=""><summary>&nbsp;<b>R_1 R1 (</b>&nbsp;10/15/2018 9:58:07 AM<b>&nbsp;)</b></summary><div class="col-xs-12" style="width: 1026.86px;">correciotn</div></details><hr></div></div>', 0, NULL, 1, 3, CAST(N'2018-10-15T18:48:41.373' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4049, 8036, N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'<div class="row text-left"><b>International Journal of Optimization in Electrical Engineering</b><hr></div><div class="row"><div class="col-xs-6 text-left" style="width: 576.469px;"><b>Article Title:&nbsp;</b>Electronic Next Generation</div><div class="col-xs-3" style="width: 288.234px;"><b>Article Type:&nbsp;</b>Original research</div><div class="col-xs-3" style="width: 288.234px;"><b>Field:&nbsp;</b>Electronic</div><hr></div><div class="row"><div class="col-xs-12" style="width: 1152.94px;"><b>Reviewers:</b></div><div class=" col-xs-offset-1 col-xs-11" style="width: 1056.86px; margin-left: 96.0781px;"><details open=""><summary>&nbsp;<b>R_1 R1 (</b>&nbsp;10/15/2018 9:58:07 AM<b>&nbsp;)</b></summary><div class="col-xs-12" style="width: 1026.86px;">correciotn</div></details><hr></div></div>', 0, NULL, 1, 4, CAST(N'2018-10-15T18:48:55.683' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4050, 8036, N'ce24fef9-3e1f-4dfe-be40-1dc7e81d9e05', N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'<div class="row text-left"><b>International Journal of Optimization in Electrical Engineering</b><hr></div><div class="row"><div class="col-xs-6 text-left" style="width: 576.469px;"><b>Article Title:&nbsp;</b>Electronic Next Generation</div><div class="col-xs-3" style="width: 288.234px;"><b>Article Type:&nbsp;</b>Original research</div><div class="col-xs-3" style="width: 288.234px;"><b>Field:&nbsp;</b>Electronic</div><hr></div><div class="row"><div class="col-xs-12" style="width: 1152.94px;"><b>Reviewers:</b></div><div class=" col-xs-offset-1 col-xs-11" style="width: 1056.86px; margin-left: 96.0781px;"><details open=""><summary>&nbsp;<b>R_1 R1 (</b>&nbsp;10/15/2018 9:58:07 AM<b>&nbsp;)</b></summary><div class="col-xs-12" style="width: 1026.86px;">correciotn</div></details><hr></div></div>', 0, NULL, 0, 9, CAST(N'2018-10-15T19:05:59.753' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4051, 8036, N'ce24fef9-3e1f-4dfe-be40-1dc7e81d9e05', N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'<div class="row text-left"><span style="font-family: Arial, Helvetica, sans-serif; font-weight: 700;">&nbsp;Accept Message:</span><hr></div><div class="row"><div class="col-xs-6 text-left" style="width: 576.469px;"><b>Article Title:&nbsp;</b>Electronic Next Generation</div><div class="col-xs-3" style="width: 288.234px;"><b>Article Type:&nbsp;</b>Original research</div><div class="col-xs-3" style="width: 288.234px;"><b>Field:&nbsp;</b>Electronic</div><hr></div><div class="row"><div class="col-xs-12" style="width: 1152.94px;"><b>Reviewers:</b></div><div class=" col-xs-offset-1 col-xs-11" style="width: 1056.86px; margin-left: 96.0781px;"><details open=""><summary>&nbsp;<b>R_1 R1 (</b>&nbsp;10/15/2018 9:58:07 AM<b>&nbsp;)</b></summary><div class="col-xs-12" style="width: 1026.86px;">correciotn</div></details><hr></div></div>', 0, NULL, 0, 7, CAST(N'2018-10-15T19:06:56.003' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4052, 8036, N'ce24fef9-3e1f-4dfe-be40-1dc7e81d9e05', N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'<div class="row"><div class="col-xs-6 text-left" style="width: 576.469px;"><b>Article Title:&nbsp;</b>Electronic Next Generation</div><div class="col-xs-3" style="width: 288.234px;"><b>Article Type:&nbsp;</b>Original research</div><div class="col-xs-3" style="width: 288.234px;"><b>Field:&nbsp;</b>Electronic</div><hr></div><div class="row"><div class="col-xs-12" style="width: 1152.94px;"><b>Reviewers:</b></div><div class=" col-xs-offset-1 col-xs-11" style="width: 1056.86px; margin-left: 96.0781px;"><details open=""><summary>&nbsp;<b>R_1 R1 (</b>&nbsp;10/15/2018 9:58:07 AM<b>&nbsp;)</b></summary><div class="col-xs-12" style="width: 1026.86px;"><span style="font-weight: bold; background-color: rgb(255, 0, 0);">ssssssssssssssssssssssssssssssssssssssssssssscorreciotn</span></div><div><br></div></details></div></div>', 0, NULL, 0, 8, CAST(N'2018-10-15T19:07:30.393' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4053, 8036, N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'28402571-7efe-4866-b2fb-bbf2c77b03af', N'<div class="row"><div class="col-xs-6 text-left" style="width: 576.469px;"><b>Article Title:&nbsp;</b>Electronic Next Generation</div><div class="col-xs-3" style="width: 288.234px;"><b>Article Type:&nbsp;</b>Original research</div><div class="col-xs-3" style="width: 288.234px;"><b>Field:&nbsp;</b>Electronic</div><hr></div><div class="row"><div class="col-xs-12" style="width: 1152.94px;"><b>Reviewers:</b></div><div class=" col-xs-offset-1 col-xs-11" style="width: 1056.86px; margin-left: 96.0781px;"><details open=""><summary>&nbsp;<b>R_1 R1 (</b>&nbsp;10/15/2018 9:58:07 AM<b>&nbsp;)</b></summary><div class="col-xs-12" style="width: 1026.86px;">correciotn</div><div><br></div></details></div></div>', 0, NULL, 0, 19, CAST(N'2018-10-15T19:07:59.530' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4054, 8036, N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'28402571-7efe-4866-b2fb-bbf2c77b03af', N'<div class="row"><div class="col-xs-6 text-left" style="width: 576.469px;"><span style="color: rgb(106, 168, 79);"><b>Article Title:&nbsp;</b>Electronic Next Generation</span></div><div class="col-xs-3" style="width: 288.234px;"><span style="color: rgb(106, 168, 79);"><b>Article Type:&nbsp;</b>Original research</span></div><div class="col-xs-3" style="width: 288.234px;"><span style="color: rgb(106, 168, 79);"><b>Field:&nbsp;</b>Electronic</span></div><hr></div><div class="row"><div class="col-xs-12" style="width: 1152.94px;"><b style="color: rgb(106, 168, 79);">Reviewers:</b></div><div class=" col-xs-offset-1 col-xs-11" style="width: 1056.86px; margin-left: 96.0781px;"><details open=""><summary><span style="color: rgb(106, 168, 79);">&nbsp;<b>R_1 R1 (</b>&nbsp;10/15/2018 9:58:07 AM<b>&nbsp;)</b></span></summary><div class="col-xs-12" style="width: 1026.86px;"><span style="color: rgb(106, 168, 79);">correciotn</span></div><div><br></div></details></div></div>', 0, NULL, 0, 18, CAST(N'2018-10-15T19:08:22.447' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4055, 8036, N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'28402571-7efe-4866-b2fb-bbf2c77b03af', N'<div class="row"><div class="col-xs-6 text-left" style="width: 576.469px;"><span style="background-color: rgb(255, 0, 0);"><b>Article Title:&nbsp;</b>Electronic Next Generation</span></div><div class="col-xs-3" style="width: 288.234px;"><span style="background-color: rgb(255, 0, 0);"><b>Article Type:&nbsp;</b>Original research</span></div><div class="col-xs-3" style="width: 288.234px;"><span style="background-color: rgb(255, 0, 0);"><b>Field:&nbsp;</b>Electronic</span></div><hr></div><div class="row"><div class="col-xs-12" style="width: 1152.94px;"><b style="background-color: rgb(255, 0, 0);">Reviewers:</b></div><div class=" col-xs-offset-1 col-xs-11" style="width: 1056.86px; margin-left: 96.0781px;"><details open=""><summary><span style="background-color: rgb(255, 0, 0);">&nbsp;<b>R_1 R1 (</b>&nbsp;10/15/2018 9:58:07 AM<b>&nbsp;)</b></span></summary><div class="col-xs-12" style="width: 1026.86px;"><span style="background-color: rgb(255, 0, 0);">correciotn</span></div><div><br></div></details></div></div>', 0, NULL, 0, 17, CAST(N'2018-10-15T19:08:41.690' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4056, 8036, N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'28402571-7efe-4866-b2fb-bbf2c77b03af', N'<div>&nbsp; if ($("#editor_DropDownList").val() != undefined) {</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; getEditorArticles($("#editor_DropDownList").val());</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }</div><div><br></div>', 0, NULL, 0, 18, CAST(N'2018-10-15T19:10:37.840' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (4057, 8036, N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'28402571-7efe-4866-b2fb-bbf2c77b03af', N'e56645', 0, NULL, 0, 17, CAST(N'2018-10-16T15:40:53.410' AS DateTime), NULL)
INSERT [dbo].[Message] ([Id], [ArticleId], [Sender], [Receiver], [MessageText], [OrderNumber], [Title], [Visited], [Type], [MessageDate], [PublicUserEmail]) VALUES (5036, 9036, N'2f3c31d0-d3fb-43a4-aeb8-e413a6556d9e', N'28402571-7efe-4866-b2fb-bbf2c77b03af', N'awewe', 0, NULL, 0, 17, CAST(N'2018-10-23T17:48:27.470' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Message] OFF
SET IDENTITY_INSERT [dbo].[PageContent] ON 

INSERT [dbo].[PageContent] ([Id], [Content], [Type], [journalId]) VALUES (1, N'<div style="color: rgb(36, 36, 36);"><div class="row row-tight" style="font-size: 15.04px; font-family: NexusSans, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; margin: 0px auto; padding: 0.9375rem 0px 0px; vertical-align: baseline; width: 940px; max-width: 62.5rem; color: rgb(80, 80, 80);"><div role="navigation" aria-label="Category" style="margin: 0px; padding: 0px; font-family: NexusSans, Arial, Helvetica, &quot;Lucida Sans Unicode&quot;, &quot;Microsoft Sans Serif&quot;, &quot;Segoe UI Symbol&quot;, STIXGeneral, &quot;Cambria Math&quot;, &quot;Arial Unicode MS&quot;, sans-serif; font-size: 20px;"><div class="branded row" style="margin: 0px; padding: 0px;"></div></div></div><div class="row row-tight" style="margin: 0px auto; padding: 0.9375rem 0px 0px; vertical-align: baseline; width: 940px; max-width: 62.5rem; color: rgb(80, 80, 80);"><span style="font-weight: bold; font-family: garamond, serif; font-size: x-large;">A.I.A University Publishing Group.</span></div></div>', NULL, NULL)
INSERT [dbo].[PageContent] ([Id], [Content], [Type], [journalId]) VALUES (2, N'', N'FooterContent', NULL)
INSERT [dbo].[PageContent] ([Id], [Content], [Type], [journalId]) VALUES (3, N'Footer News', N'FooterNews', NULL)
SET IDENTITY_INSERT [dbo].[PageContent] OFF
SET IDENTITY_INSERT [dbo].[Person] ON 

INSERT [dbo].[Person] ([Id], [UserId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ORCID], [ProfilePictureUrl]) VALUES (2, N'c87419bb-de56-48ae-abba-c56a2692d4cb', N'Farzad', N'Sattari', N'-', N'-', N'-', 0, NULL, NULL, NULL, N'111111', N'2222222', N'3333333', N'4444', N'55555555555', N'Short Bio', N'/Resources/Uploaded/Persons/Profile/c87419bbde5648aeabbac56a2692d4cb/2018080616563120180805135706BodyguardUser.png?CT=image_png.png')
INSERT [dbo].[Person] ([Id], [UserId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ORCID], [ProfilePictureUrl]) VALUES (7022, N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'eic1', N'-', NULL, NULL, NULL, 0, NULL, N'-', N'-', N'-', N'-', NULL, NULL, NULL, N'-', NULL)
INSERT [dbo].[Person] ([Id], [UserId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ORCID], [ProfilePictureUrl]) VALUES (7023, N'2f3c31d0-d3fb-43a4-aeb8-e413a6556d9e', N'eic2', N'-', NULL, NULL, NULL, 0, NULL, N'-', N'-', N'-', N'-', NULL, NULL, NULL, N'-', NULL)
INSERT [dbo].[Person] ([Id], [UserId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ORCID], [ProfilePictureUrl]) VALUES (8021, N'28402571-7efe-4866-b2fb-bbf2c77b03af', N'Author1', N'pournaeim', NULL, NULL, NULL, 0, NULL, N'0', N'0', N'0', N'0', NULL, NULL, NULL, N'0', NULL)
INSERT [dbo].[Person] ([Id], [UserId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ORCID], [ProfilePictureUrl]) VALUES (8022, N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'E1', N'1', NULL, NULL, NULL, 0, NULL, N'1', N'1', N'1', N'1', NULL, NULL, NULL, N'1', NULL)
INSERT [dbo].[Person] ([Id], [UserId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ORCID], [ProfilePictureUrl]) VALUES (9021, N'ce24fef9-3e1f-4dfe-be40-1dc7e81d9e05', N'R1', N'R_1', NULL, NULL, NULL, 0, NULL, N'r1', N'r1', N'r1', N'r1', NULL, NULL, NULL, N'11', NULL)
INSERT [dbo].[Person] ([Id], [UserId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ORCID], [ProfilePictureUrl]) VALUES (9022, N'0d8da45b-11b3-4047-a4ff-800c878c2fee', N'R2', N'2', NULL, NULL, NULL, 0, NULL, N'2', N'2', N'2', N'2', NULL, NULL, NULL, N'2', NULL)
INSERT [dbo].[Person] ([Id], [UserId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ORCID], [ProfilePictureUrl]) VALUES (9023, N'5ba84549-a275-4216-a7bf-dab050a342c4', N'R3', N'3', NULL, NULL, NULL, 0, NULL, N'3', N'333', N'3', N'3', NULL, NULL, NULL, N'3', NULL)
INSERT [dbo].[Person] ([Id], [UserId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ORCID], [ProfilePictureUrl]) VALUES (9024, N'238abeb3-01a1-4764-812e-54d3c292181d', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Person] ([Id], [UserId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ORCID], [ProfilePictureUrl]) VALUES (9025, N'e2e85ad2-7468-493a-a8ef-f4dd401c88db', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Person] ([Id], [UserId], [FirstName], [LastName], [MobilePhone], [Tel], [Identifier], [Sex], [BirthDate], [AcademicInfoNames], [AcademicInfoValues], [StreetLine1], [StreetLine2], [City], [State], [ZipCode], [ORCID], [ProfilePictureUrl]) VALUES (9026, N'91b4e59a-1d4a-4556-bf11-fb0b685d7ab6', N'a', N'a', NULL, NULL, NULL, 0, NULL, N'22222,', N'222,', N'a', N'a', NULL, NULL, NULL, N'2222222222', NULL)
SET IDENTITY_INSERT [dbo].[Person] OFF
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
SET IDENTITY_INSERT [dbo].[RefrenceWord] ON 

INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (1, N'Home')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (2, N'Services')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (3, N'Partners')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (4, N'About Us')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (5, N'Contact')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (6, N'Login')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (7, N'Register')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (8, N'Search Here')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (9, N'Getting Started')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (10, N'Language')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (11, N'Country')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (12, N'City')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (13, N'Postcode')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (14, N'Expertise')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (15, N'Let''s Work Together!')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (16, N'Join Free Today')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (17, N'Rent Management - Find Certificate Management - Get Or Sell Tasks In Your Local Area')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (18, N'Profiles, Looking For Jobs Right Now')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (19, N'Offering Jobs Right Now')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (20, N'International Profiles And Jobs')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (21, N'See All Profiles Here')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (22, N'See All Jobs Here')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (23, N'Profiles And Jobs')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (24, N'Profiles')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (25, N'Jobs')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (26, N'Select Country')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (27, N'Free')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (28, N'click')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (29, N'Unlimited')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (30, N'week')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (31, N'month')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (32, N'Limited Profile Visit')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (33, N'Unlimited Profile Visit')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (34, N'Limited To Living Postcode')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (35, N'No Limitation To Postcode')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (36, N'Limited To Chosen Postcode')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (37, N'Limited To Chosen City')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (38, N'Limited To Chosen Country')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (39, N'Access To Entire Profiles')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (40, N'Limited Days')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (41, N'No Time Limitation')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (42, N'No Job/Labor List')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (43, N'Receive Job/Labor List')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (44, N'No Access To Visited Profiles')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (45, N'Access To Visited Profiles')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (46, N'Buy Now')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (47, N'Our Main Services')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (48, N'Rent Crew')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (49, N'Get, Buy & Sell Jobs')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (50, N'Networks & Events')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (51, N'Buy & Sell Used Equipments')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (52, N'Buy & Sell New Equipments')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (53, N'Use')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (54, N'As You Wish')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (55, N'Future Digital Access')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (56, N'Read More About Cookiejar')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (57, N'Testimonial')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (58, N'Sign Up Now And Be A Part Of A Future')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (59, N'Sign Me')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (60, N'Upcoming Events')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (61, N'Get In Touch')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (62, N'Address')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (63, N'E-Mail')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (64, N'Phone')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (65, N'Who Are We')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (66, N'And Where Are We Going')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (67, N'Welcome To The Club')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (68, N'Join Our Next Meeting')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (69, N'The Best Network Of The Year')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (70, N'See All Genre')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (71, N'Network')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (72, N'Contact Us')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (73, N'Meet Us Here')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (74, N'Network Meetings')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (75, N'Saturday ')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (76, N'Sunday ')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (77, N'Monday ')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (78, N'Tuesday')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (79, N'Wednesday')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (80, N'Thursday')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (81, N'Friday')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (82, N'Sign Up To Cookiejar Today')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (83, N'Name')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (84, N'Subject')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (85, N'Message')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (86, N'Send')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (87, N'See All Members')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (88, N'See All Events')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (89, N'See All Jobs')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (90, N'Web Shop')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (91, N'A Cooperation')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (92, N'That Supports You')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (93, N'Start Your Cooperation')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (94, N'Contact Your Local Branch')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (95, N'The Best Contracts')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (96, N'Starts Here')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (97, N'Geographical Location')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (98, N'See All Representatives')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (99, N'What Do You Gain From Buying Indicative Here?')
GO
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (100, N'Join To The Next Network Meeting')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (101, N'Password')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (102, N'Remember Me?')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (103, N'Forgot Password?')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (104, N'Social Network Account Log In')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (105, N'The Email Is Required.')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (106, N'The Password Is Required.')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (107, N'Enter Your Email')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (108, N'Email Link')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (109, N'Create A New Account')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (110, N'User Name')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (111, N'Role')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (112, N'Confirm Password')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (113, N'Select Your Role')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (114, N'Company')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (115, N'Customer')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (116, N'Skilled Worker')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (117, N'Admin Panel')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (118, N'All Rights Reserved')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (119, N'Login With Your Social Network Account')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (120, N'Social Login')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (121, N'Error')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (122, N'An Error Occurred While Processing Your Request')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (123, N'Locked Out')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (124, N'This Account Has Been Locked Out, Please Try Again Later')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (125, N'You Do Not Have A Local Username/Password For This Site. Add A Local Account So You Can Log In Without An External Login.')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (126, N'Create Local Login')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (127, N'Set Password')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (128, N'Change Password Form')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (129, N'Change Password')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (130, N'Format')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (131, N'Protection')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (132, N'Type')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (133, N'You''ve Successfully Authenticated With')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (134, N'Please Enter E-Mail For This Site Below And Click The Register Button To Finish Logging In.')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (135, N'Unsuccessful Login With Service')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (136, N'Please Check Your Email To Reset Your Password')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (137, N'Select Your Countries')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (138, N'Reset')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (139, N'Reset Your Password')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (140, N'Your Password Has Been Reset')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (141, N'Click Here To Log In')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (142, N'Register Date')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (143, N'Roles')
INSERT [dbo].[RefrenceWord] ([Id], [Word]) VALUES (144, N'Forgot Password Confirmation')
SET IDENTITY_INSERT [dbo].[RefrenceWord] OFF
SET IDENTITY_INSERT [dbo].[SiteInfo] ON 

INSERT [dbo].[SiteInfo] ([Id], [SiteName]) VALUES (1, N'COOKIEjAR')
SET IDENTITY_INSERT [dbo].[SiteInfo] OFF
SET IDENTITY_INSERT [dbo].[Subject] ON 

INSERT [dbo].[Subject] ([Id], [ParentId], [Name]) VALUES (0, NULL, N'Subjects')
INSERT [dbo].[Subject] ([Id], [ParentId], [Name]) VALUES (1, 0, N'Engineering')
INSERT [dbo].[Subject] ([Id], [ParentId], [Name]) VALUES (2, 0, N'Life Sciences 123 456 789 1234 5678 9012 3445 66')
INSERT [dbo].[Subject] ([Id], [ParentId], [Name]) VALUES (3, 1, N'Computer Science ')
INSERT [dbo].[Subject] ([Id], [ParentId], [Name]) VALUES (4, 1, N'Economy and Finance')
INSERT [dbo].[Subject] ([Id], [ParentId], [Name]) VALUES (17, 0, N'Social Sciences and Humanities')
INSERT [dbo].[Subject] ([Id], [ParentId], [Name]) VALUES (1022, 0, N'Health Sciences')
INSERT [dbo].[Subject] ([Id], [ParentId], [Name]) VALUES (1023, 1, N'Energy')
SET IDENTITY_INSERT [dbo].[Subject] OFF
SET IDENTITY_INSERT [dbo].[UserDefiner] ON 

INSERT [dbo].[UserDefiner] ([Id], [DefinerId], [UserId]) VALUES (5003, N'c87419bb-de56-48ae-abba-c56a2692d4cb', N'6d3be45e-015b-4648-9779-7af68b5ad1b1')
INSERT [dbo].[UserDefiner] ([Id], [DefinerId], [UserId]) VALUES (5004, N'c87419bb-de56-48ae-abba-c56a2692d4cb', N'2f3c31d0-d3fb-43a4-aeb8-e413a6556d9e')
INSERT [dbo].[UserDefiner] ([Id], [DefinerId], [UserId]) VALUES (6002, N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'4391d79f-f5b6-4309-bd93-b251a83774a2')
INSERT [dbo].[UserDefiner] ([Id], [DefinerId], [UserId]) VALUES (7002, N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'ce24fef9-3e1f-4dfe-be40-1dc7e81d9e05')
INSERT [dbo].[UserDefiner] ([Id], [DefinerId], [UserId]) VALUES (7003, N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'0d8da45b-11b3-4047-a4ff-800c878c2fee')
INSERT [dbo].[UserDefiner] ([Id], [DefinerId], [UserId]) VALUES (7004, N'4391d79f-f5b6-4309-bd93-b251a83774a2', N'5ba84549-a275-4216-a7bf-dab050a342c4')
INSERT [dbo].[UserDefiner] ([Id], [DefinerId], [UserId]) VALUES (8002, N'c87419bb-de56-48ae-abba-c56a2692d4cb', N'238abeb3-01a1-4764-812e-54d3c292181d')
INSERT [dbo].[UserDefiner] ([Id], [DefinerId], [UserId]) VALUES (8003, N'c87419bb-de56-48ae-abba-c56a2692d4cb', N'e2e85ad2-7468-493a-a8ef-f4dd401c88db')
INSERT [dbo].[UserDefiner] ([Id], [DefinerId], [UserId]) VALUES (8004, N'6d3be45e-015b-4648-9779-7af68b5ad1b1', N'91b4e59a-1d4a-4556-bf11-fb0b685d7ab6')
SET IDENTITY_INSERT [dbo].[UserDefiner] OFF
SET IDENTITY_INSERT [dbo].[Volume] ON 

INSERT [dbo].[Volume] ([Id], [ParentId], [Name], [No], [Desc1], [Desc2], [Type], [JournalId], [ArticleId], [Description]) VALUES (4024, NULL, N'Volumes', NULL, NULL, NULL, 0, 6014, NULL, NULL)
INSERT [dbo].[Volume] ([Id], [ParentId], [Name], [No], [Desc1], [Desc2], [Type], [JournalId], [ArticleId], [Description]) VALUES (4025, NULL, N'Volumes', NULL, NULL, NULL, 0, 7015, NULL, NULL)
INSERT [dbo].[Volume] ([Id], [ParentId], [Name], [No], [Desc1], [Desc2], [Type], [JournalId], [ArticleId], [Description]) VALUES (4026, NULL, N'International Journal of Optimization in Electrical Engineering Volumes', NULL, NULL, NULL, 0, 7016, NULL, N'
')
INSERT [dbo].[Volume] ([Id], [ParentId], [Name], [No], [Desc1], [Desc2], [Type], [JournalId], [ArticleId], [Description]) VALUES (5057, 5051, N'qqqqqqqqqqqqq', NULL, N'100', N'200', 3, 7015, 9036, N'aaaaaaaaaaaa')
INSERT [dbo].[Volume] ([Id], [ParentId], [Name], [No], [Desc1], [Desc2], [Type], [JournalId], [ArticleId], [Description]) VALUES (5058, 4026, N'Volume', N'1', N'2018', NULL, 1, 7016, NULL, NULL)
INSERT [dbo].[Volume] ([Id], [ParentId], [Name], [No], [Desc1], [Desc2], [Type], [JournalId], [ArticleId], [Description]) VALUES (5059, 5058, NULL, N'1', NULL, NULL, 2, 7016, NULL, NULL)
INSERT [dbo].[Volume] ([Id], [ParentId], [Name], [No], [Desc1], [Desc2], [Type], [JournalId], [ArticleId], [Description]) VALUES (5061, 4025, N'Volume', N'1', NULL, NULL, 1, 7015, NULL, NULL)
INSERT [dbo].[Volume] ([Id], [ParentId], [Name], [No], [Desc1], [Desc2], [Type], [JournalId], [ArticleId], [Description]) VALUES (5062, 5061, N'Issue', N'1', NULL, NULL, 2, 7015, NULL, NULL)
INSERT [dbo].[Volume] ([Id], [ParentId], [Name], [No], [Desc1], [Desc2], [Type], [JournalId], [ArticleId], [Description]) VALUES (5063, 5062, N'qqqqqqqqqqqqq', NULL, N'300', N'400', 3, 7015, 9036, NULL)
INSERT [dbo].[Volume] ([Id], [ParentId], [Name], [No], [Desc1], [Desc2], [Type], [JournalId], [ArticleId], [Description]) VALUES (5064, 5059, N'Electronic Next Generation', NULL, NULL, NULL, 3, 7016, 8036, NULL)
SET IDENTITY_INSERT [dbo].[Volume] OFF
ALTER TABLE [dbo].[Article] ADD  CONSTRAINT [DF_Articles_ArticleTypeId]  DEFAULT ((0)) FOR [ArticleTypeId]
GO
ALTER TABLE [dbo].[Article] ADD  CONSTRAINT [DF_Articles_State]  DEFAULT ((1)) FOR [ArticleState]
GO
ALTER TABLE [dbo].[Article] ADD  CONSTRAINT [DF_Article_ArticleState1]  DEFAULT ((1)) FOR [ArticleStateUpdateDate]
GO
ALTER TABLE [dbo].[Article] ADD  CONSTRAINT [DF_Articles_VisitCount]  DEFAULT ((0)) FOR [VisitCount]
GO
ALTER TABLE [dbo].[Article] ADD  CONSTRAINT [DF_Articles_DownloadCount]  DEFAULT ((0)) FOR [DownloadCount]
GO
ALTER TABLE [dbo].[Article] ADD  CONSTRAINT [DF_Articles_Restricted]  DEFAULT ((0)) FOR [Restricted]
GO
ALTER TABLE [dbo].[ArticleAccessRight] ADD  CONSTRAINT [DF_ArticleAccessRights_NoAccess]  DEFAULT ((0)) FOR [AccessRight]
GO
ALTER TABLE [dbo].[ArticleEditor] ADD  CONSTRAINT [DF_ArticlesEditors_ArticleReviewState]  DEFAULT ((0)) FOR [ArticleEditState]
GO
ALTER TABLE [dbo].[ArticleReviewer] ADD  CONSTRAINT [DF_ArticlesReviewers_ArticleReviewState]  DEFAULT ((0)) FOR [ArticleReviewState]
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
ALTER TABLE [dbo].[City] ADD  CONSTRAINT [DF_City_Active]  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [DF__Country__Iso3__4E9398CC]  DEFAULT (NULL) FOR [Iso3]
GO
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [DF__Country__NumCode__4F87BD05]  DEFAULT (NULL) FOR [NumCode]
GO
ALTER TABLE [dbo].[Image] ADD  CONSTRAINT [DF_Image_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[JournalPage] ADD  CONSTRAINT [DF_JournalPages_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Language] ADD  CONSTRAINT [DF_Language_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
GO
ALTER TABLE [dbo].[Language] ADD  CONSTRAINT [DF_Language_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Message] ADD  CONSTRAINT [DF_Messages_Road]  DEFAULT ((0)) FOR [Visited]
GO
ALTER TABLE [dbo].[Message] ADD  CONSTRAINT [DF_Messages_Type]  DEFAULT ((0)) FOR [Type]
GO
ALTER TABLE [dbo].[Person] ADD  CONSTRAINT [DF_A0D4FE3A8E1C4519B8E29BC7F53AC475_Sex]  DEFAULT ((0)) FOR [Sex]
GO
ALTER TABLE [dbo].[Reference] ADD  CONSTRAINT [DF_Reference_VisitCount]  DEFAULT ((1)) FOR [VisitCount]
GO
ALTER TABLE [dbo].[Article]  WITH CHECK ADD  CONSTRAINT [FK_Article_ArticleType] FOREIGN KEY([ArticleTypeId])
REFERENCES [dbo].[ArticleType] ([Id])
GO
ALTER TABLE [dbo].[Article] CHECK CONSTRAINT [FK_Article_ArticleType]
GO
ALTER TABLE [dbo].[Article]  WITH CHECK ADD  CONSTRAINT [FK_Article_SubjectField] FOREIGN KEY([FieldId])
REFERENCES [dbo].[SubjectField] ([Id])
GO
ALTER TABLE [dbo].[Article] CHECK CONSTRAINT [FK_Article_SubjectField]
GO
ALTER TABLE [dbo].[Article]  WITH CHECK ADD  CONSTRAINT [FK_Articles_Journals] FOREIGN KEY([JournalId])
REFERENCES [dbo].[Journal] ([Id])
GO
ALTER TABLE [dbo].[Article] CHECK CONSTRAINT [FK_Articles_Journals]
GO
ALTER TABLE [dbo].[ArticleAccessRight]  WITH CHECK ADD  CONSTRAINT [FK_ArticleAccessRights_Articles] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ArticleAccessRight] CHECK CONSTRAINT [FK_ArticleAccessRights_Articles]
GO
ALTER TABLE [dbo].[ArticleAuthor]  WITH CHECK ADD  CONSTRAINT [FK_ArticleAuthor_Article] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ArticleAuthor] CHECK CONSTRAINT [FK_ArticleAuthor_Article]
GO
ALTER TABLE [dbo].[ArticleEditor]  WITH CHECK ADD  CONSTRAINT [FK_ArticlesEditors_Articles] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ArticleEditor] CHECK CONSTRAINT [FK_ArticlesEditors_Articles]
GO
ALTER TABLE [dbo].[ArticleReviewer]  WITH CHECK ADD  CONSTRAINT [FK_ArticlesReviewers_Articles] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ArticleReviewer] CHECK CONSTRAINT [FK_ArticlesReviewers_Articles]
GO
ALTER TABLE [dbo].[ArticleReviewer]  WITH CHECK ADD  CONSTRAINT [FK_ArticlesReviewers_Persons] FOREIGN KEY([ReviewerId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ArticleReviewer] CHECK CONSTRAINT [FK_ArticlesReviewers_Persons]
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
ALTER TABLE [dbo].[Attachment]  WITH CHECK ADD  CONSTRAINT [FK_Attachment_Article] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Attachment] CHECK CONSTRAINT [FK_Attachment_Article]
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
ALTER TABLE [dbo].[Dictionary]  WITH CHECK ADD  CONSTRAINT [FK_Dictionary_RefrenceWord] FOREIGN KEY([RefrenceWordId])
REFERENCES [dbo].[RefrenceWord] ([Id])
GO
ALTER TABLE [dbo].[Dictionary] CHECK CONSTRAINT [FK_Dictionary_RefrenceWord]
GO
ALTER TABLE [dbo].[Image]  WITH CHECK ADD  CONSTRAINT [FK_Image_Journal] FOREIGN KEY([JournalId])
REFERENCES [dbo].[Journal] ([Id])
GO
ALTER TABLE [dbo].[Image] CHECK CONSTRAINT [FK_Image_Journal]
GO
ALTER TABLE [dbo].[Journal]  WITH CHECK ADD  CONSTRAINT [FK_Journal_Subject] FOREIGN KEY([SubjectId])
REFERENCES [dbo].[Subject] ([Id])
GO
ALTER TABLE [dbo].[Journal] CHECK CONSTRAINT [FK_Journal_Subject]
GO
ALTER TABLE [dbo].[SubjectField]  WITH CHECK ADD  CONSTRAINT [FK_SubjectField_Journal] FOREIGN KEY([JournalId])
REFERENCES [dbo].[Journal] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SubjectField] CHECK CONSTRAINT [FK_SubjectField_Journal]
GO
ALTER TABLE [dbo].[JournalPage]  WITH CHECK ADD  CONSTRAINT [FK_JournalPage_Journal] FOREIGN KEY([JournalId])
REFERENCES [dbo].[Journal] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[JournalPage] CHECK CONSTRAINT [FK_JournalPage_Journal]
GO
ALTER TABLE [dbo].[JournalUser]  WITH CHECK ADD  CONSTRAINT [FK_JournalUser_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[JournalUser] CHECK CONSTRAINT [FK_JournalUser_AspNetUsers]
GO
ALTER TABLE [dbo].[JournalUser]  WITH CHECK ADD  CONSTRAINT [FK_JournalUser_Journal] FOREIGN KEY([JournalId])
REFERENCES [dbo].[Journal] ([Id])
GO
ALTER TABLE [dbo].[JournalUser] CHECK CONSTRAINT [FK_JournalUser_Journal]
GO
ALTER TABLE [dbo].[JournalUserActiveField]  WITH CHECK ADD  CONSTRAINT [FK_JournalUserActiveField_SubjectField] FOREIGN KEY([SubjectFieldId])
REFERENCES [dbo].[SubjectField] ([Id])
GO
ALTER TABLE [dbo].[JournalUserActiveField] CHECK CONSTRAINT [FK_JournalUserActiveField_SubjectField]
GO
ALTER TABLE [dbo].[JournalUserActiveField]  WITH CHECK ADD  CONSTRAINT [FK_JournalUserActiveField_JournalUser] FOREIGN KEY([JournalUserId])
REFERENCES [dbo].[JournalUser] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[JournalUserActiveField] CHECK CONSTRAINT [FK_JournalUserActiveField_JournalUser]
GO
ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_Article] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_Article]
GO
ALTER TABLE [dbo].[PageContent]  WITH CHECK ADD  CONSTRAINT [FK_FirstPageContent_Journal] FOREIGN KEY([journalId])
REFERENCES [dbo].[Journal] ([Id])
GO
ALTER TABLE [dbo].[PageContent] CHECK CONSTRAINT [FK_FirstPageContent_Journal]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_AspNetUsers]
GO
ALTER TABLE [dbo].[Province]  WITH CHECK ADD  CONSTRAINT [FK_CountryProvince] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO
ALTER TABLE [dbo].[Province] CHECK CONSTRAINT [FK_CountryProvince]
GO
ALTER TABLE [dbo].[Reference]  WITH CHECK ADD  CONSTRAINT [FK_Reference_Article] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reference] CHECK CONSTRAINT [FK_Reference_Article]
GO
ALTER TABLE [dbo].[Volume]  WITH CHECK ADD  CONSTRAINT [FK_Volume_Article] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Volume] CHECK CONSTRAINT [FK_Volume_Article]
GO
ALTER TABLE [dbo].[Volume]  WITH CHECK ADD  CONSTRAINT [FK_Volume_Journal] FOREIGN KEY([JournalId])
REFERENCES [dbo].[Journal] ([Id])
GO
ALTER TABLE [dbo].[Volume] CHECK CONSTRAINT [FK_Volume_Journal]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Article', @level2type=N'COLUMN',@level2name=N'ArticleTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NewUploaded = 1,
            HasStructuralError = 2,
            AssignedToReviewer = 3,
            UnderReview = 4,
            HasError = 5,
            AcceptByReviewer = 6,
            UnderCurrection = 7,
            Currected = 8,
            RejectByReviewer = 9,
            RejectByEditor = 10,
            AcceptedByEditor = 11' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Article', @level2type=N'COLUMN',@level2name=N'ArticleState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NewUploaded = 1,
            HasStructuralError = 2,
            AssignedToReviewer = 3,
            UnderReview = 4,
            HasError = 5,
            AcceptByReviewer = 6,
            UnderCurrection = 7,
            Currected = 8,
            RejectByReviewer = 9,
            RejectByEditor = 10,
            AcceptedByEditor = 11' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Article', @level2type=N'COLUMN',@level2name=N'ArticleStateUpdateDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0=Download,
1=First Page,
2=No Access' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ArticleAccessRight', @level2type=N'COLUMN',@level2name=N'AccessRight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = First Page Image, 
1 = Left Sponsor Image,
2 = Right Sponsor Image' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Image', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = Journal,
1 = Conferences,
2 = Courerses,
3 = Books

' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Journal', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Article States' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Message', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = Root, 1 = Volume, 2 = Issue, 3 = Assign Article' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Volume', @level2type=N'COLUMN',@level2name=N'Type'
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
         Configuration = "(H (1[47] 4[21] 3) )"
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
         Configuration = "(H (1[50] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[37] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4[70] 3) )"
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
         Configuration = "(H (4[60] 2) )"
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
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ArticleType"
            Begin Extent = 
               Top = 285
               Left = 354
               Bottom = 381
               Right = 524
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Journal"
            Begin Extent = 
               Top = 471
               Left = 325
               Bottom = 653
               Right = 495
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleAuthor"
            Begin Extent = 
               Top = 29
               Left = 681
               Bottom = 172
               Right = 851
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Article"
            Begin Extent = 
               Top = 20
               Left = 37
               Bottom = 566
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "AspNetUsers"
            Begin Extent = 
               Top = 210
               Left = 771
               Bottom = 553
               Right = 995
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person"
            Begin Extent = 
               Top = 50
               Left = 1084
               Bottom = 320
               Right = 1254
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "SubjectField"
            Begin Extent = 
               Top = 232
               Left = 589
               Bottom = 345
               Right = 759
    ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'        End
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
      Begin ColumnWidths = 48
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
      Begin ColumnWidths = 11
         Column = 4560
         Alias = 3780
         Table = 1440
         Output = 795
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticle'
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
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[71] 3) )"
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
         Configuration = "(H (1[52] 4) )"
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
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "AspNetUsers"
            Begin Extent = 
               Top = 15
               Left = 1279
               Bottom = 353
               Right = 1503
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person"
            Begin Extent = 
               Top = 23
               Left = 1070
               Bottom = 295
               Right = 1240
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleType"
            Begin Extent = 
               Top = 159
               Left = 861
               Bottom = 255
               Right = 1031
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Journal"
            Begin Extent = 
               Top = 300
               Left = 859
               Bottom = 488
               Right = 1029
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleAuthor"
            Begin Extent = 
               Top = 10
               Left = 856
               Bottom = 143
               Right = 1031
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Article"
            Begin Extent = 
               Top = 11
               Left = 494
               Bottom = 539
               Right = 722
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleEditor"
            Begin Extent = 
               Top = 60
               Left = 277
               Bottom = 210
               Right = 447
            End
  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticleAssistant'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'          DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserDefiner"
            Begin Extent = 
               Top = 210
               Left = 60
               Bottom = 329
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SubjectField"
            Begin Extent = 
               Top = 487
               Left = 67
               Bottom = 600
               Right = 237
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
      Begin ColumnWidths = 53
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
         Width = 3315
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
         Column = 4560
         Alias = 1950
         Table = 1830
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticleAssistant'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticleAssistant'
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
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[78] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4[75] 3) )"
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
         Left = -442
      End
      Begin Tables = 
         Begin Table = "ArticleEditor"
            Begin Extent = 
               Top = 30
               Left = 882
               Bottom = 178
               Right = 1052
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleType"
            Begin Extent = 
               Top = 204
               Left = 781
               Bottom = 300
               Right = 951
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Journal"
            Begin Extent = 
               Top = 321
               Left = 769
               Bottom = 515
               Right = 939
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Article"
            Begin Extent = 
               Top = 19
               Left = 482
               Bottom = 548
               Right = 710
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleAuthor"
            Begin Extent = 
               Top = 47
               Left = 281
               Bottom = 180
               Right = 451
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person_2"
            Begin Extent = 
               Top = 9
               Left = 63
               Bottom = 282
               Right = 223
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person_1"
            Begin Extent = 
               Top = 359
               Left = 1146
               Bottom = 633
               Right = 1306
            End
       ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticleEditor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'     DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SubjectField"
            Begin Extent = 
               Top = 323
               Left = 0
               Bottom = 436
               Right = 170
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
      Begin ColumnWidths = 51
         Width = 284
         Width = 3135
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
         Column = 4200
         Alias = 1830
         Table = 1320
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticleEditor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticleEditor'
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
         Configuration = "(H (1[63] 2[24] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[68] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4[75] 3) )"
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
         Configuration = "(H (1[60] 4) )"
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
         Top = -384
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ArticleType"
            Begin Extent = 
               Top = 113
               Left = 874
               Bottom = 209
               Right = 1044
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleAuthor"
            Begin Extent = 
               Top = 0
               Left = 1068
               Bottom = 131
               Right = 1238
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Article"
            Begin Extent = 
               Top = 23
               Left = 606
               Bottom = 448
               Right = 834
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "Journal"
            Begin Extent = 
               Top = 376
               Left = 266
               Bottom = 584
               Right = 436
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Subject"
            Begin Extent = 
               Top = 623
               Left = 10
               Bottom = 736
               Right = 180
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person"
            Begin Extent = 
               Top = 196
               Left = 1300
               Bottom = 468
               Right = 1470
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JournalUser"
            Begin Extent = 
               Top = 490
               Left = 587
               Bottom = 620
               Right = 757
            End
        ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticleEditorInChief'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JournalUserActiveField"
            Begin Extent = 
               Top = 449
               Left = 913
               Bottom = 562
               Right = 1118
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SubjectField"
            Begin Extent = 
               Top = 563
               Left = 1201
               Bottom = 676
               Right = 1371
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleEditor"
            Begin Extent = 
               Top = 169
               Left = 157
               Bottom = 299
               Right = 327
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "ArticleReviewer"
            Begin Extent = 
               Top = 2
               Left = 152
               Bottom = 132
               Right = 338
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "AspNetUsers"
            Begin Extent = 
               Top = 559
               Left = 804
               Bottom = 732
               Right = 1028
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
      Begin ColumnWidths = 41
         Width = 284
         Width = 1500
         Width = 1500
         Width = 2640
         Width = 1500
         Width = 1500
         Width = 1650
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
         Column = 4200
         Alias = 1500
         Table = 1320
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticleEditorInChief'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticleEditorInChief'
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
         Configuration = "(H (1[50] 4[37] 3) )"
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
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4[82] 3) )"
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
         Configuration = "(H (1[27] 4) )"
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
      ActivePaneConfig = 3
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = -288
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ArticleAccessRight"
            Begin Extent = 
               Top = 294
               Left = 292
               Bottom = 424
               Right = 462
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person"
            Begin Extent = 
               Top = 335
               Left = 655
               Bottom = 740
               Right = 825
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ViewArticle"
            Begin Extent = 
               Top = 294
               Left = 38
               Bottom = 424
               Right = 254
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
      Begin ColumnWidths = 33
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
      Begin Colum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticlePersonAccessRight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'nWidths = 11
         Column = 3360
         Alias = 1890
         Table = 1695
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticlePersonAccessRight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticlePersonAccessRight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[51] 4[10] 2[20] 3) )"
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
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[85] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4[97] 3) )"
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
         Configuration = "(H (1[67] 4) )"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4[60] 2) )"
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
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ArticleReviewer"
            Begin Extent = 
               Top = 234
               Left = 804
               Bottom = 406
               Right = 990
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Article"
            Begin Extent = 
               Top = 216
               Left = 333
               Bottom = 744
               Right = 561
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Person"
            Begin Extent = 
               Top = 391
               Left = 1139
               Bottom = 821
               Right = 1296
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleType"
            Begin Extent = 
               Top = 372
               Left = 70
               Bottom = 472
               Right = 240
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Journal"
            Begin Extent = 
               Top = 436
               Left = 798
               Bottom = 626
               Right = 968
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleAuthor"
            Begin Extent = 
               Top = 228
               Left = 73
               Bottom = 361
               Right = 243
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Subject"
            Begin Extent = 
               Top = 580
               Left = 577
               Bottom = 693
               Right = 747
            End
     ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticleReviewer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'       DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SubjectField"
            Begin Extent = 
               Top = 490
               Left = 73
               Bottom = 603
               Right = 243
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
      Begin ColumnWidths = 47
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
         Column = 4200
         Alias = 1935
         Table = 2790
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticleReviewer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewArticleReviewer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[47] 4[28] 2[5] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[24] 2[34] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[43] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[52] 3) )"
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
         Configuration = "(H (1[44] 4[30] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[49] 4) )"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[30] 2) )"
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
         Configuration = "(V (2) )"
      End
      ActivePaneConfig = 2
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 3240
         Width = 2505
         Width = 3120
         Width = 3225
         Width = 2505
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 4200
         Alias = 1425
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewAuthorEditorChiefEditorInJournal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewAuthorEditorChiefEditorInJournal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[34] 4[34] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[42] 4[32] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[43] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4[57] 3) )"
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
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ArticleAuthor"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleEditor"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person"
            Begin Extent = 
               Top = 105
               Left = 728
               Bottom = 360
               Right = 907
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
         Width = 1440
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 5220
         Alias = 900
         Table = 1320
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewEditorByAuthor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewEditorByAuthor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[19] 4[17] 2[46] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[62] 4[14] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[62] 2[13] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[44] 3) )"
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
         Configuration = "(H (1[32] 4) )"
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
         Configuration = "(V (2) )"
      End
      ActivePaneConfig = 1
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ArticleEditor"
            Begin Extent = 
               Top = 169
               Left = 164
               Bottom = 299
               Right = 334
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person"
            Begin Extent = 
               Top = 336
               Left = 414
               Bottom = 611
               Right = 574
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Article"
            Begin Extent = 
               Top = 211
               Left = 740
               Bottom = 712
               Right = 948
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JournalUser"
            Begin Extent = 
               Top = 517
               Left = 132
               Bottom = 647
               Right = 302
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
         Width = 3135
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 4425
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
         Or = 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewEditorJournal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewEditorJournal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewEditorJournal'
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
         Configuration = "(H (1[79] 3) )"
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
         Configuration = "(H (1[16] 4) )"
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
      ActivePaneConfig = 1
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Article"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 266
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Attachment"
            Begin Extent = 
               Top = 39
               Left = 861
               Bottom = 169
               Right = 1031
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleAuthor"
            Begin Extent = 
               Top = 114
               Left = 525
               Bottom = 227
               Right = 695
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person_3"
            Begin Extent = 
               Top = 234
               Left = 236
               Bottom = 353
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Message"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person_1"
            Begin Extent = 
               Top = 354
               Left = 236
               Bottom = 473
               Right = 396
            End
            Display' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewEditorSendMessageUploadFile'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'Flags = 280
            TopColumn = 0
         End
         Begin Table = "Person_2"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 485
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleReviewer"
            Begin Extent = 
               Top = 474
               Left = 236
               Bottom = 604
               Right = 422
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
      Begin ColumnWidths = 50
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
      Begin ColumnWidths = 11
         Column = 4020
         Alias = 2070
         Table = 1590
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewEditorSendMessageUploadFile'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewEditorSendMessageUploadFile'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[26] 4[36] 2[6] 3) )"
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
         Configuration = "(H (1[31] 4[43] 2) )"
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
      ActivePaneConfig = 9
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Subject"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Journal"
            Begin Extent = 
               Top = 31
               Left = 389
               Bottom = 242
               Right = 567
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
         Column = 2805
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewJournal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewJournal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[29] 4[44] 2[3] 3) )"
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
         Configuration = "(H (1[28] 4[46] 2) )"
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
         Configuration = "(H (4[60] 2) )"
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
         Begin Table = "Journal"
            Begin Extent = 
               Top = 61
               Left = 494
               Bottom = 191
               Right = 684
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SubjectField"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 105
               Right = 214
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
         Column = 2835
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewSubjectField'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewSubjectField'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[30] 2[3] 3) )"
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
         Configuration = "(H (1[28] 4[46] 2) )"
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
         Begin Table = "JournalPage"
            Begin Extent = 
               Top = 9
               Left = 14
               Bottom = 139
               Right = 184
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Journal"
            Begin Extent = 
               Top = 61
               Left = 494
               Bottom = 191
               Right = 684
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewJournalPage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewJournalPage'
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
         Configuration = "(H (1[87] 3) )"
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
         Configuration = "(H (1[69] 4) )"
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
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "JournalUser"
            Begin Extent = 
               Top = 135
               Left = 323
               Bottom = 265
               Right = 493
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AspNetUsers"
            Begin Extent = 
               Top = 277
               Left = 557
               Bottom = 545
               Right = 776
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "AspNetUserRoles"
            Begin Extent = 
               Top = 378
               Left = 844
               Bottom = 488
               Right = 1014
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AspNetRoles"
            Begin Extent = 
               Top = 326
               Left = 1082
               Bottom = 422
               Right = 1252
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JournalUserActiveField"
            Begin Extent = 
               Top = 173
               Left = 71
               Bottom = 286
               Right = 263
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SubjectField"
            Begin Extent = 
               Top = 343
               Left = 310
               Bottom = 456
               Right = 480
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
      Begin ColumnWidths = 19
 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewJournalUserActiveField'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'        Width = 284
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewJournalUserActiveField'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewJournalUserActiveField'
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
         Configuration = "(H (1[24] 4[53] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[79] 3) )"
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
         Configuration = "(H (1[16] 4[59] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[79] 4) )"
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
      ActivePaneConfig = 8
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "AspNetUserRoles"
            Begin Extent = 
               Top = 83
               Left = 1178
               Bottom = 179
               Right = 1348
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AspNetUsers"
            Begin Extent = 
               Top = 70
               Left = 855
               Bottom = 414
               Right = 1100
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AspNetRoles"
            Begin Extent = 
               Top = 451
               Left = 974
               Bottom = 547
               Right = 1144
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person"
            Begin Extent = 
               Top = 348
               Left = 615
               Bottom = 620
               Right = 785
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JournalUser"
            Begin Extent = 
               Top = 49
               Left = 587
               Bottom = 162
               Right = 757
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Journal"
            Begin Extent = 
               Top = 127
               Left = 288
               Bottom = 325
               Right = 478
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Subject"
            Begin Extent = 
               Top = 304
               Left = 60
               Bottom = 417
               Right = 230
            End
      ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewJournalUserInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      DisplayFlags = 280
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
      Begin ColumnWidths = 16
         Width = 284
         Width = 1500
         Width = 810
         Width = 3480
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 3405
         Width = 1500
         Width = 5475
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
         Column = 1605
         Alias = 1050
         Table = 1815
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewJournalUserInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewJournalUserInfo'
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
         Configuration = "(H (1[15] 4[59] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[67] 3) )"
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
         Configuration = "(H (4[60] 2) )"
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
         Top = 0
         Left = -235
      End
      Begin Tables = 
         Begin Table = "Article"
            Begin Extent = 
               Top = 9
               Left = 1168
               Bottom = 139
               Right = 1396
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person_1"
            Begin Extent = 
               Top = 157
               Left = 1183
               Bottom = 535
               Right = 1343
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Message"
            Begin Extent = 
               Top = 9
               Left = 776
               Bottom = 276
               Right = 950
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person_3"
            Begin Extent = 
               Top = 223
               Left = 352
               Bottom = 538
               Right = 512
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
      Begin ColumnWidths = 41
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 3150
         Width = 3150
         Width = 1500
         Width = 1500
         Width = 1560
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewMessage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'500
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
         Width = 4485
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 4200
         Alias = 1965
         Table = 1500
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
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewMessage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[36] 2[20] 3) )"
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
         Begin Table = "Articles"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 332
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 5
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
         Column = 4230
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewMostVisitedArticle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewMostVisitedArticle'
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
         Begin Table = "News"
            Begin Extent = 
               Top = 6
               Left = 72
               Bottom = 219
               Right = 256
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewNew'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewNew'
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
         Configuration = "(H (1[33] 4) )"
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
      ActivePaneConfig = 9
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Person"
            Begin Extent = 
               Top = 103
               Left = 987
               Bottom = 455
               Right = 1157
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "AspNetUsers"
            Begin Extent = 
               Top = 32
               Left = 581
               Bottom = 423
               Right = 805
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AspNetUserRoles"
            Begin Extent = 
               Top = 19
               Left = 311
               Bottom = 115
               Right = 481
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AspNetRoles"
            Begin Extent = 
               Top = 66
               Left = 85
               Bottom = 175
               Right = 255
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
         Column = 4200
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewPersonInRole'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         Alias = 1050
         Table = 1200
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
         Configuration = "(H (1[51] 4[32] 3) )"
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
         Configuration = "(H (1[41] 4) )"
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
         Begin Table = "ArticleEditor"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleReviewer"
            Begin Extent = 
               Top = 4
               Left = 548
               Bottom = 134
               Right = 734
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ViewPersonInRole"
            Begin Extent = 
               Top = 18
               Left = 791
               Bottom = 356
               Right = 984
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
         Alias = 900
         Table = 1755
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 3645
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewReviewerKnownEditor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewReviewerKnownEditor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[15] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[63] 4[12] 3) )"
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
      ActivePaneConfig = 1
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ViewArticleReviewer"
            Begin Extent = 
               Top = 4
               Left = 413
               Bottom = 320
               Right = 641
            End
            DisplayFlags = 280
            TopColumn = 15
         End
         Begin Table = "ViewArticleEditor"
            Begin Extent = 
               Top = 6
               Left = 754
               Bottom = 281
               Right = 982
            End
            DisplayFlags = 280
            TopColumn = 22
         End
         Begin Table = "ViewMessage"
            Begin Extent = 
               Top = 4
               Left = 61
               Bottom = 279
               Right = 265
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
         Column = 2055
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Fil' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewReviewersCombinedResult'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'ter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewReviewersCombinedResult'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewReviewersCombinedResult'
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
         Begin Table = "Attachment"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person"
            Begin Extent = 
               Top = 23
               Left = 459
               Bottom = 256
               Right = 619
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
         Alias = 945
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewSupplementarie'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewSupplementarie'
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
      ActivePaneConfig = 1
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "AspNetUsers"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 362
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "UserDefiner"
            Begin Extent = 
               Top = 29
               Left = 654
               Bottom = 142
               Right = 824
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AspNetRoles"
            Begin Extent = 
               Top = 440
               Left = 878
               Bottom = 536
               Right = 1048
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AspNetUserRoles"
            Begin Extent = 
               Top = 421
               Left = 419
               Bottom = 517
               Right = 589
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
         O' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewUserDefiner'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'r = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewUserDefiner'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewUserDefiner'
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
         Begin Table = "AspNetUserRoles"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 102
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AspNetRoles"
            Begin Extent = 
               Top = 163
               Left = 279
               Bottom = 259
               Right = 449
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AspNetUsers"
            Begin Extent = 
               Top = 6
               Left = 635
               Bottom = 335
               Right = 859
            End
            DisplayFlags = 280
            TopColumn = 1
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
         Alias = 1050
         Table = 1575
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewUserRole'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewUserRole'
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
         Configuration = "(H (1[54] 4[18] 3) )"
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
         Configuration = "(H (1[12] 4) )"
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
      ActivePaneConfig = 9
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Subject"
            Begin Extent = 
               Top = 6
               Left = 939
               Bottom = 119
               Right = 1109
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Journal"
            Begin Extent = 
               Top = 3
               Left = 678
               Bottom = 210
               Right = 868
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Article"
            Begin Extent = 
               Top = 1
               Left = 349
               Bottom = 570
               Right = 577
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleType"
            Begin Extent = 
               Top = 310
               Left = 89
               Bottom = 406
               Right = 259
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ArticleAuthor"
            Begin Extent = 
               Top = 241
               Left = 747
               Bottom = 371
               Right = 917
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person"
            Begin Extent = 
               Top = 221
               Left = 966
               Bottom = 351
               Right = 1141
            End
            DisplayFlags = 280
            TopColumn = 14
         End
         Begin Table = "Volume"
            Begin Extent = 
               Top = 14
               Left = 68
               Bottom = 259
               Right = 238
            End
            DisplayFlag' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewVolume'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N's = 280
            TopColumn = 0
         End
         Begin Table = "SubjectField"
            Begin Extent = 
               Top = 421
               Left = 53
               Bottom = 534
               Right = 223
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
      Begin ColumnWidths = 42
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
         Column = 4515
         Alias = 5685
         Table = 2670
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewVolume'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewVolume'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[26] 4[30] 2[33] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[40] 4[21] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
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
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[62] 4) )"
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
      ActivePaneConfig = 9
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Volume"
            Begin Extent = 
               Top = 8
               Left = 26
               Bottom = 242
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Article"
            Begin Extent = 
               Top = 0
               Left = 369
               Bottom = 529
               Right = 613
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Journal"
            Begin Extent = 
               Top = 24
               Left = 951
               Bottom = 210
               Right = 1137
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
      Begin ColumnWidths = 39
         Width = 284
         Width = 3225
         Width = 3150
         Width = 3150
         Width = 1110
         Width = 1590
         Width = 3195
         Width = 1980
         Width = 3180
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
         Width = 1500
         Width = ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewVolumeIssue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 2940
         Alias = 1530
         Table = 2460
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 2880
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewVolumeIssue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewVolumeIssue'
GO
