;; This  model accompanies:
;; Joyce, J. 2019, Modelling agricultural strategies in the Dutch Roman limes zone via agent-based modelling (ROMFARMS). Springer (Cham)
;; Joyce, J. 2019, Farming along the limes. Using agent-based modelling to investigate possibilities for subsistence and surplus-based agricultural production in the Lower Rhine delta between 12BC and 270AD. PhD thesis, Vrije Universiteit Amsterdam.

;; This version programmed by Jamie Joyce, 2019
;; In-line documentation completed by Philip Verhagen, 2020

;; model initialization

extensions [ gis ]

;; three breeds are defined: settlements, persons and animals

breed [ settlements settlement ]

breed [ persons person ]

breed [ animals animal ]

;; declaration of a large number of global variables

globals [

  ;; section 1 - inputs fixed at start of simulation
  ;; 1a - inputs for running simulations in reconstructed landscapes
  raster ;; imported raster GIS file
  settlement-density ;; density of settlements per square km
  catchment-area ;; standard patch size for determining catchment radius

  ;; 1b - inputs for simulating arable farming
  calories-in-crops ;; calories / kg obtained from cereal crops
  fallow-time ;; fallow-time in years for arable farming
  basic-yield ;; annual cereal yield in kg / ha
  sowing-rate ;; annual amount of cereals needed for sowing in kg / ha
  yield-increase-manure ;; annual increase in cereal yield per kg / N in kg / ha
  N-content-manure;; nitrogen content of manure in kg / ton
  sowing-time ;; time in hours needed for sowing 1 ha of land
  ploughing-time ;; time in hours needed for ploughing 1 ha of land
  manuring-time ;; time in hours needed for manuring 1 ha of land
  harvesting-time ;; time in hours needed for harvesting 1 ha of land

  ;; 1c - inputs for simulating animal husbandry
  adult-weight-cattle ;; weight of adult cattle
  immature-weight-cattle ;; weight of immature cattle
  young-weight-cattle ;; weight of young cattle
  adult-weight-sheep ;; weight of adult sheep
  immature-weight-sheep ;; weight of immature sheep
  young-weight-sheep ;; weight of young sheep
  %-edible-carcass-cattle ;; % live weight of cattle available as meat
  %-edible-carcass-sheep ;; % live weight of sheep available as meat
  milk-yield-cattle ;; l of milk produced per head of cattle per day
  milk-yield-sheep ;; l of milk produced per sheep per day
  lactation-length-cattle ;; lactation length for cattle in days
  lactation-length-sheep ;; lactation length for sheep in days
  wool-yield-sheep ;; kg of wool produced per sheep per year
  manure-daily-yield ;; kg of manure produced per head of cattle per day
  twinning-rate-sheep ;; probability of adult sheep producing two offspring
  alphaS ;; age of senescence (sheep)
  alphaC ;; age of senescence (cattle)
  alphaH ;; age of senescence (horses)
  alpha ;; standard deviation age of senescence
  neonatal-mortality-sheep ;; mortality rate of neonatal sheep
  neonatal-mortality-cattle ;; mortality rate of neonatal cattle
  neonatal-mortality-horse ;; mortality rate of neonatal horses
  annual-mortality-rate ;; background annual mortality rate of animals
  CYMR ;; mortality rate of young cattle
  CIMR ;; mortality rate of immature cattle
  CAMR ;; mortality rate of adult cattle
  SYMR ;; mortality rate of young sheep
  SIMR ;; mortality rate of immature sheep
  SAMR ;; mortality rate of adult sheep
  HIMR ;; removal rate of immature horses
  fodder-sheep ;; fodder required by sheep (kg)
  fodder-cattle ;; fodder required by cattle (kg)
  fodder-horse ;; fodder required by horses (kg)
  fodder-collection-time ;; time needed to collect fodder (hrs/ha)
  pasture-land-sheep ;; pasture land required by sheep (ha)
  pasture-land-cattle ;; pasture land required by cattle (ha)
  pasture-land-horse ;; pasture land required by horses (ha)
  yield-grassland ;; yields of grassland in kg / ha

  ;; 1d - inputs for simulating wood collection
  walking-speed ;; walking speed in km / hr (not adapted to load)
  max-load-adult-male ;; maximum carrying load (kg) of adult male
  max-load-adult-female ;; maximum carrying load (kg) of adult female
  max-load-other ;; maximum carrying load (kg) of 'weak' workforce
  fuel-collection-time ;; fuel collection time in hours per person per patch
  timber-collection-time ;; timber collection time in hours per person per patch

  ;; section 2 - variables updated during simulation
  area ;; NOT USED!!

  ;; 2a - for simulation of human demography
  d-pop ;; total human population at end of year
  d1-pop ;; total human population at start of year
  pop-growth ;; population growth as the percentage increase or decrease from the previous year
  elderly-male-list ;; list of 'elderly males' > 50 years old
  elderly-female-list ;; list of 'elderly femals' > 50 years old
  adult-male-list ;; list of 'adult males' aged 16-50
  adult-female-list ;; list of 'adult females' aged 16-50
  male-4th-list ;; list of all males aged 10-16
  female-4th-list ;; list of all females aged 10-16
  male-3rd-list ;; list of all males aged 5-10
  female-3rd-list ;; list of all females aged 5-10
  male-2nd-list ;; list of all males aged 1-5
  female-2nd-list ;; list of all females aged 1-5
  male-1st-list ;; list of all males < 1 year old
  female-1st-list ;; list of all females < 1 year old
  count-children-list;; list of counts of all children

  ;; 2c - for simulation of arable farming
  ploughing-labour-list ;; list of total hours per workforce member needed for ploughing
  total-ploughing-labour-list ;; list of total amount of labour needed for ploughing (hrs)
  sowing-labour-list ;; list of total hours per workforce member needed for sowing
  total-sowing-labour-list ;; list of total amount of labour needed for sowing (hrs)
  manuring-labour-list ;; list of total hours per workforce member needed for manuring
  total-manuring-labour-list ;; list of total amount of labour needed for manuring (hrs)
  harvesting-labour-list ;; list of total hours per workforce member needed for harvesting
  total-harvesting-labour-list ;; list of total amount of labour needed for harvesting (hrs)
  min-arable-land-list ;; list of minimum amount of arable land needed (ha)
  arable-land-list ;; list of total amount of arable land used (ha)
  yield-list ;; list of total yield of grain (kg)
  surplus-list ;; list of total surplus of grain (kg)
  grain-deficit-list ;; list of total deficit of grain (kg)
  count-famines ;; total number of famines recorded in settlements during simulation

  ;; 2d - for simulation animal husbandry
  cattle-meat-list ;; list of total meat yield from cattle (kg)
  cattle-milk-list ;; list of total milk yield from cattle (l)
  cattle-manure-list ;; list of total manure yield from cattle (kg)
  sheep-meat-list ;; list of total meat yield from sheep (kg)
  sheep-milk-list ;; list of total milk yield from sheep (l)
  sheep-wool-list ;; list of total wool yield from sheep (kg)
  horse-surplus-list ;; list of total surplus horses
  meadow-land-list ;; list of total amount of land needed for meadows (ha)
  pasture-land-list ;; list of total amount of land needed for pasture (ha)
  total-fodder-labour-list ;; list of total amount of labour needed for fodder collection (hrs)
  fodder-labour-list ;; list of total hours per workforce member needed for fodder collection
  horse-pop-list ;; number of horses
  cattle-pop-list ;; heads of cattle
  sheep-pop-list ;; number of sheep
  d-pop-cattle ;; heads of cattle at end of year
  d1-pop-cattle ;; heads of cattle at start of year
  d-pop-horse ;; number of horses at end of year
  d1-pop-horse ;; number of horses at start of year
  d-pop-sheep ;; number of sheep at end of year
  d1-pop-sheep ;; number of sheep at start of year
  pop-growth-sheep ;; sheep herd population growth as the percentage increase or decrease from the previous year
  pop-growth-cattle ;; cattle herd population growth as the percentage increase or decrease from the previous year
  pop-growth-horse ;; horse herd population growth as the percentage increase or decrease from the previous year

  ;; 2e - for simulation of wood collection
  fuel-workforce-list ;; number of people in fuel workforce
  total-fuel-labour-list ;; hours spent on collecting fuel
  fuel-labour-list ;; hours spent on collecting fuel per person
  fuel-deficit-list ;; total fuel deficit
  distance-travelled-fuel-list ;; total distance travelled for fuel
  construction-labour-list ;; hours spent on collecting fuel
  construction-workforce-list ;; number of people in construction workforce
  timber-deficit-list ;; total timber deficit
  distance-travelled-construction-list ;; total distance travelled for timber
  biomass-list ;; total aviable biomass from forest / coppicing / alternative wood
  biomass-forest-list ;; total available biomass from forest / coppicing
]

;; the patches in the landscape have the following attributes

patches-own [
  ;; section 1 - attributed fixed at start of simulation
  raster-value ;; raster value obtained upon GIS import
  landscape-type ;; levee, floodbasin or NULL

  ;; section 2 - attributes updated every year during simulation
  patch-owner ;; each patch is 'owned' by a settlement
  use ;; current land use: arable farming, animal husbandry or woodland
  biomass ;; for woodland: the quantity of wood in kg / ha
  countdown-fallow ;; number of remaining fallow years for arable land
  countdown-reforest ;; number of remaining years before woodland is regrown
]

;; the settlements have the following attributes

settlements-own [
  no-households ;; maximum number of households in the settlement
  people ;; list of inhabitants in settlement

  ;; attributes related to arable farming
  catchment ;; list of patches used for arable farming and coppicing by the settlement
  calories-required ;; the annual amount of calories required for consumption by the settlement
  min-grain-store ;; the minimum grain store needed in kg
  ploughing-labour-1 ;; total hours needed for ploughing per settlement
  ploughing-labour-2 ;; hours needed for ploughing per person aged 16-50
  sowing-labour-1 ;; total hours needed for sowing per settlement
  sowing-labour-2 ;; hours needed for sowing per person aged > 10
  manuring-labour-1 ;; total hours needed for manuring per settlement
  manuring-labour-2 ;; hours needed for manuring per person aged 16-50
  harvesting-labour-1 ;; total hours needed for harvesting per settlement
  harvesting-labour-2 ;; hours needed for harvesting per person aged 16-50
  grain-store ;; grain store in kg per settlement
  max-arable-land-land ;; total area of arable land available to settlement
  max-arable-land-grain ;; maximum area of arable land settlement can sow with available grain
  max-arable-land-labour ;; maximum area of arable land “strong” workforce in settlement can harvest in two weeks in current step
  min-arable-land ;; minimum area of arable land needed to produced minimum amount of grain required by settlement
  arable-land ;; total area of arable land cultivated by settlement
  yield-grain ;; total yield of grain (kg) produced by settlement
  surplus-grain ;; total surplus grain (kg) produced by settlement
  grain-deficit ;; total quantity of grain (kg) still required but not produced by settement

  ;; attributes related to animal husbandry (cattle, sheep and horses)
  livestock ;; list of animals owned by settlement
  SNM ;; total number of own neonatal sheep slaughtered by settlement
  CNM ;; total number of own neonatal cattle slaughtered by settlement
  SYM ;; total number of own young sheep slaughtered by settlement
  CYM ;; total number of own young cattle slaughtered by settlement
  SIM ;; total number of own immature sheep slaughtered by settlement
  CIM ;; total number of own immature cattle slaughtered by settlement
  SAM ;; total number of own adult sheep slaughtered by settlement
  CAM ;; total number of own adult cattle slaughtered by settlement
  cattle-meat-yield ;; total amount of meat from slaughtered cattle (kg) produced by settlement
  sheep-meat-yield ;; total amount of meat from slaughtered sheep (kg) produced by settlement
  cattle-milk-yield ;; total amount of milk from cattle (l) produced by settlement
  sheep-milk-yield ;; total amount of milk from sheep (l) produced by settlement
  sheep-wool-yield ;; total amount of wool from sheep (kg) produced by settlement
  cattle-manure-yield ;; total amount of manure from cattle (kg) produced by settlement
  horse-surplus ;; total number of surplus immature horses bred by settlement
  pasture-land ;; total area of grazing land required by all livestock owned by settlement
  meadow-land ;; total area of grassland needed to produce winter fodder for livestock owned by settlement
  fodder-labour-1 ;; total hours needed for fodder production per settlement
  fodder-labour-2 ;; hours needed for fodder production per person aged 16-50

  ;; attributes related to wood collection (fuel and timber)
  fuel-workforce ;; list of settlement’s inhabitants in foraging group for fuel
  fuel-store ;; total quantity of fuel (kg) settlement possesses
  fuel-target ;; current patch foraging group of settlement is targeting for fuel collection
  fuel-requirement ;; total quantity of fuel (kg) that needs to be collected by foraging group in current trip
  fuel-labour-1 ;; total hours needed for fuel collection per settlement
  fuel-labour-2 ;; hours needed for fuel collection per person aged 16-50
  age ;; the age of the settlement, in order to know whether buildings need to be reconstructed
  construction-workforce ;; list of settlement’s inhabitants in foraging group for timbe
  construction-store ;; total quantity of timber (kg) settlement possesses
  construction-target ;; current patch foraging group is targeting for timber collection
  construction-requirement ;; total quantity of timber (kg) needed to rebuild buildings in settlement
  construction-labour ;; ;; total hours needed for timber collection per settlement
]

