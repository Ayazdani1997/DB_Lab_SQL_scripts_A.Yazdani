--use database ClanDB
create or alter function [dbo].[findPlayerWithRole]
(
	@clan_id int,
	@roleName char( 100 )
)
returns table
as	return ( 
			select users.nid , allRoles.[level] from ClanDB.dbo.Clan clans , ClanDB.dbo.[User] users , ClanDB.dbo.Player players 
			, ClanDB.dbo.RoleName roles , ClanDB.dbo.upToNowRoles allRoles
			where users.clan_id = @clan_id and users.nid = players.nid and
			players.current_role_id = roles.roleId and @roleName = roles.roleName 
			and allRoles.role_id = roles.roleId and allRoles.p_nid = players.nid
			union
			select players.nid , allRoles.[level] from ClanDB.dbo.Clan clans, ClanDB.dbo.Player players
			, ClanDB.dbo.upToNowRoles allRoles , ClanDB.dbo.RoleName roles
			where @roleName = roles.roleName and players.nid = clans.manager_nid and clans.cid = @clan_id and
			players.current_role_id = roles.roleId and allRoles.role_id = roles.roleId and allRoles.p_nid = players.nid
			)
			