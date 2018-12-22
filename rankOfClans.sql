create or alter function rankOfClans
(
) returns table
as return
  (
    select NumOfWins.cid , dbo.calcExperience( NumOfWins.cid ) as experience, NumOfLoses.numOfLoses as w , NumOfWins.numOfWins as l from
    (
      select clan.cid , count( * ) as numOfWins from Clan clan , Wars wars
      where ( clan.cid = wars.attacker_id
      and wars.initial_attacker_soldier_num >= wars.initial_defender_soldier_num )
      or ( clan.cid = wars.defender_id and wars.initial_attacker_soldier_num <= wars.initial_defender_soldier_num )
      group by clan.cid
      ) as NumOfWins ,
    (
      select clan.cid , count( * ) as numOfLoses from Clan clan , Wars wars
      where ( clan.cid = wars.attacker_id
      and wars.initial_attacker_soldier_num < wars.initial_defender_soldier_num )
      or ( clan.cid = wars.defender_id and wars.initial_attacker_soldier_num > wars.initial_defender_soldier_num )
      group by clan.cid
      ) as NumOfLoses
    where
    NumOfLoses.cid = NumOfWins.cid
  )