create or alter procedure dbo.startWar(
	@attackerClanId int,
	@defenderClanId int,
	@startDate Date
)
as begin
	declare @attackerClanInitialSoldier int
	declare @defenderClanInitialSoldier int
	declare @finalAttackerSoldier int
	declare @finalDefenderSoldier int
	declare @winnerKillFactor int
	declare @loserKillFactor int
	declare @attackerFoodCount int
	declare @attackerGoldCount int
	declare @defenderFoodCount int
	declare @defenderGoldCount int
	set @winnerKillFactor = ABS( CHECKSUM( NEWID() ) % 10 + 10 )
	set @loserKillFactor = ABS( CHECKSUM( NEWID() ) % 10 + 20 )
	select @attackerClanInitialSoldier = cur_soldier_count from ClanDB.dbo.Clan clan where clan.cid = @attackerClanId
	select @defenderClanInitialSoldier = cur_soldier_count from ClanDB.dbo.Clan clan where clan.cid = @defenderClanId
	select @attackerFoodCount = resourceMapper.resource_count
		from ClanDB.dbo.Wars w , ClanDB.dbo.HavingResource resourceMapper
		where w.attacker_id = resourceMapper.cid and resourceMapper.resource_name = 'food'
	select @attackerGoldCount = resourceMapper.resource_count
		from ClanDB.dbo.Wars w , ClanDB.dbo.HavingResource resourceMapper
		where w.attacker_id = resourceMapper.cid and resourceMapper.resource_name = 'gold'
	select @defenderFoodCount = resourceMapper.resource_count
		from ClanDB.dbo.Wars w , ClanDB.dbo.HavingResource resourceMapper
		where w.defender_id = resourceMapper.cid and resourceMapper.resource_name = 'food'
	select @defenderGoldCount = resourceMapper.resource_count
		from ClanDB.dbo.Wars w , ClanDB.dbo.HavingResource resourceMapper
		where w.defender_id = resourceMapper.cid and resourceMapper.resource_name = 'gold'
	if @attackerClanInitialSoldier > @defenderClanInitialSoldier begin
		set @finalAttackerSoldier = @attackerClanInitialSoldier - ( @attackerClanInitialSoldier * @winnerKillFactor ) / 100
		set @finalDefenderSoldier = @defenderClanInitialSoldier - ( @defenderClanInitialSoldier * @loserKillFactor ) / 100
		set @attackerFoodCount = @attackerFoodCount + @defenderFoodCount / 10
		set @attackerGoldCount = @attackerGoldCount + @defenderGoldCount / 10
		set @defenderFoodCount = @defenderFoodCount - @defenderFoodCount / 10
		set @defenderGoldCount = @defenderGoldCount - @defenderGoldCount / 10 
	end
	else begin
		set @finalAttackerSoldier = @attackerClanInitialSoldier - ( @attackerClanInitialSoldier * @loserKillFactor ) / 100
		set @finalDefenderSoldier = @defenderClanInitialSoldier - ( @defenderClanInitialSoldier * @winnerKillFactor ) / 100
		set @defenderFoodCount = @defenderFoodCount + @defenderFoodCount / 10
		set @defenderGoldCount = @defenderGoldCount + @defenderGoldCount / 10
		set @attackerFoodCount = @attackerFoodCount - @defenderFoodCount / 10
		set @attackerGoldCount = @attackerGoldCount - @defenderGoldCount / 10
	end
	update ClanDB.dbo.HavingResource set resource_count = @defenderFoodCount where cid = @defenderClanId and resource_name = 'food'
	update ClanDB.dbo.HavingResource set resource_count = @defenderGoldCount where cid = @defenderClanId and resource_name = 'gold'
	update ClanDB.dbo.HavingResource set resource_count = @attackerFoodCount where cid = @attackerClanId and resource_name = 'food'
	update ClanDB.dbo.HavingResource set resource_count = @attackerGoldCount where cid = @defenderClanId and resource_name = 'gold'
	insert into ClanDB.dbo.Wars values( @attackerClanId , @defenderClanId , @attackerClanInitialSoldier  , 
		@finalAttackerSoldier , @defenderClanInitialSoldier , @finalDefenderSoldier , @startDate )
	update ClanDB.dbo.Clan set cur_soldier_count = @finalAttackerSoldier where cid = @attackerClanId
	update ClanDB.dbo.Clan set cur_soldier_count = @finalDefenderSoldier where cid = @defenderClanId
	return
end