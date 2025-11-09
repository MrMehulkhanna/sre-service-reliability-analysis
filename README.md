# sre-service-reliability-analysis
DuckDB analysis for notification-service uptime and downtime (Sept 2024)
# Service Reliability Analysis — notification-service (EU-CENTRAL-1) — Sept 2024

This repository contains a DuckDB SQL query that computes reliability metrics for `notification-service` in `EU-CENTRAL-1` during September 2024.

## Files
- `query/service_reliability.sql` — final DuckDB SQL returning one row with:
  - `uptime_percentage` (0-100, rounded to 2 decimals)
  - `avg_response_time` (ms, rounded to 2 decimals) — only when service available
  - `total_incidents` (count of incidents overlapping the month)
  - `total_downtime_minutes` (minutes, portion inside month, rounded to 2 decimals)

## How to run locally (DuckDB)
See instructions below.

## Author
Mehul Khanna  
📧 23f2001539@ds.study.iitm.ac.in
