CREATE DATABASE [Lezaczek_test_env]
GO
ALTER DATABASE [Lezaczek_test_env] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Lezaczek_test_env].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
USE [Lezaczek_test_env]
GO
/****** Object:  Table [Events]    Script Date: 21/05/2024 15:13:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Events](
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
/****** Object:  Table [News]    Script Date: 21/05/2024 15:13:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [News](
	[NewsId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[DateAdded] [datetime] NOT NULL,
	[DateOfEvent] [date] NOT NULL,
	[Place] [nvarchar](100) NULL,
	[StaringTime] [time](7) NULL,
	[EndingTime] [time](7) NULL,
 CONSTRAINT [PK_News] PRIMARY KEY CLUSTERED 
(
	[NewsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Users]    Script Date: 21/05/2024 15:13:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](80) NULL,
	[Email] [nvarchar](120) NOT NULL,
	[Surname] [nvarchar](80) NULL,
	[Password] [nvarchar](max) NOT NULL,
	[IsAdmin] [int] NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[LastLogin] [datetime] NULL,
	[UserGender] [nvarchar](10) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 1, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Events] ADD  DEFAULT ((0)) FOR [EventType]
GO
ALTER TABLE [Events] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Events] ADD  DEFAULT (CONVERT([date],sysdatetime())) FOR [DateStart]
GO
ALTER TABLE [Events] ADD  DEFAULT (CONVERT([date],sysdatetime())) FOR [DateEnd]
GO
ALTER TABLE [Events] ADD  DEFAULT (CONVERT([time],sysdatetime())) FOR [startingTime]
GO
ALTER TABLE [Events] ADD  DEFAULT (CONVERT([time],dateadd(hour,(1),sysdatetime()))) FOR [EndingTime]
GO
ALTER TABLE [News] ADD  CONSTRAINT [DF_News_DateAdded]  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Users] ADD  DEFAULT ((0)) FOR [IsAdmin]
GO
ALTER TABLE [Users] ADD  CONSTRAINT [DF_Users_TimeCreated]  DEFAULT (sysdatetime()) FOR [TimeCreated]
GO
ALTER TABLE [Events]  WITH CHECK ADD  CONSTRAINT [FK_Events_Users] FOREIGN KEY([UserId])
REFERENCES [Users] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Events] CHECK CONSTRAINT [FK_Events_Users]
GO
ALTER TABLE [News]  WITH CHECK ADD  CONSTRAINT [FK_News_Users] FOREIGN KEY([UserId])
REFERENCES [Users] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [News] CHECK CONSTRAINT [FK_News_Users]
GO
USE [master]
GO
ALTER DATABASE [Lezaczek_test_env] SET  READ_WRITE 
GO
