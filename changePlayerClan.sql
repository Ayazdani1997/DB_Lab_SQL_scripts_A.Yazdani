create or alter procedure changePlayerClan
(
   @nid int,
   @newClan int,
   @jobName char( 100 )
) as begin
  declare @clanCount int
  select @clanCount = count( * ) from Clan where cid = @newClan
  if @clanCount != 0 begin
    update [User] set clan_id = @newClan , job = @jobName where nid = @nid
  end
  else begin
    insert into [User]( clan_id, nid, job)  values( @newClan , @nid , @jobName )
  end
end