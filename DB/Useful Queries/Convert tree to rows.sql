WITH  CategoryTree (Id, name, level, ParentId) 
AS ( 
  SELECT
    Id, 
    '' + Name, 
    0, 
    ParentId 
  FROM Category 
  WHERE ParentId = -1
 
  UNION ALL
  SELECT
    mn.Id, 
    mt.name + '/' + mn.name, 
    mt.level + 1, 
    mn.ParentId
  FROM Category mn, CategoryTree mt 
  WHERE mn.ParentId = mt.Id 
) 
SELECT * FROM CategoryTree 
WHERE level > 0 
ORDER BY level, ParentId;