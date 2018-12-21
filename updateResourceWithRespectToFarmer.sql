create or alter procedure dbo.updateResourceWithRespectToFarmerTo
(
	@clan_id int
)
as begin
		declare @food char( 100 )
		declare @farm char( 100 )
		declare @farmersSumLevel int
		declare @countToIncrease int
		declare @roleName char( 100 )
		declare @farmCount int
		declare @foodCount int
		set @food = 'food'
		set @roleName = 'farmer'
		set @farm = 'farm'
		select @farmersSumLevel = sum( [level] ) from dbo.findPlayerWithRole( @clan_id , @roleName )
		if @farmersSumLevel IS NOT NULL begin
			set @countToIncrease = @farmersSumLevel
			select @foodCount = resource_count from ClanDB.dbo.HavingResource where resource_name = @food and cid = @clan_id
			if @foodCount IS NOT NULL begin
				select @farmCount = buildingCount from [dbo].[getCountOfSpecifiedBuildingOfAClan]( @clan_id , @farm )
				set @countToIncrease = @countToIncrease * @farmCount
				update ClanDB.dbo.HavingResource set resource_count = resource_count + @countToIncrease where cid = @clan_id and resource_name = @food
			end
		end
  	else begin
			insert into ClanDB.dbo.HavingResource values( @clan_id , @food , @countToIncrease )
		end
end