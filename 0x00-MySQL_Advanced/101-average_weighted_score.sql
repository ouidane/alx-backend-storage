-- 101-average_weighted_score.sql
DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE user_cursor CURSOR FOR SELECT id FROM users;
    DECLARE done INT DEFAULT 0;
    DECLARE user_id INT;
    DECLARE total_weight INT;
    DECLARE weighted_sum FLOAT;
    DECLARE avg_weighted_score FLOAT;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN user_cursor;

    read_loop: LOOP
        FETCH user_cursor INTO user_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT SUM(score * weight) INTO weighted_sum
        FROM corrections c
        JOIN projects p ON c.project_id = p.id
        WHERE c.user_id = user_id;

        SELECT SUM(weight) INTO total_weight
        FROM projects p
        JOIN corrections c ON c.project_id = p.id
        WHERE c.user_id = user_id;

        IF total_weight > 0 THEN
            SET avg_weighted_score = weighted_sum / total_weight;
        ELSE
            SET avg_weighted_score = 0;
        END IF;

        UPDATE users SET average_score = avg_weighted_score WHERE id = user_id;

    END LOOP;

    CLOSE user_cursor;
END $$

DELIMITER ;
