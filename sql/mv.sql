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
	
    WITH t AS (
        SELECT MAX(avg_time) AS max_avg_time
        FROM mv_time_zones_statictics
    )
    SELECT tzs.*
    FROM mv_time_zones_statictics tzs
    JOIN t
        ON tzs.avg_time = t.max_avg_time
        
        
   -- Question 2    
    
-- Statistics for time zones	
CREATE MATERIALIZED VIEW mv_time_zones_statictics2 AS
	SELECT zone_in
	, zone_out
	, avg(time) avg_time
	, min(time) min_time
	, max(time) max_time
	, count(1)  number_trips
	FROM mv_time_zones
	group by zone_in, zone_out 
	

    WITH t AS (
        SELECT MAX(avg_time) AS max_avg_time
        FROM mv_time_zones_statictics
    )
    SELECT tzs.*
    FROM mv_time_zones_statictics2 tzs
    JOIN t
        ON tzs.avg_time = t.max_avg_time
        
        
    -- Question 3
    WITH T AS (
	 	select MAX(td.tpep_pickup_datetime) as MAX_PICKUP_DATETIME
	 	from trip_data td
	 	)
	SELECT tz.zone zone_in	
		,COUNT(1)
	FROM trip_data td
	JOIN taxi_zone tz ON td.puLocationID = tz.location_id
	join T on TD.tpep_pickup_datetime between (MAX_PICKUP_DATETIME- interval '17 HOUR') AND MAX_PICKUP_DATETIME
	group by zone_in
	order by count(1) desc
        
        
        

   