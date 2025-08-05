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

AREA_SIDE_LENGTH_METERS = 5000
TILE_SIDE_LENGTH_METERS = 100

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

window_size = AREA_SIDE_LENGTH_METERS  # 1000 meters

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
    "low natural levee": "#ABCD66",
    "fluvial terraces": "#A8A800",
    "coversands": "#FFFFBE",
    "high Pleistocene sands": "#D7C29E",
    "river dunes": "#FFFF00",
    "dunes and beach ridges": "#E6E600",
}

FLOOD_BASIN_TYPES = {
    "high floodplain": "#89CD66",
    "low floodplain": "#9ED7C2",
}

UNKNOWN_TYPES = {
    "post-Roman erosion": "#E1E1E1",
    "eutrophic peatlands": "#D79E9E",
    "mesotrophic peatlands": "#CD8966",
    "oligotrophic peatlands": "#CD6666",
}

# --- Build a single soil name to color dictionary ---
soil_names_to_colors = {}
soil_names_to_colors.update(WATER_TYPES)
soil_names_to_colors.update(LEVEE_TYPES)
soil_names_to_colors.update(FLOOD_BASIN_TYPES)
soil_names_to_colors.update(UNKNOWN_TYPES)

# 2. Build reference index for NetLogo (order: water, levee, flood basin, peatlands)
SOIL_TYPE_ORDER = list(soil_names_to_colors.keys())
SOIL_TYPE_COLORS = list(soil_names_to_colors.values())
SOIL_TYPE_TO_INDEX = {name: i for i, name in enumerate(SOIL_TYPE_ORDER)}

# --- NEW: Set of all valid soils and water types for filtering ---
ALL_VALID_SOILS = set(SOIL_TYPE_ORDER)
ALL_WATER_SOILS = set(WATER_TYPES.keys())

# --- Normalize soil types: strip " (uncertain)" suffix for all uses below ---
def normalize_soil_type(s):
    if isinstance(s, str) and s.endswith(" (uncertain)"):
        return s[:-len(" (uncertain)")]
    return s

