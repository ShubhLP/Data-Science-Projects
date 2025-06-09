library(tidyverse)

?msleep
glimpse(msleep)
View(msleep)

# Rename variables
msleep %>% 
  rename('conserv' = 'conservation') %>% 
  glimpse()

# Reorder Variables
msleep %>% 
  select('vore', 'name', everything())

# change a variable type
class(msleep$vore)
msleep$vore <- as.factor(msleep$vore)
glimpse(msleep)

msleep %>% 
  mutate(vore = as.character(vore)) %>%
  glimpse()

# Select variables to work with
names(msleep)

msleep %>% 
  select(2:4, awake, starts_with('sleep'), contains("wt")) %>% 
  names()

# Filter and arrange data
unique(msleep$order)

msleep %>% 
  filter((order == 'Carnivora') | (order == 'Primates') & sleep_total > 8) %>% 
  select(name, order, sleep_total) %>% 
  arrange(-sleep_total) %>%
  View()

msleep %>% 
  filter(order %in% c("Carnivore", "Primates") & sleep_total > 8) %>% 
  select(name, order, sleep_total) %>%
  arrange(order) %>% 
  View()

# Change observations (mutate)
msleep %>%
  mutate(brainwt = brainwt * 1000) %>% 
  View()

msleep %>% 
  mutate(brainwt_in_grams = brainwt * 1000) %>% 
  View()

# Conditional changes (if-else)
## logical vector based on condition

msleep$brainwt
msleep$brainwt > 0.01

size_of_brain = msleep %>%
  select(name, brainwt) %>% 
  drop_na(brainwt) %>% 
  mutate(brain_size = if_else(brainwt > 0.01, 'large', 'small'))

# Recode data and rename a variable
## Change observation of 'large' and 'small' into

size_of_brain %>% 
  mutate(brain_size = recode(brain_size, 
                             'large' = 1, 
                             'small' = 2))

# Reshape the data from wide to long or long to wide

library(gapminder)
View(gapminder)

data <- select(gapminder, country, year, lifeExp)

View(data)

wide_data <- data %>% 
  pivot_wider(names_from = year, values_from = lifeExp)

View(wide_data)

length(names(wide_data))

long_data <- wide_data %>%
  pivot_longer(2:13, names_to = "year", values_to = "lifeExp")
View(long_data)