;; the persons have the following attributes

persons-own [
  ;; section 1 - attributes fixed at creation
  sex ;; male of female

  ;; section 2 - attributes updated during simulation
  age ;; age in years
  mortality ;; mortality depending on age
  fertility ;; fertility depending on age (females only)

  my-house ;; household of person
  my-spouse ;; partner of person (> 16 years old)
  count-children ;; number of children (females > 16 years old only)

  ;; parameters for wood collection
  distance-travelled-fuel ;; distance travelled for fuel
  distance-travelled-construction ;; distance travelled for construction wood
  max-load ;; maximum load depending on age
  load ;; actual load carried
  processing-time-fuel ;; processing time for fuel
  processing-time-timber ;; processing time for construction wood
]

;; the animals have the following attributes

animals-own [
  ;; section 1 - attributes fixed at creation
  sex ;; male of female
  species ;; sheep, cattle or horses

  ;; section 2 - attributes updated during simulation
  age ;; age in years
  fertility ;; fertility depending on age (females only)
  lactating ;; is the animal lactating or not? (females only)
  survivorship ;; probability that animal will die of natural causes in current step

  my-owner ;; settlement owning the animal

]

to setup
  ca
  setup-landscape
  setup-globals
  setup-agents
  reset-ticks
end

;; start of simulation; modules run in consecutive order: demography, arable farming, animal husbandry, fuel collection, construction

to go
  if ticks = runtime[
    stop
  ]
  if not any? settlements [
    stop
  ]
  go-demography
  go-arable
  go-pastoral
  go-fuel
  go-construction
  update-globals
  update-patches

  ;; if settlements have reached age where reconstruction is needed, reset to 0, otherwise add 1 year

  ask settlements [
    ifelse age = reconstruction-frequency [
      set age 0
    ]
    [
      set age age + 1
    ]
  ]
  tick
end

;; this sub-process generates landscape within which agents interact
;; various options are selected at setup by the user

to setup-landscape

  ;; landscapes can be randomly-generated ("hyp") or reconstructed from palaeogeographic data (1-32)

   if region = "hyp" [

    ;; all simulations are run in a 32 x 32 grid of 13 x 13 pixel patches

    resize-world -16 16 -16 16
    set-patch-size 13

    set settlement-density 0.02 ;; standard settlement density, can only be set in this line

    ;; area-levee and area-floodbasin are set by user in input box; N.B. there is no check whether the total is < 1, or whether the inputs are < 0 !
    ;; the procedure randomly selects a first select patch to be set to "levee"
    ;; until the number of patches matches the number set by the user, the levee patches will 'grow' by adding neighbouring patches
    ;; then, patches will be filled with "floodbasin", until this also matches the number set by the user
    ;; the remaining patches will be set to "other"
    ;; in practice, this means that the hypothetical landscapes will always have contiguous areas of levee and floodbasin,
    ;; and that small patches of levee will be surrounded by zones of floodbasin and "other"

    if area-levee > 0 [
      ask one-of patches [
        set pcolor brown
        set landscape-type "levee"
      ]
      while [ count patches with [ pcolor = brown ] < ( count patches * area-levee ) ] [
        ask one-of patches with [ pcolor = brown ] [
          if any? neighbors with [ pcolor != brown ] [ ;; if there are any 'free' neighbouring patches, set one of them to "levee"
            ask one-of neighbors with [ pcolor != brown ] [
              set pcolor brown
              set landscape-type "levee"
            ]
          ]
        ]
      ]
    ]
    if area-floodbasin > 0 [
      while [ count patches with [ pcolor = green ] < ( count patches * area-floodbasin ) and any? patches with [ pcolor = brown and any? neighbors with [ pcolor != brown and pcolor != green ] ] ] [
        ask one-of patches with [ pcolor = brown ] [ ;; first, check levee patches
          if any? neighbors with [ pcolor != brown and pcolor != green ] [
            ask one-of neighbors with [ pcolor != brown and pcolor != green ] [ ;; if there are any 'free' neighbouring patches, set one of them to "floodbasin"
              set pcolor green
              set landscape-type "floodbasin"
            ]
          ]
        ]
      ]

      while [ count patches with [ pcolor = green ] < ( count patches * area-floodbasin ) and count patches with [ pcolor = black ] > 0 ] [
        ask one-of patches with [ pcolor = green ] [ ;; then, check floodbasin patches as long as there are still empty patches; N.B. this generates an error at start when area-levee = 0
          if any? neighbors with [ pcolor != brown and pcolor != green ] [
            ask one-of neighbors with [ pcolor != green and pcolor != brown ] [ ;; if there are any 'free' neighbouring patches, set one of them to "floodbasin"
              set pcolor green
              set landscape-type "floodbasin"
            ]
          ]
        ]
      ]
    ]
    ask patches [
      set raster-value "null" ;; raster-value is set to "null", as it only has meaning for the reconstructed landscapes
    ]
  ]
  ask patches [
    set raster-value "null"
  ]

  ;; import GIS maps as ASCII grid files

  if region != "hyp" [ ;; if a reconstructed landscaped is simulated, this sub-process loads the relevant raster file and assigns a settlement density value depending on period to be simulated.
    gis:load-coordinate-system "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/UTM_zone31N.prj" ;; when a reconstructed landscape is loaded, the path names will need to be updated for .asc and .prj files

    ;; the regions are resized to 100 x 100 grids of 5 x 5 pixels; in Joyce (2019), they are 10 x 10 kms with 50 x 50 m grid cells

    resize-world -50 50 -50 50
    set-patch-size 5

    ;; the regions are imported as ASCII grid files, the list given here was used by Joyce (2019), but can be replaced by user-defined maps
    ;; for each region, the settlement density value is determined per archaeological period; again, these can be replaced if necessary

    if region = 1 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_1.asc"
      if period = "IJZ" [
        set settlement-density 0.0141
      ]
      if period = "ROMVA" [
        set settlement-density 0.0212
      ]
      if period = "ROMVB" [
        set settlement-density 0.0226
      ]
      if period = "ROMMA" [
        set settlement-density 0.0268
      ]
      if period = "ROMMB" [
        set settlement-density 0.0254
      ]
    ]
    if region = 2 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_2.asc"
      if period = "IJZ" [
        set settlement-density 0.0034
      ]
      if period = "ROMVA" [
        set settlement-density 0.0127
      ]
      if period = "ROMVB" [
        set settlement-density 0.0127
      ]
      if period = "ROMMA" [
        set settlement-density 0.0141
      ]
      if period = "ROMMB" [
        set settlement-density 0.0141
      ]
    ]
    if region = 3 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_3.asc"
      if period = "IJZ" [
        set settlement-density 0
      ]
      if period = "ROMVA" [
        set settlement-density 0
      ]
      if period = "ROMVB" [
        set settlement-density 0.0035
      ]
      if period = "ROMMA" [
        set settlement-density 0.0035
      ]
      if period = "ROMMB" [
        set settlement-density 0.0035
      ]
    ]
    if region = 4 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_4.asc"
      if period = "IJZ" [
        set settlement-density 0
      ]
      if period = "ROMVA" [
        set settlement-density 0
      ]
      if period = "ROMVB" [
        set settlement-density 0
      ]
      if period = "ROMMA" [
        set settlement-density 0
      ]
      if period = "ROMMB" [
        set settlement-density 0.003
      ]
    ]
    if region = 5 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_5.asc"
      if period = "IJZ" [
        set settlement-density 0.0075
      ]
      if period = "ROMVA" [
        set settlement-density 0.0114
      ]
      if period = "ROMVB" [
        set settlement-density 0.0122
      ]
      if period = "ROMMA" [
        set settlement-density 0.0114
      ]
      if period = "ROMMB" [
        set settlement-density 0.0107
      ]
    ]
    if region = 6 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_6.asc"
      if period = "IJZ" [
        set settlement-density 0.007
      ]
      if period = "ROMVA" [
        set settlement-density 0.0106
      ]
      if period = "ROMVB" [
        set settlement-density 0.0106
      ]
      if period = "ROMMA" [
        set settlement-density 0.013
      ]
      if period = "ROMMB" [
        set settlement-density 0.0127
      ]
    ]
    if region = 7 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_7.asc"
      if period = "IJZ" [
        set settlement-density 0.0083
      ]
      if period = "ROMVA" [
        set settlement-density 0.0147
      ]
      if period = "ROMVB" [
        set settlement-density 0.0147
      ]
      if period = "ROMMA" [
        set settlement-density 0.019
      ]
      if period = "ROMMB" [
        set settlement-density 0.019
      ]
    ]
    if region = 8 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_8.asc"
      if period = "IJZ" [
        set settlement-density 0.0016
      ]
      if period = "ROMVA" [
        set settlement-density 0.0063
      ]
      if period = "ROMVB" [
        set settlement-density 0.0067
      ]
      if period = "ROMMA" [
        set settlement-density 0.0129
      ]
      if period = "ROMMB" [
        set settlement-density 0.0129
      ]
    ]
    if region = 9 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_9.asc"
      if period = "IJZ" [
        set settlement-density 0.0059
      ]
      if period = "ROMVA" [
        set settlement-density 0.0148
      ]
      if period = "ROMVB" [
        set settlement-density 0.0148
      ]
      if period = "ROMMA" [
        set settlement-density 0.0207
      ]
      if period = "ROMMB" [
        set settlement-density 0.0207
      ]
    ]
    if region = 10 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_10.asc"
      if period = "IJZ" [
        set settlement-density 0.0041
      ]
      if period = "ROMVA" [
        set settlement-density 0.0068
      ]
      if period = "ROMVB" [
        set settlement-density 0.0068
      ]
      if period = "ROMMA" [
        set settlement-density 0.0084
      ]
      if period = "ROMMB" [
        set settlement-density 0.0084
      ]
    ]
    if region = 11 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_11.asc"
      if period = "IJZ" [
        set settlement-density 0.0064
      ]
      if period = "ROMVA" [
        set settlement-density 0.0142
      ]
      if period = "ROMVB" [
        set settlement-density 0.0144
      ]
      if period = "ROMMA" [
        set settlement-density 0.0187
      ]
      if period = "ROMMB" [
        set settlement-density 0.0187
      ]
    ]
    if region = 12 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_12.asc"
      if period = "IJZ" [
        set settlement-density 0.0046
      ]
      if period = "ROMVA" [
        set settlement-density 0.0082
      ]
      if period = "ROMVB" [
        set settlement-density 0.0082
      ]
      if period = "ROMMA" [
        set settlement-density 0.0115
      ]
      if period = "ROMMB" [
        set settlement-density 0.0115
      ]
    ]
    if region = 13 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_13.asc"
      if period = "IJZ" [
        set settlement-density 0.0038
      ]
      if period = "ROMVA" [
        set settlement-density 0.0064
      ]
      if period = "ROMVB" [
        set settlement-density 0.0066
      ]
      if period = "ROMMA" [
        set settlement-density 0.0064
      ]
      if period = "ROMMB" [
        set settlement-density 0.0062
      ]
    ]
    if region = 14 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_14.asc"
            if period = "IJZ" [
        set settlement-density 0.0057
      ]
      if period = "ROMVA" [
        set settlement-density 0.0068
      ]
      if period = "ROMVB" [
        set settlement-density 0.0068
      ]
      if period = "ROMMA" [
        set settlement-density 0.0075
      ]
      if period = "ROMMB" [
        set settlement-density 0.007
      ]
    ]
    if region = 15 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_15.asc"
      if period = "IJZ" [
        set settlement-density 0.0065
      ]
      if period = "ROMVA" [
        set settlement-density 0.0092
      ]
      if period = "ROMVB" [
        set settlement-density 0.0092
      ]
      if period = "ROMMA" [
        set settlement-density 0.0097
      ]
      if period = "ROMMB" [
        set settlement-density 0.0099
      ]
    ]
    if region = 16 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_16.asc"
      if period = "IJZ" [
        set settlement-density 0.0034
      ]
      if period = "ROMVA" [
        set settlement-density 0.0041
      ]
      if period = "ROMVB" [
        set settlement-density 0.0043
      ]
      if period = "ROMMA" [
        set settlement-density 0.0041
      ]
      if period = "ROMMB" [
        set settlement-density 0.0041
      ]
    ]
    if region = 17 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_17.asc"
      if period = "IJZ" [
        set settlement-density 0.0026
      ]
      if period = "ROMVA" [
        set settlement-density 0.0031
      ]
      if period = "ROMVB" [
        set settlement-density 0.0031
      ]
      if period = "ROMMA" [
        set settlement-density 0.0034
      ]
      if period = "ROMMB" [
        set settlement-density 0.0034
      ]
    ]
    if region = 18 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_18.asc"
      if period = "IJZ" [
        set settlement-density 0.0044
      ]
      if period = "ROMVA" [
        set settlement-density 0.0208
      ]
      if period = "ROMVB" [
        set settlement-density 0.0295
      ]
      if period = "ROMMA" [
        set settlement-density 0.0438
      ]
      if period = "ROMMB" [
        set settlement-density 0.0416
      ]
    ]
    if region = 19 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_19.asc"
      if period = "IJZ" [
        set settlement-density 0.0047
      ]
      if period = "ROMVA" [
        set settlement-density 0.0117
      ]
      if period = "ROMVB" [
        set settlement-density 0.0117
      ]
      if period = "ROMMA" [
        set settlement-density 0.0152
      ]
      if period = "ROMMB" [
        set settlement-density 0.0187
      ]
    ]
    if region = 20 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_20.asc"
      if period = "IJZ" [
        set settlement-density 0.0037
      ]
      if period = "ROMVA" [
        set settlement-density 0.0064
      ]
      if period = "ROMVB" [
        set settlement-density 0.0092
      ]
      if period = "ROMMA" [
        set settlement-density 0.0147
      ]
      if period = "ROMMB" [
        set settlement-density 0.0175
      ]
    ]
    if region = 21 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_21.asc"
      if period = "IJZ" [
        set settlement-density 0.0085
      ]
      if period = "ROMVA" [
        set settlement-density 0.0318
      ]
      if period = "ROMVB" [
        set settlement-density 0.0318
      ]
      if period = "ROMMA" [
        set settlement-density 0.0425
      ]
      if period = "ROMMB" [
        set settlement-density 0.0361
      ]
    ]
    if region = 22 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_22.asc"
      if period = "IJZ" [
        set settlement-density 0
      ]
      if period = "ROMVA" [
        set settlement-density 0.0031
      ]
      if period = "ROMVB" [
        set settlement-density 0.0031
      ]
      if period = "ROMMA" [
        set settlement-density 0.0031
      ]
      if period = "ROMMB" [
        set settlement-density 0.0031
      ]
    ]
    if region = 23 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_23.asc"
      if period = "IJZ" [
        set settlement-density 0.0048
      ]
      if period = "ROMVA" [
        set settlement-density 0.0061
      ]
      if period = "ROMVB" [
        set settlement-density 0.0061
      ]
      if period = "ROMMA" [
        set settlement-density 0.0145
      ]
      if period = "ROMMB" [
        set settlement-density 0.0145
      ]
    ]
    if region = 24 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_24.asc"
      if period = "IJZ" [
        set settlement-density 0
      ]
      if period = "ROMVA" [
        set settlement-density 0
      ]
      if period = "ROMVB" [
        set settlement-density 0
      ]
      if period = "ROMMA" [
        set settlement-density 0.0063
      ]
      if period = "ROMMB" [
        set settlement-density 0.0063
      ]
    ]
    if region = 25 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_25.asc"
      if period = "IJZ" [
        set settlement-density 0
      ]
      if period = "ROMVA" [
        set settlement-density 0.0047
      ]
      if period = "ROMVB" [
        set settlement-density 0.0047
      ]
      if period = "ROMMA" [
        set settlement-density 0.0047
      ]
      if period = "ROMMB" [
        set settlement-density 0.0047
      ]
    ]
    if region = 26 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_26.asc"
      if period = "IJZ" [
        set settlement-density 0.0019
      ]
      if period = "ROMVA" [
        set settlement-density 0.0033
      ]
      if period = "ROMVB" [
        set settlement-density 0.0033
      ]
      if period = "ROMMA" [
        set settlement-density 0.009
      ]
      if period = "ROMMB" [
        set settlement-density 0.0095
      ]
    ]
    if region = 27 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_27.asc"
      if period = "IJZ" [
        set settlement-density 0.0047
      ]
      if period = "ROMVA" [
        set settlement-density 0.0093
      ]
      if period = "ROMVB" [
        set settlement-density 0.0093
      ]
      if period = "ROMMA" [
        set settlement-density 0.0114
      ]
      if period = "ROMMB" [
        set settlement-density 0.0114
      ]
    ]
    if region = 28 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_28.asc"
      if period = "IJZ" [
        set settlement-density 0.0017
      ]
      if period = "ROMVA" [
        set settlement-density 0.0067
      ]
      if period = "ROMVB" [
        set settlement-density 0.0071
      ]
      if period = "ROMMA" [
        set settlement-density 0.0067
      ]
      if period = "ROMMB" [
        set settlement-density 0.0067
      ]
    ]
    if region = 29 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_29.asc"
      if period = "IJZ" [
        set settlement-density 0.0083
      ]
      if period = "ROMVA" [
        set settlement-density 0.01
      ]
      if period = "ROMVB" [
        set settlement-density 0.0102
      ]
      if period = "ROMMA" [
        set settlement-density 0.0105
      ]
      if period = "ROMMB" [
        set settlement-density 0.01
      ]
    ]
    if region = 30 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_30.asc"
      if period = "IJZ" [
        set settlement-density 0.0095
      ]
      if period = "ROMVA" [
        set settlement-density 0.0102
      ]
      if period = "ROMVB" [
        set settlement-density 0.0102
      ]
      if period = "ROMMA" [
        set settlement-density 0.01
      ]
      if period = "ROMMB" [
        set settlement-density 0.01
      ]
    ]
    if region = 31 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_31.asc"
      if period = "IJZ" [
        set settlement-density 0.0165
      ]
      if period = "ROMVA" [
        set settlement-density 0.0225
      ]
      if period = "ROMVB" [
        set settlement-density 0.024
      ]
      if period = "ROMMA" [
        set settlement-density 0.0262
      ]
      if period = "ROMMB" [
        set settlement-density 0.0255
      ]
    ]
    if region = 32 [
      set raster gis:load-dataset "C:/Users/jamaa/Documents/USB 10072017/Palaeogeography/clip_32.asc"
      if period = "IJZ" [
        set settlement-density 0.0162
      ]
      if period = "ROMVA" [
        set settlement-density 0.0324
      ]
      if period = "ROMVB" [
        set settlement-density 0.0324
      ]
      if period = "ROMMA" [
        set settlement-density 0.0306
      ]
      if period = "ROMMB" [
        set settlement-density 0.0288
      ]
    ]
    gis:set-world-envelope-ds gis:envelope-of raster
    gis:apply-raster raster raster-value
  ]

  ;; raster-values are taken from imported maps, these are specific for the study by Joyce (2019) and can be replaced by other values for other cases

  ask patches [
    if raster-value = 1 or raster-value = 4 or raster-value = 7 or raster-value = 9 [ ;; ROMFARMS sets different colours for different reconstructed landscape elements but only assigns values to levees and floodbasins.
      set landscape-type "levee"
      set pcolor brown
    ]
    if raster-value = 11 or raster-value = 12 [
      set pcolor green
      set landscape-type "floodbasin"
    ]
    if raster-value = 24 or raster-value = 0 or raster-value = 33 [
      set pcolor blue
    ]
    if raster-value = 14 or raster-value = 15 or raster-value = 17  [
      set pcolor 12
    ]
    if raster-value = 25 or raster-value = 28 or raster-value = 21  [
      set pcolor 125
    ]
    if raster-value = 20 or raster-value = 32 or raster-value = 31 [
      set pcolor 47
    ]
    set patch-owner nobody
    set use "none"
  ]

  ;; last action: determine the forest cover

  setup-forest
