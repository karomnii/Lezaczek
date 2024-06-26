USE [master]
GO
IF NOT EXISTS 
    (SELECT name  
     FROM master.sys.server_principals
     WHERE name = 'test')
BEGIN
    CREATE LOGIN [test] WITH PASSWORD = ''; /* paste your env variable $TESTER_PASS value here*/
END
GO
CREATE DATABASE [Lezaczek]
GO
ALTER DATABASE [Lezaczek] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Lezaczek].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
USE [Lezaczek]
GO
/****** Object:  User [tester]    Script Date: 25/05/2024 01:12:50 ******/
CREATE USER [tester] FOR LOGIN [test] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Events]    Script Date: 25/05/2024 01:12:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Events](
	[EventId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Place] [nvarchar](100) NULL,
	[EventType] [int] NOT NULL,
	[DateAdded] [datetime] NOT NULL,
	[DateStart] [date] NOT NULL,
	[DateEnd] [date] NOT NULL,
	[startingTime] [time](7) NULL,
	[EndingTime] [time](7) NULL,
 CONSTRAINT [PK_Events] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[News]    Script Date: 25/05/2024 01:12:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News](
	[NewsId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[DateAdded] [datetime] NOT NULL,
	[DateOfEvent] [date] NOT NULL,
	[Place] [nvarchar](100) NULL,
	[StartingTime] [time](7) NULL,
	[EndingTime] [time](7) NULL,
 CONSTRAINT [PK_News] PRIMARY KEY CLUSTERED 
(
	[NewsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 25/05/2024 01:12:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](80) NULL,
	[Email] [nvarchar](120) NOT NULL,
	[Surname] [nvarchar](80) NULL,
	[Password] [nvarchar](max) NOT NULL,
	[IsAdmin] [int] NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[LastLogin] [datetime] NULL,
	[UserGender] [nvarchar](10) NULL,
	[Salt] [nvarchar](max) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Events] ADD  DEFAULT ((0)) FOR [EventType]
GO
ALTER TABLE [dbo].[Events] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [dbo].[Events] ADD  DEFAULT (CONVERT([date],sysdatetime())) FOR [DateStart]
GO
ALTER TABLE [dbo].[Events] ADD  DEFAULT (CONVERT([date],sysdatetime())) FOR [DateEnd]
GO
ALTER TABLE [dbo].[Events] ADD  DEFAULT (CONVERT([time],sysdatetime())) FOR [startingTime]
GO
ALTER TABLE [dbo].[Events] ADD  DEFAULT (CONVERT([time],dateadd(hour,(1),sysdatetime()))) FOR [EndingTime]
GO
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_News_DateAdded]  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [IsAdmin]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_TimeCreated]  DEFAULT (sysdatetime()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[Events]  WITH CHECK ADD  CONSTRAINT [FK_Events_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Events] CHECK CONSTRAINT [FK_Events_Users]
GO
ALTER TABLE [dbo].[News]  WITH CHECK ADD  CONSTRAINT [FK_News_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[News] CHECK CONSTRAINT [FK_News_Users]
GO
USE [master]
GO
ALTER DATABASE [Lezaczek] SET  READ_WRITE 
GO
