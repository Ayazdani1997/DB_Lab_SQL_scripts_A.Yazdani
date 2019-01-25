create or alter procedure removeAllRecordsInTables
as begin
  delete from Player
  delete from BuildingTypes
  delete from Clan
  delete from HavingResource
  delete from Building
  delete from Resource
  delete from RoleName
  delete from upToNowRoles
  delete from [User]
  delete from Wars
end