end

to setup-globals ;; assigns values to the numerous variables used in ROMFARMS and sets the initial values for list variables.

  ;; step 1 - determine number of people per sex and age category in settlements
  ask settlements [
    set elderly-male-list lput count people with [ sex = "male" and age >= 50 ] elderly-male-list
    set elderly-female-list lput count people with [ sex = "female" and age >= 50 ] elderly-female-list
    set adult-male-list lput count people with [ sex = "male" and age >= 16 and age < 50 ] adult-male-list
    set adult-female-list lput count people with [ sex = "female" and age >= 16 and age < 50 ] adult-female-list
    set male-4th-list lput count people with [ sex = "male" and age >= 10 and age < 16 ] male-4th-list
    set female-4th-list lput count people with [ sex = "female" and age >= 10 and age < 16 ] female-4th-list
    set male-3rd-list lput count people with [ sex = "male" and age >= 5 and age < 10 ] male-3rd-list
    set female-3rd-list lput count people with [ sex = "female" and age >= 5 and age < 10 ] female-3rd-list
    set male-2nd-list lput count people with [ sex = "male" and age >= 1 and age < 5 ] male-2nd-list
    set female-2nd-list lput count people with [ sex = "female" and age >= 1 and age < 5 ] female-2nd-list
    set male-1st-list lput count people with [ sex = "male" and age < 1 ] male-1st-list
    set female-1st-list lput count people with [ sex = "female" and age < 1 ] female-1st-list
  ]

  ;; step 2 - inputs fixed at start of simulation
  ;; all these values are derived from literature, but can be adapted if so desired (see Joyce 2019:230-231 for references)

  ;; 2a - arable farming
  set calories-in-crops 3100 ;; kCal/kg
  set basic-yield 1000 ;; kg/ha
  set sowing-rate 200 ;; kg/ha
  set yield-increase-manure 15 ;; kg per 1kg N
  set N-content-manure 0.006 ;; 6kg per ton manure
  set sowing-time 3 ;;hrs/ha
  set ploughing-time 30 ;; hrs/ha
  set manuring-time 30 ;; hrs/ha
  set harvesting-time 24 ;; hrs/ha

  ;; 2b - animal husbandry
  set adult-weight-cattle 200 ;; kg per head
  set immature-weight-cattle 150 ;; kg per head
  set young-weight-cattle 35 ;; kg per head
  set adult-weight-sheep 25 ;; kg per head
  set immature-weight-sheep 18.75 ;; kg per head
  set young-weight-sheep 10 ;; kg per head
  set %-edible-carcass-cattle 0.6 ;; % of live weight
  set %-edible-carcass-sheep 0.3 ;; % of live weight
  set milk-yield-cattle 1.2 ;; litres per day
  set milk-yield-sheep 0.2 ;; litres per day
  set lactation-length-cattle 200 ;; days
  set lactation-length-sheep 135 ;; days
  set wool-yield-sheep 2 ;; kg per head
  set manure-daily-yield 0.06 ;; % of live weight per days
  set twinning-rate-sheep 0.2 ;; % probability of adult sheep producing two offspring
  set alphaS 7.5 ;; maximum age sheep - standard deviation
  set alphaC 17.5 ;; maximum age cattle - standard deviation
  set alphaH 27.5 ;; maximum age horse - standard deviation
  set alpha 2.5 ;; standard deviation (see above)
  set neonatal-mortality-sheep 0.32 ;; % probability of neonatal sheep dying from natural causes
  set neonatal-mortality-cattle 0.2 ;; % probability of neonatal cattle dying from natural causes
  set neonatal-mortality-horse 0.2 ;; % probability of neonatal horse dying from natural causes
  set annual-mortality-rate 0.014 ;; % probability of all animals to die per year
  set fodder-sheep 252 ;; kg/adult head for four months
  set fodder-cattle 756 ;; kg/adult head for four months
  set fodder-horse 756 ;; kg/adult head for four months
  set fodder-collection-time 16 ;; hrs/ha
  set pasture-land-sheep 9 ;; no. heads/ha
  set pasture-land-cattle 3 ;; no. heads/ha
  set pasture-land-horse 3 ;; no.heads/ha
  set yield-grassland 3000 ;; kg/ha

  ;; 2c - wood collection
  set walking-speed 5 ;; km/hr
  set max-load-adult-male 30 ;; kg of firewood
  set max-load-adult-female 20 ;; kg of firewood
  set max-load-other 15 ;; kg of firewood
  set fuel-collection-time 3 ;; hrs/trip
  set timber-collection-time 6 ;; hrs/trip
  set biomass-forest-list [ ] ;; count total biomass of forest
  ask patches with [ use = "forest" or use = "coppice" ] [
    set biomass-forest-list lput biomass biomass-forest-list
  ]
  set biomass-list [ ] ;; count total biomass of forest and fens
  ask patches with [ use = "forest" or use = "coppice" or use = "alt-wood" ] [
    set biomass-list lput biomass biomass-list
  ]
  set catchment-area 1
end

;; this sub-process generates settlement agents and places them randomly in the landscape on a levee patch
;; the number of agents generated depends on the values for the relevant interface parameters: 1-, 2-, 3- or 5-household settlements
;; settlements will only appear on levee patches where no landuse is allocated yet, and where no neighbours are found
;; symbol sizes depend on number of households
;; settlements will be given people and livestock

