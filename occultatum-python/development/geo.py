print(" hello world")

import geopandas as gpd
import folium
import random
from shapely.geometry import box
import numpy as np
import rasterio
from rasterio.features import rasterize
import matplotlib.pyplot as plt
from matplotlib.patches import Patch
import json
import os
import pandas as pd

import pynetlogo
jvm_path = os.path.join(os.environ["JAVA_HOME"], "lib", "server", "libjvm.so")

netlogo = pynetlogo.NetLogoLink(
    gui=True,
    jvm_path=jvm_path,
)

netlogo.load_model('/home/juliusdb/Documents/repos/occultatum-assets/occultatum_farms.nlogo')

netlogo.command('setup')

with open("/home/juliusdb/Documents/repos/occultatum-assets/limes_paleogeography.json") as f:
    data = json.load(f)
gdf = gpd.GeoDataFrame.from_features(data)
print("Loaded GeoDataFrame with", len(gdf), "features")
if gdf.empty:
    print("WARNING: GeoDataFrame is empty. Check that 'limes_paleogeography.json' exists and contains valid features.")
    # Optionally, print the file path and exit early for clarity
    import os
    print("Current working directory:", os.getcwd())
    print("File exists:", os.path.exists("limes_paleogeography.json"))
    # Optionally, exit to avoid further errors
    import sys
    sys.exit(1)

# Ensure data is in a projected CRS (meters), reproject if needed
if gdf.crs is None:
    # Set the CRS to WGS84 (EPSG:4326) if you know that's correct for your data
    gdf.set_crs(epsg=4326, inplace=True)

if gdf.crs.to_epsg() == 4326:
    # You must know the correct projected CRS for your data!
    # Example: Amersfoort / RD New (EPSG:28992) for the Netherlands
    gdf = gdf.to_crs(epsg=28992)

# Get the total bounds of the data (minx, miny, maxx, maxy)
minx, miny, maxx, maxy = gdf.total_bounds

hectare_side = 100  # meters
window_size = 10 * hectare_side  # 1000 meters

# Try to find a window with at least 3 soil types
max_attempts = 1000
attempt = 0
found = False

# List of valid soils
VALID_SOILS = {
    "coversands",
    "coversands (uncertain)",
    "dunes and beach ridges",
    "estuary",
    "eutrophic peatlands",
    "eutrophic peatlands (uncertain)",
    "fluvial terraces",
    "high Pleistocene sands",
    "high floodplain",
    "high natural levee",
    "high natural levee (Vecht)",
    "high natural levee (uncertain)",
    "low floodplain",
    "low floodplain (uncertain)",
    "low natural levee",
    "low natural levee (uncertain)",
    "mesotrophic peatlands",
    "mesotrophic peatlands (uncertain)",
    "moderately high natural levee",
    "moderately high natural levee (Vecht)",
    "moderately high natural levee (uncertain)",
    "oligotrophic peatlands",
    "oligotrophic peatlands (uncertain)",
    "post-Roman erosion",
    "river dunes",
    "tidal flats",
    "tidal flats (uncertain)",
}

# Color mapping for rasterization (hex to RGB)
SOIL_COLORS = {
    "coversands": "#FFFFBE",
    "coversands (uncertain)": "#FFFFBE",
    "dunes and beach ridges": "#E6E600",
    "estuary": "#73DFFF",
    "eutrophic peatlands": "#D79E9E",
    "eutrophic peatlands (uncertain)": "#D79E9E",
    "fluvial terraces": "#A8A800",
    "high Pleistocene sands": "#D7C29E",
    "high floodplain": "#89CD66",
    "high natural levee": "#AAFF00",
    "high natural levee (Vecht)": "#AAFF00",
    "high natural levee (uncertain)": "#AAFF00",
    "low floodplain": "#9ED7C2",
    "low floodplain (uncertain)": "#9ED7C2",
    "low natural levee": "#ABCD66",
    "low natural levee (uncertain)": "#ABCD66",
    "mesotrophic peatlands": "#CD8966",
    "mesotrophic peatlands (uncertain)": "#CD8966",
    "moderately high natural levee": "#CDF57A",
    "moderately high natural levee (Vecht)": "#CDF57A",
    "moderately high natural levee (uncertain)": "#CDF57A",
    "oligotrophic peatlands": "#CD6666",
    "oligotrophic peatlands (uncertain)": "#CD6666",
    "post-Roman erosion": "#E1E1E1",
    "river dunes": "#FFFF00",
    "tidal flats": "#448970",
    "tidal flats (uncertain)": "#448970",
    "rivers and streams": "#BEE8FF",   # add this line
    "lakes": "#BEE8FF",                # add this line if needed
    "sea": "#BEE8FF",                  # add this line if needed
}

while attempt < max_attempts and not found:
    x0 = random.uniform(minx, maxx - window_size)
    y0 = random.uniform(miny, maxy - window_size)
    x1 = x0 + window_size
    y1 = y0 + window_size

    window_poly = box(x0, y0, x1, y1)
    window_gdf = gdf[gdf.intersects(window_poly)].copy()

    # Extract soil types from the 'element' property
    if 'element' in window_gdf.columns:
        soil_types = window_gdf['element'].dropna().unique()
        valid_soil_types = [s for s in soil_types if s in VALID_SOILS]
        # Area check for rivers/streams/water
        river_types = {
            "low floodplain",
            "low floodplain (uncertain)",
            "estuary",
            "tidal flats",
            "tidal flats (uncertain)",
            "rivers and streams",
            "lakes",
            "sea",
            "dunes and beach ridges",
        }
        window_gdf['area'] = window_gdf.geometry.area
        river_area = window_gdf[window_gdf['element'].isin(river_types)]['area'].sum()
        total_area = window_gdf['area'].sum()
        river_fraction = river_area / total_area if total_area > 0 else 0
        has_water = any(s in river_types for s in soil_types)
        # Area fraction for each valid soil type
        soil_area_fractions = []
        for soil in set(valid_soil_types):
            soil_area = window_gdf[window_gdf['element'] == soil]['area'].sum()
            fraction = soil_area / total_area if total_area > 0 else 0
            soil_area_fractions.append(fraction)
        # Ensure at least 3 valid soils, <=50% water, at least one water type, and each soil >=10%
        if (
            len(set(valid_soil_types)) >= 3 and
            river_fraction <= 0.5 and
            has_water and
            all(f >= 0.10 for f in soil_area_fractions)
        ):
            found = True
    attempt += 1

