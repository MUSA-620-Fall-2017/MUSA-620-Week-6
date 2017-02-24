# MUSA-620-Week-6

Spatial databases ([notes](https://github.com/MUSA-620-Fall-2017/MUSA-620-Week-6/blob/master/week-6-spatial-databases.pptx))

![Distance from nearest SEPTA station](https://blueshift.io/septa-distance.png "Distance from nearest SEPTA station")



## Assignment

This assignment is **required**. You may turn it in by email (galkamaxd at gmail) or in person at class.

**Due:** the first class after spring break, 15-Mar

### Task:

**Using the last 10 years of data from the [[FARS] database](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars) and [Philadelphia's road network](https://www.opendataphilly.org/dataset/street-centerlines), investigate the geospatial distribution of fatal vehicle crashes in Philadelphia and whether alcohol was a contributing factor.**


### Deliverable:

**A map of Philadelphia's road network that displays the number of fatal accidents on each street (visualized as line width) as well as whether alcohol was a contributing factors (visualized as color). Please also include all SQL queries used to construct the map.**


To construct this map, you will need to create a PostGIS database with four tables: one for the Philadelphia road network and one for each of the tables in the FARS database (accident, vehicle, and person). The FARS accident table contains the coordinates of each accident and should be imported as a spatial table (with point geometry). The other tables (vehicle and person) do not contain geospatial data, and should be imported as standard data tables.

To combine this data into the right format, you should construct three SQL queries. You can run these queries in PGAdmin, or if you prefer, in Qgis.

- The information you need from FARS is the location of the accident (in the accident table) and its contributing factors (in the person table). Construct a join query to combine this data together into a *view* (a temporary table in your database).

- The next step is create a new view that also contains the street on which the accident happened. You can do this using a spatial join query. For each point in the view you just created, join the id of the nearest street segment. You should now have a new view that contains the coordinates of each accident, that accident's contributing factors, and the id of the street segment on which it occured.

- The last SQL query should aggregate the accident data for each street segment and join it to the road network table. Load the resulting table into ArcMap.

Use ArcMap (or Qgis) to style the layer. Vary the line width according number of accidents. Vary the color according to the % of accidents where alcohol was a contributing factor.



### Useful Links

[Postgres / PostGIS](https://www.enterprisedb.com/software-downloads-postgres)

[QGIS: for importing data to PostGIS](http://www.qgis.org/en/site/)

[Philadelphia road network](https://www.opendataphilly.org/dataset/street-centerlines)

[Download a cleaned & standardized version of the FARS data from here](http://metrocosm.com/get-the-data/#accidents)

[FARS database: original source & documentation](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars)












