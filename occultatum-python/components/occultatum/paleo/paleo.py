import geopandas as gdp
import polars as pl
import random
from shapely.geometry import box
import numpy as np
import rasterio
from rasterio.features import rasterize
import matplotlib.pyplot as plt
from matplotlib.patches import Patch
import imageio

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

RIVER_TYPES = {
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
    "rivers and streams": "#BEE8FF",
    "lakes": "#BEE8FF",
    "sea": "#BEE8FF",
}

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def rasterize_window(window_df, window_bounds, out_shape=(512, 512), out_image="window_raster.png", out_legend="window_raster_legend.png"):
    """
    Rasterizes the soil types in the window_df to an RGB PNG image and saves a legend.
    """
    x0, y0, x1, y1 = window_bounds
    shapes = []
    for row in window_df.iter_rows(named=True):
        soil = row["element"]
        color = SOIL_COLORS.get(soil)
        if not color and soil in {"rivers and streams", "streams", "stream", "water", "lake", "lakes", "sea"}:
            color = "#BEE8FF"
            SOIL_COLORS[soil] = color
        if color:
            shapes.append((row["geometry"], soil))
    soil_to_int = {soil: i+1 for i, soil in enumerate(SOIL_COLORS.keys())}
    int_to_rgb = {soil_to_int[soil]: hex_to_rgb(SOIL_COLORS[soil]) for soil in SOIL_COLORS}
    transform = rasterio.transform.from_bounds(x0, y0, x1, y1, out_shape[1], out_shape[0])
    raster = rasterize(
        ((geom, soil_to_int.get(val, 0)) for geom, val in shapes),
        out_shape=out_shape,
        transform=transform,
        fill=0,
        dtype="uint8"
    )
    rgb = np.zeros((out_shape[0], out_shape[1], 3), dtype=np.uint8)
    for val, color in int_to_rgb.items():
        mask = raster == val
        rgb[mask] = color
    imageio.imwrite(out_image, rgb)
    save_legend(out_legend, SOIL_COLORS)

def save_legend(filename, soil_colors):
    fig, ax = plt.subplots(figsize=(4, len(soil_colors) * 0.22 + 0.5))
    handles = []
    labels = []
    for soil, hex_color in soil_colors.items():
        handles.append(Patch(facecolor=hex_color, edgecolor='black'))
        labels.append(soil)
    ax.legend(handles, labels, loc='center left', frameon=True)
    ax.axis('off')
    plt.tight_layout()
    plt.savefig(filename, bbox_inches='tight', transparent=True, dpi=150)
    plt.close(fig)

def load_data(file_path):
    # loads landscape data from GeoJSON file

    # Load GeoJSON into GeoDataFrame using geopandas
    gdf = gdp.read_file(file_path)
    # Ensure CRS is EPSG:28992
    if gdf.crs is None or gdf.crs.to_epsg() == 4326:
        gdf = gdf.to_crs("EPSG:28992")
    # Extract relevant columns for Polars DataFrame
    df = pl.DataFrame({
        "element": gdf["element"].to_numpy(),
        "geometry": gdf["geometry"].to_numpy(),
        "area": gdf.geometry.area.to_numpy()
    })
    # Store bounds for later use
    bounds = gdf.total_bounds
    return df, bounds, gdf.crs


def find_window(df, bounds, crs, window_size=1000, min_soil_types=3, min_water=0.01, max_water=0.5, min_soil_fraction=0.10, max_attempts=1000):
    """
    Inputs: window size, minimum soil types, water percentage range
    Outputs: a window with at least X soil types and Y < water percentage < Z
    Iutputs: lat longitude info

    Finds a window with at least X soil types.
    The window must contain > Y < Z percentage of water
    The returned window also contains lattitute and longtitude info
    """
    minx, miny, maxx, maxy = bounds
    attempt = 0
    found = False
    gdf = gdp.GeoDataFrame({
        "element": df["element"].to_list(),
        "geometry": df["geometry"].to_list()
    }, geometry="geometry", crs=crs)
    while attempt < max_attempts and not found:
        x0 = random.uniform(minx, maxx - window_size)
        y0 = random.uniform(miny, maxy - window_size)
        x1 = x0 + window_size
        y1 = y0 + window_size
        window_poly = box(x0, y0, x1, y1)
        # Create a GeoSeries for the window polygon
        window_poly_gdf = gdp.GeoDataFrame({
            "geometry": [window_poly]
        }, geometry="geometry", crs=crs)
        # Find intersections
        mask = gdf.intersects(window_poly)
        window_gdf = gdf[mask]
        if "element" in window_gdf.columns and len(window_gdf) > 0:
            soil_types = window_gdf["element"].unique().tolist()
            valid_soil_types = [s for s in soil_types if s in VALID_SOILS]
            window_gdf["area"] = window_gdf.geometry.area
            river_area = window_gdf[window_gdf["element"].isin(list(RIVER_TYPES))]["area"].sum()
            total_area = window_gdf["area"].sum()
            river_fraction = river_area / total_area if total_area > 0 else 0
            has_water = any(s in RIVER_TYPES for s in soil_types)
            # Area fraction for each valid soil type
            soil_area_fractions = []
            for soil in set(valid_soil_types):
                soil_area = window_gdf[window_gdf["element"] == soil]["area"].sum()
                fraction = soil_area / total_area if total_area > 0 else 0
                soil_area_fractions.append(fraction)
            if (
                len(set(valid_soil_types)) >= min_soil_types and
                min_water <= river_fraction <= max_water and
                has_water and
                all(f >= min_soil_fraction for f in soil_area_fractions)
            ):
                found = True
                # Return as Polars DataFrame, plus window bounds and centroid in lat/lon
                window_df = pl.DataFrame({
                    "element": window_gdf["element"].to_numpy(),
                    "geometry": window_gdf["geometry"].to_numpy(),
                    "area": window_gdf["area"].to_numpy()
                })
                # Get centroid in WGS84
                window_poly_gdf = gdp.GeoDataFrame({
                    "geometry": [window_poly]
                }, geometry="geometry", crs=crs)
                window_poly_gdf = window_poly_gdf.to_crs("EPSG:4326")
                centroid_geom = window_poly_gdf["geometry"][0].centroid
                latlon = (centroid_geom.y, centroid_geom.x)
                return window_df, (x0, y0, x1, y1), latlon
        attempt += 1
    raise RuntimeError("Could not find a suitable window after {} attempts.".format(max_attempts))


def get_soil_types(window_df):
    """
    Returns a list of soil types in the DF as a map from soil type index to name
    """
    # Returns a dict mapping index to soil type name
    soil_types = window_df["element"].unique().to_list()
    return {i: soil for i, soil in enumerate(soil_types)}



if __name__ == "__main__":
    (df, array, crs) = load_data("limes_paleogeography.json")
    window_df, window_bounds, _ = find_window(df, array, crs)
    rasterize_window(window_df, window_bounds)
    print("Rasterized window saved as window_raster.png")
    print("Legend saved as window_raster_legend.png")
