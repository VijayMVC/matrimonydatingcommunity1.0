USE [LovenmaryEmpty]
GO
/****** Object:  Table [dbo].[Quotescatmaster]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Quotescatmaster](
	[catid] [int] IDENTITY(1,1) NOT NULL,
	[category] [varchar](250) NOT NULL,
 CONSTRAINT [PK_Quotescatmaster] PRIMARY KEY CLUSTERED 
(
	[catid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[ProperCase]    Script Date: 06/25/2015 17:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ProperCase](@Text as varchar(8000))
returns varchar(8000)
as
begin
   declare @Reset bit;
   declare @Ret varchar(8000);
   declare @i int;
   declare @c char(1);

   select @Reset = 1, @i=1, @Ret = '';
   
   while (@i <= len(@Text))
   	select @c= substring(@Text,@i,1),
               @Ret = @Ret + case when @Reset=1 then UPPER(@c) else LOWER(@c) end,
               @Reset = case when @c like '[a-zA-Z]' then 0 else 1 end,
               @i = @i +1
   return @Ret
end
GO
/****** Object:  Table [dbo].[profileviews]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[profileviews](
	[viewedbyid] [bigint] NOT NULL,
	[pidof] [bigint] NOT NULL,
	[ipaddress] [varchar](150) NOT NULL,
	[vieweddate] [smalldatetime] NOT NULL,
	[viewid] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_profileviews] PRIMARY KEY CLUSTERED 
(
	[viewid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Referals]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Referals](
	[Pid] [varchar](60) NOT NULL,
	[referdby] [varchar](60) NOT NULL,
	[refer2] [varchar](60) NOT NULL,
	[ref1val] [money] NOT NULL,
	[ref2val] [money] NOT NULL,
	[ipaddress] [varchar](150) NOT NULL,
	[paid] [varchar](1) NOT NULL,
	[refdate] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QuotesCommnets]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QuotesCommnets](
	[commentid] [bigint] IDENTITY(1,1) NOT NULL,
	[picid] [bigint] NOT NULL,
	[candiid] [bigint] NOT NULL,
	[fname] [varchar](250) NOT NULL,
	[comment] [varchar](500) NOT NULL,
	[commnetdate] [datetime] NOT NULL,
	[approved] [varchar](1) NOT NULL,
 CONSTRAINT [PK_QuotesCommnets] PRIMARY KEY CLUSTERED 
(
	[commentid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Login_Details]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Login_Details](
	[LogId] [bigint] IDENTITY(1,1) NOT NULL,
	[candiid] [bigint] NOT NULL,
	[LoginDate] [datetime] NOT NULL,
	[LogoutDate] [datetime] NULL,
	[IPAddress] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Login_Details] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[send_msg]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[send_msg](
	[msgid] [bigint] IDENTITY(1,1) NOT NULL,
	[msgtoid] [bigint] NOT NULL,
	[msgfromid] [bigint] NOT NULL,
	[msg] [varchar](500) NOT NULL,
	[msgdate] [datetime] NOT NULL,
	[aproveSender] [varchar](1) NOT NULL,
	[msgissend] [varchar](1) NOT NULL,
 CONSTRAINT [PK_send_msg] PRIMARY KEY CLUSTERED 
(
	[msgid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[ShowAllQuotesComments]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ShowAllQuotesComments] --0,100,'1=1'
--Declare
@startRowIndex int,
@maximumRows int,
@criteria nvarchar(500)


as
--Set @startRowIndex=0
--Set @maximumRows=300
--Set @criteria = '1 =1'

Declare @sqlst as varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;


select @sqlst='SELECT   * from (select c.commentid ,ROW_NUMBER() OVER(ORDER BY c.commnetdate DESC) AS rowid,c.candiid,p.fname,p.lname,p.photo,
c.comment 
from QuotesCommnets c inner join profile p
on c.candiid=p.pid

where '+ @criteria +'

) as kk'

EXEC(@sqlst + ' where rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxRow+')')
GO
/****** Object:  StoredProcedure [dbo].[ShowAllQuotes]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PRoc [dbo].[ShowAllQuotes] --0 , 500 , ' 1 =1  '
--Declare
@startRowIndex int,
@maximumRows int,
@criteria varchar(500)


as
--Set @startRowIndex=0
--Set @maximumRows=300
--Set @criteria = '1 =1'

Declare @sqlst as varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;

select @sqlst='SELECT   * from
(Select quotesid,tbl_Quotes.candiid,quotesdate,Quotessub,QuotesDesc,quotespic,
(Select count(commentid) FROM QuotesCommnets where picid=quotesid ) as CommentsTotal,
Profile.fname as Username,
Profile.photo as Photo,
isnull((Select SUM(rate)/COUNT(0) from tbl_rating_typeWise where tbl_rating_typeWise.fk_postId=tbl_Quotes.quotesid and posttype=''Quot''),0) as Rating,
ROW_NUMBER() OVER(ORDER BY quotesdate DESC) AS rowid  
from tbl_Quotes
inner join Profile on  tbl_Quotes.candiid=Profile.pid

where '+ @criteria +'

) as kk'

--Select quotesid,tbl_Quotes.candiid,quotesdate,Quotessub,QuotesDesc,quotespic,
--(Select count(commentid) FROM QuotesCommnets where picid=quotesid ) as CommentsTotal,
--candidatesRegistration.firstname as Username,
--candidatesRegistration.photo as Photo,
----isnull((Select SUM(rate)/COUNT(0) from tbl_rating_typeWise where tbl_rating_typeWise.fk_postId=tbl_Quotes.quotesid and posttype='Fun'),0) as Rating,
--ROW_NUMBER() OVER(ORDER BY quotesdate DESC) AS rowid  
--from tbl_Quotes
--inner join candidatesRegistration on  tbl_Quotes.candiid=tbl_Quotes.candiid


EXEC(@sqlst + ' where rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxRow +')')
GO
/****** Object:  StoredProcedure [dbo].[ShowAllPolls]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PRoc [dbo].[ShowAllPolls] --0 , 500 , ' 1 =1  '
--Declare
@startRowIndex int,
@maximumRows int,
@criteria varchar(500)


as
--Set @startRowIndex=0
--Set @maximumRows=300
--Set @criteria = '1 =1'

Declare @sqlst as varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;

select @sqlst='SELECT   * from
(Select 
Sno,

QsnDesc,
NoOfOptions,

CreationloginId,
CreationDate,
(Select count(SNo) FROM OnlinePoleTest_Master where 
QueId=pole_Que_CreateMaster.Sno and polecomment<>'''')
 as CommentsTotal,
(Select count(QueId) FROM OnlinePoleTest_Master where QueId=pole_Que_CreateMaster.Sno)
 as PoleTaken,
(Select fname from Profile where pid=CreationLogInId) as Username,
(Select photo from Profile where pid=CreationLogInId) as Photo,
isnull((Select SUM(rate)/COUNT(0) from tbl_rating_typeWise where tbl_rating_typeWise.fk_postId=pole_Que_CreateMaster.Sno and posttype=''Poll''),0) as Rating,
ROW_NUMBER() OVER(ORDER BY CreationDate DESC) AS rowid 
from pole_Que_CreateMaster

where '+ @criteria +'

) as kk'


EXEC(@sqlst + ' where rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxRow +')')
GO
/****** Object:  StoredProcedure [dbo].[ShowAllpollcomments]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ShowAllpollcomments] --12,2
--Declare
@startRowIndex int,
@maximumRows int,
@mid varchar(500)

as
--Set @startRowIndex=0
--Set @maximumRows=500000
--Set @mid='20092140518'

declare @sqlst varchar(max), @MaxRow int
set @MaxRow= @startRowIndex + @maximumRows
set @sqlst ='select * from (
select SNo ,ROW_NUMBER() OVER(ORDER BY sno DESC) AS rowid,c.CreationLogInId,poleAns,p.fname,p.lname,p.photo,
c.polecomment 
from OnlinePoleTest_Master c inner join [Profile] p
on c.CreationLogInId =p.pid
where '+ @mid +'

) as kk'

EXEC(@sqlst + ' where rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxRow +')')
GO
/****** Object:  Table [dbo].[siteactivity]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[siteactivity](
	[siteactivityid] [bigint] IDENTITY(1,1) NOT NULL,
	[candiid] [bigint] NOT NULL,
	[activity] [varchar](700) NOT NULL,
	[activitydate] [smalldatetime] NOT NULL,
	[photo] [varchar](250) NOT NULL,
	[pk_Id] [bigint] NOT NULL,
	[actType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_siteactivity] PRIMARY KEY CLUSTERED 
(
	[siteactivityid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[Supports_get]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Supports_get]
@startRowIndex int,
@maximumRows int,
@Criteria varchar(MAX)
as
Declare @smt varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows
set @smt='Select * from(
select *,ROW_NUMBER() OVER (Order By ComplaintID desc)as rowid 
,CASE	WHEN IsResolved=''Y'' THEN ''messageAreaR''
		ELSE ''messageAreaP'' 
END as BGCls
from Support
Where' + @Criteria +' ) as kk'
Exec(@smt +' where rowid > ' + @startRowIndex + ' AND rowid <= '+@MaxRow)
GO
/****** Object:  StoredProcedure [dbo].[support_Comments_get]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[support_Comments_get]
@startRowIndex int,
@maximumRows int,
@Criteria varchar(MAX)
as
Declare @smt varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows
set @smt='Select * from(
select CC.*,''Re: '' + UC.ComplaintHead as ComplaintHead ,ROW_NUMBER() OVER (Order By CommentsID)as rowid 
from Support_comments CC JOIN Support UC
ON CC.ComplaintsID=UC.ComplaintID
Where' + @Criteria +' ) as kk'
Exec(@smt +' where rowid > ' + @startRowIndex + ' AND rowid <= '+@MaxRow)

--,CASE	WHEN IsResolved=''Y'' THEN ''messageAreaR''
--		ELSE ''messageAreaP'' 
--END as BGCls
GO
/****** Object:  Table [dbo].[Support_comments]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Support_comments](
	[CommentsID] [bigint] IDENTITY(1,1) NOT NULL,
	[ComplaintsID] [bigint] NOT NULL,
	[Comments] [varchar](5000) NOT NULL,
	[CommentsBy] [bigint] NOT NULL,
	[CommentsByName] [varchar](250) NOT NULL,
	[IsAdmin] [varchar](1) NOT NULL,
	[CommentsDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Support_Comments] PRIMARY KEY CLUSTERED 
(
	[CommentsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Support]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Support](
	[ComplaintID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserMobile] [varchar](20) NOT NULL,
	[EmailID] [varchar](250) NOT NULL,
	[UserName] [varchar](250) NOT NULL,
	[ComplaintHead] [varchar](500) NOT NULL,
	[ComplaintDesc] [varchar](5000) NOT NULL,
	[ComplaintDate] [datetime] NOT NULL,
	[IsResolved] [varchar](1) NOT NULL,
	[ResolvedDate] [datetime] NULL,
	[ResolvedBy] [bigint] NOT NULL,
	[ResolvedByName] [varchar](250) NOT NULL,
 CONSTRAINT [PK_Support] PRIMARY KEY CLUSTERED 
(
	[ComplaintID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SubCategory]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SubCategory](
	[SubCatId] [bigint] IDENTITY(1,1) NOT NULL,
	[CatId] [bigint] NOT NULL,
	[CandiId] [bigint] NOT NULL,
	[SubCatTitle] [varchar](250) NOT NULL,
	[SubCatDesc] [varchar](500) NOT NULL,
	[StartedBy] [bigint] NOT NULL,
	[UpdatedBy] [bigint] NULL,
	[LastTopic] [varchar](500) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[IsApprover] [varchar](1) NOT NULL,
	[LastTopicid] [bigint] NOT NULL,
	[TotalView] [bigint] NOT NULL,
 CONSTRAINT [PK_SubCategory] PRIMARY KEY CLUSTERED 
(
	[SubCatId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[User_Complaints]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User_Complaints](
	[ComplaintID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserMobile] [varchar](20) NOT NULL,
	[EmailID] [varchar](250) NOT NULL,
	[UserName] [varchar](250) NOT NULL,
	[ComplaintHead] [varchar](500) NOT NULL,
	[ComplaintDesc] [varchar](5000) NOT NULL,
	[ComplaintDate] [datetime] NOT NULL,
	[IsResolved] [varchar](1) NOT NULL,
	[ResolvedDate] [datetime] NULL,
	[ResolvedBy] [bigint] NOT NULL,
	[ResolvedByName] [varchar](250) NOT NULL,
 CONSTRAINT [PK_User_Complaints] PRIMARY KEY CLUSTERED 
(
	[ComplaintID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[User_Complaints_Comments]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User_Complaints_Comments](
	[CommentsID] [bigint] IDENTITY(1,1) NOT NULL,
	[ComplaintsID] [bigint] NOT NULL,
	[Comments] [varchar](5000) NOT NULL,
	[CommentsBy] [bigint] NOT NULL,
	[CommentsByName] [varchar](250) NOT NULL,
	[IsAdmin] [varchar](1) NOT NULL,
	[CommentsDate] [datetime] NOT NULL,
 CONSTRAINT [PK_User_Complaints_Comments] PRIMARY KEY CLUSTERED 
(
	[CommentsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[User_Interest]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User_Interest](
	[ExpressID] [bigint] IDENTITY(1,1) NOT NULL,
	[Candiid] [bigint] NOT NULL,
	[IntrestedIn] [bigint] NOT NULL,
	[InterestDate] [datetime] NOT NULL,
	[ResponseDate] [date] NULL,
	[UserResponse] [varchar](10) NOT NULL,
	[UserMessage] [varchar](500) NOT NULL,
	[InterestFor] [varchar](250) NOT NULL,
 CONSTRAINT [PK_User_Interest] PRIMARY KEY CLUSTERED 
(
	[ExpressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[totalRegistered]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[totalRegistered]
@startRowIndex int,
@maximumRows int,
@criteria varchar(max)
as
Declare @sqlst as varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows
select @sqlst='With TotalRegMem as(
	select distinct 
	cr.candiid 
	,cr.FirstName
      ,cr.LastName
      ,cr.EmailID
      ,cr.Passw
      ,cr.MobileNo
      ,cr.cityName
      ,cr.StateName
      ,cr.Country
      ,cr.IsActive
      ,cr.IsApproved
      ,cr.RegDate
      ,cr.LastLogin
      ,cr.address
      ,cr.photo
      ,cr.ipaddress
      ,cr.websiteUrl
      ,cr.issuspended
     ,cr.LastPayDate
      ,CONVERT(varchar(11),cr.NextPayDate,106) as NextPayDate
      ,isnull((Select TOP 1 p_name from partner_Payment PP Where PP.candiid=cr.candiid Order By TransID Desc),'''') AS Plan_Name
      ,ROW_NUMBER() OVER(ORDER BY cr.candiid DESC) AS rowid 
      ,fd.FtpHostName
      ,fd.Ftpusername 
      ,fd.FtpPassword
     
 from candireg cr left outer join dbo.FtpDetail fd on cr.candiid = fd.candiid   where ' + @criteria +' ) select * from TotalRegMem '

EXEC(@sqlst + ' where  rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxRow +') Order By rowid Asc') 

--totalRegistered 0 , 120, '1=1'CONVERT(date, RegDate) between CONVERT(date, getdate()-7)'
GO
/****** Object:  Table [dbo].[topicsQnAansw]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[topicsQnAansw](
	[answerid] [varchar](50) NOT NULL,
	[forumqnaid] [int] NOT NULL,
	[anser] [varchar](5000) NOT NULL,
	[updatedby] [varchar](250) NOT NULL,
	[updateddate] [smalldatetime] NOT NULL,
	[isApproved] [varchar](1) NULL,
	[isapprove] [varchar](1) NULL,
	[updatebyid] [bigint] NOT NULL,
 CONSTRAINT [PK_topicsQnAansw] PRIMARY KEY CLUSTERED 
(
	[answerid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TopicAnswer]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[TopicAnswer](
	[AnsId] [bigint] IDENTITY(1,1) NOT NULL,
	[TopicId] [bigint] NOT NULL,
	[TopicAns] [varchar](5000) NOT NULL,
	[CandiId] [bigint] NOT NULL,
	[AnsDate] [datetime] NOT NULL,
	[IsApproved] [varchar](1) NOT NULL,
	[candiName] [varchar](250) NOT NULL,
 CONSTRAINT [PK_TopicAnswer] PRIMARY KEY CLUSTERED 
(
	[AnsId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_rating_typeWise]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_rating_typeWise](
	[pk_id] [bigint] IDENTITY(1,1) NOT NULL,
	[fk_postId] [bigint] NOT NULL,
	[rate] [int] NOT NULL,
	[posttype] [varchar](10) NOT NULL,
	[fk_userid] [bigint] NOT NULL,
 CONSTRAINT [PK_tbl_rating_typeWise] PRIMARY KEY CLUSTERED 
(
	[pk_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_Quotes]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Quotes](
	[quotesid] [bigint] IDENTITY(1,1) NOT NULL,
	[candiid] [bigint] NOT NULL,
	[quotesdate] [datetime] NULL,
	[Quotessub] [varchar](100) NULL,
	[QuotesDesc] [varchar](500) NULL,
	[quotespic] [varchar](100) NULL,
	[ipaddress] [varchar](50) NULL,
	[IsApproved] [varchar](1) NULL,
	[categoryId] [int] NOT NULL,
 CONSTRAINT [PK_tbl_Quotes] PRIMARY KEY CLUSTERED 
(
	[quotesid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Topic]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Topic](
	[TopicId] [bigint] IDENTITY(1,1) NOT NULL,
	[TopicTitle] [varchar](500) NOT NULL,
	[TopicDesc] [nvarchar](max) NULL,
	[SubCatId] [bigint] NOT NULL,
	[CandiId] [bigint] NOT NULL,
	[UpdateCandiName] [varchar](250) NULL,
	[UpdateCandiId] [bigint] NULL,
	[StartDate] [datetime] NOT NULL,
	[UpdateDate] [datetime] NULL,
	[IsApproved] [varchar](1) NOT NULL,
	[candiName] [varchar](50) NULL,
	[TotalView] [bigint] NOT NULL,
	[CatId] [bigint] NOT NULL,
	[LastAnsId] [smallint] NOT NULL,
 CONSTRAINT [PK_Topic] PRIMARY KEY CLUSTERED 
(
	[TopicId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TopEarners_bkp]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TopEarners_bkp](
	[eid] [bigint] IDENTITY(1,1) NOT NULL,
	[mid] [bigint] NOT NULL,
	[earnedamt] [decimal](18, 2) NOT NULL,
	[earndate] [smalldatetime] NOT NULL,
	[source] [varchar](50) NOT NULL,
	[pstatus] [varchar](50) NOT NULL,
	[referd] [bigint] NOT NULL,
	[regdatetp] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[topearners]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[topearners](
	[eid] [bigint] IDENTITY(1,1) NOT NULL,
	[mid] [bigint] NOT NULL,
	[earnedamt] [decimal](18, 2) NOT NULL,
	[earndate] [smalldatetime] NOT NULL,
	[source] [varchar](50) NOT NULL,
	[pstatus] [varchar](50) NOT NULL,
	[referd] [bigint] NOT NULL,
	[regdatetp] [datetime] NOT NULL,
 CONSTRAINT [PK_topearners_1] PRIMARY KEY CLUSTERED 
(
	[eid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[topearnercount]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[topearnercount]
@criteria varchar(max)
as
Declare @sqlst as varchar(max)
select @sqlst='select count(*)
from profile pr inner join topearners r1
on pr.pid=r1.mid where ' + @criteria

EXEC(@sqlst)
GO
/****** Object:  StoredProcedure [dbo].[topearner]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[topearner] 
@startRowIndex int,
@maximumRows int,
@criteria varchar(max)
as

Declare @sqlst as varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;

select @sqlst='
select * from(
select r1.mid,pr.fname,pr.lname,pr.email,pr.gender,pr.countryname,
pr.state,pr.cityname,pr.whoami,pr.purpose,pr.ethnic,pr.religion,pr.caste,
sum(earnedamt) as sum1,photoname,ph.passw,pr.ipaddress,pr.ipcountry,pr.cityid,

ROW_NUMBER() OVER(ORDER BY sum(earnedamt) DESC) AS rowid 
from profile pr join topearners r1 on pr.pid=r1.mid
left join singlephoto ph on pr.pid=ph.pid where ' + @criteria +' 
group by r1.mid,pr.fname,pr.lname,pr.email,pr.gender,
pr.passw,pr.countryname,pr.state,pr.cityname, pr.whoami,
pr.purpose,pr.ethnic,pr.religion,pr.caste,photoname,
ph.passw,pr.ipaddress,pr.ipcountry,pr.cityid) as kk'

EXEC(@sqlst + ' where  rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxRow +') ')
	
	
	--Select * from topearners
GO
/****** Object:  Table [dbo].[websolaffi]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[websolaffi](
	[candiid] [bigint] IDENTITY(1,1) NOT NULL,
	[Passw] [varchar](250) NOT NULL,
	[emailAddress] [varchar](250) NOT NULL,
	[firstname] [varchar](250) NOT NULL,
	[lastname] [varchar](250) NOT NULL,
	[regdate] [datetime] NOT NULL,
	[dateofbirth] [datetime] NOT NULL,
	[gender] [varchar](1) NOT NULL,
	[address1] [varchar](255) NOT NULL,
	[address2] [varchar](255) NOT NULL,
	[address3] [varchar](255) NOT NULL,
	[pincode] [varchar](50) NOT NULL,
	[Telephone] [varchar](50) NOT NULL,
	[mobile] [varchar](50) NOT NULL,
	[cityid] [bigint] NOT NULL,
	[cityname] [varchar](250) NOT NULL,
	[stateid] [bigint] NOT NULL,
	[statename] [varchar](250) NOT NULL,
	[countryname] [varchar](250) NOT NULL,
	[countryid] [int] NOT NULL,
	[education] [varchar](255) NOT NULL,
	[TotalExp] [int] NOT NULL,
	[CVlocation] [varchar](100) NOT NULL,
	[Enddate] [datetime] NOT NULL,
	[LastLogin] [datetime] NOT NULL,
	[imagename] [varchar](150) NOT NULL,
	[imageext] [varchar](10) NOT NULL,
	[emailverified] [varchar](1) NOT NULL,
	[Activated] [varchar](1) NOT NULL,
	[Verified] [varchar](1) NOT NULL,
	[blocked] [varchar](1) NOT NULL,
	[mth] [int] NOT NULL,
	[profiletype] [int] NOT NULL,
	[Friendshipzone] [varchar](1) NOT NULL,
	[Remail] [varchar](1) NOT NULL,
	[Purpose] [varchar](250) NOT NULL,
	[referdby] [bigint] NULL,
	[referdbyold] [varchar](255) NOT NULL,
	[banned] [varchar](1) NOT NULL,
	[showgads] [varchar](1) NOT NULL,
	[ipaddress] [varchar](100) NOT NULL,
	[industryid] [int] NOT NULL,
	[industryname] [varchar](250) NOT NULL,
	[jobcategoryid] [int] NOT NULL,
	[jobcategoryname] [varchar](250) NOT NULL,
	[designation] [varchar](255) NOT NULL,
	[companyname] [varchar](255) NOT NULL,
	[keywords] [varchar](255) NOT NULL,
	[university] [varchar](255) NOT NULL,
	[certification] [varchar](255) NOT NULL,
	[certifications] [varchar](255) NOT NULL,
	[isbouncing] [varchar](1) NOT NULL,
	[adminemails] [varchar](1) NOT NULL,
	[Jobalerts] [varchar](1) NOT NULL,
	[EmailfromEmployers] [varchar](1) NOT NULL,
	[emailsent] [varchar](1) NOT NULL,
	[hide] [varchar](1) NOT NULL,
	[filextension] [varchar](5) NOT NULL,
	[isonlinenow] [varchar](1) NOT NULL,
	[photo] [varchar](150) NOT NULL,
	[photopassw] [varchar](60) NOT NULL,
	[Smsjobalerts] [varchar](1) NOT NULL,
	[SmsEmployerAlert] [varchar](1) NOT NULL,
	[SmsInspirationalQuotes] [varchar](1) NOT NULL,
	[SmsFunnyQuotes] [varchar](1) NOT NULL,
	[isValidMobile] [varchar](1) NOT NULL,
	[smsOffers] [varchar](1) NOT NULL,
	[smsAdmin] [varchar](1) NOT NULL,
	[photoapproved] [varchar](1) NOT NULL,
	[approvedFProfile] [varchar](1) NOT NULL,
	[ipcountry] [varchar](150) NOT NULL,
	[isdoubtful] [varchar](1) NOT NULL,
	[sponsoremail] [varchar](1) NOT NULL,
	[hasinvited] [varchar](1) NOT NULL,
	[bayt] [varchar](1) NOT NULL,
	[profileheadline] [varchar](250) NOT NULL,
	[Ethnicity] [varchar](150) NOT NULL,
	[religion] [varchar](150) NOT NULL,
	[caste] [varchar](150) NOT NULL,
	[starsign] [varchar](150) NOT NULL,
	[maritalstatus] [varchar](150) NOT NULL,
	[lang] [varchar](150) NOT NULL,
	[htid] [int] NOT NULL,
	[htname] [varchar](50) NOT NULL,
	[wt] [varchar](50) NOT NULL,
	[skincolor] [varchar](50) NOT NULL,
	[eyesight] [varchar](50) NOT NULL,
	[aboutme] [varchar](250) NOT NULL,
	[diet] [varchar](50) NOT NULL,
	[drinks] [varchar](50) NOT NULL,
	[smoke] [varchar](50) NOT NULL,
	[drugs] [varchar](50) NOT NULL,
	[Susp] [varchar](1) NOT NULL,
	[sponsorsent] [varchar](1) NOT NULL,
	[ref1val] [decimal](18, 2) NOT NULL,
	[baytmember] [varchar](1) NOT NULL,
	[pstatus] [varchar](50) NOT NULL,
	[visibleinSearchengine] [varchar](1) NOT NULL,
	[showpvtinfo] [varchar](1) NOT NULL,
	[schoolname] [varchar](250) NOT NULL,
	[schoolyear] [varchar](4) NOT NULL,
	[collename] [varchar](250) NOT NULL,
	[colyear] [varchar](4) NOT NULL,
	[companywebsite] [varchar](350) NOT NULL,
	[allowprofilecomments] [varchar](1) NOT NULL,
	[FrinedshipRequests] [varchar](1) NOT NULL,
	[KnowsEmailCanAdd] [varchar](1) NOT NULL,
	[blacklistedemail] [varchar](1) NOT NULL,
	[newsnFun] [varchar](1) NOT NULL,
	[exportedTowebsol] [varchar](1) NOT NULL,
	[mrole] [varchar](10) NOT NULL,
	[shine] [int] NOT NULL,
	[referdurl] [varchar](400) NOT NULL,
	[bouncemarkexptowebsol] [varchar](1) NOT NULL,
	[facebookpost] [varchar](1) NOT NULL,
	[FB_ID] [varchar](50) NOT NULL,
	[FB_UserName] [varchar](250) NOT NULL,
	[IsGPlus] [varchar](1) NOT NULL,
	[GPlusImg] [varchar](250) NOT NULL,
	[GplusASProfile] [varchar](1) NOT NULL,
	[Mem_Type] [varchar](1) NOT NULL,
	[candiWeb] [varchar](250) NOT NULL,
	[GplusID] [varchar](250) NOT NULL,
	[aim] [varchar](500) NOT NULL,
 CONSTRAINT [PK_websolaffi_1] PRIMARY KEY CLUSTERED 
(
	[candiid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[waitingmembers]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[waitingmembers] --waitingmembers 0,1100,' inner join ', ' profile.pid in(Select distinct candiid from User_Interest WHere IntrestedIn=11 and UserResponse=''P'')' , 11'
@startRowIndex int,
@maximumRows int,
@jointype varchar(60),
@criteria varchar(max),
@candiid bigint
as

Declare @sqlst as varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;

select @sqlst='
With Waiting_Mem as (
select  ROW_NUMBER() OVER(ORDER BY profiledate DESC) AS rowid ,profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,passw ,
(Select InterestFor from User_Interest where User_Interest.candiid=profile.pid and User_Interest.IntrestedIn = ' + convert(varchar,@candiid) + ') AS InterestFor
from profile  where  ' + @criteria + ' )
select *,(Select MAX(Rowid) from Waiting_Mem AS Total) from Waiting_Mem'
EXEC(@sqlst + ' where rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxRow + ')')
GO
/****** Object:  StoredProcedure [dbo].[waitingForResponse]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[waitingForResponse] --0,1100,' inner join ', '1=1'
@startRowIndex int,
@maximumRows int,
@jointype varchar(60),
@criteria varchar(max),
@candiid bigint
as

Declare @sqlst as varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;

select @sqlst='select * from (
select   ROW_NUMBER() OVER(ORDER BY profiledate DESC) AS rowid ,profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,passw ,
(Select InterestFor from User_Interest where User_Interest.IntrestedIn=profile.pid and User_Interest.candiid = ' + convert(varchar,@candiid) + ') AS InterestFor
from profile  where  ' + @criteria + ' ) as kk'
EXEC(@sqlst + ' where rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxRow + ')')
GO
/****** Object:  Table [dbo].[User_Steps]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User_Steps](
	[User_Step_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candiid] [bigint] NOT NULL,
	[StepID] [bigint] NOT NULL,
	[IsView] [varchar](1) NOT NULL,
	[IsTestTaken] [varchar](1) NOT NULL,
	[IsPassTest] [varchar](1) NOT NULL,
	[CompletedON] [date] NULL,
 CONSTRAINT [PK_User_Steps] PRIMARY KEY CLUSTERED 
(
	[User_Step_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[User_Complaints_get]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[User_Complaints_get]
@startRowIndex int,
@maximumRows int,
@Criteria varchar(MAX)
as
SET NOCOUNT ON;
Declare @smt varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;
set @smt='With AllComplaints AS(
select *,ROW_NUMBER() OVER (Order By ComplaintID desc)as rowid 
,CASE	WHEN IsResolved=''Y'' THEN ''messageAreaR''
		ELSE ''messageAreaP'' 
END as BGCls
from User_Complaints
Where ' + @Criteria +' ) Select *,(Select MAX(rowid) from AllComplaints) AS Total from AllComplaints'
Exec(@smt +' where rowid > ' + @startRowIndex + ' AND rowid <= '+@MaxRow)
GO
/****** Object:  StoredProcedure [dbo].[User_Complaints_Comments_get]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[User_Complaints_Comments_get]
@startRowIndex int,
@maximumRows int,
@Criteria varchar(MAX)
as
Declare @smt varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;
set @smt='WITH AllComments AS (
select CC.*,''Re: '' + UC.ComplaintHead as ComplaintHead ,ROW_NUMBER() OVER (Order By CommentsID)as rowid 
from User_Complaints_Comments CC JOIN User_Complaints UC
ON CC.ComplaintsID=UC.ComplaintID
Where ' + @Criteria +' ) Select *,(SELECT MAX(rowid) from AllComments) AS Total from AllComments'
Exec(@smt +' where rowid > ' + @startRowIndex + ' AND rowid <= '+@MaxRow)

--,CASE	WHEN IsResolved=''Y'' THEN ''messageAreaR''
--		ELSE ''messageAreaP'' 
--User_Complaints_Comments_get 0,10,'CC.ComplaintsID=590'
GO
/****** Object:  Table [dbo].[users]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[users](
	[userid] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](250) NOT NULL,
	[passw] [varchar](250) NOT NULL,
	[role] [varchar](50) NOT NULL,
 CONSTRAINT [pkusers] PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WebsolAffi_Forums_MainCategory]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WebsolAffi_Forums_MainCategory](
	[catid] [bigint] IDENTITY(1,1) NOT NULL,
	[Category] [varchar](500) NOT NULL,
	[descrip] [varchar](500) NOT NULL,
	[CandiId] [bigint] NOT NULL,
	[StartDate] [datetime] NOT NULL,
 CONSTRAINT [PK_WebsolAffi_Forums_MainCategory] PRIMARY KEY CLUSTERED 
(
	[catid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WebsolAffi_Forums_TopicAnswer]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WebsolAffi_Forums_TopicAnswer](
	[AnsId] [bigint] IDENTITY(1,1) NOT NULL,
	[TopicId] [bigint] NOT NULL,
	[TopicAns] [varchar](5000) NOT NULL,
	[CandiId] [bigint] NOT NULL,
	[AnsDate] [datetime] NOT NULL,
	[IsApproved] [varchar](1) NOT NULL,
	[candiName] [varchar](250) NOT NULL,
 CONSTRAINT [WebsolAffi_PK_TopicAnswer] PRIMARY KEY CLUSTERED 
(
	[AnsId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WebsolAffi_Forums_Topic]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[WebsolAffi_Forums_Topic](
	[TopicId] [bigint] IDENTITY(1,1) NOT NULL,
	[TopicTitle] [varchar](500) NOT NULL,
	[TopicDesc] [nvarchar](max) NULL,
	[SubCatId] [bigint] NOT NULL,
	[CandiId] [bigint] NOT NULL,
	[UpdateCandiName] [varchar](250) NULL,
	[UpdateCandiId] [bigint] NULL,
	[StartDate] [datetime] NOT NULL,
	[UpdateDate] [datetime] NULL,
	[IsApproved] [varchar](1) NOT NULL,
	[candiName] [varchar](50) NULL,
	[TotalView] [bigint] NOT NULL,
	[CatId] [bigint] NOT NULL,
 CONSTRAINT [WebsolAffi_PK_Topic] PRIMARY KEY CLUSTERED 
(
	[TopicId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WebsolAffi_Forums_SubCategory]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WebsolAffi_Forums_SubCategory](
	[SubCatId] [bigint] IDENTITY(1,1) NOT NULL,
	[CatId] [bigint] NOT NULL,
	[CandiId] [bigint] NOT NULL,
	[SubCatTitle] [varchar](250) NOT NULL,
	[SubCatDesc] [varchar](500) NOT NULL,
	[StartedBy] [bigint] NOT NULL,
	[UpdatedBy] [bigint] NULL,
	[LastTopic] [varchar](500) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[IsApprover] [varchar](1) NOT NULL,
	[LastTopicid] [bigint] NOT NULL,
	[TotalView] [bigint] NOT NULL,
 CONSTRAINT [PK_WebsolAffi_Forums_SubCategory] PRIMARY KEY CLUSTERED 
(
	[SubCatId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WebsolAffi_Step_Test]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WebsolAffi_Step_Test](
	[QAID] [bigint] IDENTITY(1,1) NOT NULL,
	[candiid] [bigint] NOT NULL,
	[stepID] [bigint] NOT NULL,
	[Qid] [bigint] NOT NULL,
	[Ans] [varchar](500) NOT NULL,
	[AnsDate] [datetime] NOT NULL,
	[IsCorrect] [varchar](1) NOT NULL,
 CONSTRAINT [PK_WebsolAffi_Step_Test] PRIMARY KEY CLUSTERED 
(
	[QAID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WebsolAffi_RefDetails]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WebsolAffi_RefDetails](
	[eid] [bigint] IDENTITY(1,1) NOT NULL,
	[eidold] [varchar](60) NOT NULL,
	[mid] [bigint] NOT NULL,
	[earnedamt] [decimal](18, 2) NOT NULL,
	[earndate] [smalldatetime] NOT NULL,
	[source] [varchar](50) NOT NULL,
	[pstatus] [varchar](50) NOT NULL,
	[referd] [bigint] NOT NULL,
	[regdatetp] [datetime] NOT NULL,
 CONSTRAINT [PK_WebsolAffi_RefDetails_1] PRIMARY KEY CLUSTERED 
(
	[eid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[websolAffi_videoComments]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[websolAffi_videoComments](
	[cid] [bigint] IDENTITY(1,1) NOT NULL,
	[candiid] [bigint] NOT NULL,
	[videoID] [bigint] NOT NULL,
	[comments] [varchar](1000) NOT NULL,
	[commentdate] [datetime] NOT NULL,
 CONSTRAINT [PK_websolAffi_videoComments] PRIMARY KEY CLUSTERED 
(
	[cid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[Update_DatingAdsence]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Update_DatingAdsence]
@webid bigint,
@candiid bigint,
@Ads1_ad_client varchar(500)='',
@Ads2_ad_client varchar(500)='',
@Ads3_ad_client varchar(500)='',
@Ads4_ad_client varchar(500)='',
@pub_id varchar(50)=''

AS
Update DatingSite set 
Ads1_ad_client=@Ads1_ad_client,
Ads2_ad_client=@Ads2_ad_client,
Ads3_ad_client=@Ads3_ad_client,
Ads4_ad_client=@Ads4_ad_client,
pub_id=@pub_id
where webid=@webid and candiid=@candiid
GO
/****** Object:  Table [dbo].[Country]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Country](
	[COUNTRYID] [int] NOT NULL,
	[countryname] [varchar](255) NULL,
	[countrygroupid] [int] NULL,
	[countrygroupname] [varchar](max) NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[COUNTRYID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (1, N'India', 1, N'Asia')
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (2, N'Afghanistan', 1, N'Asia')
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (3, N'Albania', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (4, N'Algeria', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (5, N'American Samoa', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (6, N'Andorra', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (7, N'Angola', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (8, N'Anguilla', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (9, N'Antartica', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (10, N'Antigua and Barbuda', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (11, N'Argentina', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (12, N'Armenia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (13, N'Aruba', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (14, N'Australia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (15, N'Austria', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (16, N'Azerbaidjan', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (17, N'Bahamas', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (18, N'Bahrain', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (19, N'Bangladesh', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (20, N'Barbados', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (21, N'Belarus', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (22, N'Belgium', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (23, N'Belize', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (24, N'Benin', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (25, N'Bermuda', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (26, N'Bhutan', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (27, N'Bolivia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (28, N'Bosnia-Herzegovina', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (29, N'Botswana', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (30, N'Bouvet Island', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (31, N'Brazil', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (32, N'British Indian Ocea', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (33, N'Brunei Darussalam', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (34, N'Bulgaria', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (35, N'Burkina Faso', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (36, N'Burundi', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (37, N'Cambodia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (38, N'Cameroon', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (39, N'Canada', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (40, N'Cape Verde', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (41, N'Cayman Islands', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (42, N'Central African Rep', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (43, N'Chad', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (44, N'Chile', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (45, N'China', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (46, N'Christmas Island', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (47, N'Cocos (Keeling) Isl', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (48, N'Colombia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (49, N'Comoros', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (50, N'Congo', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (51, N'Cook Islands', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (52, N'Costa Rica', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (53, N'Croatia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (54, N'Cyprus', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (55, N'Czech Republic', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (56, N'Denmark', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (57, N'Djibouti', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (58, N'Dominica', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (59, N'Dominican Republic', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (60, N'East Timor', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (61, N'Ecuador', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (62, N'Egypt', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (63, N'El Salvador', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (64, N'Equatorial Guinea', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (65, N'Eritrea', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (66, N'Estonia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (67, N'Ethiopia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (68, N'Falkland Islands', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (69, N'Faroe Islands', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (70, N'Fiji', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (71, N'Finland', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (72, N'Former USSR', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (73, N'France', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (74, N'France (European Te', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (75, N'French Guyana', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (76, N'French Southern Ter', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (77, N'Gabon', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (78, N'Gambia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (79, N'Georgia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (80, N'Germany', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (81, N'Ghana', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (82, N'Gibraltar', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (83, N'Greece', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (84, N'Greenland', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (85, N'Grenada', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (86, N'Guadeloupe (French)', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (87, N'Guam', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (88, N'Guatemala', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (89, N'Guinea', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (90, N'Guinea Bissau', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (91, N'Guyana', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (92, N'Haiti', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (93, N'Heard and McDonald', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (94, N'Honduras', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (95, N'Hong Kong', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (96, N'Hungary', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (97, N'Iceland', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (98, N'Indonesia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (99, N'Iraq', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (100, N'Ireland', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (101, N'Israel', NULL, NULL)
GO
print 'Processed 100 total records'
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (102, N'Italy', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (103, N'Ivory Coast', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (104, N'Jamaica', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (105, N'Japan', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (106, N'Jordan', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (107, N'Kazakhstan', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (108, N'Kenya', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (109, N'Kiribati', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (110, N'Kuwait', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (111, N'Kyrgyzstan', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (112, N'Laos', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (113, N'Latvia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (114, N'Lebanon', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (115, N'Lesotho', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (116, N'Liberia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (117, N'Liechtenstein', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (118, N'Lithuania', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (119, N'Luxembourg', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (120, N'Macau', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (121, N'Macedonia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (122, N'Madagascar', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (123, N'Malawi', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (124, N'Malaysia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (125, N'Maldives', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (126, N'Mali', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (127, N'Malta', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (128, N'Marshall Islands', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (129, N'Martinique (French)', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (130, N'Mauritania', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (131, N'Mauritius', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (132, N'Mayotte', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (133, N'Mexico', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (134, N'Micronesia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (135, N'Moldavia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (136, N'Monaco', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (137, N'Mongolia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (138, N'Montserrat', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (139, N'Morocco', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (140, N'Mozambique', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (141, N'Namibia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (142, N'Nauru', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (143, N'Nepal', 1, N'Asia')
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (144, N'Netherlands', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (145, N'Netherlands Antille', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (146, N'Neutral Zone', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (147, N'New Caledonia (Fren', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (148, N'New Zealand', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (149, N'Nicaragua', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (150, N'Niger', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (151, N'Nigeria', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (152, N'Niue', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (153, N'Norfolk Island', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (154, N'Northern Mariana Is', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (155, N'Oman', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (156, N'Pakistan', 1, N'Asia')
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (157, N'Palau', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (158, N'Panama', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (159, N'Papua New Guinea', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (160, N'Paraguay', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (161, N'Peru', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (162, N'Philippines', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (163, N'Pitcairn Island', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (164, N'Poland', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (165, N'Polynesia (French)', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (166, N'Portugal', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (167, N'Qatar', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (168, N'Reunion (French)', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (169, N'Romania', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (170, N'Russian Federation', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (171, N'Rwanda', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (172, N'S. Georgia &amp; S.', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (173, N'Saint Helena', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (174, N'Saint Kitts &amp; N', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (175, N'Saint Lucia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (176, N'Saint Pierre and Mi', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (177, N'Saint Tome and Prin', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (178, N'Saint Vincent &amp;', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (179, N'Samoa', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (180, N'San Marino', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (181, N'Saudi Arabia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (182, N'Senegal', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (183, N'Seychelles', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (184, N'Sierra Leone', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (185, N'Singapore', 1, N'Asia')
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (186, N'Slovakia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (187, N'Slovenia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (188, N'Solomon Islands', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (189, N'Somalia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (190, N'South Africa', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (191, N'South Korea', 1, N'Asia')
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (192, N'Spain', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (193, N'Sri Lanka', 1, N'Asia')
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (194, N'Suriname', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (195, N'Svalbard and Jan Ma', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (196, N'Swaziland', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (197, N'Sweden', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (198, N'Switzerland', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (199, N'Tadjikistan', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (200, N'Taiwan', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (201, N'Tanzania', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (202, N'Thailand', 1, N'Asia')
GO
print 'Processed 200 total records'
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (203, N'Togo', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (204, N'Tokelau', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (205, N'Tonga', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (206, N'Trinidad and Tobago', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (207, N'Tunisia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (208, N'Turkey', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (209, N'Turkmenistan', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (210, N'Turks and Caicos Is', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (211, N'Tuvalu', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (212, N'Uganda', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (213, N'UK', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (214, N'Ukraine', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (215, N'United Arab Emirate', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (216, N'Uruguay', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (217, N'United States', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (218, N'US Minor Outlying I', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (219, N'Uzbekistan', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (220, N'Vanuatu', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (221, N'Vatican City', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (222, N'Venezuela', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (223, N'Vietnam', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (224, N'Virgin Islands (Bri', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (225, N'Virgin Islands (US)', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (226, N'Wallis and Futuna I', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (227, N'Western Sahara', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (228, N'Yemen', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (229, N'Yugoslavia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (230, N'Zaire', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (231, N'Zambia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (232, N'Zimbabwe', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (233, N'Singapore', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (234, N'Saudi Arabia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (235, N'Oman', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (236, N'Singapore', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (237, N'Thailand', 1, N'Asia')
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (238, N'Indonesia', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (239, N'China', 1, N'Asia')
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (240, N'Pakistan', 1, N'Asia')
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (241, N'Italy', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (242, N'Bangladesh', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (243, N'Nepal', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (244, N'Srilanka', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (245, N'Work From home', NULL, NULL)
INSERT [dbo].[Country] ([COUNTRYID], [countryname], [countrygroupid], [countrygroupname]) VALUES (246, N'Qatar', NULL, NULL)
/****** Object:  Table [dbo].[Contact_History]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Contact_History](
	[ContactID] [bigint] IDENTITY(1,1) NOT NULL,
	[candiid] [bigint] NOT NULL,
	[Contacted] [bigint] NOT NULL,
	[ContactON] [datetime] NOT NULL,
	[User_Message] [varchar](500) NOT NULL,
	[MailSend] [varchar](1) NOT NULL,
 CONSTRAINT [PK_Contact_History] PRIMARY KEY CLUSTERED 
(
	[ContactID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[EditDatingSite]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[EditDatingSite]
@webid bigint,
@candiid bigint,
@WebTitle varchar(250),
@WebsitePunchline varchar(200)
--,@Ads1 varchar(100)='',
--@Ads1_Slot varchar(50)='',
--@Ads2 varchar(100)='',
--@Ads2_Slot varchar(50)='',
--@Ads3 varchar(100)='',
--@Ads3_Slot varchar(50)=''

AS

update [datingSite] set 
			[WebsiteTitle]=@WebTitle
           ,[WebsitePunchline]=@WebsitePunchline
           --,[Ads1_ad_client]=@Ads1
           --,[Ads1_Slot]=@Ads1_Slot
           --,[Ads2_ad_client]=@Ads2
           --,[Ads2_Slot]=@Ads2_Slot
           --,[Ads3_ad_client]=@Ads3
           --,[Ads3_Slot]=@Ads3_Slot
           
           where candiid = @candiid and webid = @webid
GO
/****** Object:  StoredProcedure [dbo].[addDownlodDetails]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[addDownlodDetails]
@candiid bigint,
@filename	varchar(100) = '',
@ipaddress varchar(15)=''
as
INSERT INTO [downloadDetails]
           ([candiid]
           ,[filename]
           ,[ipaddress]
           )
     VALUES
           (@candiid
           ,@filename
           ,@ipaddress
           )
GO
/****** Object:  StoredProcedure [dbo].[AddDatingSite]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddDatingSite]
@candiid bigint,
@WebsiteUrl varchar(250),
@WebsiteTitle varchar(250),
@WebsitePunchline varchar(200),
@Ads1 varchar(500)='',
@Ads2 varchar(500)='',
@Ads3 varchar(500)=''
AS
if Not Exists(Select * from datingSite where websiteurl=@websiteUrl)
BEGIN
INSERT INTO [datingSite]
           ([WebsiteUrl]
           ,[WebsiteTitle]
           ,[WebsitePunchline]
           ,[Ads1_ad_client]
           
           ,[Ads2_ad_client]
           
           ,[Ads3_ad_client]
           
           ,[candiid])
     VALUES
           (@WebsiteUrl, 
@WebsiteTitle, 
@WebsitePunchline,
@Ads1, 

@Ads2, 

@Ads3,

@candiid ) Select @@IDENTITY
END
	else
		select 0 as 'Fail'
GO
/****** Object:  Table [dbo].[alert]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[alert](
	[searchno] [bigint] IDENTITY(1,1) NOT NULL,
	[candiid] [varchar](60) NOT NULL,
	[query] [varchar](max) NOT NULL,
	[queryname] [varchar](250) NOT NULL,
	[email] [varchar](250) NOT NULL,
	[verified] [varchar](1) NOT NULL,
	[fireddate] [smalldatetime] NOT NULL,
	[jointype] [varchar](60) NOT NULL,
 CONSTRAINT [alert_PrimaryKey] PRIMARY KEY CLUSTERED 
(
	[searchno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Cast_List]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cast_List](
	[castID] [bigint] IDENTITY(1,1) NOT NULL,
	[Cast_N] [varchar](50) NOT NULL,
	[Rel] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Cast_List] PRIMARY KEY CLUSTERED 
(
	[castID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Cast_List] ON
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (1, N'Ad Dharmi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (2, N'Adi Andhra', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (3, N'Adi Dravida', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (4, N'Adi Karnataka', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (5, N'Agamudayar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (6, N'Aggarwal', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (7, N'Agri', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (8, N'Ahir', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (9, N'Ahom', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (10, N'Ambalavasi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (11, N'Arora', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (12, N'Arunthathiyar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (13, N'Arya Vysya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (14, N'Baghel/Pal/Gaderiya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (15, N'Baidya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (16, N'Baishnab', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (17, N'Baishya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (18, N'Balija', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (19, N'Balija Naidu', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (20, N'Bania', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (21, N'Banik', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (22, N'Banjara', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (23, N'Bari', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (24, N'Barujibi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (25, N'Besta', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (26, N'Bhandari', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (27, N'Bhatia', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (28, N'Bhatraju', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (29, N'Bhavsar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (30, N'Bhovi/Bhoi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (31, N'Billava', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (32, N'Bishnoi/Vishnoi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (33, N'Boyer', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (34, N'Brahmbatt', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (35, N'Brahmin', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (36, N'Brahmin 6000 Niyogi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (37, N'Brahmin Anavil', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (38, N'Brahmin Audichya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (39, N'Brahmin Bajkhedwal', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (40, N'Brahmin Barendra', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (41, N'Brahmin Bhargava', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (42, N'Brahmin Bhatt', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (43, N'Brahmin Bhumihar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (44, N'Brahmin Brahacharanam', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (45, N'Brahmin Daivadnya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (46, N'Brahmin Deshastha', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (47, N'Brahmin Dhiman', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (48, N'Brahmin Dravida', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (49, N'Brahmin Dunua', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (50, N'Brahmin Garhwali', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (51, N'Brahmin Gaud Saraswat (GSB)', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (52, N'Brahmin Gaur', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (53, N'Brahmin Goswami', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (54, N'Brahmin Gujar Gaur', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (55, N'Brahmin Gurukkal', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (56, N'Brahmin Halua', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (57, N'Brahmin Havyaka', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (58, N'Brahmin Hoysala', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (59, N'Brahmin Iyengar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (60, N'Brahmin Iyer', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (61, N'Brahmin Jangid', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (62, N'Brahmin Jangra', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (63, N'Brahmin Jhadua', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (64, N'Brahmin Jhijhotiya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (65, N'Brahmin Jogi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (66, N'Brahmin Kanyakubj', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (67, N'Brahmin Karhade', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (68, N'Brahmin Kashmiri Pandit', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (69, N'Brahmin Koknastha', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (70, N'Brahmin Kota', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (71, N'Brahmin Kulin', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (72, N'Brahmin Kumaoni', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (73, N'Brahmin Madhwa', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (74, N'Brahmin Maithil', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (75, N'Brahmin Modh', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (76, N'Brahmin Mohyal', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (77, N'Brahmin Nagar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (78, N'Brahmin Namboodiri', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (79, N'Brahmin Narmadiya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (80, N'Brahmin Panda', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (81, N'Brahmin Pandit', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (82, N'Brahmin Pareek', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (83, N'Brahmin Pushkarna', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (84, N'Brahmin Rarhi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (85, N'Brahmin Rigvedi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (86, N'Brahmin Rudraj', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (87, N'Brahmin Sakaldwipi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (88, N'Brahmin Sanadya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (89, N'Brahmin Sanketi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (90, N'Brahmin Saraswat', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (91, N'Brahmin Saryuparin', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (92, N'Brahmin Shivalli', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (93, N'Brahmin Shrimali', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (94, N'Brahmin Smartha', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (95, N'Brahmin Sri Vishnava', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (96, N'Brahmin Tyagi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (97, N'Brahmin Vaidiki', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (98, N'Brahmin Viswa', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (99, N'Brahmin Vyas', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (100, N'Brahmin Yajurvedi', N'Hindu')
GO
print 'Processed 100 total records'
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (101, N'Brahmo', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (102, N'Bunt/Shetty', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (103, N'Chamar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (104, N'Chambhar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (105, N'Chandravanshi Kahar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (106, N'Chasa', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (107, N'Chattada Sri Vaishnava', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (108, N'Chaudary', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (109, N'Chaurasia', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (110, N'Chettiar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (111, N'Chhetri', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (112, N'CKP', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (113, N'Coorgi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (114, N'Deshastha Maratha', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (115, N'Devadigas', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (116, N'Devang Koshthi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (117, N'Devanga', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (118, N'Devendra Kula Vellalar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (119, N'Dhangar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (120, N'Dheevara', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (121, N'Dhoba', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (122, N'Dhobi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (123, N'Dusadh', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (124, N'Edigas', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (125, N'Ezhava', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (126, N'Ezhuthachan', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (127, N'Gabit', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (128, N'Ganiga', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (129, N'Garhwali', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (130, N'Gavali', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (131, N'Gavara', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (132, N'Ghumar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (133, N'Goala', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (134, N'Goan', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (135, N'Gomantak Maratha', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (136, N'Gondhali', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (137, N'Goud', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (138, N'Gounder', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (139, N'Gowda', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (140, N'Gramani', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (141, N'Gudia', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (142, N'Gujjar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (143, N'Gupta', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (144, N'Gurav', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (145, N'Gurjar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (146, N'Hegde', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (147, N'Jaiswal', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (148, N'Jangam', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (149, N'Jat', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (150, N'Jatav', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (151, N'Kadava patel', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (152, N'Kahar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (153, N'Kaibarta', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (154, N'Kalal', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (155, N'Kalar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (156, N'Kalinga Vysya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (157, N'Kalwar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (158, N'Kamboj', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (159, N'Kamma', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (160, N'Kansari', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (161, N'Kapol', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (162, N'Kapu', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (163, N'Kapu Munnuru', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (164, N'Karana', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (165, N'Karmakar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (166, N'Karuneegar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (167, N'Kasar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (168, N'Kashyap', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (169, N'Kayastha', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (170, N'Khandayat', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (171, N'Khandelwal', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (172, N'Kharwar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (173, N'Khatik', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (174, N'Khatri', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (175, N'Kokanastha Maratha', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (176, N'Koli', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (177, N'Koli Mahadev', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (178, N'Kongu Vellala Gounder', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (179, N'Konkani', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (180, N'Kori', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (181, N'Koshti', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (182, N'Kshatriya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (183, N'Kshatriya Agnikula', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (184, N'Kudumbi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (185, N'Kulalar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (186, N'Kulita', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (187, N'Kumawat', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (188, N'Kumbhakar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (189, N'Kumhar/Kumbhar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (190, N'Kummari', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (191, N'Kunbi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (192, N'Kurmi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (193, N'Kurmi kshatriya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (194, N'Kuruba', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (195, N'Kuruhina shetty', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (196, N'Kurumbar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (197, N'Kushwaha', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (198, N'Kutchi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (199, N'Kutchi Gurjar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (200, N'Lambadi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (201, N'Leva Patidar', N'Hindu')
GO
print 'Processed 200 total records'
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (202, N'Leva Patil', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (203, N'Lingayat', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (204, N'Lodhi Rajput', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (205, N'Lohana', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (206, N'Lohar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (207, N'Lubana', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (208, N'Madiga', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (209, N'Mahajan', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (210, N'Mahar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (211, N'Maheshwari', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (212, N'Mahindra', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (213, N'Mahisya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (214, N'Majabi/Mazhbi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (215, N'Mala', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (216, N'Mali', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (217, N'Mallah', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (218, N'Manipuri', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (219, N'Mapila', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (220, N'Maratha', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (221, N'Maravar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (222, N'Maruthuvar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (223, N'Marwari', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (224, N'Matang', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (225, N'Mathur', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (226, N'Maurya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (227, N'Meena ', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (228, N'Meenavar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (229, N'Mehra', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (230, N'Menon', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (231, N'Meru', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (232, N'Meru darji', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (233, N'Modak', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (234, N'Mogaveera', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (235, N'Monchi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (236, N'Motati Reddy', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (237, N'Mudaliar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (238, N'Mudaliar Arcot', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (239, N'Mudiraj', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (240, N'Muthuraja', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (241, N'Nadar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (242, N'Naicker', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (243, N'Naidu', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (244, N'Naik/Nayak/Nayaka', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (245, N'Nair', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (246, N'Nair Veluthedathu', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (247, N'Nair Vilakkithala', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (248, N'Namasudra/Namosudra', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (249, N'Nambiar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (250, N'Namboodiri', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (251, N'Napit', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (252, N'Nayee (Barber)', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (253, N'Nepali', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (254, N'Nhavi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (255, N'OBC', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (256, N'Oswal', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (257, N'Padmashali', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (258, N'Pal', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (259, N'Panchal', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (260, N'Panchamsali', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (261, N'Pandaram', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (262, N'Panicker', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (263, N'Parkava Kulam', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (264, N'Pasi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (265, N'Patel', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (266, N'Patel Dodia', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (267, N'Patel Kadva', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (268, N'Patel Leva', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (269, N'Patil', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (270, N'Patnaick', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (271, N'Patra', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (272, N'Perika', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (273, N'Pillai', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (274, N'Prajapati', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (275, N'Raigar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (276, N'Rajaka', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (277, N'Rajbhar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (278, N'Rajbonshi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (279, N'Rajput', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (280, N'Rajput Garhwali', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (281, N'Rajput Kumaoni', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (282, N'Rajput Negi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (283, N'Rajput Rohella/Tank', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (284, N'Ramdasia', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (285, N'Ramgarhia', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (286, N'Ravidasia', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (287, N'Rawat', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (288, N'Reddy', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (289, N'Sadgope', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (290, N'Saha', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (291, N'Sahu', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (292, N'Saini', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (293, N'Saliya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (294, N'Scheduled Caste', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (295, N'Scheduled Tribe', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (296, N'Senai Thalaivar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (297, N'Senguntha Mudaliyar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (298, N'Settibalija', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (299, N'Shah', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (300, N'Shimpi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (301, N'Sindhi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (302, N'Sindhi Amil', N'Hindu')
GO
print 'Processed 300 total records'
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (303, N'Sindhi Baibhand', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (304, N'Sindhi Bhatia', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (305, N'Sindhi Larai', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (306, N'Sindhi Larkana', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (307, N'Sindhi Rohiri', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (308, N'Sindhi Sahiti', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (309, N'Sindhi Sakkhar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (310, N'Sindhi Shikarpuri', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (311, N'SKP', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (312, N'Somvanshi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (313, N'Somvanshi Kayastha Prabhu', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (314, N'Sonar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (315, N'Soni', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (316, N'Sood', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (317, N'Sourashtra', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (318, N'Sozhiya Vellalar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (319, N'Srisayani', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (320, N'SSK', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (321, N'Subarna Banik', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (322, N'Sundhi', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (323, N'Sutar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (324, N'Swakula sali', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (325, N'Swarnkar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (326, N'Tamboli', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (327, N'Tanti', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (328, N'Tantuway', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (329, N'Telaga', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (330, N'Teli', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (331, N'Thakkar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (332, N'Thakur', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (333, N'Thevar/Mukkulathor', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (334, N'Thigala', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (335, N'Thiyya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (336, N'Tili', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (337, N'Togata', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (338, N'Tonk Kshatriya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (339, N'Tribe', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (340, N'Turupu Kapu', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (341, N'Uppara', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (342, N'Vaddera', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (343, N'Vaidiki Velanadu', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (344, N'Vaish', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (345, N'Vaishnav', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (346, N'Vaishnav Vanik', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (347, N'Vaishnava', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (348, N'Vaishya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (349, N'Vaishya Vani', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (350, N'Valluvar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (351, N'Valmiki', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (352, N'Vania', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (353, N'Vaniya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (354, N'Vanjari', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (355, N'Vankar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (356, N'Vannar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (357, N'Vannia Kula Kshatriyar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (358, N'Vanniyar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (359, N'Varshney', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (360, N'Veershaiva/Veera Saivam', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (361, N'Velama', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (362, N'Velan', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (363, N'Vellalar', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (364, N'Vettuva Gounder', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (365, N'Vishwakarma', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (366, N'Vokkaliga', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (367, N'Vysya', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (368, N'Yadav/Yadava', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (369, N'Shia', N'Muslim')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (370, N'Sunni', N'Muslim')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (371, N'Arora', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (372, N'Bhatia', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (373, N'Gursikh', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (374, N'Jat', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (375, N'Kamboj', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (376, N'Kesadhari', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (377, N'Khashap Rajpoot', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (378, N'Khatri', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (379, N'Labana', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (380, N'Mazhbi', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (381, N'Rajput', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (382, N'Ramdasia', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (383, N'Ramgarhia', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (384, N'Saini', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (385, N'Anglo Indian', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (386, N'Born Again', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (387, N'Brethren', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (388, N'Catholic', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (389, N'Catholic - Knanaya', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (390, N'Catholic - Latin', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (391, N'Catholic - Malankara', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (392, N'Catholic - Roman', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (393, N'Catholic - Syrian', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (394, N'Chaldean', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (395, N'CMS', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (396, N'CSI', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (397, N'Evangelical', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (398, N'Indian Orthodox', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (399, N'Jacobite', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (400, N'Jacobite - Knanaya', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (401, N'Jacobite - Syrian', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (402, N'Knanaya', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (403, N'Mangalorean', N'Christian')
GO
print 'Processed 400 total records'
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (404, N'Manglorean', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (405, N'Marthomite', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (406, N'Nadar', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (407, N'Pentecost', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (408, N'Protestant', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (409, N'Syrian', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (410, N'Syrian - Malabar', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (411, N'Syrian - Orthodox', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (412, N'Syro - Malabar', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (413, N'Digamber', N'Jain')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (414, N'Shwetamber', N'Jain')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (415, N'Other', N'Hindu')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (416, N'Other', N'Christian')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (417, N'Other', N'Muslim')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (418, N'Other', N'Jain')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (419, N'Other', N'Sikh')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (420, N'Other', N'Jew')
INSERT [dbo].[Cast_List] ([castID], [Cast_N], [Rel]) VALUES (421, N'Other', N'Other')
SET IDENTITY_INSERT [dbo].[Cast_List] OFF
/****** Object:  Table [dbo].[candiReg]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[candiReg](
	[candiid] [bigint] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](250) NOT NULL,
	[LastName] [varchar](250) NOT NULL,
	[EmailID] [varchar](250) NOT NULL,
	[Passw] [varchar](50) NOT NULL,
	[MobileNo] [varchar](12) NOT NULL,
	[cityName] [varchar](50) NOT NULL,
	[StateName] [varchar](50) NOT NULL,
	[Country] [varchar](50) NOT NULL,
	[IsActive] [varchar](1) NOT NULL,
	[IsApproved] [varchar](1) NOT NULL,
	[RegDate] [datetime] NOT NULL,
	[LastLogin] [datetime] NOT NULL,
	[mrol] [varchar](50) NOT NULL,
	[address] [varchar](1000) NOT NULL,
	[cityid] [bigint] NOT NULL,
	[COUNTRYID] [bigint] NOT NULL,
	[stateid] [bigint] NOT NULL,
	[photo] [varchar](150) NOT NULL,
	[photopassw] [varchar](60) NOT NULL,
	[refby] [bigint] NOT NULL,
	[refer2] [bigint] NOT NULL,
	[ref1val] [decimal](18, 2) NOT NULL,
	[ref2val] [decimal](18, 2) NOT NULL,
	[RefUrl] [varchar](500) NOT NULL,
	[ipaddress] [varchar](15) NOT NULL,
	[websiteUrl] [varchar](500) NOT NULL,
	[issuspended] [varchar](1) NOT NULL,
	[LastPayDate] [date] NULL,
	[NextPayDate] [date] NULL,
 CONSTRAINT [PK_candiReg] PRIMARY KEY CLUSTERED 
(
	[candiid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[blacklisted]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[blacklisted](
	[pid] [bigint] NOT NULL,
	[memberidblocked] [bigint] NOT NULL,
	[fname] [varchar](250) NOT NULL,
	[lname] [varchar](250) NOT NULL,
	[upddate] [smalldatetime] NOT NULL,
 CONSTRAINT [pkblacklisted] PRIMARY KEY CLUSTERED 
(
	[pid] ASC,
	[memberidblocked] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[getMsg]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[getMsg]
@criteria varchar(Max)='',
@setOrder varchar(Max) = ''
as
Declare @sqlst as varchar(max)

select @sqlst='
SELECT   * from
(
select TOP 100 PERCENT msgid,
(select fname from [profile]
 where Profile.pid = sm.msgfromid)as msgFrom ,
 msgfromid,
 (select fname from [profile]
 where Profile.pid = sm.msgtoid)as msgTo, msgtoid, msg,
 (select COUNT(msgfromid)as totalmails from send_msg nm where nm.msgfromid= sm.msgfromid)as totalmails 
 ,msgdate 
 from [send_msg] sm WITH (NOLOCK) where '+@criteria +' 
 
) as kk' 
 print @setOrder
EXEC(@sqlst + ' ' + @setOrder) 
 
 --exec getMsg 'aproveSender = ''N''  and  CONVERT(VARCHAR(10),msgdate,110) = CONVERT(VARCHAR(10),GETDATE(),110) and (select gender from Profile where Profile.pid = send_msg.msgfromid) = ''F'''
 --exec getMsg 'aproveSender = ''Y''',' order by msgdate desc' --
 --select  msgdate,msgfromid  from send_msg  where aproveSender = 'N' and CONVERT(VARCHAR(10),msgdate,110) = CONVERT(VARCHAR(10),GETDATE(),110) and (select gender from Profile where Profile.pid = send_msg.msgfromid) = 'F' order by msgdate desc 
 
--select msgtoid,msgdate,msgfromid, msg from send_msg WITH (NOLOCK) group by msgtoid,msgdate,msgfromid , msg  order by msgdate desc
GO
/****** Object:  StoredProcedure [dbo].[jeevansathimails]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[jeevansathimails]
as
select  email,fname,jid from jeevansathiids where -- email like '%aminnagpure%' 
 emsent=0
--order by inviteid desc
GO
/****** Object:  Table [dbo].[invalidemails]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[invalidemails](
	[emailid] [int] IDENTITY(1,1) NOT NULL,
	[email] [varchar](250) NOT NULL,
	[inviteid] [bigint] NOT NULL,
 CONSTRAINT [PK_invalidemails] PRIMARY KEY CLUSTERED 
(
	[emailid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[invites]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[invites](
	[inviteid] [bigint] IDENTITY(1,1) NOT NULL,
	[candiid] [varchar](60) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[fname] [varchar](150) NOT NULL,
	[lname] [varchar](150) NOT NULL,
	[isdeleted] [varchar](1) NOT NULL,
	[sendersemail] [varchar](250) NOT NULL,
	[invitesent] [int] NOT NULL,
	[lovenmarry] [varchar](1) NOT NULL,
	[ischecked] [varchar](1) NOT NULL,
	[isvalidemail] [varchar](1) NOT NULL,
	[isblacklisted] [varchar](1) NOT NULL,
	[exported] [varchar](1) NOT NULL,
	[converted] [varchar](1) NOT NULL,
	[lovenmarrysent] [int] NOT NULL,
	[isbouncing] [int] NOT NULL,
	[membercontact] [int] NOT NULL,
	[bhavna] [int] NOT NULL,
	[tanysent] [int] NOT NULL,
	[reshma] [int] NOT NULL,
	[kavita] [int] NOT NULL,
	[mohini] [int] NOT NULL,
	[sachin] [int] NOT NULL,
	[aditi] [int] NOT NULL,
 CONSTRAINT [PK_invites] PRIMARY KEY CLUSTERED 
(
	[inviteid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[get_SiteDetails]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[get_SiteDetails]
@webid bigint
AS
Select * from DatingSite where webid=@webid
GO
/****** Object:  StoredProcedure [dbo].[Get_MyWebsitesDetails]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Get_MyWebsitesDetails] 
@candiid bigint, 
@webid bigint

AS

SELECT * FROM [DatingSite]
Where webid=@webid
GO
/****** Object:  StoredProcedure [dbo].[Get_MyWebsites]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Get_MyWebsites] @candiid bigint
AS
SELECT * FROM DatingSite where candiid=@candiid
GO
/****** Object:  Table [dbo].[forumqandA]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[forumqandA](
	[forumqnaid] [bigint] IDENTITY(1,1) NOT NULL,
	[forumtopid] [bigint] NOT NULL,
	[question] [nvarchar](500) NOT NULL,
	[questdesc] [nvarchar](max) NOT NULL,
	[startedby] [varchar](250) NOT NULL,
	[starteddate] [smalldatetime] NOT NULL,
	[updatedby] [varchar](250) NOT NULL,
	[updateddate] [smalldatetime] NOT NULL,
	[isapprove] [varchar](1) NULL,
	[startedbyid] [bigint] NULL,
	[updatebyid] [bigint] NOT NULL,
 CONSTRAINT [PK_forumqandA] PRIMARY KEY CLUSTERED 
(
	[forumqnaid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[viewSiteDetails]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[viewSiteDetails]
@candiid bigint
as

SELECT  [downlodId]
      ,[candiid]
      ,[filename]
      ,[ipaddress]
      ,[downloadDate]
  FROM [downloadDetails] where candiid = @candiid
  
  SELECT [candiid]
      ,[FtpHostName]
      ,[Ftpusername]
      ,[FtpPassword]
      ,[createDate]
      ,[FtpDetailsID]
  FROM [FtpDetail] where candiid = @candiid
GO
/****** Object:  StoredProcedure [dbo].[EditFtpDetails]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[EditFtpDetails]
@candiid bigint,
@FtpDetailsID bigint,
@FtpHostName varchar(500)='',
@Ftpusername varchar(100) = '',
@FtpPassword varchar(50) = ''

as
update FtpDetail set 
FtpHostName = @FtpHostName , 
Ftpusername = @Ftpusername , 
FtpPassword = @FtpPassword 

where 

candiid = @candiid 
And 
FtpDetailsID = @FtpDetailsID
GO
/****** Object:  Table [dbo].[forumtopics]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[forumtopics](
	[forumtopid] [int] IDENTITY(1,1) NOT NULL,
	[forumtitle] [varchar](250) NOT NULL,
	[lastupdate] [smalldatetime] NOT NULL,
	[updatedby] [varchar](250) NOT NULL,
	[startedby] [varchar](250) NOT NULL,
	[forumcatid] [int] NOT NULL,
	[topicsdescription] [varchar](500) NOT NULL,
	[latesttopic] [varchar](500) NOT NULL,
	[latesttopicid] [bigint] NOT NULL,
	[isSusp] [varchar](1) NULL,
	[isApproved] [varchar](1) NULL,
	[updatebyid] [bigint] NULL,
	[startedbyid] [bigint] NULL,
 CONSTRAINT [PK_forumtopics] PRIMARY KEY CLUSTERED 
(
	[forumtopid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[forumcategory]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[forumcategory](
	[forumcatid] [int] IDENTITY(1,1) NOT NULL,
	[forumcategoryn] [varchar](500) NOT NULL,
	[descrip] [varchar](500) NOT NULL,
 CONSTRAINT [PK_forumcategory] PRIMARY KEY CLUSTERED 
(
	[forumcatid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[favorities]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[favorities](
	[pid] [bigint] NOT NULL,
	[memberidfav] [bigint] NOT NULL,
	[fname] [varchar](250) NOT NULL,
 CONSTRAINT [pkfavorities] PRIMARY KEY CLUSTERED 
(
	[pid] ASC,
	[memberidfav] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[photo]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[photo](
	[photoid] [bigint] IDENTITY(1,1) NOT NULL,
	[photoname] [varchar](50) NOT NULL,
	[photopath] [varchar](100) NOT NULL,
	[pid] [bigint] NOT NULL,
	[active] [varchar](1) NOT NULL,
	[datasize] [varchar](50) NOT NULL,
	[passw] [varchar](50) NOT NULL,
	[uploaddate] [smalldatetime] NOT NULL,
	[mainphoto] [varchar](1) NOT NULL,
	[isimported] [varchar](1) NOT NULL,
	[email] [varchar](250) NOT NULL,
 CONSTRAINT [PK_photo] PRIMARY KEY CLUSTERED 
(
	[photoid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[paymentApproved]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[paymentApproved](
	[pid] [varchar](60) NOT NULL,
	[amtapproved] [money] NOT NULL,
	[approvaldate] [smalldatetime] NOT NULL,
	[paymentnumber] [varchar](60) NOT NULL,
	[paymentdate] [smalldatetime] NOT NULL,
	[payid] [varchar](60) NOT NULL,
	[amtpaid] [money] NOT NULL,
	[actualpaymentdate] [varchar](150) NOT NULL,
 CONSTRAINT [pkpaymentapproved] PRIMARY KEY CLUSTERED 
(
	[payid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[passwordrequests]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[passwordrequests](
	[requestid] [bigint] IDENTITY(1,1) NOT NULL,
	[frompid] [bigint] NOT NULL,
	[topid] [bigint] NOT NULL,
	[fromemail] [varchar](250) NOT NULL,
	[fname] [varchar](250) NOT NULL,
	[lname] [varchar](250) NOT NULL,
 CONSTRAINT [pkpasswordrequest] PRIMARY KEY CLUSTERED 
(
	[requestid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[partnersearch]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[partnersearch] --0,1100,' inner join ', '1=1'
@startRowIndex int,
@maximumRows int,
@jointype varchar(60),
@criteria varchar(max)
as

Declare @sqlst as varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;

select @sqlst='select * from (
select   ROW_NUMBER() OVER(ORDER BY profiledate DESC) AS rowid ,profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,passw 
from profile  where  ' + @criteria + ' ) as kk'
EXEC(@sqlst + ' where rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxRow + ')')
GO
/****** Object:  Table [dbo].[Partner_Payment]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Partner_Payment](
	[TransID] [bigint] IDENTITY(1,1) NOT NULL,
	[candiid] [bigint] NOT NULL,
	[amount] [money] NOT NULL,
	[TransSummary] [varchar](250) NOT NULL,
	[TransDate] [datetime] NOT NULL,
	[CurrentBalance] [money] NOT NULL,
	[NextPayDate] [date] NOT NULL,
	[P_version] [varchar](50) NOT NULL,
	[P_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Partner_Payment] PRIMARY KEY CLUSTERED 
(
	[TransID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OnlinePoleTest_Master]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OnlinePoleTest_Master](
	[SNo] [int] IDENTITY(1,1) NOT NULL,
	[poleId] [varchar](10) NOT NULL,
	[QueId] [bigint] NOT NULL,
	[QueDesc] [varchar](200) NOT NULL,
	[poleAns] [varchar](200) NOT NULL,
	[polecomment] [varchar](250) NOT NULL,
	[TotalScore] [varchar](50) NOT NULL,
	[UserScore] [varchar](50) NOT NULL,
	[CreationLogInId] [bigint] NOT NULL,
	[CreationDate] [varchar](50) NOT NULL,
	[isapprove] [varchar](1) NOT NULL,
 CONSTRAINT [PK_OnlinePoleTest_Master] PRIMARY KEY CLUSTERED 
(
	[SNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[newspaging]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[newspaging]
@startRowIndex int,
@maximumRows int,
@criteria varchar(max)
as

Declare @sqlst as varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;

select @sqlst='select * from (Select newsid,newsheadline,newscontent, convert(varchar(10),newsdate,103) as [newsdate], 
 rOW_NUMBER() OVER(ORDER BY newsdate DESC) AS rowid  from news where ' + @criteria + ' ) as kk'

EXEC(@sqlst + ' where rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxRow+')')
GO
/****** Object:  Table [dbo].[newscomments]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[newscomments](
	[ncommentid] [bigint] IDENTITY(1,1) NOT NULL,
	[candiid] [bigint] NOT NULL,
	[fname] [varchar](250) NOT NULL,
	[comment] [varchar](1000) NOT NULL,
	[commentdate] [smalldatetime] NOT NULL,
	[approved] [varchar](1) NOT NULL,
	[newsid] [bigint] NOT NULL,
 CONSTRAINT [PK_newscomments] PRIMARY KEY CLUSTERED 
(
	[ncommentid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[news]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[news](
	[newsid] [bigint] IDENTITY(1,1) NOT NULL,
	[newsheadline] [varchar](250) NOT NULL,
	[newscat] [int] NOT NULL,
	[newscontent] [varchar](max) NOT NULL,
	[newsdate] [smalldatetime] NOT NULL,
	[website] [varchar](250) NOT NULL,
	[pid] [bigint] NOT NULL,
 CONSTRAINT [PK_news] PRIMARY KEY CLUSTERED 
(
	[newsid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[pole_Que_CreateMaster]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[pole_Que_CreateMaster](
	[Sno] [int] IDENTITY(1,1) NOT NULL,
	[QuestionId] [varchar](10) NOT NULL,
	[QsnDesc] [varchar](4000) NOT NULL,
	[NoOfOptions] [varchar](50) NOT NULL,
	[CorrectOption] [varchar](50) NOT NULL,
	[Marks] [varchar](50) NOT NULL,
	[CreationloginId] [bigint] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[IsApprove] [varchar](1) NOT NULL,
 CONSTRAINT [PK_pole_Que_CreateMaster] PRIMARY KEY CLUSTERED 
(
	[Sno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[pole_Que_CreateDetail]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[pole_Que_CreateDetail](
	[Sno] [int] IDENTITY(1,1) NOT NULL,
	[QuestionId] [bigint] NOT NULL,
	[OptionOrder] [int] NOT NULL,
	[OptionValue] [varchar](500) NOT NULL,
	[CreationloginId] [varchar](50) NULL,
	[CreationDate] [datetime] NULL,
 CONSTRAINT [PK_pole_Que_CreateDetail] PRIMARY KEY CLUSTERED 
(
	[Sno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[AddPoints]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[AddPoints]
@candiid bigint,
@points bigint,
@Action varchar(50)=''
AS
if Exists(Select * from Points_Summary Where candiid=@candiid)
BEGIN
Update Points_Summary set TotalEarnedPoints=TotalEarnedPoints+@points, PendingPoints=PendingPoints+@points Where candiid=@candiid
END
ELSE

INSERT INTO [Points_Summary]
           ([candiid]
           ,[TotalEarnedPoints]
           ,[PendingPoints]
           ,[ApprovedPoints]
           ,[RedimPoints]
           ,[BalancePoints]
           ,[PendingToRedim])
     VALUES
           (@candiid
           ,@points
           ,@points
           ,0
           ,0
           ,0
           ,0)
GO
/****** Object:  StoredProcedure [dbo].[memsearchcount]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[memsearchcount]
@criteria as varchar(max)
as
Declare @sqlst as varchar(max)


select @sqlst='select count(*) from candireg where ' + @criteria

EXEC(@sqlst)
GO
/****** Object:  StoredProcedure [dbo].[memsearch]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[memsearch]
@startRowIndex int,
@maximumRows int,
@criteria varchar(max)
as
Declare @sqlst as varchar(max),@MaxR bigint
Set @MaxR = @startRowIndex + @maximumRows
select @sqlst='
SELECT   * from
(
select  isnull((Select SUM(earnedamt) from Twinkletopearners tp where tp.candiid=mm.candiid ),0) as sm,mm.*,
isnull((Select firstname from candiReg mmm where mm.refby=mmm.candiid),'''') as RefByName1,
isnull((Select firstname from candiReg mmm where mm.refer2=mmm.candiid),'''') as RefByName2,
(Select COUNT(*) from candiReg mmm where mmm.refby=mm.candiid) as DirectRef,
(Select COUNT(*) from candiReg mmm where mmm.refer2=mm.candiid) as InDirectRef,
 ROW_NUMBER() OVER(ORDER BY regdate DESC) AS rowid 

FROM  candiReg mm WHERE '+@criteria +'
) as kk' 
--
--) as kk'
--group by email,passw,mm.mid,fname,lname,gender,regdate,photo,dob,aboutme,purpose,ipaddress,mobile,isvalidmobile
--Print (@sqlst + ' where rowid > ('+ Convert(Varchar(50),(Convert(float,@startRowIndex))) +') AND rowid <= ('+ Convert(Varchar(50),(Convert(float,@startRowIndex) + Convert(float,@maximumRows))) +')')
EXEC(@sqlst + ' where rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxR +')')
 
 --memsearch 0, 12,'1=1'
GO
/****** Object:  StoredProcedure [dbo].[members_waitingForResponse]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[members_waitingForResponse] --0,1100,' inner join ', '1=1'
@startRowIndex int,
@maximumRows int,
@criteria varchar(max),
@candiid bigint
as

Declare @sqlst as varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;

select @sqlst='WITH Waiting_For_resp(
select   ROW_NUMBER() OVER(ORDER BY profiledate DESC) AS rowid ,profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,passw ,
(Select InterestFor from User_Interest where User_Interest.IntrestedIn=profile.pid and User_Interest.candiid = ' + convert(varchar,@candiid) + ') AS InterestFor
from profile  where  ' + @criteria + ' )
select *,(Select MAX(Rowid) from Waiting_For_resp) as Total from Waiting_For_resp
'
EXEC(@sqlst + ' where rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxRow + ')')
GO
/****** Object:  StoredProcedure [dbo].[Members_waiting]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Members_waiting] --waitingmembers 0,1100,' inner join ', ' profile.pid in(Select distinct candiid from User_Interest WHere IntrestedIn=11 and UserResponse=''P'')' , 11'
@startRowIndex int,
@maximumRows int,
@criteria varchar(max),
@candiid bigint
as

Declare @sqlst as varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;

select @sqlst='
With Waiting_Mem as (
select  ROW_NUMBER() OVER(ORDER BY profiledate DESC) AS rowid ,profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,passw ,
(Select InterestFor from User_Interest where User_Interest.candiid=profile.pid and User_Interest.IntrestedIn = ' + convert(varchar,@candiid) + ') AS InterestFor
from profile  where  ' + @criteria + ' )
select *,(Select MAX(Rowid) from Waiting_Mem  ) as Total from Waiting_Mem'
EXEC(@sqlst + ' where rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxRow + ')')
GO
/****** Object:  StoredProcedure [dbo].[members_Search]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[members_Search] --members_Search 0,20,'1=1'
@startRowIndex int,
@maximumRows int,
@criteria varchar(max)='1=1'
as

Declare @sqlst as varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;

select @sqlst='
WIth AllPartner as (
select  ROW_NUMBER() OVER(ORDER BY profiledate DESC) AS rowid ,profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,passw 
from profile where ' + @criteria + ' )
select * ,(Select MAX(Rowid) from AllPartner) as Total from AllPartner'
EXEC(@sqlst + ' where rowid > '+@startRowIndex+' AND rowid <= ('+ @MaxRow + ')')
GO
/****** Object:  Table [dbo].[MainCategory]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MainCategory](
	[catid] [bigint] IDENTITY(1,1) NOT NULL,
	[Category] [varchar](500) NOT NULL,
	[descrip] [varchar](500) NOT NULL,
	[CandiId] [bigint] NOT NULL,
	[StartDate] [datetime] NOT NULL,
 CONSTRAINT [PK_MainCategory] PRIMARY KEY CLUSTERED 
(
	[catid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[LogTrack]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[LogTrack]
@candiid bigint,
@LoginDate DateTime=null,
@IPAddress varchar(50)='',
@LogStatus varchar(10)='Login'
AS
if @LoginDate is null
	BEGIN
		Set @LoginDate=GETDATE()
	END
If @LogStatus ='Login'
BEGIN
	INSERT INTO [dbo].[Login_Details]([candiid],[LoginDate],[IPAddress]) Values(@candiid,@LoginDate,@IPAddress)
	Update websolaffi set LastLogin=@LoginDate where CANDIid=@candiid
END
Else if @LogStatus='Logout'
Update Login_Details set LogoutDate=@LoginDate where candiid=@candiid
if Exists(Select * from User_Steps Where Candiid=@candiid )
	Select TOP 1 StepID,IsView,IsTestTaken,IsPassTest,isnull(CompletedON,GETDATE()) as CompletedON from User_Steps Where Candiid=@candiid order by StepID desc;
else
	Select 0 as StepID, '' as IsView, '' as IsTestTaken, '' as IsPassTest , GETDATE() as CompletedON
GO
/****** Object:  StoredProcedure [dbo].[Login_User]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Login_User]
@Email varchar(250),
@Pass varchar(250)
AS
select candiid,firstname,Friendshipzone,countryid,susp,emailverified,lastname,mrole,
photo,mobile,hasinvited,facebookpost,FB_ID,IsGPlus,GPlusImg,mem_type,emailAddress,mobile
From websolaffi
Where emailAddress=@Email AND Passw=@Pass
GO
/****** Object:  StoredProcedure [dbo].[monica]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[monica]
as
select top 41 email,fname,inviteid from invites where  -- email like '%aminnagpure%' 
 isblacklisted='N' and isbouncing=0 and membercontact=0
and isdeleted='N' and isvalidemail='Y'
order by inviteid desc
GO
/****** Object:  StoredProcedure [dbo].[mohiniemail]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[mohiniemail]
as
select top 200000 email,fname,inviteid from invites where --  email like '%aminnagpure%' 
 isblacklisted='N' and isbouncing=0 and mohini=0
and isdeleted='N' and isvalidemail='Y'
order by inviteid desc
GO
/****** Object:  StoredProcedure [dbo].[mquery]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[mquery] @pid varchar(60)
as
 select searchno,queryname from alert where candiid=@pid
GO
/****** Object:  StoredProcedure [dbo].[photogallery]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[photogallery]
@pid bigint
as
Select * from photo  where pid=@pid
GO
/****** Object:  StoredProcedure [dbo].[Express_Interest]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Express_Interest]
@candiid bigint,
@Tocandiid bigint,
@interestedFor varchar(250),
@AddDate datetime=null
AS
if ISDATE(@AddDate)=0
	set @AddDate=GETDATE()
if not Exists(Select * from User_Interest Where (CONVERT(varchar,Candiid)+CONVERT(varchar,IntrestedIn))=(CONVERT(varchar,@candiid)+CONVERT(varchar,@Tocandiid)) OR 
(CONVERT(varchar,IntrestedIn)+CONVERT(varchar,Candiid))=(CONVERT(varchar,@Tocandiid)+CONVERT(varchar,@candiid))
)
BEGIN
Insert into User_Interest
(Candiid,IntrestedIn,InterestDate,InterestFor)values(@candiid,@Tocandiid,@AddDate,@interestedFor)
END
GO
/****** Object:  StoredProcedure [dbo].[fixinginvalidemails]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[fixinginvalidemails]
as
select  top 2500000 inviteid,email,fname,lname,sendersemail,lovenmarrysent from
invites  where -- email like '%aminnagpure%'
 
lovenmarrysent=0
order by inviteid desc
GO
/****** Object:  StoredProcedure [dbo].[Fill_QuotesCategory]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[Fill_QuotesCategory]
 
 as
  Select * from Quotescatmaster
GO
/****** Object:  StoredProcedure [dbo].[forummainpage]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[forummainpage]
@startRowIndex int,
@maximumRows int,
@criteria varchar(max)
as
select forumcatid,forumcategoryn,descrip from forumcategory
GO
/****** Object:  StoredProcedure [dbo].[fullProfile]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[fullProfile]
@candiid bigint
as
select cr.*,ftp.*,(select count(downlodId) from downloadDetails)as Downloads from candireg cr left outer join dbo.FtpDetail ftp on cr.candiid = ftp.candiid
  where cr.candiid = @candiid
GO
/****** Object:  StoredProcedure [dbo].[activateMamber]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[activateMamber]
@candiid bigint
as
update candireg set IsActive = 'Y' where candiid = @candiid
GO
/****** Object:  StoredProcedure [dbo].[Get_Cast_List]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Get_Cast_List]
@Rel varchar(50)=''
As
if @Rel <> ''
	Select * from Cast_List where Rel=@Rel
else
	Select * from Cast_List Where Cast_N<>'Other'
GO
/****** Object:  StoredProcedure [dbo].[getCandiRegi]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[getCandiRegi]
@candiid bigint
as 
select Passw,FirstName,LastName,MobileNo,cityid,stateid,COUNTRYID,EmailID,[address],photo ,
photopassw  ,websiteUrl 
from candiReg where candiid = @candiid
GO
/****** Object:  StoredProcedure [dbo].[getAllCategory]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[getAllCategory]
@id int =0
AS
if @id = 0
	Select catid,Category,descrip from dbo.MainCategory
else
	Select catid,Category,descrip from dbo.MainCategory where catid=@id
GO
/****** Object:  StoredProcedure [dbo].[inviteemailtanya]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[inviteemailtanya]
as
select top 110000 email,fname,inviteid,tanysent from invites where  
--email like '%aminnagpure%' 
 isblacklisted='N' and isbouncing=0 and tanysent=0 and isdeleted='N' and isvalidemail='Y'
--order by inviteid desc
GO
/****** Object:  StoredProcedure [dbo].[inviteemailslovenmarrymarking1]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[inviteemailslovenmarrymarking1] @inviteid bigint
as
update invites set lovenmarrysent=1 where inviteid=@inviteid
GO
/****** Object:  StoredProcedure [dbo].[inviteemailslovenmarry_2]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[inviteemailslovenmarry_2]
as
select  top 10 candiid,email,fname,lname,sendersemail,inviteid,lovenmarry from
invites  where -- email like '%aminnagpure%'
 isdeleted='N' 
and lovenmarrysent=1  and isvalidemail='Y' and isblacklisted='N' and isdeleted='N'
and converted='N' and isbouncing=0
and email not like '%@hotmail.com' and email not like '%@aol'
GO
/****** Object:  StoredProcedure [dbo].[inviteemailslovenmarry]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[inviteemailslovenmarry]
as
select  top 17 candiid,email,fname,lname,sendersemail,inviteid from
invites  where --email like '%aminnagpure%'
lovenmarrysent=0  and isvalidemail='Y' and isblacklisted='N' and isdeleted='N'
and converted='N' and isbouncing=0 
order by inviteid desc
GO
/****** Object:  StoredProcedure [dbo].[inviteemailreshma]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[inviteemailreshma]
as
select top 1 email,fname,inviteid from invites where -- email like '%aminnagpure%' 
 isblacklisted='N' and isbouncing=0 and reshma=0 and isdeleted='N' and isvalidemail='Y'
--order by inviteid desc
GO
/****** Object:  StoredProcedure [dbo].[inviteemailRAHUL]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[inviteemailRAHUL]
as
select top 41000 email,fname,inviteid,tanysent from invites where  
--email like '%aminnagpure%' 
 isblacklisted='N' and isbouncing=0 and tanysent=1 and isdeleted='N' and isvalidemail='Y'
--order by inviteid desc
GO
/****** Object:  StoredProcedure [dbo].[inviteemailall]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[inviteemailall]
as
select top 1 email,fname,inviteid from invites where -- email like '%aminnagpure%' 
 isblacklisted='N' and isbouncing=0 and membercontact=0
and isdeleted='N' and isvalidemail='Y'

--order by inviteid desc
GO
/****** Object:  StoredProcedure [dbo].[InsertTopic]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[InsertTopic]
@TopicTitle varchar(500),
@TopicDesc varchar(max),
@CatId bigint,
@SubCatId bigint,
@CandiId bigint,
@UpdateCandiName varchar(250),
@UpdateCandiId bigint,
@StartDate dateTime,
@UpdateDate Datetime

AS
BEGIN
DECLARE @TopicId bigint 
 INSERT INTO [Topic]([TopicTitle],[TopicDesc],[CatId],[SubCatId],[CandiId],[UpdateCandiName],[UpdateCandiId],[StartDate],[UpdateDate])
            VALUES(@TopicTitle,@TopicDesc,@CatId,@SubCatId,@CandiId,@UpdateCandiName,@UpdateCandiId,@StartDate,@UpdateDate) 
 select @@identity
Set @TopicId =  SCOPE_IDENTITY()            
update dbo.SubCategory set LastTopic=@TopicId,UpdatedBy=@CandiId,UpdatedDate=@UpdateDate Where SubCatId=@SubCatId
 
Return @TopicId
END
GO
/****** Object:  StoredProcedure [dbo].[InsertAnswer]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertAnswer]

@TopicId bigint ,
@TopicAns varchar(5000),
@CandiId bigInt,
@AnsDate DateTime,
@UpdateyByName varchar(250)
AS
BEGIN
Declare @NewAnsId bigint
INSERT INTO [TopicAnswer]([TopicId],[TopicAns],[CandiId],[AnsDate])
     VALUES
           (@TopicId,@TopicAns,@CandiId,@AnsDate) select @@IDENTITY;
Set @NewAnsId =SCOPE_IDENTITY()
Update dbo.Topic set  UpdateDate=@AnsDate,UpdateCandiId=@CandiId,
UpdateCandiName=@UpdateyByName Where TopicId=@TopicId

Return @NewAnsId
END
GO
/****** Object:  StoredProcedure [dbo].[kavitaemail]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[kavitaemail]
as
select top 99000 email,fname,inviteid,kavita from invites where  -- email like '%aminnagpure%' 
 isblacklisted='N' and isbouncing=0 and kavita=0
and isdeleted='N' and isvalidemail='Y'
--order by inviteid desc
GO
/****** Object:  StoredProcedure [dbo].[getReferby]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[getReferby]
@candiid bigint
as
declare @refby bigint;
select @refby=refby from candiReg where candiid = @candiid

select FirstName
      ,LastName
      ,EmailID
      ,MobileNo
      ,cityName
      ,StateName
      ,Country
      ,address
      ,photo
from candiReg where candiid =@refby
--exec getReferby 1
GO
/****** Object:  StoredProcedure [dbo].[loadcountry]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[loadcountry]
as
select countryid,countryname from country order by countryid
GO
/****** Object:  StoredProcedure [dbo].[bhavnaemail]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[bhavnaemail]
as
select  email,fname,inviteid,bhavna from invites where --  email like '%aminnagpure%' 
 isblacklisted='N' and isbouncing=0 and bhavna=0
and isdeleted='N' and isvalidemail='Y'
--order by inviteid desc
GO
/****** Object:  StoredProcedure [dbo].[aprovemsg]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[aprovemsg]
@msgid bigint,
@ismsgSent varchar(1)='N'
as

update send_msg set aproveSender='Y' , msgissend = @ismsgSent   where msgid = @msgid
GO
/****** Object:  StoredProcedure [dbo].[approvephotoall]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[approvephotoall]
@pid varchar(60)
as
update photo set active='Y' where pid=@pid
GO
/****** Object:  StoredProcedure [dbo].[approvephoto]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[approvephoto]
@photoid varchar(60)
as
update photo set active='Y' where photoid=@photoid
GO
/****** Object:  StoredProcedure [dbo].[Approve]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Approve]
@candiid bigint
as
update candireg set IsApproved = 'Y' where candiid = @candiid
GO
/****** Object:  StoredProcedure [dbo].[alertcount]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[alertcount] @pid varchar(60)
as
select count(*) from alert where candiid=@pid
GO
/****** Object:  StoredProcedure [dbo].[checkNewscommentscount]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[checkNewscommentscount]
@mid bigint
as
select count(ncommentid)
from newscomments
where newsid=@mid
GO
/****** Object:  StoredProcedure [dbo].[delphoto]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[delphoto]
@photoid varchar(60)
as
delete from photo where photoid=@photoid
GO
/****** Object:  StoredProcedure [dbo].[DelMember]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DelMember]
@candiid bigint
as
delete from dbo.downloadDetails where candiid = @candiid 
delete from dbo.Twinkletopearners where candiid = @candiid 
delete from dbo.FtpDetail where candiid = @candiid
delete from candireg where candiid = @candiid
GO
/****** Object:  StoredProcedure [dbo].[delImage]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[delImage]
@candiid bigint
as
update  candiReg set  photo = '' where candiid = @candiid
GO
/****** Object:  StoredProcedure [dbo].[deleteTopic]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[deleteTopic]
@TopicId bigint
AS
BEGIN
Declare @SubCatId bigint, @NewTopic bigint 
Delete From TopicAnswer Where TopicId=@TopicId
Select @SubCatId= SubCatId from Topic Where TopicId=@TopicId
Delete From Topic Where TopicId=@TopicId
Select @NewTopic = COUNT(TopicId) from dbo.Topic Where SubCatId=@SubCatId
Print @NewTopic
if @NewTopic > 0
	BEGIN
		Select @NewTopic = MAX(TopicId) from dbo.Topic Where SubCatId=@SubCatId
		Print @NewTopic
		Update dbo.SubCategory set LastTopic=@NewTopic Where SubCatId=@SubCatId
	END
ELSE
	Update dbo.SubCategory set LastTopic=NUll Where SubCatId=@SubCatId

END
GO
/****** Object:  StoredProcedure [dbo].[deletemsg]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[deletemsg]  
@msgid bigint
as  

delete from send_msg where msgid=@msgid
GO
/****** Object:  StoredProcedure [dbo].[deleteAnswer]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[deleteAnswer]
@AnsId bigint
AS
BEGIN
Declare @TopicId1 bigint, @NewAns bigint 
Select @TopicId1= TopicId from TopicAnswer Where AnsId= @AnsId
Delete From TopicAnswer Where AnsId=@AnsId
Select @NewAns = COUNT(AnsId) from dbo.TopicAnswer Where TopicId=@TopicId1
if @NewAns > 0
	BEGIN
		Select @NewAns = MAX(Ansid) from dbo.TopicAnswer Where TopicId=@TopicId1		
		Update dbo.Topic set LastAnsId=@NewAns Where TopicId=@TopicId1
	END
ELSE
	Update dbo.Topic set LastAnsId=NUll Where TopicId=@TopicId1
END
GO
/****** Object:  StoredProcedure [dbo].[Delete_Interest]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PRocedure [dbo].[Delete_Interest]
@candiid bigint,
@Tocandiid bigint
AS
if  Exists(Select * from User_Interest Where Candiid=@candiid and IntrestedIn=@tocandiid)
BEGIN
Delete from User_Interest Where Candiid=@candiid and IntrestedIn=@tocandiid
END
GO
/****** Object:  StoredProcedure [dbo].[DeactivateMamber]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DeactivateMamber]
@candiid bigint
as
update candireg set IsActive = 'N' where candiid = @candiid
GO
/****** Object:  StoredProcedure [dbo].[earnmoney]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[earnmoney]
as
select top 11 email,fname,inviteid from invites where --  email like '%aminnagpure%' 
 isblacklisted='N' and isbouncing=0 and bhavna=1
and isdeleted='N' and isvalidemail='Y'
order by inviteid desc
GO
/****** Object:  StoredProcedure [dbo].[aditi]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[aditi]
as
select top 1 email,fname,inviteid from invites where  -- email like '%aminnagpure%' 
 isblacklisted='N' and isbouncing=0 and aditi=0
and isdeleted='N' and isvalidemail='Y'
--order by inviteid desc
GO
/****** Object:  StoredProcedure [dbo].[AddProfileview]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddProfileview]
@viewdby bigint,
@viewdofid bigint,
@ipAddress varchar(150)=''
AS
if Not Exists(select * from profileviews  where viewedbyid=@viewdby   and pidof=@viewdofid )
	insert into profileviews(viewedbyid,pidof,ipaddress) values(@viewdby ,@viewdofid ,@ipAddress )
else
	update profileviews set vieweddate=getdate() where viewedbyid=@viewdby  and  pidof=@viewdofid
	
	--Select * from profileviews where pidof=122915
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_UpdateMailImage]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WebsolAffi_UpdateMailImage]
@candiid bigint,
@photoname varchar(150)
AS
Update websolaffi set photo=@photoname where CANDIid=@candiid
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Update_stepView]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WebsolAffi_Update_stepView]
@candiid bigint,
@stepid bigint
AS
If Exists(Select * from User_Steps where Candiid=@candiid and StepID=@stepid)
BEGIN
	update User_Steps set IsView= 'Y' where Candiid=@candiid and StepID=@stepid
END
ELSE
BEGIN
	Insert into User_Steps(Candiid,StepID,IsView,IsTestTaken,IsPassTest)
	VALUES(@candiid,@stepid,'Y','N','N')
END
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_UnApproveTest]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[WebsolAffi_UnApproveTest]
AS
Select US.*, Aff.firstname, Aff.lastname,Aff.regdate from User_steps US
JOIN Websolaffi Aff
ON US.Candiid=Aff.candiid
Where US.IsPassTest='N'
GO
/****** Object:  StoredProcedure [dbo].[websolAffi_Totalmembers]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[websolAffi_Totalmembers]
@Total bigint output,
@Today bigint output
AS
Select @Total=isnull(COUNT(*),0) from websolaffi
Select @Today=isnull(COUNT(*),0) from websolaffi Where  CONVERT(VARCHAR(10), regdate, 110)=CONVERT(VARCHAR(10), GETDATE(), 110)
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_myrevenue_get]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WebsolAffi_myrevenue_get]
@candiid bigint
AS
Select isnull(SUM(ref1val),0) as TotalSum,Count(ref1val)  as TotalCount
from websolaffi where referdby=@candiid
Select ISNULL(SUM(ref1val),0) as TotalSum,Count(ref1val)  as TotalCount
from websolaffi where referdby=@candiid and CONVERT(VARCHAR(10), regdate, 110)=CONVERT(VARCHAR(10), GETDATE(), 110)

Select photo ,FB_ID , GPlusImg from websolaffi where candiid=@candiid
GO
/****** Object:  StoredProcedure [dbo].[websolaffi_getMembers]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PRocedure [dbo].[websolaffi_getMembers]
@startRowIndex bigint,
@maximumRows bigint
AS
Declare
@MAXR bigint
set @MAXR=@startRowIndex+@maximumRows;

WITH AllMem as 
(
select * ,(Select isnull(SUM(ref1val),0) from  websolaffi af where af.referdby=mem.candiid) as Earned, ROW_NUMBER() OVER(order by candiid  desc) as Rowid from websolaffi mem where Susp='N'
)
select *,(Select MAX(Rowid) from AllMem) As TC from AllMem where Rowid>@startRowIndex and Rowid<= @MAXR
GO
/****** Object:  StoredProcedure [dbo].[websolaffi_get_videocomments]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[websolaffi_get_videocomments] -- 0, 120, 1
--Declare
@startRowIndex bigint,
@maximumRows bigint,
@vid bigint

as
SET NOCOUNT ON;
declare @sqlst varchar(max), @MaxRow int
set @MaxRow= @startRowIndex + @maximumRows;
WITH AllComments AS (
select cid ,ROW_NUMBER() OVER(ORDER BY cid DESC) AS rowid,c.candiid,p.firstname,p.lastname,p.photo,
c.comments ,p.FB_ID,p.GPlusImg,c.commentdate
from websolAffi_videoComments c inner join websolaffi p
on c.candiid =p.candiid
where videoID= @vid

)select *,(Select MAX(rowid) from AllComments) as TC from AllComments
where rowid > @startRowIndex AND rowid <= @MaxRow
GO
/****** Object:  StoredProcedure [dbo].[usp_loadphotoes]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_loadphotoes]
as
select photoname from photo
GO
/****** Object:  StoredProcedure [dbo].[usp_insert_ForumTopics]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[usp_insert_ForumTopics]
--Declare 
@forumtopid Varchar(100),
@question nVarchar(500),
@questdesc nvarchar(max),
@startedbyid bigint,
@updatebyid bigint,
@startedby Varchar(100)


as

Declare @topicid bigint

insert into forumqandA(forumtopid,question,questdesc,startedbyid,updatebyid,startedby)
values(@forumtopid,@question,@questdesc,@startedbyid,@updatebyid,@startedby)

Select @topicid = @@IDENTITY

update forumtopics set latesttopic=convert(nvarchar(500),@questdesc),startedbyid=@startedbyid,updatebyid=@updatebyid,latesttopicid=@topicid
where forumtopid=@forumtopid
GO
/****** Object:  StoredProcedure [dbo].[usp_Home_Poll_CheckPollAns]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_Home_Poll_CheckPollAns]
@id bigint,
@Logid bigint
as

Select isnull((select distinct(CreationLogInId) from OnlinePoleTest_Master where QueId=@id and CreationLogInId=@Logid),0) as countRank,
isnull((select top 1 poleAns from OnlinePoleTest_Master where QueId=@id and CreationLogInId=@Logid),'') as yourans
GO
/****** Object:  StoredProcedure [dbo].[websolAffi_viewProfile]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[websolAffi_viewProfile]
@candiid bigint
AS
Select * from websolaffi where candiid=@candiid
GO
/****** Object:  StoredProcedure [dbo].[UpDate_Interest]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpDate_Interest] 
@candiid bigint,
@Tocandiid bigint,
@Response varchar(10),
@AddDate datetime=null,
@Mess varchar(500)=''
AS
if ISDATE(@AddDate)=0
	set @AddDate=GETDATE()

if  Exists(Select * from User_Interest Where IntrestedIn=@candiid and Candiid=@tocandiid)
BEGIN

Update User_Interest
Set UserMessage=@Mess, UserResponse=@Response,ResponseDate=@AddDate Where IntrestedIn=@candiid and candiid=@Tocandiid
END
GO
/****** Object:  StoredProcedure [dbo].[ViewMyProfile]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[ViewMyProfile]
@candiid bigint
AS
Select * from websolaffi where candiid=@candiid
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Forums_SubCate_Add]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WebsolAffi_Forums_SubCate_Add]
@CatId bigint,
@CandiId bigint,
@SubCatTitle varchar(250),
@SubCatDesc varchar(500),
@StartedBy bigint,
@UpdatedBy bigint,
@StartDate datetime,
@UpdatedDate datetime


as
if not Exists(Select * from dbo.WebsolAffi_Forums_SubCategory Where SubCatTitle = @SubCAtTitle and CatId=@CAtId)
BEGIN
	INSERT INTO [dbo].[WebsolAffi_Forums_SubCategory]
           ([CatId]
           ,[CandiId]
           ,[SubCatTitle]
           ,[SubCatDesc]
           ,[StartedBy]
           ,[UpdatedBy]
           
           ,[StartDate]
           ,[UpdatedDate]
           )
     VALUES
           (@CatId,
@CandiId,
@SubCatTitle,
@SubCatDesc,
@StartedBy, 
@UpdatedBy, 

@StartDate, 
@UpdatedDate
) SeLeCT @@IDENTITY
END
else
	Select 0 as fail
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Forums_InsertTopic]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WebsolAffi_Forums_InsertTopic]
@TopicTitle varchar(500),
@TopicDesc varchar(max),
@CatId bigint,
@SubCatId bigint,
@CandiId bigint,
@UpdateCandiName varchar(250),
@UpdateCandiId bigint,
@StartDate dateTime,
@UpdateDate Datetime

AS
BEGIN
DECLARE @TopicId bigint 
 INSERT INTO [WebsolAffi_Forums_Topic]([TopicTitle],[TopicDesc],[CatId],[SubCatId],[CandiId],[UpdateCandiName],[UpdateCandiId],[StartDate],[UpdateDate])
            VALUES(@TopicTitle,@TopicDesc,@CatId,@SubCatId,@CandiId,@UpdateCandiName,@UpdateCandiId,@StartDate,@UpdateDate) 
 select @@identity
Set @TopicId =  SCOPE_IDENTITY()            
update dbo.WebsolAffi_Forums_SubCategory set LastTopic=@TopicId,UpdatedBy=@CandiId,UpdatedDate=@UpdateDate Where SubCatId=@SubCatId
 
Return @TopicId
END
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Forums_InsertAnswer]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WebsolAffi_Forums_InsertAnswer]
@TopicId bigint ,
@TopicAns varchar(5000),
@CandiId bigInt,
@AnsDate DateTime,
@UpdateyByName varchar(250)
AS
BEGIN
Declare @NewAnsId bigint
INSERT INTO [WebsolAffi_Forums_TopicAnswer]([TopicId],[TopicAns],[CandiId],[AnsDate])
     VALUES
           (@TopicId,@TopicAns,@CandiId,@AnsDate) select @@IDENTITY;
Set @NewAnsId =SCOPE_IDENTITY()
Update dbo.WebsolAffi_Forums_Topic set  UpdateDate=@AnsDate,UpdateCandiId=@CandiId,
UpdateCandiName=@UpdateyByName Where TopicId=@TopicId

Return @NewAnsId
END
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Forums_getTopics]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[WebsolAffi_Forums_getTopics]
@startRowIndex int=0,
@maximumRows int=120,
@criteria bigint
as
select * from 
(
select TopicId,CatId,TopicTitle,TopicDesc,T.CandiId,
cn.firstname,
CONVERT(varchar(10),StartDate,103) as
starteddate,UpdateCandiId,convert(varchar(20),
UpdateDate,100) as
updatedate,
(Select COUNT(AnsId) From WebsolAffi_Forums_TopicAnswer Where WebsolAffi_Forums_TopicAnswer.TopicId=T.TopicId) as 'ReplayCount',
UpdateCandiName, Photo,FB_ID,GPlusImg,GplusASProfile,
CONVERT(varchar(10),UpdateDate,103)as updateddate,ROW_NUMBER() OVER(ORDER BY UpdateDate DESC) AS rowid
 from WebsolAffi_Forums_Topic as T left join websolaffi as cn on
T.CandiId=cn.CANDIid  where SubCatId=@criteria

) as kk
where rowid >@startRowIndex AND rowid <= (@startRowIndex + @maximumRows)
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Forums_GetTopicDetails]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WebsolAffi_Forums_GetTopicDetails]
@TopicId as bigint
AS
Select T.TopicId,T.TopicTitle ,T.TopicDesc,T.CatId,T.SubCatId,
T.CandiId,CAN.firstname  ,
T.UpdateCandiId,T.UpdateCandiName,
CONVERT(VARCHAR(20), T.StartDate, 100) AS StartDate,
CONVERT(VARCHAR(20),T.UpdateDate, 100) AS  UpdateDate,

(Select COUNT(TopicTitle) from WebsolAffi_Forums_Topic WHere WebsolAffi_Forums_Topic.CandiId=CAN.candiid) as TotalThread,
(Select COUNT(AnsId) from WebsolAffi_Forums_TopicAnswer WHere WebsolAffi_Forums_TopicAnswer.TopicId=T.TopicId) as TotalReplay, CAN.photo,can.FB_ID,can.GPlusImg,can.GplusASProfile
from WebsolAffi_Forums_Topic T LEFt JOIN websolaffi  CAN ON T.CandiId = CAN.candiid  Where TopicId=@TopicId
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Forums_getTopicAnswer]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WebsolAffi_Forums_getTopicAnswer]
@startRowIndex int,
@maximumRows int,
@criteria bigint
AS
Declare @MAXRow bigint
set @MAXRow=@startRowIndex + @maximumRows
SET NOCOUNT ON;
 select * from( Select AnsId,TopicAns,TA.CandiId,TopicId, 
CONVERT(VARCHAR(20), AnsDate, 100) as AnsDate,
can.firstname ,ROW_NUMBER() over(order by AnsDate) as rowid,can.photo,can.FB_ID,can.GPlusImg,can.GplusASProfile
from WebsolAffi_Forums_TopicAnswer TA LEFT JOIN websolaffi  can
ON TA.CandiId=can.candiid Where TopicId=@criteria
) as DT 
where rowid >@startRowIndex AND rowid <= @MAXRow
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Forums_getSubCategory]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WebsolAffi_Forums_getSubCategory]
	@mid int 
AS
Select SC.SubCatId,SC.SubCatTitle,SC.UpdatedBy,SC.LastTopic,SC.LastTopicid
,Sc.CatId ,Sc.SubCatDesc,
CONVERT(VARCHAR(20), sc.UpdatedDate, 100) AS  lastupdate ,
(Select SUBSTRING ( TopicTitle ,1 , 60 ) as TopicTitle from WebsolAffi_Forums_Topic Where TopicId=Sc.LastTopicid ) as TopicTitle,
pl.candiid ,pl.firstname ,pl.Activated ,pl.photo,pl.photopassw,pl.FB_ID,pl.GPlusImg,
'' + (Select firstname  from websolaffi  where candiid =Sc.UpdatedBy) as UpdatedByName,
'' + Convert(varchar(50),(Select count(TopicTitle) from WebsolAffi_Forums_Topic where SC.SubCatId=WebsolAffi_Forums_Topic.SubCatId)) as TopicsCount,
'' + Convert(varchar(50),(select COUNT(TA.AnsId) from WebsolAffi_Forums_TopicAnswer TA inner join WebsolAffi_Forums_Topic on TA.TopicId= WebsolAffi_Forums_Topic.TopicId where WebsolAffi_Forums_Topic.SubCatId=SC.SubCatId)) as ReplyCount
from dbo.WebsolAffi_Forums_SubCategory SC LEFT OUTER JOIN dbo.websolaffi pl
ON SC.UpdatedBy=pl.candiid  
Where  Sc.CatId=@mid
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Forums_getSubCatDetails]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[WebsolAffi_Forums_getSubCatDetails]
@SubcatID bigint
AS
Select SC.SubCatTitle,Sc.SubCatDesc,isnull(CONVERT(VARCHAR(20), sc.UpdatedDate, 100),'') AS  lastupdate ,sc.CatId,sc.StartDate,
CAN.candiid,CAN.firstname,CAN.lastname,CAN.photo,CAN.photopassw,'' + Convert(varchar(50),
(Select count(TopicTitle) from WebsolAffi_Forums_Topic where SC.SubCatId=WebsolAffi_Forums_Topic.SubCatId)) as TopicsCount,'' + Convert(varchar(50),
(select COUNT(TA.AnsId) from WebsolAffi_Forums_TopicAnswer TA inner join WebsolAffi_Forums_Topic on TA.TopicId= WebsolAffi_Forums_Topic.TopicId 
where WebsolAffi_Forums_Topic.SubCatId=SC.SubCatId)) as ReplyCount
,can.FB_ID,can.GPlusImg,can.GplusASProfile
 from dbo.WebsolAffi_Forums_SubCategory SC LEFT OUTER JOIN 
dbo.websolaffi CAN ON SC.CandiId=CAN.candiid  Where  Sc.SubCatId=@SubcatID
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Forums_getAllCategory]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[WebsolAffi_Forums_getAllCategory]
@id int =0
AS
if @id = 0
	Select catid,Category,descrip from dbo.WebsolAffi_Forums_MainCategory
else
	Select catid,Category,descrip from dbo.WebsolAffi_Forums_MainCategory where catid=@id
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Forums_DeleteTopic]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WebsolAffi_Forums_DeleteTopic]
@TopicId bigint
AS
BEGIN
Declare @SubCatId bigint, @NewTopic bigint 
Delete From WebsolAffi_Forums_TopicAnswer Where TopicId=@TopicId
Select @SubCatId= SubCatId from WebsolAffi_Forums_Topic Where TopicId=@TopicId
Delete From WebsolAffi_Forums_Topic Where TopicId=@TopicId
Select @NewTopic = COUNT(TopicId) from dbo.WebsolAffi_Forums_Topic Where SubCatId=@SubCatId
Print @NewTopic
if @NewTopic > 0
	BEGIN
		Select @NewTopic = MAX(TopicId) from dbo.WebsolAffi_Forums_Topic Where SubCatId=@SubCatId
		Print @NewTopic
		Update dbo.WebsolAffi_Forums_SubCategory set LastTopic=@NewTopic Where SubCatId=@SubCatId
	END
ELSE
	Update dbo.WebsolAffi_Forums_SubCategory set LastTopic=NUll Where SubCatId=@SubCatId

END
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Forums_DeleteAnswer]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WebsolAffi_Forums_DeleteAnswer]
@AnsId bigint
AS
BEGIN
Declare @TopicId1 bigint, @NewAns bigint 

Select @TopicId1= TopicId from WebsolAffi_Forums_TopicAnswer Where AnsId= @AnsId
Delete From WebsolAffi_Forums_TopicAnswer Where AnsId=@AnsId
Select @NewAns = COUNT(AnsId) from dbo.WebsolAffi_Forums_TopicAnswer Where TopicId=@TopicId1

--if @NewAns > 0
--	BEGIN
--		Select @NewAns = MAX(Ansid) from dbo.Forums_TopicAnswer Where TopicId=@TopicId1
		
--		Update dbo.Forums_Topic set LastAnsId=@NewAns Where TopicId=@TopicId1
--	END
--ELSE
	--Update dbo.Topic set LastAnsId=NUll Where TopicId=@TopicId1

END
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Forums_Category_Add]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WebsolAffi_Forums_Category_Add]
	@forumcategoryn varchar(250),
	@descrip varchar(500),
	@CandiId bigint =0,
	@RowEffect int output,
	@StartDate dateTime=GETDATE
AS
BEGIN
Declare @c int
Select @c=COUNT(Category) from WebsolAffi_Forums_MainCategory  where Category=@forumcategoryn;
set @RowEffect =0;
SET NOCOUNT ON;

	if @c=0
	BEGIN
			insert into WebsolAffi_Forums_MainCategory(Category,descrip,CandiId,StartDate) values(@forumcategoryn,@descrip,@CandiId,@StartDate)
			set @RowEffect= 1;
	END
	ELSE
	set @RowEffect= -2;

	return @RowEffect;
END
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_ApproveTest]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[WebsolAffi_ApproveTest]
@SestID bigint
AS
Update User_Steps set IsPassTest='Y' where User_Step_id=@SestID
Select * from websolaffi where candiid =( Select  candiid from User_Steps  where User_Step_id=@SestID)
GO
/****** Object:  StoredProcedure [dbo].[websolAffi_Add_videoComments]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[websolAffi_Add_videoComments]
@candiid bigint,
@videoID bigint,
@comments varchar(1000),
@commentdate datetime
AS
INSERT INTO [websolAffi_videoComments]
           ([candiid]
           ,[videoID]
           ,[comments]
           ,[commentdate])
     VALUES
(	@candiid, 
@videoID, 
@comments,
@commentdate)
GO
/****** Object:  StoredProcedure [dbo].[WebsolAffi_Add_StepTest]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[WebsolAffi_Add_StepTest]
@candiid bigint,
@stepID bigint,
@Qid bigint,
@Ans varchar(500),
@AnsDate datetime
AS
If Not Exists(Select * from WebsolAffi_Step_Test Where candiid=@candiid and stepID=@stepID AND Qid=@Qid)
BEGIN
	INSERT INTO [WebsolAffi_Step_Test]([candiid],[stepID],[Qid],[Ans],[AnsDate])
		 VALUES(@candiid,@stepID, @Qid, @Ans, @AnsDate)
	If Exists(Select * from User_Steps where Candiid=@candiid and StepID=@stepid)
	BEGIN
		update User_Steps set IsView= 'Y',IsTestTaken='Y' where Candiid=@candiid and StepID=@stepid
	END
	ELSE
	BEGIN
		Insert into User_Steps(Candiid,StepID,IsView,IsTestTaken,IsPassTest)
		VALUES(@candiid,@stepid,'Y','Y','N')
	END
END

SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[UserComplaints_Delete]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserComplaints_Delete]
@ComplaintsID bigint
AS
Delete from User_Complaints_Comments Where ComplaintsID=@ComplaintsID
Delete from User_Complaints Where ComplaintID=@ComplaintsID
GO
/****** Object:  StoredProcedure [dbo].[UserComplaints_Comments_Delete]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserComplaints_Comments_Delete]
@CommentID bigint
AS
Delete from User_Complaints_Comments Where CommentsID=@CommentID
GO
/****** Object:  StoredProcedure [dbo].[User_Complaints_Comments_Add]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[User_Complaints_Comments_Add]
@ComplaintsID bigint,
@Comments varchar(5000),
@CommentsBy bigint=0,
@CommentsByName varchar(250),
@IsAdmin varchar(1)='N',
@CommentsDate datetime,
@Resolved varchar(1)='N'
AS

INSERT INTO [User_Complaints_Comments]
           ([ComplaintsID]
           ,[Comments]
           ,[CommentsBy]
           ,[CommentsByName]
           ,[IsAdmin]
           ,[CommentsDate])
     VALUES
(
@ComplaintsID,
@Comments, 
@CommentsBy,
@CommentsByName,
@IsAdmin, 
@CommentsDate)

	Update User_Complaints set IsResolved=@Resolved Where ComplaintID=@ComplaintsID
GO
/****** Object:  StoredProcedure [dbo].[User_Reg]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[User_Reg]
@FirstName varchar(250),
@LastName varchar(250),
@EmailID varchar(250),
@Passw varchar(50),
@MobileNo varchar(12),
@cityName varchar(50)='',
@StateName varchar(50)='',
@Country varchar(50)='',
@IsApproved varchar(1)='Y',
@RegDate datetime = null,
@refby bigint=0,
@refer2 bigint=0,
@ref1val decimal(18,2)=0,
@ref2val decimal(18,2)=0,
@ipaddress varchar(15)='',
@websiteUrl varchar(500)=''
AS
if @RegDate is null
BEGIN
	set @RegDate=getdate()
END
if Not Exists(Select * from candiReg where emailID=@emailID)
BEGIN
INSERT INTO [candiReg]
           ([FirstName]
           ,[LastName]
           ,[EmailID]
           ,[Passw]
           ,[MobileNo]
           ,[cityName]
           ,[StateName]
           ,[Country]
           ,[IsApproved]
           ,[RegDate]
           ,refby,
           refer2,
           ref1val,
           ref2val,
           ipaddress,
           websiteUrl)
     VALUES
           (@FirstName,
@LastName,
@EmailID, 
@Passw, 
@MobileNo, 
@cityName, 
@StateName,
@Country, 
@IsApproved,
@RegDate,
@refby ,
@refer2 ,
@ref1val ,
@ref2val ,
@ipaddress,
@websiteUrl) Select @@IdeNTITY
END
else
	select 0 as 'fail'
GO
/****** Object:  StoredProcedure [dbo].[Usp_AddPoll_Question]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Usp_AddPoll_Question]
@strq Varchar(4000),
@strop Varchar(50),
@candiid bigint,
@CDate Datetime =null
as
if @CDate is null
	set @CDate=GETDATE()
Insert Into  pole_Que_CreateMaster ( QsnDesc, NoOfOptions,  CreationloginId, CreationDate) Values
(@strq,@strop,@candiid,@CDate)

Select @@IDENTITY
GO
/****** Object:  StoredProcedure [dbo].[usp_Add_Ratting]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_Add_Ratting]
@fk_postId bigint,
@rate int,
@posttype varchar(10),
@fk_userId bigint
as

Insert into tbl_rating_typeWise
Select @fk_postId, @rate, @posttype,@fk_userId
GO
/****** Object:  StoredProcedure [dbo].[usp_add_Quotes]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_add_Quotes]
 @mid bigint,
 @adsubject varchar(100),
 @addescription varchar(500),
 @ipaddress varchar(50),
 @picPhoto varchar(50),
 @categoryId bigint
 as
 
 insert into tbl_Quotes(candiid,Quotessub,QuotesDesc,ipaddress,quotesdate,quotespic,categoryId)
 values(@mid,@adsubject,@addescription,@ipaddress, getdate(),@picPhoto,@categoryId)
 Select @@IDENTITY
GO
/****** Object:  StoredProcedure [dbo].[Usp_add_PollQuestion]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[Usp_add_PollQuestion]
@QuestionId varchar(25), 
@QsnDesc Varchar(500), 
@NoOfOptions varchar(10),
@CorrectOption Varchar(20),  
@Marks varchar(10), 
@CreationloginId varchar(10)

as

Insert Into  pole_Que_CreateMaster (QuestionId, QsnDesc, NoOfOptions, CorrectOption,  Marks, CreationloginId, CreationDate)
Select @QuestionId, @QsnDesc, @NoOfOptions, @CorrectOption, @Marks,@CreationloginId, GETDATE() 
Select @@IDENTITY
GO
/****** Object:  StoredProcedure [dbo].[usp_FDelete_ForumTopic]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_FDelete_ForumTopic]
@id bigint
as



Delete from topicsQnAansw where forumqnaid= @id 


Delete from forumqanda where forumqnaid=@id
GO
/****** Object:  StoredProcedure [dbo].[usp_fDelete_Comments_Quotes]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_fDelete_Comments_Quotes]
@PostId bigint
as
Delete from QuotesCommnets where commentid=@PostId
GO
/****** Object:  StoredProcedure [dbo].[Usp_DeleteProfile_ByMOD_Photo]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[Usp_DeleteProfile_ByMOD_Photo]
@ProfileID Varchar(60)
as
Delete from Photo where pid=@ProfileID
GO
/****** Object:  StoredProcedure [dbo].[Usp_Delete_News_Commnet]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[Usp_Delete_News_Commnet]
@Id bigint
as

Delete from newscomments where ncommentid=@Id
GO
/****** Object:  StoredProcedure [dbo].[usp_Delete_ForumComments]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
cREATE proc [dbo].[usp_Delete_ForumComments]
@id  Varchar(50)
as


Delete from topicsQnAansw where answerid= @id
GO
/****** Object:  StoredProcedure [dbo].[TLogin]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[TLogin]
@Email varchar(250),
@Pass varchar(50)
AS
SELECT *
  FROM [candiReg] Where emailID=@Email and PAssw = @pass
GO
/****** Object:  StoredProcedure [dbo].[twinkle_UpdatePlan]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[twinkle_UpdatePlan]
@candiid bigint,
@amount money,
@TransSummary varchar(250),
@TransDate datetime,
@CurrentBalance money,
@NextPayDate date,
@P_version varchar(50),
@P_name varchar(50)
AS
INSERT INTO [Partner_Payment]
           ([candiid]
           ,[amount]
           ,[TransSummary]
           ,[TransDate]
           ,[CurrentBalance]
           ,[NextPayDate]
           ,[P_version]
           ,[P_name])
     VALUES
           (@candiid,
@amount, 
@TransSummary,
@TransDate, 
@CurrentBalance,
@NextPayDate, 
@P_version, 
@P_name);
Update candiReg set LastPayDate=@TransDate, NextPayDate=@NextPayDate where candiid=@candiid;
GO
/****** Object:  StoredProcedure [dbo].[twinkle_get_subsPlan]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[twinkle_get_subsPlan]
@candiid bigint
AS
IF EXISTS(Select * from candiReg Where candiid=@candiid)
BEGIN
IF EXISTS(Select TOP 1 * from Partner_Payment Where candiid=@candiid)
BEGIN
	Select TOP 1 * from Partner_Payment Where candiid=@candiid Order by TransID desc
END
ELSE
	BEGIN
		Declare @ND DATE
		SET @ND=DATEADD(DAY,3,getdate())
		INSERT INTO [Partner_Payment]
           ([candiid]
           ,[amount]
           ,[TransSummary]
           ,[TransDate]
           ,[CurrentBalance]
           ,[NextPayDate]
           ,[P_version]
           ,[P_name])
     VALUES
           (@candiid
           ,0
           ,'Trail Of 3 days'
           ,getdate()
           ,0
           ,@ND
           ,'T'
           ,'Trial');
           Update candiReg set NextPayDate=@ND where candiid=@candiid;
           Select TOP 1 * from Partner_Payment Where candiid=@candiid Order by TransID desc
		END
END
ELSE
BEGIN
Select * from candiReg Where candiid=@candiid
END
GO
/****** Object:  StoredProcedure [dbo].[unapprovedphotos]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[unapprovedphotos]
as
select count(*) as cnt from photo where active='N'
GO
/****** Object:  StoredProcedure [dbo].[UnApprove]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[UnApprove]
@candiid bigint
as
update candireg set IsApproved = 'N' where candiid = @candiid
GO
/****** Object:  StoredProcedure [dbo].[suspended]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[suspended]
as
select distinct * from candireg where  issuspended = 'Y' ORDER BY  RegDate DESC
GO
/****** Object:  StoredProcedure [dbo].[Suspend]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Suspend]
@candiid bigint
as
update candireg set issuspended = 'Y' where candiid = @candiid
GO
/****** Object:  StoredProcedure [dbo].[Update_PersonalInfo]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Update_PersonalInfo]
@candiid bigint,
@fname varchar(250),
@lname varchar(250),
@mobile varchar(20),
@Addr varchar(max),
@companyname varchar(250),
@gender varchar(1),
@education varchar(255),
@dateofbirth date,
@countryname varchar(250),
@companywebsite varchar(250),
@candiWeb varchar(250),
@countryid int,
@statename varchar(250),
@stateid int,
@cityname varchar(250),
@cityid int,
@aboutme varchar(500),
@aim varchar(500)
AS
Update websolaffi set firstname=@fname, lastname=@lname,mobile=@mobile,address1=@Addr,
companyname=@companyname,education=@education,dateofbirth=@dateofbirth,
countryname=@countryname, countryid=@countryid,statename=@statename,stateid=@stateid,cityname=@cityname,cityid=@cityid,
aboutme=@aboutme,companywebsite=@companywebsite, candiWeb=@candiWeb,gender=@gender,aim=@aim
Where CANDIid=@candiid
GO
/****** Object:  StoredProcedure [dbo].[User_Complaints_VerifyUser]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[User_Complaints_VerifyUser]
@mobile varchar(20)='',
@EmailID varchar(250)='',
@ComplaintsID bigint=0
AS
if @mobile='' AND @EmailID=''
Select * from User_Complaints where ComplaintID=@ComplaintsID
else
BEGIN
Select * from User_Complaints where UserMobile=@mobile and EmailID=@EmailID 
Select * from User_Complaints where UserMobile=@mobile and EmailID=@EmailID AND ComplaintID=@ComplaintsID
END
GO
/****** Object:  StoredProcedure [dbo].[User_Complaints_Add]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[User_Complaints_Add]
@UserMobile varchar(20),
@EmailID varchar(250),
@UserName varchar(250),
@ComplaintHead varchar(500),
@ComplaintDesc varchar(5000),
@ComplaintDate datetime
AS
if Not Exists(Select * from User_Complaints Where UserMobile=@UserMobile AND EmailID=@EmailID AND ComplaintHead=@ComplaintHead)
BEGIN
INSERT INTO [User_Complaints]
           (
				[UserMobile]
				,[EmailID]
				,[UserName]
				,[ComplaintHead]
				,[ComplaintDesc]
				,[ComplaintDate]
           )
     VALUES
           (
				@UserMobile,
				@EmailID,
				@UserName,
				@ComplaintHead,
				@ComplaintDesc,
				@ComplaintDate
			) select @@IDENTITY
END
else
	Select 0 as 'AlreadyReg'
GO
/****** Object:  StoredProcedure [dbo].[updateconv]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[updateconv] @em varchar(250)
as
update invites set converted='Y' where email=@em
GO
/****** Object:  StoredProcedure [dbo].[updateregi]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[updateregi]
@candiid bigint,
@passw  varchar(50),
@firstname varchar(250),
@lastname varchar(100),
@MobileNo varchar(12),
@cityName varchar(50),
@StateName varchar(50),
@country varchar(50),
@cityid bigint,
@stateid bigint,
@COUNTRYID bigint,
@address varchar(1000),
@photo varchar(150),
@photopassw varchar(60),
@websiteUrl varchar(500)=''

as
update candiReg 
set 
Passw = @passw , 
FirstName = @firstname, 
LastName=@lastname, 
cityName = @cityname, 
StateName = @statename, 
Country = @country, 
MobileNo = @MobileNo,
cityid = @cityid,
stateid =@stateid,
COUNTRYID = @COUNTRYID,
address = @address,
photo = @photo,
photopassw =@photopassw,
websiteUrl = @websiteUrl
where 
candiid =@candiid
GO
/****** Object:  Table [dbo].[states]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[states](
	[countryid] [int] NOT NULL,
	[statename] [varchar](255) NULL,
	[stateid] [smallint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_states] PRIMARY KEY CLUSTERED 
(
	[stateid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[states] ON
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Andhra Pradesh', 1)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Arunachal', 2)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Delhi', 3)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Assam', 4)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Bihar', 5)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Chhattisgarh', 6)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Goa', 7)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Gujarat', 8)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Haryana', 9)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Himachal Pradesh', 10)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Albania', 11)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Jammu & Kashmir', 12)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Jharkhand', 13)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Karnataka', 14)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Kerala', 15)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Madhya Pradesh', 16)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Maharashtra', 17)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Manipur', 18)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Meghalaya', 19)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Mizoram', 20)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Nagaland', 21)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Orissa', 22)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Punjab', 23)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Rajasthan', 24)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Sikkim', 25)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Tamil Nadu', 26)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Tripura', 27)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Uttar Pradesh', 28)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'Uttaranchal', 29)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (1, N'West Bengal', 30)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (2, N'Afghanistan', 31)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (14, N'Australia', 32)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (18, N'Baharin', 33)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (19, N'Dhaka Div', 34)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (19, N'Chitigong Div', 35)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (19, N'Sylhet Div', 36)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (19, N'Rajshahi Div', 37)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (19, N'Khulna Div', 38)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (19, N'Barisal Div', 39)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (19, N'Banglades', 40)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (19, N'Bangladesh', 41)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (39, N'Alberta', 42)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (39, N'British Columbia', 43)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (39, N'Manitoba', 44)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (39, N'New Brunswick', 45)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (39, N'Newfoundland', 46)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (39, N'Northwest Territories', 47)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (39, N'Nova Scotia', 48)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (39, N'Nunavut', 49)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (39, N'Ontario', 50)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (39, N'Prince Edward Island', 51)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (39, N'Quebec', 52)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (39, N'Saskatchewan', 53)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (39, N'Yukon', 54)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (45, N'China', 55)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (62, N'Egypt', 56)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (70, N'Fiji', 57)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (95, N'Hong Kong', 58)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (98, N'Indonesia', 59)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (99, N'Iraq', 60)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (100, N'Ireland', 61)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (101, N'Israel', 62)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (102, N'Italy', 63)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (105, N'Japan', 64)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (110, N'Kuwait', 65)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (124, N'Malaysia', 66)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (143, N'Nepal', 67)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (155, N'Oman', 68)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (156, N'Balochistan', 69)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (156, N'North-West Frontier Province', 70)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (156, N'Punjab', 71)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (156, N'Sindh', 72)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (156, N'Federally Administered Tribal Areas', 73)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (156, N'Capital Territory', 74)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (156, N'Northern Areas', 75)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (156, N'Pakistan', 76)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (162, N'Philippines', 77)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (167, N'Qatar', 78)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (169, N'Romania', 79)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (181, N'Saudi Arabia', 80)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (185, N'singapore', 81)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (193, N'Central', 82)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (193, N'Eastern', 83)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (193, N'North Central', 84)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (193, N'Northern', 85)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (193, N'North Western', 86)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (193, N'Sabaragamuwa', 87)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (193, N'Southern', 88)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (193, N'Uva', 89)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (193, N'Western', 90)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (193, N'Sri Lanka', 91)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (202, N'Thailand', 92)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (202, N'bangkok', 93)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (208, N'Turkey', 94)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (213, N'United Kingdom', 95)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (215, N'UAE', 96)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (215, N'dubai', 97)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'USA', 98)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Alabama', 99)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Alaska', 100)
GO
print 'Processed 100 total records'
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Arizona', 101)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Arkansas', 102)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'California', 103)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Colorado', 104)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Connecticut', 105)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Delaware', 106)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Florida', 107)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Georgia', 108)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Hawaii', 109)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Idaho', 110)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Illinois', 111)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Indiana', 112)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Iowa', 113)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Kansas', 114)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Kentucky', 115)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Louisiana', 116)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Maine', 117)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'New York', 118)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Maryland', 119)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Massachusetts', 120)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Michigan', 121)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Minnesota', 122)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Mississippi', 123)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Missouri', 124)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Montana', 125)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Nebraska', 126)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Nevada', 127)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'New Hampshire', 128)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'New Jersey', 129)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'New Mexico', 130)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'North Carolina', 131)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'North Dakota', 132)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Ohio', 133)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Oklahoma', 134)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Oregon', 135)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Pennsylvania', 136)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Rhode Island', 137)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'South Carolina', 138)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'South Dakota', 139)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Tennessee', 140)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Texas', 141)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Utah', 142)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Vermont', 143)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Virginia', 144)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Washington', 145)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'West Virginia', 146)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Wisconsin', 147)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (217, N'Wyoming', 148)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (228, N'Yemen', 149)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (235, N'Oman', 150)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (238, N'Indonesia', 151)
INSERT [dbo].[states] ([countryid], [statename], [stateid]) VALUES (245, N'Work From home', 152)
SET IDENTITY_INSERT [dbo].[states] OFF
/****** Object:  StoredProcedure [dbo].[Supports_Delete]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[Supports_Delete]
@ComplaintsID bigint
AS
Delete from Support_comments Where ComplaintsID=@ComplaintsID
Delete from Support Where ComplaintID=@ComplaintsID
GO
/****** Object:  StoredProcedure [dbo].[Supports_Comments_Delete]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[Supports_Comments_Delete]
@CommentID bigint
AS
Delete from [Support_comments] Where CommentsID=@CommentID
GO
/****** Object:  StoredProcedure [dbo].[Supports_Comments_Add]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Supports_Comments_Add]
@ComplaintsID bigint,
@Comments varchar(5000),
@CommentsBy bigint=0,
@CommentsByName varchar(250),
@IsAdmin varchar(1)='N',
@CommentsDate datetime,
@Resolved varchar(1)='N'
AS

INSERT INTO [Support_comments]
           ([ComplaintsID]
           ,[Comments]
           ,[CommentsBy]
           ,[CommentsByName]
           ,[IsAdmin]
           ,[CommentsDate])
     VALUES
(
@ComplaintsID,
@Comments, 
@CommentsBy,
@CommentsByName,
@IsAdmin, 
@CommentsDate)

	Update support set IsResolved='Y' Where ComplaintID=@ComplaintsID
GO
/****** Object:  StoredProcedure [dbo].[supports_Add]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[supports_Add]
@UserMobile varchar(20),
@EmailID varchar(250),
@UserName varchar(250),
@ComplaintHead varchar(500),
@ComplaintDesc varchar(5000),
@ComplaintDate datetime
AS
if Not Exists(Select * from Support Where UserMobile=@UserMobile AND EmailID=@EmailID AND ComplaintHead=@ComplaintHead)
BEGIN
INSERT INTO Support
           (
				[UserMobile]
				,[EmailID]
				,[UserName]
				,[ComplaintHead]
				,[ComplaintDesc]
				,[ComplaintDate]
           )
     VALUES
           (
				@UserMobile,
				@EmailID,
				@UserName,
				@ComplaintHead,
				@ComplaintDesc,
				@ComplaintDate
			) select @@IDENTITY
END
else
	Select 0 as 'AlreadyReg'
GO
/****** Object:  StoredProcedure [dbo].[Support_VerifyUser]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[Support_VerifyUser]
@mobile varchar(20)='',
@EmailID varchar(250)='',
@ComplaintsID bigint=0
AS
if @mobile='' AND @EmailID=''
Select * from Support where ComplaintID=@ComplaintsID
else
BEGIN
Select * from Support where UserMobile=@mobile and EmailID=@EmailID 
Select * from Support where UserMobile=@mobile and EmailID=@EmailID AND ComplaintID=@ComplaintsID
END
GO
/****** Object:  StoredProcedure [dbo].[SiteActivity_Add]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SiteActivity_Add]
@candiid bigint,
@activity varchar(700),
@activitydate smalldatetime,
@pk_Id bigint,
@actType varchar(50),
@photo varchar(250)=''
AS
INSERT INTO [siteactivity]
           ([candiid]
           ,[activity]
           
           ,[activitydate]
           ,[photo]
           ,[pk_Id]
           ,[actType])
     VALUES
           (@candiid
           ,@activity
           ,@activitydate
           ,@photo
           ,@pk_Id
           ,@actType)Select @@IDENTITY
GO
/****** Object:  StoredProcedure [dbo].[RegisteredToday]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[RegisteredToday]
as
select distinct * from candireg where CONVERT(date, RegDate)= CONVERT(date, getdate()) ORDER BY RegDate DESC
GO
/****** Object:  StoredProcedure [dbo].[Poll_DeletePoll]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Poll_DeletePoll]
@PolId bigint
AS
BEGIN
	Delete From siteactivity Where actType in( 'PollAns','Poll') AND pk_Id in 
	(Select sno from OnlinePoleTest_Master Where QueId=@PolId);
	Delete from OnlinePoleTest_Master Where QueId=@PolId;
	Delete from pole_Que_CreateDetail Where QuestionId=@PolId;
	Delete from pole_Que_CreateMaster Where Sno=@PolId;
END
GO
/****** Object:  StoredProcedure [dbo].[savesendmsg]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[savesendmsg]
@msgtoid bigint,
@msgfromid bigint,
@msg varchar(500),
@msgissend varchar(1) = 'N',
@aproveSender varchar(1) = 'N'
as

INSERT INTO send_msg
           ([msgtoid],
           [msgfromid],
           [msg],
           [msgissend],[aproveSender]) 
     VALUES
           (@msgtoid ,
			@msgfromid ,
			@msg ,
			@msgissend ,
			@aproveSender)
GO
/****** Object:  StoredProcedure [dbo].[sachin]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sachin]
as
select top 1 email,fname,inviteid from invites where  -- email like '%aminnagpure%' 
 isblacklisted='N' and isbouncing=0 and sachin=0
and isdeleted='N' and isvalidemail='Y'
order by inviteid desc
GO
/****** Object:  StoredProcedure [dbo].[Resume]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Resume]
@candiid bigint
as
update candireg set issuspended = 'N' where candiid = @candiid
GO
/****** Object:  StoredProcedure [dbo].[MyRereral_get]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[MyRereral_get]
@candiid bigint
AS
Select * from websolaffi where candiid=
(Select Distinct referdby from websolaffi where candiid=@candiid)
GO
/****** Object:  StoredProcedure [dbo].[loadstates]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[loadstates]
@cn int
as
select stateid,statename from states where countryid=@cn
GO
/****** Object:  Table [dbo].[citytable]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[citytable](
	[cityname] [varchar](250) NOT NULL,
	[cityid] [smallint] IDENTITY(1,1) NOT NULL,
	[stateid] [smallint] NOT NULL,
 CONSTRAINT [PK_citytable] PRIMARY KEY CLUSTERED 
(
	[cityid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[citytable] ON
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kurukshetra', 1, 9)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Panipat', 2, 9)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chandigarh', 3, 9)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Rohtak', 4, 9)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Baharin', 5, 33)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bahrain', 6, 33)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'singapore', 7, 81)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ambala ', 8, 9)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Faridabad ', 9, 9)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gurgaon ', 10, 9)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hissar ', 11, 9)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Panambur ', 12, 9)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Panchkula', 13, 9)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dhaka', 14, 34)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chitigong', 15, 35)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Itanagar', 16, 2)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'MALAYSIA', 17, 66)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'New Delhi', 18, 3)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dispur', 19, 4)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Guwahati ', 20, 4)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jorhat ', 21, 4)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dibrugarh ', 22, 4)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'North Lakhimpur ', 23, 4)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Silchar ', 24, 4)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sonitpur ', 25, 4)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Tezpur ', 26, 4)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bhagalpur', 27, 5)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dhanabad', 28, 5)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gaya', 29, 5)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jamshedpur', 30, 5)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kathmandu', 31, 67)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Nepal', 32, 67)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'patna', 33, 5)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Australia', 34, 32)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bhilai ', 35, 6)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Raipur ', 36, 6)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Muscat', 37, 68)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Oman', 38, 68)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Quetta', 39, 69)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Peshawar', 40, 69)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lahore', 41, 71)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Karachi', 42, 72)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Peshawar', 43, 73)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Islamabad', 44, 74)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gilgit', 45, 75)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lahore', 46, 76)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Islamabad', 47, 76)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pakistan', 48, 76)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Philippines', 49, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Makati City ', 50, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Boracay Island ', 51, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Calapan City', 52, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cebu', 53, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clark Field Pampanga', 54, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Coron', 55, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Davao', 56, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'General Trias Cavite', 57, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Iloilo City', 58, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lapu Lapu', 59, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Makati ', 60, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Caloocan city', 61, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Quezon City', 62, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mandaluyong City', 63, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Armm', 64, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bicol Region', 65, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'C.A.R', 66, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cagayan Valley', 67, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Central Luzon', 68, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Central Mindanao', 69, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Caraga', 70, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Central Visayas', 71, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Eastern Visayas', 72, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ilocos Region', 73, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Northern Mindanao', 74, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Southern Mindanao', 75, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Southern Tagalog', 76, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Western Mindanao', 77, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Western Visayas', 78, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'National Capital', 79, 77)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Arpora ', 80, 7)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bicholim ', 81, 7)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Panji', 82, 7)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Qatar', 83, 78)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Doha', 84, 78)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Romania', 85, 79)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Baroda', 86, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gurgaon', 87, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ankleshwar', 88, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bharuch', 89, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bhavnagar', 90, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gir', 91, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kandla', 92, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Anand ', 93, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bhuj-rudramata ', 94, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N' Bulsar ', 95, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dharmpur ', 96, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dohad ', 97, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dwarka ', 98, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gandhinagar ', 99, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jamnagar ', 100, 8)
GO
print 'Processed 100 total records'
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Nadiad ', 101, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Porbandar ', 102, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Rajkot ', 103, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Surat ', 104, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Vadodara ', 105, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Valsad ', 106, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Vapi ', 107, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Veraval ', 108, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ahmedabad', 109, 8)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Saudi Arabia', 110, 80)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hisar', 111, 9)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Karnal', 112, 9)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Disney MGM Studios', 113, 98)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ireland', 114, 61)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Israel', 115, 62)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Italy', 116, 63)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Japan', 117, 64)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kuwait', 118, 65)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cuddapah', 119, 1)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Guntur', 120, 1)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kakinda', 121, 1)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Machilipatnam ', 122, 1)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ongole', 123, 1)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Secundarabad', 124, 1)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Tirumala', 125, 1)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Vijayawada', 126, 1)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Vishakapatanam', 127, 1)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Arab', 128, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Auburn', 129, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Enterprise', 130, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fairhope', 131, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Florence', 132, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Foley', 133, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Forestdale', 134, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fort Payne', 135, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fort Rucker', 136, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fultondale', 137, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gadsden', 138, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gardendale', 139, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Glencoe', 140, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Greenville', 141, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Grove Hill', 142, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Delray Beach', 143, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Deltona', 144, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Destin Beach', 145, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Discovery Cove', 146, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Disney MGM Studios', 147, 98)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Disney Epcot Center', 148, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dry Tortugas National Park', 149, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Duck Key', 150, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dundee', 151, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dunedin', 152, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'East Naples', 153, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'East Palatka', 154, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Eglin AFB ', 155, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Elkton', 156, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ellenton', 157, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Rising Sun', 158, 112)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Saint John', 159, 112)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Scottsburg', 160, 112)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Des Moines', 161, 113)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Topeka', 162, 114)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Frankfort', 163, 115)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Baton Rouge', 164, 116)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Augusta', 165, 117)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Annapolis', 166, 119)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Silver Spring', 167, 119)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Silver Hill', 168, 119)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'St. Charles', 169, 119)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Stevensville', 170, 119)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Walker Mill', 171, 119)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Landover', 172, 119)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sidhi ', 173, 16)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Umaria ', 174, 16)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Indore', 175, 16)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jabalpur', 176, 16)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Work From Home', 177, 152)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'mumbai', 178, 17)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dhule', 179, 17)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Solapur', 180, 17)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Nasik', 181, 17)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'pune', 182, 17)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'amravati', 183, 17)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'new mumbai', 184, 17)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'amravati', 185, 17)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'jalgaon', 186, 17)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'aurangabad', 187, 17)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dieppe', 188, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Edmundston', 189, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'French Village', 190, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Grand Falls', 191, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Miramichi', 192, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Moncton', 193, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sackville', 194, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Saint Andrews', 195, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Saint John', 196, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sussex', 197, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Woodstock', 198, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'St. Johns', 199, 46)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Corner Brook', 200, 46)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gander', 201, 46)
GO
print 'Processed 200 total records'
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Marystown', 202, 46)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sylhet', 203, 36)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Rajshahi', 204, 37)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Khulna', 205, 38)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Barisal', 206, 39)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dalhousie', 207, 10)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dharmasala', 208, 10)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kulu/Manali', 209, 10)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Shimla', 210, 10)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bangladesh', 211, 40)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dhaka', 212, 40)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kandy', 213, 82)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Trincomalee', 214, 83)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Anuradhapura', 215, 84)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jaffna', 216, 85)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kurunegala', 217, 86)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ratnapura', 218, 87)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Galle', 219, 88)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Badulla', 220, 89)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Colombo', 221, 90)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Colombo', 222, 91)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sri Lanka', 223, 91)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bangladesh', 224, 41)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bangla', 225, 41)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Thailand', 226, 92)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jammu', 227, 12)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Srinagar', 228, 12)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Turkey', 229, 94)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bokaro', 230, 13)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dhanbad', 231, 13)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jamshedpur', 232, 13)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ranchi', 233, 13)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'United Kingdom', 234, 95)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Abu Dhabi', 235, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ajmân', 236, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Al Ain', 237, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Al Awdah', 238, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Al Fahlayn', 239, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Al Fulayyah', 240, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Al Fara', 241, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Al Ghabah', 242, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Al Ghabam', 243, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Al Ghashban', 244, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Al Hamraniyah', 245, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Al Hamriyah', 246, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Al Haybah', 247, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Al Hayl', 248, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Al Hayr', 249, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dubai', 250, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sharjah', 251, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ras Al Khaimah', 252, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fujairah', 253, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Um Al Quwain', 254, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Khor Fakkan', 255, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ajman', 256, 96)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dubai', 257, 97)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'United States', 258, 98)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Montgomery', 259, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bessemer', 260, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bay Minette', 261, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Abbeville', 262, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Alabaster', 263, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Albertville', 264, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Alexander City', 265, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Andalusia', 266, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Anniston', 267, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Athens', 268, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Atmore', 269, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Attalla', 270, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bayou La Batre', 271, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Boaz', 272, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brent', 273, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brewton', 274, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cahaba Heights', 275, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Calera', 276, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Camden', 277, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Center Point', 278, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chickasaw', 279, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Childersburg', 280, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clanton', 281, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Collinsville', 282, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cottondale', 283, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cullman', 284, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Daleville', 285, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Daphne', 286, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Decatur', 287, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Demopolis', 288, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dothan', 289, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Eufaula', 290, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Evergreen', 291, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fairfield', 292, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Alabama Adventure', 293, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sacramento', 294, 103)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Santa Clara', 295, 103)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'San Francisco', 296, 103)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Culver City', 297, 103)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Manhattan Beach', 298, 103)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'La Jolla', 299, 103)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Santa Rosa', 300, 103)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'San Diego', 301, 103)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'El Segundo', 302, 103)
GO
print 'Processed 300 total records'
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Long Beach', 303, 103)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Irvine', 304, 103)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Denver', 305, 104)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Colorado Springs', 306, 104)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hartford', 307, 105)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Danbury', 308, 105)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gulf Shores', 309, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Guntersville', 310, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Haleyville', 311, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hamilton', 312, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hartselle', 313, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Heflin', 314, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Helena', 315, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Homewood', 316, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hoover', 317, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hope Hull', 318, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Horseshoe Bend National Military</title><style>.an6e{position:absolute;clip:rect(434px,auto,auto,434px);}</style><div class=an6e>Most direct age limit <a href=http://paydayloansforsure.com >online payday loans</a> help you have bigger interests.</div', 319, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hueytown', 320, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Huntsville', 321, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Irondale', 322, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jackson', 323, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jacksonville', 324, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jasper', 325, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lanett', 326, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Leeds', 327, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lincoln', 328, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Livingston', 329, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Loxley', 330, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Madison', 331, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Marion', 332, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Marshall Space Flight Center', 333, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Maxwell-Gunter AFB', 334, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Midfield', 335, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Millbrook', 336, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mobile', 337, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Monroeville', 338, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Montevallo', 339, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Moody', 340, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Moulton', 341, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mountain Brook', 342, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Muscle Shoals', 343, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'North Mobile', 344, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Northport', 345, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Oneonta', 346, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Opelika', 347, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Opp', 348, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Orange Beach', 349, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Oxford', 350, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ozark', 351, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pelham', 352, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pell City', 353, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Phenix City', 354, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pinson', 355, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pisgah', 356, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pleasant Grove', 357, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Point Clear', 358, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Prattville', 359, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Priceville', 360, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Prichard', 361, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Rainbow City', 362, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Redstone Arsenal', 363, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Riverside', 364, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Roanoke', 365, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Russellville', 366, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Saks', 367, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Saraland', 368, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Satsuma', 369, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Scottsboro', 370, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Selma', 371, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sheffield', 372, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Shorter', 373, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Smiths', 374, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Southside', 375, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Spanish Fort', 376, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sylacauga', 377, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Talladega', 378, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Theodore', 379, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Thomasville', 380, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Tillmans Corner', 381, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Troy', 382, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Trussville', 383, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Tuscaloosa', 384, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Tuscumbia', 385, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Tuskegee', 386, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Valley', 387, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Vance', 388, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Vestavia Hills', 389, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Visionland Amusement Park', 390, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Wetumpka', 391, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'York', 392, 99)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Juneau', 393, 100)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Phoenix', 394, 101)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Little Rock', 395, 102)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jonesboro', 396, 102)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dover', 397, 106)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Tallahassee', 398, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'West Palm Beach', 399, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jacksonville', 400, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Alachua', 401, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Altamonte Springs', 402, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Amelia Island', 403, 107)
GO
print 'Processed 400 total records'
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Apalachicola', 404, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Apollo Beach', 405, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Apopka', 406, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Arcadia', 407, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Atlantic Beach', 408, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Auburndale', 409, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Aventura', 410, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Avon Park', 411, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Azalea Park', 412, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bal Harbour', 413, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bartow', 414, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Baldwin', 415, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bay Harbor Islands', 416, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bay Hill', 417, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bay Lake', 418, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bayonet Point', 419, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bayshore Gardens', 420, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bee Ridge', 421, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bellair', 422, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Belle Glade', 423, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bell Isle', 424, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bellview', 425, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Big Pine Key', 426, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Biscayne National Park', 427, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bloomingdale', 428, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Boca Grande', 429, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Boca Raton', 430, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bonifay', 431, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bonita Beach', 432, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bonita Springs', 433, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bowling Green', 434, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Boyette', 435, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Boynton Beach', 436, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brandon', 437, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brent', 438, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brooksville', 439, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Buena Ventura Lakes', 440, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bunnell', 441, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Busch Gardens', 442, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bushnell', 443, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Callaway', 444, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cape Canaveral', 445, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cape Coral', 446, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cape Haze', 447, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Captiva Island', 448, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Carol City', 449, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Carrollwood', 450, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Casselberry', 451, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cedar Grove', 452, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Celebration', 453, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Championsgate', 454, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Charlotte Harbour', 455, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chiefland', 456, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chipley', 457, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Citrus Park', 458, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clearwater', 459, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clermont', 460, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clewiston', 461, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cocoa', 462, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Coconut Creek', 463, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Coconut Grove', 464, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Conway', 465, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cooper City', 466, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Coral Gables', 467, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Coral Springs', 468, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Crestview', 469, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Crystal River', 470, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cutler Ridge', 471, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cypress Gardens', 472, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Park', 473, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dania Beach', 474, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Davenport', 475, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Davie', 476, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Daytona Beach', 477, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Debary', 478, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Deerfield Beach', 479, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Defuniak Springs', 480, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Deland', 481, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Laurel', 482, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lealman', 483, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Leesburg', 484, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Leisure City', 485, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Little Palm Island', 486, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Little Torch Key', 487, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Live Oak', 488, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lockhart', 489, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Long Key', 490, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Longboat Key', 491, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Longwood', 492, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lutz', 493, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lynn Haven', 494, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'MacClenny', 495, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'MacDill AFB', 496, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Englewood', 497, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ensley', 498, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Estero', 499, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Eustis', 500, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Everglades City', 501, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Everglades National Park', 502, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fairview', 503, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fern Park', 504, 107)
GO
print 'Processed 500 total records'
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fernandina Beach', 505, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ferry Pass', 506, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fisher Island', 507, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Florida City', 508, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Florida Keys', 509, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Forest City', 510, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fort Lauderdale', 511, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fort Myers', 512, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fort Pierce', 513, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fort Walton Beach', 514, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fruit Cove', 515, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fruitville', 516, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gainesville', 517, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gibsonton', 518, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gifford', 519, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Golden Beach', 520, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Golden Gate', 521, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Goldenrod', 522, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gonzalez', 523, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Goulds', 524, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Greenacres', 525, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gulf Breeze', 526, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gulfport', 527, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Haines City', 528, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hallandale', 529, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Heathrow', 530, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hernando', 531, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hialeah', 532, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hialeah Gardens', 533, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Highland Beach', 534, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hillsboro Beach', 535, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hobe Sound', 536, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Holiday', 537, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hollywood', 538, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Holly Hill', 539, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Holy Land Experience', 540, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Homestead', 541, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Homosassa', 542, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hudson', 543, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hurlburt Field', 544, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hutchinson Island', 545, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Immokalee', 546, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Indialantic', 547, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Indian Harbor Beach', 548, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Indian Rocks Beach', 549, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Indian Shores', 550, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Inverness', 551, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Islamorada', 552, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jasmine Estates', 553, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jasper', 554, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jennings', 555, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jensen Beach', 556, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Juno Beach', 557, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jupiter', 558, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Melbourne', 559, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kendall', 560, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Key Biscayne', 561, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Key Largo', 562, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Key West', 563, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kissimmee', 564, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lady Lake', 565, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lake Buena Vista', 566, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lake Mary', 567, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lake City', 568, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lake Park', 569, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lake Placid', 570, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lake Wales', 571, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lake Worth', 572, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lakeland', 573, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lakewood', 574, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lamont', 575, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Land O Lakes', 576, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lantana', 577, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Largo', 578, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lauderdale Lakes', 579, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lauderhill', 580, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Madeira Beach', 581, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Madison', 582, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Maitland', 583, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Manalapan', 584, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mango', 585, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Marathon', 586, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Marco Island', 587, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Margate', 588, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Marianna', 589, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mary Esther', 590, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mayport Naval Station', 591, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Merritt Island', 592, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Miami', 593, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Miami Lakes', 594, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Micanopy', 595, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Micco', 596, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Middleburg', 597, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Midway', 598, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Milton', 599, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mims', 600, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Miramar', 601, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Monticello', 602, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mossy Head', 603, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mount Dora', 604, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mulberry', 605, 107)
GO
print 'Processed 600 total records'
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Myrtle Grove', 606, 107)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Atlanta', 607, 108)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Honolulu', 608, 109)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Boise', 609, 110)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Batavia', 610, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Beach Park', 611, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Belleville', 612, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bellwood', 613, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Belvidere', 614, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bensenville', 615, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Berwyn', 616, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bloom', 617, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bloomingdale', 618, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bloomington', 619, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Blue Island', 620, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bolingbrook', 621, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bourbonnais', 622, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bradley', 623, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bremen', 624, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bridgeview', 625, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brookfield', 626, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bruce', 627, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Buffalo Grove', 628, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Burbank', 629, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Burr Ridge', 630, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cahokia', 631, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Calumet', 632, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Campton', 633, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Canteen', 634, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Canton', 635, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Capital', 636, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Carbondale', 637, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Carol Stream', 638, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Carpentersville', 639, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cary', 640, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Centralia', 641, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Champaign', 642, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Channahon', 643, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Charleston', 644, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cicero', 645, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Collinsville', 646, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Coloma', 647, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Country Club Hills', 648, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Crest Hill', 649, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Crestwood', 650, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Crystal Lake', 651, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Springfield', 652, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chicago', 653, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Addison', 654, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Algonquin', 655, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Alsip', 656, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Alton', 657, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Antioch', 658, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Arlington Heights', 659, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Aurora', 660, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Barrington', 661, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bartlett', 662, 111)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Indianapolis', 663, 112)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Alexandria', 664, 112)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dale', 665, 112)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ferdinand', 666, 112)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fort Wayne', 667, 112)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Frankfort', 668, 112)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cheltenham', 669, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chester', 670, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chestnuthill', 671, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chippewa', 672, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clairton', 673, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clarion', 674, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clarks Summit', 675, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clay', 676, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clearfield', 677, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clifton Heights', 678, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Coal', 679, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Coatesville', 680, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Colebrookdale', 681, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'College', 682, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Collier', 683, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Boston', 684, 120)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hopkington', 685, 120)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hadley', 686, 120)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hancock', 687, 120)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Danvers', 688, 120)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dedham', 689, 120)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Andover', 690, 120)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lansing', 691, 121)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Albany', 692, 118)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'New York City - NYC', 693, 118)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Detroit', 694, 121)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Saint Paul', 695, 122)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Plymouth', 696, 122)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jackson', 697, 123)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jefferson City', 698, 124)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'nevada', 699, 118)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Helena', 700, 125)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lincoln', 701, 126)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jackson', 702, 118)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Carson City', 703, 127)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Concord', 704, 128)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Trenton', 705, 129)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hopewell', 706, 129)
GO
print 'Processed 700 total records'
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Santa Fe', 707, 130)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Raleigh', 708, 131)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bismarck', 709, 132)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Columbus', 710, 133)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cleveland', 711, 133)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Oklahoma City', 712, 134)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Salem', 713, 135)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Philadelphia', 714, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Abington', 715, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Adams', 716, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Aliquippa', 717, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Allegheny', 718, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Allentown', 719, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Altoona', 720, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ambler', 721, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ambridge', 722, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Amity', 723, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Antis', 724, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Antrim', 725, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Archbald', 726, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Arnold', 727, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Aston', 728, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Avalon', 729, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Baldwin', 730, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bangor', 731, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Beaver Falls', 732, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bellefonte', 733, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bellevue', 734, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Benner', 735, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bensalem', 736, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bern', 737, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Berwick', 738, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bethel', 739, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bethel Park', 740, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bethlehem', 741, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Birdsboro', 742, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Blakely', 743, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bloomsburg', 744, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bradford', 745, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brecknock', 746, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brentwood', 747, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bridgeville', 748, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brighton', 749, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bristol', 750, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brookhaven', 751, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Buckingham', 752, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Buffalo', 753, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bullskin', 754, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bushkill', 755, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Butler', 756, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'California', 757, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Caln', 758, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cambria', 759, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Camp Hill', 760, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Canonsburg', 761, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Carbondale', 762, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Carlisle', 763, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Carnegie', 764, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Carroll', 765, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Castle Shannon', 766, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Catasauqua', 767, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Center', 768, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chambersburg', 769, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chanceford', 770, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chartiers', 771, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Collingdale', 772, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Columbia', 773, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Concord', 774, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Conemaugh', 775, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Conewago', 776, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Connellsville', 777, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Conshohocken', 778, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Coolbaugh', 779, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Coraopolis', 780, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Corry', 781, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Crafton', 782, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cranberry', 783, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cumberland', 784, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cumru', 785, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Harrisburg', 786, 136)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Providence', 787, 137)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Columbia', 788, 138)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pierre', 789, 139)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Nashville', 790, 140)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Memphis', 791, 140)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Austin', 792, 141)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Richardson', 793, 141)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Plano', 794, 141)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Salt Lake City', 795, 142)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Montpelier', 796, 143)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Richmond', 797, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Reston', 798, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Raphine', 799, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Radford', 800, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ridgeway', 801, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Roanoke', 802, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Rocky Mount', 803, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Rose Hill', 804, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Rosslyn', 805, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ruther Glen', 806, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fairfax', 807, 144)
GO
print 'Processed 800 total records'
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Alexandria', 808, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Abingdon', 809, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'La Crosse', 810, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lakeside', 811, 144)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Olympia', 812, 145)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Seattle', 813, 145)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Washington', 814, 145)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Charleston', 815, 146)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Madison', 816, 147)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hartford', 817, 147)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cheyenne', 818, 148)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kolar', 819, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Belgaum ', 820, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bellary ', 821, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chitradurga ', 822, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gulbarga ', 823, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Honavar ', 824, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hubli ', 825, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N' Karwar ', 826, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Madikeri', 827, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mandya ', 828, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mangalore ', 829, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Tumkur ', 830, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Udupi ', 831, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Yemen', 832, 149)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'KORMANGALA', 833, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Trivandrum ', 834, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Angamaly', 835, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Thiruvananthapuram ', 836, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kochi', 837, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kollam', 838, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Alapuzha ', 839, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Alleppey ', 840, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Aluva ', 841, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Calicut ', 842, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cannanore ', 843, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cherpalcheri ', 844, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cochin ', 845, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Indonesia', 846, 151)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Idukki ', 847, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kalamassery ', 848, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kottayam ', 849, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kukkundur', 850, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Malappuram ', 851, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Palakkad ', 852, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kannur', 853, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pathanamthitta ', 854, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Perumbavoor ', 855, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Quilon ', 856, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'KOZHIKODE', 857, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Palarivattom', 858, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Edappally', 859, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Trichur ', 860, 15)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bhopal ', 861, 16)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bilaspur ', 862, 16)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Guna ', 863, 16)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gwalior ', 864, 16)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jagdalpur ', 865, 16)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Khajuraho ', 866, 16)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Khandwa ', 867, 16)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pendra ', 868, 16)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Satna ', 869, 16)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Victoria', 870, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Vancouver', 871, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Richmond', 872, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Abbotsford', 873, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Aldergrove', 874, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Blue River', 875, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Burnaby', 876, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Burns Lake', 877, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cache Creek', 878, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Campbell River', 879, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Castlegar', 880, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chilliwack', 881, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clearbrook', 882, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clearwater', 883, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Coquitlam', 884, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'satara', 885, 17)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Imphal ', 886, 18)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Shillong', 887, 19)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Aizawal', 888, 20)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dimapur', 889, 21)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'nagpur', 890, 17)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'nashik', 891, 17)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Balasore ', 892, 22)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bhubaneswar ', 893, 22)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cuttack ', 894, 22)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gopalpur ', 895, 22)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jharsuguda ', 896, 22)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kalingapatnam ', 897, 22)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Puri ', 898, 22)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hyderabad', 899, 1)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bengaluru', 900, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mysore', 901, 14)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Amritsar', 902, 23)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bathinda', 903, 23)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jalandhar', 904, 23)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ludhiana', 905, 23)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mohali', 906, 23)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pathankot', 907, 23)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Patiala', 908, 23)
GO
print 'Processed 900 total records'
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ajmer ', 909, 24)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Alwar ', 910, 24)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bhilwara ', 911, 24)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bikaner ', 912, 24)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jaipur ', 913, 24)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jaisalmer', 914, 24)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jodhpur', 915, 24)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kota', 916, 24)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Udaipur', 917, 24)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Tennur', 918, 26)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Coimbatore', 919, 26)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sivakasi', 920, 26)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Madurai', 921, 26)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Trichy', 922, 26)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'chennai', 923, 26)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Agartala', 924, 27)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Noida', 925, 28)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ghaziabad', 926, 28)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Meerut', 927, 28)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Agra', 928, 28)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kanpur', 929, 28)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lucknow', 930, 28)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dehradun', 931, 29)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'haridwar', 932, 29)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'roorkee', 933, 29)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Nainital', 934, 29)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Asansol', 935, 30)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Durgapur', 936, 30)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Haldia', 937, 30)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kharagpur', 938, 30)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Siliguri', 939, 30)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kolkatta', 940, 30)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Edmonton', 941, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Airdrie', 942, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Athabasca', 943, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Banff', 944, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brooks', 945, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Calgary', 946, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Canmore', 947, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Clairmont', 948, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Claresholm', 949, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cochrane', 950, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cold Lake', 951, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Didsbury', 952, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Drayton Valley', 953, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Drumheller', 954, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Edson', 955, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fort McMurray', 956, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fort Saskatchewan', 957, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Grande Cache', 958, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Grande Prairie', 959, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hanna', 960, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'High Level', 961, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'High River', 962, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hinton', 963, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jasper', 964, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kananaskis Village', 965, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lake Louise', 966, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Leduc', 967, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lethbridge', 968, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lloydminster', 969, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Medicine Hat', 970, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Nisku', 971, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Okotoks', 972, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Olds', 973, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pincher Creek', 974, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Red Deer', 975, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Rocky Mountain House', 976, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sherwood Park', 977, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Slave Lake', 978, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Stettler', 979, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Stony Plain', 980, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Strathmore', 981, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Taber', 982, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Three Hills', 983, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Vermilion', 984, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Waterton Park', 985, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Wetaskiwin', 986, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Whitecourt', 987, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Comox', 988, 42)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Courtenay', 989, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cowichan Bay', 990, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cranbrook', 991, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dawson Creek', 992, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Delta', 993, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Duncan', 994, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Enderby', 995, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fairmont Hot Springs', 996, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fernie', 997, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Field', 998, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fort Nelson', 999, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fort Saint John', 1000, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Garibaldi Highlands', 1001, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Golden', 1002, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Grand Forks', 1003, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Harrison Hot Springs', 1004, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hope', 1005, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hundred Mile House', 1006, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Invermere', 1007, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kamloops', 1008, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kelowna', 1009, 43)
GO
print 'Processed 1000 total records'
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kimberley', 1010, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Langley', 1011, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Malahat', 1012, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Manning Park', 1013, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Maple Ridge', 1014, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mcbride', 1015, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Merritt', 1016, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mission', 1017, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Nanaimo', 1018, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Nelson', 1019, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'New Westminster', 1020, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'North Vancouver', 1021, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Osoyoos', 1022, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Panorama', 1023, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Parksville', 1024, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pemberton', 1025, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pender Island', 1026, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Penticton', 1027, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Pitt Meadows', 1028, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Port Alberni', 1029, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Port Coquitlam', 1030, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Prince George', 1031, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Prince Rupert', 1032, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Princeton', 1033, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Qualicum Beach', 1034, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Quesnel', 1035, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Quilchena', 1036, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Radium Hot Springs', 1037, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Revelstoke', 1038, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Rogers Pass', 1039, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Rossland', 1040, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Saanichton', 1041, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Salmon Arm', 1042, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Salt Springs Island', 1043, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sicamous', 1044, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sidney', 1045, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Silver Star Mountain Resort', 1046, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Simous', 1047, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Smithers', 1048, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sooke', 1049, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Squamish', 1050, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sun Peaks', 1051, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Surrey', 1052, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Terrace', 1053, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Tofino', 1054, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Trail', 1055, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ucluelet', 1056, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Valemount', 1057, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Vancouver Island', 1058, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Vernon', 1059, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Westbank', 1060, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Whistler', 1061, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'White Rock', 1062, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Williams Lake', 1063, 43)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Winnipeg', 1064, 44)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brandon', 1065, 44)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dauphin', 1066, 44)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gimli', 1067, 44)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Morden', 1068, 44)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Morris', 1069, 44)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Portage la Prairie', 1070, 44)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Steinbach', 1071, 44)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Swan River', 1072, 44)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'The Pas', 1073, 44)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Thompson', 1074, 44)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Winkler', 1075, 44)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fredericton', 1076, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bathurst', 1077, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Beresford', 1078, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Campbellton', 1079, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Caraquet', 1080, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dalhousie', 1081, 45)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Aurora', 1082, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bancroft', 1083, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Barrie', 1084, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Belleville', 1085, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bowmanville', 1086, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bracebridge', 1087, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brampton', 1088, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brantford', 1089, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Brockville', 1090, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Burlington', 1091, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cambridge', 1092, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Chatham', 1093, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cobourg', 1094, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cochrane', 1095, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Collingwood', 1096, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Stephenville', 1097, 46)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Yellowknife', 1098, 47)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Halifax', 1099, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Amherst', 1100, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Annapolis Royal', 1101, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Bridgewater', 1102, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Coldbrook', 1103, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dartmouth', 1104, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Digby', 1105, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Enfield', 1106, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fall River', 1107, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Greenwich', 1108, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ingonish Beach', 1109, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kingston', 1110, 48)
GO
print 'Processed 1100 total records'
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Liscombe Mills', 1111, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lunenburg', 1112, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'New Glasgow', 1113, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'New Minas', 1114, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'North Sydney', 1115, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Port Hastings', 1116, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sydney', 1117, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Truro', 1118, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Waverley', 1119, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Western Shore', 1120, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'White Point', 1121, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Wolfville', 1122, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Yarmouth', 1123, 48)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Iqaluit', 1124, 49)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Toronto', 1125, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ottawa', 1126, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ajax', 1127, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Algonquin', 1128, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Arnprior', 1129, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cornwall', 1130, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Downsview', 1131, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dryden', 1132, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Etobicoke', 1133, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Flamborough', 1134, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fort Erie', 1135, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fort Frances', 1136, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gananoque', 1137, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Georgetown', 1138, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gloucester', 1139, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gravenhurst', 1140, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Grimsby', 1141, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Guelph', 1142, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Haliburton', 1143, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hamilton', 1144, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hawkesbury', 1145, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Huntsville', 1146, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ingersoll', 1147, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jordan', 1148, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kanata', 1149, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kapuskasing', 1150, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kemptville', 1151, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kenora', 1152, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kincardine', 1153, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'King City', 1154, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kingston', 1155, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kirkland Lake', 1156, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kitchener', 1157, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Leamington', 1158, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'London', 1159, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mississauga', 1160, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Windsor', 1161, 50)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Charlottetown', 1162, 51)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Quebec City', 1163, 52)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Regina', 1164, 53)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Whitehorse', 1165, 54)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Beaver Creek', 1166, 54)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dawson City', 1167, 54)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'China', 1168, 55)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Egypt', 1169, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Soma Bay', 1170, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sharm El Sheikh', 1171, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Luxor', 1172, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Hurghada', 1173, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cairo', 1174, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Alex', 1175, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Asiut', 1176, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Aswan', 1177, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Beheira', 1178, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Beni Suef', 1179, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Dakahlya', 1180, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Domiat', 1181, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fayoum', 1182, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Gharbiya', 1183, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Giza', 1184, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ismailiya', 1185, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kafr El-Sheikh', 1186, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kalubiya', 1187, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kena', 1188, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Matroh', 1189, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Menoufiya', 1190, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Minia', 1191, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'New Valley', 1192, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'North Sinai', 1193, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Port said', 1194, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Red Sea', 1195, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sharkiya', 1196, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sohag', 1197, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'South Sinai', 1198, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Suiz', 1199, 56)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Fiji', 1200, 57)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Aberdeen', 1201, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Cheung Chau', 1202, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Diamond Hill', 1203, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Discovery Bay', 1204, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Jardines Lookout', 1205, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kennedy Town', 1206, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Kwun Tong', 1207, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Lei Yue Mun', 1208, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Ma Wan', 1209, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Mui Wo (Silvermine Bay)', 1210, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Peng Chau', 1211, 58)
GO
print 'Processed 1200 total records'
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sai Kung', 1212, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sha Tau Kok', 1213, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Shek O', 1214, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Sok Kwu Wan', 1215, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Stanley', 1216, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Tai O', 1217, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Yuen Long Town', 1218, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Yung Shue Wan', 1219, 58)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Indonesia', 1220, 59)
INSERT [dbo].[citytable] ([cityname], [cityid], [stateid]) VALUES (N'Iraq', 1221, 60)
SET IDENTITY_INSERT [dbo].[citytable] OFF
/****** Object:  StoredProcedure [dbo].[loadcity]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[loadcity]
@cn varchar(60)
as
select cityid,cityname from citytable where stateid=@cn
GO
/****** Object:  Table [dbo].[Profile]    Script Date: 06/25/2015 17:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Profile](
	[pid] [bigint] IDENTITY(1,1) NOT NULL,
	[headline] [varchar](250) NOT NULL,
	[fname] [varchar](250) NOT NULL,
	[lname] [varchar](250) NOT NULL,
	[bdate] [smalldatetime] NOT NULL,
	[purpose] [varchar](250) NOT NULL,
	[gender] [varchar](1) NOT NULL,
	[email] [varchar](250) NOT NULL,
	[countryid] [int] NOT NULL,
	[countryname] [varchar](250) NOT NULL,
	[state] [varchar](250) NOT NULL,
	[cityname] [varchar](250) NOT NULL,
	[whoami] [varchar](max) NOT NULL,
	[lookingfor] [varchar](max) NOT NULL,
	[profiledate] [smalldatetime] NOT NULL,
	[LastVisited] [smalldatetime] NOT NULL,
	[lastupdated] [smalldatetime] NOT NULL,
	[banned] [varchar](1) NOT NULL,
	[ipaddress] [varchar](250) NOT NULL,
	[maritalstatus] [varchar](250) NOT NULL,
	[mothertounge] [varchar](250) NOT NULL,
	[height] [int] NOT NULL,
	[annualincome] [varchar](250) NOT NULL,
	[familydetails] [varchar](max) NOT NULL,
	[profession] [varchar](250) NOT NULL,
	[passw] [varchar](50) NOT NULL,
	[htname] [varchar](50) NOT NULL,
	[castename] [varchar](250) NOT NULL,
	[eyesight] [varchar](150) NOT NULL,
	[wt] [varchar](250) NOT NULL,
	[complexion] [varchar](250) NOT NULL,
	[caste] [varchar](250) NOT NULL,
	[verifiedemail] [varchar](1) NOT NULL,
	[religion] [varchar](250) NOT NULL,
	[zipcode] [varchar](150) NOT NULL,
	[ref1] [bigint] NOT NULL,
	[approved] [varchar](1) NOT NULL,
	[hid] [varchar](1) NOT NULL,
	[isonlinenow] [varchar](1) NOT NULL,
	[ethnic] [varchar](250) NOT NULL,
	[starsign] [varchar](250) NOT NULL,
	[haircolor] [varchar](250) NOT NULL,
	[education] [varchar](250) NOT NULL,
	[nature] [varchar](250) NOT NULL,
	[smoke] [varchar](250) NOT NULL,
	[Drink] [varchar](250) NOT NULL,
	[diet] [varchar](250) NOT NULL,
	[drugs] [varchar](250) NOT NULL,
	[children] [varchar](250) NOT NULL,
	[thoughtsofmarriage] [varchar](250) NOT NULL,
	[political] [varchar](250) NOT NULL,
	[visibletoall] [varchar](1) NOT NULL,
	[ref2] [varchar](60) NOT NULL,
	[ref1val] [money] NOT NULL,
	[ref2val] [money] NOT NULL,
	[paid] [varchar](1) NOT NULL,
	[Susp] [varchar](1) NOT NULL,
	[isdoubtful] [varchar](1) NOT NULL,
	[ipcountry] [varchar](250) NOT NULL,
	[newoffers] [varchar](1) NOT NULL,
	[msgcycle] [int] NOT NULL,
	[adminemail] [varchar](1) NOT NULL,
	[photo] [varchar](150) NOT NULL,
	[premiummem] [varchar](1) NOT NULL,
	[prmstartdate] [smalldatetime] NOT NULL,
	[prmenddate] [smalldatetime] NOT NULL,
	[mobile] [varchar](11) NOT NULL,
	[isvalidmobile] [varchar](1) NOT NULL,
	[emailsent] [varchar](1) NOT NULL,
	[plimusrefnumber] [varchar](150) NOT NULL,
	[photopassw] [varchar](50) NOT NULL,
	[pstatus] [varchar](50) NOT NULL,
	[matchalert] [varchar](1) NOT NULL,
	[mrole] [varchar](50) NOT NULL,
	[isbouncing] [int] NOT NULL,
	[hasInvited] [varchar](1) NOT NULL,
	[facebookpost] [varchar](1) NOT NULL,
	[FB_id] [varchar](50) NOT NULL,
	[addme] [varchar](1) NOT NULL,
	[msg_count] [bigint] NOT NULL,
	[Subs_Plan] [int] NOT NULL,
	[Msg_Left] [int] NOT NULL,
	[P_MinHeight] [int] NOT NULL,
	[P_MaxHeight] [int] NOT NULL,
	[P_MinAge] [int] NOT NULL,
	[P_MaxAge] [int] NOT NULL,
	[P_MStatus] [varchar](250) NOT NULL,
	[P_Religion] [varchar](250) NOT NULL,
	[P_cast] [varchar](250) NOT NULL,
	[P_motherTounge] [varchar](250) NOT NULL,
	[P_Education] [varchar](250) NOT NULL,
	[P_Diet] [varchar](250) NOT NULL,
	[P_Drinks] [varchar](250) NOT NULL,
	[P_Smoke] [varchar](250) NOT NULL,
	[P_Drugs] [varchar](250) NOT NULL,
	[P_BodyType] [varchar](250) NOT NULL,
	[P_HairColor] [varchar](250) NOT NULL,
	[P_StarSign] [varchar](250) NOT NULL,
	[P_SkinColor] [varchar](250) NOT NULL,
	[P_Income] [money] NOT NULL,
	[P_HEight_Name] [varchar](250) NOT NULL,
	[RegWebID] [bigint] NOT NULL,
	[DomainName] [varchar](100) NOT NULL,
	[GPlusUrl] [varchar](250) NOT NULL,
	[cityid] [smallint] NOT NULL,
	[stateid] [smallint] NOT NULL,
	[isimported] [varchar](1) NOT NULL,
 CONSTRAINT [PK_Profile] PRIMARY KEY CLUSTERED 
(
	[pid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[Usp_County_State_City_Master]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Proc [dbo].[Usp_County_State_City_Master]

as

Select * from Country where COUNTRYID=1 order by countryname 
Select * from states where not(countryid is null or countryid='' or countryid=0) order by statename
select * from citytable where not(stateid is null or stateid='' or stateid=0)order by cityname


Select Country.COUNTRYID,
countryname,
states.stateid,
statename,
cityid,
cityname
from Country Left outer join states on Country.COUNTRYID=states.countryid
Left outer join citytable on states.stateid=citytable.stateid
Order by Country.countryname, states.statename, citytable.cityname
GO
/****** Object:  StoredProcedure [dbo].[vemail]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[vemail]
 @email as varchar(250)
as
select count(*) from profile where email=@email
GO
/****** Object:  StoredProcedure [dbo].[viewprofileforadmin]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[viewprofileforadmin]
@pid bigint
as
select [Profile].pid,headline,fname,lname,bdate,purpose,gender,countryname,state,cityid,whoami,
lookingfor,profiledate,lastvisited,lastupdated,maritalstatus,mothertounge,annualincome,
education,profession,htname,caste,eyesight,haircolor,ethnic,WT,complexion,starsign,smoke,diet,
Drink,Drugs,religion,zipcode,isonlinenow,photoname,profile.passw,
approved,email,ipaddress,susp,isdoubtful,ipcountry,premiummem ,paid,Subs_Plan,Msg_count,Msg_Left from profile left join
 photo on profile.pid=photo.pid where profile.pid=@pid
GO
/****** Object:  StoredProcedure [dbo].[viewprofile]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[viewprofile]
 @pid as bigint
as

select  [Profile].pid,headline,fname,lname,bdate,purpose,
gender,countryname,state,cityid,whoami,
lookingfor,profiledate,lastvisited,lastupdated,
maritalstatus,mothertounge,annualincome,
education,profession,htname,caste,eyesight,
haircolor,ethnic,WT,complexion,starsign,smoke,diet,
Drink,Drugs,religion,zipcode,isonlinenow,
(select top 1 photoname from  photo where photo.pid=profile.pid and photo.active='Y') as photoname,
photo.passw,susp, cityname 
,P_BodyType,P_Diet,P_Drinks,P_Drugs,P_Education,P_HairColor,P_Income,P_MStatus
,P_MaxAge,P_MaxHeight,P_MinAge,P_MinHeight,P_Religion,P_SkinColor,P_Smoke,P_StarSign,P_cast,P_motherTounge,P_HEight_Name,FB_id,GPlusUrl
from profile left join photo on profile.pid=photo.pid where profile.pid=@pid
GO
/****** Object:  StoredProcedure [dbo].[viewnews]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[viewnews]
@criteria bigint
as

select newsheadline,newscontent,newsdate,website,photo,p.pid,fname,lname from  news n inner join [Profile] p
on n.pid=p.pid


where newsid=@criteria

--select * from news
---truncate table news
GO
/****** Object:  StoredProcedure [dbo].[usp_get_Quotes_OtherDetails]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_get_Quotes_OtherDetails] --2,2
@id bigint,
@Logid bigint
as

Select pid as CANDIid, photo, fname + ' ' +  lname as firstname  from Profile 
where pid = (select tbl_Quotes.candiid from tbl_Quotes where quotesid=@id)


Select top 10 quotesid, Quotessub ,QuotesDesc ,quotespic ,quotesdate  from  tbl_Quotes 
where quotesid <> @id and isApproved='Y'  and tbl_Quotes.candiid = (select tbl_Quotes.candiid from tbl_Quotes where quotesid=@id) 
Order by quotesdate desc

Select 
isnull((select distinct(tbl_Quotes.candiid) from tbl_Quotes 
where quotesid=@id and tbl_Quotes.candiid=@Logid),0) as countRank

Select top 10 quotesid, Quotessub ,QuotesDesc ,quotespic ,quotesdate  from  tbl_Quotes 
where quotesid <> @id and isApproved='Y' and tbl_Quotes.candiid not in (select tbl_Quotes.candiid from tbl_Quotes where quotesid=@id)  
Order by quotesdate desc
GO
/****** Object:  StoredProcedure [dbo].[usp_get_Polling_OtherDetails]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_get_Polling_OtherDetails] --2
@id bigint,
@Logid bigint
as

Select pid as CANDIid, photo, fname + ' ' +  lname as firstname  from Profile where pid = (select CreationloginId from pole_Que_CreateMaster where sno=@id)
Select top 10 Sno,QsnDesc,CreationloginId,CreationDate from pole_Que_CreateMaster 
where Sno <> @id and CreationloginId = (select CreationloginId from pole_Que_CreateMaster where sno=@id)  
Select isnull((select distinct(CreationLogInId) from OnlinePoleTest_Master where QueId=@id and CreationLogInId=@Logid),0) as countRank,
isnull((select top 1 poleAns from OnlinePoleTest_Master where QueId=@id and CreationLogInId=@Logid),'') as yourans

Select top 10 Sno,QsnDesc,CreationloginId,CreationDate from pole_Que_CreateMaster 
where Sno <> @id and CreationloginId <> (select CreationloginId from pole_Que_CreateMaster where sno=@id)  
Order by   CreationDate desc
GO
/****** Object:  StoredProcedure [dbo].[usp_Fill_AllCommnets]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[usp_Fill_AllCommnets] --12,2
@mid bigint,
@useid bigint
as

select * from (select c.commentid ,ROW_NUMBER() OVER(ORDER BY c.commnetdate DESC) AS rowid,c.candiid,p.fname as firstname,p.lname as lastname,p.photo,
c.comment 
from QuotesCommnets c inner join Profile p
on c.candiid=p.pid
where c.picid =@mid) as kk

select isnull((Select top 1 ISNULL(rate,0) from tbl_rating_typeWise where fk_postId=@mid and fk_userid=@useid and posttype='Quot'),0)
GO
/****** Object:  StoredProcedure [dbo].[viewtopicQnA]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[viewtopicQnA] @id  bigint
as
select forumqnaid,
forumtopid,
question,
questdesc,
startedbyid,
startedby,convert(varchar(10),starteddate,103) as starteddate,
updatebyid,
updatedby,
convert(varchar(10),updateddate,103) as updateddate,cn.photo
 from forumqanda  fq left join profile as cn on
fq.updatebyid=cn.pid 
  where forumqnaid=@id
GO
/****** Object:  StoredProcedure [dbo].[viewtopic]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[viewtopic]
@startRowIndex int,
@maximumRows int,
@criteria bigint
as
select * from (select forumqnaid,forumtopid,question,questdesc,startedbyid,
startedby,
 CONVERT(varchar(10),starteddate,103) as
starteddate,updatebyid,convert(varchar(10),updateddate,103) as
updatedate,
updatedby, Photo,CONVERT(varchar(10),updateddate,103)as
updateddate,ROW_NUMBER() OVER(ORDER BY updateddate DESC) AS rowid
 from [forumqandA] as fq left join Profile as cn on
fq.updatebyid=cn.pid  where forumtopid=@criteria) as kk
where rowid >@startRowIndex AND rowid <= (@startRowIndex + @maximumRows)
GO
/****** Object:  StoredProcedure [dbo].[upmlogin]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[upmlogin] @pid varchar(60)
as
update profile set lastvisited=getdate(),isonlinenow='Y' where pid=@pid
GO
/****** Object:  StoredProcedure [dbo].[updatedate]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[updatedate]
as
update profile set bdate='1990-10-10'  where datediff(yy,bdate,getdate())<18
GO
/****** Object:  StoredProcedure [dbo].[Update_Plans]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Update_Plans]
@Premium varchar(1)='N',
@subs_Plan int,
@pid bigint
as
update profile set paid='Y', Approved='Y' ,hasInvited='Y',premiummem=@Premium, prmstartdate=GETDATE(), 
Subs_Plan=@subs_Plan ,Msg_Left =Msg_Left+@subs_Plan where pid=@pid
GO
/****** Object:  StoredProcedure [dbo].[Update_PartenerProfile]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Update_PartenerProfile]
@candiid bigint,
@P_BodyType varchar(250),
@P_Diet varchar(250),
@P_Drinks varchar(250),
@P_Drugs varchar(250),
@P_Education  varchar(250),
@P_HairColor  varchar(250),
@P_Income money,
@P_MStatus varchar(250),
@P_MaxAge int,
@P_MaxHeight int,
@P_MinAge int,
@P_MinHeight int,
@P_Religion varchar(250),
@P_SkinColor varchar(250),
@P_Smoke varchar(250),
@P_StarSign varchar(250),
@P_cast varchar(250),
@P_motherTounge varchar(250),
@P_HEight_Name varchar(250)
AS
Update [Profile] set P_BodyType=@P_BodyType,P_Diet=@P_Diet,P_Drinks=@P_Drinks,P_Drugs=@P_Drugs,P_Education=@P_Education,
P_HairColor=@P_HairColor,P_Income=@P_Income,P_MStatus=@P_MStatus,P_MaxAge=@P_MaxAge,P_MaxHeight=@P_MaxHeight,
P_MinAge=@P_MinAge,P_MinHeight=@P_MinHeight,P_Religion=@P_Religion,P_SkinColor=@P_SkinColor,P_Smoke=@P_Smoke,
P_StarSign=@P_StarSign,P_cast=@P_cast,P_motherTounge=@P_motherTounge,P_HEight_Name=@P_HEight_Name where pid=@candiid
GO
/****** Object:  StoredProcedure [dbo].[unsuspendprofile]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[unsuspendprofile]
@pid varchar(60)
as
update profile set susp='N',approved='Y' where pid=@pid
GO
/****** Object:  StoredProcedure [dbo].[unapprovedprof]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[unapprovedprof]
as
select count(*) as cnt from profile where approved='N' and susp='N' and isdoubtful='N'
GO
/****** Object:  StoredProcedure [dbo].[totalsusp]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[totalsusp]
as
select count(*) as cnt from profile where susp='Y'
GO
/****** Object:  StoredProcedure [dbo].[totalmem]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[totalmem]
as
select count(pid) as cnt from profile
GO
/****** Object:  StoredProcedure [dbo].[toprofiles]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[toprofiles]
as
select top 20 pid,fname,email from [Profile]
GO
/****** Object:  StoredProcedure [dbo].[topprofiles]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[topprofiles]
as
select top 20 pid,fname,email from [Profile]
GO
/****** Object:  StoredProcedure [dbo].[topicansers]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[topicansers] 
@startRowIndex int,
@maximumRows int,
@criteria varchar(max)

as

 select * from(select answerid,forumqnaid,anser,updatebyid,updatedby,
 convert(varchar(10),updateddate,103) as updateddate,ROW_NUMBER() over(order by updateddate) as rowid,cn.photo
 from topicsQnAansw as fq left join profile as cn on
fq.updatebyid=cn.pid  
 where forumqnaid=@criteria
  group by answerid,forumqnaid,anser,updatebyid,updatedby,updateddate,cn.photo) as kk 
 where rowid >@startRowIndex AND rowid <= @startRowIndex + @maximumRows
GO
/****** Object:  StoredProcedure [dbo].[suspendprofile]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[suspendprofile]
@pid varchar(60)
as
update profile set susp='Y',approved='N' where pid=@pid
GO
/****** Object:  StoredProcedure [dbo].[polecomments]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[polecomments] --12,2
@mid bigint,
@useid bigint,
@StartRow int,
@maxRow int
as
Declare @MaxR int
set @MaxR=@StartRow+@maxRow
select * from (
select SNO ,ROW_NUMBER() OVER(ORDER BY sno ) AS rowid,c.CreationLogInId,poleAns,p.fname as firstname,p.lname as lastname,p.photo,
c.polecomment 
from OnlinePoleTest_Master c inner join profile p
on c.CreationLogInId =p.pid
where c.QueId =@mid) as kk where rowid>=@StartRow and rowid <=@MaxR

select isnull((Select top 1 ISNULL(rate,0) from tbl_rating_typeWise where fk_postId=@mid and fk_userid=@useid and posttype='Poll'),0)
GO
/****** Object:  View [dbo].[singlephoto]    Script Date: 06/25/2015 17:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[singlephoto]  AS select distinct  profile.pid,(select top 1 photoname from photo where photo.pid=profile.pid)as photoname,photo.passw from profile inner join  photo
on profile.pid=photo.pid
 where photo.active='Y'
GO
/****** Object:  StoredProcedure [dbo].[sendpassw]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sendpassw] @em varchar(250)
as
select passw from [profile] where email=@em
GO
/****** Object:  StoredProcedure [dbo].[Siteactivity_get]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Siteactivity_get]
as
 select top 10 SA.*,
 isnull((select top 1 photoname from  photo where photo.pid=SA.candiid and photo.active='Y'),'') as UserPhoto,
 (Select FB_ID from [Profile] where SA.candiid=[Profile].pid) 
 as FB_ID from siteactivity SA where SA.actType='Reg'
 order by siteactivityid desc

 select top 10 SA.*,
 isnull((select top 1 photoname from  photo where photo.pid=SA.candiid and photo.active='Y'),'') as UserPhoto,
 (Select FB_ID from [Profile] where SA.candiid=[Profile].pid) 
 as FB_ID from siteactivity SA where SA.actType in ('NewTopic','TopicRep')
 order by siteactivityid desc
 
  select top 10 SA.*,
 isnull((select top 1 photoname from  photo where photo.pid=SA.candiid and photo.active='Y'),'') as UserPhoto,
 (Select FB_ID from [Profile] where SA.candiid=[Profile].pid) 
 as FB_ID from siteactivity SA where SA.actType in ('Poll','PollAns')
 order by siteactivityid desc
 
  select top 10 SA.*,
 isnull((select top 1 photoname from  photo where photo.pid=SA.candiid and photo.active='Y'),'') as UserPhoto,
 (Select FB_ID from [Profile] where SA.candiid=[Profile].pid) 
 as FB_ID from siteactivity SA where SA.actType in ('ArtRep','Artical')
 order by siteactivityid desc
 
 select top 10 SA.*,
 isnull((select top 1 photoname from  photo where photo.pid=SA.candiid and photo.active='Y'),'') as UserPhoto,
 (Select FB_ID from [Profile] where SA.candiid=[Profile].pid) 
 as FB_ID from siteactivity SA where SA.actType in ('Quotes','QuoteComm')
 order by siteactivityid desc
GO
/****** Object:  StoredProcedure [dbo].[resetuser]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[resetuser]
@pid varchar(60)
as
update profile set isonlinenow='N' where pid=@pid
GO
/****** Object:  StoredProcedure [dbo].[regtoday]    Script Date: 06/25/2015 17:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[regtoday]
as
select count(*) as cnt from profile where convert(varchar(10),profiledate,103)=convert(varchar(10),getdate(),103)
GO
/****** Object:  StoredProcedure [dbo].[Quotescomments]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[Quotescomments] --12,2
@mid bigint,
@useid bigint
as

select * from (select c.commentid ,ROW_NUMBER() OVER(ORDER BY c.commnetdate DESC) AS rowid,c.candiid,p.fname as firstname,p.lname as lastname,p.photo,
c.comment 
from QuotesCommnets c inner join Profile p
on c.candiid=p.pid
where c.picid =@mid) as kk

select isnull((Select top 1 ISNULL(rate,0) from tbl_rating_typeWise where fk_postId=@mid and fk_userid=@useid and posttype='Quot'),0)
GO
/****** Object:  StoredProcedure [dbo].[myfriendsCount]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[myfriendsCount]
@criteria as varchar(50)
as


select count(*) from profile,friendshiprequest 
where (frommid=@criteria or tomid=@criteria) and isapproved='Y'
GO
/****** Object:  StoredProcedure [dbo].[profileofday]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[profileofday]
as
select  top 1 profile.pid,(select top 1 photoname from photo where photo.pid=profile.pid and photo.active='Y')as photoname ,photo.passw,fname,profiledate,count(pidof)
 from profile 
inner join photo on  profile.pid=photo.pid 
inner join profileviews on profileviews.pidof=profile.pid
where visibletoall='Y' and approved='Y' 
group by profile.pid,photoname,photo.passw,fname,profiledate
order by count(pidof) desc
GO
/****** Object:  StoredProcedure [dbo].[newlyregForFB]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure  [dbo].[newlyregForFB]
as
select distinct top 50 profile.pid,
(select top 1 photoname from photo where photo.pid=profile.pid and photo.active='Y')as photoname ,photo.passw,dbo.ProperCase(fname) as fname,profiledate  
from profile inner join photo on  profile.pid=photo.pid 
where visibletoall='Y' and approved='Y'  
order by profiledate desc
GO
/****** Object:  StoredProcedure [dbo].[newlyreg]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure  [dbo].[newlyreg]
as
select  top 7 [profile].pid,(select top 1 photoname from photo where photo.pid=profile.pid and photo.active='Y')
as photoname ,
photo.passw,fname,profiledate  from [profile]
 inner join photo on  profile.pid=photo.pid where visibletoall='Y' and approved='Y'  
order by pid desc
GO
/****** Object:  StoredProcedure [dbo].[mostviewdmaleprofilesFB]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[mostviewdmaleprofilesFB]
as
select distinct top 50 profile.pid,(select top 1 photoname from photo where photo.pid=profile.pid and photo.active='Y')as photoname ,photo.passw,dbo.ProperCase(fname) as fname,profiledate,count(pidof)
 from profile 
inner join photo on  profile.pid=photo.pid 
inner join profileviews on profileviews.pidof=profile.pid
where visibletoall='Y' and approved='Y' and gender='M'
group by profile.pid,photoname,photo.passw,fname,profiledate
order by count(pidof) desc
GO
/****** Object:  StoredProcedure [dbo].[mostviewdmaleprofiles]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[mostviewdmaleprofiles]
as
select distinct top 7 profile.pid,(select top 1 photoname from photo where photo.pid=profile.pid and photo.active='Y')as photoname ,photo.passw,fname,profiledate,count(pidof)
 from profile 
inner join photo on  profile.pid=photo.pid 
inner join profileviews on profileviews.pidof=profile.pid
where visibletoall='Y' and approved='Y' and gender='M'
group by profile.pid,photoname,photo.passw,fname,profiledate
order by count(pidof) desc
GO
/****** Object:  StoredProcedure [dbo].[mostviewdFemaleprofilesFB]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[mostviewdFemaleprofilesFB]
as
select distinct top 50 profile.pid,(select top 1 photoname from photo where photo.pid=profile.pid and photo.active='Y')as photoname ,photo.passw,dbo.ProperCase(fname) as fname,profiledate,count(pidof)
 from profile 
inner join photo on  profile.pid=photo.pid 
inner join profileviews on profileviews.pidof=profile.pid
where visibletoall='Y' and approved='Y' and gender='F' and photopassw=''
group by profile.pid,photoname,photo.passw,fname,profiledate
order by count(pidof) desc
GO
/****** Object:  StoredProcedure [dbo].[mostviewdFemaleprofiles]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[mostviewdFemaleprofiles]
as
select distinct top 7 profile.pid,(select top 1 photoname from photo where photo.pid=profile.pid and photo.active='Y')as photoname ,photo.passw,fname,profiledate,count(pidof)
 from profile 
inner join photo on  profile.pid=photo.pid 
inner join profileviews on profileviews.pidof=profile.pid
where visibletoall='Y' and approved='Y' and gender='F'
group by profile.pid,photoname,photo.passw,fname,profiledate
order by count(pidof) desc
GO
/****** Object:  StoredProcedure [dbo].[Moderators_HomePage]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Moderators_HomePage]  
AS  
Select(  
select count(*) from profile where convert(varchar(10),profiledate,103)=convert(varchar(10),getdate(),103)) as regtoday,  
(select count(*) from profile where convert(varchar(10),profiledate,103)=convert(varchar(10),DATEADD(DAY,-1,getdate()),103)) as YesterdayMem,  
(select count(*) from profile where susp='Y') as totalsusp,  
(select count(*) from profile) as totalmem,  
(select count(*) from profile where approved='N' and susp='N' and isdoubtful='N') as unapprovedprof,  
(select count(*) from photo where active='N') as unapprovedphotos,  
(select count(*) from profile where isdoubtful='Y' and susp='N') as doubtfulprofiles,
(select count(*) from send_msg where aproveSender='N' and msgissend='N' ) as unapprovedmails
GO
/****** Object:  StoredProcedure [dbo].[mlogin]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[mlogin] @em varchar(250),@pw varchar(250)
as
select pid,fname,approved,lname,susp,isvalidmobile,gender,mrole,hasInvited,headline ,facebookpost,wt,mobile,whoami,photo,FB_id,GPlusUrl  from profile where email=@em and passw=@pw
GO
/****** Object:  StoredProcedure [dbo].[Matchalert]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Matchalert]@gender as varchar(1)
as

select email,fname,pid,passw from profile
where adminemail='Y' and matchalert='Y' and gender=@gender
and isbouncing=0  --and email like '%aminnagpure%'
order by profiledate desc
GO
/****** Object:  StoredProcedure [dbo].[onlinemem]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[onlinemem]
as
select distinct top 10 profile.pid,(select top 1 photoname from photo where photo.pid=profile.pid and photo.active='Y')as photoname ,photo.passw,dbo.ProperCase(fname) as fname,profiledate,count(pidof)
 from profile 
inner join photo on  profile.pid=photo.pid 
inner join profileviews on profileviews.pidof=profile.pid
where visibletoall='Y' and approved='Y' and isonlinenow='Y'
group by profile.pid,photoname,photo.passw,fname,profiledate
order by count(pidof) desc
GO
/****** Object:  StoredProcedure [dbo].[offeralertsall]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[offeralertsall]
as
select pid,email,fname,passw from profile
where newoffers='Y'  and emailsent='N'
GO
/****** Object:  StoredProcedure [dbo].[offeralerts]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[offeralerts]
as
select email,fname,passw from profile
where newoffers='Y' and
datediff(day,profiledate,getdate())<=7
GO
/****** Object:  StoredProcedure [dbo].[issenderaprove]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[issenderaprove]
@pid bigint
as

select count(aproveSender) from send_msg where msgfromid = @pid and aproveSender = 'Y'

select gender from Profile where pid = @pid
GO
/****** Object:  StoredProcedure [dbo].[getInboxMsg]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[getInboxMsg]    
@msgid bigint  
as    
  
select a.msgid,a.msgtoid,(select b.fname from Profile as b where b.pid=a.msgtoid) as msgtoname,
a.msgfromid, (select b.fname from Profile as b where b.pid=a.msgfromid) as msgfromname, a.msg,a.msgdate 
from send_msg as a where a.msgtoid=@msgid order by msgid desc
GO
/****** Object:  StoredProcedure [dbo].[getEmail]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[getEmail]
@pid bigint
as

select email from profile where pid=@pid
GO
/****** Object:  StoredProcedure [dbo].[getwaitingMsg]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[getwaitingMsg]
as
select msgid,
(select fname from [profile]
 where Profile.pid = mm.msgfromid)as msgFrom ,
 msgfromid,
 (select fname from [profile]
 where Profile.pid = mm.msgtoid)as msgTo,
 msgtoid,
 msg,msgdate
 ,(select COUNT(msgfromid) from send_msg sm where sm.msgfromid =mm.msgfromid and aproveSender = 'Y' and msgissend='Y' )as totalsend,(select COUNT(msgfromid) from send_msg sm where sm.msgfromid =mm.msgfromid and aproveSender = 'Y'and msgissend='N' )as totalpending
  from [send_msg] mm where aproveSender = 'Y' and msgissend = 'N'
  
  
  --exec getwaitingMsg
GO
/****** Object:  StoredProcedure [dbo].[getviewfemales]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[getviewfemales]
as
select distinct top 10 profile.pid,photo ,fname,bdate,religion,cityname,education,profession,
profiledate,count(pidof)
 from profile 
inner join profileviews on profileviews.pidof=profile.pid
where visibletoall='Y' and approved='Y' and gender='F' and photo<>''
group by profile.pid,photo,fname,bdate,religion,cityname,education,profession,profiledate
order by count(pidof) desc
GO
/****** Object:  StoredProcedure [dbo].[getviewdmales]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[getviewdmales]
as
select distinct top 30 profile.pid,photo ,fname,bdate,religion,cityname,education,profession,
profiledate --,count(pidof)
 from profile 
inner join profileviews on profileviews.pidof=profile.pid
where visibletoall='Y' and approved='Y' and gender='M' and photo<>''
--group by profile.pid,photo,fname,bdate,religion,cityname,education,profession,profiledate
order by profiledate desc
GO
/****** Object:  StoredProcedure [dbo].[getviewdfemales]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[getviewdfemales]
as
select distinct top 30 profile.pid,photo.photoname as photo ,fname,bdate,religion,cityname,education,profession,
profiledate --,count(pidof)
 from profile 
left join photo on photo.pid=profile.pid
where visibletoall='Y' and approved='Y' and gender='F' 
--group by profile.pid,photo,fname,bdate,religion,cityname,education,profession,profiledate
order by profiledate desc
--select top 10 * from profile order by profiledate desc
--select top 10 * from siteactivity order by siteactivityid desc
GO
/****** Object:  StoredProcedure [dbo].[getTopics]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[getTopics]
@startRowIndex int,
@maximumRows int,
@criteria bigint
as
SET NOCOUNT ON;
Declare @MAX Bigint
set @MAX=@startRowIndex + @maximumRows;

WITH AllToics As
(
select TopicId,TopicTitle,TopicDesc,T.CandiId,
pl.fname ,
CONVERT(varchar(10),StartDate,103) as
starteddate,UpdateCandiId,convert(varchar(20),
UpdateDate,100) as
updatedate,
(Select COUNT(AnsId) From TopicAnswer Where TopicAnswer.TopicId=T.TopicId) as 'ReplayCount',
UpdateCandiName, Photo,
CONVERT(varchar(10),UpdateDate,103)as updateddate,ROW_NUMBER() OVER(ORDER BY UpdateDate DESC) AS rowid
 from Topic as T left join Profile  as pl on
T.CandiId= pl.pid   where SubCatId=@criteria

)
select *,(Select MAX(ROwid) from AllToics) as Total from AllToics
where rowid >@startRowIndex AND rowid <= @MAX
GO
/****** Object:  StoredProcedure [dbo].[getTopicDetails]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[getTopicDetails]
@TopicId as bigint
AS
Select T.TopicId,T.TopicTitle ,T.TopicDesc,T.CatId,T.SubCatId,
T.CandiId,CAN.fname  ,
T.UpdateCandiId,T.UpdateCandiName,
CONVERT(VARCHAR(20), T.StartDate, 100) AS StartDate,
CONVERT(VARCHAR(20),T.UpdateDate, 100) AS  UpdateDate,

(Select COUNT(TopicTitle) from Topic WHere Topic.CandiId=CAN.pid) as TotalThread,
(Select COUNT(AnsId) from TopicAnswer WHere TopicAnswer.TopicId=T.TopicId) as TotalReplay, CAN.photo
from Topic T LEFt JOIN Profile  CAN ON T.CandiId = CAN.pid  Where TopicId=@TopicId

select * from Topic
GO
/****** Object:  StoredProcedure [dbo].[getTopicAnswer]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getTopicAnswer]
@startRowIndex int,
@maximumRows int,
@criteria bigint
AS
 select * from( Select AnsId,TopicAns,TA.CandiId,TopicId, 
CONVERT(VARCHAR(20), AnsDate, 100) as AnsDate,
pl.fname ,ROW_NUMBER() over(order by AnsDate) as rowid,pl .photo
from TopicAnswer TA LEFT JOIN Profile  pl
ON TA.CandiId=pl.pid  Where TopicId=@criteria
) as DT 
where rowid >@startRowIndex AND rowid <= @startRowIndex + @maximumRows
GO
/****** Object:  StoredProcedure [dbo].[getSubCategory]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getSubCategory]
	@mid int 
AS
Select SC.SubCatId,SC.SubCatTitle,SC.UpdatedBy,SC.LastTopic,SC.LastTopicid
,Sc.CatId ,Sc.SubCatDesc,
CONVERT(VARCHAR(20), sc.UpdatedDate, 100) AS  lastupdate ,
(Select SUBSTRING ( TopicTitle ,1 , 60 ) as TopicTitle from Topic Where TopicId=Sc.LastTopicid ) as TopicTitle,
pl.pid ,pl.fname ,pl.lname ,pl.photo,pl.photopassw,
'' + (Select fname  from Profile  where pid =Sc.UpdatedBy) as UpdatedByName,
'' + Convert(varchar(50),(Select count(TopicTitle) from Topic where SC.SubCatId=Topic.SubCatId)) as TopicsCount,
'' + Convert(varchar(50),(select COUNT(TA.AnsId) from TopicAnswer TA inner join Topic on TA.TopicId= Topic.TopicId where Topic.SubCatId=SC.SubCatId)) as ReplyCount
from dbo.SubCategory SC LEFT OUTER JOIN dbo.Profile  pl
ON SC.UpdatedBy=pl.pid  
Where  Sc.CatId=@mid
GO
/****** Object:  StoredProcedure [dbo].[get_UnApprovePhoto]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[get_UnApprovePhoto]
AS
select photoid,photoname,P.pid,PR.gender,PR.bdate,PR.mobile,PR.paid,PR.fname,PR.lname,PR.profiledate,PR.LastVisited,
(Select COUNT(*) from Photo PC Where PC.pid =P.PId) as TPhoto
from photo P Left OUTER JOIN PROFILE PR 
ON P.pid =PR.pid
where P.active='N' order by uploaddate desc
GO
/****** Object:  StoredProcedure [dbo].[get_Membership]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[get_Membership]
@candiid bigint,
@tocontact bigint=0,
@td datetime=null
as
if @td is null
BEGIN
	set @td=GETDATE()
END
select gender,premiummem,Paid,msg_count,Subs_Plan,msg_left,Susp from profile where pid=@candiid
select email,gender from profile where pid=@tocontact
Select ISNULL(Count(*),0) as 'ToDayMsg' from Contact_History
where CONVERT(VARCHAR(10), ContactON,103)= CONVERT(VARCHAR(10), @td, 103) and candiid=@candiid
GO
/****** Object:  StoredProcedure [dbo].[get_ProfileNearME1]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[get_ProfileNearME1] 
@candiid bigint
AS
Declare @PIN varchar(10),@city varchar(100),@State varchar(100),@gender varchar(1), @S varchar(4), @smt varchar(max)

Select @PIN=SUBSTRING(zipcode,1,LEN(zipcode)-1)+'_',@city=cityname,@State=[state] ,@gender=gender from [Profile] where pid=@candiid
if @gender='M'
BEGIN
	set @S='asc'
	END
	else
	BEGIN
	set @S='desc'
	END
set @smt=' Select TOP 5 * FROM(
Select TOP 5 zipcode, profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,profession
From [Profile] Where zipcode like ''' + @PIN + ''' AND gender<>''' + @gender + '''
UNION
Select TOP 5 zipcode, profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,profession
From [Profile] Where cityname=''' + @city + ''' AND gender<> '''+ @gender + '''
UNION
Select TOP 5 zipcode, profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,profession
From [Profile] Where [state]=''' + @state + ''' AND gender<>''' + @gender+ '''
UNION
Select TOP 5 zipcode, profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,profession
From [Profile] Where zipcode like '''+@PIN + ''' AND gender='''+@gender + '''
UNION
Select TOP 5 zipcode, profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,profession
From [Profile] Where cityname= '''+@city+ ''' AND gender= '''+@gender+ '''
UNION
Select TOP 5 zipcode, profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,profession
From [Profile] Where [state]= '''+@state+ ''' AND gender= '''+@gender+ '''
) as Amit Order by gender '
print @gender
print @smt + @S+',photoname desc'
EXEC(@smt+ @S+',photoname desc')

--get_ProfileNearME1  12
GO
/****** Object:  StoredProcedure [dbo].[get_ProfileNearME]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[get_ProfileNearME]
@candiid bigint
AS
Declare @PIN varchar(50),@city varchar(100),@State varchar(100),@gender varchar(1), @S varchar(4), @smt varchar(max)

Select @PIN=zipcode,@city=cityname,@State=[state] ,@gender=gender from [Profile] where pid=@candiid
if LEN(@PIN) > 2
BEGIN
	set @PIN=SUBSTRING(@PIN,1,LEN(@PIN)-1)+'_'
	set @PIN=' zipcode like ''' + @PIN + ''' AND '
END
ELSE 
BEGIN
	Set @PIN=''
END
if @gender='M'
BEGIN
	set @S='asc'
	END
	else
	BEGIN
	set @S='desc'
	END
set @smt=' Select TOP 10 * FROM(
Select TOP 8 zipcode, profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,profession
From [Profile] Where ' + @PIN + ' gender<>''' + @gender + '''
UNION
Select TOP 8 zipcode, profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,profession
From [Profile] Where cityname=''' + @city + ''' AND gender<> '''+ @gender + '''
UNION
Select TOP 8 zipcode, profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,profession
From [Profile] Where [state]=''' + @state + ''' AND gender<>''' + @gender+ '''
UNION
Select TOP 8 zipcode, profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,profession
From [Profile] Where  ' + @PIN + ' gender='''+@gender + '''
UNION
Select TOP 8 zipcode, profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,profession
From [Profile] Where cityname= '''+@city+ ''' AND gender= '''+@gender+ '''
UNION
Select TOP 8 zipcode, profile.pid,profile.profiledate, fname,mobile,premiummem,
lname,bdate,purpose,gender,ethnic,religion,caste,profile.countryname,
whoami, profile.state, profile.cityid,profile.cityname,photo as  photoname,photopassw,ipaddress,ipcountry,email,profession
From [Profile] Where [state]= '''+@state+ ''' AND gender= '''+@gender+ '''
) as Amit Order by gender '
print @gender
print @smt + @S+',photoname desc'
EXEC(@smt+ @S+',photoname desc')

--get_ProfileNearME1  10630
GO
/****** Object:  StoredProcedure [dbo].[GET_PartenerProfile]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GET_PartenerProfile]
@candiid bigint
AS
Select P_BodyType,P_Diet,P_Drinks,P_Drugs,P_Education,P_HairColor,P_Income,P_MStatus
,P_MaxAge,P_MaxHeight,P_MinAge,P_MinHeight,P_Religion,P_SkinColor,P_Smoke,P_StarSign,P_cast,P_motherTounge,P_HEight_Name
 from [Profile] where pid=@candiid
GO
/****** Object:  StoredProcedure [dbo].[get_AllPartners]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[get_AllPartners]
AS
Select pid,fname,lname,email,mobile,COUNT(DatingSite.webID) as SiteCount,
stuff((SELECT distinct ','+WebsiteUrl  
           FROM DatingSite t2
           where t2.candiid = DatingSite.candiid
           FOR XML PATH('')),1,1,'') as 'WebsiteLists'
           ,
stuff((SELECT distinct ','+Pub_id  
           FROM DatingSite t3
           where t3.candiid = DatingSite.candiid
           FOR XML PATH('')),1,1,'') as 'Pub_id'
           ,DatingSite.IsApprove
 from [Profile] P JOIN
DatingSite ON DatingSite.candiid=P.pid group by pid,fname,lname,email,mobile,candiid, IsApprove
GO
/****** Object:  StoredProcedure [dbo].[forumsubcategory]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[forumsubcategory]
@startRowIndex int,
@maximumRows int,
@mid int
as
select 
ft.forumtopid,
ft.forumtitle,
ft.updatebyid,
fname as firstname,
lname as lastname,
topicsdescription,
Convert(varchar(100), latesttopic) as latesttopic,
latesttopicid, 
forumcatid,
photo,
photopassw,
lastupdate ,
'Threads : ' + Convert(varchar(50),(Select count(forumqnaid) from forumqandA where forumtopid=ft.forumtopid)) as TopicsCount,
'Replys : ' + Convert(varchar(50),(select COUNT(answerid) from topicsQnAansw inner join forumqandA on topicsQnAansw.forumqnaid= forumqandA.forumqnaid where forumqandA.forumtopid=ft.forumtopid)) as ReplyCount

from forumtopics as ft left join Profile cn
on ft.updatebyid=cn.pid
where forumcatid=@mid
GO
/****** Object:  StoredProcedure [dbo].[Forums_getTopicAnswer]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Forums_getTopicAnswer]
@startRowIndex int,
@maximumRows int,
@criteria bigint
AS
SET NOCOUNT ON;
 With AllReplies as( Select AnsId,TopicAns,TA.CandiId,TopicId, 
CONVERT(VARCHAR(20), AnsDate, 100) as AnsDate,
pl.fname ,ROW_NUMBER() over(order by AnsDate) as rowid,pl .photo
from TopicAnswer TA LEFT JOIN Profile  pl
ON TA.CandiId=pl.pid  Where TopicId=@criteria
)
select *,(Select MAX(rowid) from AllReplies) as Total from AllReplies
where rowid >@startRowIndex AND rowid <= @startRowIndex + @maximumRows
GO
/****** Object:  StoredProcedure [dbo].[Forums_Get_SubCategory_Detail]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Forums_Get_SubCategory_Detail]
@SubCatID bigint
AS
SET NOCOUNT ON;
Select SC.SubCatTitle,Sc.SubCatDesc,CONVERT(VARCHAR(20), sc.UpdatedDate, 100) AS  lastupdate 
,pl.pid,pl.fname,pl.lname,pl.photo,pl.photopassw,'' + Convert(varchar(50),
(Select count(TopicTitle) from Topic where SC.SubCatId=Topic.SubCatId)) as TopicsCount,
'' + Convert(varchar(50),(select COUNT(TA.AnsId) from TopicAnswer TA inner join Topic on 
TA.TopicId= Topic.TopicId where Topic.SubCatId=SC.SubCatId)) as ReplyCount from dbo.SubCategory 
SC LEFT OUTER JOIN dbo.Profile pl ON SC.CandiId=pl.pid  Where  Sc.SubCatId=@SubCatID;
GO
/****** Object:  StoredProcedure [dbo].[fetchrecord]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[fetchrecord]

as


    select TOP 20000 [pid],     
        [headline],[fname],[lname],[bdate],[purpose],[gender],[email],[countryid],[whoami],[lookingfor],
        [profiledate],[maritalstatus],mothertounge,[height],[annualincome],[profession],
        [passw],[htname],[eyesight],[wt] ,[complexion],[verifiedemail],[zipcode],[approved],[starsign],[haircolor],[education],[smoke],[Drink],[diet],[drugs],[paid],[Susp],[isdoubtful],[photo],[premiummem],[mobile],[mrole],[facebookpost],[FB_id],[GPlusUrl],[cityid],[stateid],isimported
    from profile where isimported = 'N'
  



--select * from Profile where isimported = 'Y'

--update Profile set isimported='N'
GO
/****** Object:  StoredProcedure [dbo].[emailall]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[emailall]
as
select email,fname,pid from profile
where adminemail='Y' and emailsent='N'
order by profiledate desc
GO
/****** Object:  StoredProcedure [dbo].[editreg]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[editreg]
@pId varchar(60)
as

Select * from profile where pid=@pId
GO
/****** Object:  StoredProcedure [dbo].[doubtfulprofiles]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[doubtfulprofiles]
as
select count(*) as cnt from profile where isdoubtful='Y' and susp='N'
GO
/****** Object:  StoredProcedure [dbo].[checkregi]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[checkregi] @em varchar(250)
as
select pid from profile where email=@em
GO
/****** Object:  StoredProcedure [dbo].[checkNewscomments]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[checkNewscomments]
@startRowIndex int,
@maximumRows int,
@mid bigint
as
Declare @sqlst as varchar(max),@MaxRow int
set @MaxRow=@startRowIndex + @maximumRows;



select * from (select c.ncommentid,c.candiid,p.fname as firstname,p.lname as lastname,p.photo,c.comment
,ROW_NUMBER() OVER(ORDER BY commentdate DESC) AS rowid
from newscomments c inner join profile p
on c.candiid=p.pid
where c.newsid=@mid) as kk
where rowid >@startRowIndex AND rowid <= (@MaxRow)
GO
/****** Object:  StoredProcedure [dbo].[checKInterest]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[checKInterest]
@candiid bigint,
@Tocandiid bigint,
@TODate datetime =null
As
if @TODate is null
	set @TODate=GETDATE()
Select * from User_Interest Where 
(CONVERT(varchar,Candiid)+CONVERT(varchar,IntrestedIn))=''+(CONVERT(varchar,@candiid)+CONVERT(varchar,@Tocandiid)) OR 
(CONVERT(varchar,Candiid)+CONVERT(varchar,IntrestedIn))=''+(CONVERT(varchar,@Tocandiid)+CONVERT(varchar,@candiid))

Select isnull(COUNT(*),0) AS ToDayInterest from User_Interest where Candiid=@candiid and 
 CONVERT(VARCHAR(10), InterestDate,103)= CONVERT(VARCHAR(10), @TODate, 103)
 Select paid,premiummem,gender,(Select COUNT(*) from User_Interest where Candiid=@candiid) as totalInterest from profile where pid=@candiid
 Select fname,lname,gender from profile where pid=@Tocandiid
GO
/****** Object:  StoredProcedure [dbo].[checkemail]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[checkemail]
@email as varchar(250)
as
select count(*) from profile where email=@email
GO
/****** Object:  StoredProcedure [dbo].[adminemailall]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[adminemailall]
as
select email,fname,passw,pid from [Profile] where-- email like '%aminnagpure%' 
 adminemail='Y' and isbouncing=0 -- and paid='N'  and gender='M'
 order by pid desc
GO
/****** Object:  StoredProcedure [dbo].[Add_msg]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Add_msg]
@candiid bigint,
@Contacted bigint,
@User_Message varchar(500),
@ContactON datetime = null,
@MailSend varchar(1)
as
if exists(Select * from [Profile] where pid=@candiid)
BEGIN
Insert INTO Contact_History(candiid,Contacted,ContactON,User_Message,MailSend ) 
values(@candiid,@Contacted,@ContactON,@User_Message,@MailSend )
Update [Profile] set msg_count =msg_count+1 where pid=@candiid --,Msg_Left=Msg_Left-1
END
GO
/****** Object:  StoredProcedure [dbo].[approveprofile]    Script Date: 06/25/2015 17:16:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[approveprofile]
@pid varchar(60)
as
update profile set Approved='Y' where pid=@pid
GO
/****** Object:  Default [alertqueryDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[alert] ADD  CONSTRAINT [alertqueryDefault]  DEFAULT ('') FOR [query]
GO
/****** Object:  Default [alertquerynameDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[alert] ADD  CONSTRAINT [alertquerynameDefault]  DEFAULT ('') FOR [queryname]
GO
/****** Object:  Default [alertemailDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[alert] ADD  CONSTRAINT [alertemailDefault]  DEFAULT ('') FOR [email]
GO
/****** Object:  Default [alertverifiedDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[alert] ADD  CONSTRAINT [alertverifiedDefault]  DEFAULT ('N') FOR [verified]
GO
/****** Object:  Default [alertfireddateDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[alert] ADD  CONSTRAINT [alertfireddateDefault]  DEFAULT (getdate()) FOR [fireddate]
GO
/****** Object:  Default [[dbo]].[alert]]jointypeDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[alert] ADD  CONSTRAINT [[dbo]].[alert]]jointypeDefault]  DEFAULT ('Left Join') FOR [jointype]
GO
/****** Object:  Default [blacklistedmemberidblockedDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[blacklisted] ADD  CONSTRAINT [blacklistedmemberidblockedDefault]  DEFAULT ('') FOR [memberidblocked]
GO
/****** Object:  Default [blacklistedfnameDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[blacklisted] ADD  CONSTRAINT [blacklistedfnameDefault]  DEFAULT ('') FOR [fname]
GO
/****** Object:  Default [blacklistedlnameDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[blacklisted] ADD  CONSTRAINT [blacklistedlnameDefault]  DEFAULT ('') FOR [lname]
GO
/****** Object:  Default [blacklistedupddateDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[blacklisted] ADD  CONSTRAINT [blacklistedupddateDefault]  DEFAULT (getdate()) FOR [upddate]
GO
/****** Object:  Default [DF_candiReg_FirstName]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_FirstName]  DEFAULT ('') FOR [FirstName]
GO
/****** Object:  Default [DF_candiReg_LastName]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_LastName]  DEFAULT ('') FOR [LastName]
GO
/****** Object:  Default [DF_candiReg_EmailID]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_EmailID]  DEFAULT ('') FOR [EmailID]
GO
/****** Object:  Default [DF_candiReg_Passw]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_Passw]  DEFAULT ('') FOR [Passw]
GO
/****** Object:  Default [DF_candiReg_MobileNo]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_MobileNo]  DEFAULT ('') FOR [MobileNo]
GO
/****** Object:  Default [DF_candiReg_StateName]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_StateName]  DEFAULT ('') FOR [StateName]
GO
/****** Object:  Default [DF_candiReg_Country]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_Country]  DEFAULT ('') FOR [Country]
GO
/****** Object:  Default [DF_candiReg_IsActive]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_IsActive]  DEFAULT ('N') FOR [IsActive]
GO
/****** Object:  Default [DF_candiReg_IsApproved]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_IsApproved]  DEFAULT ('Y') FOR [IsApproved]
GO
/****** Object:  Default [DF_candiReg_RegDate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_RegDate]  DEFAULT (getdate()) FOR [RegDate]
GO
/****** Object:  Default [DF_candiReg_LastLogin]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_LastLogin]  DEFAULT (getdate()) FOR [LastLogin]
GO
/****** Object:  Default [DF_candiReg_mrol]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_mrol]  DEFAULT ('') FOR [mrol]
GO
/****** Object:  Default [DF_candiReg_address]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_address]  DEFAULT ('') FOR [address]
GO
/****** Object:  Default [DF_candiReg_cityid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_cityid]  DEFAULT ((0)) FOR [cityid]
GO
/****** Object:  Default [DF_candiReg_COUNTRYID]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_COUNTRYID]  DEFAULT ((0)) FOR [COUNTRYID]
GO
/****** Object:  Default [DF_candiReg_stateid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_stateid]  DEFAULT ((0)) FOR [stateid]
GO
/****** Object:  Default [DF_candiReg_photo]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_photo]  DEFAULT ('') FOR [photo]
GO
/****** Object:  Default [DF_candiReg_photopassw]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_photopassw]  DEFAULT ('') FOR [photopassw]
GO
/****** Object:  Default [DF_candiReg_refby]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_refby]  DEFAULT ((0)) FOR [refby]
GO
/****** Object:  Default [DF_candiReg_refer2]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_refer2]  DEFAULT ('') FOR [refer2]
GO
/****** Object:  Default [DF_candiReg_ref1val]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_ref1val]  DEFAULT ((0)) FOR [ref1val]
GO
/****** Object:  Default [DF_candiReg_ref2val]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_ref2val]  DEFAULT ((0)) FOR [ref2val]
GO
/****** Object:  Default [DF_candiReg_RefUrl]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_RefUrl]  DEFAULT ('') FOR [RefUrl]
GO
/****** Object:  Default [DF_candiReg_ipaddress]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_ipaddress]  DEFAULT ('') FOR [ipaddress]
GO
/****** Object:  Default [DF_candiReg_websiteUrl]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_websiteUrl]  DEFAULT ('') FOR [websiteUrl]
GO
/****** Object:  Default [DF_candiReg_issuspended]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[candiReg] ADD  CONSTRAINT [DF_candiReg_issuspended]  DEFAULT ('N') FOR [issuspended]
GO
/****** Object:  Default [DF_Cast_List_CAst_N]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Cast_List] ADD  CONSTRAINT [DF_Cast_List_CAst_N]  DEFAULT ('') FOR [Cast_N]
GO
/****** Object:  Default [DF_Cast_List_Rel]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Cast_List] ADD  CONSTRAINT [DF_Cast_List_Rel]  DEFAULT ('Hindu') FOR [Rel]
GO
/****** Object:  Default [DF_citytable_stateid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[citytable] ADD  CONSTRAINT [DF_citytable_stateid]  DEFAULT ((0)) FOR [stateid]
GO
/****** Object:  Default [DF_Contact_History_candiid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Contact_History] ADD  CONSTRAINT [DF_Contact_History_candiid]  DEFAULT ((0)) FOR [candiid]
GO
/****** Object:  Default [DF_Contact_History_Contacted]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Contact_History] ADD  CONSTRAINT [DF_Contact_History_Contacted]  DEFAULT ((0)) FOR [Contacted]
GO
/****** Object:  Default [DF_Contact_History_ContactON]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Contact_History] ADD  CONSTRAINT [DF_Contact_History_ContactON]  DEFAULT (getdate()) FOR [ContactON]
GO
/****** Object:  Default [DF_Contact_History_User_Message]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Contact_History] ADD  CONSTRAINT [DF_Contact_History_User_Message]  DEFAULT ('') FOR [User_Message]
GO
/****** Object:  Default [DF_Contact_History_MailSend]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Contact_History] ADD  CONSTRAINT [DF_Contact_History_MailSend]  DEFAULT ('N') FOR [MailSend]
GO
/****** Object:  Default [favoritiesmemberidfavDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[favorities] ADD  CONSTRAINT [favoritiesmemberidfavDefault]  DEFAULT ('') FOR [memberidfav]
GO
/****** Object:  Default [favoritiesfnameDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[favorities] ADD  CONSTRAINT [favoritiesfnameDefault]  DEFAULT ('') FOR [fname]
GO
/****** Object:  Default [DF_forumcategory_descrip]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumcategory] ADD  CONSTRAINT [DF_forumcategory_descrip]  DEFAULT ('') FOR [descrip]
GO
/****** Object:  Default [DF_forumqandA_question]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumqandA] ADD  CONSTRAINT [DF_forumqandA_question]  DEFAULT ('') FOR [question]
GO
/****** Object:  Default [DF_forumqandA_questdesc]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumqandA] ADD  CONSTRAINT [DF_forumqandA_questdesc]  DEFAULT ('') FOR [questdesc]
GO
/****** Object:  Default [DF_forumqandA_startedby]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumqandA] ADD  CONSTRAINT [DF_forumqandA_startedby]  DEFAULT ('') FOR [startedby]
GO
/****** Object:  Default [DF_forumqandA_starteddate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumqandA] ADD  CONSTRAINT [DF_forumqandA_starteddate]  DEFAULT (getdate()) FOR [starteddate]
GO
/****** Object:  Default [DF_forumqandA_updatedby]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumqandA] ADD  CONSTRAINT [DF_forumqandA_updatedby]  DEFAULT ('') FOR [updatedby]
GO
/****** Object:  Default [DF_forumqandA_updateddate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumqandA] ADD  CONSTRAINT [DF_forumqandA_updateddate]  DEFAULT (getdate()) FOR [updateddate]
GO
/****** Object:  Default [DF__forumqand__isapp__15702A09]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumqandA] ADD  CONSTRAINT [DF__forumqand__isapp__15702A09]  DEFAULT ('N') FOR [isapprove]
GO
/****** Object:  Default [DF_forumtopics_forumtitle]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumtopics] ADD  CONSTRAINT [DF_forumtopics_forumtitle]  DEFAULT ('') FOR [forumtitle]
GO
/****** Object:  Default [DF_forumtopics_lastupdate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumtopics] ADD  CONSTRAINT [DF_forumtopics_lastupdate]  DEFAULT (getdate()) FOR [lastupdate]
GO
/****** Object:  Default [DF_forumtopics_updatedby]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumtopics] ADD  CONSTRAINT [DF_forumtopics_updatedby]  DEFAULT ('') FOR [updatedby]
GO
/****** Object:  Default [DF_forumtopics_startedby]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumtopics] ADD  CONSTRAINT [DF_forumtopics_startedby]  DEFAULT ('') FOR [startedby]
GO
/****** Object:  Default [DF_forumtopics_topicsdescription]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumtopics] ADD  CONSTRAINT [DF_forumtopics_topicsdescription]  DEFAULT ('') FOR [topicsdescription]
GO
/****** Object:  Default [DF_forumtopics_latesttopic]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumtopics] ADD  CONSTRAINT [DF_forumtopics_latesttopic]  DEFAULT ('') FOR [latesttopic]
GO
/****** Object:  Default [DF_forumtopics_latesttopicid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumtopics] ADD  CONSTRAINT [DF_forumtopics_latesttopicid]  DEFAULT ('') FOR [latesttopicid]
GO
/****** Object:  Default [DF__forumtopi__isSus__2D7CBDC4]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumtopics] ADD  CONSTRAINT [DF__forumtopi__isSus__2D7CBDC4]  DEFAULT ('N') FOR [isSusp]
GO
/****** Object:  Default [DF__forumtopi__isApp__2E70E1FD]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[forumtopics] ADD  CONSTRAINT [DF__forumtopi__isApp__2E70E1FD]  DEFAULT ('N') FOR [isApproved]
GO
/****** Object:  Default [DF_invalidemails_email]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invalidemails] ADD  CONSTRAINT [DF_invalidemails_email]  DEFAULT ('') FOR [email]
GO
/****** Object:  Default [DF_invalidemails_inviteid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invalidemails] ADD  CONSTRAINT [DF_invalidemails_inviteid]  DEFAULT ((0)) FOR [inviteid]
GO
/****** Object:  Default [DF_invites_candiid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_candiid]  DEFAULT ('') FOR [candiid]
GO
/****** Object:  Default [DF_invites_email]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_email]  DEFAULT ('') FOR [email]
GO
/****** Object:  Default [DF_invites_fname]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_fname]  DEFAULT ('') FOR [fname]
GO
/****** Object:  Default [DF_invites_lname]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_lname]  DEFAULT ('') FOR [lname]
GO
/****** Object:  Default [DF_invites_isdeleted]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_isdeleted]  DEFAULT ('N') FOR [isdeleted]
GO
/****** Object:  Default [DF_invites_sendersemail]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_sendersemail]  DEFAULT ('') FOR [sendersemail]
GO
/****** Object:  Default [DF_invites_invitesent]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_invitesent]  DEFAULT ((0)) FOR [invitesent]
GO
/****** Object:  Default [DF_invites_lovenmarry]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_lovenmarry]  DEFAULT ('Y') FOR [lovenmarry]
GO
/****** Object:  Default [DF_invites_ischecked]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_ischecked]  DEFAULT ('N') FOR [ischecked]
GO
/****** Object:  Default [DF_invites_isvalidemail]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_isvalidemail]  DEFAULT ('Y') FOR [isvalidemail]
GO
/****** Object:  Default [DF_invites_isblacklisted]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_isblacklisted]  DEFAULT ('N') FOR [isblacklisted]
GO
/****** Object:  Default [DF_invites_exported]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_exported]  DEFAULT ('N') FOR [exported]
GO
/****** Object:  Default [DF_invites_converted]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_converted]  DEFAULT ('N') FOR [converted]
GO
/****** Object:  Default [DF_invites_lovenmarrysent]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_lovenmarrysent]  DEFAULT ((0)) FOR [lovenmarrysent]
GO
/****** Object:  Default [DF_invites_isbouncing]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_isbouncing]  DEFAULT ((0)) FOR [isbouncing]
GO
/****** Object:  Default [DF_invites_membercontact]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_membercontact]  DEFAULT ((0)) FOR [membercontact]
GO
/****** Object:  Default [DF_invites_bhavna]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_bhavna]  DEFAULT ((0)) FOR [bhavna]
GO
/****** Object:  Default [DF_invites_tanysent]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_tanysent]  DEFAULT ((0)) FOR [tanysent]
GO
/****** Object:  Default [DF_invites_reshma]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_reshma]  DEFAULT ((0)) FOR [reshma]
GO
/****** Object:  Default [DF_invites_kavita]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_kavita]  DEFAULT ((0)) FOR [kavita]
GO
/****** Object:  Default [DF_invites_mohini]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_mohini]  DEFAULT ((0)) FOR [mohini]
GO
/****** Object:  Default [DF_invites_sachin]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_sachin]  DEFAULT ((0)) FOR [sachin]
GO
/****** Object:  Default [DF_invites_aditi]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[invites] ADD  CONSTRAINT [DF_invites_aditi]  DEFAULT ((0)) FOR [aditi]
GO
/****** Object:  Default [DF_Login_Details_candiid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Login_Details] ADD  CONSTRAINT [DF_Login_Details_candiid]  DEFAULT ((0)) FOR [candiid]
GO
/****** Object:  Default [DF_Login_Details_LoginDate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Login_Details] ADD  CONSTRAINT [DF_Login_Details_LoginDate]  DEFAULT (getdate()) FOR [LoginDate]
GO
/****** Object:  Default [DF_Login_Details_IPAddress]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Login_Details] ADD  CONSTRAINT [DF_Login_Details_IPAddress]  DEFAULT ('') FOR [IPAddress]
GO
/****** Object:  Default [DF_Category_descrip]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[MainCategory] ADD  CONSTRAINT [DF_Category_descrip]  DEFAULT ('') FOR [descrip]
GO
/****** Object:  Default [DF_MainCategory_CandiId]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[MainCategory] ADD  CONSTRAINT [DF_MainCategory_CandiId]  DEFAULT ((0)) FOR [CandiId]
GO
/****** Object:  Default [DF_MainCategory_StartDate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[MainCategory] ADD  CONSTRAINT [DF_MainCategory_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
/****** Object:  Default [DF_news_newsheadline]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_newsheadline]  DEFAULT ('') FOR [newsheadline]
GO
/****** Object:  Default [DF_news_newscat]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_newscat]  DEFAULT ((1)) FOR [newscat]
GO
/****** Object:  Default [DF_news_newscontent]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_newscontent]  DEFAULT ('') FOR [newscontent]
GO
/****** Object:  Default [DF_news_newsdate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_newsdate]  DEFAULT (getdate()) FOR [newsdate]
GO
/****** Object:  Default [DF_news_website]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_website]  DEFAULT ('') FOR [website]
GO
/****** Object:  Default [DF_news_pid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[news] ADD  CONSTRAINT [DF_news_pid]  DEFAULT ((0)) FOR [pid]
GO
/****** Object:  Default [DF_newscomments_fname]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[newscomments] ADD  CONSTRAINT [DF_newscomments_fname]  DEFAULT ('') FOR [fname]
GO
/****** Object:  Default [DF_newscomments_commentdate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[newscomments] ADD  CONSTRAINT [DF_newscomments_commentdate]  DEFAULT (getdate()) FOR [commentdate]
GO
/****** Object:  Default [DF_newscomments_approved]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[newscomments] ADD  CONSTRAINT [DF_newscomments_approved]  DEFAULT ('Y') FOR [approved]
GO
/****** Object:  Default [DF_newscomments_newsid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[newscomments] ADD  CONSTRAINT [DF_newscomments_newsid]  DEFAULT ('') FOR [newsid]
GO
/****** Object:  Default [DF_OnlinePoleTest_Master_poleId]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[OnlinePoleTest_Master] ADD  CONSTRAINT [DF_OnlinePoleTest_Master_poleId]  DEFAULT ('') FOR [poleId]
GO
/****** Object:  Default [DF_OnlinePoleTest_Master_polecomment]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[OnlinePoleTest_Master] ADD  CONSTRAINT [DF_OnlinePoleTest_Master_polecomment]  DEFAULT ('') FOR [polecomment]
GO
/****** Object:  Default [DF_OnlinePoleTest_Master_isapprove]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[OnlinePoleTest_Master] ADD  CONSTRAINT [DF_OnlinePoleTest_Master_isapprove]  DEFAULT ('N') FOR [isapprove]
GO
/****** Object:  Default [DF_Partner_Payment_amount]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Partner_Payment] ADD  CONSTRAINT [DF_Partner_Payment_amount]  DEFAULT ((0)) FOR [amount]
GO
/****** Object:  Default [DF_Partner_Payment_TransSummary]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Partner_Payment] ADD  CONSTRAINT [DF_Partner_Payment_TransSummary]  DEFAULT ('') FOR [TransSummary]
GO
/****** Object:  Default [DF_Partner_Payment_TransDate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Partner_Payment] ADD  CONSTRAINT [DF_Partner_Payment_TransDate]  DEFAULT (getdate()) FOR [TransDate]
GO
/****** Object:  Default [DF_Partner_Payment_CurrentBalance]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Partner_Payment] ADD  CONSTRAINT [DF_Partner_Payment_CurrentBalance]  DEFAULT ((0)) FOR [CurrentBalance]
GO
/****** Object:  Default [DF_Partner_Payment_NextPayDate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Partner_Payment] ADD  CONSTRAINT [DF_Partner_Payment_NextPayDate]  DEFAULT (getdate()) FOR [NextPayDate]
GO
/****** Object:  Default [DF_Partner_Payment_P_version]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Partner_Payment] ADD  CONSTRAINT [DF_Partner_Payment_P_version]  DEFAULT ('T') FOR [P_version]
GO
/****** Object:  Default [DF_Partner_Payment_P_name]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Partner_Payment] ADD  CONSTRAINT [DF_Partner_Payment_P_name]  DEFAULT ('Trial') FOR [P_name]
GO
/****** Object:  Default [passwordrequestsfrompidDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[passwordrequests] ADD  CONSTRAINT [passwordrequestsfrompidDefault]  DEFAULT ('') FOR [frompid]
GO
/****** Object:  Default [passwordrequeststopidDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[passwordrequests] ADD  CONSTRAINT [passwordrequeststopidDefault]  DEFAULT ('') FOR [topid]
GO
/****** Object:  Default [passwordrequestsfromemailDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[passwordrequests] ADD  CONSTRAINT [passwordrequestsfromemailDefault]  DEFAULT ('') FOR [fromemail]
GO
/****** Object:  Default [passwordrequestsfnameDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[passwordrequests] ADD  CONSTRAINT [passwordrequestsfnameDefault]  DEFAULT ('') FOR [fname]
GO
/****** Object:  Default [passwordrequestslnameDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[passwordrequests] ADD  CONSTRAINT [passwordrequestslnameDefault]  DEFAULT ('') FOR [lname]
GO
/****** Object:  Default [[dbo]].[paymentApproved]]pidDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[paymentApproved] ADD  CONSTRAINT [[dbo]].[paymentApproved]]pidDefault]  DEFAULT ('') FOR [pid]
GO
/****** Object:  Default [[dbo]].[paymentApproved]]amtapprovedDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[paymentApproved] ADD  CONSTRAINT [[dbo]].[paymentApproved]]amtapprovedDefault]  DEFAULT ((0)) FOR [amtapproved]
GO
/****** Object:  Default [paymentApprovedapprovaldateDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[paymentApproved] ADD  CONSTRAINT [paymentApprovedapprovaldateDefault]  DEFAULT (getdate()) FOR [approvaldate]
GO
/****** Object:  Default [paymentApprovedpaymentnumberDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[paymentApproved] ADD  CONSTRAINT [paymentApprovedpaymentnumberDefault]  DEFAULT ('') FOR [paymentnumber]
GO
/****** Object:  Default [[dbo]].[paymentApproved]]paymentdateDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[paymentApproved] ADD  CONSTRAINT [[dbo]].[paymentApproved]]paymentdateDefault]  DEFAULT (getdate()) FOR [paymentdate]
GO
/****** Object:  Default [[dbo]].[paymentApproved]]payidDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[paymentApproved] ADD  CONSTRAINT [[dbo]].[paymentApproved]]payidDefault]  DEFAULT ('') FOR [payid]
GO
/****** Object:  Default [[dbo]].[paymentApproved]]amtpaidDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[paymentApproved] ADD  CONSTRAINT [[dbo]].[paymentApproved]]amtpaidDefault]  DEFAULT ((0)) FOR [amtpaid]
GO
/****** Object:  Default [[dbo]].[paymentApproved]]actualpaymentdateDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[paymentApproved] ADD  CONSTRAINT [[dbo]].[paymentApproved]]actualpaymentdateDefault]  DEFAULT ('') FOR [actualpaymentdate]
GO
/****** Object:  Default [photophotonameDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[photo] ADD  CONSTRAINT [photophotonameDefault]  DEFAULT ('') FOR [photoname]
GO
/****** Object:  Default [photophotopathDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[photo] ADD  CONSTRAINT [photophotopathDefault]  DEFAULT ('') FOR [photopath]
GO
/****** Object:  Default [DF_photo_pid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[photo] ADD  CONSTRAINT [DF_photo_pid]  DEFAULT ((0)) FOR [pid]
GO
/****** Object:  Default [photoactiveDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[photo] ADD  CONSTRAINT [photoactiveDefault]  DEFAULT ('N') FOR [active]
GO
/****** Object:  Default [photodatasizeDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[photo] ADD  CONSTRAINT [photodatasizeDefault]  DEFAULT ('') FOR [datasize]
GO
/****** Object:  Default [photopasswDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[photo] ADD  CONSTRAINT [photopasswDefault]  DEFAULT ('') FOR [passw]
GO
/****** Object:  Default [photouploaddateDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[photo] ADD  CONSTRAINT [photouploaddateDefault]  DEFAULT (getdate()) FOR [uploaddate]
GO
/****** Object:  Default [DF_photo_mainphoto]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[photo] ADD  CONSTRAINT [DF_photo_mainphoto]  DEFAULT ('N') FOR [mainphoto]
GO
/****** Object:  Default [DF_photo_isimported]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[photo] ADD  CONSTRAINT [DF_photo_isimported]  DEFAULT ('N') FOR [isimported]
GO
/****** Object:  Default [DF_photo_email]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[photo] ADD  CONSTRAINT [DF_photo_email]  DEFAULT ('') FOR [email]
GO
/****** Object:  Default [DF_pole_Que_CreateMaster_QuestionId]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[pole_Que_CreateMaster] ADD  CONSTRAINT [DF_pole_Que_CreateMaster_QuestionId]  DEFAULT ('') FOR [QuestionId]
GO
/****** Object:  Default [DF_pole_Que_CreateMaster_QsnDesc]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[pole_Que_CreateMaster] ADD  CONSTRAINT [DF_pole_Que_CreateMaster_QsnDesc]  DEFAULT ('') FOR [QsnDesc]
GO
/****** Object:  Default [DF_pole_Que_CreateMaster_CorrectOption]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[pole_Que_CreateMaster] ADD  CONSTRAINT [DF_pole_Que_CreateMaster_CorrectOption]  DEFAULT ((0)) FOR [CorrectOption]
GO
/****** Object:  Default [DF_pole_Que_CreateMaster_Marks]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[pole_Que_CreateMaster] ADD  CONSTRAINT [DF_pole_Que_CreateMaster_Marks]  DEFAULT ((0)) FOR [Marks]
GO
/****** Object:  Default [DF_pole_Que_CreateMaster_CreationloginId]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[pole_Que_CreateMaster] ADD  CONSTRAINT [DF_pole_Que_CreateMaster_CreationloginId]  DEFAULT ((0)) FOR [CreationloginId]
GO
/****** Object:  Default [DF_pole_Que_CreateMaster_CreationDate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[pole_Que_CreateMaster] ADD  CONSTRAINT [DF_pole_Que_CreateMaster_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
/****** Object:  Default [DF_pole_Que_CreateMaster_IsApprove]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[pole_Que_CreateMaster] ADD  CONSTRAINT [DF_pole_Que_CreateMaster_IsApprove]  DEFAULT ('Y') FOR [IsApprove]
GO
/****** Object:  Default [ProfileheadlineDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [ProfileheadlineDefault]  DEFAULT ('') FOR [headline]
GO
/****** Object:  Default [ProfilefnameDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [ProfilefnameDefault]  DEFAULT ('') FOR [fname]
GO
/****** Object:  Default [ProfilelnameDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [ProfilelnameDefault]  DEFAULT ('') FOR [lname]
GO
/****** Object:  Default [[dbo]].[Profile]]bdateDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]bdateDefault]  DEFAULT (getdate()) FOR [bdate]
GO
/****** Object:  Default [ProfilepurposeDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [ProfilepurposeDefault]  DEFAULT ('') FOR [purpose]
GO
/****** Object:  Default [ProfilegenderDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [ProfilegenderDefault]  DEFAULT ('M') FOR [gender]
GO
/****** Object:  Default [[dbo]].[Profile]]emailDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]emailDefault]  DEFAULT ('') FOR [email]
GO
/****** Object:  Default [[dbo]].[Profile]]countryidDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]countryidDefault]  DEFAULT ((1)) FOR [countryid]
GO
/****** Object:  Default [[dbo]].[Profile]]countrynameDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]countrynameDefault]  DEFAULT ('') FOR [countryname]
GO
/****** Object:  Default [[dbo]].[Profile]]stateDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]stateDefault]  DEFAULT ('') FOR [state]
GO
/****** Object:  Default [ProfilecitynameDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [ProfilecitynameDefault]  DEFAULT ('') FOR [cityname]
GO
/****** Object:  Default [ProfilewhoamiDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [ProfilewhoamiDefault]  DEFAULT ('') FOR [whoami]
GO
/****** Object:  Default [ProfilelookingforDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [ProfilelookingforDefault]  DEFAULT ('') FOR [lookingfor]
GO
/****** Object:  Default [[dbo]].[Profile]]profiledateDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]profiledateDefault]  DEFAULT (getdate()) FOR [profiledate]
GO
/****** Object:  Default [[dbo]].[Profile]]LastVisitedDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]LastVisitedDefault]  DEFAULT (getdate()) FOR [LastVisited]
GO
/****** Object:  Default [[dbo]].[Profile]]lastupdatedDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]lastupdatedDefault]  DEFAULT (getdate()) FOR [lastupdated]
GO
/****** Object:  Default [[dbo]].[Profile]]bannedDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]bannedDefault]  DEFAULT ('N') FOR [banned]
GO
/****** Object:  Default [[dbo]].[Profile]]ipaddressDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]ipaddressDefault]  DEFAULT ('') FOR [ipaddress]
GO
/****** Object:  Default [[dbo]].[Profile]]maritalstatusDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]maritalstatusDefault]  DEFAULT ('') FOR [maritalstatus]
GO
/****** Object:  Default [[dbo]].[Profile]]mothertoungeDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]mothertoungeDefault]  DEFAULT ('') FOR [mothertounge]
GO
/****** Object:  Default [[dbo]].[Profile]]heightDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]heightDefault]  DEFAULT ((0)) FOR [height]
GO
/****** Object:  Default [[dbo]].[Profile]]annualincomeDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]annualincomeDefault]  DEFAULT ('') FOR [annualincome]
GO
/****** Object:  Default [[dbo]].[Profile]]familydetailsDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]familydetailsDefault]  DEFAULT ('') FOR [familydetails]
GO
/****** Object:  Default [[dbo]].[Profile]]professionDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]professionDefault]  DEFAULT ('') FOR [profession]
GO
/****** Object:  Default [[dbo]].[Profile]]passwDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]passwDefault]  DEFAULT ('') FOR [passw]
GO
/****** Object:  Default [[dbo]].[Profile]]htnameDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]htnameDefault]  DEFAULT ('') FOR [htname]
GO
/****** Object:  Default [[dbo]].[Profile]]castenameDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]castenameDefault]  DEFAULT ('') FOR [castename]
GO
/****** Object:  Default [[dbo]].[Profile]]eyesightDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]eyesightDefault]  DEFAULT ('') FOR [eyesight]
GO
/****** Object:  Default [[dbo]].[Profile]]wtDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]wtDefault]  DEFAULT ('') FOR [wt]
GO
/****** Object:  Default [[dbo]].[Profile]]complexionDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]complexionDefault]  DEFAULT ('') FOR [complexion]
GO
/****** Object:  Default [[dbo]].[Profile]]casteDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]casteDefault]  DEFAULT ('') FOR [caste]
GO
/****** Object:  Default [[dbo]].[Profile]]verifiedemailDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]verifiedemailDefault]  DEFAULT ('Y') FOR [verifiedemail]
GO
/****** Object:  Default [[dbo]].[Profile]]religionDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]religionDefault]  DEFAULT ('') FOR [religion]
GO
/****** Object:  Default [[dbo]].[Profile]]zipcodeDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]zipcodeDefault]  DEFAULT ('') FOR [zipcode]
GO
/****** Object:  Default [DF_Profile_ref1]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_ref1]  DEFAULT ((0)) FOR [ref1]
GO
/****** Object:  Default [[dbo]].[Profile]]approvedDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]approvedDefault]  DEFAULT ('Y') FOR [approved]
GO
/****** Object:  Default [[dbo]].[Profile]]hidDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]hidDefault]  DEFAULT ('N') FOR [hid]
GO
/****** Object:  Default [[dbo]].[Profile]]isonlinenowDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]isonlinenowDefault]  DEFAULT ('N') FOR [isonlinenow]
GO
/****** Object:  Default [[dbo]].[Profile]]ethnicDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]ethnicDefault]  DEFAULT ('') FOR [ethnic]
GO
/****** Object:  Default [[dbo]].[Profile]]starsignDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]starsignDefault]  DEFAULT ('') FOR [starsign]
GO
/****** Object:  Default [[dbo]].[Profile]]haircolorDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]haircolorDefault]  DEFAULT ('') FOR [haircolor]
GO
/****** Object:  Default [[dbo]].[Profile]]educationDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]educationDefault]  DEFAULT ('') FOR [education]
GO
/****** Object:  Default [[dbo]].[Profile]]natureDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]natureDefault]  DEFAULT ('') FOR [nature]
GO
/****** Object:  Default [[dbo]].[Profile]]smokeDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]smokeDefault]  DEFAULT ('') FOR [smoke]
GO
/****** Object:  Default [[dbo]].[Profile]]DrinkDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]DrinkDefault]  DEFAULT ('') FOR [Drink]
GO
/****** Object:  Default [[dbo]].[Profile]]dietDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]dietDefault]  DEFAULT ('') FOR [diet]
GO
/****** Object:  Default [[dbo]].[Profile]]drugsDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]drugsDefault]  DEFAULT ('') FOR [drugs]
GO
/****** Object:  Default [[dbo]].[Profile]]childrenDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]childrenDefault]  DEFAULT ('') FOR [children]
GO
/****** Object:  Default [[dbo]].[Profile]]thoughtsofmarriageDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]thoughtsofmarriageDefault]  DEFAULT ('') FOR [thoughtsofmarriage]
GO
/****** Object:  Default [[dbo]].[Profile]]politicalDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]politicalDefault]  DEFAULT ('') FOR [political]
GO
/****** Object:  Default [[dbo]].[Profile]]visibletoallDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]visibletoallDefault]  DEFAULT ('Y') FOR [visibletoall]
GO
/****** Object:  Default [[dbo]].[Profile]]ref2Default]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]ref2Default]  DEFAULT ('') FOR [ref2]
GO
/****** Object:  Default [[dbo]].[Profile]]ref1valDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]ref1valDefault]  DEFAULT ((0)) FOR [ref1val]
GO
/****** Object:  Default [[dbo]].[Profile]]ref2valDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]ref2valDefault]  DEFAULT ((0)) FOR [ref2val]
GO
/****** Object:  Default [[dbo]].[Profile]]paidDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]paidDefault]  DEFAULT ('N') FOR [paid]
GO
/****** Object:  Default [[dbo]].[Profile]]SuspDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]SuspDefault]  DEFAULT ('N') FOR [Susp]
GO
/****** Object:  Default [[dbo]].[Profile]]isdoubtfulDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]isdoubtfulDefault]  DEFAULT ('N') FOR [isdoubtful]
GO
/****** Object:  Default [[dbo]].[Profile]]ipcountryDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]ipcountryDefault]  DEFAULT ('') FOR [ipcountry]
GO
/****** Object:  Default [[dbo]].[Profile]]newoffersDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]newoffersDefault]  DEFAULT ('Y') FOR [newoffers]
GO
/****** Object:  Default [[dbo]].[Profile]]msgcycleDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]msgcycleDefault]  DEFAULT ((0)) FOR [msgcycle]
GO
/****** Object:  Default [[dbo]].[Profile]]adminemailDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [[dbo]].[Profile]]adminemailDefault]  DEFAULT ('Y') FOR [adminemail]
GO
/****** Object:  Default [DF_Profile_photo]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_photo]  DEFAULT ('') FOR [photo]
GO
/****** Object:  Default [DF_Profile_premiummem]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_premiummem]  DEFAULT ('N') FOR [premiummem]
GO
/****** Object:  Default [DF_Profile_prmstartdate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_prmstartdate]  DEFAULT (getdate()) FOR [prmstartdate]
GO
/****** Object:  Default [DF_Profile_prmenddate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_prmenddate]  DEFAULT (getdate()) FOR [prmenddate]
GO
/****** Object:  Default [DF_Profile_mobile]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_mobile]  DEFAULT ('') FOR [mobile]
GO
/****** Object:  Default [DF_Profile_isvalidmobile]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_isvalidmobile]  DEFAULT ('N') FOR [isvalidmobile]
GO
/****** Object:  Default [DF_Profile_emailsent]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_emailsent]  DEFAULT ('N') FOR [emailsent]
GO
/****** Object:  Default [DF_Profile_plimusrefnumber]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_plimusrefnumber]  DEFAULT ('') FOR [plimusrefnumber]
GO
/****** Object:  Default [DF_Profile_photopassw]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_photopassw]  DEFAULT ('') FOR [photopassw]
GO
/****** Object:  Default [DF_Profile_pstatus]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_pstatus]  DEFAULT ('Pending') FOR [pstatus]
GO
/****** Object:  Default [DF_Profile_matchalert]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_matchalert]  DEFAULT ('Y') FOR [matchalert]
GO
/****** Object:  Default [DF_Profile_mrole]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_mrole]  DEFAULT ('') FOR [mrole]
GO
/****** Object:  Default [DF_Profile_isbouncing]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_isbouncing]  DEFAULT ((0)) FOR [isbouncing]
GO
/****** Object:  Default [profile_hasinvitde]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [profile_hasinvitde]  DEFAULT ('N') FOR [hasInvited]
GO
/****** Object:  Default [DF_Profile_facebookpost]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_facebookpost]  DEFAULT ('N') FOR [facebookpost]
GO
/****** Object:  Default [DF_Profile_FB_id]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_FB_id]  DEFAULT ('') FOR [FB_id]
GO
/****** Object:  Default [DF_Profile_addme]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_addme]  DEFAULT ('N') FOR [addme]
GO
/****** Object:  Default [DF_Profile_msg_count]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_msg_count]  DEFAULT ((0)) FOR [msg_count]
GO
/****** Object:  Default [DF_Profile_Subs_Plan]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_Subs_Plan]  DEFAULT ((0)) FOR [Subs_Plan]
GO
/****** Object:  Default [DF_Profile_Msg_Left]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_Msg_Left]  DEFAULT ((0)) FOR [Msg_Left]
GO
/****** Object:  Default [DF_Profile_P_MinHeight]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_MinHeight]  DEFAULT ((0)) FOR [P_MinHeight]
GO
/****** Object:  Default [DF_Profile_P_MaxHeight]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_MaxHeight]  DEFAULT ((30)) FOR [P_MaxHeight]
GO
/****** Object:  Default [DF_Profile_P_MinAge]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_MinAge]  DEFAULT ((18)) FOR [P_MinAge]
GO
/****** Object:  Default [DF_Profile_P_MaxAge]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_MaxAge]  DEFAULT ((60)) FOR [P_MaxAge]
GO
/****** Object:  Default [DF_Profile_P_MStatus]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_MStatus]  DEFAULT ('') FOR [P_MStatus]
GO
/****** Object:  Default [DF_Profile_P_Religion]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_Religion]  DEFAULT ('') FOR [P_Religion]
GO
/****** Object:  Default [DF_Profile_P_cast]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_cast]  DEFAULT ('') FOR [P_cast]
GO
/****** Object:  Default [DF_Profile_P_motherTounge]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_motherTounge]  DEFAULT ('') FOR [P_motherTounge]
GO
/****** Object:  Default [DF_Profile_P_Education]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_Education]  DEFAULT ('') FOR [P_Education]
GO
/****** Object:  Default [DF_Profile_P_Diet]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_Diet]  DEFAULT ('') FOR [P_Diet]
GO
/****** Object:  Default [DF_Profile_P_Drinks]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_Drinks]  DEFAULT ('') FOR [P_Drinks]
GO
/****** Object:  Default [DF_Profile_P_Smoke]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_Smoke]  DEFAULT ('') FOR [P_Smoke]
GO
/****** Object:  Default [DF_Profile_P_Drugs]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_Drugs]  DEFAULT ('') FOR [P_Drugs]
GO
/****** Object:  Default [DF_Profile_P_BodyType]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_BodyType]  DEFAULT ('') FOR [P_BodyType]
GO
/****** Object:  Default [DF_Profile_P_HairColor]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_HairColor]  DEFAULT ('') FOR [P_HairColor]
GO
/****** Object:  Default [DF_Profile_P_StarSign]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_StarSign]  DEFAULT ('') FOR [P_StarSign]
GO
/****** Object:  Default [DF_Profile_P_SkinColor]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_SkinColor]  DEFAULT ('') FOR [P_SkinColor]
GO
/****** Object:  Default [DF_Profile_P_Income]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_Income]  DEFAULT ((0)) FOR [P_Income]
GO
/****** Object:  Default [DF_Profile_P_HEight_Name]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_P_HEight_Name]  DEFAULT ('') FOR [P_HEight_Name]
GO
/****** Object:  Default [DF_Profile_RegWebID]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_RegWebID]  DEFAULT ((0)) FOR [RegWebID]
GO
/****** Object:  Default [DF_Profile_DomainName]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_DomainName]  DEFAULT ('') FOR [DomainName]
GO
/****** Object:  Default [DF_Profile_GPlusUrl]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_GPlusUrl]  DEFAULT ('') FOR [GPlusUrl]
GO
/****** Object:  Default [DF_Profile_cityid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_cityid]  DEFAULT ((0)) FOR [cityid]
GO
/****** Object:  Default [DF_Profile_stateid_1]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_stateid_1]  DEFAULT ((0)) FOR [stateid]
GO
/****** Object:  Default [DF_Profile_isimported]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_isimported]  DEFAULT ('N') FOR [isimported]
GO
/****** Object:  Default [profileviewspidofDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[profileviews] ADD  CONSTRAINT [profileviewspidofDefault]  DEFAULT ('') FOR [pidof]
GO
/****** Object:  Default [profileviewsipaddressDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[profileviews] ADD  CONSTRAINT [profileviewsipaddressDefault]  DEFAULT ('') FOR [ipaddress]
GO
/****** Object:  Default [profileviewsvieweddateDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[profileviews] ADD  CONSTRAINT [profileviewsvieweddateDefault]  DEFAULT (getdate()) FOR [vieweddate]
GO
/****** Object:  Default [DF_QuotesCommnets_commnetdate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[QuotesCommnets] ADD  CONSTRAINT [DF_QuotesCommnets_commnetdate]  DEFAULT (getdate()) FOR [commnetdate]
GO
/****** Object:  Default [DF_QuotesCommnets_approved]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[QuotesCommnets] ADD  CONSTRAINT [DF_QuotesCommnets_approved]  DEFAULT ('Y') FOR [approved]
GO
/****** Object:  Default [ReferalsreferdbyDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Referals] ADD  CONSTRAINT [ReferalsreferdbyDefault]  DEFAULT ('') FOR [referdby]
GO
/****** Object:  Default [Referalsrefer2Default]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Referals] ADD  CONSTRAINT [Referalsrefer2Default]  DEFAULT ('') FOR [refer2]
GO
/****** Object:  Default [Referalsref1valDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Referals] ADD  CONSTRAINT [Referalsref1valDefault]  DEFAULT ((0)) FOR [ref1val]
GO
/****** Object:  Default [Referalsref2valDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Referals] ADD  CONSTRAINT [Referalsref2valDefault]  DEFAULT ((0)) FOR [ref2val]
GO
/****** Object:  Default [ReferalsipaddressDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Referals] ADD  CONSTRAINT [ReferalsipaddressDefault]  DEFAULT ('') FOR [ipaddress]
GO
/****** Object:  Default [ReferalspaidDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Referals] ADD  CONSTRAINT [ReferalspaidDefault]  DEFAULT ('Y') FOR [paid]
GO
/****** Object:  Default [ReferalsrefdateDefault]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Referals] ADD  CONSTRAINT [ReferalsrefdateDefault]  DEFAULT (getdate()) FOR [refdate]
GO
/****** Object:  Default [DF_send_msg_msgtoid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[send_msg] ADD  CONSTRAINT [DF_send_msg_msgtoid]  DEFAULT ((0)) FOR [msgtoid]
GO
/****** Object:  Default [DF_send_msg_msgfromid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[send_msg] ADD  CONSTRAINT [DF_send_msg_msgfromid]  DEFAULT ((0)) FOR [msgfromid]
GO
/****** Object:  Default [DF_send_msg_msg]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[send_msg] ADD  CONSTRAINT [DF_send_msg_msg]  DEFAULT ('') FOR [msg]
GO
/****** Object:  Default [DF_send_msg_msgdate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[send_msg] ADD  CONSTRAINT [DF_send_msg_msgdate]  DEFAULT (getdate()) FOR [msgdate]
GO
/****** Object:  Default [DF_send_msg_aproveSender]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[send_msg] ADD  CONSTRAINT [DF_send_msg_aproveSender]  DEFAULT ('N') FOR [aproveSender]
GO
/****** Object:  Default [DF_send_msg_msgissend]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[send_msg] ADD  CONSTRAINT [DF_send_msg_msgissend]  DEFAULT ('N') FOR [msgissend]
GO
/****** Object:  Default [DF_siteactivity_activity]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[siteactivity] ADD  CONSTRAINT [DF_siteactivity_activity]  DEFAULT ('') FOR [activity]
GO
/****** Object:  Default [DF_siteactivity_activitydate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[siteactivity] ADD  CONSTRAINT [DF_siteactivity_activitydate]  DEFAULT (getdate()) FOR [activitydate]
GO
/****** Object:  Default [DF_siteactivity_photo]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[siteactivity] ADD  CONSTRAINT [DF_siteactivity_photo]  DEFAULT ('') FOR [photo]
GO
/****** Object:  Default [siteActivity_Pk_ID]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[siteactivity] ADD  CONSTRAINT [siteActivity_Pk_ID]  DEFAULT ((0)) FOR [pk_Id]
GO
/****** Object:  Default [siteActivity_actType]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[siteactivity] ADD  CONSTRAINT [siteActivity_actType]  DEFAULT ('') FOR [actType]
GO
/****** Object:  Default [DF_SubCategory_CatId]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[SubCategory] ADD  CONSTRAINT [DF_SubCategory_CatId]  DEFAULT ((0)) FOR [CatId]
GO
/****** Object:  Default [DF_SubCategory_SubCatTitle]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[SubCategory] ADD  CONSTRAINT [DF_SubCategory_SubCatTitle]  DEFAULT ('') FOR [SubCatTitle]
GO
/****** Object:  Default [DF_SubCategory_SubCatDesc]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[SubCategory] ADD  CONSTRAINT [DF_SubCategory_SubCatDesc]  DEFAULT ('') FOR [SubCatDesc]
GO
/****** Object:  Default [DF_SubCategory_LastTopic]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[SubCategory] ADD  CONSTRAINT [DF_SubCategory_LastTopic]  DEFAULT ('') FOR [LastTopic]
GO
/****** Object:  Default [DF_SubCategory_StartDate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[SubCategory] ADD  CONSTRAINT [DF_SubCategory_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
/****** Object:  Default [DF_SubCategory_IsApprover]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[SubCategory] ADD  CONSTRAINT [DF_SubCategory_IsApprover]  DEFAULT ('N') FOR [IsApprover]
GO
/****** Object:  Default [DF_SubCategory_LastTopicid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[SubCategory] ADD  CONSTRAINT [DF_SubCategory_LastTopicid]  DEFAULT ((0)) FOR [LastTopicid]
GO
/****** Object:  Default [DF_Support_UserMobile]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support] ADD  CONSTRAINT [DF_Support_UserMobile]  DEFAULT ('') FOR [UserMobile]
GO
/****** Object:  Default [DF_Support_EmailID]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support] ADD  CONSTRAINT [DF_Support_EmailID]  DEFAULT ('') FOR [EmailID]
GO
/****** Object:  Default [DF_Support_UserName]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support] ADD  CONSTRAINT [DF_Support_UserName]  DEFAULT ('') FOR [UserName]
GO
/****** Object:  Default [DF_Support_ComplaintHead]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support] ADD  CONSTRAINT [DF_Support_ComplaintHead]  DEFAULT ('') FOR [ComplaintHead]
GO
/****** Object:  Default [DF_Support_ComplaintDesc]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support] ADD  CONSTRAINT [DF_Support_ComplaintDesc]  DEFAULT ('') FOR [ComplaintDesc]
GO
/****** Object:  Default [DF_Support_ComplaintDate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support] ADD  CONSTRAINT [DF_Support_ComplaintDate]  DEFAULT (getdate()) FOR [ComplaintDate]
GO
/****** Object:  Default [DF_Support_IsResolved]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support] ADD  CONSTRAINT [DF_Support_IsResolved]  DEFAULT ('N') FOR [IsResolved]
GO
/****** Object:  Default [DF_Support_ResolvedBy]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support] ADD  CONSTRAINT [DF_Support_ResolvedBy]  DEFAULT ((0)) FOR [ResolvedBy]
GO
/****** Object:  Default [DF_Support_ResolvedByName]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support] ADD  CONSTRAINT [DF_Support_ResolvedByName]  DEFAULT ('') FOR [ResolvedByName]
GO
/****** Object:  Default [DF_Support_comments_ComplaintsID]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support_comments] ADD  CONSTRAINT [DF_Support_comments_ComplaintsID]  DEFAULT ((0)) FOR [ComplaintsID]
GO
/****** Object:  Default [DF_Support_comments_Comments]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support_comments] ADD  CONSTRAINT [DF_Support_comments_Comments]  DEFAULT ('') FOR [Comments]
GO
/****** Object:  Default [DF_Support_comments_CommentsBy]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support_comments] ADD  CONSTRAINT [DF_Support_comments_CommentsBy]  DEFAULT ((0)) FOR [CommentsBy]
GO
/****** Object:  Default [DF_Support_comments_CommentsByName]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support_comments] ADD  CONSTRAINT [DF_Support_comments_CommentsByName]  DEFAULT ('') FOR [CommentsByName]
GO
/****** Object:  Default [DF_Support_comments_IsAdmin]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support_comments] ADD  CONSTRAINT [DF_Support_comments_IsAdmin]  DEFAULT ('Y') FOR [IsAdmin]
GO
/****** Object:  Default [DF_User_Support_comments_CommentsDate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Support_comments] ADD  CONSTRAINT [DF_User_Support_comments_CommentsDate]  DEFAULT (getdate()) FOR [CommentsDate]
GO
/****** Object:  Default [DF__tbl_Quote__candi__47C69FAC]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[tbl_Quotes] ADD  CONSTRAINT [DF__tbl_Quote__candi__47C69FAC]  DEFAULT ((0)) FOR [candiid]
GO
/****** Object:  Default [DF__tbl_Quote__quote__48BAC3E5]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[tbl_Quotes] ADD  CONSTRAINT [DF__tbl_Quote__quote__48BAC3E5]  DEFAULT (getdate()) FOR [quotesdate]
GO
/****** Object:  Default [DF__tbl_Quote__Quote__49AEE81E]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[tbl_Quotes] ADD  CONSTRAINT [DF__tbl_Quote__Quote__49AEE81E]  DEFAULT ('') FOR [Quotessub]
GO
/****** Object:  Default [DF__tbl_Quote__Quote__4AA30C57]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[tbl_Quotes] ADD  CONSTRAINT [DF__tbl_Quote__Quote__4AA30C57]  DEFAULT ('') FOR [QuotesDesc]
GO
/****** Object:  Default [DF__tbl_Quote__IsApp__4B973090]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[tbl_Quotes] ADD  CONSTRAINT [DF__tbl_Quote__IsApp__4B973090]  DEFAULT ('Y') FOR [IsApproved]
GO
/****** Object:  Default [DF__tbl_ratin__fk_po__5555A4F4]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[tbl_rating_typeWise] ADD  CONSTRAINT [DF__tbl_ratin__fk_po__5555A4F4]  DEFAULT ((0)) FOR [fk_postId]
GO
/****** Object:  Default [DF__tbl_rating__rate__5649C92D]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[tbl_rating_typeWise] ADD  CONSTRAINT [DF__tbl_rating__rate__5649C92D]  DEFAULT ((0)) FOR [rate]
GO
/****** Object:  Default [DF__tbl_ratin__fk_us__573DED66]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[tbl_rating_typeWise] ADD  CONSTRAINT [DF__tbl_ratin__fk_us__573DED66]  DEFAULT ((0)) FOR [fk_userid]
GO
/****** Object:  Default [DF_topearners_mid]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[topearners] ADD  CONSTRAINT [DF_topearners_mid]  DEFAULT ((0)) FOR [mid]
GO
/****** Object:  Default [DF_topearners_earnedamt]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[topearners] ADD  CONSTRAINT [DF_topearners_earnedamt]  DEFAULT ((0)) FOR [earnedamt]
GO
/****** Object:  Default [DF_topearners_earndate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[topearners] ADD  CONSTRAINT [DF_topearners_earndate]  DEFAULT (getdate()) FOR [earndate]
GO
/****** Object:  Default [DF_topearners_pstatus]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[topearners] ADD  CONSTRAINT [DF_topearners_pstatus]  DEFAULT ('pending') FOR [pstatus]
GO
/****** Object:  Default [DF_topearners_referd_1]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[topearners] ADD  CONSTRAINT [DF_topearners_referd_1]  DEFAULT ((0)) FOR [referd]
GO
/****** Object:  Default [DF_topearners_regdate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[topearners] ADD  CONSTRAINT [DF_topearners_regdate]  DEFAULT (getdate()) FOR [regdatetp]
GO
/****** Object:  Default [DF_Topic_Topic]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Topic] ADD  CONSTRAINT [DF_Topic_Topic]  DEFAULT ('') FOR [TopicTitle]
GO
/****** Object:  Default [DF_Topic_StartDate]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Topic] ADD  CONSTRAINT [DF_Topic_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
/****** Object:  Default [DF_Topic_IsApproved]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Topic] ADD  CONSTRAINT [DF_Topic_IsApproved]  DEFAULT ('N') FOR [IsApproved]
GO
/****** Object:  Default [DF_Topic_TotalView]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Topic] ADD  CONSTRAINT [DF_Topic_TotalView]  DEFAULT ((0)) FOR [TotalView]
GO
/****** Object:  Default [DF_Topic_CatId]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Topic] ADD  CONSTRAINT [DF_Topic_CatId]  DEFAULT ((0)) FOR [CatId]
GO
/****** Object:  Default [DF_Topic_LastAnsId]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Topic] ADD  CONSTRAINT [DF_Topic_LastAnsId]  DEFAULT ((0)) FOR [LastAnsId]
GO
/****** Object:  Default [DF_TopicAnswer_TopicAns]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[TopicAnswer] ADD  CONSTRAINT [DF_TopicAnswer_TopicAns]  DEFAULT ('') FOR [TopicAns]
GO
/****** Object:  Default [DF_TopicAnswer_AnsDate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[TopicAnswer] ADD  CONSTRAINT [DF_TopicAnswer_AnsDate]  DEFAULT (getdate()) FOR [AnsDate]
GO
/****** Object:  Default [DF_TopicAnswer_IsApproved]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[TopicAnswer] ADD  CONSTRAINT [DF_TopicAnswer_IsApproved]  DEFAULT ('N') FOR [IsApproved]
GO
/****** Object:  Default [DF_TopicAnswer_candiName]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[TopicAnswer] ADD  CONSTRAINT [DF_TopicAnswer_candiName]  DEFAULT ('') FOR [candiName]
GO
/****** Object:  Default [DF_topicsQnAansw_answerid]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[topicsQnAansw] ADD  CONSTRAINT [DF_topicsQnAansw_answerid]  DEFAULT ('') FOR [answerid]
GO
/****** Object:  Default [DF_topicsQnAansw_ans]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[topicsQnAansw] ADD  CONSTRAINT [DF_topicsQnAansw_ans]  DEFAULT ('') FOR [anser]
GO
/****** Object:  Default [DF_topicsQnAansw_updateddate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[topicsQnAansw] ADD  CONSTRAINT [DF_topicsQnAansw_updateddate]  DEFAULT (getdate()) FOR [updateddate]
GO
/****** Object:  Default [DF__topicsQnA__isApp__7F4BDEC0]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[topicsQnAansw] ADD  CONSTRAINT [DF__topicsQnA__isApp__7F4BDEC0]  DEFAULT ('N') FOR [isApproved]
GO
/****** Object:  Default [DF__topicsQnA__isapp__004002F9]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[topicsQnAansw] ADD  CONSTRAINT [DF__topicsQnA__isapp__004002F9]  DEFAULT ('N') FOR [isapprove]
GO
/****** Object:  Default [DF_User_Complaints_UserMobile]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints] ADD  CONSTRAINT [DF_User_Complaints_UserMobile]  DEFAULT ('') FOR [UserMobile]
GO
/****** Object:  Default [DF_User_Complaints_EmailID]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints] ADD  CONSTRAINT [DF_User_Complaints_EmailID]  DEFAULT ('') FOR [EmailID]
GO
/****** Object:  Default [DF_User_Complaints_UserName]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints] ADD  CONSTRAINT [DF_User_Complaints_UserName]  DEFAULT ('') FOR [UserName]
GO
/****** Object:  Default [DF_User_Complaints_ComplaintHead]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints] ADD  CONSTRAINT [DF_User_Complaints_ComplaintHead]  DEFAULT ('') FOR [ComplaintHead]
GO
/****** Object:  Default [DF_User_Complaints_ComplaintDesc]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints] ADD  CONSTRAINT [DF_User_Complaints_ComplaintDesc]  DEFAULT ('') FOR [ComplaintDesc]
GO
/****** Object:  Default [DF_User_Complaints_ComplaintDate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints] ADD  CONSTRAINT [DF_User_Complaints_ComplaintDate]  DEFAULT (getdate()) FOR [ComplaintDate]
GO
/****** Object:  Default [DF_User_Complaints_IsResolved]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints] ADD  CONSTRAINT [DF_User_Complaints_IsResolved]  DEFAULT ('N') FOR [IsResolved]
GO
/****** Object:  Default [DF_User_Complaints_ResolvedBy]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints] ADD  CONSTRAINT [DF_User_Complaints_ResolvedBy]  DEFAULT ((0)) FOR [ResolvedBy]
GO
/****** Object:  Default [DF_User_Complaints_ResolvedByName]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints] ADD  CONSTRAINT [DF_User_Complaints_ResolvedByName]  DEFAULT ('') FOR [ResolvedByName]
GO
/****** Object:  Default [DF_User_Complaints_Comments_ComplaintsID]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints_Comments] ADD  CONSTRAINT [DF_User_Complaints_Comments_ComplaintsID]  DEFAULT ((0)) FOR [ComplaintsID]
GO
/****** Object:  Default [DF_User_Complaints_Comments_Comments]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints_Comments] ADD  CONSTRAINT [DF_User_Complaints_Comments_Comments]  DEFAULT ('') FOR [Comments]
GO
/****** Object:  Default [DF_User_Complaints_Comments_CommentsBy]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints_Comments] ADD  CONSTRAINT [DF_User_Complaints_Comments_CommentsBy]  DEFAULT ((0)) FOR [CommentsBy]
GO
/****** Object:  Default [DF_User_Complaints_Comments_CommentsByName]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints_Comments] ADD  CONSTRAINT [DF_User_Complaints_Comments_CommentsByName]  DEFAULT ('') FOR [CommentsByName]
GO
/****** Object:  Default [DF_User_Complaints_Comments_IsAdmin]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints_Comments] ADD  CONSTRAINT [DF_User_Complaints_Comments_IsAdmin]  DEFAULT ('Y') FOR [IsAdmin]
GO
/****** Object:  Default [DF_User_Complaints_Comments_CommentsDate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Complaints_Comments] ADD  CONSTRAINT [DF_User_Complaints_Comments_CommentsDate]  DEFAULT (getdate()) FOR [CommentsDate]
GO
/****** Object:  Default [DF_User_Interest_Candiid]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Interest] ADD  CONSTRAINT [DF_User_Interest_Candiid]  DEFAULT ((0)) FOR [Candiid]
GO
/****** Object:  Default [DF_User_Interest_IntrestedIn]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Interest] ADD  CONSTRAINT [DF_User_Interest_IntrestedIn]  DEFAULT ((0)) FOR [IntrestedIn]
GO
/****** Object:  Default [DF_User_Interest_InterestDate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Interest] ADD  CONSTRAINT [DF_User_Interest_InterestDate]  DEFAULT (getdate()) FOR [InterestDate]
GO
/****** Object:  Default [DF_User_Interest_UserResponse]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Interest] ADD  CONSTRAINT [DF_User_Interest_UserResponse]  DEFAULT ('P') FOR [UserResponse]
GO
/****** Object:  Default [DF_User_Interest_UserMessage]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Interest] ADD  CONSTRAINT [DF_User_Interest_UserMessage]  DEFAULT ('') FOR [UserMessage]
GO
/****** Object:  Default [DF_User_Interest_InterestFor]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Interest] ADD  CONSTRAINT [DF_User_Interest_InterestFor]  DEFAULT ('') FOR [InterestFor]
GO
/****** Object:  Default [DF_User_Steps_IsVew]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Steps] ADD  CONSTRAINT [DF_User_Steps_IsVew]  DEFAULT ('N') FOR [IsView]
GO
/****** Object:  Default [DF_User_Steps_IsTestTaken]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Steps] ADD  CONSTRAINT [DF_User_Steps_IsTestTaken]  DEFAULT ('N') FOR [IsTestTaken]
GO
/****** Object:  Default [DF_User_Steps_IsPassTest]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[User_Steps] ADD  CONSTRAINT [DF_User_Steps_IsPassTest]  DEFAULT ('N') FOR [IsPassTest]
GO
/****** Object:  Default [usersusernameDefault]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[users] ADD  CONSTRAINT [usersusernameDefault]  DEFAULT ('') FOR [username]
GO
/****** Object:  Default [userspasswDefault]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[users] ADD  CONSTRAINT [userspasswDefault]  DEFAULT ('') FOR [passw]
GO
/****** Object:  Default [usersroleDefault]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[users] ADD  CONSTRAINT [usersroleDefault]  DEFAULT ('') FOR [role]
GO
/****** Object:  Default [DF_websolaffi_Passw]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_Passw]  DEFAULT ('') FOR [Passw]
GO
/****** Object:  Default [DF_websolaffi_firstname]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_firstname]  DEFAULT ('') FOR [firstname]
GO
/****** Object:  Default [DF_websolaffi_lastname]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_lastname]  DEFAULT ('') FOR [lastname]
GO
/****** Object:  Default [DF_websolaffi_regdate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_regdate]  DEFAULT (getdate()) FOR [regdate]
GO
/****** Object:  Default [DF_websolaffi_dateofbirth]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_dateofbirth]  DEFAULT (getdate()) FOR [dateofbirth]
GO
/****** Object:  Default [DF_websolaffi_gender]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_gender]  DEFAULT ('M') FOR [gender]
GO
/****** Object:  Default [DF_websolaffi_address1]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_address1]  DEFAULT ('') FOR [address1]
GO
/****** Object:  Default [DF_websolaffi_address2]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_address2]  DEFAULT ('') FOR [address2]
GO
/****** Object:  Default [DF_websolaffi_address3]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_address3]  DEFAULT ('') FOR [address3]
GO
/****** Object:  Default [DF_websolaffi_pincode]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_pincode]  DEFAULT ('') FOR [pincode]
GO
/****** Object:  Default [DF_websolaffi_Telephone]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_Telephone]  DEFAULT ('') FOR [Telephone]
GO
/****** Object:  Default [DF_websolaffi_mobile]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_mobile]  DEFAULT ('') FOR [mobile]
GO
/****** Object:  Default [DF_websolaffi_cityid]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_cityid]  DEFAULT ((0)) FOR [cityid]
GO
/****** Object:  Default [DF_websolaffi_cityname]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_cityname]  DEFAULT ('') FOR [cityname]
GO
/****** Object:  Default [DF_websolaffi_stateid]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_stateid]  DEFAULT ((0)) FOR [stateid]
GO
/****** Object:  Default [DF_websolaffi_statename]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_statename]  DEFAULT ('') FOR [statename]
GO
/****** Object:  Default [DF_websolaffi_countryname]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_countryname]  DEFAULT ('') FOR [countryname]
GO
/****** Object:  Default [DF_websolaffi_countryid]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_countryid]  DEFAULT ((1)) FOR [countryid]
GO
/****** Object:  Default [DF_websolaffi_education]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_education]  DEFAULT ('') FOR [education]
GO
/****** Object:  Default [DF_websolaffi_TotalExp]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_TotalExp]  DEFAULT ((0)) FOR [TotalExp]
GO
/****** Object:  Default [DF_websolaffi_CVlocation]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_CVlocation]  DEFAULT ('') FOR [CVlocation]
GO
/****** Object:  Default [DF_websolaffi_Enddate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_Enddate]  DEFAULT (getdate()) FOR [Enddate]
GO
/****** Object:  Default [DF_websolaffi_LastLogin]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_LastLogin]  DEFAULT (getdate()) FOR [LastLogin]
GO
/****** Object:  Default [DF_websolaffi_imagename]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_imagename]  DEFAULT ('') FOR [imagename]
GO
/****** Object:  Default [DF_websolaffi_imageext]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_imageext]  DEFAULT ('') FOR [imageext]
GO
/****** Object:  Default [DF_websolaffi_emailverified]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_emailverified]  DEFAULT ('N') FOR [emailverified]
GO
/****** Object:  Default [DF_websolaffi_Activated]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_Activated]  DEFAULT ('') FOR [Activated]
GO
/****** Object:  Default [DF_websolaffi_Verified]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_Verified]  DEFAULT ('') FOR [Verified]
GO
/****** Object:  Default [DF_websolaffi_blocked]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_blocked]  DEFAULT ('N') FOR [blocked]
GO
/****** Object:  Default [DF_websolaffi_mth]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_mth]  DEFAULT ((0)) FOR [mth]
GO
/****** Object:  Default [DF_websolaffi_profiletype]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_profiletype]  DEFAULT ((0)) FOR [profiletype]
GO
/****** Object:  Default [DF_websolaffi_Friendshipzone]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_Friendshipzone]  DEFAULT ('N') FOR [Friendshipzone]
GO
/****** Object:  Default [DF_websolaffi_Remail]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_Remail]  DEFAULT ('N') FOR [Remail]
GO
/****** Object:  Default [DF_websolaffi_Purpose]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_Purpose]  DEFAULT ('') FOR [Purpose]
GO
/****** Object:  Default [DF_websolaffi_referdby]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_referdby]  DEFAULT ('') FOR [referdbyold]
GO
/****** Object:  Default [DF_websolaffi_banned]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_banned]  DEFAULT ('N') FOR [banned]
GO
/****** Object:  Default [DF_websolaffi_showgads]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_showgads]  DEFAULT ('Y') FOR [showgads]
GO
/****** Object:  Default [DF_websolaffi_ipaddress]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_ipaddress]  DEFAULT ('') FOR [ipaddress]
GO
/****** Object:  Default [DF_websolaffi_industryid]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_industryid]  DEFAULT ((1)) FOR [industryid]
GO
/****** Object:  Default [DF_websolaffi_industryname]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_industryname]  DEFAULT ('') FOR [industryname]
GO
/****** Object:  Default [DF_websolaffi_jobcategoryid]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_jobcategoryid]  DEFAULT ((1)) FOR [jobcategoryid]
GO
/****** Object:  Default [DF_websolaffi_jobcategoryname]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_jobcategoryname]  DEFAULT ('') FOR [jobcategoryname]
GO
/****** Object:  Default [DF_websolaffi_designation]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_designation]  DEFAULT ('') FOR [designation]
GO
/****** Object:  Default [DF_websolaffi_companyname]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_companyname]  DEFAULT ('') FOR [companyname]
GO
/****** Object:  Default [DF_websolaffi_keywords]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_keywords]  DEFAULT ('') FOR [keywords]
GO
/****** Object:  Default [DF_websolaffi_university]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_university]  DEFAULT ('') FOR [university]
GO
/****** Object:  Default [DF_websolaffi_certification]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_certification]  DEFAULT ('') FOR [certification]
GO
/****** Object:  Default [DF_websolaffi_certifications]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_certifications]  DEFAULT ('') FOR [certifications]
GO
/****** Object:  Default [DF_websolaffi_isbouncing]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_isbouncing]  DEFAULT ('N') FOR [isbouncing]
GO
/****** Object:  Default [DF_websolaffi_adminemails]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_adminemails]  DEFAULT ('Y') FOR [adminemails]
GO
/****** Object:  Default [DF_websolaffi_Jobalerts]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_Jobalerts]  DEFAULT ('Y') FOR [Jobalerts]
GO
/****** Object:  Default [DF_websolaffi_EmailfromEmployers]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_EmailfromEmployers]  DEFAULT ('Y') FOR [EmailfromEmployers]
GO
/****** Object:  Default [DF_websolaffi_emailsent]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_emailsent]  DEFAULT ('N') FOR [emailsent]
GO
/****** Object:  Default [DF_websolaffi_hide]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_hide]  DEFAULT ('N') FOR [hide]
GO
/****** Object:  Default [DF_websolaffi_filextension]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_filextension]  DEFAULT ('') FOR [filextension]
GO
/****** Object:  Default [DF_websolaffi_isonlinenow]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_isonlinenow]  DEFAULT ('N') FOR [isonlinenow]
GO
/****** Object:  Default [DF_websolaffi_photo]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_photo]  DEFAULT ('') FOR [photo]
GO
/****** Object:  Default [DF_websolaffi_photopassw]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_photopassw]  DEFAULT ('') FOR [photopassw]
GO
/****** Object:  Default [DF_websolaffi_Smsjobalerts]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_Smsjobalerts]  DEFAULT ('Y') FOR [Smsjobalerts]
GO
/****** Object:  Default [DF_websolaffi_SmsEmployerAlert]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_SmsEmployerAlert]  DEFAULT ('Y') FOR [SmsEmployerAlert]
GO
/****** Object:  Default [DF_websolaffi_SmsInspirationalQuotes]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_SmsInspirationalQuotes]  DEFAULT ('Y') FOR [SmsInspirationalQuotes]
GO
/****** Object:  Default [DF_websolaffi_SmsFunnyQuotes]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_SmsFunnyQuotes]  DEFAULT ('Y') FOR [SmsFunnyQuotes]
GO
/****** Object:  Default [DF_websolaffi_isValidMobile]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_isValidMobile]  DEFAULT ('N') FOR [isValidMobile]
GO
/****** Object:  Default [DF_websolaffi_smsOffers]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_smsOffers]  DEFAULT ('Y') FOR [smsOffers]
GO
/****** Object:  Default [DF_websolaffi_smsAdmin]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_smsAdmin]  DEFAULT ('Y') FOR [smsAdmin]
GO
/****** Object:  Default [DF_websolaffi_photoapproved]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_photoapproved]  DEFAULT ('Y') FOR [photoapproved]
GO
/****** Object:  Default [DF_websolaffi_approvedFProfile]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_approvedFProfile]  DEFAULT ('Y') FOR [approvedFProfile]
GO
/****** Object:  Default [DF_websolaffi_ipcountry]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_ipcountry]  DEFAULT ('') FOR [ipcountry]
GO
/****** Object:  Default [DF_websolaffi_isdoubtful]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_isdoubtful]  DEFAULT ('N') FOR [isdoubtful]
GO
/****** Object:  Default [DF_websolaffi_sponsoremail]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_sponsoremail]  DEFAULT ('Y') FOR [sponsoremail]
GO
/****** Object:  Default [DF_websolaffi_hasinvited]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_hasinvited]  DEFAULT ('N') FOR [hasinvited]
GO
/****** Object:  Default [DF_websolaffi_bayt]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_bayt]  DEFAULT ('N') FOR [bayt]
GO
/****** Object:  Default [DF_websolaffi_profileheadline]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_profileheadline]  DEFAULT ('') FOR [profileheadline]
GO
/****** Object:  Default [DF_websolaffi_Ethnicity]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_Ethnicity]  DEFAULT ('') FOR [Ethnicity]
GO
/****** Object:  Default [DF_websolaffi_religion]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_religion]  DEFAULT ('') FOR [religion]
GO
/****** Object:  Default [DF_websolaffi_caste]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_caste]  DEFAULT ('') FOR [caste]
GO
/****** Object:  Default [DF_websolaffi_starsign]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_starsign]  DEFAULT ('') FOR [starsign]
GO
/****** Object:  Default [DF_websolaffi_maritalstatus]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_maritalstatus]  DEFAULT ('') FOR [maritalstatus]
GO
/****** Object:  Default [DF_websolaffi_lang]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_lang]  DEFAULT ('') FOR [lang]
GO
/****** Object:  Default [DF_websolaffi_htid]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_htid]  DEFAULT ((1)) FOR [htid]
GO
/****** Object:  Default [DF_websolaffi_htname]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_htname]  DEFAULT ('') FOR [htname]
GO
/****** Object:  Default [DF_websolaffi_wt]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_wt]  DEFAULT ('') FOR [wt]
GO
/****** Object:  Default [DF_websolaffi_skincolor]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_skincolor]  DEFAULT ('') FOR [skincolor]
GO
/****** Object:  Default [DF_websolaffi_eyesight]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_eyesight]  DEFAULT ('') FOR [eyesight]
GO
/****** Object:  Default [DF_websolaffi_aboutme]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_aboutme]  DEFAULT ('') FOR [aboutme]
GO
/****** Object:  Default [DF_websolaffi_diet]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_diet]  DEFAULT ('') FOR [diet]
GO
/****** Object:  Default [DF_websolaffi_drinks]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_drinks]  DEFAULT ('') FOR [drinks]
GO
/****** Object:  Default [DF_websolaffi_smoke]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_smoke]  DEFAULT ('') FOR [smoke]
GO
/****** Object:  Default [DF_websolaffi_drugs]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_drugs]  DEFAULT ('') FOR [drugs]
GO
/****** Object:  Default [DF_websolaffi_Susp]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_Susp]  DEFAULT ('N') FOR [Susp]
GO
/****** Object:  Default [DF_websolaffi_sponsorsent]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_sponsorsent]  DEFAULT ('N') FOR [sponsorsent]
GO
/****** Object:  Default [DF_websolaffi_ref1val]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_ref1val]  DEFAULT ((0)) FOR [ref1val]
GO
/****** Object:  Default [DF_websolaffi_baytmember]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_baytmember]  DEFAULT ('N') FOR [baytmember]
GO
/****** Object:  Default [DF_websolaffi_pstatus]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_pstatus]  DEFAULT ('Pending') FOR [pstatus]
GO
/****** Object:  Default [DF_websolaffi_visibleinSearchengine]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_visibleinSearchengine]  DEFAULT ('Y') FOR [visibleinSearchengine]
GO
/****** Object:  Default [DF_websolaffi_showpvtinfo]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_showpvtinfo]  DEFAULT ('Y') FOR [showpvtinfo]
GO
/****** Object:  Default [DF_websolaffi_schoolname]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_schoolname]  DEFAULT ('') FOR [schoolname]
GO
/****** Object:  Default [DF_websolaffi_schoolyear]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_schoolyear]  DEFAULT ('') FOR [schoolyear]
GO
/****** Object:  Default [DF_websolaffi_collename]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_collename]  DEFAULT ('') FOR [collename]
GO
/****** Object:  Default [DF_websolaffi_colyear]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_colyear]  DEFAULT ('') FOR [colyear]
GO
/****** Object:  Default [DF_websolaffi_companywebsite]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_companywebsite]  DEFAULT ('') FOR [companywebsite]
GO
/****** Object:  Default [DF_websolaffi_allowprofilecomments]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_allowprofilecomments]  DEFAULT ('Y') FOR [allowprofilecomments]
GO
/****** Object:  Default [DF_websolaffi_FrinedshipRequests]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_FrinedshipRequests]  DEFAULT ('Y') FOR [FrinedshipRequests]
GO
/****** Object:  Default [DF_websolaffi_KnowsEmailCanAdd]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_KnowsEmailCanAdd]  DEFAULT ('N') FOR [KnowsEmailCanAdd]
GO
/****** Object:  Default [DF_websolaffi_blacklistedemail]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_blacklistedemail]  DEFAULT ('N') FOR [blacklistedemail]
GO
/****** Object:  Default [DF_websolaffi_newsnFun]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_newsnFun]  DEFAULT ('Y') FOR [newsnFun]
GO
/****** Object:  Default [DF_websolaffi_exportedTowebsol]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_exportedTowebsol]  DEFAULT ('N') FOR [exportedTowebsol]
GO
/****** Object:  Default [DF_websolaffi_mrole]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_mrole]  DEFAULT ('') FOR [mrole]
GO
/****** Object:  Default [DF_websolaffi_shine]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_shine]  DEFAULT ((0)) FOR [shine]
GO
/****** Object:  Default [DF_websolaffi_referdurl]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_referdurl]  DEFAULT ('') FOR [referdurl]
GO
/****** Object:  Default [DF_websolaffi_bouncemarkexptowebsol]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_bouncemarkexptowebsol]  DEFAULT ('N') FOR [bouncemarkexptowebsol]
GO
/****** Object:  Default [DF_websolaffi_facebookpost_1]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_facebookpost_1]  DEFAULT ('N') FOR [facebookpost]
GO
/****** Object:  Default [DF_websolaffi_FB_ID_1]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_FB_ID_1]  DEFAULT ('') FOR [FB_ID]
GO
/****** Object:  Default [DF_websolaffi_FB_UserName_1]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_FB_UserName_1]  DEFAULT ('') FOR [FB_UserName]
GO
/****** Object:  Default [DF_websolaffi_IsGPlus]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_IsGPlus]  DEFAULT ('N') FOR [IsGPlus]
GO
/****** Object:  Default [DF_websolaffi_GPlusImg]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_GPlusImg]  DEFAULT ('') FOR [GPlusImg]
GO
/****** Object:  Default [DF_websolaffi_GplusASProfile]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_GplusASProfile]  DEFAULT ('Y') FOR [GplusASProfile]
GO
/****** Object:  Default [DF_websolaffi_Mem_Type]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_Mem_Type]  DEFAULT ('') FOR [Mem_Type]
GO
/****** Object:  Default [DF_websolaffi_candiWeb]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_candiWeb]  DEFAULT ('') FOR [candiWeb]
GO
/****** Object:  Default [DF_websolaffi_GplusID]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_GplusID]  DEFAULT ('') FOR [GplusID]
GO
/****** Object:  Default [DF_websolaffi_aim]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolaffi] ADD  CONSTRAINT [DF_websolaffi_aim]  DEFAULT ('') FOR [aim]
GO
/****** Object:  Default [DF_websolaffi_Forums_Category_descrip]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_MainCategory] ADD  CONSTRAINT [DF_websolaffi_Forums_Category_descrip]  DEFAULT ('') FOR [descrip]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_MainCategory_CandiId]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_MainCategory] ADD  CONSTRAINT [DF_WebsolAffi_Forums_MainCategory_CandiId]  DEFAULT ((0)) FOR [CandiId]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_MainCategory_StartDate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_MainCategory] ADD  CONSTRAINT [DF_WebsolAffi_Forums_MainCategory_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_SubCategory_CatId]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_SubCategory] ADD  CONSTRAINT [DF_WebsolAffi_Forums_SubCategory_CatId]  DEFAULT ((0)) FOR [CatId]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_SubCategory_SubCatTitle]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_SubCategory] ADD  CONSTRAINT [DF_WebsolAffi_Forums_SubCategory_SubCatTitle]  DEFAULT ('') FOR [SubCatTitle]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_SubCategory_SubCatDesc]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_SubCategory] ADD  CONSTRAINT [DF_WebsolAffi_Forums_SubCategory_SubCatDesc]  DEFAULT ('') FOR [SubCatDesc]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_SubCategory_LastTopic]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_SubCategory] ADD  CONSTRAINT [DF_WebsolAffi_Forums_SubCategory_LastTopic]  DEFAULT ('') FOR [LastTopic]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_SubCategory_StartDate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_SubCategory] ADD  CONSTRAINT [DF_WebsolAffi_Forums_SubCategory_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_SubCategory_IsApprover]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_SubCategory] ADD  CONSTRAINT [DF_WebsolAffi_Forums_SubCategory_IsApprover]  DEFAULT ('Y') FOR [IsApprover]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_SubCategory_LastTopicid]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_SubCategory] ADD  CONSTRAINT [DF_WebsolAffi_Forums_SubCategory_LastTopicid]  DEFAULT ((0)) FOR [LastTopicid]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_SubCategory_TotalView]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_SubCategory] ADD  CONSTRAINT [DF_WebsolAffi_Forums_SubCategory_TotalView]  DEFAULT ((0)) FOR [TotalView]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_Topic_Topic]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_Topic] ADD  CONSTRAINT [DF_WebsolAffi_Forums_Topic_Topic]  DEFAULT ('') FOR [TopicTitle]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_Topic_StartDate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_Topic] ADD  CONSTRAINT [DF_WebsolAffi_Forums_Topic_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_Topic_IsApproved]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_Topic] ADD  CONSTRAINT [DF_WebsolAffi_Forums_Topic_IsApproved]  DEFAULT ('Y') FOR [IsApproved]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_Topic_TotalView]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_Topic] ADD  CONSTRAINT [DF_WebsolAffi_Forums_Topic_TotalView]  DEFAULT ((0)) FOR [TotalView]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_Topic_CatId]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_Topic] ADD  CONSTRAINT [DF_WebsolAffi_Forums_Topic_CatId]  DEFAULT ((0)) FOR [CatId]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_TopicAnswer_TopicAns]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_TopicAnswer] ADD  CONSTRAINT [DF_WebsolAffi_Forums_TopicAnswer_TopicAns]  DEFAULT ('') FOR [TopicAns]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_TopicAnswer_AnsDate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_TopicAnswer] ADD  CONSTRAINT [DF_WebsolAffi_Forums_TopicAnswer_AnsDate]  DEFAULT (getdate()) FOR [AnsDate]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_TopicAnswer_IsApproved]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_TopicAnswer] ADD  CONSTRAINT [DF_WebsolAffi_Forums_TopicAnswer_IsApproved]  DEFAULT ('Y') FOR [IsApproved]
GO
/****** Object:  Default [DF_WebsolAffi_Forums_TopicAnswer_candiName]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Forums_TopicAnswer] ADD  CONSTRAINT [DF_WebsolAffi_Forums_TopicAnswer_candiName]  DEFAULT ('') FOR [candiName]
GO
/****** Object:  Default [DF_WebsolAffi_RefDetails_mid]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_RefDetails] ADD  CONSTRAINT [DF_WebsolAffi_RefDetails_mid]  DEFAULT ((0)) FOR [mid]
GO
/****** Object:  Default [DF_WebsolAffi_RefDetails_earnedamt]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_RefDetails] ADD  CONSTRAINT [DF_WebsolAffi_RefDetails_earnedamt]  DEFAULT ((0)) FOR [earnedamt]
GO
/****** Object:  Default [DF_WebsolAffi_RefDetails_earndate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_RefDetails] ADD  CONSTRAINT [DF_WebsolAffi_RefDetails_earndate]  DEFAULT (getdate()) FOR [earndate]
GO
/****** Object:  Default [DF_WebsolAffi_RefDetails_pstatus]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_RefDetails] ADD  CONSTRAINT [DF_WebsolAffi_RefDetails_pstatus]  DEFAULT ('pending') FOR [pstatus]
GO
/****** Object:  Default [DF_WebsolAffi_RefDetails_referd_1]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_RefDetails] ADD  CONSTRAINT [DF_WebsolAffi_RefDetails_referd_1]  DEFAULT ((0)) FOR [referd]
GO
/****** Object:  Default [DF_WebsolAffi_RefDetails_regdate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_RefDetails] ADD  CONSTRAINT [DF_WebsolAffi_RefDetails_regdate]  DEFAULT (getdate()) FOR [regdatetp]
GO
/****** Object:  Default [DF_WebsolAffi_Step_Test_candiid]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Step_Test] ADD  CONSTRAINT [DF_WebsolAffi_Step_Test_candiid]  DEFAULT ((0)) FOR [candiid]
GO
/****** Object:  Default [DF_WebsolAffi_Step_Test_stepID]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Step_Test] ADD  CONSTRAINT [DF_WebsolAffi_Step_Test_stepID]  DEFAULT ((0)) FOR [stepID]
GO
/****** Object:  Default [DF_WebsolAffi_Step_Test_Qid]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Step_Test] ADD  CONSTRAINT [DF_WebsolAffi_Step_Test_Qid]  DEFAULT ((0)) FOR [Qid]
GO
/****** Object:  Default [DF_WebsolAffi_Step_Test_Ans]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Step_Test] ADD  CONSTRAINT [DF_WebsolAffi_Step_Test_Ans]  DEFAULT ('') FOR [Ans]
GO
/****** Object:  Default [DF_WebsolAffi_Step_Test_AndDate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Step_Test] ADD  CONSTRAINT [DF_WebsolAffi_Step_Test_AndDate]  DEFAULT (getdate()) FOR [AnsDate]
GO
/****** Object:  Default [DF_WebsolAffi_Step_Test_IsCorrect]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[WebsolAffi_Step_Test] ADD  CONSTRAINT [DF_WebsolAffi_Step_Test_IsCorrect]  DEFAULT ('') FOR [IsCorrect]
GO
/****** Object:  Default [DF_websolAffi_videoComments_candiid]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolAffi_videoComments] ADD  CONSTRAINT [DF_websolAffi_videoComments_candiid]  DEFAULT ((0)) FOR [candiid]
GO
/****** Object:  Default [DF_websolAffi_videoComments_videoID]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolAffi_videoComments] ADD  CONSTRAINT [DF_websolAffi_videoComments_videoID]  DEFAULT ((0)) FOR [videoID]
GO
/****** Object:  Default [DF_websolAffi_videoComments_comments]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolAffi_videoComments] ADD  CONSTRAINT [DF_websolAffi_videoComments_comments]  DEFAULT ('') FOR [comments]
GO
/****** Object:  Default [DF_websolAffi_videoComments_commentdate]    Script Date: 06/25/2015 17:16:46 ******/
ALTER TABLE [dbo].[websolAffi_videoComments] ADD  CONSTRAINT [DF_websolAffi_videoComments_commentdate]  DEFAULT (getdate()) FOR [commentdate]
GO
/****** Object:  ForeignKey [FK_citytable_states]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[citytable]  WITH CHECK ADD  CONSTRAINT [FK_citytable_states] FOREIGN KEY([stateid])
REFERENCES [dbo].[states] ([stateid])
GO
ALTER TABLE [dbo].[citytable] CHECK CONSTRAINT [FK_citytable_states]
GO
/****** Object:  ForeignKey [FK_Profile_citytable]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile]  WITH CHECK ADD  CONSTRAINT [FK_Profile_citytable] FOREIGN KEY([cityid])
REFERENCES [dbo].[citytable] ([cityid])
GO
ALTER TABLE [dbo].[Profile] CHECK CONSTRAINT [FK_Profile_citytable]
GO
/****** Object:  ForeignKey [FK_Profile_Country]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile]  WITH CHECK ADD  CONSTRAINT [FK_Profile_Country] FOREIGN KEY([countryid])
REFERENCES [dbo].[Country] ([COUNTRYID])
GO
ALTER TABLE [dbo].[Profile] CHECK CONSTRAINT [FK_Profile_Country]
GO
/****** Object:  ForeignKey [FK_Profile_states]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[Profile]  WITH CHECK ADD  CONSTRAINT [FK_Profile_states] FOREIGN KEY([stateid])
REFERENCES [dbo].[states] ([stateid])
GO
ALTER TABLE [dbo].[Profile] CHECK CONSTRAINT [FK_Profile_states]
GO
/****** Object:  ForeignKey [FK_states_Country]    Script Date: 06/25/2015 17:16:45 ******/
ALTER TABLE [dbo].[states]  WITH CHECK ADD  CONSTRAINT [FK_states_Country] FOREIGN KEY([countryid])
REFERENCES [dbo].[Country] ([COUNTRYID])
GO
ALTER TABLE [dbo].[states] CHECK CONSTRAINT [FK_states_Country]
GO
