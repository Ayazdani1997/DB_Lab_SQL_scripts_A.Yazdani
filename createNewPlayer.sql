create or alter procedure createNewPlayer
(
    @nid int,
    @jobType bit,
    @firstName char( 100 ),
    @lastName char( 100 ),
    @roleName char( 100 ),
    @playerLevel int
) as begin
    declare @roleId char( 100 )
    select @roleId = roleId from RoleName where roleName = @roleName
    if @roleId is not null begin
        insert into Player( nid , jobType, first_name, last_name, current_role_id)
        values( @nid , @jobType , @firstName , @lastName , @roleId )
        insert into upToNowRoles( p_nid, role_id, level ) values( @nid , @roleId , @playerLevel )
    end
end