while not found:
    x0 = random.uniform(minx, maxx - window_size)
    y0 = random.uniform(miny, maxy - window_size)
    x1 = x0 + window_size
    y1 = y0 + window_size

    window_poly = box(x0, y0, x1, y1)
    window_gdf = gdf[gdf.intersects(window_poly)].copy()

    # Extract soil types from the 'element' property
    if 'element' in window_gdf.columns:
        # Use normalized soil types for all logic
        window_gdf['element_norm'] = window_gdf['element'].map(normalize_soil_type)
        soil_types = window_gdf['element_norm'].dropna().unique()
        valid_soil_types = [s for s in soil_types if s in ALL_VALID_SOILS]
        river_types = ALL_WATER_SOILS
        window_gdf['area'] = window_gdf.geometry.area
        river_area = window_gdf[window_gdf['element_norm'].isin(river_types)]['area'].sum()
        total_area = window_gdf['area'].sum()
        river_fraction = river_area / total_area if total_area > 0 else 0
        has_water = any(s in river_types for s in soil_types)

        # Rasterization for cell-based area check
        shapes = []
        for _, row in window_gdf.iterrows():
            soil_norm = row.get("element_norm")
            idx = SOIL_TYPE_TO_INDEX.get(soil_norm)
            if idx is not None:
                shapes.append((row.geometry, idx))
        out_shape = (10, 10)
        transform = rasterio.transform.from_bounds(x0, y0, x1, y1, out_shape[1], out_shape[0])
        raster = rasterize(
            ((geom, int(val)) for geom, val in shapes),
            out_shape=out_shape,
            transform=transform,
            fill=0,
            dtype="uint8"
        )
        # Compute cell-based fractions
        unique, counts = np.unique(raster, return_counts=True)
        cell_fractions = {idx: count / raster.size for idx, count in zip(unique, counts)}
        present_soil_indexes = set(unique)
        
        # Calculate water fraction based on rasterized cells
        water_cell_count = 0
        for idx in present_soil_indexes:
            if idx < len(SOIL_TYPE_ORDER) and SOIL_TYPE_ORDER[idx] in river_types:
                water_cell_count += counts[list(unique).index(idx)]
        water_cell_fraction = water_cell_count / raster.size

        # --- Calculate levee fraction based on rasterized cells ---
        levee_types = set(LEVEE_TYPES.keys())
        levee_cell_count = 0
        for idx in present_soil_indexes:
            if idx < len(SOIL_TYPE_ORDER) and SOIL_TYPE_ORDER[idx] in levee_types:
                levee_cell_count += counts[list(unique).index(idx)]
        levee_cell_fraction = levee_cell_count / raster.size

        # --- Calculate flood-basin fraction based on rasterized cells ---
        flood_basin_types = set(FLOOD_BASIN_TYPES.keys())
        flood_basin_cell_count = 0
        for idx in present_soil_indexes:
            if idx < len(SOIL_TYPE_ORDER) and SOIL_TYPE_ORDER[idx] in flood_basin_types:
                flood_basin_cell_count += counts[list(unique).index(idx)]
        flood_basin_cell_fraction = flood_basin_cell_count / raster.size

        # Check: at least 3 valid soils, <50% water (rasterized), at least one water type, each present soil >=10%, >=30% levee, >=30% flood-basin
        enough_soils = len(present_soil_indexes) >= 3
        enough_water_rasterized = water_cell_fraction < 0.5 and water_cell_fraction > 0.2  # Use rasterized fraction instead of geometric
        #has_water_cell = any(SOIL_TYPE_ORDER[idx] in river_types for idx in present_soil_indexes if idx < len(SOIL_TYPE_ORDER))
        # all_above_10 = all(f >= 0.10 for idx, f in cell_fractions.items() if idx in present_soil_indexes)
        enough_levee = levee_cell_fraction >= 0.25
        enough_flood_basin = flood_basin_cell_fraction >= 0.25

        if (
            enough_soils and
            enough_water_rasterized and
            # has_water_cell and
            #all_above_10 and
            enough_levee and
            enough_flood_basin
        ):
            print(f"Found suitable window: {len(present_soil_indexes)} soil types, {water_cell_fraction:.1%} water cells, {levee_cell_fraction:.1%} levee cells, {flood_basin_cell_fraction:.1%} flood-basin cells")
            # Print all soil types present in the rasterized window
            present_soil_types = [SOIL_TYPE_ORDER[idx] for idx in sorted(present_soil_indexes)]
            print("Soil types present in rasterized window:", present_soil_types)
            found = True
    attempt += 1

if not found:
    raise RuntimeError("Could not find a window with at least 3 soil types after {} attempts.".format(max_attempts))

# Debug: print all unique layers present in the selected area (not just soil layers)
if 'element' in window_gdf.columns:
    present_layers = window_gdf['element'].dropna().unique()
    present_layers_norm = window_gdf['element_norm'].dropna().unique()
    print("All layers present in selected area:", present_layers)
    print("All normalized layers present in selected area:", present_layers_norm)

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
# Prepare shapes and values for rasterization (use normalized soil names)
shapes = []
values = []
for _, row in window_gdf.iterrows():
    soil_norm = row.get("element_norm")
    idx = SOIL_TYPE_TO_INDEX.get(soil_norm)
    if idx is not None:
        shapes.append((row.geometry, idx))
        values.append(idx)
    # else: skip unknown types

# Raster size and transform
amount_of_tiles_per_side = AREA_SIDE_LENGTH_METERS // TILE_SIDE_LENGTH_METERS
out_shape = (amount_of_tiles_per_side, amount_of_tiles_per_side)
transform = rasterio.transform.from_bounds(x0, y0, x1, y1, out_shape[1], out_shape[0])

