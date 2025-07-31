"""
Map soil types to landscape categories for the Roman farming model.
Based on dissertation analysis of land use in the Dutch limes zone.
"""

# Landscape category mapping
SOIL_TO_LANDSCAPE = {
    # Levees - used primarily for settlement and arable farming
    "high natural levee": "levees",
    "high natural levee (Vecht)": "levees",
    "high natural levee (uncertain)": "levees",
    "moderately high natural levee": "levees",
    "moderately high natural levee (Vecht)": "levees",
    "moderately high natural levee (uncertain)": "levees",
    "low natural levee": "levees",
    "low natural levee (uncertain)": "levees",
    "river dunes": "levees",  # Used similarly to levees for habitation
    "dunes and beach ridges": "levees",  # Used for arable farming in coastal regions
    
    # Flood basins - used primarily for pasture and meadow (animal husbandry)
    "high floodplain": "flood_basins",
    "low floodplain": "flood_basins",
    "low floodplain (uncertain)": "flood_basins",
    "estuary": "flood_basins",
    "tidal flats": "flood_basins",
    "tidal flats (uncertain)": "flood_basins",
    
    # Other landscape elements with varying uses
    "coversands": "other",
    "coversands (uncertain)": "other",
    "fluvial terraces": "other",
    "high Pleistocene sands": "other",
    "eutrophic peatlands": "other",
    "eutrophic peatlands (uncertain)": "other",
    "mesotrophic peatlands": "other", 
    "mesotrophic peatlands (uncertain)": "other",
    "oligotrophic peatlands": "other",
    "oligotrophic peatlands (uncertain)": "other",
    "post-Roman erosion": "other",
    
    # Water bodies
    "rivers and streams": "water",
    "lakes": "water",
    "sea": "water",
}

# Secondary classifications based on specific uses
SOIL_LAND_USE = {
    # Primary arable lands
    "high natural levee": "arable_primary",
    "high natural levee (Vecht)": "arable_primary",
    "high natural levee (uncertain)": "arable_primary",
    "moderately high natural levee": "arable_primary",
    "moderately high natural levee (Vecht)": "arable_primary",
    "moderately high natural levee (uncertain)": "arable_primary",
    "dunes and beach ridges": "arable_primary",
    
    # Secondary arable lands
    "low natural levee": "arable_secondary",
    "low natural levee (uncertain)": "arable_secondary",
    "river dunes": "arable_secondary",
    "coversands": "arable_secondary",
    "coversands (uncertain)": "arable_secondary",
    "high Pleistocene sands": "arable_secondary",
    "fluvial terraces": "arable_secondary",
    
    # Primary pasture/meadow lands
    "high floodplain": "pasture_primary",
    "low floodplain": "pasture_primary",
    "low floodplain (uncertain)": "pasture_primary",
    "tidal flats": "pasture_primary",
    "tidal flats (uncertain)": "pasture_primary",
    
    # Secondary pasture/meadow lands
    "estuary": "pasture_secondary",
    
    # Woodland areas
    "eutrophic peatlands": "woodland",
    "eutrophic peatlands (uncertain)": "woodland",
    "mesotrophic peatlands": "woodland",
    "mesotrophic peatlands (uncertain)": "woodland",
    "oligotrophic peatlands": "woodland",
    "oligotrophic peatlands (uncertain)": "woodland",
    
    # Water bodies
    "rivers and streams": "water",
    "lakes": "water",
    "sea": "water",
    
    # Other
    "post-Roman erosion": "unusable",
}

def get_landscape_category(soil_type):
    """
    Map a soil type to its broader landscape category.
    
    Args:
        soil_type (str): The soil type to categorize
        
    Returns:
        str: The landscape category ("levees", "flood_basins", or "other")
    """
    return SOIL_TO_LANDSCAPE.get(soil_type, "other")

def get_land_use(soil_type):
    """
    Map a soil type to its primary land use.
    
    Args:
        soil_type (str): The soil type to categorize
        
    Returns:
        str: The land use category
    """
    return SOIL_LAND_USE.get(soil_type, "other")

# Table of soil types and their uses for reference
LAND_USE_TABLE = """
| Soil Type | Landscape Category | Primary Use | Secondary Use |
|-----------|-------------------|-------------|---------------|
| High natural levee | Levees | Settlement, Arable farming | - |
| Moderately high natural levee | Levees | Settlement, Arable farming | - |
| Low natural levee | Levees | Arable farming | Settlement |
| Dunes and beach ridges | Levees | Arable farming | Settlement |
| River dunes | Levees | Settlement | Arable farming |
| High floodplain | Flood basins | Pasture | Fodder production |
| Low floodplain | Flood basins | Pasture, Fodder production | - |
| Tidal flats | Flood basins | Grazing | - |
| Estuary | Flood basins | Grazing | - |
| Coversands | Other | (Limited) Arable farming | - |
| High Pleistocene sands | Other | (Limited) Arable farming | - |
| Fluvial terraces | Other | (Limited) Agricultural use | - |
| Eutrophic peatlands | Other | Woodland (firewood) | - |
| Mesotrophic peatlands | Other | Woodland | - |
| Oligotrophic peatlands | Other | Woodland | - |
"""
