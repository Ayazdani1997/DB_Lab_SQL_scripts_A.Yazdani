create or alter procedure developBuildingForClan
(
  @clan_id int
)
as begin
  declare @defaultBuildingType int
  declare @sawyerCount int
  declare @halfFinishedBuildingCount int
  declare @unfinishedPercent int
  declare @sawyer char( 100 )
  declare @newPercentageDelta int
  declare @decreaseFactorOfGold int
  set @decreaseFactorOfGold = 25
  set @sawyer = 'sawyer'
  declare @wood char( 100 )
  set @wood = 'wood'
  declare @gold char( 100 )
  set @gold = 'gold'
  declare @goldCount int
  declare @woodCount int
  select @goldCount = resource_count from HavingResource where resource_name = @gold and cid = @clan_id
  select @woodCount = resource_count from HavingResource where resource_name = @wood and cid = @clan_id
  select @defaultBuildingType = clan.default_buildType from Clan clan where clan.cid = @clan_id
  select @sawyerCount = count( * ) from findPlayerWithRole( @clan_id , @sawyer )
  select @halfFinishedBuildingCount = count( * ) from Building building
    where building.develop_percentage != 100
    and building.buildingType = @defaultBuildingType and building.clan_owner_id = @clan_id
  if @halfFinishedBuildingCount = 0 begin
    insert into Building( clan_owner_id, buildingType, develop_percentage ) values( @clan_id , @defaultBuildingType , 0 )
  end
  --decreasing goldCount and woodCount
  if @goldCount is not null and @woodCount is not null begin
      if @goldCount > @woodCount begin
        set @newPercentageDelta = @woodCount / @decreaseFactorOfGold
      end
      else begin
        set @newPercentageDelta = @goldCount / @decreaseFactorOfGold
      end
      if @newPercentageDelta > @sawyerCount begin
        set @newPercentageDelta = @sawyerCount
      end
      set @goldCount = @goldCount - ( @newPercentageDelta * @decreaseFactorOfGold )
      set @woodCount = @woodCount - @newPercentageDelta * @decreaseFactorOfGold
  end
  select @unfinishedPercent = develop_percentage from Building where buildingType = @defaultBuildingType and clan_owner_id = @clan_id and develop_percentage!=100
  if (@unfinishedPercent+@newPercentageDelta > 100) begin
      update Building set develop_percentage = 100 where clan_owner_id = @clan_id and buildingType = @defaultBuildingType and develop_percentage != 100
      insert into Building( clan_owner_id, buildingType, develop_percentage ) values( @clan_id , @defaultBuildingType , @newPercentageDelta-(100-@unfinishedPercent) )
  end
  else begin
      update Building set develop_percentage = develop_percentage + @newPercentageDelta where clan_owner_id = @clan_id and buildingType = @defaultBuildingType and develop_percentage != 100
  end
  update HavingResource set resource_count = @goldCount where resource_name = @gold and cid = @clan_id
  update HavingResource set resource_count = @woodCount where resource_name = @wood and cid = @clan_id
end