to setup-agents
  set-default-shape settlements "house"
  while [ count settlements with [ no-households = 1 ] < no-1-household-settlements and any? patches with [ landscape-type = "levee" and use = "none" and count turtles-on neighbors = 0 ] ] [
    ask one-of patches with [ landscape-type = "levee" and use = "none" and count turtles-on neighbors = 0 ] [
      sprout 1 [
        set breed settlements
        set age 0
        set no-households 1
        set size 1
        set color white
        set people turtle-set [ ]
        set livestock turtle-set [ ]
        ]
      ]
    ]
  while [ count settlements with [ no-households = 2 ] < no-2-household-settlements and any? patches with [ landscape-type = "levee" and use = "none" and count turtles-on neighbors = 0 ] ] [
    ask one-of patches with [ landscape-type = "levee" and use = "none" and count turtles-on neighbors = 0 ] [
      sprout 1 [
        set breed settlements
        set age 0
        set no-households 2
        set size 1.25
        set color white
        set people turtle-set [ ]
        set livestock turtle-set [ ]
      ]
    ]
  ]
  while [ count settlements with [ no-households = 3 ] < no-3-household-settlements and any? patches with [ landscape-type = "levee" and use = "none" and count turtles-on neighbors = 0 ] ] [
    ask one-of patches with [ landscape-type = "levee" and use = "none" and count turtles-on neighbors = 0 ] [
      sprout 1 [
        set breed settlements
        set age 0
        set no-households 3
        set size 1.5
        set color white
        set people turtle-set [ ]
        set livestock turtle-set [ ]
      ]
    ]
  ]
  while [ count settlements with [ no-households = 5 ] < no-5-household-settlements and any? patches with [ landscape-type = "levee" and use = "none" and count turtles-on neighbors = 0 ] ] [
    ask one-of patches with [ landscape-type = "levee" and use = "none" and count turtles-on neighbors = 0 ] [
      sprout 1 [
        set breed settlements
        set age 0
        set no-households 5
        set size 1.75
        set color white
        set people turtle-set [ ]
        set livestock turtle-set [ ]
      ]
    ]
  ]

 ;; each household will have one couple with four children aged 0-15 years
 ;; age is set to 16, is this a mistake?

  ask settlements [
    repeat no-households [
      hatch 1 [ ;; produces one male adult per household and sets initial variables
        ht
        set breed persons
        set sex "male"
        set my-spouse nobody
        set age 16
        set distance-travelled-fuel 0
        set distance-travelled-construction 0
        set my-house myself
        ask my-house [
          set people ( turtle-set people myself )
        ]
      ]
      hatch 1 [
        ht ;; produces one female adult per household and sets initial variables
        set breed persons
        set sex "female"
        set my-spouse nobody
        set age 16
        set distance-travelled-fuel 0
        set distance-travelled-construction 0
        set count-children 0
        set my-house myself
        ask my-house [
          set people ( turtle-set people myself )
        ]
        set my-spouse one-of other persons with [ sex = "male" and age >= 16 and age < 50 and my-spouse = nobody and my-house = [ my-house ] of myself ] ;; sets spouse as one of other adults with opposite sex in the same settlement
        ask my-spouse [
          set my-spouse myself
        ]
      ]
      repeat 4 [
        hatch 1 [ ;; produces four sub-adults per household, ages set randomly between 0 and 15
          ht
          set breed persons
          set sex one-of ( list "male" "female" )
          set age 0 + random 15
          set distance-travelled-fuel 0
          set distance-travelled-construction 0
          set my-spouse nobody
          set my-house myself
          ask my-house [
            set people ( turtle-set people myself )
          ]
        ]
      ]
    ]

    ;; the remaining attributes of the settlements are set in a separate procedure

    config-settlements
  ]
end

;; procedure for demography; determine number of deaths and births, and update counts of population

to go-demography
  ;; first empty all existing lists
  set elderly-male-list [ ]
  set elderly-female-list [ ]
  set adult-male-list [ ]
  set adult-female-list [ ]
  set male-4th-list [ ]
  set female-4th-list [ ]
  set male-3rd-list [ ]
  set female-3rd-list [ ]
  set male-2nd-list [ ]
  set female-2nd-list [ ]
  set male-1st-list [ ]
  set female-1st-list [ ]
  set count-children-list [ ]

  set d1-pop d-pop ;; set current population to last year's population
  update-settlements-1 ;; run update of calorie requirements etc. on all settlements; N.B. in procedure it is said this should be run AFTER births, deaths and marriages
  births ;; determine number of births
  deaths ;; determine number of deaths
  marriages ;; determine number of marriage

  ;; count all population groups
  ask settlements [
    set elderly-male-list lput count people with [ sex = "male" and age >= 50 ] elderly-male-list
    set elderly-female-list lput count people with [ sex = "female" and age >= 50 ] elderly-female-list
    set adult-male-list lput count people with [ sex = "male" and age >= 16 and age < 50 ] adult-male-list
    set adult-female-list lput count people with [ sex = "female" and age >= 16 and age < 50 ] adult-female-list
    set male-4th-list lput count people with [ sex = "male" and age >= 10 and age < 16 ] male-4th-list
    set female-4th-list lput count people with [ sex = "female" and age >= 10 and age < 16 ] female-4th-list
    set male-3rd-list lput count people with [ sex = "male" and age >= 5 and age < 10 ] male-3rd-list
    set female-3rd-list lput count people with [ sex = "female" and age >= 5 and age < 10 ] female-3rd-list
    set male-2nd-list lput count people with [ sex = "male" and age >= 1 and age < 5 ] male-2nd-list
    set female-2nd-list lput count people with [ sex = "female" and age >= 1 and age < 5 ] female-2nd-list
    set male-1st-list lput count people with [ sex = "male" and age < 1 ] male-1st-list
    set female-1st-list lput count people with [ sex = "female" and age < 1 ] female-1st-list
  ]
  ask persons [
    set age age + 1 ;; increases the age of all surviving inhabitants by one year
  ]
  update-settlements-2  ;; check if settlements still have adults, if not, they are abandoned
end

to go-arable
  ;; first empty all existing lists
  set arable-land-list [ ]
  set min-arable-land-list []
  set yield-list [ ]
  set surplus-list [ ]
  set grain-deficit-list [ ]
  set sowing-labour-list [ ]
  set total-sowing-labour-list [ ]
  set ploughing-labour-list [ ]
  set total-ploughing-labour-list [ ]
  set manuring-labour-list [ ]
  set total-manuring-labour-list [ ]
  set harvesting-labour-list [ ]
  set total-harvesting-labour-list [ ]

  ;; set fallow time (2 years or 0) - this could be set at initialization, since this is input by the user
  ifelse strategy-arable = "none" or strategy-arable = "extensification" [
    set fallow-time 2
  ]
  [
    set fallow-time 0
  ]
  ;; calculate land, yield and surplus for settlements
  calculate-land-arable
  calculate-yield-arable
  calculate-surplus-arable
end

to go-pastoral
  ;; increase age of animals by 1 year
  ask animals [
    set age age + 1
  ]
  ;; set population to last year's population
  set d1-pop-horse d-pop-horse
  set d1-pop-cattle d-pop-cattle
  set d1-pop-sheep d-pop-sheep
  ;; empty all existing lists
  set sheep-pop-list [ ]
  set cattle-pop-list [ ]
  set horse-pop-list [ ]
  set sheep-meat-list [ ]
  set cattle-meat-list [ ]
  set sheep-milk-list [ ]
  set cattle-milk-list [ ]
  set sheep-wool-list [ ]
  set cattle-manure-list [ ]
  set horse-surplus-list [ ]
  set meadow-land-list [ ]
  set pasture-land-list [ ]
  set total-fodder-labour-list [ ]
  set fodder-labour-list [ ]
  ;; run procedures for livestock demography and slaughter
  set-mortality-rates
  births-animals
  natural-mortality
  slaughter
end

to go-fuel
  ask persons [ ;; assigns the value for the maximum carrying load per person depending on age.
    if age >= 10 and age < 16 [
      set max-load max-load-other
    ]
    if age >= 16 and age < 50 and sex = "male" [
      set max-load max-load-adult-male
    ]
    if age >= 16 and age < 50 and sex = "female" [
      set max-load max-load-adult-female
    ]
    if age >= 50 [
      set max-load max-load-other
    ]
  ]
  ;; empty all existing lists
  set fuel-workforce-list [ ]
  set total-fuel-labour-list [ ]
  set fuel-labour-list [ ]
  set fuel-deficit-list [ ]
  set distance-travelled-fuel-list [ ]
  ask persons [
    set processing-time-fuel 0
    set distance-travelled-fuel 0
  ]
  ;; run procedure for fuel collection
  calc-workforce-fuel
end

to go-construction
  ;; empty all existing lists
  set construction-labour-list [ ]
  set construction-workforce-list []
  set timber-deficit-list [ ]
  set distance-travelled-construction-list [ ]
  ask persons [
    set processing-time-timber 0
    set distance-travelled-construction 0
  ]
  ;; run procedure for construction wood collection
  calc-workforce-construction
end

to update-globals
  set d-pop count persons
  set d-pop-horse count animals with [ species = "horse" ]
  set d-pop-sheep count animals with [ species = "sheep" ]
  set d-pop-cattle count animals with [ species = "cattle" ]
  if ticks > 1 [ ;; calculates herd population growth as the percentage increase or decrease from the previous year
    set pop-growth ( d-pop - d1-pop ) / d1-pop
    if sheep? = TRUE [
      set pop-growth-sheep ( d-pop-sheep - d1-pop-sheep ) / d1-pop-sheep
    ]
    if cattle? = TRUE [
      set pop-growth-cattle ( ( d-pop-cattle - d1-pop-cattle ) / d1-pop-cattle )
    ]
    if horse? = TRUE [
      set pop-growth-horse ( d-pop-horse - d1-pop-horse ) / d1-pop-horse
    ]
  ]
  ask settlements [ ;; updates the values for the various labour expenditures and yields of grain and animal products.
    set arable-land-list lput arable-land arable-land-list
    set yield-list lput yield-grain yield-list
    set surplus-list lput surplus-grain surplus-list
    set grain-deficit-list lput grain-deficit grain-deficit-list
    set total-sowing-labour-list lput sowing-labour-1 total-sowing-labour-list
    set sowing-labour-list lput sowing-labour-2 sowing-labour-list
    set total-ploughing-labour-list lput ploughing-labour-1 total-ploughing-labour-list
    set ploughing-labour-list lput ploughing-labour-2 ploughing-labour-list
    if strategy-arable = "intensification" [
      set total-manuring-labour-list lput manuring-labour-1 total-manuring-labour-list
      set manuring-labour-list lput manuring-labour-2 manuring-labour-list
    ]
    set total-harvesting-labour-list lput harvesting-labour-1 total-harvesting-labour-list
    set harvesting-labour-list lput harvesting-labour-2 harvesting-labour-list
    set sheep-pop-list lput count livestock with [ species = "sheep" ] sheep-pop-list
    set cattle-pop-list lput count livestock with [ species = "cattle" ] cattle-pop-list
    set horse-pop-list lput count livestock with [ species = "horse" ] horse-pop-list
    set sheep-meat-list lput sheep-meat-yield sheep-meat-list
    set cattle-meat-list lput cattle-meat-yield cattle-meat-list
    set sheep-milk-list lput sheep-milk-yield sheep-milk-list
    set cattle-milk-list lput cattle-milk-yield cattle-milk-list
    set sheep-wool-list lput sheep-wool-yield sheep-wool-list
    set cattle-manure-list lput cattle-manure-yield cattle-manure-list
    set horse-surplus-list lput horse-surplus horse-surplus-list
    set meadow-land-list lput meadow-land meadow-land-list
    set pasture-land-list lput pasture-land pasture-land-list
    set total-fodder-labour-list lput fodder-labour-1 total-fodder-labour-list
    set fodder-labour-list lput fodder-labour-2 fodder-labour-list
    set total-fuel-labour-list lput fuel-labour-1 total-fuel-labour-list
    set fuel-labour-list lput fuel-labour-2 fuel-labour-list
    set construction-labour-list lput construction-labour construction-labour-list
    if fuel-requirement > fuel-store [
      set fuel-deficit-list lput ( fuel-requirement - fuel-store ) fuel-deficit-list
    ]
    if construction-requirement > construction-store and age = reconstruction-frequency [
      set timber-deficit-list lput ( construction-requirement - construction-store ) timber-deficit-list
    ]
  ]
  ask persons with [ distance-travelled-fuel > 0 ] [
    set distance-travelled-fuel-list lput distance-travelled-fuel distance-travelled-fuel-list
  ]
  ask persons with [ sex = "female" and age >= 16 ] [
    set count-children-list lput count-children count-children-list
  ]
  set biomass-list [ ]
  set biomass-forest-list [ ]
  ask patches with [ use = "forest" or use = "coppice" or use = "alt-wood" ] [
    set biomass-list lput biomass biomass-list
    if use = "forest" or use = "coppice" [
      set biomass-forest-list lput biomass biomass-forest-list
    ]
  ]
end

;; procedure to update biomass of forest / fenland

to update-patches
  ask patches with [ countdown-reforest > 0 ] [ ;; time to regeneration of deforested patches reduced by 1 and if it reaches 0, patches regenerate
    set countdown-reforest countdown-reforest - 1
    if countdown-reforest = 0 [
      if landscape-type = "levee" and use = "forest" [
        set biomass ( 100 + random 20 ) * 439
      ]
      if landscape-type = "floodbasin" and use = "forest" [
        set biomass ( 110 + random 30 ) * 439
      ]
      if landscape-type = "fen" [
        set biomass ( 65 + random 20 ) * 439
      ]
      if use = "coppice" [
        set biomass ( 180 + random 40 ) * 439
      ]
    ]
  ]
  ask patches with [ landscape-type = "levee" and countdown-fallow > 0 ] [ ;; time for patches to be reused as arable land reduced by 1 and restores arable land to available to use when this value reaches 0.
    set countdown-fallow countdown-fallow - 1
    if countdown-fallow = 0 [
      set pcolor brown
    ]
  ]
  ask patches with [ biomass > 0 ] [
    set pcolor scale-color green biomass 100000 1000
  ]
