create or alter procedure initilizeResourceTable
as begin
  insert into Resource( name , unit ) values ( 'food' , 'gram' )
  insert into Resource( name , unit ) values( 'gold' , 'gram' )
  insert into Resource( name , unit ) values( 'wood' , 'number' )
  insert into Resource( name , unit ) values( 'army' , 'count' )
end