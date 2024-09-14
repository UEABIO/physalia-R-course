# (PART\*) Getting the most out of tidyverse {.unnumbered}










# Reading files with `readr`

Make sure for these exercises you are starting with a **clean session**

## Cleaning column names

Reading a CSV file often requires some data cleaning. For example, let's say I want to import data and convert all column names to `snake_case`. 

Most of us would probably read the .CSV file first, then start data cleaning - for example with the `janitor::clean_names()` function. 


```r
library(tidyverse)
library(janitor)
#load data
penguins_raw <- read_csv ("data/penguins_raw.csv")

penguins_raw |> 
janitor::clean_names() 
```

In my previous example, I used the `clean_names()` function from the "janitor" package to convert the column names to lowercase. You can achieve the same result by using the `make_clean_names()` function within the `read_csv` function, specifying it in the `name_repair` argument.


```r
penguins_clean <- read_csv ("data/penguins_raw.csv",
                      name_repair = janitor::make_clean_names)
```

By default the `janitor::make_clean_names` function has a default argument of `snake_case` but within the function there is also a `case` argument where other common naming conventions can be used. 

## Selecting columns

In addition to cleaning your column names, you can also directly select columns while using the "read_csv" function by utilizing the "col_select" argument. This can be extremely useful when working with large files, selecting only the columns you need can be memory-efficient. 


```r
penguins_clean <- read_csv ("data/penguins_raw.csv",
                      name_repair = janitor::make_clean_names,
                      col_select = c(species, body_mass_g, flipper_length_mm)) |> 
  glimpse()
```

## Reading multiple files

Here we actually start with a complete dataframe - and first iterate to split into 25 equally sized dataframes.
`walk2` operates in the same way as `map2` - but is the preferred option here as it is "silent" 


```r
dir.create(c("data/many_files"))
peng_samples <- map(1:25, ~ slice_sample(penguins_clean, n = 20))

walk2(peng_samples, 1:25, ~ write_csv(.x, paste0("data/many_files/", .y, ".csv")))
```

### Create a vector of file paths

Now, to create a vector of file paths, we'll use the list.files function in R. This function allows us to identify and list all the files with a specific extension in a directory. In this example, we're looking for CSV files in the "data/many_files" directory.


```r
csv_files_list_files <- list.files(path = "data/many_files",
                                    pattern = "csv", full.names = TRUE)
```

```
 [1] "data/many_files/1.csv"  "data/many_files/10.csv" "data/many_files/11.csv" "data/many_files/12.csv"
 [5] "data/many_files/13.csv" "data/many_files/14.csv" "data/many_files/15.csv" "data/many_files/16.csv"
 [9] "data/many_files/17.csv" "data/many_files/18.csv" "data/many_files/19.csv" "data/many_files/2.csv" 
[13] "data/many_files/20.csv" "data/many_files/21.csv" "data/many_files/22.csv" "data/many_files/23.csv"
[17] "data/many_files/24.csv" "data/many_files/25.csv" "data/many_files/3.csv"  "data/many_files/4.csv" 
[21] "data/many_files/5.csv"  "data/many_files/6.csv"  "data/many_files/7.csv"  "data/many_files/8.csv" 
[25] "data/many_files/9.csv"
```

The function "list.files" has several arguments. Here's an explanation of some key arguments:

- "path": This argument allows you to specify the directory where your files are located. It's essential to ensure the path is set correctly. You should be working within an R-Studio project or have defined your working directory to avoid issues.

- "pattern": You provide a regular expression in this argument to filter the files you want to list. In your example, you mentioned that you are looking for files containing the string "csv." This helps narrow down the selection to specific file types or patterns.

- "full.names": Setting this argument to `TRUE` indicates that you want to store the full paths of the files, not just their names. This is important for ensuring you can correctly access and read these files later. If "full.names" is not set to `TRUE`, you may encounter difficulties when attempting to read the files because the file paths would be incomplete.

This vector, `csv_files_list_files`, will now hold the file paths to all the CSV files in our specified directory, making it easy to access and manipulate these files in our R environment

### Read multiple files

Now that we have obtained the file paths, we can proceed to load the files into R. The preferred method in the tidyverse is to use the `map_dfr` function from the `purrr` package. This function iterates through all the file paths and combines the data frames into a single, unified data frame. In the following code, `.x` represents the file name or path. To read and output the actual content of the CSV files (not just the filenames), you should include `.x` (the path) within a `readr` function. While this example deals with CSV files, this approach works similarly for other rectangular file formats.


```r
df <- map_dfr(csv_files_list_files,
              ~ read_csv(.x))

glimpse(df)
```


### Selecting files

Now, to filter and choose specific files for reading, we'll use the `str_detect()` function from the `stringr` package in R. This function allows us to search for specific patterns within our vector of file paths and select files that match our criteria. he pattern argument specifies the pattern we want to detect, which, in this case, is "[2-4]". The `negate = FALSE` argument ensures that we only select files that match the pattern. This work is made easier when we have good naming conventions.



```r
csv_files_list_files[str_detect(csv_files_list_files, pattern = "[2-4]",
negate = FALSE)]
```
```
 [1] "data/many_files/12.csv" "data/many_files/13.csv" "data/many_files/14.csv"
 [4] "data/many_files/2.csv"  "data/many_files/20.csv" "data/many_files/21.csv"
 [7] "data/many_files/22.csv" "data/many_files/23.csv" "data/many_files/24.csv"
[10] "data/many_files/25.csv" "data/many_files/3.csv"  "data/many_files/4.csv"
```

If we want to narrow our criteria further to include only the files that meet the specific pattern of file names ending with "2.csv" or "4.csv." We can work with a subset of files that specifically fit our analysis needs.

`str_detect(csv_files_list_files, pattern = "[24]\\.csv$` is the core of this code. Here, we are applying the `str_detect()` function to search for a particular pattern within the csv_files_list_files. The pattern we are looking for is "[24]\.csv$," which essentially means we're seeking files with a file name that ends with "2.csv" or "4.csv."


```r
csv_files_list_files[str_detect(csv_files_list_files, pattern = "[24]\\.csv$")]
```

```
[1] "data/many_files/12.csv" "data/many_files/14.csv" "data/many_files/2.csv" 
[4] "data/many_files/22.csv" "data/many_files/24.csv" "data/many_files/4.csv"

```


## Exercise

