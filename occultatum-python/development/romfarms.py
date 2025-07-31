from components.occultatum.paleo.core import load_data, find_window, rasterize_window, get_all_soil_types, get_soil_color_map
import agentpy as ap
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
import polars as pl
import matplotlib.pyplot as plt
from components.occultatum.romfarms.landscape_categories import get_landscape_category
import random
import csv

# Load and process the data
(df, array, crs) = load_data("limes_paleogeography.json")
window_df, window_bounds, _ = find_window(df, array, crs)
print(window_df.head())
raster, rgb = rasterize_window(window_df, window_bounds, out_shape=(10, 10))

print("Raster" , raster)
print("RGB", rgb)

# Save RGB colors as hex strings to CSV (grid format)
def rgb_to_hex(rgb_tuple):
    return "#{:02x}{:02x}{:02x}".format(*rgb_tuple)

with open("soil_colors.csv", "w", newline="") as csvfile:
    writer = csv.writer(csvfile)
    for x in range(rgb.shape[0]):
        row = [rgb_to_hex(tuple(rgb[x, y])) for y in range(rgb.shape[1])]
        writer.writerow(row)


# Convert raster to Polars DataFrame
rows = []
for x in range(raster.shape[0]):
    for y in range(raster.shape[1]):
        rows.append({"x": x, "y": y, "value": raster[x, y]})
raster_df = pl.DataFrame(rows)

# Get soil types for color mapping
soil_types = get_all_soil_types()
print("Soil types:", soil_types)

class ForestModel(ap.Model):

    def setup(self):
        N_settlements = 10

        # Access parameters via self.p
        # self.p automatically contains all parameters passed to the model
        settlements = self.agents = ap.AgentList(self, N_settlements)

        # Create grid (forest)
        self.landscape = ap.Grid(self, raster.shape, track_empty=True)
        self.landscape.add_agents(settlements, random=True, empty=True)

        self.agents.specialization = 0

    def step(self):

        # Select generalist agents
        generalists = self.agents.select(self.agents.specialization == 0)

        for generalist in generalists:
            # Get the position of the agent
            pos = self.landscape.positions[generalist]
            radius = 2
            x = pos[0]
            y = pos[1]
            print("Agent position:", pos)

            neighbor_patches_soil_types = raster_df.filter(pl.col("x").is_between(x - radius, x + radius) & pl.col("y").is_between(x - radius, x + radius)).select(pl.col("value"))
            most_frequent_soil_type = neighbor_patches_soil_types.to_series().mode()[0]
            print(neighbor_patches_soil_types)

            most_frequent_soil_type_name = soil_types[most_frequent_soil_type]
            print("Most frequent soil type in neighborhood:", most_frequent_soil_type)
            print("most_frequent_soil_type_name", most_frequent_soil_type_name)
            # Update agent's specialization based on the most frequent soil type

            most_frequent_soil_type_common_name = get_landscape_category(most_frequent_soil_type_name)

            specialization = 'GENERALIST'

            if most_frequent_soil_type_common_name == "levees":
                specialization = random.choices(['ARABLE_FARMING', 'GENERALIST'], weights=[7, 3])[0]

                
                
            elif most_frequent_soil_type_common_name == "flood_basins":
                specialization = random.choices(['ANIMAL_HUSBANDRY', 'POTTERY', 'GENERALIST'], weights=[5, 2, 1])[0]
            elif most_frequent_soil_type_common_name == "other":
                specialization = random.choices(['ARABLE_FARMING', 'GENERALIST'], weights=[3, 7])[0]

            print('Specialization:', specialization)
            generalist.specialization = specialization

            marker = "s"

            if(specialization == 'ARABLE_FARMING'):
                marker = "o"
            elif(specialization == 'ANIMAL_HUSBANDRY'):
                marker = "X"
            elif(specialization == 'POTTERY'):
                marker = "D"

            plt.scatter(x, y, marker=marker, label=specialization)

    def end(self):
        mpl_color_map = get_soil_color_map()
        ap.gridplot(grid=raster, color_dict=mpl_color_map, convert=True)

model = ForestModel()
model.run(steps=1)
plt.savefig("output.png")  # Save the plot instead of showing it