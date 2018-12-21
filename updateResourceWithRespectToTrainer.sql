create or alter procedure dbo.updateResourceWithRespectToTrainerTo
(
	@clan_id int
)
as begin
		declare @army char( 100 )
		declare @trainersSumLevel int
		declare @countToIncrease int
		declare @roleName char( 100 )
		declare @armyCount int
    declare @gold char(100)
    declare @decreaseFactor int
    declare @goldCount int
    set @gold = 'gold'
    set @decreaseFactor = 5
		set @army = 'army'
		set @roleName = 'trainer'
		select @trainersSumLevel = sum( [level] ) from dbo.findPlayerWithRole( @clan_id , @roleName )
		if @trainersSumLevel IS NOT NULL begin
			set @countToIncrease = @trainersSumLevel
			select @armyCount = resource_count from ClanDB.dbo.HavingResource where resource_name = @army and cid = @clan_id
			if @armyCount IS NOT NULL begin
				set @countToIncrease = @countToIncrease * 10
        select @goldCount = resource_count from HavingResource where resource_name = @gold and cid = @clan_id
        if @goldCount < @countToIncrease * @decreaseFactor begin
          set @countToIncrease = @goldCount / 5
        end
			  update ClanDB.dbo.HavingResource set resource_count = resource_count + @countToIncrease where cid = @clan_id and resource_name = @army
        update HavingResource set resource_count = resource_count - @countToIncrease * @decreaseFactor where cid = @clan_id and resource_name = @gold
			end
		end
  	else begin
			insert into ClanDB.dbo.HavingResource values( @clan_id , @army , 0 )
		end
end
go