# (PART\*) Data Wrangling {.unnumbered}

# Penguin project




In this workshop we will work through setting up a project and loading data. Once we have a curated and cleaned the dataset we can work on generating insights from the data.

As a biologist you should be used to asking questions and gathering data. It is also important that you learn all aspects of the research process. This includes responsible data management (understanding data files & spreadsheet organisation, keeping data safe) and data analysis.

In this chapter we will look at the structure of data files, and how to read these with R. We will also continue to develop reproducible scripts. This means that we are writing scripts that are well organised and easy to read, and also making sure that our scripts are complete and capable of reproducing an analysis from start to finish. 

Transparency and reproducibility are key values in scientific research, when you analyse data in a reproducible way it means that others can understand and check your work. It also means that the most important person can benefit from your work, YOU! When you return to an analysis after even a short break, you will be thanking your earlier self if you have worked in a clear and reproducible way, as you can pick up right where you left off.  


## Meet the Penguins

This data, taken from the `palmerpenguins` (@R-palmerpenguins) package was originally published by @Antarctic. In our course we will work with real data that has been shared by other researchers.

The palmer penguins data contains size measurements, clutch observations, and blood isotope ratios for three penguin species observed on three islands in the Palmer Archipelago, Antarctica over a study period of three years.

<img src="images/gorman-penguins.jpg" alt="Photo of three penguin species, Chinstrap, Gentoo, Adelie" width="80%" style="display: block; margin: auto;" />

These data were collected from 2007 - 2009 by Dr. Kristen Gorman with the Palmer Station Long Term Ecological Research Program, part of the US Long Term Ecological Research Network. The data were imported directly from the Environmental Data Initiative (EDI) Data Portal, and are available for use by CC0 license (“No Rights Reserved”) in accordance with the Palmer Station Data Policy. We gratefully acknowledge Palmer Station LTER and the US LTER Network. Special thanks to Marty Downs (Director, LTER Network Office) for help regarding the data license & use. Here is our intrepid package co-author, Dr. Gorman, in action collecting some penguin data:

<img src="images/penguin-expedition.jpg" alt="Photo of Dr Gorman in the middle of a flock of penguins" width="80%" style="display: block; margin: auto;" />

Here is a map of the study site

<img src="images/antarctica-map.png" alt="Antarctic Peninsula and the Palmer Field Station" width="80%" style="display: block; margin: auto;" />

## Activity 1: Organising our workspace

Before we can begin working with the data, we need to do some set-up. 

* Go to RStudio Cloud and open the `Penguins` R project

* Create the following folders using the + New Folder button in the Files tab

  * data
  * outputs
  * scripts
  

<div class="warning">
<p>R is case-sensitive so type everything EXACTLY as printed here</p>
</div>



```r
dir.create("data",
           showWarnings = FALSE)

dir.create("outputs",
           showWarnings = FALSE)

dir.create("scripts",
           showWarnings = FALSE)

# or this can be run using apply
lapply(c("data", "outputs", "scripts"), function(dir_name) {
  dir.create(dir_name, showWarnings = FALSE)
})
```

Having these separate subfolders within our project helps keep things tidy, means it's harder to lose things, and lets you easily tell R exactly where to go to retrieve data.  

The next step of our workflow is to have a well organised project space. RStudio Cloud does a lot of the hard work for you, each new data project can be set up with its own Project space. 

We will define a project as a series of linked questions that uses one (or sometimes several) datasets. For example a coursework assignment for a particular module would be its own project, a series of linked experiments or particular research project might be its own project.

A Project will contain several files, possibly organised into sub-folders containing data, R scripts and final outputs. You might want to keep any information (wider reading) you have gathered that is relevant to your project.

