--use database ClanDB
create or alter function [dbo].[calcExperience]
(
	@clan_id int
)
returns int
as begin
		declare @experience int
		declare @winCount int
		declare @loseCount int
		declare @loseWeight int
		declare @winWeight int
		select @winCount = count( * ) 
		from ClanDB.dbo.Wars w 
			where ( w.attacker_id = @clan_id and w.initial_attacker_soldier_num >= 
			w.initial_defender_soldier_num ) or ( w.defender_id = @clan_id 
			and w.initial_defender_soldier_num >= w.initial_attacker_soldier_num )
		select  @loseCount = count( * ) from
			ClanDB.dbo.Wars w where ( w.attacker_id = @clan_id and w.initial_attacker_soldier_num < 
			w.initial_defender_soldier_num ) or ( w.defender_id = @clan_id 
			and w.initial_defender_soldier_num < w.initial_attacker_soldier_num )
		SET @winWeight = 50
		SET @loseWeight = 10
		SET @experience = @winWeight * @winCount + @loseWeight * @loseCount
		return @experience
end