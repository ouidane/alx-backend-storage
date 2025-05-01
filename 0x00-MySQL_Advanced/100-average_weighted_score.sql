-- 100-average_weighted_score.sql
DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id INT)
BEGIN
    DECLARE total_weight INT DEFAULT 0;
    DECLARE weighted_sum FLOAT DEFAULT 0;
    DECLARE avg_weighted_score FLOAT;

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
END $$

DELIMITER ;
