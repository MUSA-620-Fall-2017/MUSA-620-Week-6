# MUSA-620-Week-6

Spatial databases ([notes](https://github.com/MUSA-620-Fall-2017/MUSA-620-Week-6/blob/master/week-6-spatial-databases.pptx))

![Distance from nearest SEPTA station](https://blueshift.io/distance-from-septa.png "Distance from nearest SEPTA station")
Distance from each building in Philadelpha to the nearest SEPTA station



## Assignment

This assignment is **required**. You may turn it in by email (galkamaxd at gmail) or in person at class.

**Due:** the first class after spring break, 15-Mar

### Task:

**Using the last 10 years of data from the [FARS database](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars) and [Philadelphia's road network](https://www.opendataphilly.org/dataset/street-centerlines), investigate the geospatial distribution of fatal vehicle crashes in Philadelphia and whether alcohol was a contributing factor.**


### Deliverable:

**A map of Philadelphia's road network that displays:**
1. **the number of fatal accidents on each street segment (visualized as line width) and**
2. **whether alcohol was a contributing factor (visualized using color).**

**Please also include all SQL queries and any code used to construct the map.**


FARS (Fatality Analysis Reporting System) is a relational database containing a record of every fatal traffic accident in the U.S. back to 1975. The database is made up of three primary tables.
- Accident table: information about the accident itelf (where it took place, weather conditions, time and date, etc).
- Vehicle table: information about the vehicles involved in the accidents (make/model, estimated speed at time of impact, damage, etc).
- Person table:  information about the people involved in the accidents (demographics, which seat of the car they were in, whether or not they were injured, etc).

We will be using data from the period 2004-2013. For the purposes of this project, we will need the accident locations ("latitude", "longitud" columns in the accident table) and a record of whether alcohol was a factor ("DR_DRINK" column in the vehicle table).

([Download clean, standardized versions of these tables here](http://metrocosm.com/get-the-data/#accidents)).


Before working with the data, you will need to create a PostGIS database with four tables:

Two spatial tables:
1. Philadelphia road network ([download shapefile here](https://www.opendataphilly.org/dataset/street-centerlines))
2. FARS accident table -- use the "latitude" and "longitud" columns to create a point layer, then import to PostGIS.

Three attribute tables (no spatial component):
3. FARS vehicle table
4. FARS person table (we will not be using this table, but I include it here for good measure)


You can pull this data together by constructing the following three SQL queries. The queries can be run in PGAdmin, or if you prefer, in Qgis.

1. Use the "ST_CASE" field to join the accident table with the vehicle table, creating a single table with the coordinates of each accident as well as information about alcohol involvement (note: if the driver was drunk ("DR_DRINK" = 1) in *any* of the vehicles involved in the accident, alcohol was a factor). Save this table as a view.

2. Create another spatial query to join the accident data to the Philadelphia road network. This query will contain several pieces. Similar to the [example we did in class](https://github.com/MUSA-620-Fall-2017/MUSA-620-Week-7/blob/master/README.md), this query should join each accident to the nearest street segment. The fields in your SELECT clause should include a count of the number of accidents, as well as a count of the number of accidents in which alcohol was a factor.


Use ArcMap (or Qgis) to style the layer. Vary the line width according number of accidents. Vary the color according to the % of accidents where alcohol was a contributing factor.



### Useful Links

[Postgres / PostGIS](https://www.enterprisedb.com/software-downloads-postgres)

[QGIS: for importing data to PostGIS](http://www.qgis.org/en/site/)

[Philadelphia road network](https://www.opendataphilly.org/dataset/street-centerlines)

[FARS database: cleaned & standardized tables for download](http://metrocosm.com/get-the-data/#accidents)

[FARS database: original source & documentation](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars)

[DVRPC Rail Station](https://www.opendataphilly.org/dataset/dvrpc-passenger-rail)












