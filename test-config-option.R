library("sf")
library("RSQLite")
in_file = system.file("shape/storms_xyz.shp", package = "sf")
out_file = tempfile(fileext = ".gpkg")
Sys.setenv(OGR_CURRENT_DATE = "2020-01-02T03:04:05.678Z")
gdal_utils(
  util = "vectortranslate",
  source = in_file,
  destination = out_file,
  options = c("-f", "GPKG")
)
con <- dbConnect(SQLite(), out_file)
dbGetQuery(con, 'SELECT last_change FROM gpkg_contents')$last_change
