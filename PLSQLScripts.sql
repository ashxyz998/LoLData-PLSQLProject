
-- 1. Function to find the KDA of a player 
CREATE OR REPLACE FUNCTION get_player_kda(player_name IN VARCHAR2, in_league IN VARCHAR2 DEFAULT NULL) 
RETURN NUMBER
IS
kills NUMBER;
deaths NUMBER;
assists NUMBER;
BEGIN
    kills := 0;
    deaths := 0;
    assists := 0;
    IF in_league IS NULL THEN
        FOR rec IN (
                    SELECT kills,deaths,assists FROM loldata2023 WHERE playername = player_name
                    )
        LOOP
            kills := kills + rec.kills;
            deaths := deaths + rec.deaths;
            assists := assists + rec.assists;
        END LOOP;
    ELSE
        FOR rec IN(
                    SELECT kills, deaths,assists FROM loldata2023 WHERE playername = player_name AND league = in_league
                  )
        LOOP
            kills := kills + rec.kills;
            deaths := deaths + rec.deaths;
            assists := assists + rec.assists;
        END LOOP;
    END IF;
    IF deaths = 0 THEN
        deaths := deaths +1;
    END IF;
    RETURN ROUND((kills + assists) / deaths,2);
END;
/

-- 2. Function to find the stat score on a specific champion -- create objects and add methods
CREATE OR REPLACE TYPE stat_score AS OBJECT
    (
        kda NUMBER(5,2),
        
    
    );
CREATE OR REPLACE FUNCTION get_stat_score(player_name IN VARCHAR2, stat_champion IN VARCHAR2)
RETURN NUMBER(7,2), 
IS
kills NUMBER;


-- 3. Compare the stat score on specific champion


-- 4. Find the team which has the most early game influence