# Rasterize to integer mask
raster = rasterize(
    ((geom, int(val)) for geom, val in shapes),
    out_shape=out_shape,
    transform=transform,
    fill=0,
    dtype="uint8"
)

# --- Soil group mapping ---
SOIL_GROUPS = [
    ("water", WATER_TYPES),
    ("levee", LEVEE_TYPES),
    ("flood-basin", FLOOD_BASIN_TYPES),
    ("unknown", UNKNOWN_TYPES),
]
SOIL_TYPE_TO_GROUP = {}
SOIL_TYPE_TO_GROUP_NAME = {}
for idx, (group_name, group_dict) in enumerate(SOIL_GROUPS):
    for soil_name in group_dict.keys():
        SOIL_TYPE_TO_GROUP[soil_name] = idx
        SOIL_TYPE_TO_GROUP_NAME[soil_name] = group_name

# Build patch attribute arrays for NetLogo
nrows, ncols = raster.shape
soil_type_idx_arr = np.zeros((nrows, ncols), dtype=int)
soil_type_name_arr = np.zeros((nrows, ncols), dtype='<U32')
soil_group_idx_arr = np.zeros((nrows, ncols), dtype=int)
soil_group_name_arr = np.zeros((nrows, ncols), dtype='<U32')
pcolor_arr = np.empty((nrows, ncols, 3), dtype=int)

# Create lookup tables for NetLogo
soil_group_names = ["water", "levee", "flood-basin", "unknown"]

for i in range(nrows):
    for j in range(ncols):
        idx = int(raster[i, j])
        soil_name = SOIL_TYPE_ORDER[idx]
        group_idx = SOIL_TYPE_TO_GROUP.get(soil_name, -1)
        group_name = SOIL_TYPE_TO_GROUP_NAME.get(soil_name, "unknown")
        hex_color = soil_names_to_colors[soil_name]
        r, g, b = hex_to_rgb(hex_color)
        soil_type_idx_arr[i, j] = idx
        soil_type_name_arr[i, j] = soil_name  # Use soil type index as name index
        soil_group_idx_arr[i, j] = group_idx
        soil_group_name_arr[i, j] = group_name
        pcolor_arr[i, j] = [r, g, b]

import pynetlogo
jvm_path = os.path.join(os.environ["JAVA_HOME"], "lib", "server", "libjvm.so")

netlogo = pynetlogo.NetLogoLink(
    gui=True,
    jvm_path=jvm_path,
)

netlogo.load_model('/home/juliusdb/Documents/repos/occultatum-assets/occultatum_farms.nlogo')

netlogo.command('setup')

# Ensure NetLogo world matches the DataFrame shape
min_px = 0
max_px = ncols - 1
min_py = 0
max_py = nrows - 1
netlogo.command(f"resize-world {min_px} {max_px} {min_py} {max_py}")
netlogo.command("clear-all")

# Set patch attributes from Python
print("Setting patch attributes in NetLogo...")

netlogo.patch_set("soil-type", pd.DataFrame(soil_type_idx_arr))
netlogo.patch_set("landscape-type", pd.DataFrame(soil_group_idx_arr))

for i in range(nrows):
    for j in range(ncols):
        pcolor_rgb = pcolor_arr[i, j]
        pxcor = j
        pycor = (nrows - 1) - i  # flip y-axis to match NetLogo's coordinate system
        netlogo.command(
            f"ask patch {pxcor} {pycor} [set pcolor rgb {pcolor_rgb[0]} {pcolor_rgb[1]} {pcolor_rgb[2]}]"
        )

        netlogo.command(
            f"ask patch {pxcor} {pycor} [set soil-type-name \"{soil_type_name_arr[i, j]}\" ]"
        )

        netlogo.command(
            f"ask patch {pxcor} {pycor} [set landscape-type-name \"{soil_group_name_arr[i, j]}\" ]"
        )

netlogo.command("spawn")