create table BuildingTypes
(
	buildingTypeId int identity
		constraint BuildingTypes_PK
			primary key,
	buildingTypeName char(100) not null
)
go

create table Clan
(
	clan_message char(100),
	cid int identity
		constraint Clan_PK
			primary key,
	cur_soldier_count int not null,
	manager_nid int not null
		constraint Clan_UN
			unique,
	default_buildType int not null
		constraint Clan_BuildingTypes_FK
			references BuildingTypes
)
go

create table Building
(
	clan_owner_id int not null
		constraint Building_Clan_FK
			references Clan,
	buildingType int not null
		constraint Building_BuildingTypes_FK
			references BuildingTypes,
	develop_percentage real not null,
	building_id int identity
		constraint Building_PK
			primary key
)
go

create table Resource
(
	name char(100) not null
		constraint Resource_PK
			primary key,
	unit char(100) not null
)
go

create table HavingResource
(
	cid int not null
		constraint HavingResource_Clan_FK
			references Clan,
	resource_name char(100) not null
		constraint HavingResource_Resource_FK
			references Resource,
	resource_count int not null,
	constraint HavingResource_PK
		primary key (cid, resource_name)
)
go

create table RoleName
(
	roleId int identity
		constraint RoleName_PK
			primary key,
	roleName char(100) not null
)
go

create table Player
(
	nid int not null
		constraint Player_PK
			primary key,
	jobType bit not null,
	first_name char(100) not null,
	last_name char(100) not null,
	current_role_id int
		constraint Player_RoleName_FK
			references RoleName
)
go

create table [User]
(
	clan_id int not null
		constraint User_Clan_FK
			references Clan,
	nid int not null
		constraint User_PK
			primary key,
	job char(100) not null
)
go

create table Wars
(
	attacker_id int not null
		constraint wars_Clan_FK
			references Clan,
	defender_id int not null
		constraint wars_Clan_FK_1
			references Clan,
	initial_attacker_soldier_num int not null,
	final_attacker_soldier_num int not null,
	initial_defender_soldier_num int not null,
	final_defender_soldier_num int not null,
	startDate date not null,
	constraint Wars_PK
		primary key (attacker_id, defender_id, startDate)
)
go

create table upToNowRoles
(
	p_nid int not null
		constraint upToNowRoles_Player_FK
			references Player,
	role_id int not null
		constraint upToNowRoles_RoleName_FK
			references RoleName,
	level int not null,
	constraint upToNowRoles_PK
		primary key (p_nid, role_id)
)
go