This final section for the workshop provides a real world example using iterations to create graphs of population trends from the [Living Planet Index](https://www.livingplanetindex.org/) for a number of vertebrate species from 1970 to 2014. 

The data can be collected here:


```{=html}
<a href="https://raw.githubusercontent.com/UEABIO/data-sci-v1/main/book/files/LPI_data_loops.csv">
<button class="btn btn-success"><i class="fa fa-save"></i> Download LPI data as csv</button>
</a>
```


**1. Can you make four plots using data nesting and map functions?** 

For this exercise we would like to filter the dataframe to House sparrow, Great tit, Corn bunting and Meadow pipit then nest this data and apply a map function to produce a scatter plot of year against abundance. Customise the plot as you see fit.


<button id="displayTextunnamed-chunk-12" onclick="javascript:toggle('unnamed-chunk-12');">Show Solution</button>

<div id="toggleTextunnamed-chunk-12" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
nested_LPI <- LPI |> 
  group_by(Common.Name) |> 
  nest() |> 
  filter(Common.Name %in% c("House sparrow", "Great tit", "Corn bunting", "Meadow pipit")) |> 
     mutate(plots = map(data, ~ ggplot(., aes (x = year, y = abundance)) +              
                            geom_point(size = 2, colour = "#00868B") +                                                
                            geom_smooth(method = lm, colour = "#00868B", fill = "#00868B") +
                            ggtitle(Common.Name)+
                            labs(y = "Abundance\n", x = "")))


  wrap_plots(nested_LPI$plots)
```
</div></div></div>



**2. Can you write this object to multiple dataframes based on "Common.Name".**

For this exercise we would like to read the entire dataframe, then produce four new .csv files one for each of House sparrow, Great tit, Corn bunting and Meadow pipit.

<button id="displayTextunnamed-chunk-13" onclick="javascript:toggle('unnamed-chunk-13');">Show Solution</button>

<div id="toggleTextunnamed-chunk-13" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
LPI <- read_csv("https://raw.githubusercontent.com/UEABIO/data-sci-v1/main/book/files/LPI_data_loops.csv")

LPI |> 
  group_by(Common.Name) |> 
  nest() |> 
  filter(Common.Name %in% c("House sparrow", "Great tit", "Corn bunting", "Meadow pipit")) 

walk2(nested$data, nested$Common.Name, ~ write_csv(.x, paste0(paste0("split_files/", .y , ".csv"))))
```

</div></div></div>



# Working across columns

In this section we will go through the following functions:



- `last_col()`

- `starts_with()`

- `ends_with()`

- `contains()`

- `matches()`

- `num_range()`

- `where()`

This set of handy functions helps streamline column selection and manipulation in data frames. These functions serve various purposes, from selecting specific columns based on their names to targeting numeric ranges or custom patterns, ultimately making data wrangling more efficient and precise.

## Select the last column


```r
penguins_clean |> 
  select(last_col()) |> 
  glimpse()
```

```
## Rows: 344
## Columns: 1
## $ comments <chr> "Not enough blood for isotopes.", NA, NA, "Adult not sampled.…
```

You can also select `n-to-the-last` with `last_col()`


```r
penguins_clean |> 
  select(last_col(3)) |> 
  glimpse()
```

```
## Rows: 344
## Columns: 1
## $ sex <chr> "MALE", "FEMALE", "FEMALE", NA, "FEMALE", "MALE", "FEMALE", "MALE"…
```

<div class="info">
<p>Indexing starts at 0, so 1 indicates n-1.</p>
</div>


## Selecting columns based on string

This code selects all columns that "start with s"


```r
penguins_clean |> 
  select(starts_with("s")) |> 
  glimpse()
```
```
Rows: 344
Columns: 5
$ study_name    <chr> "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708"…
$ sample_number <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,…
$ species       <chr> "Adelie Penguin (Pygoscelis adeliae)", "Adelie Penguin (Pygoscelis adeliae)", "Adelie …
$ stage         <chr> "Adult, 1 Egg Stage", "Adult, 1 Egg Stage", "Adult, 1 Egg Stage", "Adult, 1 Egg Stage"…
$ sex           <chr> "MALE", "FEMALE", "FEMALE", NA, "FEMALE", "MALE", "FEMALE", "MALE", NA, NA, NA, NA, "F…

```

`starts_with` and `ends_with` works with any character, but also with a vector of characters, here it allows us to select all columns that begin with either "s or c".


```r
penguins_clean |> 
  select(starts_with(c("s", "c"))) |> 
  glimpse()
```
```
Rows: 344
Columns: 9
$ study_name        <chr> "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0…
$ sample_number     <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,…
$ species           <chr> "Adelie Penguin (Pygoscelis adeliae)", "Adelie Penguin (Pygoscelis adeliae)", "Ade…
$ stage             <chr> "Adult, 1 Egg Stage", "Adult, 1 Egg Stage", "Adult, 1 Egg Stage", "Adult, 1 Egg St…
$ sex               <chr> "MALE", "FEMALE", "FEMALE", NA, "FEMALE", "MALE", "FEMALE", "MALE", NA, NA, NA, NA…
$ clutch_completion <chr> "Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "No", "No", "Yes", "Yes", "Yes", "Yes", …
$ culmen_length_mm  <dbl> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, 42.0, 37.8, 37.8, 41.1, 38.6, …
$ culmen_depth_mm   <dbl> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1, 20.2, 17.1, 17.3, 17.6, 21.2, …
$ comments          <chr> "Not enough blood for isotopes.", NA, NA, "Adult not sampled.", NA, NA, "Nest neve…
```

### Contains

We can also use the `contains()` function to search for columns that contain a specific string, it searches for an exact match to your string (no regular expressions) but is case-insensitive


```r
penguins_clean |> 
  select(contains("length")) |> 
  glimpse()
```

```
Rows: 344
Columns: 2
$ culmen_length_mm  <dbl> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, 42.0, 37.8, 37.8, 41.1, 38.6, …
$ flipper_length_mm <dbl> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 186, 180, 182, 191, 198, 185, 195…
```

### Regular expressions

Regular expressions, often abbreviated as regex, are powerful tools for pattern matching and text manipulation. They provide a concise and flexible way to search, extract, and manipulate text based on specific patterns, allowing data analysts and programmers to efficiently handle complex text-processing tasks. 

We have been working with regex each time we use  `stringr` but we have been looking for literal characters
But we can use regex types to look for specific patterns

| Regex Type                                  | Description                                                                                               |
|--------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| Literal Characters                         | Matches the exact sequence of characters you specify.                                                   |
| Character Classes (square brackets `[]`)   | Matches any character within the specified set.                                                           |
| Wildcards (dot `.`)                        | Matches any single character (except for a newline).                                                      |
| Quantifiers (e.g., `*`, `+`, `?`)          | Specify the number of times a character or group can occur.                                               |
| Anchors (e.g., `^`, `$`)                   | Specify the start (`^`) or end (`$`) of a line or string.                                                  |
| Character Escapes (e.g., `\d`, `\s`, `\w`) | Shorthand for common character classes.                                                                    |
| Groups (parentheses `()`)                  | Create subpatterns for more complex matches.                                                               |
| Alternation (pipe `|`)                     | Allows multiple alternative matches.                                                                       |
| Ranges (dash `-`)                          | Matches any character within a specified range.                                                            |
| Quantifiers (e.g., `{m}`, `{m,}`, `{m,n}`) | Specify exact, minimum, or minimum to maximum occurrences of a character or group.                        |
| Word Boundaries (`\b`)                     | Matches the position between a word character and a non-word character.                                    |
| Capture Groups (parentheses `()`)          | Create groups for capturing matched content for later use.                                                 |
| Lookahead and Lookbehind                   | Perform assertions without including them in the match.                                                    |
| Modifiers (e.g., `i`, `g`, `m`)            | Modify the behavior of the regex, such as making it case-insensitive (`i`) or matching across multiple lines (`m`). |


This example will look for any columns that match contains numbers. 


```r
penguins_clean |> 
  select(matches("[0-9]")) |> 
  glimpse()
```
```
Rows: 344
Columns: 2
$ delta_15_n_o_oo <dbl> NA, 8.94956, 8.36821, NA, 8.76651, 8.66496, 9.18718, 9.46060, NA, 9.13362, 8.63243, …
$ delta_13_c_o_oo <dbl> NA, -24.69454, -25.33302, NA, -25.32426, -25.29805, -25.21799, -24.89958, NA, -25.09…

```

This *modifier* means columns are only returned if they have at least two numbers in the column header


```r
penguins_clean |> 
  select(matches("[0-9]{2}")) |> 
  glimpse()
```

This pattern looks for an exact string match to "length_" but it must also be followed by any two letters...


```r
penguins_clean |> 
    select(matches("length_[a-z]{2}")) |> 
    glimpse()
```


## Selecting by column type

The `where()` function is used when you want to select variables of a specific data type in a dataset. For example, you can use it to select character variables.



```r
penguins_clean |> 
    select(where(is.character)) |> 
    glimpse()
```
```
Rows: 344
Columns: 10
$ study_name        <chr> "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0…
$ species           <chr> "Adelie Penguin (Pygoscelis adeliae)", "Adelie Penguin (Pygoscelis adeliae)", "Ade…
$ region            <chr> "Anvers", "Anvers", "Anvers", "Anvers", "Anvers", "Anvers", "Anvers", "Anvers", "A…
$ island            <chr> "Torgersen", "Torgersen", "Torgersen", "Torgersen", "Torgersen", "Torgersen", "Tor…
$ stage             <chr> "Adult, 1 Egg Stage", "Adult, 1 Egg Stage", "Adult, 1 Egg Stage", "Adult, 1 Egg St…
$ individual_id     <chr> "N1A1", "N1A2", "N2A1", "N2A2", "N3A1", "N3A2", "N4A1", "N4A2", "N5A1", "N5A2", "N…
$ clutch_completion <chr> "Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "No", "No", "Yes", "Yes", "Yes", "Yes", …
$ date_egg          <chr> "11/11/2007", "11/11/2007", "16/11/2007", "16/11/2007", "16/11/2007", "16/11/2007"…
$ sex               <chr> "MALE", "FEMALE", "FEMALE", NA, "FEMALE", "MALE", "FEMALE", "MALE", NA, NA, NA, NA…
$ comments          <chr> "Not enough blood for isotopes.", NA, NA, "Adult not sampled.", NA, NA, "Nest neve…
```

Other "predicate functions" include

- is.double

- is.numeric

- is.logical

- is.factor

- is.integer


## Combos

Using standard logical operators such as `|` and `&` we can string together different combinations of selection criteria:

Here the column must be of type numeric *or* the title contains "species"


```r
penguins_clean |> 
  select(where(is.numeric) | contains("species")) |> 
  glimpse()
```
```
Rows: 344
Columns: 8
$ sample_number     <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,…
$ culmen_length_mm  <dbl> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, 42.0, 37.8, 37.8, 41.1, 38.6, …
$ culmen_depth_mm   <dbl> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1, 20.2, 17.1, 17.3, 17.6, 21.2, …
$ flipper_length_mm <dbl> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 186, 180, 182, 191, 198, 185, 195…
$ body_mass_g       <dbl> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475, 4250, 3300, 3700, 3200, 3800, …
$ delta_15_n_o_oo   <dbl> NA, 8.94956, 8.36821, NA, 8.76651, 8.66496, 9.18718, 9.46060, NA, 9.13362, 8.63243…
$ delta_13_c_o_oo   <dbl> NA, -24.69454, -25.33302, NA, -25.32426, -25.29805, -25.21799, -24.89958, NA, -25.…
$ species           <chr> "Adelie Penguin (Pygoscelis adeliae)", "Adelie Penguin (Pygoscelis adeliae)", "Ade…

```


# Modifying variables

## count

Counting is one of the most common tasks you do when working with data. Counting may
sound simple, but it can get complicated quickly. Consider these examples:

- Sometimes we want to count with continuous variables. Suppose you have a year variable
in your data frame that is of data type integer (e.g. 1982, 1945, 1990). You want to
know the number of people for each decade. To do this, you must first convert your year
variable to decades before you start counting.

-  Often you want to count things per group (for example, the number of players on a
particular sports team) and add the counts per group as a new variable to your data
frame. You could use joins to do this, but could you do it with less code and more
efficiently?

In this example, we have created a new variable body_mass_intervals that is calculated from the variable body_mass_g. We also used the name argument to give the count column a more descriptive name.


```r
penguins_clean |> 
  count(body_mass_intervals = cut_width(body_mass_g, 100))
```

<div class="kable-table">

|body_mass_intervals |  n|
|:-------------------|--:|
|[2.65e+03,2.75e+03] |  1|
|(2.75e+03,2.85e+03] |  2|
|(2.85e+03,2.95e+03] |  5|
|(2.95e+03,3.05e+03] |  7|
|(3.05e+03,3.15e+03] |  6|
|(3.15e+03,3.25e+03] | 12|
|(3.25e+03,3.35e+03] | 17|
|(3.35e+03,3.45e+03] | 18|
|(3.45e+03,3.55e+03] | 21|
|(3.55e+03,3.65e+03] | 15|
|(3.65e+03,3.75e+03] | 21|
|(3.75e+03,3.85e+03] | 18|
|(3.85e+03,3.95e+03] | 21|
|(3.95e+03,4.05e+03] | 12|
|(4.05e+03,4.15e+03] | 12|
|(4.15e+03,4.25e+03] | 10|
|(4.25e+03,4.35e+03] | 11|
|(4.35e+03,4.45e+03] | 14|
|(4.45e+03,4.55e+03] |  6|
|(4.55e+03,4.65e+03] | 13|
|(4.65e+03,4.75e+03] | 15|
|(4.75e+03,4.85e+03] |  8|
|(4.85e+03,4.95e+03] |  9|
|(4.95e+03,5.05e+03] | 10|
|(5.05e+03,5.15e+03] |  5|
|(5.15e+03,5.25e+03] |  7|
|(5.25e+03,5.35e+03] |  7|
|(5.35e+03,5.45e+03] |  6|
|(5.45e+03,5.55e+03] | 11|
|(5.55e+03,5.65e+03] |  5|
|(5.65e+03,5.75e+03] |  6|
|(5.75e+03,5.85e+03] |  5|
|(5.85e+03,5.95e+03] |  2|
|(5.95e+03,6.05e+03] |  3|
|(6.25e+03,6.35e+03] |  1|
|NA                  |  2|

</div>
You can see that the bins each have a range of 10. Also, the bins are surrounded by square brackets and parentheses. A parenthesis means that the number is included in the bin, a square bracket means that a number is **not** included in the bin,  In our second example, this would mean that 2.75e+03 is included, but not 2.85e+03.


## extract

This code is using the `separate` function from the `tidyr` package to split the "species" column in the penguins_clean data frame into two separate columns: "species" and "full_latin_name." The separation is based on a specific delimiter, which is an opening parenthesis `(`.


```r
penguins_clean |> 
  separate(species,
          into = c("species", "full_latin_name"),
          sep = "\\("
          )
```

This approach reaches its limits quite quickly - note here it has left an ugly `)` on the end of the second column. There are also issues when we lack a clear separator to distinguish the columns we want to create. For these use cases we have extract.

Now suppose you want to separate the common names and latin names of the species variable by regex:


```r
penguins_clean_split <- penguins_clean |> 
  extract(species,
          into = c("species", "full_latin_name"),
          regex = "(\\w+) .* \\(([^)]+)\\)"
          )
penguins_clean_split |> colnames()
```

```
##  [1] "study_name"        "sample_number"     "species"          
##  [4] "full_latin_name"   "region"            "island"           
##  [7] "stage"             "individual_id"     "clutch_completion"
## [10] "date_egg"          "culmen_length_mm"  "culmen_depth_mm"  
## [13] "flipper_length_mm" "body_mass_g"       "sex"              
## [16] "delta_15_n_o_oo"   "delta_13_c_o_oo"   "comments"
```

- The first group captures one or more word characters (\\w+).

-  `.*` this captures any characters in the string but doesn't capture them

- The last group contains anything found inside brackets `()`

  - `\\(` finds an open bracket but does not capture it    
  - `([^)]+)` captures anything except a closing parenthesis
  
# Factors

## Anonymising factors

Sometimes you want to make your data completely anonymous so that other people can’t see sensitive information. Or because you wish to blind you own analyses we can do this with `forcats::fct_anon` 


```r
penguins_clean_split |> 
  mutate(species = fct_anon(species,
         prefix = "species_"))
```

## Lump factors

`fct_lump_min()` is a function from the `forcats` package in R, which is used to lump or group together levels of a categorical variable in a way that keeps the most common levels intact while grouping the less common levels into an "Other" or "Miscellaneous" category.

In this example, any species not represented by at least 150 observations, will be lumped into an "Other" category:


```r
penguins_clean_split |> 
  mutate(body_size = fct_lump_min(as_factor(species), 150)) |> 
  ggplot(aes(x = body_size,
         y = flipper_length_mm))+
  geom_boxplot()
```

## Ordering factors

With the `fct_relevel` function we can set factors and apply a specified level at the same time:


```r
penguins_clean_split |> 
  mutate(species = fct_relevel(species, "Adelie", "Chinstrap", "Gentoo")) |> 
  ggplot(aes(x = species))+
  geom_bar()+
  coord_flip()
```

<img src="05-tidyverse_files/figure-html/unnamed-chunk-30-1.png" width="100%" style="display: block; margin: auto;" />

With the function `fct_infreq` we can change the order according to how frequently each level occurs


```r
penguins_clean_split |> 
  mutate(species = fct_infreq(species)) |> 
  ggplot(aes(x = species))+
  geom_bar()+
  coord_flip()
```

<img src="05-tidyverse_files/figure-html/unnamed-chunk-31-1.png" width="100%" style="display: block; margin: auto;" />


The `fct_rev()` function in R is used to reverse the order of levels in a factor variable. It is particularly useful for changing the order of factor levels when you want to display data in a reversed or descending order.


```r
penguins_clean_split |> 
  mutate(species = fct_rev(as_factor(species))) |> 
  ggplot(aes(x = species))+
  geom_bar()+
  coord_flip()
```

<img src="05-tidyverse_files/figure-html/unnamed-chunk-32-1.png" width="100%" style="display: block; margin: auto;" />

The `fct_reorder` function allows us to order the levels based on another continuous variable


```r
penguins_clean_split |> 
  mutate(species = as_factor(species) |> 
           fct_reorder(body_mass_g,
                       .fun = median)) |> 
  # by default the levels are ordered by the median values of the continuous variable
  # mean, min and max can all be included here
  ggplot(aes(x = species,
             y = body_mass_g,
             colour = species))+
  geom_boxplot(width = .2,
               outlier.shape = NA)+
  geom_jitter(width = .2,
              alpha = .4)
```

<img src="05-tidyverse_files/figure-html/unnamed-chunk-33-1.png" width="100%" style="display: block; margin: auto;" />


# Applying functions across columns

One of the credos of programming is “Don’t repeat yourself”. We have seen in previous tutorials that many of us fall victim to this principle quite often. Fortunately, the tidyverse team has developed a set of functions that make it easier not to repeat ourselves: 

## calculate summary statistics across columns

In this example I am generating summary statistics for two columns, but I can make this process more efficient: 


```r
penguins_clean_split |> 
  group_by(species) |> 
  summarise(
    mean_body_mass = mean(body_mass_g, na.rm = T),
    mean_flipper_length = mean(flipper_length_mm, na.rm = T)
  )
```


A couple of things are important here:

• The function across only works inside dplyr verbs (e.g. mutate)

• The function has three important arguments: .cols stands for the column to apply a
function to. You can use the tidyselect functions here; .fns stands for the function(s)
that will be applied to these columns; .names is used whenever you want to change the
names of the selected columns.

Each use case will work with this general structure:

```
<DFRAME> |> 
<DPLYR VERB>(
across(
.cols = <SELECTION OF COLUMNS>,
.fns = <FUNCTION TO BE APPLIED TO EACH COLUMN>,
.names = <NAME OF THE GENERATED COLUMNS>
)
)
```

Instead you can use the across function to get the same result, here I could supply column names `.cols = c("body_mass_g", "flipper_length_mm")` or can I use `where` to get whole column types  :


```r
penguins_clean_split |> 
  group_by(species) |> 
  summarise(
    across(
      .cols = where(is.numeric),
      .fns = ~mean(.x, na.rm = T),
      .names = "mean_{.col}")
    )
```

<div class="kable-table">

|species   | mean_sample_number| mean_culmen_length_mm| mean_culmen_depth_mm| mean_flipper_length_mm| mean_body_mass_g| mean_delta_15_n_o_oo| mean_delta_13_c_o_oo|
|:---------|------------------:|---------------------:|--------------------:|----------------------:|----------------:|--------------------:|--------------------:|
|Adelie    |               76.5|              38.79139|             18.34636|               189.9536|         3700.662|             8.859733|            -25.80419|
|Chinstrap |               34.5|              48.83382|             18.42059|               195.8235|         3733.088|             9.356155|            -24.54654|
|Gentoo    |               62.5|              47.50488|             14.98211|               217.1870|         5076.016|             8.245338|            -26.18530|

</div>

## Change variable types across columns


```r
penguins_clean_split |> 
  mutate(
    across(.cols = c("species", "island", "region"),
           .fns = as_factor)
  ) |> 
  select(where(is.factor)) |> 
  glimpse()
```

```
## Rows: 344
## Columns: 3
## $ species <fct> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adelie…
## $ region  <fct> Anvers, Anvers, Anvers, Anvers, Anvers, Anvers, Anvers, Anvers…
## $ island  <fct> Torgersen, Torgersen, Torgersen, Torgersen, Torgersen, Torgers…
```

```
Rows: 344
Columns: 3
$ species <fct> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adel…
$ region  <fct> Anvers, Anvers, Anvers, Anvers, Anvers, Anvers, Anvers, Anvers, Anvers, Anve…
$ island  <fct> Torgersen, Torgersen, Torgersen, Torgersen, Torgersen, Torgersen, Torgersen,…
```


## Correct typos

We can use the `across` functions to quickly change typos across multiple columns at once, here is an example:


```r
x <- c("Adelie", "adelie", "pinstrap", "Chinstrap")
y <- c("adelie", "Adelie", "Chinstrap","Chinstrap")

typo_df <- tibble(x,y)
```



```r
typo_df |> 
  mutate(across(
    .cols = everything(),
    .fns = ~ case_when(
      str_detect(., "adelie") ~ str_replace(., "adelie", "Adelie"),
      str_detect(., "pinstrap") ~ str_replace(., "pinstrap", "Chinstrap"),
      TRUE ~ .
    )
  ))
```

<div class="kable-table">

|x         |y         |
|:---------|:---------|
|Adelie    |Adelie    |
|Adelie    |Adelie    |
|Chinstrap |Chinstrap |
|Chinstrap |Chinstrap |

</div>


# Working with rows

## Filtering rows based on conditions across multiple columns

Suppose you want to filter multiple rows from your data frame that fail to meet a criteria.


```r
penguins_clean_split |> 
  filter(
    if_any(.cols = contains("culmen"),
           .fns = ~. < 40)
  ) |> 
  glimpse()
```



## filter rows based on missing values

Another very useful use case is filtering rows based on missing values across multiple columns.


```r
penguins_clean_split |> 
  filter(
    if_all(.cols = where(is.numeric),
           .fns = ~!is.na(.))
  ) 
```


<div class="try">
<p>At first the outcome above can seem counter-intuitive, but can be
explained by the <code>!</code> operator. The if_all is evaluating
whether all columns meet the condition of NOT containing NA.</p>
<p>You can try different combinations of if_all, if_any and the NOT
operator</p>
</div>

## slicing

Suppose we want to remove the 10 highest values of body mass from our dataframe - we could do this with `slice`



```r
penguins_clean_split |> 
  arrange(desc(body_mass_g)) |> 
  slice(1:10)
```

<div class="kable-table">

|study_name | sample_number|species |full_latin_name  |region |island |stage              |individual_id |clutch_completion |date_egg   | culmen_length_mm| culmen_depth_mm| flipper_length_mm| body_mass_g|sex  | delta_15_n_o_oo| delta_13_c_o_oo|comments |
|:----------|-------------:|:-------|:----------------|:------|:------|:------------------|:-------------|:-----------------|:----------|----------------:|---------------:|-----------------:|-----------:|:----|---------------:|---------------:|:--------|
|PAL0708    |            18|Gentoo  |Pygoscelis papua |Anvers |Biscoe |Adult, 1 Egg Stage |N39A2         |Yes               |2007-11-27 |             49.2|            15.2|               221|        6300|MALE |         8.27376|       -25.00169|NA       |
|PAL0708    |            34|Gentoo  |Pygoscelis papua |Anvers |Biscoe |Adult, 1 Egg Stage |N56A2         |Yes               |2007-12-03 |             59.6|            17.0|               230|        6050|MALE |         7.76843|       -25.68210|NA       |
|PAL0809    |            78|Gentoo  |Pygoscelis papua |Anvers |Biscoe |Adult, 1 Egg Stage |N58A2         |Yes               |2008-11-06 |             51.1|            16.3|               220|        6000|MALE |         8.40327|       -26.76821|NA       |
|PAL0910    |           118|Gentoo  |Pygoscelis papua |Anvers |Biscoe |Adult, 1 Egg Stage |N36A2         |Yes               |2009-12-01 |             48.8|            16.2|               222|        6000|MALE |         8.33825|       -25.88547|NA       |
|PAL0809    |            80|Gentoo  |Pygoscelis papua |Anvers |Biscoe |Adult, 1 Egg Stage |N60A2         |Yes               |2008-11-09 |             45.2|            16.4|               223|        5950|MALE |         8.19749|       -26.65931|NA       |
|PAL0910    |           112|Gentoo  |Pygoscelis papua |Anvers |Biscoe |Adult, 1 Egg Stage |N32A2         |Yes               |2009-11-20 |             49.8|            15.9|               229|        5950|MALE |         8.29226|       -26.21019|NA       |
|PAL0708    |            14|Gentoo  |Pygoscelis papua |Anvers |Biscoe |Adult, 1 Egg Stage |N37A2         |Yes               |2007-11-29 |             48.4|            14.6|               213|        5850|MALE |         7.82080|       -25.48025|NA       |
|PAL0708    |            16|Gentoo  |Pygoscelis papua |Anvers |Biscoe |Adult, 1 Egg Stage |N38A2         |Yes               |2007-12-03 |             49.3|            15.7|               217|        5850|MALE |         8.07137|       -25.52473|NA       |
|PAL0910    |           116|Gentoo  |Pygoscelis papua |Anvers |Biscoe |Adult, 1 Egg Stage |N35A2         |Yes               |2009-11-25 |             55.1|            16.0|               230|        5850|MALE |         8.08354|       -26.18161|NA       |
|PAL0809    |            68|Gentoo  |Pygoscelis papua |Anvers |Biscoe |Adult, 1 Egg Stage |N51A2         |Yes               |2008-11-09 |             49.5|            16.2|               229|        5800|MALE |         8.49854|       -26.74809|NA       |

</div>


`slice` keeps all rows for which you specify positive indices. Note that in R indexing starts with 1 and not with 0 as in most other programming languages. To make it more clear what rows slice keeps, let’s add row numbers to our data frame and slice some arbitrary rows:


```r
penguins_clean_split |> 
  arrange(desc(body_mass_g)) |> 
  rownames_to_column(var = "row_number") |> 
  slice(c(1,123,307))
```

<div class="kable-table">

|row_number |study_name | sample_number|species   |full_latin_name       |region |island |stage              |individual_id |clutch_completion |date_egg   | culmen_length_mm| culmen_depth_mm| flipper_length_mm| body_mass_g|sex    | delta_15_n_o_oo| delta_13_c_o_oo|comments                              |
|:----------|:----------|-------------:|:---------|:---------------------|:------|:------|:------------------|:-------------|:-----------------|:----------|----------------:|---------------:|-----------------:|-----------:|:------|---------------:|---------------:|:-------------------------------------|
|1          |PAL0708    |            18|Gentoo    |Pygoscelis papua      |Anvers |Biscoe |Adult, 1 Egg Stage |N39A2         |Yes               |2007-11-27 |             49.2|            15.2|               221|        6300|MALE   |         8.27376|       -25.00169|NA                                    |
|123        |PAL0809    |            59|Gentoo    |Pygoscelis papua      |Anvers |Biscoe |Adult, 1 Egg Stage |N17A1         |Yes               |2008-11-06 |             43.2|            14.5|               208|        4450|FEMALE |         8.48367|       -26.86485|NA                                    |
|307        |PAL0708    |            17|Chinstrap |Pygoscelis antarctica |Anvers |Dream  |Adult, 1 Egg Stage |N71A1         |No                |2007-11-30 |             50.3|            20.0|               197|        3300|MALE   |        10.02019|       -24.54704|Nest never observed with full clutch. |

</div>

To remove specific rows, we can use negative indices. Suppose, we want to remove the first 340 rows from our data frame.


```r
penguins_clean_split |> 
  arrange(desc(body_mass_g)) |> 
  rownames_to_column(var = "row_number") |> 
  slice(c(-1:-340))
```

<div class="kable-table">

|row_number |study_name | sample_number|species   |full_latin_name       |region |island    |stage              |individual_id |clutch_completion |date_egg   | culmen_length_mm| culmen_depth_mm| flipper_length_mm| body_mass_g|sex    | delta_15_n_o_oo| delta_13_c_o_oo|comments                                                 |
|:----------|:----------|-------------:|:---------|:---------------------|:------|:---------|:------------------|:-------------|:-----------------|:----------|----------------:|---------------:|-----------------:|-----------:|:------|---------------:|---------------:|:--------------------------------------------------------|
|341        |PAL0809    |            65|Adelie    |Pygoscelis adeliae    |Anvers |Biscoe    |Adult, 1 Egg Stage |N29A1         |Yes               |2008-11-13 |             36.4|            17.1|               184|        2850|FEMALE |         8.62623|       -26.11650|NA                                                       |
|342        |PAL0809    |            39|Chinstrap |Pygoscelis antarctica |Anvers |Dream     |Adult, 1 Egg Stage |N72A1         |No                |2008-11-24 |             46.9|            16.6|               192|        2700|FEMALE |         9.80589|       -24.73735|Nest never observed with full clutch.                    |
|343        |PAL0708    |             4|Adelie    |Pygoscelis adeliae    |Anvers |Torgersen |Adult, 1 Egg Stage |N2A2          |Yes               |2007-11-16 |               NA|              NA|                NA|          NA|NA     |              NA|              NA|Adult not sampled.                                       |
|344        |PAL0910    |           120|Gentoo    |Pygoscelis papua      |Anvers |Biscoe    |Adult, 1 Egg Stage |N38A2         |No                |2009-12-01 |               NA|              NA|                NA|          NA|NA     |              NA|              NA|Adult not sampled. Nest never observed with full clutch. |

</div>

Helper functions include `slice_head()`, `slice_tail()`, `slice_max()`, `slice_min()` and `slice_sample()`
We can use these functions to more quickly and easily filter our data under some situations


```r
penguins_clean_split |> 
  slice_max(order_by = body_mass_g,
            n = 20) |> # we can also use prop e.g. prop =.1 to slice the top 10%
  select(species, body_mass_g)
```

<div class="kable-table">

|species | body_mass_g|
|:-------|-----------:|
|Gentoo  |        6300|
|Gentoo  |        6050|
|Gentoo  |        6000|
|Gentoo  |        6000|
|Gentoo  |        5950|
|Gentoo  |        5950|
|Gentoo  |        5850|
|Gentoo  |        5850|
|Gentoo  |        5850|
|Gentoo  |        5800|
|Gentoo  |        5800|
|Gentoo  |        5750|
|Gentoo  |        5700|
|Gentoo  |        5700|
|Gentoo  |        5700|
|Gentoo  |        5700|
|Gentoo  |        5700|
|Gentoo  |        5650|
|Gentoo  |        5650|
|Gentoo  |        5650|

</div>

## groupwise slicing

To apply these functions within different sub-categories, we have to use `group_by()`


```r
penguins_clean_split |> 
  group_by(species) |> 
  slice_max(order_by = body_mass_g,
            n = 3) |> 
  select(species, body_mass_g) |> 
  ungroup()
```

<div class="kable-table">

|species   | body_mass_g|
|:---------|-----------:|
|Adelie    |        4775|
|Adelie    |        4725|
|Adelie    |        4700|
|Chinstrap |        4800|
|Chinstrap |        4550|
|Chinstrap |        4500|
|Gentoo    |        6300|
|Gentoo    |        6050|
|Gentoo    |        6000|
|Gentoo    |        6000|

</div>

## bootstrapping with slice

If we set the replace argument to TRUE in `slice()`, we will perform sampling with replacement. This means the same row of data can appear twice in our dataframe. 


```r
slice_sample(penguins_clean_split, 
             prop = .5, 
             replace = TRUE) |> 
  duplicated() |> 
  sum()
```

```
## [1] 35
```


Why would we do this? This functionality allows us to create bootstraps from our data frame. Bootstrapping is a
technique where a set of samples of the same size are drawn from a single original sample.

Some values appear more than once because bootstrapping allows each value to be pulled multiple times from the original data set. Once you have your bootstraps, you can calculate metrics from them. For example, the mean value of each bootstrap. The underlying logic of this technique is that since the sample itself is from a population, the bootstraps act as proxies for other samples from that population. Now that we have created one bootstrap from our sample, we can create many. In the following code I have used map to create 100 bootstraps from my original sample:


```r
set.seed(342)
bootstraps <- map(1:100, 
                  ~slice_sample(penguins_clean_split, 
                                prop = .1, # 10% of dataframe
                                replace = TRUE))

bootstraps %>%
    map_dbl(~ mean(.$body_mass_g, na.rm = TRUE)) |> 
  tibble(x = _ ) |> 
ggplot(aes(x = x)) +
geom_histogram(fill = "grey80", color = "black")+
  geom_vline(data = penguins_clean_split,
             aes(xintercept = mean(body_mass_g, na.rm = T)),
             linewidth = 2, colour = "red", linetype  ="dashed")
```

<img src="05-tidyverse_files/figure-html/unnamed-chunk-48-1.png" width="100%" style="display: block; margin: auto;" />


# Group work

The [R4DS](https://r4ds.had.co.nz/many-models.html) book demonstrates how functions can be used to run multiple models simultaneously. This technique is valuable for extracting meaningful insights from your data.

To find out how well culmen length can predict culmen depth we build a linear regression model.

Once we have created the model, we can retrieve the results parameters and test statistics
with the summary function:
`summary(model)`


```r
model <- lm(culmen_depth_mm ~ culmen_length_mm, data = penguins_clean_split)

summary(model)
```

```
## 
## Call:
## lm(formula = culmen_depth_mm ~ culmen_length_mm, data = penguins_clean_split)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -4.1381 -1.4263  0.0164  1.3841  4.5255 
## 
## Coefficients:
##                  Estimate Std. Error t value Pr(>|t|)    
## (Intercept)      20.88547    0.84388  24.749  < 2e-16 ***
## culmen_length_mm -0.08502    0.01907  -4.459 1.12e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.922 on 340 degrees of freedom
##   (2 observations deleted due to missingness)
## Multiple R-squared:  0.05525,	Adjusted R-squared:  0.05247 
## F-statistic: 19.88 on 1 and 340 DF,  p-value: 1.12e-05
```

Now we know that there are important covariates to consider - and the most appropriate method from an analysis perspective would be to include these as covariates within a single model


```r
model <- lm(culmen_depth_mm ~ culmen_length_mm * species, data = penguins_clean_split)

summary(model)
```

```
Call:
lm(formula = culmen_depth_mm ~ culmen_length_mm * species, data = penguins_clean_split)

Residuals:
    Min      1Q  Median      3Q     Max 
-2.6574 -0.6675 -0.0524  0.5383  3.5032 

Coefficients:
                                  Estimate Std. Error t value Pr(>|t|)    
(Intercept)                       11.40912    1.13812  10.025  < 2e-16 ***
culmen_length_mm                   0.17883    0.02927   6.110 2.76e-09 ***
speciesChinstrap                  -3.83998    2.05398  -1.870 0.062419 .  
speciesGentoo                     -6.15812    1.75451  -3.510 0.000509 ***
culmen_length_mm:speciesChinstrap  0.04338    0.04558   0.952 0.341895    
culmen_length_mm:speciesGentoo     0.02601    0.04054   0.642 0.521590    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.9548 on 336 degrees of freedom
  (2 observations deleted due to missingness)
Multiple R-squared:  0.7697,	Adjusted R-squared:  0.7662 
F-statistic: 224.5 on 5 and 336 DF,  p-value: < 2.2e-16

```

However, there may be occasions where we wish to apply simple models to each subpopulation in turn:

First we need to `nest()` our data - tibbles with nested dataframes can be manipulated using various functions and operations to perform tasks like filtering, summarizing, and visualization. Nested dataframes also facilitate operations on a per-group basis, which can be useful for group-wise analysis. 

1. First we create a new nested dataframe 2. Then we run a model function (passing this through `broom::tidy()` to get a tibble friendly output) inside mutate. This will create a new column with nested tibbles in it. We then unnest the model to extract the terms for each Intercept and slope. 


```r
penguins |> 
    group_by(species) |> 
    nest() |> 
    mutate(model = map(data, ~ lm(culmen_depth_mm ~ culmen_length_mm, data = .) |> broom::tidy())) |> 
    unnest(model)
```

```
# A tibble: 6 × 7
# Groups:   species [3]
  species   data                term             estimate std.error statistic  p.value
  <chr>     <list>              <chr>               <dbl>     <dbl>     <dbl>    <dbl>
1 Adelie    <tibble [152 × 16]> (Intercept)        11.4      1.34        8.52 1.61e-14
2 Adelie    <tibble [152 × 16]> culmen_length_mm    0.179    0.0344      5.19 6.67e- 7
3 Gentoo    <tibble [124 × 16]> (Intercept)         5.25     1.05        4.98 2.15e- 6
4 Gentoo    <tibble [124 × 16]> culmen_length_mm    0.205    0.0222      9.24 1.02e-15
5 Chinstrap <tibble [68 × 16]>  (Intercept)         7.57     1.55        4.88 6.99e- 6
6 Chinstrap <tibble [68 × 16]>  culmen_length_mm    0.222    0.0317      7.01 1.53e- 9

```

# Pivot

## pivot wider

<div class="info">
<p>Un-tidy data violates one of these three principles in one way or
another:</p>
<p>• Each variable forms a column • Each observation forms a row • Each
type of observation unit is a table</p>
</div>



```r
wk1 <- c(1,2,4,5)
wk2 <- c(3,4,1,0)
wk3 <- c(0,0,2,0)
penguin_id <- c("N15A1" , "N15A2" , "N18A1", "N71A2")

peng_obs <- tibble(penguin_id, wk1,wk2,wk3)
```

This data is untidy because a value that measures the same underlying attribute (number of observations) is split across three columns. Here wk1,wk2 and wk3 represent the underlying variable of observations split across three weeks.

We can use pivot to create a tidy representation of the data


```r
peng_obs |> 
  pivot_longer(
    cols = "wk1":"wk3",
    names_to = "week",
    values_to = "observations"
  )
```

<div class="kable-table">

|penguin_id |week | observations|
|:----------|:----|------------:|
|N15A1      |wk1  |            1|
|N15A1      |wk2  |            3|
|N15A1      |wk3  |            0|
|N15A2      |wk1  |            2|
|N15A2      |wk2  |            4|
|N15A2      |wk3  |            0|
|N18A1      |wk1  |            4|
|N18A1      |wk2  |            1|
|N18A1      |wk3  |            2|
|N71A2      |wk1  |            5|
|N71A2      |wk2  |            0|
|N71A2      |wk3  |            0|

</div>

We can tidy this dataframe further by removing the "wk" prefix:


```r
peng_obs |> 
  pivot_longer(
    cols = "wk1":"wk3",
    names_to = "week",
    names_prefix = "wk",
    values_to = "observations"
  )
```

<div class="kable-table">

|penguin_id |week | observations|
|:----------|:----|------------:|
|N15A1      |1    |            1|
|N15A1      |2    |            3|
|N15A1      |3    |            0|
|N15A2      |1    |            2|
|N15A2      |2    |            4|
|N15A2      |3    |            0|
|N18A1      |1    |            4|
|N18A1      |2    |            1|
|N18A1      |3    |            2|
|N71A2      |1    |            5|
|N71A2      |2    |            0|
|N71A2      |3    |            0|

</div>
<div class="warning">
<p>Note that the week column is still being treated as a character
string. using <code>names_transform</code> we can fix this</p>
</div>


```r
peng_obs |> 
  pivot_longer(
    cols = "wk1":"wk3",
    names_to = "week",
    names_prefix = "wk",
    names_transform = as.integer,
    values_to = "observations"
  )
```

<div class="kable-table">

|penguin_id | week| observations|
|:----------|----:|------------:|
|N15A1      |    1|            1|
|N15A1      |    2|            3|
|N15A1      |    3|            0|
|N15A2      |    1|            2|
|N15A2      |    2|            4|
|N15A2      |    3|            0|
|N18A1      |    1|            4|
|N18A1      |    2|            1|
|N18A1      |    3|            2|
|N71A2      |    1|            5|
|N71A2      |    2|            0|
|N71A2      |    3|            0|

</div>

## pivot longer

Suppose you would like to make a data frame wider because you would like to present the results in a human-readable table. To do this, you can use pivot_wider and provide arguments for its main parameters:

- id_cols: These columns are the identifiers for the observations. These column names
remain unchanged in the data frame. Their values form the rows of the transformed data
frame. By default, all columns except those specified in names_from and values_from
become id_cols.

-  names_from: These columns will be transformed into a wider format. Their values will
be converted to columns. If you specify more than one column for names_from, the
newly created column names will be a combination of the column values.

- values_from: The values of these columns will be used for the columns created with
names_from.


## pivot wider for summary tables


```r
penguins_clean_split |> 
  group_by(species, island) |> 
  summarise(mean = mean(body_mass_g, na.rm = T))
```

<div class="kable-table">

|species   |island    |     mean|
|:---------|:---------|--------:|
|Adelie    |Biscoe    | 3709.659|
|Adelie    |Dream     | 3688.393|
|Adelie    |Torgersen | 3706.373|
|Chinstrap |Dream     | 3733.088|
|Gentoo    |Biscoe    | 5076.016|

</div>




```r
penguins_clean_split |> 
  group_by(species, island) |> 
  summarise(mean = mean(body_mass_g, na.rm = T)) |> 
  pivot_wider(names_from = c(species, island),
              values_from = mean,
              names_prefix = "mean_")
```

<div class="kable-table">

| mean_Adelie_Biscoe| mean_Adelie_Dream| mean_Adelie_Torgersen| mean_Chinstrap_Dream| mean_Gentoo_Biscoe|
|------------------:|-----------------:|---------------------:|--------------------:|------------------:|
|           3709.659|          3688.393|              3706.373|             3733.088|           5076.016|

</div>

# Writing Functions in Tidyverse

The goal here is to understand how to use tidy evaluation to write functions that incorporate `{tidyverse}` functions e.g. (mutate, select, filter) etc. 

Below is an example of some code to select a variable:


```r
penguins_clean_split |> 
  select(species)
```

Put that exact working code into a function


```r
test_function <- function(select_var){
  penguins_clean_split |> 
  select(select_var)
}

test_function(select_var = species)
```

```
Error: object 'species' not found

```

This error occurs becaus of *tidy evaluation*

<div class="info">
<p>Tidy evaluation: A framework for controlling how expressions and
variables in your code are evaluated by tidyverse functions.</p>
<ul>
<li><p>Allows programmers to select variables based on their position,
name, or type</p></li>
<li><p>Useful for passing variable names as inputs to functions that use
tidyverse packages like dplyr and ggplot2</p></li>
<li><p>{dplyr} verbs rely on tidy evaluation to resolve programming
commands</p></li>
</ul>
</div>

## Data masking

Data masking is a handy feature of tidyverse that makes it easier to program with dataframes. It allows you to reference columns wihout using `$`, whereas almost all base R functions use unmasked programming.

However, this makes it harder to create functions

Data masking is used by `arrange()`, `count()`, `filter()`, `group_by()`, `mutate()`, and `summarise()`. To check which type of tidy evaluation a function uses, check the help file. 


```r
test_filter_species <- function(filter_var) {
  penguins_clean_split %>%
    filter(species == filter_var)
}

test_filter_species("Adelie") %>%
  glimpse()
```

```
## Rows: 152
## Columns: 18
## $ study_name        <chr> "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708…
## $ sample_number     <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1…
## $ species           <chr> "Adelie", "Adelie", "Adelie", "Adelie", "Adelie", "A…
## $ full_latin_name   <chr> "Pygoscelis adeliae", "Pygoscelis adeliae", "Pygosce…
## $ region            <chr> "Anvers", "Anvers", "Anvers", "Anvers", "Anvers", "A…
## $ island            <chr> "Torgersen", "Torgersen", "Torgersen", "Torgersen", …
## $ stage             <chr> "Adult, 1 Egg Stage", "Adult, 1 Egg Stage", "Adult, …
## $ individual_id     <chr> "N1A1", "N1A2", "N2A1", "N2A2", "N3A1", "N3A2", "N4A…
## $ clutch_completion <chr> "Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "No", "No"…
## $ date_egg          <date> 2007-11-11, 2007-11-11, 2007-11-16, 2007-11-16, 200…
## $ culmen_length_mm  <dbl> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, …
## $ culmen_depth_mm   <dbl> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1, …
## $ flipper_length_mm <dbl> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 186…
## $ body_mass_g       <dbl> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475, …
## $ sex               <chr> "MALE", "FEMALE", "FEMALE", NA, "FEMALE", "MALE", "F…
## $ delta_15_n_o_oo   <dbl> NA, 8.94956, 8.36821, NA, 8.76651, 8.66496, 9.18718,…
## $ delta_13_c_o_oo   <dbl> NA, -24.69454, -25.33302, NA, -25.32426, -25.29805, …
## $ comments          <chr> "Not enough blood for isotopes.", NA, NA, "Adult not…
```

By passing quoted arguments to the function, you can use it directly in the expression, and the function will evaluate it as if it were part of the data frame. 


```r
test_filter_general <- function(filter_condition) {
  penguins_clean_split %>%
    filter(filter_condition)
}

test_filter_general("flipper_length_mm > 180") %>%
  glimpse()
```

```
Error in `filter()`:
ℹ In argument: `filter_condition`.
Caused by error:
! `..1` must be a logical vector, not the string "fliper_length_mm > 180".
Backtrace:
  1. test_filter_general("flipper_length_mm > 180") %>% glimpse()
 12. dplyr:::dplyr_internal_error(...)

```

However, we can avoid this by embracing the curly operators `{{.}}` this allows the data-masked argument to have its evaluation delayed until after the data frame columns are defined. With the `{{` operator you can tunnel data-variables (i.e. columns from the data frames) through arg-variables (function arguments). 


```r
test_filter_general <- function(filter_condition) {
  penguins_clean_split %>%
    filter({{filter_condition}})
}

test_filter_general(flipper_length_mm > 180) %>%
  glimpse()
```

```
## Rows: 329
## Columns: 18
## $ study_name        <chr> "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708…
## $ sample_number     <dbl> 1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, …
## $ species           <chr> "Adelie", "Adelie", "Adelie", "Adelie", "Adelie", "A…
## $ full_latin_name   <chr> "Pygoscelis adeliae", "Pygoscelis adeliae", "Pygosce…
## $ region            <chr> "Anvers", "Anvers", "Anvers", "Anvers", "Anvers", "A…
## $ island            <chr> "Torgersen", "Torgersen", "Torgersen", "Torgersen", …
## $ stage             <chr> "Adult, 1 Egg Stage", "Adult, 1 Egg Stage", "Adult, …
## $ individual_id     <chr> "N1A1", "N1A2", "N2A1", "N3A1", "N3A2", "N4A1", "N4A…
## $ clutch_completion <chr> "Yes", "Yes", "Yes", "Yes", "Yes", "No", "No", "Yes"…
## $ date_egg          <date> 2007-11-11, 2007-11-11, 2007-11-16, 2007-11-16, 200…
## $ culmen_length_mm  <dbl> 39.1, 39.5, 40.3, 36.7, 39.3, 38.9, 39.2, 34.1, 42.0…
## $ culmen_depth_mm   <dbl> 18.7, 17.4, 18.0, 19.3, 20.6, 17.8, 19.6, 18.1, 20.2…
## $ flipper_length_mm <dbl> 181, 186, 195, 193, 190, 181, 195, 193, 190, 186, 18…
## $ body_mass_g       <dbl> 3750, 3800, 3250, 3450, 3650, 3625, 4675, 3475, 4250…
## $ sex               <chr> "MALE", "FEMALE", "FEMALE", "FEMALE", "MALE", "FEMAL…
## $ delta_15_n_o_oo   <dbl> NA, 8.94956, 8.36821, 8.76651, 8.66496, 9.18718, 9.4…
## $ delta_13_c_o_oo   <dbl> NA, -24.69454, -25.33302, -25.32426, -25.29805, -25.…
## $ comments          <chr> "Not enough blood for isotopes.", NA, NA, NA, NA, "N…
```

Let's try another data-masked function


```r
summary_table <- function(df, var){
  df |> 
    summarise(mean = mean({{var}}, na.rm = T),
              sd = sd({{var}}, na.rm = T))
}

summary_table(penguins_clean_split, body_mass_g)
```

<div class="kable-table">

|     mean|       sd|
|--------:|--------:|
| 4201.754| 801.9545|

</div>

### Alternative to `{{}}`

The `{{.}}` is a shortcut for `!!enquo(.)` Where `rlang::enquo()` captures and quote an argument or an expression. The result of `enquo()` is a **quosure**, which is a combination of the quoted expression and its associated environment. 

`!!` This is the unquote operator. It's used to unquote or unsplice the contents of a quosure. In other words, it takes the quoted expression out of the quosure and evaluates it. We can see how this would work for one of our previous examples: 


```r
test_filter_general <- function(filter_condition) {
  
  filter_quo <- enquo(filter_condition)
  
  penguins_clean_split %>%
    filter(!!filter_quo)
}

test_filter_general(flipper_length_mm > 180) %>%
  glimpse()
```

```
## Rows: 329
## Columns: 18
## $ study_name        <chr> "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708…
## $ sample_number     <dbl> 1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, …
## $ species           <chr> "Adelie", "Adelie", "Adelie", "Adelie", "Adelie", "A…
## $ full_latin_name   <chr> "Pygoscelis adeliae", "Pygoscelis adeliae", "Pygosce…
## $ region            <chr> "Anvers", "Anvers", "Anvers", "Anvers", "Anvers", "A…
## $ island            <chr> "Torgersen", "Torgersen", "Torgersen", "Torgersen", …
## $ stage             <chr> "Adult, 1 Egg Stage", "Adult, 1 Egg Stage", "Adult, …
## $ individual_id     <chr> "N1A1", "N1A2", "N2A1", "N3A1", "N3A2", "N4A1", "N4A…
## $ clutch_completion <chr> "Yes", "Yes", "Yes", "Yes", "Yes", "No", "No", "Yes"…
## $ date_egg          <date> 2007-11-11, 2007-11-11, 2007-11-16, 2007-11-16, 200…
## $ culmen_length_mm  <dbl> 39.1, 39.5, 40.3, 36.7, 39.3, 38.9, 39.2, 34.1, 42.0…
## $ culmen_depth_mm   <dbl> 18.7, 17.4, 18.0, 19.3, 20.6, 17.8, 19.6, 18.1, 20.2…
## $ flipper_length_mm <dbl> 181, 186, 195, 193, 190, 181, 195, 193, 190, 186, 18…
## $ body_mass_g       <dbl> 3750, 3800, 3250, 3450, 3650, 3625, 4675, 3475, 4250…
## $ sex               <chr> "MALE", "FEMALE", "FEMALE", "FEMALE", "MALE", "FEMAL…
## $ delta_15_n_o_oo   <dbl> NA, 8.94956, 8.36821, 8.76651, 8.66496, 9.18718, 9.4…
## $ delta_13_c_o_oo   <dbl> NA, -24.69454, -25.33302, -25.32426, -25.29805, -25.…
## $ comments          <chr> "Not enough blood for isotopes.", NA, NA, NA, NA, "N…
```

## tidy-select

When using functions that use tidy-select, we put variable names in quotes and use th `all_of` and `any_of` functions.


```r
my_select_function <- function(select_variable){
  penguins_clean_split |> 
    dplyr::select(select_variable)
  }

my_select_function(species) |> 
  glimpse()
```

```
Error: object 'species' not found

```


```r
my_select_function <- function(select_variable){
  penguins_clean_split |> 
    dplyr::select(select_variable)
  }

my_select_function("species") |> 
  glimpse()
```

```
Warning: Using an external vector in selections was deprecated in tidyselect 1.1.0.
Please use `all_of()` or `any_of()` instead.
# Was:
data %>% select(select_variable)

# Now:
data %>% select(all_of(select_variable))

```

- `any_of()`: selecting any of the listed variables

- `all_of()`: for strict selection. If any of the variables in the character vector is missing, an error is thrown

- Can also use `!all_of()` to select all variables not found in the character vector supplied to all_of()



```r
my_select_function <- function(select_variable){
  penguins_clean_split |> 
    dplyr::select(dplyr::all_of(select_variable))
  }

my_select_function(select_variable = c("species", "sex")) |> 
  glimpse()
```

```
## Rows: 344
## Columns: 2
## $ species <chr> "Adelie", "Adelie", "Adelie", "Adelie", "Adelie", "Adelie", "A…
## $ sex     <chr> "MALE", "FEMALE", "FEMALE", NA, "FEMALE", "MALE", "FEMALE", "M…
```




## Practice


<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 

Write a `function` that uses filter to take any two of the penguin species then selects one numeric variable e.g. body_mass_g and compares them with a violin plot geom_violin()

 </div></div>



<button id="displayTextunnamed-chunk-72" onclick="javascript:toggle('unnamed-chunk-72');">Show Solution</button>

<div id="toggleTextunnamed-chunk-72" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
compare_species_plot <- function(data, species_1, species_2, feature) {
    
  filtered_data <- data |> 
        filter(species %in% c(species_1, species_2))
    
    # Create a conditional ggplot
    ggplot(filtered_data, aes(x = species, y = {{feature}}))+ 
      geom_violin()
        

}

compare_species_plot(penguins_clean_split, "Adelie", "Chinstrap", culmen_length_mm)
```

<img src="05-tidyverse_files/figure-html/unnamed-chunk-77-1.png" width="100%" style="display: block; margin: auto;" />
</div></div></div>

Try substituting in `quo_name(enquo(filter_condition))`. To return a character string that represents your filter condition. In the example below I have used `quo_name(enquo())` to enable conversion to character strings, this means all of the function arguments can be provided without "quotes". 

<button id="displayTextunnamed-chunk-73" onclick="javascript:toggle('unnamed-chunk-73');">Show Solution</button>

<div id="toggleTextunnamed-chunk-73" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
compare_species_plot <- function(data, species_1, species_2, feature) {
    
   
    
    # Quote species_1 and species_2 using quosures
    species_1_quo <- quo_name(enquo(species_1))
    species_2_quo <- quo_name(enquo(species_2))
    

    filtered_data <- data |> 
        filter(species %in% c(species_1_quo, species_2_quo))
    
    # Create a conditional ggplot
    ggplot(filtered_data, aes(x = species, y = {{feature}})) +
        geom_violin()
}

# Example usage without quotes for species names

compare_species_plot(penguins_clean_split, Adelie, Chinstrap, culmen_length_mm)
```
</div></div></div>


## Exercise


**1.Practice tidy evaluation** I want to produce a function that allows unquoted arguments and produces a barplot of the number of penguins recorded by species. In this instance I am going to start with a function where I can filter the penguins according to one variable and fill the columns according to another variable e.g. filter by year and colour by island to get a year-by-year abundance chart

Try and write a specific example first:

<button id="displayTextunnamed-chunk-74" onclick="javascript:toggle('unnamed-chunk-74');">Show Solution</button>

<div id="toggleTextunnamed-chunk-74" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
penguins|> 
  filter(year == 2007) |> 
  ggplot(aes(x=species, fill=island))+
  geom_bar(position=position_dodge2(preserve="single"))+
  coord_flip()
```

<img src="05-tidyverse_files/figure-html/unnamed-chunk-77-1.png" width="100%" style="display: block; margin: auto;" />

</div></div></div>


Then abstract this and use bare (unquoted) values in your arguments

<button id="displayTextunnamed-chunk-75" onclick="javascript:toggle('unnamed-chunk-75');">Show Solution</button>

<div id="toggleTextunnamed-chunk-75" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
plot_count <- function(filter_condition, colour_variable){
penguins|> 
  filter({{filter_condition}}) |> 
  ggplot(aes(x=species, fill={{colour_variable}}))+
  geom_bar(position=position_dodge2(preserve="single"))+
  coord_flip()
}

plot_count(year == 2007 , colour_variable = island)
```

<img src="05-tidyverse_files/figure-html/unnamed-chunk-78-1.png" width="100%" style="display: block; margin: auto;" />
</div></div></div>


**2. Write your own custom function** Can you write your own custom function in tidyverse? If you have something from your own data or work - see if you can functionalise your flow?




