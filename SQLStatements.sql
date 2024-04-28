
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


-- 6. Find the person with the highest KDA
/*
SELECT playername, get_player_kda(playername) AS KDA
FROM loldata2023
WHERE get_player_kda(playername) = (
*/
    SELECT MAX(get_player_kda(playername)) AS KDA
    FROM loldata2023
    WHERE league = 'LPL' and position = 'mid' 
    GROUP BY playername
    ORDER BY KDA desc
    ;