end

to births
  set-fertility ;; call to set-fertility is needed to update fertility every year
  ask persons with [ my-spouse != nobody and sex = "female" and age >= 16 and age < 50 ] [
    if random-float 1.0 < fertility [
      ;; generates a random value lfrom 0 to 1. If the number is less than the fertility rate assigned to each married woman between 16 and 49 one child is generated. The sex of the child is assigned randomly.
      hatch 1 [
        set breed persons
        set age 0
        set sex one-of ( list "male" "female" )
        set my-house [ my-house ] of myself
        set my-spouse nobody
        set distance-travelled-fuel 0
        set distance-travelled-construction 0
      ]
      set count-children count-children + 1
    ]
  ]
end

to deaths
  set-mortality ;; call to set-mortality is needed to update mortality every year
  ask persons [
    if random-float 1.0 < mortality [ ;; generates a random value from 0 to 1. If the number is less than the mortality rate assigned to each person, the person dies and is removed from the simulation.
      die
    ]
  ]
end

to marriages
  ask persons with [ sex = "male" and age >= 16 and age < 50 and my-spouse = nobody ] [
    ;; if a male aged 16 to 49 is unmarried, they will seek a new spouse. If no unmarried females between 16 and 49 are available, the sub-process ends.
    if any? other persons with [ sex = "female" and age >= 16 and age < 50 and my-spouse = nobody and my-house != [ my-house ] of myself ] [
      ifelse [ count people with [ my-spouse != nobody ] ] of my-house < ( [ no-households ] of my-house * 2 ) [
        ;; if there is space for the new couple, the couple move to the male spouse's settlement. If not, the new couple moves to the female spouse's settlement.
        set my-spouse one-of other persons with [ sex = "female" and age >= 16 and age < 50 and my-spouse = nobody and my-house != [ my-house ] of myself ]
        ask my-spouse [
          set my-spouse myself
          set my-house [ my-house ] of myself
        ]
      ]
      [
        set my-spouse one-of other persons with [ sex = "female" and age >= 16 and age < 50 and my-spouse = nobody and my-house != [ my-house ] of myself ]
        ask my-spouse [
          set my-spouse myself
        ]
        new-settlement ;; if no space in either of the new spouse's original settlements, the sub-process for creation of a new settlement is called.
      ]
    ]
  ]
end

to update-settlements-1 ;; updates the value for the calories required for the new population of each settlement once births, marriages and deaths have taken place.
  ask settlements [
    ;; first, calculate required kgs of grain for last year; if grain store is more, then subtract this from grain store -> this is the grain consumed in the previous year
    ;; remaining grain store is passed on to the current year
    ;; else, calculate grain deficit, and set grain store to 0
    ifelse grain-store >= ( ( calories-required * %-calories-from-crops ) / calories-in-crops ) [
      set grain-store grain-store - ( ( calories-required * %-calories-from-crops ) / calories-in-crops )
    ]
    [
      set grain-deficit  ( ( ( calories-required * %-calories-from-crops ) / calories-in-crops ) - grain-store )
      set grain-store 0
    ]
    ;; recalculate the calories required by inhabitants of settlement for this year
    set calories-required ( count people with [ age >= 16 and age < 50 and sex = "male" ] * 3250 * 365 + count people with [ age >= 16 and age < 50 and sex = "male" ] * 550 * 6 * 7 )
    set calories-required calories-required + ( count people with [ age > 50 and sex = "male" ] * 2650 * 365 )
    set calories-required calories-required + ( count people with [ age >= 16 and age < 50 and sex = "female" ] * 2800 * 365 + count people with [ age >= 16 and age < 50 and sex = "female" ] * 400 * 6 * 7 )
    set calories-required calories-required + ( count people with [ age >= 50 and sex = "female" ] * 2450 * 365 )
    set calories-required calories-required + ( count people with [ age < 1 ] * 675 * 365 )
    set calories-required calories-required + ( count people with [ age >= 1 and age < 5 ] * 1360 * 365 )
    set calories-required calories-required + ( count people with [ age >= 5 and age < 10 ] * 2010 * 365 )
    set calories-required calories-required + ( count people with [ age >= 10 and age < 16 and sex = "male" ] * 2750 * 365 )
    set calories-required calories-required + ( count people with [ age >= 10 and age < 16 and sex = "female" ] * 2420 * 365 )

    ;; calculate minimum amount of grain to be stored this year; store-size is set by user; 3110 should be calories-in-crops!
    set min-grain-store ( ( calories-required * %-calories-from-crops ) / 3110 ) * store-size

    set fuel-requirement count people * 365 * daily-per-capita-fuel-use
    set fuel-store 0
  ]
end

to update-settlements-2
  ask settlements [
    ;; checks whether a settlement contains a least one adult or if a settlement is devoid of any inhabitants.
    ;; If so, the settlement is removed and any remaining dependents sent to the nearest settlement.
    ;; Any coppiced plot managed by the removed settlement reverts to unmanaged woodland and livestock owned by the removed settlement are removed also.
    set people ( turtle-set persons with [ my-house = myself ] )
    if count people = 0 [
      ask livestock [
        die
      ]
      if any? catchment with [ use = "coppice" and patch-owner = myself ] [
        ask catchment with [ use = "coppice" and patch-owner = myself ] [
          set use "forest"
        ]
      ]
      ask catchment with [ patch-owner = myself ] [
        set patch-owner nobody
      ]
      die
    ]
    if count people with [ age >= 16 and age < 50 ] = 0 [
      if any? catchment with [ use = "coppice" and patch-owner = myself ] [
        ask catchment with [ use = "coppice" and patch-owner = myself ] [
          set use "forest"
        ]
      ]
      ask catchment with [ patch-owner = myself ] [
        set patch-owner nobody
      ]
      ifelse any? other settlements with [ self != myself ] [
        let a one-of other settlements with [ self != myself ]
        ask people [
          set my-house a
        ]
        ask livestock [
          die
        ]
        die
      ]
      [
        ask people [
          die
        ]
        ask livestock [
          die
        ]
        die
      ]
    ]
    set people ( turtle-set persons with [ my-house = myself ] )
    set livestock ( turtle-set animals with [ my-owner = myself ] )
  ]

end

to calculate-land-arable
  ask settlements [
    set arable-land 0
    set min-arable-land ( ( min-grain-store / basic-yield ) + ( ( ( min-grain-store / basic-yield ) * sowing-rate ) / basic-yield ) )
    ;; first calculates the minimum area that each settlement must cultivate to produce sufficient food, sowing seed and a buffer
    set min-arable-land-list lput min-arable-land min-arable-land-list
    set max-arable-land-land count catchment with [ use != "coppice" and countdown-fallow = 0 and landscape-type = "levee" ]
    ;; calculates the maximum area of land that can be cultivated as restricted by land availability; countdown-fallow must be 0
    if max-arable-land-land < 0 [
      set max-arable-land-land 0
    ]
    set max-arable-land-labour count people with [ age >= 16 and age < 50 ] * 3.2 ;; calculates the maximum area of land that can be cultivated with available strong workforce (Joyce 2019:36 states 3.5)
    if max-arable-land-labour < 0 [
      set max-arable-land-labour 0
    ]
    set max-arable-land-grain ( grain-store / sowing-rate ) ;; calculates the maximum area of land that can be cultivated with available sowing seed in grainstore
    if max-arable-land-grain < 0 [
      set max-arable-land-grain 0
    ]
    let max-arable-land min ( list max-arable-land-land max-arable-land-labour max-arable-land-grain ) ;; sets the maximum area of land as the lower of the three areas calculated above
    ifelse min-arable-land <= max-arable-land [
      set arable-land min-arable-land ;; sets the area of land to be cultivated as the minimum area of land or the maximum area of land, whichever is lower
      if strategy-arable = "extensification" and surplus-grain > 0 [
        ;; if settlements undertake extensification as per interface parameter, the extra area of land that can be cultivated with available land, labour or sowing seed is calculated
        let d max-arable-land-land - arable-land
        let f max-arable-land-labour - arable-land
        let g ( surplus-grain / sowing-rate ) ;; surplus grain from last year, g is the amount of land that could be sown with this
        let extra-land min ( list d f g )
        set surplus-grain surplus-grain - ( extra-land * sowing-rate ) ;; the grain necessary for sowing the extra-land is subtracted from the surplus grain
        set arable-land arable-land + extra-land ;; increases the area of land to be cultivated by the area of extra land that can be cultivated when settlements practice extensification
        ;; possible scenarios therefore: arable land limited by available land, available workforce or available sowing seed
      ]
    ]
    [
      set arable-land max-arable-land ;; if min-arable-land is larger than max-arable-land, all available land is taken, possibly leading to grain deficits in this year
    ]
    if arable-land < 0 [ ;; no arable land is needed if the grain store is large enough to feed everyone?
      set arable-land 0
    ]
    set surplus-grain 0
    set grain-store grain-store - ( arable-land * sowing-rate ) ;; reduces grain store by the quantity needed to sow the area of land to be cultivated
    if count catchment with [ landscape-type = "levee" and use != "forest" and use != "coppice" and countdown-fallow = 0 ] >= arable-land [
      ;; updates the nearest patches of arable land to the settlement to reflect its use in the current year and resets the fallowing countdown
      ;; set to arable land those available patches that are closest to the settlement
      ask min-n-of arable-land catchment with [ landscape-type = "levee" and  use != "forest" and use != "coppice" and countdown-fallow = 0 ] [ distance myself ] [
        set use "arable"
        set pcolor brown + 2
        set countdown-fallow fallow-time
      ]
    ]
    if count catchment with [ landscape-type = "levee" and  use != "forest" and use != "coppice" and countdown-fallow = 0 ] < arable-land [
      ;; if any potential arable land contains woodland but is required for arable farming, the woodland is removed and the fuel store of the settlements in increased accordingly.
      let x count catchment with [ landscape-type = "levee" and use != "forest" and use != "coppice" and countdown-fallow = 0 ]
      let y arable-land - x
      ask min-n-of x catchment with [ landscape-type = "levee" and use != "forest" and use != "coppice" and countdown-fallow = 0 ] [ distance myself ] [
        set use "arable"
        set pcolor brown + 2
        set countdown-fallow fallow-time
      ]
    ask min-n-of y catchment with [ landscape-type = "levee" and use != "coppice" ] [ distance myself ] [
      set use "arable"
      set pcolor brown + 2
      set biomass 0
      ask myself [
        set fuel-store fuel-store + [ biomass ] of myself
      ]
    ]
  ]
  if strategy-arable = "intensification" [ ;; calculates the labour expenditure for manuring (when settlements undertake intensification only), ploughing, sowing and harvesting.
    set manuring-labour-1 ( arable-land * manuring-time )
    set manuring-labour-2 ( arable-land * manuring-time ) / ( count people with [ age >= 16 and age < 50 ] )
    ]
  set ploughing-labour-1 ( arable-land *  ploughing-time )
  set ploughing-labour-2 ( arable-land * ploughing-time ) / ( count people with [ age >= 16 and age < 50 ] )
  set sowing-labour-1 ( arable-land * sowing-time )
  set sowing-labour-2 ( arable-land * sowing-time ) / ( count people with [ age >= 10 ] )
  set harvesting-labour-1 ( arable-land * harvesting-time )
  set harvesting-labour-2 ( arable-land * harvesting-time ) / ( count people with [ age >= 16 and age < 50 ] )
  ]
end

;; this procedure calculates grain yields from arable land per settlement

to calculate-yield-arable
  let factor ( -0.2 + random-float 0.4 ) ;; random yield fluctuation +/- 20%
  ask settlements [
    set yield-grain ( arable-land * ( basic-yield * ( 1 + factor ) ) )
    ;; calculates the yield of grain as the area of land cultivated multiplied by the basic yield and increased/decreased randomly within the range +/- 20%.
    if strategy-arable = "intensification" [
      ifelse cattle-manure-yield >= ( arable-land * 10000 ) [
        ;; calculates the extra yield of grain as a result of incorporating manure into the soil. The amount of nitrogen added depends on the amount of manure which comes from cattle herds
        ;; N.B. this calculates extra yield on the basis of the value yield-increase-manure, which is then again increased/decreased randomly within the range +/- 20%
        ;; if the total amount of manure collected is more than 10000 kg per hectare, then it will achieve maximum effect
        ;; otherwise, the yield increase is proportional to the amount of manure collected
        let a ( arable-land * ( 10000 * N-content-manure * yield-increase-manure ) * ( 1 + factor ) )
        set yield-grain yield-grain + a
      ]
      [
        let b ( cattle-manure-yield / arable-land )
        let c ( arable-land * ( b * N-content-manure * yield-increase-manure ) * ( 1 + factor ) )
        set yield-grain yield-grain + c
      ]
    ]
    ;; transfer grain yield to grain store
    set grain-store yield-grain
  ]
