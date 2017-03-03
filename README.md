# MUSA-620-Week-6

Spatial databases ([notes](https://github.com/MUSA-620-Fall-2017/MUSA-620-Week-6/blob/master/week-6-spatial-databases.pptx))

![Distance from nearest SEPTA station](https://blueshift.io/distance-from-septa.png "Distance from nearest SEPTA station")
Distance from each building in Philadelpha to the nearest SEPTA station



## Assignment

This assignment is **required**. You may turn it in by email (galkamaxd at gmail) or in person at class.

**Due:** the first class after spring break, 15-Mar

### Task:

**Using the last 10 years of data from the [FARS database](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars) and [Philadelphia's road network](https://www.opendataphilly.org/dataset/street-centerlines), investigate the geospatial distribution of fatal vehicle crashes in Philadelphia ~~and whether alcohol was a contributing factor.~~**


### Deliverable:

**A map of Philadelphia's road network that displays the number of fatal accidents on each street segment**

**Please also include all SQL queries and any code used to construct the map.**

![Fatal accidents in Philadelphia](https://blueshift.io/philly-accidents.png "Fatal accidents in Philadelphia")

#### FARS Database

The **FARS (Fatality Analysis Reporting System)** is a relational database containing a record of every fatal traffic accident in the U.S. back to 1975. The database is made up of three primary tables.
- Accident table: information about the accident itelf (where it took place, weather conditions, time and date, etc).
- Vehicle table: information about the vehicles involved in the accidents (make/model, estimated speed at time of impact, damage, etc).
- Person table:  information about the people involved in the accidents (demographics, which seat of the car they were in, whether or not they were injured, etc).

We will be using data from the period 2004-2013. For the purposes of this project, only the accident table is needed.

([Download clean, standardized versions of the FARS tables here](http://metrocosm.com/get-the-data/#accidents)).


#### Set up PostGIS Database

First, you will need to create a PostGIS database with three spatial tables:
1. Philadelphia city borders ([download shapefile here](https://github.com/MUSA-620-Fall-2017/MUSA-620-Week-6/blob/master/philadelphia_borders.zip))
2. Philadelphia road network ([download shapefile here](https://www.opendataphilly.org/dataset/street-centerlines))
3. FARS accident table -- use the "latitude" and "longitud" columns to create a point layer, then import to PostGIS.

We will not be using these tables, but you may want to import tham anyway so you have them avaialable to work with FARS in the future.
4. FARS vehicle table
5. FARS person table


#### PostGIS Queries

You can pull this data together by constructing the following three SQL queries.

1. **Remove all accidents that did not happen in Philadelphia.** You can do this by running a spatial join query of this form:

    SELECT ???
    FROM ???
    WHERE ST_WITHIN(???)

  Save this table as a view (or export the results as a layer and reimport it into your database as a new table).

2. **Match each accident to a street segment.** This should be a spatial join query, similar to the [example we did in class to find the nearest SEPTA station](https://github.com/MUSA-620-Fall-2017/MUSA-620-Week-7/blob/master/README.md). In this case, you are finding the nearest street segment for each point. The result should be the same as the table you created in the last step with one additional column, the nearest street id.

    SELECT DISTINCT ON ???
    FROM ???
    ORDER BY ???

  Save this table as a new view.

3. **Join the accident data to the Philly road network** The final query should be a left join, to combine the table you created in the last step with the Philadelphia street network. 

    SELECT ??? SUM(your_accident_table.&#42;) as num_accidents, ???
    FROM ???
    LEFT JOIN ???
    ON ???
    GROUP BY ???

  Export the results as a QGIS layer, and save it as a shapefile.


#### Visualize the Results

Use ArcMap or QGIS to visualize the data. [This video](https://www.youtube.com/watch?v=wpracFy4rVE) shows how to style the layer in QGIS: varying the line width and color according to the number of accidents. 


### Useful Links

[Postgres / PostGIS](https://www.enterprisedb.com/software-downloads-postgres)

[QGIS](http://www.qgis.org/en/site/)

[Philadelphia road network](https://www.opendataphilly.org/dataset/street-centerlines)

[FARS database: cleaned & standardized tables for download](http://metrocosm.com/get-the-data/#accidents)

[FARS database: original source & documentation](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars)





