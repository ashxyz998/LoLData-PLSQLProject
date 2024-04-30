
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
SELECT playername, VSPM 
FROM loldata2023
WHERE league IN ('LCK','LEC','LPL','LCS','PCS','LJL','CBLOL','LLA','VCS','WLDs','MSI') AND playername NOT LIKE 'unknown player'
ORDER BY VSPM;

-- 9. Highest Death ratio (deaths/game) for players in Worlds
SELECT playername, SUM(deaths)/COUNT(playername) AS Death_Ratio
FROM loldata2023
WHERE league = 'WLDs'
GROUP BY playername
ORDER BY Death_Ratio;

-- 10. Teams' drakes/game rate
SELECT team, SUM(dragons)/COUNT(team) AS Drake_Ratio
FROM loldata2023
WHERE league = 'LCK' and playername = null
GROUP BY team
ORDER BY Drake_Ratio;

-- 11. Person who lost the most gold buying control wards
SELECT playername, controlwardsbought, controlwardsbought * (-75) AS Gold_Lost
FROM loldata2023
WHERE league IN ('LCK','LEC','LPL','LCS','PCS','LJL','CBLOL','LLA','VCS','WLDs','MSI') AND playername NOT LIKE 'unknown player' AND controlwardsbought = 
    (SELECT MAX(controlwardsbought)
    FROM loldata2023
    WHERE league IN ('LCK','LEC','LPL','LCS','PCS','LJL','CBLOL','LLA','VCS','WLDs','MSI') AND playername NOT LIKE 'unknown player');
-- 12. Match with most triple kills

-- 13. Player who gave the most number of first bloods

-- 14. DMG / Gold ratio 

-- 15. Team which takes the most turret plates per game

-- 16. Junglers with the highest counter jungling percentage

-- 17. Find the drakes' percentages. (Find which drake spawned the highest)

-- 18. Most picked champion in support role at Worlds

-- 19. Teams that got first three towers and still lost the game.

-- 20. Reverse sweep
