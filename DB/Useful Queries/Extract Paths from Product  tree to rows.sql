WITH  ViewProductFeatureTree (
							Level,
							FeatureTypeDetailId,
							BaseFeatureTypeDetailId,
							DetailIdPath,
							Id, ParentId, ProductId,  FeatureTypeDetailName, 
							FeatureTypeName, Price, Quantity, FeatureTypeId, Priority, FeatureTypePriority, 
							FeatureTypeDetailPriority, IconUrl, Showcase, Description) 
AS ( 
  SELECT
	0,
	FeatureTypeDetailId,
	BaseFeatureTypeDetailId,
	'' + convert(varchar(max),BaseFeatureTypeDetailId), 
	Id, ParentId, ProductId,  FeatureTypeDetailName,FeatureTypeName, Price, Quantity, 
	FeatureTypeId, Priority, FeatureTypePriority, 
	FeatureTypeDetailPriority, IconUrl, Showcase, Description 
   
  FROM ViewProductFeature 
  WHERE ParentId = '3b3c44da-7c1f-47d0-8152-c44bd3f9c245' 
   
  UNION ALL
  SELECT
    pft.Level + 1,
	vpf.FeatureTypeDetailId,
	vpf.BaseFeatureTypeDetailId,
	(convert(varchar(max),pft.BaseFeatureTypeDetailId) + '/' + convert(varchar(max), vpf.BaseFeatureTypeDetailId)) as DetailIdPath, 
	vpf.Id,  vpf.ParentId,  vpf.ProductId,  vpf.FeatureTypeDetailName,
	vpf.FeatureTypeName,vpf.Price,  vpf.Quantity, vpf.FeatureTypeId, 
	vpf.Priority, vpf.FeatureTypePriority, vpf.FeatureTypeDetailPriority, 
	vpf.IconUrl, vpf.Showcase, vpf.Description
	 
  FROM ViewProductFeature vpf, ViewProductFeatureTree pft 
  WHERE vpf.ParentId = pft.Id 
) 
SELECT *  FROM ViewProductFeatureTree 
WHERE Level > 0 --and  FeatureTypeDetailName in ('S/White','S/Black','L/White','L/Black')
ORDER BY DetailIdPath;