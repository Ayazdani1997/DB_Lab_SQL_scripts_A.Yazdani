create or alter procedure dbo.feedArmy
(
  @clan_id int
) as begin
  declare @armyCount int
  declare @foodCount int
  declare @army char( 100 )
  declare @food char( 100 )
  declare @hungerFactor float
  set @army = 'army'
  set @food = 'food'
  select @hungerFactor = RAND()*( 12 - 10 ) + 10;
  select @armyCount = resource_count from HavingResource where cid = @clan_id and resource_name = @army
  select @foodCount = resource_count from HavingResource where cid = @clan_id and resource_name = @food
    if @armyCount is not null begin
      if @foodCount is not null begin
          if @foodCount < ( @armyCount * @hungerFactor ) / 100 begin
            set @foodCount = 0
            set @armyCount = @foodCount * @hungerFactor
          end
          else begin
            set @foodCount = @foodCount - ( @armyCount * @hungerFactor ) / 100
          end
      end
      else begin
        set @foodCount = 0
      end
    end
    else begin
      set @armyCount = 0
    end
    update HavingResource set resource_count = @armyCount where cid = @clan_id and resource_name = @army
    update HavingResource set resource_count = @foodCount where cid = @clan_id and resource_name = @food
end