{{
    config(
        materialized='table')
}}

with fhv_data as (
    select *,
        'Fhv' as service_type
    from {{ ref("stg_fhv_2019") }}
),

dim_zones as (
    select * from {{ ref('taxi_zone_lookup') }}
    where Borough != 'Unknown'
)

select 
    fhv_data.dispatching_base_num,
    fhv_data.service_type,
    fhv_data.pulocationid,
    pickup_zone.Borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    fhv_data.dolocationid,
    dropoff_zone.Borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone,
    fhv_data.pickup_datetime,
    fhv_data.dropoff_datetime,
    fhv_data.sr_flag
from fhv_data
inner join dim_zones as pickup_zone
on fhv_data.pulocationid = pickup_zone.LocationID
inner join dim_zones as dropoff_zone
on fhv_data.dolocationid = dropoff_zone.LocationID