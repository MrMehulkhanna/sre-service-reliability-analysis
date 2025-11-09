-- service_reliability.sql
-- Calculates uptime % and downtime for notification-service in EU-CENTRAL-1 during Sept 2024

WITH
filtered_health AS (
  SELECT *
  FROM service_health
  WHERE service_id = 'notification-service'
    AND datacenter = 'EU-CENTRAL-1'
    AND check_timestamp >= '2024-09-01'
    AND check_timestamp < '2024-10-01'
),

filtered_incidents AS (
  SELECT
    incident_id,
    GREATEST(incident_start, TIMESTAMP '2024-09-01 00:00:00') AS overlap_start,
    LEAST(incident_end, TIMESTAMP '2024-10-01 00:00:00') AS overlap_end
  FROM service_incidents
  WHERE service_id = 'notification-service'
    AND datacenter = 'EU-CENTRAL-1'
    AND incident_end > TIMESTAMP '2024-09-01 00:00:00'
    AND incident_start < TIMESTAMP '2024-10-01 00:00:00'
),

health_summary AS (
  SELECT
    CASE WHEN COUNT(*) = 0 THEN 0.00
         ELSE ROUND(100.0 * SUM(CASE WHEN is_available THEN 1 ELSE 0 END) / COUNT(*), 2)
    END AS uptime_percentage,
    ROUND(AVG(CASE WHEN is_available THEN response_time_ms END), 2) AS avg_response_time
  FROM filtered_health
),

incident_summary AS (
  SELECT
    COUNT(*) AS total_incidents,
    ROUND(COALESCE(SUM(EXTRACT(EPOCH FROM (overlap_end - overlap_start)) / 60.0), 0.0), 2) AS total_downtime_minutes
  FROM filtered_incidents
)

SELECT
  h.uptime_percentage,
  h.avg_response_time,
  i.total_incidents,
  i.total_downtime_minutes
FROM health_summary h
CROSS JOIN incident_summary i;
