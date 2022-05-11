USE [WebShop]
GO

DECLARE	@return_value int,
		@groupedIcons xml

EXEC	@return_value = [dbo].[SpGetProductFeaturesByFilter]
		@firstIconPriority = 10,
		@featureDetailCombinationList = N'',
		@delimiter = N'/',
		@parentIdList = N'70fc93a8-74f9-4e5a-8c98-51b33c281597',
		@minPrice = 0,
		@maxPrice = 1000000,
		@groupedIconList = @groupedIcons OUTPUT

SELECT	@groupedIcons as N'@groupedIcons'

SELECT	'Return Value' = @return_value

GO
