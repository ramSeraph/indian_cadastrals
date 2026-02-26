#!/bin/bash

# download all layers using the goa bbox
cat layers.txt | xargs -I {} uvx --from wmsdump wms-extractor extract {} -u https://onemapgoagis.goa.gov.in/ows/goa_dslrmap -s WMS -o GetFeatureInfo --out-srs EPSG:3857 --service-version 1.3.0 --flavor QGISserver  --bounds 8124033.1143,1673818.0454,8336680.9270,1784345.9883 -p 1 --max-box-dims 1000,1000 -m EXTENT

# angadiva which is not in the expected bbox
uvx --from wmsdump wms-extractor extract Canacona -u https://onemapgoagis.goa.gov.in/ows/goa_dslrmap -s WMS -o GetFeatureInfo --out-srs EPSG:3857 --service-version 1.3.0 --flavor QGISserver  --bounds 8247832.4362,1659275.9008,8252132.0190,1662849.3318 -p 1 --max-box-dims 1000,1000 Canacona_angadvipa.geojsonl -m EXTENT

cat Canacona_angadvipa.geojsonl >> Canacona.geojsonl

rm Canacona_angadvipa.geojsonl

# dedup to deal with bugs in wmsdump?
cat layers.txt | xargs -I {} uv run dedup.py {}

# convert from EPSG:3857 to EPSG:4326
cat layers.txt | xargs -I {} uv run ./convert.sh {}

# join into single file
uv run join.py 
