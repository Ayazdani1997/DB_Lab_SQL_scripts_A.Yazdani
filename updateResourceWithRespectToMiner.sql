create or alter procedure dbo.updateResourceWithRespectToMinerTo
(
	@resource char( 100 ),
	@clan_id int
)
as begin
		declare @minersSumLevel int
		declare @countToIncrease int
		declare @roleName char( 100 )
		set @roleName = 'miner'
		select @minersSumLevel = sum( [level] ) from [dbo].[findPlayerWithRole]( @clan_id , @roleName )
		if @minersSumLevel IS NOT NULL begin
			set @countToIncrease = @minersSumLevel * 10
			update ClanDB.dbo.HavingResource set resource_count = resource_count + @countToIncrease where cid = @clan_id and resource_name = @resource
		end
end