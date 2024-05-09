
-- Count the number of partial data in dataset grouped by league
SELECT league,COUNT(*)
FROM LolData2023 
WHERE datacompleteness = 'partial' AND participantid = 100
GROUP BY league;

-- Find the blue side win rate in all leagues
SELECT
    ROUND(
        COUNT(
            CASE
            WHEN PARTICIPANTID = 100 AND RESULT = 1 THEN '*'
            END
            ) / COUNT(*) * 100, 2) AS BLUE_SIDE_PERCENTAGE
FROM LOLDATA2023
WHERE PARTICIPANTID = 100;

-- 1. Find the blue side win rate in major leagues
SELECT league,ROUND((COUNT(CASE WHEN participantid = 100 AND result = 1 THEN '*' END) / COUNT(*)) * 100,2) AS Blue_Side_Percentage
FROM LoLData2023 
WHERE participantid = 100 AND league IN ('LCK','LPL','LEC','LCS')
GROUP BY league;

-- 2. Find the average game times in LCK and sort them from fastest to slowest and display the time in minutes.
SELECT teamname,floor(AVG(gamelength) / 60) || ':' || lpad(mod(AVG(gamelength), 60), 2, '0') AS Average_Game_Time_In_Minutes
FROM LolData2023 
WHERE league IN ('LCK')
GROUP BY teamname
ORDER BY Average_Game_Time_In_Minutes;

-- 3. Find the team with the fastest average game time in Major Leagues.
SELECT teamname,league,FLOOR(T.avg_gamelength/60)||':'|| LPAD(MOD(T.avg_gamelength,60),2,'0') AS Fastest_Average_Game_Time
FROM
(SELECT teamname,league,AVG(gamelength) AS avg_gamelength
FROM LolData2023 
WHERE league IN ('LCK','LPL','LEC','LCS')
GROUP BY teamname,league
ORDER BY avg_gamelength
) T
WHERE ROWNUM =1;

-- 4. Count the number of times matches went to 5 games in all Tier 1 regions and how many of those were won by the team.
SELECT teamname, COUNT(CASE WHEN result = 1 THEN '*' END) AS No_Of_Wins,COUNT(*) AS Total_Appearances
FROM LolData2023 
WHERE game = 5 AND position = 'team' AND league IN ('LCK','LEC','LPL','LCS','PCS','LJL','CBLOL','LLA','VCS')
GROUP BY teamname
ORDER BY Total_Appearances desc;

-- 5. Show the players who have the highest champion count throughout a year in Tier 1 play.
SELECT playername,COUNT(DISTINCT champion) AS Champion_Count
FROM loldata2023
WHERE league IN ('LCK','LEC','LPL','LCS','PCS','LJL','CBLOL','LLA','VCS','WLDs','MSI') AND playername NOT LIKE 'unknown player'
GROUP BY playername
ORDER BY Champion_Count desc;

-- 6. Show the players with the highest KDA in LPL
SELECT playername, get_player_kda(playername) AS KDA
FROM loldata2023
WHERE league = 'LPL' 
GROUP BY playername
ORDER BY KDA desc;

-- 7. Show a player's KDA for whole year and at worlds
SELECT playername, get_player_kda(playername) AS KDA, get_player_kda(playername,'WLDs') AS KDA_AT_WORLDS
FROM loldata2023
WHERE playername = 'Ruler'
GROUP BY playername;


-- 8. Support players with highest VSPM in Tier 1 league
SELECT playername, count(playername) as no_of_games, ROUND(AVG(VSPM),2) AS VSPM_avg
FROM loldata2023
WHERE league IN ('LCK','LEC','LPL','LCS','PCS','LJL','CBLOL','LLA','VCS','WLDs','MSI') AND playername NOT LIKE 'unknown player' AND position='sup'
group by playername
having count(playername) > 10
order by VSPM_avg desc;

-- 9. Highest Death ratio (deaths/game) for players in Worlds
SELECT playername, ROUND(SUM(deaths)/COUNT(playername),2) AS Death_Ratio
FROM loldata2023
WHERE league = 'WLDs'
GROUP BY playername
HAVING COUNT(playername) > 0
ORDER BY Death_Ratio desc;

-- 10. Teams' drakes/game rate
SELECT teamname, 
    SUM(dragons)AS Total_Drakes, 
    COUNT(teamname) as No_of_games,
    ROUND(SUM(dragons)/COUNT(teamname),1) AS Drakes_Per_Game, 
    ROUND( SUM(dragons) / (SUM(dragons)+SUM(opp_dragons)) * 100,1) AS Drake_WIN_Ratio
FROM loldata2023
WHERE league = 'LCK' and position = 'team'
GROUP BY teamname
ORDER BY teamname;

-- 11. Person who lost the most gold buying control wards
SELECT playername, league,match_date, game as Game_NO, controlwardsbought, controlwardsbought * (-75) AS Gold_Lost
FROM loldata2023
WHERE league IN ('LCK','LEC','LPL','LCS','PCS','LJL','CBLOL','LLA','VCS','WLDs','MSI') AND playername NOT LIKE 'unknown player' AND controlwardsbought = 
    (SELECT MAX(controlwardsbought)
    FROM loldata2023
    WHERE league IN ('LCK','LEC','LPL','LCS','PCS','LJL','CBLOL','LLA','VCS','WLDs','MSI') AND playername NOT LIKE 'unknown player');

