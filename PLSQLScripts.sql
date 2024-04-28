
-- 1. Function to find the KDA of a player 
CREATE OR REPLACE FUNCTION get_player_kda(player_name IN VARCHAR2, league IN VARCHAR2 DEFAULT NULL) 
RETURN NUMBER
IS
kills NUMBER;
deaths NUMBER;
assists NUMBER;
BEGIN
    kills := 0;
    deaths := 0;
    assists := 0;
    FOR rec IN (
                SELECT kills,deaths,assists FROM loldata2023 WHERE playername = player_name
                )
    LOOP
        kills := kills + rec.kills;
        deaths := deaths + rec.deaths;
        assists := assists + rec.assists;
    END LOOP;
    IF deaths = 0 THEN
        deaths := deaths +1;
    END IF;
    RETURN ROUND((kills + assists) / deaths,2);
END;
/