end

;; this procedure calculates surplus grain per settlement

to calculate-surplus-arable
  ask settlements [
    if grain-store > min-grain-store [
      set surplus-grain ( grain-store - min-grain-store ) ;; reduces the grain yield by the amount required by the inhabitants for consumption, buffer and sowing seed
      set surplus-grain surplus-grain * ( 1 - surplus-takeoff ) ;; surplus-takeoff is set by user
    ]
    while [ any? other settlements with [ surplus-grain > 0 ] and grain-store < ( ( calories-required * %-calories-from-crops ) / calories-in-crops ) ] [
      ;; if settlements produce too little grain, grain can be taken from other settlement(s) with surplus grain. The surplus grain of the other settlement(s) is reduced accordingly.
      let a one-of other settlements with [ surplus-grain > 0 ]
      ifelse [ surplus-grain ] of a >= ( ( calories-required * %-calories-from-crops ) / calories-in-crops ) - grain-store [
         ask a [
           set surplus-grain surplus-grain - ( [ min-grain-store - grain-store ] of myself )
         ]
         set grain-store min-grain-store
      ]
      [
        set grain-store grain-store + [ surplus-grain ] of a
        ask a [
          set surplus-grain 0
        ]
      ]
    ]
    if grain-store < ( ( calories-required * %-calories-from-crops ) / calories-in-crops ) [ ;; if settlements can not produce or borrow enough grain, a famine is recorded.
      set grain-deficit ( ( calories-required * %-calories-from-crops ) / calories-in-crops ) - grain-store
      set count-famines count-famines + 1 ;; N.B. this does not influence mortality patterns!
    ]
  ]
end

;; procedure that sets the mortality (slaughter / removal) rates of each animal depending on age range, species and exploitations strategy; see Joyce (2019:37)

to set-mortality-rates
  if sheep-strategy = "milk" [
    set SYMR 0.44 ;; mortality rate of young sheep
    set SIMR 0.01 ;; mortality rate of immature sheep
    set SAMR 0.01 ;; mortality rate of adult sheep
  ]
  if sheep-strategy = "meat" [
    set SYMR 0.01
    set SIMR 0.45
    set SAMR 0.01
  ]
  if sheep-strategy = "wool" [
    set SYMR 0.1
    set SIMR 0.2
    set SAMR 0.1
  ]
  if cattle-strategy = "milk" [
    set CYMR 0.5 ;; mortality rate of young cattle
    set CIMR 0.01 ;; mortality rate of immature cattle
    set CAMR 0.08 ;; mortality rate of adult cattle
  ]
  if cattle-strategy = "meat" [
    set CYMR 0.01
    set CIMR 0.45
    set CAMR 0.01
  ]
  if cattle-strategy = "manure" [
    set CYMR 0.2
    set CIMR 0
    set CAMR 0.2
  ]
  set HIMR 0.55 ;; removal rate of surplus immature horses
end

;; procedure to determine number of animals born

to births-animals
  ;; lactating animals will not produce offspring
  ask animals [
    set lactating "N"
  ]
  ask animals with [ species = "sheep" and age >= 2 ] [
    if random-float 1.0 < fertility [
      ;; for each adult sheep a random number between 0 and 1 is generated. If this is less than the fertility rate of female sheep, the sheep will reproduce. The sex is assigned randomly.
      ifelse random-float 1.0 < twinning-rate-sheep [
        ;; for each adult sheep that will reproduce, a random number is generated. If this number is less than the probability that than twinning rate of sheep, two offspring are produced.
        ;; Otherwise one offspring is produced.
        hatch 2 [
          create-link-with myself
          set breed animals
          set species "sheep"
          set age 0
          set sex one-of ( list "male" "female" )
          set survivorship random-float 1.0
          set fertility 0.8
          set my-owner [ my-owner ] of myself
        ]
        set lactating "Y"
      ]
      [
        hatch 1 [
          create-link-with myself
          set breed animals
          set species "sheep"
          set age 0
          set sex one-of ( list "male" "female" )
          set survivorship random-float 1.0
          set fertility 0.8
          set my-owner [ my-owner ] of myself
        ]
        set lactating "Y"
      ]
    ]
  ]
  ask animals with [ species = "cattle" and age >= 3 ] [
    if random-float 1.0 < fertility [
      ;; for each adult cattle a random number between 0 and 1 is generated. If this is less than the fertility rate of female cattle, the cow will reproduce. Sex is assigned randomly.
      hatch 1 [
        create-link-with myself
        set breed animals
        set species "cattle"
        set age 0
        set sex one-of ( list "male" "female" )
        set survivorship random-float 1.0
        set fertility 0.7
        set my-owner [ my-owner ] of myself
      ]
      set lactating "Y"
    ]
  ]
  ask animals with [ species = "horse" and age >= 3 and sex = "female" ] [
    ;; for each adult horse a random number between 0 and 1 is generated. If this is less than the fertility rate of female horses, the horse will reproduce. Sex is assigned randomly.
    if random-float 1.0 < fertility [
      hatch 1 [
        set breed animals
        set species "horse"
        set age 0
        set sex one-of ( list "male" "female" )
        set survivorship random-float 1.0
        set fertility 0.6
        set my-owner [ my-owner ] of myself
      ]
    ]
  ]
  ;; update list of animals in settlement
  ask settlements [
    set livestock ( turtle-set animals with [ my-owner = myself ] )
  ]
end

;; procedure that determines what animals will die of natural causes (see Joyce 2019:38)

to natural-mortality
  ask animals with [ species = "sheep" and age < 1 ] [
    ;; for each animal, if a random number between 0 and 1 is less than the mortality rate, the animal dies. These commands mimic deaths due to natural mortality
    ;; neonatal mortality
    if random-float 1.0 < 0.32 [
      die
    ]
  ]
  ask animals with [ species = "cattle" and age < 1 ] [
    if random-float 1.0 < 0.2 [
      die
    ]
  ]
  ask animals with [ species = "horse" and age < 1 ] [
    if random-float 1.0 < 0.2 [
      die
    ]
  ]
  ;; mortality of older animals N.B. this is omitting the age condition, so would also effect the neonatal animals?
  ask animals with [ species = "sheep" ] [
    let survivorship2 exp ( ( - annual-mortality-rate * floor age ) - exp ( - alphaS / alpha ) * ( exp ( floor age / alpha ) - 1 ) )
    if survivorship > survivorship2 [
      die
    ]
  ]
  ask animals with [ species = "cattle" ] [
    let survivorship2 exp ( ( - annual-mortality-rate * floor age ) - exp ( - alphaC / alpha ) * ( exp ( floor age / alpha ) - 1 ) )
    if survivorship > survivorship2 [
      die
    ]
  ]
  ask animals with [ species = "horse" ] [
    let survivorship2 exp ( ( - annual-mortality-rate * floor age ) - exp ( - alphaH / alpha ) * ( exp ( floor age / alpha ) - 1 ) )
    if survivorship > survivorship2 [
      die
    ]
  ]
end

;; procedure determining yields from animal husbandry

to slaughter
  ask settlements [
    ;; empty all existing lists
    set cattle-meat-yield 0
    set sheep-meat-yield 0
    set cattle-milk-yield 0
    set sheep-milk-yield 0
    set sheep-wool-yield 0
    set cattle-manure-yield 0
    set horse-surplus 0
    set pasture-land 0
    set meadow-land 0
    set fodder-labour-1 0
    set fodder-labour-2 0
    set SNM 0
    set CNM 0
    set SYM 0
    set CYM 0
    set SIM 0
    set CIM 0
    set SAM 0
    set CAM 0
    ;; for each animal, a random number is generate between 0 and 1. If the mortality rate is more than the randomly-generated number, the animal dies (or for horse is removed).
    ;; In this sub-process the deaths of animals are recorded to calculated meat yields and surplus horses available each year.
    ;; animals are slaughtered in an order determined by their age. First male neonatal animals are slaughtered, followed by young animals, then immature animals and finally adult animals.
    ask livestock with [ species = "sheep" and sex = "male" ] [
      ask my-owner [
        set SNM SNM + 1
      ]
      die
    ]
    ask livestock with [ species = "cattle" and sex = "male" ] [
      ask my-owner [
        set CNM CNM + 1
      ]
      die
    ]
    ask livestock with [ species = "sheep" and age < 1 ] [
      if random-float 1.0 < SYMR [
        ask my-owner [
          set SYM SYM + 1
        ]
        die
      ]
    ]
    ask livestock with [ species = "cattle" and age < 1 ] [
      if random-float 1.0 < CYMR [
        ask my-owner [
          set CYM CYM + 1
        ]
        die
      ]
    ]
    ;; immature horses are not slaughtered, but removed (horse-surplus can be traded or paid as tax)
    ask livestock with [ species = "horse" and age >= 1 and age < 3 ] [
      if random-float 1.0 < HIMR [
        ask my-owner [
          set horse-surplus horse-surplus + 1
        ]
        die
      ]
    ]
    let a ( count livestock with [ species = "sheep" and age >= 2 ] / pasture-land-sheep )
    ;; pasture land required per settlement for animal herds is calculated (see Joyce 2019:40)
    ;; N.B. pasture not linked to patches
    let b ( ( count livestock with [ species = "sheep" and age >= 1 and age < 2 ] * 0.8 ) / pasture-land-sheep )
    let c ( ( count livestock with [ species = "sheep" and age < 1 ] * 0.15 ) / pasture-land-sheep )
    let SLR a + b + c
    let d ( count livestock with [ species = "cattle" and age >= 3 ] / pasture-land-cattle )
    let f ( ( count livestock with [ species = "cattle" and age >= 1 and age < 3 ] * 0.8 ) / pasture-land-cattle )
    let g ( ( count livestock with [ species = "cattle" and age < 1 ] * 0.15 ) / pasture-land-cattle )
    let CLR d + f + g
    let h ( count livestock with [ species = "horse" and age >= 3 ] / pasture-land-horse )
    let i ( ( count livestock with [ species = "horse" and age >= 1 and age < 3 ] * 0.8 ) / pasture-land-horse )
    let j ( ( count livestock with [ species = "horse" and age < 1 ] * 0.15 ) / pasture-land-horse )
    let HLR h + i + j
    set pasture-land SLR + CLR + HLR

    ;; determine yield of milk per herd from lactating animals, this is done BEFORE the slaughtering of immatures and adults takes place (see Joyce 2019:42-43)
    set cattle-milk-yield ( count animals with [ species = "cattle" and lactating = "Y" and count link-neighbors = 0 ] * milk-yield-cattle * lactation-length-cattle )
    ;; first step is to calculate this for lactating animals without link-neighbors (offspring has died), where the milk offtake can be maximal
    set cattle-milk-yield cattle-milk-yield + ( ( count animals with [ species = "cattle" and lactating = "Y" and count link-neighbors > 0 ] / 2 ) * milk-yield-cattle * lactation-length-cattle )
    ;; second step is to calculate this for lactating animals with live offspring, of which only 50% will produce milk
    set sheep-milk-yield ( count animals with [ species = "sheep" and lactating = "Y" and count link-neighbors = 0 ] * milk-yield-sheep * lactation-length-sheep )
    set sheep-milk-yield sheep-milk-yield + ( ( count animals with [ species = "sheep" and lactating = "Y" and count link-neighbors = 0 ] / 2 ) * milk-yield-sheep * lactation-length-sheep )

    ;; determine yield of wool (see Joyce 2019:43)
    set sheep-wool-yield ( count livestock with [ species = "sheep" and age >= 1 ] * wool-yield-sheep )

    ;; resumes procedure with slaughter of immature and adult animals
    ask livestock with [ species = "sheep" and age >= 1 and age < 2 ] [
      if random-float 1.0 < SIMR [
        ask my-owner [
          set SIM SIM + 1
        ]
        die
      ]
    ]
    ask livestock with [ species = "sheep" and age >= 2 ] [
      if random-float 1.0 < SAMR [
        ask my-owner [
          set SAM SAM + 1
        ]
        die
      ]
    ]
    ask livestock with [ species = "cattle" and age >= 1 and age < 3 ] [
      if random-float 1.0 < CIMR [
        ask my-owner [
          set CIM CIM + 1
        ]
        die
      ]
    ]
    ask livestock with [ species = "cattle" and age >= 3 ] [
      if random-float 1.0 < CAMR [
        ask my-owner [
          set CAM CAM + 1
        ]
        die
      ]
    ]

    ;; calculate total meat yields per settlement from animal herds (see Joyce 2019:42)
    set cattle-meat-yield CAM * ( adult-weight-cattle * %-edible-carcass-cattle ) + CIM * ( immature-weight-cattle * %-edible-carcass-cattle ) + CYM * ( young-weight-cattle * %-edible-carcass-cattle )
    set sheep-meat-yield SAM * ( adult-weight-sheep * %-edible-carcass-sheep ) + SIM * ( immature-weight-sheep * %-edible-carcass-sheep ) + SYM * ( young-weight-sheep * %-edible-carcass-sheep )

    ;; calculate total manure yield per settlement from animal herds (see Joyce 2019:42)
    set cattle-manure-yield ( ( count livestock with [ species = "cattle" and age >= 3 ] * manure-daily-yield * adult-weight-cattle ) + ( count livestock with [ species = "cattle" and age >= 1 and age < 3 ] * manure-daily-yield * immature-weight-cattle ) + ( count livestock with [ species = "cattle" and age < 1 ] * manure-daily-yield * young-weight-cattle ) ) * 120

    ;; meadow land required per settlement for animal herds is calculated (see Joyce 2019:40)
    ;; N.B. meadows are not linked to patches
    let SFR ( ( count livestock with [ species = "sheep" and age >= 2 ] ) + ( count livestock with [ species = "sheep" and age >= 1 and age < 2 ] * 0.8 ) + ( count livestock with [ species = "sheep" and age < 1 ] * 0.15 ) ) * fodder-sheep ;; calculates the quantity of fodder needed each winter for each animal herd.
    let CFR ( ( count livestock with [ species = "cattle" and age >= 3 ] ) + ( count livestock with [ species = "cattle" and age >= 1 and age < 3 ] * 0.8 ) + ( count livestock with [ species = "cattle" and age < 1 ] * 0.15 ) ) * fodder-cattle
    let HFR ( ( count livestock with [ species = "horse" and age >= 3 ] ) + ( count livestock with [ species = "horse" and age >= 1 and age < 3 ] * 0.8 ) + ( count livestock with [ species = "horse" and age < 1 ] * 0.15 ) ) * fodder-horse
    set meadow-land ( SFR + CFR + HFR ) / yield-grassland

    ;; calculate labour needed for collecting fodder (see Joyce 2019:41-42)
    set fodder-labour-1 ( meadow-land * fodder-collection-time ) ;; labour expenditure per settlement for fodder collection is calculated.
    set fodder-labour-2 ( meadow-land * fodder-collection-time ) / ( count people with [ age >= 16 and age < 50 ] )
  ]