if not found:
    raise RuntimeError("Could not find a window with at least 3 soil types after {} attempts.".format(max_attempts))

# Debug: print all unique layers present in the selected area (not just soil layers)
if 'element' in window_gdf.columns:
    present_layers = window_gdf['element'].dropna().unique()
    print("All layers present in selected area:", present_layers)

# Reproject everything to WGS84 for Folium
gdf_wgs = gdf.to_crs(epsg=4326)
window_gdf_wgs = window_gdf.to_crs(epsg=4326)
window_poly_wgs = gpd.GeoSeries([window_poly], crs=gdf.crs).to_crs(epsg=4326).iloc[0]

# Center the map on the window
center = [window_poly_wgs.centroid.y, window_poly_wgs.centroid.x]
m = folium.Map(location=center, zoom_start=15)

# Add the main data and the window

def style_function(feature):
    element = feature['properties'].get('element', '')
    # Blue for rivers, lakes, streams, and other water
    if element in {"estuary", "tidal flats", "tidal flats (uncertain)", "rivers and streams", "lakes"}:
        return {'color': '#BEE8FF', 'weight': 2, 'fillColor': '#BEE8FF', 'fillOpacity': 0.7}
    # Use color mapping for other soils
    color = SOIL_COLORS.get(element, '#888888')
    return {'color': color, 'weight': 1, 'fillColor': color, 'fillOpacity': 0.7}

folium.GeoJson(
    window_gdf_wgs,
    name="Data in Window",
    style_function=style_function
).add_to(m)

folium.GeoJson(
    gdf_wgs,
    name="All Data",
    style_function=lambda x: {'color': 'gray', 'weight': 1, 'fillOpacity': 0.1}
).add_to(m)

folium.GeoJson(
    window_poly_wgs,
    name="10x10 Hectare Window",
    style_function=lambda x: {'color': 'red', 'weight': 3, 'fillOpacity': 0}
).add_to(m)

# Rasterization of just the layers (not the base map)
def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

# Prepare shapes and values for rasterization
shapes = []
values = []
for _, row in window_gdf.iterrows():
    soil = row.get("element")
    # Use blue for any water/stream type not in SOIL_COLORS
    color = SOIL_COLORS.get(soil)
    if not color and soil in {
        "rivers and streams", "streams", "stream", "water", "lake", "lakes", "sea"
    }:
        color = "#BEE8FF"
        SOIL_COLORS[soil] = color  # ensure legend and mapping consistency
    if color:
        shapes.append((row.geometry, soil))
        values.append(soil)

# Assign an integer value to each soil type for the raster
soil_to_int = {soil: i+1 for i, soil in enumerate(SOIL_COLORS.keys())}
int_to_rgb = {soil_to_int[soil]: hex_to_rgb(SOIL_COLORS[soil]) for soil in SOIL_COLORS}

# Raster size and transform
out_shape = (10, 10)
transform = rasterio.transform.from_bounds(x0, y0, x1, y1, out_shape[1], out_shape[0])

# Rasterize to integer mask
raster = rasterize(
    ((geom, soil_to_int.get(val, 0)) for geom, val in shapes),
    out_shape=out_shape,
    transform=transform,
    fill=0,
    dtype="uint8"
)

# Build a DataFrame of soil type indices for NetLogo patch_set
soil_type_df = pd.DataFrame(raster)

print(soil_type_df.head())

# Ensure NetLogo world matches the DataFrame shape
nrows, ncols = soil_type_df.shape
min_px = 0
max_px = ncols - 1
min_py = 0
max_py = nrows - 1
# Set NetLogo world size (patches)
netlogo.command(f"resize-world {min_px} {max_px} {min_py} {max_py}")
netlogo.command("clear-all")

try:
    print(" try patch_set in NetLogo")
    netlogo.patch_set("soil_type", soil_type_df)
    print("netlogo.patch_set(\"soil_type\", soil_type_df)")
except Exception as e:
    print("Error setting patch_set in NetLogo:", e)

print("patch_set finished")

# Set pcolor for each patch based on soil_type index, using NetLogo's 'ifelse' syntax
color_map = [16776958, 16776958, 15138816, 7577855, 14155790, 14155790, 11010048, 14146334, 9022054, 11141056, 11141056, 11141056, 10463938, 10463938, 11259078, 11259078, 13466662, 13466662, 13563354, 13563354, 13563354, 13466662, 13466662, 14869217, 16776960, 4471152, 4471152, 12487935, 12487935, 12487935]
color_map_str = "[" + " ".join(str(c) for c in color_map) + "]"
netlogo.command(f"let color_map {color_map_str} ask patches [ ifelse soil_type >= 0 and soil_type < length color_map [ set pcolor item soil_type color_map ] [ set pcolor gray ] ]")

print(" spawning farmers")
netlogo.command("spawn")