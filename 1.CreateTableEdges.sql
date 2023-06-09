USE [Graphs]
GO

/****** Object:  Table [dbo].[Edges]    Script Date: 04.06.2023 0:19:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Edges](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[v1] [int] NULL,
	[v2] [int] NULL,
	[weight] [int] NULL,
 CONSTRAINT [PK_Edges] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