end

;; calculate labour required for fuel collection

to calc-workforce-fuel
  ask settlements [
    ;; empty existing lists
    set fuel-workforce turtle-set [ ]
    set fuel-labour-1 0
    set fuel-labour-2 0
    ;; determine size of workforce needed per foraging trip; collection-frequency (number of days between foraging trips) is set by user
    let a fuel-requirement / ( 365 / collection-frequency )
    let b count people with [ age >= 16 and age < 50 and sex = "male" ] * max-load-adult-male
    ;; calculates the minimum number of inhabitants required to collect sufficient fuel, and creates a foraging party
    ;; ROMFARMS seeks to send the fewest number of "strong" workforce (adult males and females) before it utilises the labour of the "weak" workforce (adolescents and the elderly).
    if b > a [
      set fuel-workforce turtle-set n-of ( ceiling ( a / max-load-adult-male ) ) people with [ age >= 16 and age < 50 and sex = "male" ]
    ]
    if b = a [
      set fuel-workforce turtle-set people with [ age >= 16 and age < 50 and sex = "male" ]
    ]
    if b < a [
      set fuel-workforce turtle-set people with [ age >= 16 and age < 50 and sex = "male" ]
      let c ( a - b )
      let d count people with [ age >= 16 and age < 50 and sex = "female" ] * max-load-adult-female
      if d > c [
        set fuel-workforce ( turtle-set fuel-workforce n-of ( ceiling ( c / max-load-adult-female ) ) people with [ age >= 16 and age < 50 and sex = "female" ] )
      ]
      if d = c [
        set fuel-workforce ( turtle-set fuel-workforce people with [ age >= 16 and age < 50 and sex = "female" ] )
      ]
      if d < c [
        set fuel-workforce ( turtle-set fuel-workforce people with [ age >= 16 and age < 50 and sex = "female" ] )
        let f ( a - ( b + d ) )
        let g count people with [ age >= 10 and age < 16 or age > 50 ] * max-load-other
        if g > f [
          set fuel-workforce ( turtle-set fuel-workforce n-of ( ceiling ( f / max-load-other ) ) people with [ age >= 10 and age < 16 or age > 50 ] )
        ]
        if g = f [
          set fuel-workforce ( turtle-set fuel-workforce people with [ age >= 10 and age < 16 or age > 50 ] )
        ]
        if g < f [
          set fuel-workforce ( turtle-set fuel-workforce people with [ age >= 10 and age < 16 or age > 50 ] )
        ]
      ]
    ]
    ;; the number of people in the fuel-workforce is added to fuel-workforce-list
    set fuel-workforce-list lput count fuel-workforce fuel-workforce-list
    ;; collect fuel
    repeat ceiling ( 365 / collection-frequency ) [
      find-fuel
    ]
  ]
end

;; calculate labour required for timber collection

to calc-workforce-construction
  ;; determine available wood biomass from patches, distinguishing between forest / coppice and forest / coppice / alternative wood biomass
  ask patches with [ use = "forest" or use = "coppice" ] [
    set biomass-forest-list lput biomass biomass-forest-list
  ]
  ask patches with [ use = "forest" or use = "coppice" or use = "alt-wood"  ] [
    set biomass-list lput biomass biomass-list
  ]
  ask settlements [ ;; calculates the minimum number of inhabitants required to collect timber. Only members of the "strong" workforce can collect timber.
    ;; inhabitants will only collect timber when reconstruction is necessary
    set construction-labour 0
    if age = reconstruction-frequency [
      set construction-workforce turtle-set [ ]
      let a count people with [ age >= 16 and age < 50 and sex = "male" ] * max-load-adult-male
      let b count people with [ age >= 16 and age < 50 and sex = "female" ] * max-load-adult-female
      if a >= construction-requirement [
        set construction-workforce ( turtle-set n-of ceiling ( construction-requirement / max-load-adult-male ) people with [ age >= 16 and age < 50 and sex = "male" ] )
      ]
      if a < construction-requirement [
        set construction-workforce ( turtle-set people with [ age >= 16 and age < 50 and sex = "male" ] )
        let c construction-requirement - a
        if b >= c [
          set construction-workforce ( turtle-set construction-workforce n-of ceiling ( c / max-load-adult-female ) people with [ age >= 16 and age < 50 and sex = "female" ] )
        ]
        if b < c [
          set construction-workforce ( turtle-set construction-workforce people with [ age >= 16 and age < 50 and sex = "female" ] )
        ]
      ]
      ;; timber is collected from patches with forest / coppicing
      while [ any? patches with [ use != "alt-wood" and biomass > 0 ] and construction-store < construction-requirement ] [
        find-timber
      ]

      ;; the number of people in the construction-workforce is added to construction-workforce-list
      set construction-workforce-list lput count construction-workforce construction-workforce-list
      ;; construction-workforce is emptied after timber collection
      set construction-workforce turtle-set [ ]
    ]
  ]
end

;; determines forest and fen cover; percentages are set by user; there is no check whether this is <= 1
;; forest and fen patches are randomly attributed to a percentage of patches with levee/floodbasin resp. NULL values
;; N.B. this leads to a non-contiguous forest cover; if a contiguous cover is desired, the procedures in setup-landscape can be applied
;; biomass figures (in kg / ha) are based on references from literature, can be adapted if desired

to setup-forest
  ask n-of ( count patches with [ landscape-type = "levee" or landscape-type = "floodbasin" ] * forest-cover ) patches with [ landscape-type = "levee" or landscape-type = "floodbasin" ] [
    set use "forest"
    if landscape-type = "levee" [
      set biomass ( 100 + random 20 ) * 439 ;; 100 +/- 20m3 is volume of wood per ha, 439kg/m3 is density of wood
    ]
    if landscape-type = "floodbasin" [
      set biomass ( 110 + random 30 ) * 439 ;; see above
    ]
  ]
    ask n-of ( fen-cover * count patches with [ pcolor = black ] ) patches with [ pcolor = black ] [
      set use "alt-wood"
      set landscape-type "fen"
      set biomass ( 65 + random 20 ) * 439 ;; see above
    ]
    ask patches with [ biomass > 0 ] [
      set pcolor scale-color green biomass 100000 1000 ;; patches are shaded according to biomass values
    ]
end

;; in this procedure the parameters for each new settlement are initialized; it is called from to new-settlement

to config-settlements

  ;; step 1 - determine calorie requirement, depending on population demographics; calculation detailed in Joyce (2019:31)
  set calories-required ( count people with [ age >= 16 and age < 50 and sex = "male" ] * 3250 * 365 + count people with [ age >= 16 and age < 50 and sex = "male" ] * 550 * 6 * 7 ) ;; sets calories-required as annual requirement for adult men (3250 per day ) plus extra calories for 6 weeks heavy labour
  set calories-required calories-required + ( count people with [ age >= 16 and age < 50 and sex = "female" ] * 2800 * 365 + count people with [ age >= 6 and age < 50 and sex = "female" ] * 400 * 6 * 7 ) ;; adds annual requirement for adult women to calorie requirement (2800 per day) plus extra for six weeks hard labour
  set calories-required calories-required + ( count people with [ age >= 50 and sex = "male" ] * 2650 * 365 ) ;; adds requirement of elderly males (aged >= 50 )to calorie requirement
  set calories-required calories-required + ( count people with [ age >= 50 and sex = "female" ] * 2450 * 365 ) ;; adds requirement of elderly females (aged >= 50) to calorie requirement
  set calories-required calories-required + ( count people with [ age < 1 ] * 675 * 180 + count people with [ age < 1 ] * 285 * 90 + count people with [ age < 1 ] * 475 * 90 ) ;; adds requirement of lactating adult females to calorie requirement
  set calories-required calories-required + ( count people with [ age >= 1 and age < 5 ] * 1360 * 365 ) ;; adds requirement of 2nd cohort persons (aged 1-4) to calorie requirement
  set calories-required calories-required + ( count people with [ age >= 5 and age < 10 ] * 2010 * 365 ) ;; adds requirement of 3rd cohort persons (aged 5-9) to calorie requirement
  set calories-required calories-required + ( count people with [ age >= 10 and age < 16 and sex = "male" ] * 2750 * 365 ) ;; adds requirement of male 4th cohort (aged 10-15) to calorie requirement
  set calories-required calories-required + ( count people with [ age >= 10 and age < 16 and sex = "female" ] * 2420 * 365 ) ;; adds requirement of female 4th cohort (aged 10-15) to calorie requirement

  ;; step 2 - determine required minimum grain store
  set min-grain-store ( ( calories-required * %-calories-from-crops ) / calories-in-crops ) * store-size
  ;; sets minimum amount of grain required by settlement as amount of grain to satisfy a % of the total calories required
  ;; (determined by %-calories-from-crops, input by user) plus a buffer (determined by store-size, input by user)
  set grain-store ( min-grain-store + ( ( min-grain-store / basic-yield ) * 200 ) ) ;; sets initial grain-store as the minimum grain store

  ;; step 3 - initialize parameters for fuel and timber collection
  set fuel-target nobody ;; current patch targeted for fuel collection
  set fuel-requirement count people * 365 * daily-per-capita-fuel-use ;; sets fuel requirement per year; daily-per-capita-fuel-use in kg is set by user
  set fuel-labour-1 0 ;; average time (hrs) spent by one member of fuel foraging group in settlement on fuel-collection in current step
  set fuel-labour-2 0 ;; total time (hrs) spent by whole “strong” workforce in settlement on fuel-collection in current step
  set fuel-store 0 ;; total quantity of fuel (kg) settlement possesses in current step; initial fuel storage is empty

  set construction-labour 0 ;; total time (hrs) spent by whole timber foraging group in settlement on timber collection in current step
  set construction-requirement 8525.4 * no-households ;; total quantity of timber (kg) needed to rebuild buildings; calculation detailed in Joyce (2019:48)
  set construction-store 0 ;; total quantity of timber (kg) settlement possesses in current step; initial timber storage is empty
  set construction-target nobody ;; current patch targeted for timber collection

  ;; step 3 - initialize parameters for animal herds
  ;; initial herd sizes are 30 heads of young adult females; user input decides what animals are found in the settlement
  ;; only a single herd per species is allowed
  if cattle? = TRUE [
    repeat 30 [
      hatch 1 [
        ht
        set breed animals
        set species "cattle"
        set age 3
        set sex "female"
        set fertility 0.7
        set survivorship random-float 1.0 ;; at birth, the survivorship is a random number (see Joyce 2019:38 for details)
        set my-owner myself
        ask myself [
          set livestock ( turtle-set livestock myself )
        ]
      ]
    ]
  ]
  if sheep? = TRUE [
    repeat 30 [
      hatch 1 [
        ht
        set breed animals
        set species "sheep"
        set age 2
        set sex "female"
        set fertility 0.8
        set survivorship random-float 1.0
        set my-owner myself
        ask myself [
          set livestock ( turtle-set livestock myself )
        ]
      ]
    ]
  ]
  if horse? = TRUE [
    repeat 30 [
      hatch 1 [
        ht
        set breed animals
        set species "horse"
        set age 3
        set sex one-of ( list "male" "female" )
        set fertility 0.6
        set survivorship random-float 1.0
        set my-owner myself
        ask myself [
          set livestock ( turtle-set livestock myself )
        ]
      ]
    ]
  ]

  ;; step 5 - determine catchment
  ;; the settlement 'owns' patches of levee that have not been claimed by other settlements in a radius of 50 pixels

  set catchment patch-set [ ] ;; first create empty patch-set
  set catchment ( patch-set catchment patches with [ landscape-type = "levee" and not any? settlements-here ] in-radius ( catchment-area * 50 ) ) ;; select available patches
  set catchment ( patch-set catchment patch-here ) ;; add the patch of the settlement itself

  if coppicing? = TRUE and count catchment > 1 [
      ask one-of catchment with [ use != "forest" and use != "coppice" ] [ ;; if coppicing is selected by user, change a single "non-forest" patch to "coppice", and adapt biomass
      set use "coppice"
      set patch-owner myself
      set biomass ( 180 + random 40 ) * 439
      set pcolor scale-color green biomass 100000 1000
    ]
  ]
  ask patch-here [
    set patch-owner myself ;; set the ownership of the patch where the settlement is located
  ]