<div class="figure" style="text-align: center">
<img src="images/project.png" alt="An example of a typical R project set-up" width="80%" />
<p class="caption">(\#fig:unnamed-chunk-7)An example of a typical R project set-up</p>
</div>

Within this project you will notice there is already one file *.Rproj*. This is an R project file, this is a very useful feature, it interacts with R to tell it you are working in a very specific place on the computer (in this case the cloud server we have dialed into). It means R will automatically treat the location of your project file as the 'working directory' and makes importing and exporting easier^[More on projects can be found in the R4DS book (https://r4ds.had.co.nz/workflow-projects.html)]. 

<div class="warning">
<p>It is very important to NEVER to move the .Rproj file, this may
prevent your workspace from opening properly.</p>
</div>

## Activity 2: Access our data

Now that we have a project workspace, we are ready to import some data.

* Use the link below to open a page in your browser with the data open

* Right-click Save As to download in csv format to your computer (Make a note of **where** the file is being downloaded to e.g. Downloads)



```{=html}
<a href="https://raw.githubusercontent.com/UEABIO/data-sci-v1/main/book/files/penguins_raw.csv">
<button class="btn btn-success"><i class="fa fa-save"></i> Download penguin data as csv</button>
</a>
```



<div class="figure" style="text-align: center">
<img src="images/excel_csv.png" alt="excel view, csv view" width="80%" />
<p class="caption">(\#fig:unnamed-chunk-10)Top image: Penguins data viewed in Excel, Bottom image: Penguins data in native csv format</p>
</div>

In raw format, each line of a CSV is separated by commas for different values. When you open this in a spreadsheet program like Excel it automatically converts those comma-separated values into tables and columns. 


## Activity 3: Upload our data

* The data is now in your Downloads folder on your computer

* We need to upload the data to our remote cloud-server (RStudio Cloud), select the upload files to server button in the Files tab

* Put your file into the data folder - if you make a mistake select the tickbox for your file, go to the cogs button and choose the option Move.

<div class="figure" style="text-align: center">
<img src="images/upload.png" alt="File tab" width="80%" />
<p class="caption">(\#fig:unnamed-chunk-11)Highlighted the buttons to upload files, and more options</p>
</div>


### Read data from a url

It is also possible to use a url as a filepath


```r
read_csv("https://raw.githubusercontent.com/UEABIO/data-sci-v1/main/book/files/penguins_raw.csv")
```

## Activity 4: Make a script

Let's now create a new R script file in which we will write instructions and store comments for manipulating data, developing tables and figures. Use the `File > New Script` menu item and select an R Script. 

Add the following:


```r
#___________________________----
# SET UP ----
## An analysis of the bill dimensions of male and female Adelie, Gentoo and Chinstrap penguins ----

### Data first published in  Gorman, KB, TD Williams, and WR Fraser. 2014. “Ecological Sexual Dimorphism and Environmental Variability Within a Community of Antarctic Penguins (Genus Pygoscelis).” PLos One 9 (3): e90081. https://doi.org/10.1371/journal.pone.0090081. ----
#__________________________----
```

Then load the following add-on package to the R script, just underneath these comments. Tidyverse isn't actually one package, but a bundle of many different packages that play well together - for example it *includes* `ggplot2` which we used in the last session, so we don't have to call that separately

Add the following to your script:


```r
# PACKAGES ----
library(tidyverse) # tidy data packages
library(janitor) # cleans variable names
#__________________________----
```

Save this file inside the scripts folder and call it `01_import_penguins_data.R`

<div class="try">
<p>Click on the document outline button (top right of script pane). This
will show you how the use of the visual outline</p>
<p>Allows us to build a series of headers and subheaders, this is very
useful when using longer scripts.</p>
</div>

## Activity 5: Read in data

Now we can read in the data. To do this we will use the function `readr::read_csv()` that allows us to read in .csv files. There are also functions that allow you to read in .xlsx files and other formats, however in this course we will only use .csv files.

* First, we will create an object called `penguins_data` that contains the data in the `penguins_raw.csv` file. 

* Add the following to your script, and check the document outline:


<div class="tab"><button class="tablinksunnamed-chunk-16 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-16', 'unnamed-chunk-16');">Base R</button><button class="tablinksunnamed-chunk-16" onclick="javascript:openCode(event, 'option2unnamed-chunk-16', 'unnamed-chunk-16');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-16" class="tabcontentunnamed-chunk-16">

```r
penguins_raw <- read.csv("data/penguins_raw.csv")

# penguins_raw <- read.csv(here("data", "penguins_raw.csv"))

attributes(penguins_raw) # reads as data.frame

head(penguins_raw) # check the data has loaded, prints first 10 rows of dataframe
```
</div><div id="option2unnamed-chunk-16" class="tabcontentunnamed-chunk-16">

```r
# IMPORT DATA ----
penguins_raw <- read_csv ("data/penguins_raw.csv")

# penguins_raw <- read_csv(here("data", "penguins_raw.csv"))

attributes(penguins_raw) # reads as tibble

head(penguins_raw) # check the data has loaded, prints first 10 rows of dataframe
#__________________________----
```
</div><script> javascript:hide('option2unnamed-chunk-16') </script>


<div class="danger">
<p>Note the differences between <code>read.csv()</code> and
<code>read_csv</code>. We covered this in differences between tibbles
and dataframes - here most obviously is a difference in column
names.</p>
</div>


## Activity: Check your script


<div class='webex-solution'><button>Solution</button>



```r
#___________________________----
# SET UP ----
## An analysis of the bill dimensions of male and female Adelie, Gentoo and Chinstrap penguins ----

### Data first published in  Gorman, KB, TD Williams, and WR Fraser. 2014. “Ecological Sexual Dimorphism and Environmental Variability Within a Community of Antarctic Penguins (Genus Pygoscelis).” PLos One 9 (3): e90081. https://doi.org/10.1371/journal.pone.0090081. ----
#__________________________----

# PACKAGES ----
library(tidyverse) # tidy data packages
library(janitor) # cleans variable names
library(lubridate) # make sure dates are processed properly
#__________________________----

# IMPORT DATA ----
penguins_raw <- read_csv ("data/penguins_raw.csv")

head(penguins_raw) # check the data has loaded, prints first 10 rows of dataframe
#__________________________----
```


</div>


## Activity: Test yourself

**Question 1.** In order to make your R project reproducible what filepath should you use? 

<select class='webex-select'><option value='blank'></option><option value=''>Absolute filepath</option><option value='answer'>Relative filepath</option></select>

**Question 2.** Which of these would be acceptable to include in a raw datafile? 

<select class='webex-select'><option value='blank'></option><option value=''>Highlighting some blocks of cells</option><option value=''>Excel formulae</option><option value='answer'>A column of observational notes from the field</option><option value=''>a mix of ddmmyy and yymmdd date formats</option></select>

**Question 3.** What should always be the first set of functions in our script? `?()`

<input class='webex-solveme nospaces' size='9' data-answer='["library()"]'/>

**Question 4.** When reading in data to R we should use

<select class='webex-select'><option value='blank'></option><option value='answer'>read_csv()</option><option value=''>read.csv()</option></select>

**Question 5.** What format is the `penguins_raw` data in?

<select class='webex-select'><option value='blank'></option><option value=''>wide data</option><option value='answer'>long data</option></select>


<div class='webex-solution'><button>Explain This Answer</button>

Each column is a unique variable and each row is a unique observation so this data is in a long (tidy) format

</div>
  

**Question 6.** The working directory for your projects is by default set to the location of?

<select class='webex-select'><option value='blank'></option><option value=''>your data files</option><option value='answer'>the .Rproj file</option><option value=''>your R script</option></select>

**Question 7.** Using the filepath `"data/penguins_raw.csv"` is an example of 

<select class='webex-select'><option value='blank'></option><option value=''>an absolute filepath</option><option value='answer'>a relative filepath</option></select>

**Question 8.** What operator do I need to use if I wish to assign the output of the `read_csv` function to an R object (rather than just print the dataframe into the console)?

<input class='webex-solveme nospaces' size='2' data-answer='["<-"]'/>

# Data wrangling with dplyr







In this chapter you will learn how to use tidyverse functions to data clean and wrangle: 

## Activity 1: Change column names

We are going to learn how to organise data using the *tidy* format^[(http://vita.had.co.nz/papers/tidy-data.pdf)]. This is because we are using the `tidyverse` packages @R-tidyverse. This is an opinionated, but highly effective method for generating reproducible analyses with a wide-range of data manipulation tools. Tidy data is an easy format for computers to read. It is also the required data structure for our **statistical tests** that we will work with later.

Here 'tidy' refers to a specific structure that lets us manipulate and visualise data with ease. In a tidy dataset each *variable* is in one column and each row contains one *observation*. Each cell of the table/spreadsheet contains the *values*. One observation you might make about tidy data is it is quite long - it generates a lot of rows of data - you might remember then that *tidy* data can be referred to as *long*-format data (as opposed to *wide* data). 

<img src="images/tidy-1.png" alt="tidy data overview" width="80%" style="display: block; margin: auto;" />

So we know our data is in R, and we know the columns and names have been imported. But we still don't know whether all of our values imported correctly, or whether it captured all the rows. 

#### Add this to your script 


```r
# CHECK DATA----
# check the data
colnames(penguins_raw)
#__________________________----
```

When we run `colnames()` we get the identities of each column in our dataframe

* **Study name**: an identifier for the year in which sets of observations were made

* **Region**: the area in which the observation was recorded

* **Island**: the specific island where the observation was recorded

* **Stage**: Denotes reproductive stage of the penguin

* **Individual** ID: the unique ID of the individual

* **Clutch completion**: if the study nest observed with a full clutch e.g. 2 eggs

* **Date egg**: the date at which the study nest observed with 1 egg

* **Culmen length**: length of the dorsal ridge of the bird's bill (mm)

* **Culmen depth**: depth of the dorsal ridge of the bird's bill (mm)

* **Flipper Length**: length of bird's flipper (mm)

* **Body Mass**: Bird's mass in (g)

* **Sex**: Denotes the sex of the bird

* **Delta 15N** : the ratio of stable Nitrogen isotopes 15N:14N from blood sample

* **Delta 13C**: the ratio of stable Carbon isotopes 13C:12C from blood sample


#### Clean column names

Often we might want to change the names of our variables. They might be non-intuitive, or too long. Our data has a couple of issues:

* Some of the names contain spaces

* Some of the names have capitalised letters

* Some of the names contain brackets

This dataframe  does not like these so let's correct these quickly. R is case-sensitive and also doesn't like spaces or brackets in variable names


```r
# CLEAN DATA ----

# clean all variable names to snake_case using the clean_names function from the janitor package
# note we are using assign <- to overwrite the old version of penguins with a version that has updated names
# this changes the data in our R workspace but NOT the original csv file

penguins_clean <- janitor::clean_names(penguins_raw) # clean the column names

colnames(penguins_clean) # quickly check the new variable names
```

```
##  [1] "study_name"        "sample_number"     "species"          
##  [4] "region"            "island"            "stage"            
##  [7] "individual_id"     "clutch_completion" "date_egg"         
## [10] "culmen_length_mm"  "culmen_depth_mm"   "flipper_length_mm"
## [13] "body_mass_g"       "sex"               "delta_15_n_o_oo"  
## [16] "delta_13_c_o_oo"   "comments"
```

#### Rename columns (manually)

The `clean_names` function quickly converts all variable names into snake case. The N and C blood isotope ratio names are still quite long though, so let's clean those with `dplyr::rename()` where "new_name" = "old_name".

<div class="tab"><button class="tablinksunnamed-chunk-25 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-25', 'unnamed-chunk-25');">Base R</button><button class="tablinksunnamed-chunk-25" onclick="javascript:openCode(event, 'option2unnamed-chunk-25', 'unnamed-chunk-25');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-25" class="tabcontentunnamed-chunk-25">

```r
names(penguins)[names(penguins_clean) == "delta_15_n_o_oo"] <- "delta_15n"

names(penguins)[names(penguins_clean) == "delta_13_c_o_oo"] <- "delta_13c"
```
</div><div id="option2unnamed-chunk-25" class="tabcontentunnamed-chunk-25">

```r
# shorten the variable names for N and C isotope blood samples

penguins <- rename(penguins_clean,
         "delta_15n"="delta_15_n_o_oo",  # use rename from the dplyr package
         "delta_13c"="delta_13_c_o_oo")
```
</div><script> javascript:hide('option2unnamed-chunk-25') </script>

## Check data

#### glimpse: check data format 

When we run `glimpse()` we get several lines of output. The number of observations "rows", the number of variables "columns". Check this against the csv file you have - they should be the same. In the next lines we see variable names and the type of data. 


<div class="tab"><button class="tablinksunnamed-chunk-26 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-26', 'unnamed-chunk-26');">Base R</button><button class="tablinksunnamed-chunk-26" onclick="javascript:openCode(event, 'option2unnamed-chunk-26', 'unnamed-chunk-26');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-26" class="tabcontentunnamed-chunk-26">

```r
attributes(penguins)
```
</div><div id="option2unnamed-chunk-26" class="tabcontentunnamed-chunk-26">

```r
glimpse(penguins)
```
</div><script> javascript:hide('option2unnamed-chunk-26') </script>

We can see a dataset with 345 rows (including the headers) and 17 variables
It also provides information on the *type* of data in each column

* `<chr>` - means character or text data

* `<dbl>` - means numerical data

#### Rename text values

Sometimes we may want to rename the values in our variables in order to make a shorthand that is easier to follow. This is changing the **values** in our columns, not the column names. 


<div class="tab"><button class="tablinksunnamed-chunk-27 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-27', 'unnamed-chunk-27');">Base R</button><button class="tablinksunnamed-chunk-27" onclick="javascript:openCode(event, 'option2unnamed-chunk-27', 'unnamed-chunk-27');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-27" class="tabcontentunnamed-chunk-27">

```r
penguins$species <- ifelse(penguins$species == "Adelie Penguin (Pygoscelis adeliae)", "Adelie",
                          ifelse(penguins$species == "Gentoo penguin (Pygoscelis papua)", "Gentoo",
                                 ifelse(penguins$species == "Chinstrap penguin (Pygoscelis antarctica)", "Chinstrap",
                                        penguins$species)))
```
</div><div id="option2unnamed-chunk-27" class="tabcontentunnamed-chunk-27">

```r
# use mutate and case_when for a statement that conditionally changes the names of the values in a variable
penguins <- penguins |> 
  mutate(species = case_when(species == "Adelie Penguin (Pygoscelis adeliae)" ~ "Adelie",
                             species == "Gentoo penguin (Pygoscelis papua)" ~ "Gentoo",
                             species == "Chinstrap penguin (Pygoscelis antarctica)" ~ "Chinstrap"))
```
</div><script> javascript:hide('option2unnamed-chunk-27') </script>



<div class="warning">
<p>Have you checked that the above code block worked? Inspect your new
tibble and check the variables have been renamed as you wanted.</p>
</div>


## dplyr verbs

In this section we will be introduced to some of the most commonly used data wrangling functions, these come from the `dplyr` package (part of the `tidyverse`). These are functions you are likely to become *very* familiar with. 

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> verb </th>
   <th style="text-align:left;"> action </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> select() </td>
   <td style="text-align:left;"> take a subset of columns </td>
  </tr>
  <tr>
   <td style="text-align:left;"> filter() </td>
   <td style="text-align:left;"> take a subset of rows </td>
  </tr>
  <tr>
   <td style="text-align:left;"> arrange() </td>
   <td style="text-align:left;"> reorder the rows </td>
  </tr>
  <tr>
   <td style="text-align:left;"> summarise() </td>
   <td style="text-align:left;"> reduce raw data to user defined summaries </td>
  </tr>
  <tr>
   <td style="text-align:left;"> group_by() </td>
   <td style="text-align:left;"> group the rows by a specified column </td>
  </tr>
  <tr>
   <td style="text-align:left;"> mutate() </td>
   <td style="text-align:left;"> create a new variable </td>
  </tr>
</tbody>
</table>

</div>

### Select

If we wanted to create a dataset that only includes certain variables, we can use the `select()` function from the `dplyr` package. 

For example I might wish to create a simplified dataset that only contains `species`, `sex`, `flipper_length_mm` and `body_mass_g`. 

Run the below code to select only those columns

<div class="tab"><button class="tablinksunnamed-chunk-30 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-30', 'unnamed-chunk-30');">Base R</button><button class="tablinksunnamed-chunk-30" onclick="javascript:openCode(event, 'option2unnamed-chunk-30', 'unnamed-chunk-30');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-30" class="tabcontentunnamed-chunk-30">

```r
penguins[c("species", "sex", "flipper_length_mm", "body_mass_g")]
```
</div><div id="option2unnamed-chunk-30" class="tabcontentunnamed-chunk-30">

```r
# DPLYR VERBS ----

select(.data = penguins, # the data object
       species, sex, flipper_length_mm, body_mass_g) # the variables you want to select
```
</div><script> javascript:hide('option2unnamed-chunk-30') </script>

Alternatively you could tell R the columns you **don't** want e.g. 

<div class="tab"><button class="tablinksunnamed-chunk-31 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-31', 'unnamed-chunk-31');">Base R</button><button class="tablinksunnamed-chunk-31" onclick="javascript:openCode(event, 'option2unnamed-chunk-31', 'unnamed-chunk-31');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-31" class="tabcontentunnamed-chunk-31">

```r
penguins[, !colnames(penguins) %in% c("study_name", "sample_number")]
```
</div><div id="option2unnamed-chunk-31" class="tabcontentunnamed-chunk-31">

```r
select(.data = penguins,
       -study_name, -sample_number)
```
</div><script> javascript:hide('option2unnamed-chunk-31') </script>

Note that `select()` does **not** change the original `penguins` tibble. It spits out the new tibble directly into your console. 

If you don't **save** this new tibble, it won't be stored. If you want to keep it, then you must create a new object. 

When you run this new code, you will not see anything in your console, but you will see a new object appear in your Environment pane.


```r
new_penguins <- select(.data = penguins, 
       species, sex, flipper_length_mm, body_mass_g)
```

### Filter

Having previously used `select()` to select certain variables, we will now use `filter()` to select only certain rows or observations. For example only Adelie penguins. 

We can do this with the equivalence operator `==`

<div class="tab"><button class="tablinksunnamed-chunk-33 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-33', 'unnamed-chunk-33');">Base R</button><button class="tablinksunnamed-chunk-33" onclick="javascript:openCode(event, 'option2unnamed-chunk-33', 'unnamed-chunk-33');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-33" class="tabcontentunnamed-chunk-33">

```r
filtered_penguins <- new_penguins[new_penguins$species == "Adelie", ]
```
</div><div id="option2unnamed-chunk-33" class="tabcontentunnamed-chunk-33">

```r
filter(.data = new_penguins, species == "Adelie")
```
</div><script> javascript:hide('option2unnamed-chunk-33') </script>

We can use several different operators to assess the way in which we should filter our data that work the same in tidyverse or base R.

<table class="table" style="font-size: 16px; width: auto !important; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">(\#tab:unnamed-chunk-34)Boolean expressions</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Operator </th>
   <th style="text-align:left;"> Name </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A &lt; B </td>
   <td style="text-align:left;"> less than </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A &lt;= B </td>
   <td style="text-align:left;"> less than or equal to </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A &gt; B </td>
   <td style="text-align:left;"> greater than </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A &gt;= B </td>
   <td style="text-align:left;"> greater than or equal to </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A == B </td>
   <td style="text-align:left;"> equivalence </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A != B </td>
   <td style="text-align:left;"> not equal </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A %in% B </td>
   <td style="text-align:left;"> in </td>
  </tr>
</tbody>
</table>

If you wanted to select all the Penguin species except Adelies, you use 'not equals'.


```r
filter(.data = new_penguins, species != "Adelie")
```

This is the same as 


```r
filter(.data = new_penguins, species %in% c("Chinstrap", "Gentoo"))
```

You can include multiple expressions within `filter()` and it will pull out only those rows that evaluate to `TRUE` for all of your conditions. 

For example the below code will pull out only those observations of Adelie penguins where flipper length was measured as greater than 190mm. 

<div class="tab"><button class="tablinksunnamed-chunk-37 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-37', 'unnamed-chunk-37');">Base R</button><button class="tablinksunnamed-chunk-37" onclick="javascript:openCode(event, 'option2unnamed-chunk-37', 'unnamed-chunk-37');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-37" class="tabcontentunnamed-chunk-37">

```r
new_penguins[new_penguins$species == "Adelie" & new_penguins$flipper_length_mm > 190, ]
```
</div><div id="option2unnamed-chunk-37" class="tabcontentunnamed-chunk-37">

```r
filter(.data = new_penguins, species == "Adelie", flipper_length_mm > 190)
```
</div><script> javascript:hide('option2unnamed-chunk-37') </script>

### Arrange

The function `arrange()` sorts the rows in the table according to the columns supplied. For example

<div class="tab"><button class="tablinksunnamed-chunk-38 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-38', 'unnamed-chunk-38');">Base R</button><button class="tablinksunnamed-chunk-38" onclick="javascript:openCode(event, 'option2unnamed-chunk-38', 'unnamed-chunk-38');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-38" class="tabcontentunnamed-chunk-38">

```r
new_penguins[order(new_penguins$sex), ] # define columns to be arranged
```
</div><div id="option2unnamed-chunk-38" class="tabcontentunnamed-chunk-38">

```r
arrange(.data = new_penguins, sex)
```
</div><script> javascript:hide('option2unnamed-chunk-38') </script>

The data is now arranged in alphabetical order by sex. So all of the observations of female penguins are listed before males. 

You can also reverse this with `desc()`


```r
arrange(.data = new_penguins, desc(sex))
```

You can also sort by more than one column, what do you think the code below does?


```r
arrange(.data = new_penguins,
        sex,
        desc(species),
        desc(flipper_length_mm))
```

### Mutate

Sometimes we need to create a new variable that doesn't exist in our dataset. For example we might want to figure out what the flipper length is when factoring in body mass. 

To create new variables we use the function `mutate()`. 

Note that as before, if you want to save your new column you must save it as an object. Here we are mutating a new column and attaching it to the `new_penguins` data oject.

<div class="tab"><button class="tablinksunnamed-chunk-41 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-41', 'unnamed-chunk-41');">Base R</button><button class="tablinksunnamed-chunk-41" onclick="javascript:openCode(event, 'option2unnamed-chunk-41', 'unnamed-chunk-41');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-41" class="tabcontentunnamed-chunk-41">

```r
new_penguins$body_mass_kg <- new_penguins$body_mass_g / 1000
```
</div><div id="option2unnamed-chunk-41" class="tabcontentunnamed-chunk-41">

```r
new_penguins <- mutate(.data = new_penguins,
                     body_mass_kg = body_mass_g/1000)
```
</div><script> javascript:hide('option2unnamed-chunk-41') </script>

## Pipes

<img src="images/pipe_order.jpg" alt="Pipes make code more human readable" width="80%" style="display: block; margin: auto;" />

Pipes look like this: `|>` Pipes allow you to send the output from one function straight into another function. Specifically, they send the result of the function before `|>` to be the **first** argument of the function after `|>`. As usual, it's easier to show, rather than tell so let's look at an example.


```r
# this example uses brackets to nest and order functions
arrange(.data = filter(.data = select(.data = penguins, species, sex, flipper_length_mm), sex == "MALE"), desc(flipper_length_mm))
```


```r
# this example uses sequential R objects to make the code more readable
object_1 <- select(.data = penguins, species, sex, flipper_length_mm)
object_2 <- filter(.data = object_1, sex == "MALE")
arrange(object_2, desc(flipper_length_mm))
```


```r
# this example is human readable without intermediate objects
penguins |>  
  select(species, sex, flipper_length_mm) |>  
  filter(sex == "MALE") |>  
  arrange(desc(flipper_length_mm))
```

The reason that this function is called a pipe is because it 'pipes' the data through to the next function. When you wrote the code previously, the first argument of each function was the dataset you wanted to work on. When you use pipes it will automatically take the data from the previous line of code so you don't need to specify it again.

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 
Try and write out as plain English what the |>  above is doing? You can read the |>  as THEN </div></div>


<div class='webex-solution'><button>Solution</button>


Take the penguins data AND THEN
Select only the species, sex and flipper length columns AND THEN
Filter to keep only those observations labelled as sex equals male AND THEN
Arrange the data from HIGHEST to LOWEST flipper lengths.


</div>


<div class="info">
<p>From R version 4 onwards there is now a “native pipe”
<code>|&gt;</code></p>
<p>This doesn’t require the tidyverse <code>magrittr</code> package and
the “old pipe” <code>%&gt;%</code> or any other packages to load and
use.</p>
<p>You may be familiar with the magrittr pipe or see it in other
tutorials, and website usages. The native pipe works equivalntly in most
situations but if you want to read about some of the operational
differences, <a
href="https://www.infoworld.com/article/3621369/use-the-new-r-pipe-built-into-r-41.html">this
site</a> does a good job of explaining .</p>
</div>


## A few more handy functions

### Check for duplication

It is very easy when inputting data to make mistakes, copy something in twice for example, or if someone did a lot of copy-pasting to assemble a spreadsheet (yikes!). We can check this pretty quickly


```r
# check for duplicate rows in the data
penguins |> 
  duplicated() |>  # produces a list of TRUE/FALSE statements for duplicated or not
  sum() # sums all the TRUE statements
```

```
[1] 0
```
Great! 

If I did have duplications I could investigate further


```r
# Check duplicated rows
penguins |> 
    filter(duplicated(penguins))
```



```r
# Keep only unduplicated data
penguins |> 
    filter(!duplicated(penguins))
```

### Summarise

We can also  explore our data for very obvious typos by checking for implausibly small or large values, this is a simple use of the `summarise` function.


```r
# use summarise to make calculations
penguins |> 
  summarise(min=min(body_mass_g, na.rm=TRUE), 
            max=max(body_mass_g, na.rm=TRUE))
```

The minimum weight for our penguins is 2.7kg, and the max is 6.3kg - not outrageous. If the min had come out at 27g we might have been suspicious. We will use `summarise` again to calculate other metrics in the future. 

<div class="info">
<p>Our first data insight, the difference the smallest adult penguin in
our dataset is nearly half the size of the largest penguin.</p>
</div>

### Group By

Many data analysis tasks can be approached using the “split-apply-combine” paradigm: split the data into groups, apply some analysis to each group, and then combine the results. `dplyr` makes this very easy with the `group_by()` function. In the `summarise` example above we were able to find the max-min body mass values for the penguins in our dataset. But what if we wanted to break that down by a grouping such as species of penguin. This is where `group_by()` comes in.

<div class="tab"><button class="tablinksunnamed-chunk-53 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-53', 'unnamed-chunk-53');">Base R</button><button class="tablinksunnamed-chunk-53" onclick="javascript:openCode(event, 'option2unnamed-chunk-53', 'unnamed-chunk-53');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-53" class="tabcontentunnamed-chunk-53">

```r
#Things start to get more complicated with Base R

split(penguins$body_mass_g, penguins$species) |> 
    lapply(function(x) c(min(x, na.rm = TRUE), max(x, na.rm = TRUE))) |> 
    do.call(rbind, args = _ ) |> 
  as.data.frame()
```
</div><div id="option2unnamed-chunk-53" class="tabcontentunnamed-chunk-53">

```r
penguins |> 
  group_by(species) |>  # subsequent functions are perform "by group"
  summarise(min=min(body_mass_g, na.rm=TRUE), 
            max=max(body_mass_g, na.rm=TRUE))
```
</div><script> javascript:hide('option2unnamed-chunk-53') </script>

Now we know a little more about our data, the max weight of our Gentoo penguins is much larger than the other two species. In fact, the minimum weight of a Gentoo penguin is not far off the max weight of the other two species. 


### Distinct

We can also look for typos by asking R to produce all of the distinct values in a variable. This is more useful for categorical data, where we expect there to be only a few distinct categories

<div class="tab"><button class="tablinksunnamed-chunk-54 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-54', 'unnamed-chunk-54');">Base R</button><button class="tablinksunnamed-chunk-54" onclick="javascript:openCode(event, 'option2unnamed-chunk-54', 'unnamed-chunk-54');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-54" class="tabcontentunnamed-chunk-54">

```r
unique(penquins$sex) # only works on vectord
```
</div><div id="option2unnamed-chunk-54" class="tabcontentunnamed-chunk-54">

```r
penguins |>  
  distinct(sex)
```
</div><script> javascript:hide('option2unnamed-chunk-54') </script>

Here if someone had mistyped e.g. 'FMALE' it would be obvious. We could do the same thing (and probably should have before we changed the names) for species. 

### Missing values: NA

There are multiple ways to check for missing values in our data


```r
# Get a sum of how many observations are missing in our dataframe
penguins |> 
  is.na() |> 
  sum()
```

But this doesn't tell us where these are, fortunately the function `summary` does this easily

## `Summary`


```r
# produce a summary of our data
summary(penguins)
#__________________________----
```

This provides a quick breakdown of the max and min for all numeric variables, as well as a list of how many missing observations there are for each one. As we can see there appear to be two missing observations for measurements in body mass, bill lengths, flipper lengths and several more for blood measures. We don't know for sure without inspecting our data further, *but* it is likely that the two birds are missing multiple measurements, and that several more were measured but didn't have their blood drawn. 

We will leave the NA's alone for now, but it's useful to know how many we have. 

We've now got a clean & tidy dataset, with a handful of first insights into the data. 








## More summary tools

Very often we want to make calculations aobut groups of observations, such as the mean or median. We are often interested in comparing responses among groups. For example, we previously found the number of distinct penguins in our entire dataset.

<div class="try">
<p>Add these new lines of code to your script as you try them. Comment
out # and add short descriptions of what you are achieving with them</p>
</div>

<div class="tab"><button class="tablinksunnamed-chunk-60 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-60', 'unnamed-chunk-60');">Base R</button><button class="tablinksunnamed-chunk-60" onclick="javascript:openCode(event, 'option2unnamed-chunk-60', 'unnamed-chunk-60');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-60" class="tabcontentunnamed-chunk-60">

```r
unique(penguins$individual_id) |> 
  length()
```
</div><div id="option2unnamed-chunk-60" class="tabcontentunnamed-chunk-60">

```r
penguins |> 
  summarise(n_distinct(individual_id))
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> n_distinct(individual_id) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 190 </td>
  </tr>
</tbody>
</table>

</div>
</div><script> javascript:hide('option2unnamed-chunk-60') </script>

Now consider when the groups are subsets of observations, as when we find out the number of penguins in each species and sex.

<div class="tab"><button class="tablinksunnamed-chunk-61 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-61', 'unnamed-chunk-61');">Base R</button><button class="tablinksunnamed-chunk-61" onclick="javascript:openCode(event, 'option2unnamed-chunk-61', 'unnamed-chunk-61');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-61" class="tabcontentunnamed-chunk-61">

```r
# note aggregate doesn't have functionality to deal with missing data
aggregate(individual_id ~ species + sex, 
          data = penguins, 
          FUN = function(x) length(unique(x)))
```
</div><div id="option2unnamed-chunk-61" class="tabcontentunnamed-chunk-61">

```r
penguins |> 
  group_by(species, sex) |> 
  summarise(n_distinct(individual_id))
```
</div><script> javascript:hide('option2unnamed-chunk-61') </script>

As we progress, not only are we learning how to use our data wrangling tools. We are also gaining insights into our data. 

**Question** How many female Adelie penguins are in our dataset? 

<input class='webex-solveme nospaces' size='2' data-answer='["65"]'/>

<br>

**Question** How many Gentoo penguins **did not** have their sex recorded?

<input class='webex-solveme nospaces' size='1' data-answer='["5"]'/>

<br>

We are using summarise and group_by a lot! They are very powerful functions:

* `group_by` adds *grouping* information into a data object, so that subsequent calculations happen on a *group-specific* basis. 

* `summarise` is a data aggregation function thart calculates summaries of one or more variables, and it will do this separately for any groups defined by `group_by`

### summarise()

`summarise()` has a whole list of useful functions for producing *descriptive* statistics

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> verb </th>
   <th style="text-align:left;"> action </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> mean(), median() </td>
   <td style="text-align:left;"> Center data </td>
  </tr>
  <tr>
   <td style="text-align:left;"> sd(), IQR() </td>
   <td style="text-align:left;"> Spread of data </td>
  </tr>
  <tr>
   <td style="text-align:left;"> min(), max(), quantile() </td>
   <td style="text-align:left;"> Range of data </td>
  </tr>
  <tr>
   <td style="text-align:left;"> first(), last(), nth() </td>
   <td style="text-align:left;"> Position </td>
  </tr>
  <tr>
   <td style="text-align:left;"> n(), n_distinct() </td>
   <td style="text-align:left;"> Count </td>
  </tr>
</tbody>
</table>

</div>

* `min` and `max` to calculate minimum and maximum values of a numeric vector

* `mean` and `median` to calculate averages of a numeric vector

* `sd` and `var` calculate standard deviation and variance of a numeric vector

Using `summarise` we can calculate the mean flipper and bill lengths of our penguins:


```r
penguins |> 
  summarise(
    mean_flipper_length = mean(flipper_length_mm, na.rm=TRUE),
     mean_culmen_length = mean(culmen_length_mm, na.rm=TRUE))
```

<div class="info">
<p>Note - we provide informative names for ourselves on the left side of
the <code>=</code></p>
<p>When performing calculations in summarise it is important to set
<code>na.rm = TRUE</code>, this removes missing values from the
calculation</p>
</div>


<div class="try">
<p>What happens when you try to produce calculations that include
<code>NA</code>? e.g <code>NA</code> + 4 or <code>NA</code> * 5</p>
</div>

We can use several functions in `summarise`. Which means we can string several calculations together in a single step, and generate more insights into our data.


```r
penguins |> 
  summarise(n=n(), # number of rows of data
            num_penguins = n_distinct(individual_id), # number of unique individuals
            mean_flipper_length = mean(flipper_length_mm, na.rm=TRUE), # mean flipper length
            prop_female = sum(sex == "FEMALE", na.rm=TRUE) / n()) # proportion of observations that are coded as female
```


<button id="displayTextunnamed-chunk-67" onclick="javascript:toggle('unnamed-chunk-67');">Show Solution</button>

<div id="toggleTextunnamed-chunk-67" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

There are 190 unique IDs and 344 total observations so it would appear that there are roughly twice as many observations as unique individuals. The sex ratio is roughly even (48% female) and the average flipper length is 201 mm.
</div></div></div>


#### Summarize `across` columns


`across` has two arguments, `.cols` and `.fns`. 

* The `.cols` argument lets you select the columns you wish to apply functions to

* The `.fns` argument applies the required function to all of the selected columns. 



```r
# Across ----
# The mean of ALL numeric columns in the data, where(is.numeric == TRUE) hunts for numeric columns

penguins |> 
  summarise(across(.cols = where(is.numeric), 
                   .fns = ~ mean(., na.rm=TRUE)))
```

The above example calculates the means of any & all numeric variables in the dataset. 

The below example is a slightly complicated way of running the n_distinct for summarise. The `.cols()` looks for any column that contains the word "penguin" and then runs the `n_distinct()`command on these


```r
# number of distinct penguins, as only one column contains the word penguin
# the argument contains looks for columns that match a character expression

penguins |> 
  summarise(across(.cols = contains("individual"), 
                   .fns = ~n_distinct(.)))
```

### group_by revisited

The `group_by` function provides the ability to separate our summary functions according to any subgroups we wish to make. The real magic happens when we pair this with `summarise` and `mutate`.

In this example, by grouping on the individual penguin ids, then summarising by n - we can see how many times each penguin was monitored in the course of this study. 


```r
penguin_stats <- penguins |> 
  group_by(individual_id) |> 
  summarise(num=n())
```


<div class="info">
<p>Remember the actions of <code>group_by</code> are “invisible”.
Subsequent functions are applied in a “grouped by” manner - but the
dataframe itself looks unchanged.</p>
</div>

#### More than one grouping variable

What if we need to calculate by more than one variable at a time? 
No problem we can submit several arguments:


```r
penguins_grouped <- penguins |> 
  group_by(sex, species)
```

 We can then calculate the mean flipper length of penguins in each of the six combinations


```r
penguins_grouped |> 
summarise(mean_flipper = mean(flipper_length_mm, na.rm=TRUE))
```

Now the first row of our summary table shows us the mean flipper length (in mm) for female Adelie penguins. There are eight rows in total, six unique combinations and two rows where the sex of the penguins was not recorded(`NA`)

#### using group_by with mutate

So far we have only used `group_by` with the `summarise` function, but this doesn't always have to be the case. 
When `mutate` is used with `group_by`, the calculations occur by 'group'. Here's an example:


```r
# Using mutate and group_by ----
centered_penguins <- penguins |> 
  group_by(sex, species) |> 
  mutate(flipper_centered = flipper_length_mm-mean(flipper_length_mm, na.rm=TRUE))

centered_penguins |> 
  select(flipper_centered)
# Each row now returns a value for EACH penguin of how much greater/lesser than the group average (sex and species) its flipper is. 
```

Here we are calculating a **group centered mean**, this new variable contains the *difference* between each observation and the mean of whichever group that observation is in. 

#### remove group_by

On occasion we may need to remove the grouping information from a dataset. This is often required when we string pipes together, when we need to work using a grouping structure, then revert back to the whole dataset again

Look at our grouped dataframe, and we can see the information on groups is at the top of the data:

```
# A tibble: 344 x 10
# Groups:   sex, species [8]
   species island culmen_length_mm culmen_depth_mm flipper_length_~ body_mass_g
   <chr>   <chr>           <dbl>         <dbl>            <dbl>       <dbl>
 1 Adelie  Torge~           39.1          18.7              181        3750
 2 Adelie  Torge~           39.5          17.4              186        3800
 3 Adelie  Torge~           40.3          18                195        3250
 ```



```r
# Run this command will remove the groups - but this is only saved if assigned BACK to an object

centered_penguins <- centered_penguins |> 
  ungroup()

centered_penguins
```

Look at this output - you can see the information on groups has now been removed from the data. 

## Working with character strings

Datasets often contain words, and we call these words "(character) strings". 

Often these aren't quite how we want them to be, but we can manipulate these as much as we like. Functions in the package `stringr`, are fantastic. And the number of different types of manipulations are endless!


```r
# Stringr ----

str_replace_all(names(penguins), c("e"= "E"))
# replace all character "e" with "E"
```


### More stringr


```r
penguins  |>  
  mutate(species=str_to_upper(species))
# Capitalise all letters
```


```r
penguins |> 
  mutate(species=str_remove_all(species, "e"))
# remove every character "e" from selected variables
```

We can also trim leading or trailing empty spaces with `str_trim`. These are often problematic and difficult to spot e.g.


```r
df2 <- tibble(label=c("penguin", " penguin", "penguin ")) 
df2 # make a test dataframe
```

We can easily imagine a scenario where data is manually input, and trailing or leading spaces are left in. These are difficult to spot by eye - but problematic because as far as R is concerned these are different values. We can use the function `distinct` to return the names of all the different levels it can find in this dataframe.


```r
df2 |> 
  distinct()
```

If we pipe the data throught the `str_trim` function to remove any gaps, then pipe this on to `distinct` again - by removing the whitespace, R now recognises just one level to this data. 


```r
df2 |> 
  mutate(label=str_trim(label, side="both")) |> 
  distinct()
```

A quick example of how to extract partial strings according to a pattern is to use `str_detect`. Combined with `filter` it is possible to subset a dataframe by searching for all the strings that match provided information, such as all the penguin IDs that start with "N1"


```r
penguins |> 
  filter(str_detect(individual_id, "N1"))
```

### separate

Sometimes a string might contain two pieces of information in one. This does not confirm to our tidy data principles. But we can easily separate the information with `separate()` from the `tidyr` package.

First we produce some made-up data


```r
df <- tibble(label=c("a-1", "a-2", "a-3")) 
#make a one column tibble
df
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> label </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> a-1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> a-2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> a-3 </td>
  </tr>
</tbody>
</table>

</div>


```r
df |> 
  separate(label, # name of variable
           c("treatment", "replicate"), # new column names
           sep="-") # the character to mark where the separation occurs
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> treatment </th>
   <th style="text-align:left;"> replicate </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> a </td>
   <td style="text-align:left;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> a </td>
   <td style="text-align:left;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> a </td>
   <td style="text-align:left;"> 3 </td>
  </tr>
</tbody>
</table>

</div>

We started with one variable called `label` and then split it into two variables, `treatment` and `replicate`, with the split made where `-` occurs. 
The opposite of this function is `unite()`

## Working with dates

Working with dates can be tricky, treating date as strictly numeric is problematic, it won't account for number of days in months or number of months in a year. 

Additionally there's a lot of different ways to write the same date:

* 13-10-2019

* 10-13-2019

* 13-10-19

* 13th Oct 2019

* 2019-10-13

This variability makes it difficult to tell our software how to read the information, luckily we can use the functions in the `lubridate` package. 


<div class="warning">
<p>If you get a warning that some dates could not be parsed, then you
might find the date has been inconsistently entered into the
dataset.</p>
<p>Pay attention to warning and error messages</p>
</div>

Depending on how we interpret the date ordering in a file, we can use `ymd()`, `ydm()`, `mdy()`, `dmy()` 

* **Question** What is the appropriate function from the above to use on the `date_egg` variable?


<div class='webex-radiogroup' id='radio_WEZPZBXUJV'><label><input type="radio" autocomplete="off" name="radio_WEZPZBXUJV" value=""></input> <span>ymd()</span></label><label><input type="radio" autocomplete="off" name="radio_WEZPZBXUJV" value=""></input> <span>ydm()</span></label><label><input type="radio" autocomplete="off" name="radio_WEZPZBXUJV" value=""></input> <span>mdy()</span></label><label><input type="radio" autocomplete="off" name="radio_WEZPZBXUJV" value="answer"></input> <span>dmy()</span></label></div>



<button id="displayTextunnamed-chunk-86" onclick="javascript:toggle('unnamed-chunk-86');">Show Solution</button>

<div id="toggleTextunnamed-chunk-86" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
penguins <- penguins |>
  mutate(date_egg_proper = lubridate::dmy(date_egg))
```
</div></div></div>


Here we use the `mutate` function from `dplyr` to create a *new variable* called `date_egg_proper` based on the output of converting the characters in `date_egg` to date format. The original variable is left intact, if we had specified the "new" variable was also called `date_egg` then it would have overwritten the original variable. 



Once we have established our date data, we are able to perform calculations. Such as the date range across which our data was collected.  





```r
penguins |> 
  summarise(min_date=min(date_egg_proper),
            max_date=max(date_egg_proper))
```

#### Calculations with dates

How many times was each penguin measured, and across what total time period?


```r
penguins |> 
  group_by(individual_id) |> 
  summarise(first_observation=min(date_egg_proper), 
            last_observation=max(date_egg_proper), 
            study_duration = last_observation-first_observation, 
            n=n())
```

Cool we can also convert intervals such as days into weeks, months or years with `dweeks(1)`, `dmonths(1)`, `dyears(1)`.

As with all cool functions, you should check out the RStudio [cheat sheet](https://www.rstudio.com/resources/cheatsheets/) for more information. Date type data is common in datasets, and learning to work with it is a useful skill. 



```r
penguins |> 
  group_by(individual_id) |> 
  summarise(first_observation=min(date_egg_proper), 
            last_observation=max(date_egg_proper), 
            study_duration_years = (last_observation-first_observation)/lubridate::dyears(1), 
            n=n()) |> 
    arrange(desc(study_duration_years))
```


Or extract the year from the date - let's do this now and update our dataframe


```r
penguins <- penguins |> 
  mutate(year = as.integer(lubridate::year(date_egg_proper)))
```


## Factors

In R, factors are a class of data that allow for **ordered categories** with a fixed set of acceptable values. 

Typically, you would convert a column from character or numeric class to a factor if you want to set an intrinsic order to the values (“levels”) so they can be displayed non-alphabetically in plots and tables, or for use in linear model analyses (more on this later). 

Another common use of factors is to standardise the legends of plots so they do not fluctuate if certain values are temporarily absent from the data.


```r
penguins <- penguins |> 
  mutate(flipper_range = case_when(flipper_length_mm <= 190 ~ "small",
                                   flipper_length_mm >190 & flipper_length_mm < 213 ~ "medium",
                                   flipper_length_mm >= 213 ~ "large"))
```

If we make a barplot, the order of the values on the x axis will typically be in alphabetical order for any character data


```r
penguins |> 
  ggplot(aes(x = flipper_range))+
  geom_bar()
```

<img src="02a-penguin_files/figure-html/unnamed-chunk-93-1.png" width="100%" style="display: block; margin: auto;" />

To convert a character or numeric column to class factor, you can use any function from the `forcats` package. They will convert to class factor and then also perform or allow certain ordering of the levels - for example using `forcats::fct_relevel()` lets you manually specify the level order. 

The function `as_factor()` simply converts the class without any further capabilities.

The `base R` function `factor()` converts a column to factor and allows you to manually specify the order of the levels, as a character vector to its `levels =` argument.

Below we use `mutate()` and `fct_relevel()` to convert the column flipper_range from class character to class factor. 

<div class="tab"><button class="tablinksunnamed-chunk-94 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-94', 'unnamed-chunk-94');">Base R</button><button class="tablinksunnamed-chunk-94" onclick="javascript:openCode(event, 'option2unnamed-chunk-94', 'unnamed-chunk-94');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-94" class="tabcontentunnamed-chunk-94">

```r
penguins$flipper_range <- factor(penguins$flipper_range)
```
</div><div id="option2unnamed-chunk-94" class="tabcontentunnamed-chunk-94">

```r
penguins <- penguins |> 
  mutate(flipper_range = fct_relevel(flipper_range))
```
</div><script> javascript:hide('option2unnamed-chunk-94') </script>



```r
levels(penguins$flipper_range)
```

```
## [1] "large"  "medium" "small"
```


<div class="tab"><button class="tablinksunnamed-chunk-96 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-96', 'unnamed-chunk-96');">Base R</button><button class="tablinksunnamed-chunk-96" onclick="javascript:openCode(event, 'option2unnamed-chunk-96', 'unnamed-chunk-96');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-96" class="tabcontentunnamed-chunk-96">

```r
penguins$flipper_range <- factor(penguins$flipper_range,
                                  levels = c("small", "medium", "large"))
```
</div><div id="option2unnamed-chunk-96" class="tabcontentunnamed-chunk-96">

```r
# Correct the code in your script with this version
penguins <- penguins |> 
  mutate(flipper_range = fct_relevel(flipper_range, "small", "medium", "large"))
```
</div><script> javascript:hide('option2unnamed-chunk-96') </script>

Now when we call a plot, we can see that the x axis categories match the intrinsic order we have specified with our factor levels. 


```r
penguins |> 
  ggplot(aes(x = flipper_range))+
  geom_bar()
```

<img src="02a-penguin_files/figure-html/unnamed-chunk-97-1.png" width="100%" style="display: block; margin: auto;" />

<div class="info">
<p>Factors will also be important when we build linear models a bit
later. The reference or intercept for a categorical predictor variable
when it is read as a <code>&lt;chr&gt;</code> is set by R as the first
one when ordered alphabetically. This may not always be the most
appropriate choice, and by changing this to an ordered
<code>&lt;fct&gt;</code> we can manually set the intercept.</p>
</div>



## Finished

* Make sure you have **saved your script 💾**  and given it the filename "01_import_penguins_data.R" in the ["scripts" folder](#activity-1-organising-our-workspace).

* You have been playing with a lot of dplyr functions, think - what functions do I actually need to make sure I have a tidy and clean dataset with appropriate column names and formatted data?

* We want : snake_case names, shorter isotope names, simpler species values and properly formatted date data with a new column for year.


<div class='webex-solution'><button>Check your script</button>



```r
#___________________________----
# SET UP ----
## An analysis of the bill dimensions of male and female Adelie, Gentoo and Chinstrap penguins ----

### Data first published in  Gorman, KB, TD Williams, and WR Fraser. 2014. “Ecological Sexual Dimorphism and Environmental Variability Within a Community of Antarctic Penguins (Genus Pygoscelis).” PLos One 9 (3): e90081. https://doi.org/10.1371/journal.pone.0090081. ----
#__________________________----

# PACKAGES ----
library(tidyverse) # tidy data packages
library(janitor) # cleans variable names
#__________________________----
# IMPORT DATA ----
penguins_raw <- read_csv ("data/penguins_raw.csv")

attributes(penguins_raw) # reads as tibble

head(penguins_raw) # check the data has loaded, prints first 10 rows of dataframe
#__________________________----
# CLEAN DATA ----

# clean all variable names to snake_case using the clean_names function from the janitor package
# note we are using assign <- to overwrite the old version of penguins with a version that has updated names
# this changes the data in our R workspace but NOT the original csv file

penguins_clean <- janitor::clean_names(penguins_raw) # clean the column names

colnames(penguins_clean) # quickly check the new variable names

# shorten the variable names for N and C isotope blood samples

penguins <- rename(penguins_clean,
         "delta_15n"="delta_15_n_o_oo",  # use rename from the dplyr package
         "delta_13c"="delta_13_c_o_oo")

# use mutate and case_when for a statement that conditionally changes the names of the values in a variable
penguins <- penguins |> 
  mutate(species = case_when(species == "Adelie Penguin (Pygoscelis adeliae)" ~ "Adelie",
                             species == "Gentoo penguin (Pygoscelis papua)" ~ "Gentoo",
                             species == "Chinstrap penguin (Pygoscelis antarctica)" ~ "Chinstrap"))

# use lubridate to format date and extract the year
penguins <- penguins |>
  mutate(date_egg_proper = lubridate::dmy(date_egg))

penguins <- penguins |> 
  mutate(year = as.integer(lubridate::year(date_egg_proper)))

# Export tidy dataframe for use in future sessions

saveRDS(penguins, file = "outputs/2024_11_01_penguin_clean.RDS")
```


</div>



* Some parts of our script are *redundant* for the purposes of generating a clean dataframe, we need the `penguins` data in a tidy/rectangular format, checked for missing values, duplicated data and with clean column names. 

* If we have that we can generate a .RDS file to save this dataframe for use in data insights scripts


```r
saveRDS(penguins, file = "outputs/2024_11_01_penguin_clean.RDS")
```



* Does your workspace look like the below? 

<div class="figure" style="text-align: center">
<img src="images/project_penguin.png" alt="My neat project layout" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-101)My neat project layout</p>
</div>

<div class="figure" style="text-align: center">
<img src="images/r_script.png" alt="My scripts and file subdirectory" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-102)My scripts and file subdirectory</p>
</div>

## Activity: Test yourself


**Question 1.** In order to subset a data by **rows** I should use the function <select class='webex-select'><option value='blank'></option><option value=''>select()</option><option value='answer'>filter()</option><option value=''>group_by()</option></select>

**Question 2.** In order to subset a data by **columns** I should use the function <select class='webex-select'><option value='blank'></option><option value='answer'>select()</option><option value=''>filter()</option><option value=''>group_by()</option></select>

**Question 3.** In order to make a new column I should use the function <select class='webex-select'><option value='blank'></option><option value=''>group_by()</option><option value=''>select()</option><option value='answer'>mutate()</option><option value=''>arrange()</option></select>

**Question 4.** Which operator should I use to send the output from line of code into the next line? <input class='webex-solveme nospaces' size='2' data-answer='["|>"]'/>

**Question 5.** What will be the outcome of the following line of code?


```r
penguins |> 
  filter(species == "Adelie")
```


<select class='webex-select'><option value='blank'></option><option value=''>The penguins dataframe object is reduced to include only Adelie penguins from now on</option><option value='answer'>A new filtered dataframe of only Adelie penguins will be printed into the console</option></select>



<div class='webex-solution'><button>Explain this answer</button>


Unless the output of a series of functions is "assigned" to an object using `<-` it will not be saved, the results will be immediately printed. This code would have to be modified to the below in order to create a new filtered object `penguins_filtered`


```r
penguins_filtered <- penguins |> 
  filter(species == "Adelie")
```


</div>


<br>


**Question 6.** What is the main point of a data "pipe"?

<select class='webex-select'><option value='blank'></option><option value=''>The code runs faster</option><option value='answer'>The code is easier to read</option></select>


**Question 7.** The naming convention outputted by the function `janitor::clean_names() is 
<select class='webex-select'><option value='blank'></option><option value='answer'>snake_case</option><option value=''>camelCase</option><option value=''>SCREAMING_SNAKE_CASE</option><option value=''>kebab-case</option></select>


**Question 8.** Which package provides useful functions for manipulating character strings? 

<select class='webex-select'><option value='blank'></option><option value='answer'>stringr</option><option value=''>ggplot2</option><option value=''>lubridate</option><option value=''>forcats</option></select>

**Question 9.** Which package provides useful functions for manipulating dates? 

<select class='webex-select'><option value='blank'></option><option value=''>stringr</option><option value=''>ggplot2</option><option value='answer'>lubridate</option><option value=''>forcats</option></select>


**Question 10.** If we do not specify a character variable as a factor, then ordering will default to what?

<select class='webex-select'><option value='blank'></option><option value=''>numerical</option><option value='answer'>alphabetical</option><option value=''>order in the dataframe</option></select>




# Data reshaping

While neither *wide* or *long* data is more correct than the other, we will work with *long* data as it is clearer how many distinct types of variables there are in our data *and* the tools we will be using from the `tidyverse` are designed to work with *long* data.

## Using `pivot` functions

There are functions found as part of the `tidyverse` that can help us to reshape data. 

* `tidyr::pivot_wider()` - from *long* to *wide* format

* `tidyr::pivot_longer()` - from *wide* to *long* format


```r
 country <- c("x", "y", "z")
 yr1960 <-  c(10, 20, 30)
 yr1970 <-  c(13, 23, 33)
 yr2010 <-  c(15, 25, 35)

country_data <- tibble(country, yr1960, yr1970, yr2010)
country_data
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:right;"> yr1960 </th>
   <th style="text-align:right;"> yr1970 </th>
   <th style="text-align:right;"> yr2010 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 15 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> y </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 23 </td>
   <td style="text-align:right;"> 25 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> z </td>
   <td style="text-align:right;"> 30 </td>
   <td style="text-align:right;"> 33 </td>
   <td style="text-align:right;"> 35 </td>
  </tr>
</tbody>
</table>

</div>




```r
pivot_longer(data = country_data,
             cols = yr1960:yr2010,
             names_to = "year",
             names_prefix = "yr",
             values_to = "metric")
```

<div class="figure" style="text-align: center">
<img src="images/tidyr_pivot.png" alt="Reshaping data with pivot" width="100%" />
<p class="caption">(\#fig:img-pivot)Reshaping data with pivot</p>
</div>


To *save* these changes to your data format, you must assign this to an object, and you have two options

* Use the same name as the original R object, this will *overwrite* the original with the new format

* Use a *new* name for the reformatted data both R objects will exist in your Environment

Neither is more *correct* than the other but be aware of what you are doing.


### Overwrite the original object 


```r
country_data <- pivot_longer(data = country_data,
             cols = yr1960:yr2010,
             names_to = "year",
             names_prefix = "yr",
             values_to = "metric")
```

### Create a new r object


```r
long_country_data <- pivot_longer(data = country_data,
             cols = yr1960:yr2010,
             names_to = "year",
             names_prefix = "yr",
             values_to = "metric")
```

## Join functions

Frequently, analysis of data will require merging these separately managed tables back together. There are multiple ways to join the observations in two tables, based on how the rows of one table are merged with the rows of the other.

When conceptualizing merges, one can think of two tables, one on the left and one on the right. The most common (and often useful) join is when you merge the subset of rows that have matches in both the left table and the right table: this is called an INNER JOIN. Other types of join are possible as well. 

- A LEFT JOIN takes all of the rows from the left table, and merges on the data from matching rows in the right table. Keys that don’t match from the left table are still provided with a missing value (NA) from the right table. 

- A RIGHT JOIN is the same, except that all of the rows from the right table are included with matching data from the left, or a missing value. 

- Finally, a FULL JOIN includes all data from all rows in both tables, and includes missing values wherever necessary.


<img src="images/join-diagrams.png" width="100%" style="display: block; margin: auto;" />


### Left join


```r
# Create tibbles df_primary and df_secondary
df_primary <- tibble(
  ID = c("A", "B", "C", "D", "F"),
  y = c(5, 5, 8, 0, 9)
)

df_secondary <- tibble(
  ID = c("A", "B", "C", "D", "E"),
  z = c(30, 21, 22, 25, 29)
)
```


```r
left_join(df_primary, df_secondary, by ='ID')
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> ID </th>
   <th style="text-align:right;"> y </th>
   <th style="text-align:right;"> z </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> D </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 25 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
</tbody>
</table>

</div>

### Right join


```r
right_join(df_primary, df_secondary, by = 'ID')
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> ID </th>
   <th style="text-align:right;"> y </th>
   <th style="text-align:right;"> z </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> D </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 25 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> E </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 29 </td>
  </tr>
</tbody>
</table>

</div>

### Full join


```r
full_join(df_primary, df_secondary, by = 'ID')
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> ID </th>
   <th style="text-align:right;"> y </th>
   <th style="text-align:right;"> z </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> D </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 25 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> E </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 29 </td>
  </tr>
</tbody>
</table>

</div>

# Dealing with Missing Data

The `palmerpenguins` dataset contains data on penguins from the Palmer Archipelago in Antarctica. This dataset includes several measurements such as species, island, bill length, bill depth, flipper length, body mass, and sex. However, it contains missing values, particularly in the sex column. In this chapter, we will:

- Use the `naniar` package to visualize and understand the patterns of missing data.

- Use the `mice` package to perform multiple imputation to handle missing values.

- Discuss how to choose an appropriate imputation algorithm.

- Check the quality of imputation using diagnostic plots and statistical checks.



## Visualise missing data with `naniar`

The naniar package provides functions to visualize and explore missing data. Start by visualizing the missing values:


```r
# Visualise missing data
naniar::vis_miss(penguins)
```

<img src="02a-penguin_files/figure-html/unnamed-chunk-114-1.png" width="100%" style="display: block; margin: auto;" />

The `vis_miss()` function creates a heatmap-like plot where missing values are shown in a different color, allowing you to quickly see where missing data occurs.

You can also use a `gg_miss_var` plot to see the proportion of missing values by variable


```r
# Visualize missing data by variable
gg_miss_var(penguins)
```

<img src="02a-penguin_files/figure-html/unnamed-chunk-115-1.png" width="100%" style="display: block; margin: auto;" />

## Explore the Patterns of Missingness
Understanding the patterns of missingness can help you decide on an appropriate imputation method:


```r
# Explore missing data patterns
miss_var_summary(penguins)
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> variable </th>
   <th style="text-align:right;"> n_miss </th>
   <th style="text-align:right;"> pct_miss </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> comments </td>
   <td style="text-align:right;"> 290 </td>
   <td style="text-align:right;"> 84.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> delta_15n </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 4.07 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> delta_13c </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 3.78 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> sex </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 3.20 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> culmen_length_mm </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0.581 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> culmen_depth_mm </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0.581 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> flipper_length_mm </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0.581 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> body_mass_g </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0.581 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> flipper_range </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0.581 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> study_name </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> sample_number </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> species </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> region </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> island </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> stage </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> individual_id </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> clutch_completion </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> date_egg </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> date_egg_proper </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> year </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
</tbody>
</table>

</div>

We can combine this with `group_by()` to get insights into the patterns surrounding our missing data


```r
penguins |> 
  select(species, island, sex) |> 
  group_by(species, island) |> 
  miss_var_summary()
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> species </th>
   <th style="text-align:left;"> island </th>
   <th style="text-align:left;"> variable </th>
   <th style="text-align:right;"> n_miss </th>
   <th style="text-align:right;"> pct_miss </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Torgersen </td>
   <td style="text-align:left;"> sex </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 9.62 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:left;"> sex </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:left;"> sex </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1.79 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gentoo </td>
   <td style="text-align:left;"> Biscoe </td>
   <td style="text-align:left;"> sex </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 4.03 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chinstrap </td>
   <td style="text-align:left;"> Dream </td>
   <td style="text-align:left;"> sex </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
</tbody>
</table>

</div>

An upset plot can be used to visualise the patterns of missingness, or rather the combinations of missingness across cases. 


```r
gg_miss_upset(penguins)
```

<img src="02a-penguin_files/figure-html/unnamed-chunk-118-1.png" width="100%" style="display: block; margin: auto;" />

`gg_miss_fct()`: This function allows you to explore missing data by levels of a factor. It is useful for checking if missingness is related to a categorical variable.


```r
# Explore missing data by species
gg_miss_fct(penguins, fct = island)
```

<img src="02a-penguin_files/figure-html/unnamed-chunk-119-1.png" width="100%" style="display: block; margin: auto;" />


## Handling missing data

### Deleting Missing Rows

One of the simplest approaches to address missing data in a dataset is to delete observations (rows) that contain any missing values. This method, often referred to as "listwise deletion" or "complete case analysis," involves removing entire records from the analysis if they are missing any data point in one or more variables

- When to Consider Deleting Missing Rows:

Minimal Missing Data: If the missing data is slight and seemingly random, eliminating those incomplete entries is unlikely to significantly affect the dataset's overall quality.

MCAR Data: Deletion is most appropriate when the missing data is Missing Completely At Random (MCAR), meaning there's no systematic difference between the missing and observed values.

### Impute missing data

Before performing imputation, it’s important to choose the right algorithm based on the data type and the nature of the missingness. The mice package supports various imputation methods for different types of data:

### Types of Missingness:

- Missing Completely at Random (MCAR): The missing data has no relationship with any other variable. Any imputation method can be used, but simpler methods like mean/mode imputation might suffice.

- Missing at Random (MAR): The missingness is related to other observed variables. Imputation methods that take into account other variables, such as predictive mean matching or multiple regression, are appropriate.

- Missing Not at Random (MNAR): The missingness is related to the missing values themselves. In such cases, data augmentation, sensitivity analysis, or using domain knowledge for imputation might be necessary.

### Choosing the Imputation Method:
Here are some common imputation methods provided by mice and when they are most appropriate:

- Mean/Mode Imputation (mean, mode): Fills in missing values with the mean (numeric data) or mode (categorical data) of observed values. Simple but can distort the distribution and underestimate variability.

- Predictive Mean Matching (pmm): Matches the missing value with observed values that have a similar predicted value based on a regression model. It’s useful for numerical data and preserves the original distribution.

- Logistic Regression (logreg): Suitable for binary categorical data, like sex in the penguins dataset, and uses logistic regression to predict the missing values.

- Polytomous Regression (polyreg): Suitable for multinomial categorical data with more than two levels (e.g., species with Adelie, Gentoo, and Chinstrap). Uses polytomous regression to impute missing values.

### Impute Missing Values Using the mice Package

Given that the sex column is a binary categorical variable, we can use logreg or polyreg for imputation. For this example, we will use logreg.

Prepare the data by the selecting relevant columns we want to use as predictors to impute our missing values:


```r
# Run the mice function with maxit=0
# This allows us to extract the default predictor matrix and methods without performing actual imputation
imp <- mice(penguins, maxit=0)

# Extract the predictor matrix from the imputation object
predM <- imp$predictorMatrix
```

> Note sex will not be included for imputation unless it is coded as a factor


```r
penguins <- penguins |> 
  mutate(sex = factor(sex))
```


```r
# Extract the methods of imputation used for each variable
meth <- imp$method

# Set the imputation method for certain columns to an empty string "" to exclude them from imputation
# For these columns, missing values will be left as is and not imputed
meth["sex"] <- "logreg"

# Print the updated methods matrix to review the imputation methods assigned to each variable
meth
```

```
##        study_name     sample_number           species            region 
##                ""                ""                ""                "" 
##            island             stage     individual_id clutch_completion 
##                ""                ""                ""                "" 
##          date_egg  culmen_length_mm   culmen_depth_mm flipper_length_mm 
##                ""             "pmm"             "pmm"             "pmm" 
##       body_mass_g               sex         delta_15n         delta_13c 
##             "pmm"          "logreg"             "pmm"             "pmm" 
##          comments   date_egg_proper              year     flipper_range 
##                ""                ""                ""                ""
```



```r
# if necessary we can determine the variables that will be used for imputation
predM["sex", ] <- c(0,0,1,1,1,1,1,1,1,0,0,0,1,0,0,0,0,0,1,0)
```



```r
# With this command, we tell mice to impute the anesimp2 data, create 5
# datasets, use predM as the predictor matrix and don't print the imputation
# process. If you would like to see the process, set print as TRUE

imputed_data <- mice(penguins, maxit = 5, 
             predictorMatrix = predM, 
             method = meth, print =  FALSE)
```

### Check for convergence

In order to obtain correct results, the MICE algorithm needs to have converged. This can be checked visually by plotting summaries of the imputed values accross the iterations.

The mean and variance of the imputed values per iteration and variable are stored in the elements chainMean and chainVar of the mids object.


```r
plot(imputed_data, layout = c(4,4))
```

<img src="02a-penguin_files/figure-html/unnamed-chunk-125-1.png" width="100%" style="display: block; margin: auto;" />


Now that we know that imputation has converged, we can compare the distribution of the imputed values against the distribution of the observed values. When our imputation models fit the data well, they should have similar distributions (conditional on the covariates used in the imputation model).


```r
# Create a complete dataset with imputed values for 'sex'
penguins_imputed <- complete(imputed_data)

# Explore missing data patterns
miss_var_summary(penguins_imputed)
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> variable </th>
   <th style="text-align:right;"> n_miss </th>
   <th style="text-align:right;"> pct_miss </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> comments </td>
   <td style="text-align:right;"> 290 </td>
   <td style="text-align:right;"> 84.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> flipper_range </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0.581 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> study_name </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> sample_number </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> species </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> region </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> island </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> stage </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> individual_id </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> clutch_completion </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> date_egg </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> culmen_length_mm </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> culmen_depth_mm </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> flipper_length_mm </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> body_mass_g </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> sex </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> delta_15n </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> delta_13c </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> date_egg_proper </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> year </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
</tbody>
</table>

</div>

### Check against original data



```r
test_data <- bind_rows("original" = penguins, "imputed" = penguins_imputed, .id = "groups")

test_data |> 
  drop_na(sex) |> 
ggplot(aes(x = sex, fill = groups)) +
  geom_bar(position = "dodge") +
  labs(title = "Comparison of Categorical Distribution: Original vs Imputed",
       x = "Category",
       y = "Count") +
  facet_wrap(~ species + island)
```

<img src="02a-penguin_files/figure-html/unnamed-chunk-127-1.png" width="100%" style="display: block; margin: auto;" />


```r
# Density plots 

test_data |> 
  drop_na(sex) |> 
ggplot(aes(x = delta_15n, fill = groups)) +
    geom_density(alpha=0.5) 
```

<img src="02a-penguin_files/figure-html/unnamed-chunk-128-1.png" width="100%" style="display: block; margin: auto;" />

# Mastering Text Data

Welcome to the hands-on tutorial on string manipulation and regular expressions (regex) in R, tailored for biologists looking to advance their data-cleaning skills. In this session, we'll explore how to harness the power of R to efficiently handle and process textual data—a crucial step in preparing datasets for analysis. By mastering string manipulation functions and regex patterns, you'll learn to clean, transform, and extract valuable information from complex biological datasets. Whether you're dealing with gene sequences, sample labels, or experimental annotations, these tools will help you streamline your data workflows and enhance your research efficiency. Let's dive into the practical techniques that will elevate your data-cleaning prowess!

When working with character strings in R, the `stringr` package offers a variety of functions for evaluating and manipulating text data. Below is an overview of key functions in `stringr`, organized by their primary use cases.

If you want to use these functions, you can call them directly from `stringr` using code like this:


```r
stringr::str_c() 
stringr::str_detect() 
```

<div class="info">
<p>What is stringr?</p>
<p>stringr is a package within the tidyverse that provides a consistent
set of functions designed to make string manipulation in R easier. It
builds on the base R functions but with more straightforward syntax and
additional features for handling text data.</p>
</div>


## String Manipulation Functions
A large part of data cleaning and preparation involves manipulating character strings. Below are some common tasks and the associated stringr functions:

### Combine, Order, and Split Strings
Use these functions to join strings, sort them, or divide them into smaller components:

- `str_c()`: Concatenate strings.
- `str_glue()`: Combine strings using glue syntax.
- `str_order()`: Order or sort strings.
- `str_split()`: Split strings into substrings.

### Clean and Standardize Text

Functions to adjust text length, wrap text, or change letter case:

- `str_pad()`: Pad strings to a specified width.
- `str_trunc()`: Truncate strings to a specified length.
- `str_wrap()`: Wrap strings into a fixed width.
- `str_to_upper()`, `str_to_title()`, `str_to_lower()`, `str_to_sentence()`: Change the case of text.

### Evaluate and Extract by Position

Functions to determine string length, extract parts of a string, or specific words:

- `str_length()`: Get the length of a string.
- `str_sub()`: Extract or replace substrings by position.
- `word()`: Extract words from a string.

### Detect Patterns and Modify Text

Functions to search for patterns and modify text:

- `str_detect()`, `str_subset()`, `str_match()`, `str_extract()`: Detect, subset, match, or extract patterns.

- `str_sub()`, `str_replace_all()`: Replace substrings.

### Use Regular Expressions ("regex")

Regular expressions ("regex") provide a powerful way to define search patterns, allowing for advanced text manipulation and pattern matching.


## Unite, split, arrange

This section covers the use of various functions in R for combining, ordering, and splitting strings. 

Combine Strings
To combine or concatenate multiple strings into a single string, you can use str_c() from the stringr package. This function allows you to merge distinct character values by providing them as separate arguments, separated by commas:


```r
str_c("String1", "String2", "String3")
```

```
## [1] "String1String2String3"
```

To insert a character value between each of the arguments, use the sep = argument (e.g., to insert a comma, space, or newline "\n"):


```r
str_c("String1", "String2", "String3", sep = ", ")
```

```
## [1] "String1, String2, String3"
```

The `collapse =` argument is used when combining multiple vectors into a single character element. It specifies a separator that appears between each element of the output.


In the example below, we combine two vectors into one long string:

The `sep =` value appears between each genus and species name.

The `collapse =` value appears between each complete binomial name.

Here’s how you can apply this to the Latin binomial names of penguins from the Palmer Penguins dataset:


```r
genus <- c("Pygoscelis", "Aptenodytes", "Eudyptes") 

species <- c("adeliae", "forsteri", "chrysolophus")
```

<div class="note">
<p>Depending on your desired display context, when printing such a
combined string with newlines, you may need to wrap the whole phrase in
cat() for the newlines to print properly:</p>
</div>


```r
cat(str_c(genus, species, sep = " ", collapse = ";\n"))
```

```
## Pygoscelis adeliae;
## Aptenodytes forsteri;
## Eudyptes chrysolophus
```

### Dynamic Strings with str_glue()
The `str_glue()` function allows you to insert dynamic R code into strings, which is particularly useful for creating dynamic plot captions or reports. Here’s how to use `str_glue()` effectively:

All content goes between double quotation marks: `str_glue("")`.
Any dynamic code or references to pre-defined values are placed within curly brackets {} inside the double quotation marks.
You can include multiple curly brackets in the same `str_glue()` command.
To display single quotes within double quotes (e.g., for formatting dates), use single quotes inside the double quotes.
Use \n to insert a new line within the string.
You can use `format()` to adjust date display and `Sys.Date()` to get the current date.

Here’s a simple example of a dynamic plot caption using the Latin binomial names of penguins:


```r
 str_glue("The dataset includes ",
          {nrow(penguins)},
          " observations of penguins, with species listed as ",
          {paste(unique(penguins$species), collapse = ', ')},
          ". Data current as of ",
          {format(Sys.Date(), '%d %b %Y')},
          ".")
```

```
## The dataset includes 344 observations of penguins, with species listed as Adelie, Gentoo, Chinstrap. Data current as of 14 Sep 2024.
```

### Summarising from a dataframe

Sometimes, it is useful to pull data from a data frame and have it pasted together in sequence. Below is an example data frame. We will use it to to make a summary statement about the penguins



```r
penguins |> 
  group_by(island, species) |> 
  summarise(n = n()) |> 
  str_glue_data("{island} Island: {species} ({n} total penguins)")
```

```
## Biscoe Island: Adelie (44 total penguins)
## Biscoe Island: Gentoo (124 total penguins)
## Dream Island: Adelie (56 total penguins)
## Dream Island: Chinstrap (68 total penguins)
## Torgersen Island: Adelie (52 total penguins)
```

### Unite

To combine character values from multiple columns into a single column within a data frame, use the `unite()` function from the `tidyr` package. This function is the opposite of the `separate()` function.

Here’s how to use `unite()`:

- Provide the name of the new united column.

- List the names of the columns you want to unite.

- By default, the separator used in the united column is an underscore _, but you can change this with the `sep =` argument.

- Use `remove = TRUE` to remove the original columns after uniting (this is the default).

- Use `na.rm = TRUE` to remove missing values while uniting (default is FALSE).


```r
penguins |>  
  unite(
    col = "reproduction_status",         # name of the new united column
    c("sex", "clutch_completion", "date_egg_proper"), # columns to unite
    sep = ", ",                   # separator to use in united column
    remove = TRUE,                # if TRUE, removes input cols from the data frame
    na.rm = TRUE                  # if TRUE, missing values are removed before uniting
  ) |> 
  select(reproduction_status,species, region, island) |> 
  head()
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> reproduction_status </th>
   <th style="text-align:left;"> species </th>
   <th style="text-align:left;"> region </th>
   <th style="text-align:left;"> island </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> MALE, Yes, 2007-11-11 </td>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Anvers </td>
   <td style="text-align:left;"> Torgersen </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FEMALE, Yes, 2007-11-11 </td>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Anvers </td>
   <td style="text-align:left;"> Torgersen </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FEMALE, Yes, 2007-11-16 </td>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Anvers </td>
   <td style="text-align:left;"> Torgersen </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Yes, 2007-11-16 </td>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Anvers </td>
   <td style="text-align:left;"> Torgersen </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FEMALE, Yes, 2007-11-16 </td>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Anvers </td>
   <td style="text-align:left;"> Torgersen </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MALE, Yes, 2007-11-16 </td>
   <td style="text-align:left;"> Adelie </td>
   <td style="text-align:left;"> Anvers </td>
   <td style="text-align:left;"> Torgersen </td>
  </tr>
</tbody>
</table>

</div>

### Split columns

If you are trying to split a data frame column, it is best to use the `separate()` function from dplyr. It is used to split one character column into other columns.

Here’s how to use separate():

- Specify the column to split.

- Use into = c(...) to list the names for the new columns.

- Set sep = to define the separator (a character or a position).

- remove = TRUE (default) will remove the original column after splitting.

- Set convert = TRUE to convert "NA" strings to actual NA values (default is FALSE).

- Control handling of extra values with extra:

- extra = "warn" (default): Shows a warning and drops extra values.

- extra = "drop": Drops extra values without a warning.

- extra = "merge": Merges extra values into the last column, preserving all data.

Example with extra = "merge":


```r
penguins |> 
  select(stage) |> 
  separate(stage,
           into = c("age", "number_of_eggs", "reproductive_stage"),
           extra = "merge") |> 
  head()
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> age </th>
   <th style="text-align:left;"> number_of_eggs </th>
   <th style="text-align:left;"> reproductive_stage </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adult </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> Egg Stage </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adult </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> Egg Stage </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adult </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> Egg Stage </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adult </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> Egg Stage </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adult </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> Egg Stage </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adult </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> Egg Stage </td>
  </tr>
</tbody>
</table>

</div>

### Arrange alphabetically

Several strings can be sorted by alphabetical order. `str_order()` returns the order, while `str_sort()` returns the strings in that order.


```r
penguins |> 
  distinct(species)
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> species </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adelie </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gentoo </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chinstrap </td>
  </tr>
</tbody>
</table>

</div>




```r
# Return the alphabetical order
str_order(unique(penguins$species))
```

```
## [1] 1 3 2
```

```r
# return the strings in alphabetical order
str_sort(unique(penguins$species))
```

```
## [1] "Adelie"    "Chinstrap" "Gentoo"
```

To use a different alphabet, add the argument locale =. See the full list of locales by entering `stringi::stri_locale_list()` in the R console.

## Clean and standardise

Change Case

To change the case of strings, such as names of penguin species or islands, use `str_to_upper()`, `str_to_lower()`, and `str_to_title()` from the stringr package:


```r
# Convert to uppercase
str_to_upper("Adelie penguin")

# Convert to lowercase
str_to_lower("Adelie penguin")

# Convert to title case (capitalize each word)
str_to_title("the adelie penguin")
```

```
## [1] "ADELIE PENGUIN"
## [1] "adelie penguin"
## [1] "The Adelie Penguin"
```

Alternatively, you can use base R functions toupper() and tolower().

For title case with more control (e.g., not capitalizing small words), use toTitleCase() from the tools package:


```r
# Title case with controlled capitalization
tools::toTitleCase("the adelie penguin")
```

```
## [1] "The Adelie Penguin"
```

To capitalize only the first letter of a string, use str_to_sentence():


```r
# Capitalize the first letter of the string
str_to_sentence("the adelie penguin is small")
```

```
## [1] "The adelie penguin is small"
```


Pad Length

Use str_pad() to add characters to a string to meet a minimum length. By default, it adds spaces, but you can specify other characters with the pad argument:



```r
# Example penguin IDs of varying lengths
penguin_ids <- c("A1", "B12", "C123")

# Pad IDs to a length of 5 characters, adding spaces on the right
str_pad(penguin_ids, 5, "right")

# Pad IDs with zeros on the right
str_pad(penguin_ids, 5, "right", pad = "0")
```

```
## [1] "A1   " "B12  " "C123 "
## [1] "A1000" "B1200" "C1230"
```
To add leading zeros (e.g., for day or month values), use:


```r
# Add leading zeros to a single digit
str_pad("3", 2, pad = "0")
```

```
## [1] "03"
```

### Truncate

Use str_trunc() to limit the length of a string. If a string is too long, it will be shortened with an ellipsis (...). The ellipsis can be customized and positioned:


```r
# Truncate a string with a maximum length of 10 characters, centered
description <- "Adelie penguin found in Antarctica"
str_trunc(description, 10, "center")
```

```
## [1] "Adel...ica"
```

### Standardize Length
First, truncate strings to a maximum length, then pad short strings to ensure uniform length:


```r
# Example penguin IDs
penguin_ids <- c("A1", "B123456", "C789")

# Truncate to a maximum length of 3 characters
truncated_ids <- str_trunc(penguin_ids, 6)
truncated_ids

# Pad to a minimum length of 6 characters
standardized_ids <- str_pad(penguin_ids, 6, "right")
standardized_ids 
```

```
## [1] "A1"     "B12..." "C789"  
## [1] "A1    "  "B123456" "C789  "
```
### Remove Leading/Trailing Whitespace
Use str_trim() to remove extra spaces, newlines (\n), or tabs (\t) from the sides of a string. Specify which side to trim:


```r
# Example penguin IDs with extra spaces
penguin_ids <- c("A1  ", "B123", "C789 ")

# Remove extra spaces from both sides
str_trim(penguin_ids)
```

```
## [1] "A1"   "B123" "C789"
```
### Remove Repeated Whitespace Within Strings
Use str_squish() to replace multiple spaces within a string with a single space and also trim spaces from the edges:


```r
# Example text with extra spaces
text <- "  Adelie   penguin   found  in  Antarctica \n"

# Remove repeated spaces and trim edges
str_squish(text)
```

```
## [1] "Adelie penguin found in Antarctica"
```
### Wrap Into Paragraphs

Use str_wrap() to format long text into structured paragraphs with a fixed line length:


```r
# Long text about penguins
text <- "The Adelie penguin is found in Antarctica. It is known for its distinctive white ring around the eyes and its black back. The penguin is well adapted to the harsh climate."

# Wrap text to a line length of 40 characters
wrapped_text <- str_wrap(text, 40)

# Print the wrapped text with line breaks
cat(wrapped_text)
```

```
## The Adelie penguin is found in
## Antarctica. It is known for its
## distinctive white ring around the eyes
## and its black back. The penguin is well
## adapted to the harsh climate.
```

## Position

### Extract by Character Position

To extract specific parts of a string, use str_sub(). 

This function requires:

- The character vector(s)
- The start position
- The end position

Position Notes:

- Positive numbers count from the left.

- Negative numbers count from the right.

- Positions are inclusive.

- If positions exceed the string length, they will be truncated.


```r
# Extracting characters from a string
species <- "AdeliePenguin"

# 3rd character from the left
str_sub(species, 3, 3)

# No character at position 0 (invalid)
str_sub(species, 0, 0)

# 6th character from the left to the 1st character from the right
str_sub(species, 6, -1)

# 5th character from the right to the 2nd character from the right
str_sub(species, -5, -2)

# 4th character to a position beyond the string length
str_sub(species, 4, 15)
```

```
## [1] "e"
## [1] ""
## [1] "ePenguin"
## [1] "ngui"
## [1] "liePenguin"
```
### Extract by Word Position
To extract specific words from a string, use word(). This function requires:

- The string(s)

- The starting word position

- The ending word position

By default, words are separated by spaces. Use `sep =` to specify a different separator if needed.

Example:


```r
# Example descriptions of penguin species
descriptions <- c("Adelie penguin found in Antarctica",
                   "Chinstrap penguin from South Shetland Islands",
                   "Gentoo penguin known for its bright orange beak")

# Extract the 1st to 3rd words of each description
word(descriptions, start = 1, end = 3, sep = " ")
```

```
## [1] "Adelie penguin found"   "Chinstrap penguin from" "Gentoo penguin known"
```

### Replace by Character Position

You can modify part of a string using `str_sub()` with the assignment operator (<-):

Example:


```r
# Modify a string
species <- "AdeliePenguin"

# Replace the 3rd and 4th characters with "XX"
str_sub(species, 3, 4) <- "XX"

# Print the modified string
species
```

```
## [1] "AdXXiePenguin"
```


### Multiple strings


```r
# Multiple species names
species_list <- c("AdeliePenguin", "ChinstrapPenguin", "GentooPenguin")

# Replace the 3rd and 4th characters with "XX" in each string
str_sub(species_list, 3, 4) <- "XX"

# Print the modified list
species_list
```

```
## [1] "AdXXiePenguin"    "ChXXstrapPenguin" "GeXXooPenguin"
```

### Evaluate Length

To get the length of a string, use str_length():


```r
# Get the length of a string
str_length("AdeliePenguin")


### Alternatively, use nchar() from base R
```

```
## [1] 13
```
## Patterns

Many stringr functions help to detect, locate, extract, match, replace, and split based on a specified pattern.

### Detect a Pattern

Use str_detect() to check if a pattern exists within a string. Provide the string or vector to search in (string =), and the pattern to look for (pattern =). By default, the search is case-sensitive.


```r
# Check if "penguin" is present in the string
str_detect(string = "Adelie penguin observed", pattern = "penguin")
```

```
## [1] TRUE
```

To find if the pattern is NOT present, use negate = TRUE:


```r
# Check if "penguin" is not present in the string
str_detect(string = "Adelie penguin observed", pattern = "penguin", negate = TRUE)
```

```
## [1] FALSE
```

To ignore case, use regex() with ignore_case = TRUE:


```r
# Case-insensitive search for "penguin"
str_detect(string = "ADELIE PENGUIN OBSERVED", pattern = regex("penguin", ignore_case = TRUE))
```

```
## [1] TRUE
```

When applied to a character vector or data frame column, `str_detect()` returns TRUE or FALSE for each value:


```r
# Vector of penguin observations
observations <- c("Adelie penguin in the area",
                   "Chinstrap penguin spotted",
                   "Gentoo penguin identified",
                   "No penguin sighted today",
                   "Egg clutch data collected")

# Detect presence of "penguin" in each observation
str_detect(observations, "penguin")
```

```
## [1]  TRUE  TRUE  TRUE  TRUE FALSE
```
To count the number of TRUE values, use sum():


```r
# Count the number of observations containing "penguin"
sum(str_detect(observations, "penguin"))
```

```
## [1] 4
```

For multiple search terms, use `|` within `pattern =`:


```r
# Count occurrences of "penguin" or "spotted"
sum(str_detect(string = observations, pattern = "spotted|identified"))
```

```
## [1] 2
```
To build a list of search terms, combine them with str_c() and sep = "|", then use this vector:


```r
# Search terms for different penguin species
penguin_species <- str_c("Adelie", "Chinstrap", "Gentoo", sep = "|")

# Count observations containing any species
sum(str_detect(string = observations, pattern = penguin_species))
```

```
## [1] 3
```

### Base R String Search Functions
In base R, `grepl()` functions similarly to `str_detect()`, returning a logical vector indicating matches to a pattern. Use ignore.case = TRUE for case-insensitive searches:


```r
# Case-insensitive search for "penguin" using base R
grepl(pattern = "penguin", x = "ADELIE PENGUIN OBSERVED", ignore.case = TRUE)
```

```
## [1] TRUE
```

Base functions sub() and gsub() work similarly to str_replace(). sub() replaces the first instance, while gsub() replaces all instances:


```r
# Replace the first instance of "penguin" with "bird"
sub(pattern = "penguin", replacement = "bird", x = "Adelie penguin spotted")

# Replace all instances of "penguin" with "bird"
gsub(pattern = "penguin", replacement = "bird", x = "Adelie penguin and Chinstrap penguin observed")
```

```
## [1] "Adelie bird spotted"
## [1] "Adelie bird and Chinstrap bird observed"
```
### Replace All

Use str_replace_all() to replace all instances of a pattern in a string. Provide the strings to be evaluated with string =, the pattern to replace with pattern =, and the replacement value with replacement =. 

> Note that this operation is case-sensitive.



```r
# Example vector with penguin observations
observations <- c("Adelie penguin observed", 
                   "Chinstrap penguin seen", 
                  "No Adelie penguins observed today",
                   "No penguin spotted")

# Replace all instances of "penguin" with "bird"
str_replace_all(string = observations, pattern = "penguin", replacement = "bird")
```

```
## [1] "Adelie bird observed"           "Chinstrap bird seen"           
## [3] "No Adelie birds observed today" "No bird spotted"
```

Notes:

- To replace a pattern with NA, use str_replace_na().

- The function str_replace() only replaces the first occurrence of the pattern within each string.

### Detect Within Logic

Using case_when()

You can use str_detect() within case_when() from dplyr to create new columns based on pattern matching. For instance, if observations is a column in a data frame, you can create a new column indicating whether each observation is related to penguins.


```r
as_tibble(observations) |> 
  mutate(penguin_related = case_when(
    # Check if observation mentions any penguin species
    str_detect(value,
               regex("Adelie|Chinstrap|Gentoo", 
                     ignore_case = TRUE)) ~ "Penguin-related",
    # All other observations
    TRUE ~ "Not penguin-related"))
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> value </th>
   <th style="text-align:left;"> penguin_related </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adelie penguin observed </td>
   <td style="text-align:left;"> Penguin-related </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chinstrap penguin seen </td>
   <td style="text-align:left;"> Penguin-related </td>
  </tr>
  <tr>
   <td style="text-align:left;"> No Adelie penguins observed today </td>
   <td style="text-align:left;"> Penguin-related </td>
  </tr>
  <tr>
   <td style="text-align:left;"> No penguin spotted </td>
   <td style="text-align:left;"> Not penguin-related </td>
  </tr>
</tbody>
</table>

</div>

### Adding Exclusion Criteria

To refine the search and exclude certain terms, add additional conditions. For example, if you want to include only observations related to penguins but exclude specific terms like "fake":


```r
as_tibble(observations) |> 
  mutate(penguin_related = case_when(
    # Must mention a penguin species
    str_detect(observations,
               regex("Adelie|Chinstrap|Gentoo", ignore_case = TRUE)) &  
    
    # AND must NOT mention "fake"
    str_detect(observations,
               regex("No", ignore_case = TRUE),
               negate = TRUE) ~ "Penguin-sighting",
    
    # All others
    TRUE ~ "Not a sighting"))
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> value </th>
   <th style="text-align:left;"> penguin_related </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adelie penguin observed </td>
   <td style="text-align:left;"> Penguin-sighting </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chinstrap penguin seen </td>
   <td style="text-align:left;"> Penguin-sighting </td>
  </tr>
  <tr>
   <td style="text-align:left;"> No Adelie penguins observed today </td>
   <td style="text-align:left;"> Not a sighting </td>
  </tr>
  <tr>
   <td style="text-align:left;"> No penguin spotted </td>
   <td style="text-align:left;"> Not a sighting </td>
  </tr>
</tbody>
</table>

</div>

### Extract a Match

Use str_extract_all() to find all instances of a pattern within a string. This is useful when you're searching for multiple patterns using "OR" conditions. For example, to search for the patterns "Adelie", "Chinstrap", or "Gentoo" in a vector of penguin observations:


```r
# Example vector with penguin observations
observations <- c("Adelie penguin seen",
                   "Chinstrap penguin observed",
                   "Gentoo and Adelie penguins spotted",
                   "No penguin mentioned")

# Extract all matches for penguin species
str_extract_all(observations, "Adelie|Chinstrap|Gentoo")
```

```
## [[1]]
## [1] "Adelie"
## 
## [[2]]
## [1] "Chinstrap"
## 
## [[3]]
## [1] "Gentoo" "Adelie"
## 
## [[4]]
## character(0)
```
str_extract_all() returns a list where each element contains all matches found in the corresponding string. For example, in the third observation, both "Gentoo" and "Adelie" are found.

### Extracting the First Match

Use str_extract() to retrieve only the first match for each string. This function produces a character vector where each element contains the first match found or NA if no match is present. To remove NA values, you can wrap the result with na.exclude().


```r
# Extract only the first match for penguin species
str_extract(observations, "Adelie|Chinstrap|Gentoo")
```

```
## [1] "Adelie"    "Chinstrap" "Gentoo"    NA
```
In this example, only the first match for each string is returned, so in the third observation, only "Gentoo" is shown, and "Adelie" is not included.


### Subset and Count

Subset Values

Use str_subset() to get the actual strings that contain a specific pattern. For instance, to find which observations mention the penguin species "Adelie", "Chinstrap", or "Gentoo":


```r
# Example vector with penguin observations
observations <- c("Adelie penguin seen",
                   "Chinstrap penguin observed",
                   "Gentoo and Adelie penguins spotted",
                   "No penguin mentioned")

# Get observations that mention any of the specified penguin species
str_subset(observations, "Adelie|Chinstrap|Gentoo")
```

```
## [1] "Adelie penguin seen"                "Chinstrap penguin observed"        
## [3] "Gentoo and Adelie penguins spotted"
```

str_subset() returns a vector of strings where the pattern is found.


### Count Matches

Use str_count() to count how many times a specific pattern appears in each string. For example, to count occurrences of "Adelie", "Chinstrap", or "Gentoo" in each observation:


```r
# Count the number of times each pattern appears in the observations
str_count(observations, regex("Adelie|Chinstrap|Gentoo", ignore_case = TRUE))
```

```
## [1] 1 1 2 0
```

str_count() provides a vector with the count of each pattern found in the corresponding string.


## Regex

Regular expressions (regex) are a powerful tool for pattern matching within strings. They allow you to define search patterns using a combination of literal characters and special symbols. Here's a brief overview of how regex works and how it can be applied in string manipulation tasks.

Key Concepts:

- Literal Characters: These are the basic characters you search for, such as letters or digits. For example, the regex "penguin" searches for the exact word "penguin".

- Special Characters: Regex uses special characters to denote patterns. Some commonly used ones include:

- . (dot): Matches any single character except a newline.

- \* (asterisk): Matches zero or more of the preceding element.

- \+ (plus): Matches one or more of the preceding element.

- \? (question mark): Matches zero or one of the preceding element.

- \| (pipe): Acts as a logical OR to match any one of several patterns.

- [] (square brackets): Defines a character class, e.g., [aeiou] matches any vowel or [0-9] matches any number

- () (parentheses): Groups patterns together.


Here’s an example string with a number of observations made. We can use it to demonstrate the basic usage of the regex functions:


```r
basic_string <- "Today Observer A spotted  3 Adelie adults and 4 Chinstraps, Observe B has spotted 12 Adelie and 6 Gentoo penguins"
```


- Match a group of characters: We can find all of the vowels in our string by putting every vowel in brackets, for example,[aeiou]


```r
str_extract_all(basic_string, "[aeiou]")
```

```
## [[1]]
##  [1] "o" "a" "e" "e" "o" "e" "e" "i" "e" "a" "u" "a" "i" "a" "e" "e" "a" "o" "e"
## [20] "e" "i" "e" "a" "e" "o" "o" "e" "u" "i"
```

- Match a range of characters: We can find any capital letter from “A” to “F,” by using a hyphen, [A-F]. Character sets are case sensitive, so [A-F] is not the same as [a-f]


```r
str_extract_all(basic_string, "[A-Z]")
```

```
## [[1]]
## [1] "T" "O" "A" "A" "C" "O" "B" "A" "G"
```

Match a range of numbers: We can find numbers between a range by adding numbers to our character set, [0-9] to find any number. Notice that the numbers are extracted as strings, not converted to numbers


```r
str_extract_all(basic_string, "[0-9]")
```

```
## [[1]]
## [1] "3" "4" "1" "2" "6"
```

### Meta characters

Meta characters represent a type of character. They will typically begin with a backslash \\. Since the backslash \\ is a special character in R, it needs to be escaped each time it is used with another backslash. In other words, **R requires 2 backslashes when using meta characters**. Each meta character will match to a single character. Here are some of the most important ones in action:

- \\\s: This meta character represents spaces. This will match to each space, tab, and newline character. You may also specify \\\t and \\\n for tab and newline characters respectively. 

> Side note: our example string does not have any tabs, but be cautious when looking for them. Many integrated development environments, or IDE’s, have a setting that will replace all tabs with spaces while you are typing. In the example string, \\\s returns a list of a vector of 17 spaces, the exact number of spaces in our example string!

- \\\w: This meta character represents alphanumeric characters. This includes all the letters a-z, capital and lowercase, and the numbers 0–9. This would be the equivalent of the bracket group [A-Za-z0-9], just much quicker to write. Take caution in remembering that the \\\w meta character on its own only captures a single character, not entire words or numbers. 

\\\d: This metacharacter matches any digits (numbers), the equivalent of [0-9]. 

## Anchors away

A text anchor says to look for matches either at the beginning or end of a string. In R, there are 2 types of anchors:

- ^: Matches the following regex at the beginning of a string

- $: Matches the preceding regex at the end of a string

### Raising the anchor

When working with text data, you may need to match a regex pattern, but only if it appears as the first thing in the string. To do that, we use the ^ anchor.

To demonstrate, our goal is to find the word “the,” but only if it appears at the beginning of a string. Here are a few example strings for use to try it out with.


```r
anchor <- "The ship sets sail on the ocean"
anchor_n <- "Ships set sail on the ocean to go places"
```


```r
str_extract_all(c(anchor, anchor_n), "^[Tt]")
```

```
## [[1]]
## [1] "T"
## 
## [[2]]
## character(0)
```

### Dropping the anchor

Sometimes you need to match a regex pattern only if it appears at the end of a string. This is accomplished with the $ anchor.
Let’s take another look at the anchor string, this time looking for “ocean” at the end of the string. We will have one result, “ocean.”



```r
str_extract_all(c(anchor, anchor_n), "ocean$")
```

```
## [[1]]
## [1] "ocean"
## 
## [[2]]
## character(0)
```

## Negation

In strings, you may want to specify certain patterns to avoid. To do this, use negations. These will match anything EXCEPT what you specify. There are two main ways to handle them in R:

- Capitalized meta characters: meta characters match a specific set of characters. A capitalized meta character will generally match everything but that set of characters

- ^ and character sets: Using a ^ in conjunction with a character set will match everything except what is specified in the character set

### Capitalised meta characters


```r
str_extract_all(anchor, "\\S")

str_extract_all(anchor, "\\s")
```

```
## [[1]]
##  [1] "T" "h" "e" "s" "h" "i" "p" "s" "e" "t" "s" "s" "a" "i" "l" "o" "n" "t" "h"
## [20] "e" "o" "c" "e" "a" "n"
## 
## [[1]]
## [1] " " " " " " " " " " " "
```

### Character sets


```r
str_extract_all(anchor, "[ocean]")

str_extract_all(anchor, "[^ocean]")
```

```
## [[1]]
##  [1] "e" "e" "a" "o" "n" "e" "o" "c" "e" "a" "n"
## 
## [[1]]
##  [1] "T" "h" " " "s" "h" "i" "p" " " "s" "t" "s" " " "s" "i" "l" " " " " "t" "h"
## [20] " "
```



### Look behind

The general formula for a look ahead is "(?<=if preceded by this)match_this"

Example: Match "penguin" only if it is preceded by "Palmer".


```r
# Example string
text <- c("The Palmer penguin is adorable.", "I love all types of penguins.", "The Emperor penguin is larger.")

# Match "penguin" only if it is followed by "Palmer"
str_extract_all(text, "(?<= Palmer)\\spenguin")
```

```
## [[1]]
## [1] " penguin"
## 
## [[2]]
## character(0)
## 
## [[3]]
## character(0)
```


### Look ahead



```r
# Match "Palmer" only if it is followed by "penguin"
str_extract_all(text, "Palmer\\s(?=penguin )")
```

```
## [[1]]
## [1] "Palmer "
## 
## [[2]]
## character(0)
## 
## [[3]]
## character(0)
```


## Exercises


`rvest` helps you scrape (or harvest) data from web pages: 


```r
library(rvest)

wiki <- "https://en.wikipedia.org/wiki/Model_organism"

all_tables <- read_html(wiki) |> 
  html_table()
```


This will give you a list of all the tables that are on the website. Here, we will just consider the first one that was found on the website. 



```r
all_tables[[1]]
```

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;">  </th>
   <th style="text-align:left;"> Model Organism </th>
   <th style="text-align:left;"> Common name </th>
   <th style="text-align:left;"> Informal classification </th>
   <th style="text-align:left;"> Usage (examples) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Virus </td>
   <td style="text-align:left;"> Phi X 174 </td>
   <td style="text-align:left;"> ΦX174 </td>
   <td style="text-align:left;"> Virus </td>
   <td style="text-align:left;"> evolution[100] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Prokaryotes </td>
   <td style="text-align:left;"> Escherichia coli </td>
   <td style="text-align:left;"> E. coli </td>
   <td style="text-align:left;"> Bacteria </td>
   <td style="text-align:left;"> bacterial genetics, metabolism </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Prokaryotes </td>
   <td style="text-align:left;"> Pseudomonas fluorescens </td>
   <td style="text-align:left;"> P. fluorescens </td>
   <td style="text-align:left;"> Bacteria </td>
   <td style="text-align:left;"> evolution, adaptive radiation[101] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Eukaryotes, unicellular </td>
   <td style="text-align:left;"> Dictyostelium discoideum </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Amoeba </td>
   <td style="text-align:left;"> immunology, host–pathogen interactions[102] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Eukaryotes, unicellular </td>
   <td style="text-align:left;"> Saccharomyces cerevisiae </td>
   <td style="text-align:left;"> Brewer's yeastBaker's yeast </td>
   <td style="text-align:left;"> Yeast </td>
   <td style="text-align:left;"> cell division, organelles, etc. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Eukaryotes, unicellular </td>
   <td style="text-align:left;"> Schizosaccharomyces pombe </td>
   <td style="text-align:left;"> Fission yeast </td>
   <td style="text-align:left;"> Yeast </td>
   <td style="text-align:left;"> cell cycle, cytokinesis, chromosome biology, telomeres, DNA metabolism, cytoskeleton organization, industrial applications[103][104] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Eukaryotes, unicellular </td>
   <td style="text-align:left;"> Chlamydomonas reinhardtii </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Algae </td>
   <td style="text-align:left;"> hydrogen production[105] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Eukaryotes, unicellular </td>
   <td style="text-align:left;"> Tetrahymena thermophila, T. pyriformis </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Ciliate </td>
   <td style="text-align:left;"> education,[106] biomedical research[107] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Eukaryotes, unicellular </td>
   <td style="text-align:left;"> Emiliania huxleyi </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Plankton </td>
   <td style="text-align:left;"> surface sea temperature[108] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Plants </td>
   <td style="text-align:left;"> Arabidopsis thaliana </td>
   <td style="text-align:left;"> Thale cress </td>
   <td style="text-align:left;"> Flowering plant </td>
   <td style="text-align:left;"> population genetics[109] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Plants </td>
   <td style="text-align:left;"> Physcomitrella patens </td>
   <td style="text-align:left;"> Spreading earthmoss </td>
   <td style="text-align:left;"> Moss </td>
   <td style="text-align:left;"> molecular farming[110] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Plants </td>
   <td style="text-align:left;"> Populus trichocarpa </td>
   <td style="text-align:left;"> Balsam poplar </td>
   <td style="text-align:left;"> Tree </td>
   <td style="text-align:left;"> drought tolerance, lignin biosynthesis, wood formation, plant biology, morphology, genetics, and ecology[111] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, nonvertebrate </td>
   <td style="text-align:left;"> Caenorhabditis elegans </td>
   <td style="text-align:left;"> Nematode, Roundworm </td>
   <td style="text-align:left;"> Worm </td>
   <td style="text-align:left;"> differentiation, development </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, nonvertebrate </td>
   <td style="text-align:left;"> Drosophila melanogaster </td>
   <td style="text-align:left;"> Fruit fly </td>
   <td style="text-align:left;"> Insect </td>
   <td style="text-align:left;"> developmental biology, human brain degenerative disease[112][113] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, nonvertebrate </td>
   <td style="text-align:left;"> Callosobruchus maculatus </td>
   <td style="text-align:left;"> Cowpea Weevil </td>
   <td style="text-align:left;"> Insect </td>
   <td style="text-align:left;"> developmental biology </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Danio rerio </td>
   <td style="text-align:left;"> Zebrafish </td>
   <td style="text-align:left;"> Fish </td>
   <td style="text-align:left;"> embryonic development </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Fundulus heteroclitus </td>
   <td style="text-align:left;"> Mummichog </td>
   <td style="text-align:left;"> Fish </td>
   <td style="text-align:left;"> effect of hormones on behavior[114] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Nothobranchius furzeri </td>
   <td style="text-align:left;"> Turquoise killifish </td>
   <td style="text-align:left;"> Fish </td>
   <td style="text-align:left;"> aging, disease, evolution </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Oryzias latipes </td>
   <td style="text-align:left;"> Japanese rice fish </td>
   <td style="text-align:left;"> Fish </td>
   <td style="text-align:left;"> fish biology, sex determination[115] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Anolis carolinensis </td>
   <td style="text-align:left;"> Carolina anole </td>
   <td style="text-align:left;"> Reptile </td>
   <td style="text-align:left;"> reptile biology, evolution </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Mus musculus </td>
   <td style="text-align:left;"> House mouse </td>
   <td style="text-align:left;"> Mammal </td>
   <td style="text-align:left;"> disease model for humans </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Gallus gallus </td>
   <td style="text-align:left;"> Red junglefowl </td>
   <td style="text-align:left;"> Bird </td>
   <td style="text-align:left;"> embryological development and organogenesis </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Taeniopygia castanotis </td>
   <td style="text-align:left;"> Australian zebra finch </td>
   <td style="text-align:left;"> Bird </td>
   <td style="text-align:left;"> vocal learning, neurobiology[116] </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Xenopus laevisXenopus tropicalis[117] </td>
   <td style="text-align:left;"> African clawed frogWestern clawed frog </td>
   <td style="text-align:left;"> Amphibian </td>
   <td style="text-align:left;"> embryonic development </td>
  </tr>
</tbody>
</table>

</div>


### Clean

Our aim is to produce a table as follows that has: 

- Clean and standardised common names
- Separated model organisms into multiple columns if they contain multiple names
- Cleaned up extraneous characters
- Use regular expressions to remove numeric references
- pivot if applicable

<div class="kable-table">

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> informal_phylum </th>
   <th style="text-align:left;"> model_organism </th>
   <th style="text-align:left;"> common_name </th>
   <th style="text-align:left;"> informal_classification </th>
   <th style="text-align:left;"> usage_examples </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Virus </td>
   <td style="text-align:left;"> Phi X 174 </td>
   <td style="text-align:left;"> ΦX174 </td>
   <td style="text-align:left;"> Virus </td>
   <td style="text-align:left;"> evolution </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Prokaryotes </td>
   <td style="text-align:left;"> Escherichia coli </td>
   <td style="text-align:left;"> E. coli </td>
   <td style="text-align:left;"> Bacteria </td>
   <td style="text-align:left;"> bacterial genetics, metabolism </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Prokaryotes </td>
   <td style="text-align:left;"> Pseudomonas fluorescens </td>
   <td style="text-align:left;"> P. fluorescens </td>
   <td style="text-align:left;"> Bacteria </td>
   <td style="text-align:left;"> evolution, adaptive radiation </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Eukaryotes, unicellular </td>
   <td style="text-align:left;"> Dictyostelium discoideum </td>
   <td style="text-align:left;"> Unknown </td>
   <td style="text-align:left;"> Amoeba </td>
   <td style="text-align:left;"> immunology, host–pathogen interactions </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Eukaryotes, unicellular </td>
   <td style="text-align:left;"> Saccharomyces cerevisiae </td>
   <td style="text-align:left;"> Brewer's yeastBaker's yeast </td>
   <td style="text-align:left;"> Yeast </td>
   <td style="text-align:left;"> cell division, organelles, etc. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Eukaryotes, unicellular </td>
   <td style="text-align:left;"> Schizosaccharomyces pombe </td>
   <td style="text-align:left;"> Fission yeast </td>
   <td style="text-align:left;"> Yeast </td>
   <td style="text-align:left;"> cell cycle, cytokinesis, chromosome biology, telomeres, DNA metabolism, cytoskeleton organization, industrial applications </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Eukaryotes, unicellular </td>
   <td style="text-align:left;"> Chlamydomonas reinhardtii </td>
   <td style="text-align:left;"> Unknown </td>
   <td style="text-align:left;"> Algae </td>
   <td style="text-align:left;"> hydrogen production </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Eukaryotes, unicellular </td>
   <td style="text-align:left;"> Tetrahymena thermophila </td>
   <td style="text-align:left;"> Unknown </td>
   <td style="text-align:left;"> Ciliate </td>
   <td style="text-align:left;"> education, biomedical research </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Eukaryotes, unicellular </td>
   <td style="text-align:left;"> Tetrahymena pyriformis </td>
   <td style="text-align:left;"> Unknown </td>
   <td style="text-align:left;"> Ciliate </td>
   <td style="text-align:left;"> education, biomedical research </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Eukaryotes, unicellular </td>
   <td style="text-align:left;"> Emiliania huxleyi </td>
   <td style="text-align:left;"> Unknown </td>
   <td style="text-align:left;"> Plankton </td>
   <td style="text-align:left;"> surface sea temperature </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Plants </td>
   <td style="text-align:left;"> Arabidopsis thaliana </td>
   <td style="text-align:left;"> Thale cress </td>
   <td style="text-align:left;"> Flowering plant </td>
   <td style="text-align:left;"> population genetics </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Plants </td>
   <td style="text-align:left;"> Physcomitrella patens </td>
   <td style="text-align:left;"> Spreading earthmoss </td>
   <td style="text-align:left;"> Moss </td>
   <td style="text-align:left;"> molecular farming </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Plants </td>
   <td style="text-align:left;"> Populus trichocarpa </td>
   <td style="text-align:left;"> Balsam poplar </td>
   <td style="text-align:left;"> Tree </td>
   <td style="text-align:left;"> drought tolerance, lignin biosynthesis, wood formation, plant biology, morphology, genetics, and ecology </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, nonvertebrate </td>
   <td style="text-align:left;"> Caenorhabditis elegans </td>
   <td style="text-align:left;"> Nematode, Roundworm </td>
   <td style="text-align:left;"> Worm </td>
   <td style="text-align:left;"> differentiation, development </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, nonvertebrate </td>
   <td style="text-align:left;"> Drosophila melanogaster </td>
   <td style="text-align:left;"> Fruit fly </td>
   <td style="text-align:left;"> Insect </td>
   <td style="text-align:left;"> developmental biology, human brain degenerative disease </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, nonvertebrate </td>
   <td style="text-align:left;"> Callosobruchus maculatus </td>
   <td style="text-align:left;"> Cowpea Weevil </td>
   <td style="text-align:left;"> Insect </td>
   <td style="text-align:left;"> developmental biology </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Danio rerio </td>
   <td style="text-align:left;"> Zebrafish </td>
   <td style="text-align:left;"> Fish </td>
   <td style="text-align:left;"> embryonic development </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Fundulus heteroclitus </td>
   <td style="text-align:left;"> Mummichog </td>
   <td style="text-align:left;"> Fish </td>
   <td style="text-align:left;"> effect of hormones on behavior </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Nothobranchius furzeri </td>
   <td style="text-align:left;"> Turquoise killifish </td>
   <td style="text-align:left;"> Fish </td>
   <td style="text-align:left;"> aging, disease, evolution </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Oryzias latipes </td>
   <td style="text-align:left;"> Japanese rice fish </td>
   <td style="text-align:left;"> Fish </td>
   <td style="text-align:left;"> fish biology, sex determination </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Anolis carolinensis </td>
   <td style="text-align:left;"> Carolina anole </td>
   <td style="text-align:left;"> Reptile </td>
   <td style="text-align:left;"> reptile biology, evolution </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Mus musculus </td>
   <td style="text-align:left;"> House mouse </td>
   <td style="text-align:left;"> Mammal </td>
   <td style="text-align:left;"> disease model for humans </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Gallus gallus </td>
   <td style="text-align:left;"> Red junglefowl </td>
   <td style="text-align:left;"> Bird </td>
   <td style="text-align:left;"> embryological development and organogenesis </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Taeniopygia castanotis </td>
   <td style="text-align:left;"> Australian zebra finch </td>
   <td style="text-align:left;"> Bird </td>
   <td style="text-align:left;"> vocal learning, neurobiology </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Xenopus laevis </td>
   <td style="text-align:left;"> African clawed frogWestern clawed frog </td>
   <td style="text-align:left;"> Amphibian </td>
   <td style="text-align:left;"> embryonic development </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animals, vertebrate </td>
   <td style="text-align:left;"> Xenopus tropicalis </td>
   <td style="text-align:left;"> African clawed frogWestern clawed frog </td>
   <td style="text-align:left;"> Amphibian </td>
   <td style="text-align:left;"> embryonic development </td>
  </tr>
</tbody>
</table>

</div>


<button id="displayTextunnamed-chunk-187" onclick="javascript:toggle('unnamed-chunk-187');">Show Solution</button>

<div id="toggleTextunnamed-chunk-187" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
# Select the first table from the list `all_tables`
selected_table <- all_tables[[1]] |> 
  # Clean column names using the `janitor` package
  janitor::clean_names() |> 
  # Rename the column `x` to `informal_phylum`
  rename("informal_phylum" = x)


selected_table |> 
  # Replace empty `common_name` fields with "Unknown"
  mutate(common_name = if_else(common_name == "", "Unknown", common_name)) |> 
  # Remove all occurrences of square brackets with any digits inside them
  mutate(across(.cols = everything(), .fns = ~ str_remove_all(.x, "\\[([0-9]*)\\]"))) |> 
  # Replace multiple consecutive `Xenopus [a-z]+` with comma separation
  mutate(model_organism = str_replace(model_organism, "(Xenopus [a-z]+)(Xenopus [a-z]+)", "\\1,\\2")) |> 
  # Split `model_organism` at commas into a list of values
  mutate(model_organism = str_split(model_organism, ",")) |> 
  # Unnest the list in `model_organism` so that each value is in a separate row
  unnest(model_organism) |> 
  # Trim whitespace from each value in `model_organism`
  mutate(model_organism = str_trim(model_organism)) |> 
  # Replace `T.` at the start of `model_organism` with `Tetrahymena`
  mutate(model_organism = str_replace(model_organism, "^T\\.", "Tetrahymena"))
```

</div></div></div>
