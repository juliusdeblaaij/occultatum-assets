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

def hex_to_rgb(hex_color):
    """Convert hex color string to (r, g, b) tuple (0-255)."""
    hex_color = hex_color.lstrip("#")
    if len(hex_color) == 3:
        # Expand short form like "F00" -> "FF0000"
        hex_color = ''.join([c*2 for c in hex_color])
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_netlogo_approx_color(r, g, b):
    """
    Approximate NetLogo color number from RGB.
    NetLogo's approximate-rgb maps (r,g,b) in 0-255 to a color number.
    See: https://github.com/NetLogo/NetLogo/blob/6.4.0/netlogo-gui/src/main/agent/AgentColor.java
    """
    # NetLogo's base colors (see NetLogo User Manual)
    # We'll use the formula: color = 5 * (r/255) + 5 * (g/255) * 10 + 5 * (b/255) * 100
    # But NetLogo's color numbers are not a simple mapping, so we use the closest patch color
    # Instead, use NetLogo's rgb primitive: rgb r g b, but for patch color tables, use the int
    # For best compatibility, just use rgb(r, g, b) in NetLogo (see gis_test.nlogo)
    # Here, return a tuple for NetLogo's rgb primitive
    return (r, g, b)

# 1. Categorize soil types by landscape function (see dissertation, ch. 4.3.2)
WATER_TYPES = {
    "estuary": "#73DFFF",
    "tidal flats": "#448970",
    "tidal flats (uncertain)": "#448970",
    "rivers and streams": "#BEE8FF",
    "lakes": "#BEE8FF",
    "sea": "#BEE8FF",
}

LEVEE_TYPES = {
    "high natural levee": "#AAFF00",
    "high natural levee (Vecht)": "#AAFF00",
    "high natural levee (uncertain)": "#AAFF00",
    "moderately high natural levee": "#CDF57A",
    "moderately high natural levee (Vecht)": "#CDF57A",
    "moderately high natural levee (uncertain)": "#CDF57A",
    "low natural levee": "#ABCD66",
    "low natural levee (uncertain)": "#ABCD66",
    "fluvial terraces": "#A8A800",
    "coversands": "#FFFFBE",
    "coversands (uncertain)": "#FFFFBE",
    "high Pleistocene sands": "#D7C29E",
    "river dunes": "#FFFF00",
    "dunes and beach ridges": "#E6E600",
    "post-Roman erosion": "#E1E1E1",
}

FLOOD_BASIN_TYPES = {
    "high floodplain": "#89CD66",
    "low floodplain": "#9ED7C2",
    "low floodplain (uncertain)": "#9ED7C2",
}

PEATLANDS_TYPES = {
    "eutrophic peatlands": "#D79E9E",
    "eutrophic peatlands (uncertain)": "#D79E9E",
    "mesotrophic peatlands": "#CD8966",
    "mesotrophic peatlands (uncertain)": "#CD8966",
    "oligotrophic peatlands": "#CD6666",
    "oligotrophic peatlands (uncertain)": "#CD6666",
}

# --- Build a single soil name to color dictionary ---
soil_names_to_colors = {}
soil_names_to_colors.update(WATER_TYPES)
soil_names_to_colors.update(LEVEE_TYPES)
soil_names_to_colors.update(FLOOD_BASIN_TYPES)
soil_names_to_colors.update(PEATLANDS_TYPES)

# 2. Build reference index for NetLogo (order: water, levee, flood basin, peatlands)
SOIL_TYPE_ORDER = list(soil_names_to_colors.keys())
SOIL_TYPE_COLORS = list(soil_names_to_colors.values())
SOIL_TYPE_TO_INDEX = {name: i for i, name in enumerate(SOIL_TYPE_ORDER)}

# --- NEW: Set of all valid soils and water types for filtering ---
ALL_VALID_SOILS = set(SOIL_TYPE_ORDER)
ALL_WATER_SOILS = set(WATER_TYPES.keys())

while not found:
    x0 = random.uniform(minx, maxx - window_size)
    y0 = random.uniform(miny, maxy - window_size)
    x1 = x0 + window_size
    y1 = y0 + window_size

    window_poly = box(x0, y0, x1, y1)
    window_gdf = gdf[gdf.intersects(window_poly)].copy()

    # Extract soil types from the 'element' property
    if 'element' in window_gdf.columns:
        soil_types = window_gdf['element'].dropna().unique()
        # Use new soil type groups for filtering
        valid_soil_types = [s for s in soil_types if s in ALL_VALID_SOILS]
        # Area check for water types using new group
        river_types = ALL_WATER_SOILS
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
    # Blue for water types using new group
    if element in WATER_TYPES:
        return {'color': '#BEE8FF', 'weight': 2, 'fillColor': '#BEE8FF', 'fillOpacity': 0.7}
    # Use color mapping for other soils
    color = soil_names_to_colors.get(element, '#888888')
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
# Prepare shapes and values for rasterization
shapes = []
values = []
for _, row in window_gdf.iterrows():
    soil = row.get("element")
    idx = SOIL_TYPE_TO_INDEX.get(soil)
    if idx is not None:
        shapes.append((row.geometry, idx))
        values.append(idx)
    # else: skip unknown types

# Raster size and transform
out_shape = (10, 10)
transform = rasterio.transform.from_bounds(x0, y0, x1, y1, out_shape[1], out_shape[0])

# Rasterize to integer mask
raster = rasterize(
    ((geom, int(val)) for geom, val in shapes),
    out_shape=out_shape,
    transform=transform,
    fill=0,
    dtype="uint8"
)

# Build a DataFrame of soil type indices for NetLogo patch_set
soil_type_df = pd.DataFrame(raster)

print(soil_type_df)

# Print legend mapping present soil indexes to their soil names
present_soil_indexes = set(np.unique(raster))
legend = {idx: SOIL_TYPE_ORDER[idx] for idx in present_soil_indexes if idx < len(SOIL_TYPE_ORDER)}
print("Soil index legend for selected window:")
for idx, name in legend.items():
    print(f"  {idx}: {name}")

# Dynamically calculate NetLogo color (as rgb tuple) from hex for each soil type index
soil_index_to_netlogo_color = {}
for idx, soil_name in enumerate(SOIL_TYPE_ORDER):
    hex_color = soil_names_to_colors[soil_name]
    r, g, b = hex_to_rgb(hex_color)
    netlogo_color = rgb_to_netlogo_approx_color(r, g, b)
    soil_index_to_netlogo_color[idx] = netlogo_color


import pynetlogo
jvm_path = os.path.join(os.environ["JAVA_HOME"], "lib", "server", "libjvm.so")

netlogo = pynetlogo.NetLogoLink(
    gui=True,
    jvm_path=jvm_path,
)

netlogo.load_model('/home/juliusdb/Documents/repos/occultatum-assets/occultatum_farms.nlogo')

netlogo.command('setup')


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

# Populate NetLogo table: soil-colors-table
netlogo.command("set soil-colors-table table:make")
for idx, color_tuple in soil_index_to_netlogo_color.items():
    # NetLogo expects a color number or rgb list; use rgb list for full color
    netlogo.command(f"table:put soil-colors-table {idx} (list {color_tuple[0]} {color_tuple[1]} {color_tuple[2]})")

# Color patches using the table (calls NetLogo procedure)
netlogo.command("color-patches-from-table")

print(" spawning farmers")
netlogo.command("spawn")