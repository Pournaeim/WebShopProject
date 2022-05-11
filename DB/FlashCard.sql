USE [WebShop]
GO
/****** Object:  Table [dbo].[FlashCard]    Script Date: 1/25/2022 8:20:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlashCard](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Front] [nvarchar](max) NULL,
	[Back] [nvarchar](max) NULL,
 CONSTRAINT [PK_Sentence] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[FlashCard] ON 
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (16, N'Our social reputations are at stake here', N'اعتبار اجتماعی ما در اینجا در معرض خطر است')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (17, N'We are trying to improve our qualifications in terms of programming and speaking English skill.', N'ما در تلاش هستیم تا از نظر برنامه نویسی و مهارت صحبت به زبان انگلیسی ، صلاحیت های خود را ارتقا دهیم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (18, N'We are leaning towards moving to England after we found out that the salaries there are much higher than we are earning now.', N'تمایل داریم به انگلستان مهاجرت کنیم بعد از اینکه فهمیدیم حقوق های آنجا خیلی بیشتر از حقوقی است که ما در حال حاضر دریافت میکنیم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (19, N'With the aim of', N'با هدف')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (20, N'To attain something', N'برای رسیدن به چیزی')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (21, N'As the name implies', N'همانطور که از نامش پیدا است')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (22, N'I do like the one where ...', N'آن جایی را دوست دارم که ... ')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (23, N'I do like the one where you walk through the forest that was burnt', N'آنجا که از جنگل سوخته رد می شدی را دوست دارم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (24, N'Haven''t you ever been told how beautiful you are ?', N'آیا تا به حال به شما نگفته اند که چقدر زیبا هستید ؟')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (25, N'Have you ever been told how beautiful you are ?', N'آیا تا به حال به شما گفته اند که چقدر زیبا هستید ؟')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (26, N'is immediately sliced to three equal pieces', N'بلافاصله به سه قطعه برابر تقسیم شد / بلافاصله به سه قطعه برابر بریده شد / بلافاصله به سه قسمت مساوی تقسیم شد')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (27, N'An ability he derives from ...', N'توانایی او که ناشی میشود از ...')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (28, N'it would be a more merciful death', N'میتوانست یک مرگ راحت تری باشد')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (29, N'we are locked out', N'پشت در ماندیم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (30, N'I challenge you to ...', N'من شما را به چالش ... میکشانم / دعوت میکنم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (31, N'we will bring up it up ourselves', N'ما خودمان باید ببریم بالا')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (32, N'I hardly think so ... ', N'من اینطور فکر نمی کنم ...')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (33, N'High level positions are at time rather stressful', N'موقعیت های شغلی رده بالا در / به نوبه / جای خود بسیار استرس زا باشند')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (34, N'The book is expensive ; however, it''s worth it', N'کتاب گران است ؛ با این حال ، ارزشش را دارد.')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (35, N'During my junior year, I had been leading seniors in programming', N'در سال سوم دانشجویی ام در برنامه نویسی سال چهارمی ها را هدایت میکردم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (36, N'I am tire of his sophomoric ideas', N'از ایده های سال دومی او خسته شدم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (37, N'During my freshman year, I was able to programming .', N' در سال اول دانشجویی ام توانایی برنامه نویسی داشتم ')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (38, N'Hard work often leads to success', N'سخت کوشی اغلب به موفقیت می انجامد')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (39, N'We really lead a delightful relationship', N'ما واقعاً یک رابطه لذت بخش را پیش میبریم می کنیم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (40, N'I spent my freshman and sophomore years in Ardabil ', N'من سال اول و دوم را در اردبیل گذراندم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (41, N'I graduated in software from Lahijan with an average of 14.5', N'من با معدل ۱۴.۵ از دانشگاه لاهیجان فارغ التحصیل شدم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (42, N'By far the most important problem for us, is learning English', N'یادگیری انگلیسی مساله خیلی مهم برای ما است')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (43, N'The senior prom', N'جشن فارغ التحصیلی')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (44, N'I was forced to drop AI course, when I was my senior year', N'وقتی که سال آخر بودم، مجبور شدم درس هوش مصنوعی را حذف کنم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (45, N'He is a Harvard gratuate', N'او فارغ التحیصل دانشگاه هاروارد است')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (46, N'My salary is paid every fortnight', N'حقوق من هر دو هفته یکبار پرداخت میشود')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (47, N'I am so happy to be here', N'از بودن در اینجا خیلی خوشحال هستم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (48, N'When I sing, I go by NightBirde (=nike name) ', N'با نام مستعار پرنده شب اواز میخوانم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (49, N'He is well behind in his project. Overall, he will not meet the deadline', N'او از پروژه خود بسیار عقب است. به طور کلی ، او به مهلت مقرر نخواهد رسید')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (50, N'We have to discover new sources of energy; otherwise, we will lose healthy living in our planet', N'ما باید منابع جدید انرژی را کشف کنیم. در غیر این صورت ، زندگی سالم را در سیاره خود از دست خواهیم داد')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (51, N'We must lead our lives to a happier state, otherwise we will face more difficulties in the future', N'ما باید زندگی خود را به وضعیت شادتری برسانیم ، در غیر این صورت در آینده با مشکلات بیشتری روبرو خواهیم شد')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (52, N'The popularity of programmers is growing due to the range of benefits they offer to any kind of businesses', N'محبوبیت برنامه نویسان به دلیل طیف وسیعی از مزایایی که برای هر نوع مشاغل ارائه می دهند ، در حال رشد است')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (53, N'In fact, while there are numerous definitions of science, there is no single clear and unified definition', N'در حقیقت ، با وجود تعاریف بی شماری که از علم ، هیچ تعریف واحد شفاف و یکپارچه ای وجود ندارد')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (54, N'purposeful people are easier to associate with', N'معاشرت با افراد هدفمند راحت تر است')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (55, N'It makes sense on paper', N'روی کاغذ منطقی است')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (56, N'Being honest in a relationship would be considered as an important and fundamental issue', N'صادق بودن در یک رابطه به عنوان یک مسئله مهم و اساسی در نظر گرفته می شود')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (57, N'If you try to lead a large purpose then start an intensive program, it gets progressively harder to handle', N'اگر می خواهید هدفی بزرگ را هدایت کنید و سپس یک برنامه فشرده را شروع کنید ، کنترل آن به تدریج دشوارتر می شود')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (58, N'Learning programming from a teacher on its own wouldn''t quite get us what we want', N'یادگیری برنامه نویسی از یک معلم به تنهایی ( به خودی خود ) ما را به آنچه می خواهیم نمی رساند')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (59, N'Zohreh is as much kind as she is a clever one', N'زهره به اندازه باهوش بودنش مهربان هم است')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (60, N'What kind of pattern does the Bounded-Context belong to ?', N'Bounded-Context متعلق به چه نوع الگوهایی است؟')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (61, N'Think about life as a whole rather than money and love', N'به کل زندگی فکر کنید تا پول و عشق')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (62, N'You might study a lot and use a perfect program to study and practice but it''s you''re output ultimately which shows wheater your studies is useful or not', N'شما ممکن است زیاد مطالعه کنید و از یک برنامه عالی برای مطالعه و تمرین استفاده کنید اما در نهایت خروجی شماست که نشان می دهد تحصیلات شما مفید است یا خیر')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (63, N'I will try to wake up early tomorrow in any way, because I lose my half of day when I wake up late', N'فردا سعی خواهم کرد به هر طریقی زود بیدار شوم ، زیرا وقتی دیر بیدار می شوم نیمی از روز خود را از دست می دهم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (64, N'I wonder how many years it would take to read all of these books', N'من تعجب می کنم که خواندن همه این کتاب ها چند سال طول می کشد؟')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (65, N'once in a while', N'هر از چند گاهی')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (66, N'The critical complexity of most software projects is in understanding the domain itself', N'پیچیدگی بحرانی اکثر پروژه های نرم افزاری در درک خود دامنه است')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (67, N'The better we study and practice, the more likely we will be success.', N'هرچه مطالعه و تمرین بهتری انجام دهیم ، همونقدر احتمال موفقیت بیشتر خواهد بود.')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (68, N'If you think about the lack of facilities in your life, you will be distracted as handle your development plans', N' اگر به کمبود امکانات در زندگی خود فکر کنید ، از برنامه های توسعه خود منحرف می شوید / حواستان از برنامه های پیشرفت تان پرت میشود')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (69, N'What can I get for you today? ( at the restaurant ) ', N'امروز چه چیزی برای شما می توانم بگیرم؟ ( در رستوران )')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (70, N'I can not wait to it. I am starving', N' نمی‌توانم صبر کنم خیلی گرسنه هستم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (71, N'With all due respect', N'با کمال احترام')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (72, N'As per our conversation', N'مطابق صحبت ما')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (73, N'I’m excited to announce', N'مشتاقم اعلام کنم که..')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (74, N'Keep up the amazing work', N'به کار خفنت ادامه بده')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (75, N'Looking forward to hearing more of your success news... ', N'منتظر شنیدن خبر موفقیتت هستم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (76, N' I accept the apology', N'عذرخواهی تو میپذیرم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (77, N'Don''t get me wrong', N'اشتباه برداشت نکن')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (78, N'It should be noted that ', N'لازم به ذکر است که...')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (79, N'We are delighted to ', N'خوشحالیم که..')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (80, N'Thank you in advance for your patience with all your questions', N'پیشاپیش از صبوری شما در پاسخ به سوالاتم ممنونم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (81, N'making a positive impact on the world', N'تاثیر مثبت در جهان')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (82, N'Temporal Landmarks ', N'نقطه عطف')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (83, N'A heavy lunch makes me sluggish in the afternoon.', N'ناهار سنگین منو بعدازظهر سست کرد')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (84, N'This could be a basic question... ', N'این سوال ممکنه ساده باشه... ')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (85, N'Listen, like, I am quite an expert when it comes to technology. ', N'گوش کنید، مثلا، وقتی صحبت از تکنولوژی میشود من کاملا متخصص هستم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (86, N'So go on, you have a go. I will be back in a minute. ', N' خب ادامه بدهید ، یک شانس دیگر دارید، یک دقیقه دیگر بر خواهم گشت')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (87, N'I will come round to you', N'پیش شما خواهم آمد')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (88, N'It just a saying Anna', N'این فقط یه حرف است آنا ')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (89, N'I can''t work it out', N'سر در نمی آورم / متوجه نمیشوم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (90, N'I can''t get my head round this', N'سر در نمی آورم / متوجه نمیشوم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (91, N'I am having trouble getting to grips with this', N'برای کنار آمدن با این ، مشکل دلرم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (92, N'I can''t seem to get to grips with this problem (C2)', N'به نظر می رسد نمی توانم با این مشکل کنار بیایم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (93, N'To your way of thinking, can these two person will be get to grips with this relation?', N'به نظر شما ، آیا این دو نفر می توانند با این رابطه کنار بیایند؟')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (94, N'What seems to be a problem ? (   It is polite, detached, reassuring, and implies that perhaps there isn''t a problem at all    )', N'چه چیزی مشکل به نظر می اید')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (95, N'I pretended to agree because I really didn''t want to take him on', N'من وانمود کردم که با او موافقم چون که نمیخواستم با او وارد بحث بشوم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (96, N'I will take you on in a badminton game', N'من تو را به رقابت در بازی بدمینتون دعوت میکنم')
GO
INSERT [dbo].[FlashCard] ([Id], [Front], [Back]) VALUES (97, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[FlashCard] OFF
GO
