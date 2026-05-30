# IMPORT DATA ----
penguins_raw <- read_csv(here::here("files", "penguins_raw.csv"))

attributes(penguins_raw) # reads as tibble

head(penguins_raw) # check the data has loaded, prints first 10 rows of dataframe

# CLEAN DATA ----

# clean all variable names to snake_case
# using the clean_names function from the janitor package
# note we are using assign <-
# to overwrite the old version of penguins
# with a version that has updated names
# this changes the data in our R workspace
# but NOT the original csv file

# clean the column names
# assign to new R object
penguins_clean <- janitor::clean_names(penguins_raw)

# quickly check the new variable names
colnames(penguins_clean)

# shorten the variable names for N and C isotope blood samples

penguins <- rename(penguins_clean,
                   "delta_15n"="delta_15_n_o_oo",  # use rename from the dplyr package
                   "delta_13c"="delta_13_c_o_oo")

# use mutate and case_when for a statement that conditionally changes the names of the values in a variable
penguins <- penguins_clean |>
  mutate(species = case_when(species == "Adelie Penguin (Pygoscelis adeliae)" ~ "Adelie",
                             species == "Gentoo penguin (Pygoscelis papua)" ~ "Gentoo",
                             species == "Chinstrap penguin (Pygoscelis antarctica)" ~ "Chinstrap"))

# use mutate and if_else
# for a statement that conditionally changes
# the names of the values in a variable
penguins <- penguins |>
  mutate(sex = if_else(
    sex == "MALE", "Male", "Female"
  )
  )

# use lubridate to format date and extract the year
penguins <- penguins |>
  mutate(date_egg = lubridate::dmy(date_egg))

penguins <- penguins |>
  mutate(year = lubridate::year(date_egg))

# Set body mass ranges
penguins <- penguins |>
  mutate(mass_range = case_when(
    body_mass_g <= 3500 ~ "smol penguin",
    body_mass_g >3500 & body_mass_g < 4500 ~ "mid penguin",
    body_mass_g >= 4500 ~ "chonk penguin",
    .default = NA)
  )

# Assign these to an ordered factor

penguins <- penguins |>
  mutate(mass_range = fct_relevel(mass_range,
                                  "smol penguin",
                                  "mid penguin",
                                  "chonk penguin")
  )
