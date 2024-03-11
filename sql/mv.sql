  -- Time for each trip and get zone descriptions.  
CREATE MATERIALIZED VIEW mv_time_zones AS
	SELECT tz1.zone zone_in
	, tz2.zone zone_out
	,td.tpep_dropoff_datetime - td.tpep_pickup_datetime as time
	FROM trip_data td
	JOIN taxi_zone tz1 ON td.puLocationID = tz1.location_id
	JOIN taxi_zone tz2 ON td.DOLocationID = tz2.location_id
	
-- Statistics for time zones	
CREATE MATERIALIZED VIEW mv_time_zones_statictics AS
	SELECT zone_in
	, zone_out
	, avg(time) avg_time
	, min(time) min_time
	, max(time) max_time
	FROM mv_time_zones
	group by zone_in, zone_out
	
select * 
from mv_time_zones_statictics
order by avg_time desc

   