end

;; in this procedure, age-specific fertility is set for females => 16 years old; numbers are based on the figures given in Coale & Trussell (1978)

to set-fertility
  ask persons with [ my-spouse != nobody and sex = "female" ] [
    if age >= 16 and age < 19 [
      set fertility 0.411
    ]
    if age >= 19 and age < 24 [
      set fertility 0.46
    ]
    if age >= 24 and age < 29 [
      set fertility 0.431
    ]
    if age >= 29 and age < 34 [
      set fertility 0.395
    ]
    if age >= 34 and age < 39 [
      set fertility 0.322
    ]
    if age >= 39 and age < 44 [
      set fertility 0.167
    ]
    if age >= 44 and age < 50 [
      set fertility 0.024
    ]
  ]
end

;; in this procedure, age-specific mortality is set for persons; numbers are based on the adapted Coale and Demeny's (1966) Model West Level 3 Female life table, taken from Hin (2013)
;; no distinction is made between male and female mortality

to set-mortality
  ask persons [
    if age >= 0 and age < 1 [
      set mortality 0.3056
    ]
    if age >= 1 and age < 5 [
      set mortality 0.2158 / 4
    ]
    if age >= 5 and age < 10 [
      set mortality 0.0606 / 5
    ]
    if age >= 10 and age < 15 [
      set mortality 0.0474 / 5
    ]
    if age >= 15 and age < 20 [
      set mortality 0.0615 / 5
    ]
    if age >= 20 and age < 25 [
      set mortality 0.0766 / 5
    ]
    if age >= 25 and age < 30 [
      set mortality 0.0857 / 5
    ]
    if age >= 30 and age < 35 [
      set mortality 0.0965 / 5
    ]
    if age >= 35 and age < 40 [
      set mortality 0.1054 / 5
    ]
    if age >= 40 and age < 45 [
      set mortality 0.1123 / 5
    ]
    if age >= 45 and age < 50 [
      set mortality 0.1197 / 5
    ]
    if age >= 50 and age < 55 [
      set mortality 0.1529 / 5
    ]
    if age >= 55 and age < 60 [
      set mortality 0.1912 / 5
    ]
    if age >= 60 and age < 65 [
      set mortality 0.2715 / 5
    ]
    if age >= 65 and age < 70 [
      set mortality 0.3484 / 5
    ]
    if age >= 70 and age < 75 [
      set mortality 0.4713 / 5
    ]
    if age >= 75 and age < 80 [
      set mortality 0.6081 / 5
    ]
    if age >= 80 and age < 85 [
      set mortality 0.7349 / 5
    ]
    if age >= 85 and age < 90 [
      set mortality 0.8650 / 5
    ]
    if age >= 90 and age < 95 [
      set mortality 0.9513 / 5
    ]
    if age >= 95 [
      set mortality 1
    ]
  ]
end

to find-fuel ;; sub-process is looped until workforces have collected the maximum amount of fuel in the landscape or enough fuel.
  while [ any? fuel-workforce with [ load < max-load ] and any? patches with [ biomass > 0 ] ] [ ;; settlements target a specific patch containing woodland.
    ifelse any? catchment with [ use = "coppice" and patch-owner = myself and biomass > 0 ] [
      set fuel-target one-of catchment with [ use = "coppice" and biomass > 0 ]
    ]
    [
      ifelse any? patches with [ use = "forest" and biomass > mean ( biomass-forest-list ) ] [
        set fuel-target max-one-of patches with [ use = "forest" and biomass > 0 ] [ distance myself ]
      ]
      [
        ifelse any? patches with [ use = "forest" and biomass > 0 ] [
          set fuel-target min-one-of patches with [ use = "forest" and biomass > 0 ] [ distance myself ]
        ]
        [
        if any? patches with [ biomass > 0 ] [
          set fuel-target min-one-of patches with [ biomass > 0 ] [ distance myself ]
        ]
      ]
    ]
  ]
  if fuel-target != nobody [
    take-fuel
    set fuel-target nobody
  ]
  ]
  set fuel-store fuel-store + sum ( [ load ] of fuel-workforce ) ;; workforces process and collect fuel
  set fuel-labour-1 fuel-labour-1 + sum ( [ processing-time-fuel ] of fuel-workforce ) ;; time spent processing fuel per member of the workforce and the sum total for the whole workforce is calculated.
  set fuel-labour-2 fuel-labour-2 + ( sum ( [ processing-time-fuel ] of fuel-workforce ) / count fuel-workforce )
  ask fuel-workforce [
    let a patch-here
    move-to my-house
    set distance-travelled-fuel distance-travelled-fuel + distance a
    ask my-house [
      set fuel-labour-1 fuel-labour-1 + ( sum ( [ distance-travelled-fuel ] of fuel-workforce ) / 10 / walking-speed ) ;; the cumulative distance travelled per member of the workforce between patches and the settlement and the sum total for the whole workforce is calculated.
      set fuel-labour-2 fuel-labour-2 + ( ( sum ( [ distance-travelled-fuel ] of fuel-workforce ) / 10 / walking-speed ) / count fuel-workforce )
    ]
    set load 0
    set distance-travelled-fuel 0
    set processing-time-fuel 0
  ]
end

to find-timber ;; same process as above
  while [ any? construction-workforce with [ load != max-load ] and any? patches with [ biomass > 0 ] ] [
    ifelse any? catchment with [ use = "coppice" and patch-owner  = myself and biomass > 0 ] [
      set construction-target max-one-of catchment with [ use = "coppice" and patch-owner = myself and biomass > 0 ] [ biomass ]
    ]
    [
      ifelse any? patches with [ use = "forest" and biomass > mean ( biomass-forest-list ) ] [
        set construction-target max-one-of patches with [ use = "forest" and biomass > mean ( biomass-forest-list ) ] [ biomass ]
      ]
      [
        if any? patches with [ use = "forest" and biomass > 0 ] [
          set construction-target min-one-of patches with [ use = "forest" and biomass > 0 ] [ distance myself ]
        ]
      ]
    ]
    if construction-target != nobody [
      take-timber
      set construction-target nobody
    ]
  ]
  set construction-store construction-store + sum ( [ load ] of construction-workforce )
  set construction-labour construction-labour + sum ( [ processing-time-timber ] of construction-workforce )
  ask construction-workforce [
    let a patch-here
    move-to my-house
    set distance-travelled-construction distance-travelled-construction + distance a
    ask my-house [
      set construction-labour construction-labour + ( ( sum ( [ distance-travelled-construction ] ) of construction-workforce ) / 10 / walking-speed )
    ]
    set load 0
    set distance-travelled-construction 0
    set processing-time-timber 0
  ]
end

;; creates a new settlement when a new married couple must leave their original settlement due to overcrowding.
;; if settlement density will be exceeded, no new settlement is produced and the couple is removed.

to new-settlement
  ifelse any? patches with [ landscape-type = "levee" and use != "settlement" and count settlements-on neighbors = 0 ] and ( precision ( ( count settlements + 1 ) / count patches with [ landscape-type = "levee" ] ) 4 ) <= settlement-density [
    let a self
    ask one-of patches with [ landscape-type = "levee" and use != "settlement" and count settlements-on neighbors = 0 ] [
      sprout 1 [
        set breed settlements
        set age 0
        set no-households [ no-households ] of [ my-house ] of a
        set color white
        set size 1 + ( ( no-households - 1 ) / 4 )
        set livestock turtle-set [ ]
        set people turtle-set [ ]
        set people ( turtle-set people a )
        set people ( turtle-set people [ my-spouse ] of a )
        ask a [
          set my-house myself
          ask my-spouse [
            set my-house [ my-house ] of a
          ]
        ]
        if [ biomass ] of patch-here > 0 [
          set fuel-store fuel-store + [ biomass ] of patch-here
          ask patch-here [
            set biomass 0
          ]
        ]
        config-settlements
      ]
    ]
  ]
  [
    ask my-spouse [
      die
    ]
    die
  ]
end

to take-fuel
  ask fuel-workforce [
    let a patch-here
    move-to [ fuel-target ] of my-house
    set distance-travelled-fuel distance-travelled-fuel + distance a
    ifelse [ biomass ] of [ fuel-target ] of my-house >= ( max-load - load ) [
      ask [ fuel-target ] of my-house [
        set biomass biomass - [ max-load - load ] of myself
        if biomass = 0 [
          if use = "coppice" [
            set countdown-reforest 12
          ]
          if use = "forest" or use = "alt-wood" [
            set countdown-reforest 15
          ]
        ]
      ]
      set load load + ( max-load - load )
      set processing-time-fuel processing-time-fuel + fuel-collection-time
    ]
    [
      set load load + [ biomass ] of [ fuel-target ] of my-house
      set processing-time-fuel processing-time-fuel + fuel-collection-time
      ask [ fuel-target ] of my-house [
        set biomass 0
        if use = "coppice" [
          set countdown-reforest 12
        ]
        if use = "forest" [
          set countdown-reforest 15
        ]
      ]
    ]
  ]
end

to take-timber
  ask construction-workforce [
    let a patch-here
    move-to [ construction-target ] of my-house
    set distance-travelled-construction distance-travelled-construction + distance a
    ifelse [ biomass ] of [ construction-target ] of my-house >= ( max-load - load ) [
      ask [ construction-target ] of my-house [
        set biomass biomass - [ max-load - load ] of myself
        if biomass = 0 [
          if use = "coppice" [
            set countdown-reforest 12
          ]
          if use = "forest" or use = "alt-wood" [
            set countdown-reforest 15
          ]
        ]
      ]
      set load load + ( max-load - load )
      set processing-time-timber processing-time-timber + timber-collection-time
    ]
    [
      set load load + [ biomass ] of [ construction-target ] of my-house
      set processing-time-timber processing-time-timber + timber-collection-time
      ask [ construction-target ] of my-house [
        set biomass 0
        if use = "coppice" [
          set countdown-reforest 12
        ]
        if use = "forest" [
          set countdown-reforest 15
        ]
      ]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
175
13
612
451
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
ticks
30.0

INPUTBOX
704
15
859
75
area-levee
0.3
1
0
Number

INPUTBOX
703
74
858
134
area-floodbasin
0.5
1
0
Number

INPUTBOX
703
133
858
193
forest-cover
0.3
1
0
Number

INPUTBOX
703
193
858
253
fen-cover
0.2
1
0
Number

INPUTBOX
10
12
165
72
no-1-household-settlements
8.0
1
0
Number

INPUTBOX
10
70
165
130
no-2-household-settlements
3.0
1
0
Number

INPUTBOX
10
129
165
189
no-3-household-settlements
1.0
1
0
Number

INPUTBOX
10
188
165
248
no-5-household-settlements
1.0
1
0
Number

INPUTBOX
860
15
1015
75
%-calories-from-crops
0.8
1
0
Number

INPUTBOX
860
75
1015
135
store-size
1.5
1
0
Number

INPUTBOX
1034
15
1189
75
daily-per-capita-fuel-use
6.0
1
0
Number

SWITCH
1203
18
1306
51
cattle?
cattle?
1
1
-1000

SWITCH
1203
50
1306
83
sheep?
sheep?
1
1
-1000

SWITCH
1203
82
1306
115
horse?
horse?
1
1
-1000

SWITCH
1034
74
1146
107
coppicing?
coppicing?
1
1
-1000

CHOOSER
1203
115
1341
160
sheep-strategy
sheep-strategy
"milk" "meat" "wool"
1

CHOOSER
1204
162
1342
207
cattle-strategy
cattle-strategy
"milk" "meat" "manure"
2

CHOOSER
861
135
999
180
strategy-arable
strategy-arable
"none" "extensification" "intensification"
0

INPUTBOX
11
308
166
368
runtime
100.0
1
0
Number

BUTTON
12
374
75
407
NIL
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
75
374
138
407
NIL
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

INPUTBOX
1035
108
1190
168
collection-frequency
1.0
1
0
Number

CHOOSER
12
422
168
467
region
region
"hyp" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32
0

CHOOSER
12
473
150
518
period
period
"IJZ" "ROMVA" "ROMVB" "ROMMA" "ROMMB"
0

INPUTBOX
861
179
1016
239
surplus-takeoff
0.0
1
0
Number

INPUTBOX
1036
175
1191
235
reconstruction-frequency
0.0
1
0
Number

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
