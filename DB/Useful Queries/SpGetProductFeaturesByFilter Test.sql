USE [WebShop]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[SpGetProductFeaturesByFilter]
		20,
		@featureDetailCombinationList = N'37/34,37/1043,36/34,36/1043',
		@delimiter = N'/',
		@parentIdList = N'38089378-ce91-42d3-a6b6-6666c68879d3,5e8238d5-4a46-4af4-8743-b5c1df70c0ea',
		@minPrice = 0,
		@maxPrice = 1000000

SELECT	'Return Value' = @return_value

GO
