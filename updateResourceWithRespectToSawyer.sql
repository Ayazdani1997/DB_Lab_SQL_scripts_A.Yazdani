create or alter procedure dbo.updateResourceWithRespectToSawyerTo
(
	@clan_id int
)
as begin
		declare @gold char( 100 )
		declare @wood char( 100 )
		declare @sawyersSumLevel int
		declare @countToIncrease int
		declare @roleName char( 100 )
		declare @goldCount int
		set @gold = 'gold'
		set @wood = 'wood'
		set @roleName = 'sawyer'
		select @sawyersSumLevel = sum( [level] ) from [dbo].[findPlayerWithRole]( @clan_id , @roleName )
		if @sawyersSumLevel IS NOT NULL begin
			set @countToIncrease = @sawyersSumLevel * 10
			select @goldCount = resource_count from ClanDB.dbo.HavingResource where resource_name = @gold and cid = @clan_id
			if @goldCount IS NOT NULL begin
				if @goldCount < @countToIncrease begin
					set @countToIncrease = @goldCount
				end
				update ClanDB.dbo.HavingResource set resource_count = resource_count - @countToIncrease where cid = @clan_id and resource_name = @gold
				update ClanDB.dbo.HavingResource set resource_count = resource_count + @countToIncrease where cid = @clan_id and resource_name = @wood
			end
		end
end