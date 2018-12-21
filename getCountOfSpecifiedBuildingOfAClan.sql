create or alter function [dbo].[getCountOfSpecifiedBuildingOfAClan]
(
	@clan_id int,
	@buildingTypeName char( 100 )
)
returns table
as	return ( 
			select count( * ) as buildingCount from ClanDB.dbo.Building building , ClanDB.dbo.BuildingTypes types
 			where building.buildingType = types.buildingTypeId and types.buildingTypeName = @buildingTypeName and clan_owner_id = @clan_id and develop_percentage = 100	
		   )