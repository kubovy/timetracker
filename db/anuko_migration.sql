INSERT INTO `logs` (
        `employer_id`, `team_id`, `user_id`,
        `client_id`, `invoice_id`,
        `project_id`, `task_id`, 
        `date`, `start`, `duration`,
        `description`, `billable`,
        `created_at`, `updated_at`)


SELECT (SELECT 2) AS `employer_id`,
        (SELECT 1) AS `team_id`,
        `activity_log`.`al_user_id` AS `user_id`,
        
        (SELECT NULL) AS `client_id`,
        (SELECT NULL) AS `invoice_id`,
        
        `activity_log`.`al_project_id` AS `project_id`,
        `activity_log`.`al_activity_id` AS `task_id`,
        
        `activity_log`.`al_date` AS `date`,
        `activity_log`.`al_from` AS `start`,
        `activity_log`.`al_duration` AS `duration`,
        
        `activity_log`.`al_comment` AS `description`,
        `activity_log`.`al_billable` AS `billable`,
        
        (SELECT CURRENT_TIMESTAMP) AS `created_at`,
        (SELECT CURRENT_TIMESTAMP) AS `updated_at`
FROM activity_log;