-- 12. Match with most triple kills from a team
SELECT teamname, league, match_date, game as Game_NO
    FROM loldata2023
    WHERE position = 'team' AND triplekills = (
    SELECT MAX(triplekills)
    FROM loldata2023
    WHERE position = 'team'
    );

-- 13. Player who was the first blood victim the most
SELECT playername, SUM(firstbloodvictim) AS No_of_First_Deaths
    FROM loldata2023
    WHERE playername = (
        SELECT playername
        FROM loldata2023
        GROUP BY playername
        HAVING SUM(firstbloodvictim) = (
            SELECT MAX(SUM(firstbloodvictim))
            FROM loldata2023
            GROUP BY playername
        )
    ); 

-- 14. DMG / Gold ratio 
SELECT ROUND((damageshare/earnedgold) * 100,2) AS DMG_PER_GOLD_Ratio
    FROM loldata2023
    WHERE position !='team' 
    ORDER BY DMG_PER_GOLD_Ratio desc;

-- 15. Team which takes the most turret plates per game
SELECT T.* 
    FROM (
SELECT teamname, AVG(turretplates) AS Turret_Plates_per_Game
    FROM loldata2023
    WHERE position = 'team' 
    GROUP BY teamname
    ORDER BY Turret_Plates_per_Game
    ) T
    WHERE ROWNUM = 1;

-- 16. Junglers with the highest counter jungling percentage
SELECT ROUND((MONSTERKILLSENEMYJUNGLE/MONSTERKILLS) * 100,2) AS Counter_Jungling_Percent
    FROM loldata2023
    WHERE league IN ('LCK','LEC','LPL','LCS','PCS','LJL','CBLOL','LLA','VCS','WLDs','MSI') AND playername NOT LIKE 'unknown player'
    GROUP BY playername
    ORDER BY Counter_Jungling_Percent desc;

-- 17. Find the drakes' percentages. (Find which drake spawned the highest)
SELECT SUM(infernals) AS INFERNAL,
    ROUND((SUM(infernals)/SUM(infernals+mountains+clouds+oceans+chemtechs+hextechs+elders))*100,2) AS INFERNAL_RATIO
    SUM(mountains) AS MOUNTAIN, 
    ROUND((SUM(mountains)/SUM(infernals+mountains+clouds+oceans+chemtechs+hextechs+elders))*100,2) AS INFERNAL_RATIO
    SUM(clouds) AS CLOUD, 
    ROUND((SUM(clouds)/SUM(infernals+mountains+clouds+oceans+chemtechs+hextechs+elders))*100,2) AS INFERNAL_RATIO
    SUM(oceans) AS OCEAN, 
    ROUND((SUM(oceans)/SUM(infernals+mountains+clouds+oceans+chemtechs+hextechs+elders))*100,2) AS INFERNAL_RATIO
    SUM(chemtechs) AS CHEMTECH,
    ROUND((SUM(chemtechs)/SUM(infernals+mountains+clouds+oceans+chemtechs+hextechs+elders))*100,2) AS INFERNAL_RATIO
    SUM(hextechs) AS HEXTECH,
    ROUND((SUM(hextechs)/SUM(infernals+mountains+clouds+oceans+chemtechs+hextechs+elders))*100,2) AS INFERNAL_RATIO
    SUM(elders) AS ELDER,
    ROUND((SUM(elders)/SUM(infernals+mountains+clouds+oceans+chemtechs+hextechs+elders))*100,2) AS INFERNAL_RATIO
    FROM loldata2023
    WHERE league IN ('LCK','LEC','LPL','LCS','PCS','LJL','CBLOL','LLA','VCS','WLDs','MSI') AND position = 'team'
    GROUP BY league;
    
-- 18. Most picked champion in support role at Worlds
SELECT champion
    FROM loldata2023
    WHERE champion = (
        SELECT champion
        FROM loldata2023
        WHERE league = 'WLDs' AND position='supp'
        GROUP BY champion
        HAVING COUNT(champion) = (
            SELECT MAX(COUNT(champion))
            FROM loldata2023
            WHERE league = 'WLDs' AND position = 'supp'
            GROUP BY champion
        )
    )
    GROUP BY champion;
    
-- 19. Teams that got first three towers and still lost the game.
SELECT teamname, league, match_date, game as Game_NO
    FROM loldata2023
    WHERE position = 'team' AND firsttothreetowers = 1 AND result = 0
    GROUP BY teamname
    ORDER BY match_date;
    
-- 20. Reverse sweep
SELECT L.teamname, L.league, L.match_date
    FROM loldata2023 L
    WHERE L.position = 'team' AND L.game = 5 AND L.result = 1 AND L.match_date = (
        SELECT L1.match_date
        FROM loldata2023 L1
        WHERE L1.position = 'team' AND L1.game = 4 AND L1.result = 1 AND L1.match_date = (
            SELECT L2.match_date
            FROM loldata2023 L2
            WHERE L2.position = 'team' AND L2.game = 3 AND L2.result = 1
        )
    )
    GROUP BY L.teamname
    ORDER BY L.match_date
    
/*
select teamname,league,count(*) from loldata2023
where teamname = 'Bilibili Gaming' and position = 'team'
group by teamname,league;
*/
select * from loldata2023;
