# Customisation with ggplot2








Up until now, we've created basic plots with the default visual style. Before we dive into working with experimental data, let's explore some straightforward ways to personalize our visuals. There are numerous ways to tweak and tailor the look of your plots in R, but once you grasp the concept behind one customization, you'll find it easier to apply similar principles in other examples.

You can customize the appearance of elements within a specific plot element, through aesthetic mapping, or by adding extra layers using the plus sign (+). In this section, we'll focus on the most common and easy-to-implement customizations, like changing colors, including axis labels, and applying different themes to your plots.

<div class="info">
<p>You will need your cleaned penguins dataframe from Day One.</p>
</div>

## Colours

There are two main differences when it comes to colors in `ggplot2`. Both arguments, color and fill, can be specified as single color or
assigned to variables.

As you have already seen in this tutorial, variables that are inside the aesthetics are encoded by variables and those that are outside are properties that are unrelated to the variables.


```r
penguins |> 
    ggplot(aes(x=culmen_length_mm))+
    geom_histogram(bins=50, 
                   aes(y=..density..,
                       fill=species), 
                   position = "identity",
                   colour="black")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-4-1.png" width="100%" style="display: block; margin: auto;" />

### Choosing and using colour palettes

You can specify what colours you want to assign to variables in a number of different ways. 

In ggplot2, colors that are assigned to variables are modified via the scale_color_* and the scale_fill_* functions. In order to use color with your data, most importantly you need to know if you are dealing with a categorical or continuous variable. The color palette should be chosen depending on type of the variable:

* **sequential or diverging** color palettes being used for continuous variables 

* **qualitative** color palettes for (unordered) categorical variables:

<img src="images/palette.png" width="80%" style="display: block; margin: auto;" />

You can pick your own sets of colours and assign them to a categorical variable. The number of specified colours **has** to match the number of categories. You can use a wide number of preset colour [names](https://www.datanovia.com/en/blog/awesome-list-of-657-r-color-names/) or you can use [hexadecimals](https://www.datanovia.com/en/blog/awesome-list-of-hexadecimal-colors-you-should-have/). 



```r
## Custom colours ----

pal <- c(
  "Adelie" = "#FF8C00", 
  "Chinstrap" = "#A034F0", 
  "Gentoo" = "#159090")

penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g))+
  geom_point(aes(colour=species))+
  scale_color_manual(values=pal)+
  theme_minimal()
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-6-1.png" width="100%" style="display: block; margin: auto;" />

You can also use a range of inbuilt colour palettes: 


```r
penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g))+
  geom_point(aes(colour=species))+
  scale_color_brewer(palette="Set1")+
  theme_minimal()
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-7-1.png" width="100%" style="display: block; margin: auto;" />


<div class="info">
<p>You can explore all schemes available with the command
<code>RColorBrewer::display.brewer.all()</code></p>
</div>

There are also many, many extensions that provide additional colour palettes. Some of my favourite packages include [ggsci](https://cran.r-project.org/web/packages/ggsci/vignettes/ggsci.html) and [wesanderson](https://github.com/karthik/wesanderson)

<img src="images/wesanderson.png" width="80%" style="display: block; margin: auto;" />

### Redundant aesthetics

Specifications made using `aes()` are inherited from the top layer of a ggplot by default. This means that if you set an aesthetic mapping at the beginning of your ggplot, it will apply to all subsequent layers *unless you explicitly override it in a specific layer*. This inheritance simplifies the process of maintaining consistent aesthetics throughout your plot.


```r
penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g))+
  geom_point(aes(colour=species))+
  geom_smooth(aes(colour = species), # both geoms use aes(colour = species)
              method = "lm", se = FALSE) +
  scale_color_brewer(palette="Set1")+
  theme_minimal()
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-10-1.png" width="100%" style="display: block; margin: auto;" />


```r
penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g,
             colour = species))+ # this can be set at the ggplot layer
  geom_point()+
  geom_smooth(method = "lm", se  = FALSE) +
  scale_color_brewer(palette="Set1")+
  theme_minimal()
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-11-1.png" width="100%" style="display: block; margin: auto;" />

### Accessible colours

It's very easy to get carried away with colour palettes, but you should remember at all times that your figures must be accessible. One way to check how accessible your figures are is to use a colour blindness checker [colorBlindness](https://cran.r-project.org/web/packages/colorBlindness/vignettes/colorBlindness.html)


```r
## Check accessibility ----

library(colorBlindness)
colorBlindness::cvdPlot() # will automatically run on the last plot you made
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-12-1.png" width="100%" style="display: block; margin: auto;" />


#### Guides to visual accessibility 

Using colours to tell categories apart can be useful, but as we can see in the example above, you should choose carefully. Other aesthetics which you can access in your geoms include `shape`, and `size` - you can combine these in complimentary ways to enhance the accessibility of your plots. Here is a hierarchy of "interpretability" for different types of data 

<img src="images/list.png" width="80%" style="display: block; margin: auto;" />


<img src="images/shape_v_colour.png" width="80%" style="display: block; margin: auto;" />

## Axes

ggplot will automatically pick the scale for each axis, and the type of coordinate space. Most plots are in Cartesian (linear X vs linear Y) coordinate space.

You might have observed that depending on how your data is distributed and the portion of the plot visible, the axis values can vary. Sometimes, we prefer to keep these values consistent. To achieve this, we've already used functions to control axis scaling in previous sections of this paper – specifically, the "scale_*" functions.

Now, we'll utilize "scale_x_continuous()" and "scale_y_continuous()" for setting our desired values on the axes. The key parameters in both functions are "limits" (defined as "limits = c(value, value)") and "breaks" (which represent the tick marks, specified as "breaks = value:value"). It's important to note that "limits" comprise only two values (the minimum and maximum), while "breaks" consists of a range of values (for instance, from 0 to 100).

For this plot, let’s say we want the x and y origin to be set at 0. To do this we can add in `xlim()` and `ylim()` functions, which define the limits of the axes:


```r
## Set axis limits ----
penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g,
             colour=species))+ 
  geom_point()+
  geom_smooth(method="lm",    
              se=FALSE)+
  scale_color_brewer(palette="Set1")+
  scale_x_continuous(limits = c(0,240), breaks = c(30,60,90,120,150,180,210,240))+
  scale_y_continuous(limits = c(0,7000), breaks = (0:7000))
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-15-1.png" width="100%" style="display: block; margin: auto;" />


```r
## Set axis limits ----
penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g,
             colour=species))+ 
  geom_point()+
  geom_smooth(method="lm",    
              se=FALSE)+
  scale_color_brewer(palette="Set1")+
  scale_x_continuous(limits = c(0,240), breaks = seq(0,240,30))+
  scale_y_continuous(limits = c(0,7000), breaks = seq(0,7000, 1000))
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-16-1.png" width="100%" style="display: block; margin: auto;" />

Further, we can control the coordinate space using `coord()` functions. Say we want to flip the x and y axes, we add `coord_flip()`:


```r
penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g,
             colour=species))+ 
  geom_point()+
  geom_smooth(method="lm",    
              se=FALSE)+
  scale_color_brewer(palette="Set1")+
  scale_x_continuous(limits = c(0,240), breaks = seq(0,240,30))+
  scale_y_continuous(limits = c(0,7000), breaks = seq(0,7000, 1000))+
  coord_flip()
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-17-1.png" width="100%" style="display: block; margin: auto;" />


### Discrete scales

The same idea of limits within a scale_* function can also be used to change the order of categories on a discrete scale. For example if we look at our boxplots again


```r
penguins |> 
  drop_na(sex) |> 
ggplot(aes(x = species, y = culmen_length_mm)) +
  geom_violin(aes(fill = sex),
              width = 0.5)+
  scale_fill_brewer(palette = "Dark2")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-18-1.png" width="100%" style="display: block; margin: auto;" />

The figures always default to the alphabetical order. Sometimes that is what we want; sometimes that is not what we want. If we wanted to switch the order we would use the `scale_x_discrete()` function and set the limits within it (limits = c("category","category")) as follows:


```r
penguins |> 
  drop_na(sex) |> 
ggplot(aes(x = species, y = culmen_length_mm)) +
  geom_violin(aes(fill = sex),
              width = 0.5)+
  scale_fill_brewer(palette = "Dark2") +
  scale_x_discrete(limits = c("Gentoo","Chinstrap")) 
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-19-1.png" width="100%" style="display: block; margin: auto;" />

What you can see from this example is that the `scale_*_` arguments actually control what data is plotted - if we wish to zoom in and out on a subsection of a plot, without actually eliminating data we use a different function

### Zooming in and out

We have seen how we can set the parameters for the axes for both continuous and discrete scales.

It can be very beneficial to be able to zoom in and out of figures, mainly to focus the frame on a given section. One function we can use to do this is the `coord_cartesian()`, in ggplot2. The main arguments are the limits on the x-axis `(xlim = c(value, value))`, the limits on the y-axis `(ylim = c(value, value))`, and whether to add a small expansion to those limits or not `(expand = TRUE/FALSE)`.


```r
penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g,
             colour=species))+ 
  geom_point()+
  geom_smooth(method="lm",    
              se=FALSE)+
  scale_color_brewer(palette="Set1")+
  coord_cartesian(xlim = c(180,210), ylim = c(3000,4000), expand = FALSE)
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-20-1.png" width="100%" style="display: block; margin: auto;" />

## Labels

By default, the axis labels will be the column names we gave as aesthetics aes(). We can change the axis labels using the xlab() and ylab() functions. Given that column names are often short and can be cryptic, this functionality is particularly important for effectively communicating results.


```r
## Custom labels ----
penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g,
             colour=species))+ 
  geom_point()+
  geom_smooth(method="lm",    
              se=FALSE)+
  scale_color_brewer(palette="Set1")+
  labs(x = "Flipper length (mm)",
       y = "Body mass (g)")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-21-1.png" width="100%" style="display: block; margin: auto;" />

### Titles and subtitles


```r
## Add titles ----
penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g,
             colour=species))+ 
  geom_point()+
  geom_smooth(method="lm",    
              se=FALSE)+
  scale_color_brewer(palette="Set1")+
  labs(x = "Flipper length (mm)",
       y = "Body mass (g)",
       title= "Penguin Size, Palmer Station LTER",
       subtitle= "Flipper length and body mass for three penguin species")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-22-1.png" width="100%" style="display: block; margin: auto;" />


### Controlling the legend

We have the ability to control legend placement, this can be done by setting `theme(legend.position = ...)` to either "top", "bottom", "left" or "right" as shown:


```r
penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g,
             colour=species))+ 
  geom_point()+
  geom_smooth(method="lm",    
              se=FALSE)+
  scale_color_brewer(palette="Set1")+
  labs(x = "Flipper length (mm)",
       y = "Body mass (g)",
       title= "Penguin Size, Palmer Station LTER",
       subtitle= "Flipper length and body mass for three penguin species")+
  theme(legend.position ="top")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-23-1.png" width="100%" style="display: block; margin: auto;" />

Or even as a coordinate within your figure expressed as a propotion of your figure - i.e. c(x = .8, y = .2) would be the bottom right of your figure


```r
penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g,
             colour=species))+ 
  geom_point()+
  geom_smooth(method="lm",    
              se=FALSE)+
  scale_color_brewer(palette="Set1")+
  labs(x = "Flipper length (mm)",
       y = "Body mass (g)",
       title= "Penguin Size, Palmer Station LTER",
       subtitle= "Flipper length and body mass for three penguin species")+
  theme(legend.position = c(.8,.2))
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-24-1.png" width="100%" style="display: block; margin: auto;" />

### Controlling redundant legends

This plot shows quite an ugly legend as it plots a layer for the boxplot and the violin at the same time


```r
penguins |> 
  drop_na(sex) |> 
ggplot(aes(x = species, y = culmen_length_mm, fill = species)) +
  geom_violin(width = .5,
              alpha = .4)+
  geom_boxplot(width = .2)+
  scale_fill_brewer(palette = "Dark2") 
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-25-1.png" width="100%" style="display: block; margin: auto;" />

You can use the `show.legend` argument within the `geom_boxplot()` function and set it to `FALSE`. This will prevent the geom_boxplot from being included in the legend. Here's an example:



```r
penguins |> 
  drop_na(sex) |> 
ggplot(aes(x = species, y = culmen_length_mm, fill = species)) +
  geom_violin(width = .5,
              alpha = .4)+
  geom_boxplot(width = .2,
               show.legend = FALSE)+
  scale_fill_brewer(palette = "Dark2") 
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-26-1.png" width="100%" style="display: block; margin: auto;" />

And of course - we can agree that the legend is actually redundant here, as the x-axis plots the species names. So we can remove it entirely with the `theme()` function.


```r
penguins |> 
  drop_na(sex) |> 
ggplot(aes(x = species, y = culmen_length_mm, fill = species)) +
  geom_violin(width = .5,
              alpha = .4)+
  geom_boxplot(width = .2)+
  scale_fill_brewer(palette = "Dark2") +
  theme(legend.position = "none")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-27-1.png" width="100%" style="display: block; margin: auto;" />

We can also choose to remove specific aesthetics from the legends using `guides()`


```r
penguins |> 
  drop_na(sex) |> 
ggplot(aes(x = species, y = culmen_length_mm, fill = species)) +
  geom_violin(width = .5,
              alpha = .4)+
  geom_boxplot(width = .2)+
  scale_fill_brewer(palette = "Dark2") +
  guides(fill = "none")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-28-1.png" width="100%" style="display: block; margin: auto;" />

## Themes

Finally, the overall appearance of the plot can be modified using theme() functions. The default theme has a grey background.
You may prefer `theme_classic()`, a `theme_minimal()` or even `theme_void()`. Try them out.


```r
## Custom themes ----
penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g,
             colour=species))+ 
  geom_point()+
  geom_smooth(method="lm",    
              se=FALSE)+
  scale_color_brewer(palette="Set1")+
  labs(x = "Flipper length (mm)",
       y = "Body mass (g)",
       title= "Penguin Size, Palmer Station LTER",
       subtitle= "Flipper length and body mass for three penguin species")+
  theme_void()
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-29-1.png" width="100%" style="display: block; margin: auto;" />


```r
## Custom themes ----
penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g,
             colour=species))+ 
  geom_point()+
  geom_smooth(method="lm",    
              se=FALSE)+
  scale_color_brewer(palette="Set1")+
  labs(x = "Flipper length (mm)",
       y = "Body mass (g)",
       title= "Penguin Size, Palmer Station LTER",
       subtitle= "Flipper length and body mass for three penguin species")+
  theme_void()+
  theme(legend.position = c(.8, .2)) # note theme customisations must come AFTER theme sets or they will be overridden
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-30-1.png" width="100%" style="display: block; margin: auto;" />

<div class="info">
<p>There is a lot more customisation available through the theme()
function. We will look at making our own custom themes in later
lessons</p>
<p>You can also try installing and running an even wider range of
pre-built themes if you install the R package <a
href="https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/">ggthemes</a>.</p>
<p>First you will need to run the
<code>install.packages("ggthemes")</code> command. Remember this is one
of the few times a command should NOT be written in your script but
typed directly into the console. That’s because it’s rude to send
someone a script that will install packages on their computer - think of
<code>library()</code> as a polite request instead!</p>
<p>To access the range of themes available type
<code>help(ggthemes)</code> then follow the documentation to find out
what you can do.</p>
</div>



## Multiple plots

### Facets

Adding combinations of different aesthetics allows you to layer more information onto a 2D plot, sometimes though things will just become *too* busy. At the point where it becomes difficult to see the trends or differences in your plot then we want to break up a single plot into sub-plots; this is called ‘faceting’. Facets are commonly used when there is too much data to display clearly in a single plot. We will revisit faceting below, however for now, let’s try to facet the plot according to sex.

To do this we use the tilde symbol ‘~’ to indicate the column name that will form each facet.


```r
## Facetting ----
penguins |> 
  drop_na(sex) |> 
  ggplot(aes(x=flipper_length_mm, 
             y = body_mass_g,
             colour=species))+ 
  geom_point()+
  geom_smooth(method="lm",    
              se=FALSE)+
  scale_color_brewer(palette="Set1")+
  facet_wrap(~sex)
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-32-1.png" width="100%" style="display: block; margin: auto;" />

### Patchwork

There are many times you might want to *combine* separate figures into multi-panel plots. Probably the easiest way to do this is with the `patchwork` package (@R-patchwork). 


```r
## Patchwork ----
library(patchwork)

p1 <- penguins |> 
  ggplot(aes(x=flipper_length_mm, 
             y = culmen_length_mm))+
  geom_point(aes(colour=species))+
  scale_color_manual(values=pal)+
  theme_minimal()

p2 <- penguins |> 
  ggplot(aes(x=culmen_depth_mm, 
             y = culmen_length_mm))+
  geom_point(aes(colour=species))+
  scale_color_manual(values=pal)+
  theme_minimal()

p3 <- penguins |>     
  group_by(sex,species) |> 
    summarise(n=n()) |> 
     drop_na(sex) |> 
     ggplot(aes(x=species, y=n)) + 
  geom_col(aes(fill=sex), 
               width=0.8,
               position=position_dodge(width=0.9), 
               alpha=0.6)+
     scale_fill_manual(values=c("darkorange1", "azure4"))+
     theme_classic()

 (p1+p2)/p3+
  plot_layout(guides = "collect") 
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-33-1.png" width="100%" style="display: block; margin: auto;" />


## Fonts

You can customise the fonts used in themes. All computers should be able to recognise the families "sans", "serif", and "mono", and some computers will be able to access other installed fonts by name.

The easiest way to add lots of custom fonts is with `showtext`. 

The second argument, family, is optional. It gives the family name of the font that will be used in R. In other words, it means that the name used to refer to the font in R does not need to be the same than the original name of the font. In this case, the font Special Elite is going to be the special family.

`showtext_auto()` must be called to indicate that showtext is going to be automatically invoked to draw text whenever a plot is created.


```r
library(showtext)
font_add_google("Special Elite", family = "special")
showtext_auto()
```

## Activity: Replicate this figure

<div class="try">
<p>How close can you get to replicating the figure below?</p>
<p>Make a NEW script for this assignment - replicate_figure.R</p>
<p>Make sure to use the tips and links at the end of this chapter, when
you are done save the file</p>
</div>

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-36-1.png" width="100%" style="display: block; margin: auto;" />



<div class='webex-solution'><button>Solution</button>



```r
pal <- c(
  "Adelie" = "#FF8C00", 
  "Chinstrap" = "#A034F0", 
  "Gentoo" = "#159090")

penguins |> 
  ggplot(aes(x = species, y = body_mass_g, color = species, fill = species)) +
      geom_boxplot(aes(fill = species),
               colour = "black",
        width = .5,
        outlier.shape = NA,
        alpha = .7)+
  geom_jitter(width =.2,
              shape = 21,
              colour = "white")+
  scale_fill_manual(values = pal)+
  scale_colour_manual(values = pal)+
  theme_classic()+
  theme(legend.position = "none")+
    labs(
    x = "",
    y = "Body mass (g)",
    title = "Body mass of brush-tailed penguins",
    subtitle = "Box and jitter plot of body mass by species")
```


</div>



## Saving

One of the easiest ways to save a figure you have made is with the `ggsave()` function. By default it will save the last plot you made on the screen. 

You should specify the output path to your **figures** folder, then provide a file name. Here I have decided to call my plot *plot* (imaginative!) and I want to save it as a .PNG image file. I can also specify the resolution (dpi 300 is good enough for most computer screens).


```r
# OUTPUT FIGURE TO FILE

ggsave("outputs/YYYYMMDD_ggplot_workshop_final_plot.png", dpi=300)
```

<div class="try">
<p>If you got this far and still have time why not try one of the
following:</p>
<ol style="list-style-type: decimal">
<li><p>Making another type of figure using the penguins dataset, use the
further reading below to use for inspiration.</p></li>
<li><p>Use any of your own data</p></li>
</ol>
</div>



### What we learned

You have learned

* The anatomy of ggplots

* How to add geoms on different layers

* How to use colour, colour palettes, facets, labels and themes

* Putting together multiple figures

* How to save and export images


## Further Reading, Guides and tips on data visualisation

* [R Cheat Sheets](https://www.rstudio.com/resources/cheatsheets/)

* [Fundamentals of Data Visualization](https://clauswilke.com/dataviz/): this book tells you everything you need to know about presenting your figures for accessbility and clarity

* [Beautiful Plotting in R](https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/): an incredibly handy ggplot guide for how to build and improve your figures

* [The ggplot2 book](https://ggplot2-book.org/): the original Hadley Wickham book on ggplot2


# Extensions for ggplot2



This tutorial has but scratched the surface of the visualisation options available using R. Here I have provided some further advanced plots and customisation options for those who are feeling confident with the content covered in this tutorial. However, the below plots give an idea of what is possible.

Check out https://exts.ggplot2.tidyverse.org/ for the full list of approved extensions for ggplot

## ggdist

### Rainclouds

Raincloud plots combine a density plot, boxplot, raw data points, and any desired summary statistics for a complete visualisation of the data. They are so called because the density plot plus raw data is reminiscent of a rain cloud.


```r
library(ggdist)

penguins |> 
    ggplot(aes(x = species,
               y = culmen_length_mm,
              fill = species)) +
  ggdist::stat_halfeye(
    point_colour = NA,
    .width = 0,
    # shift raincloud up
    justification = -.2)+
  geom_boxplot(# remove outlier dots
    outlier.shape = NA,
    # shrink width of box
    alpha = .4,
    # fade box
               width = .1)+
  ggdist::stat_dots(aes(colour = species),
                  # put dots underneath
                    side = "left",
                  # move position down
                    justification = 1.1,
                  # size of dots 
                    dotsize = .2,
                    
                  # adjust bins (grouping) of dots
                    binwidth = .4)+
  scale_fill_manual(values = pal) +
  scale_colour_manual(values = pal)+
  guides(fill = "none")+
  coord_flip() # rotate figure
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-40-1.png" width="100%" style="display: block; margin: auto;" />


### Interval plots

An interval plot is a type of data visualization that is used to display intervals or ranges associated with data points. It is particularly useful for visualizing uncertainty or variability in the data. Interval plots can be used to represent various types of intervals, such as confidence intervals, prediction intervals, or any other kind of range or interval associated with the data. 


```r
penguins |> 
  drop_na(sex) |> 
    ggplot(aes(x = species,
               y = culmen_length_mm))+
  ggdist::stat_interval(.width = c(.5, .66, .95))+
  ggdist::stat_halfeye(aes(fill = sex),
                       .width = 0,
                       shape = 21,
                       colour = "white",
                       slab_alpha = .4,
                       size = .5,
                       position = position_nudge(x = .05))+
  scale_color_viridis_d(option = "mako", direction = -1, end = .9)
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-41-1.png" width="100%" style="display: block; margin: auto;" />

## Density

A density plot is a data visualization technique used to represent the distribution of a continuous numeric variable. It provides a smoothed estimate of the probability density function (PDF) of the data, showing where values are concentrated and where they are sparse. Density plots are particularly useful for visualizing the shape, central tendency, and spread of data.


```r
library(ggdensity)

penguins |>  
    ggplot(aes(x = culmen_length_mm, 
               y = culmen_depth_mm,
               colour = species)) +
  geom_point(alpha = .2) +
  ggdensity::geom_hdr_lines()+
   scale_colour_manual(values = pal)
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-42-1.png" width="100%" style="display: block; margin: auto;" />

## ggridges

A ridge plot is a data visualization technique that is similar to a density plot but is designed for displaying multiple probability density distributions side by side, allowing for easier comparison between different groups or categories. Ridge plots are particularly useful when you want to visualize and compare the distribution of multiple continuous variables or data sets simultaneously.


```r
library(ggridges)

penguins |>  
    ggplot(aes(x = culmen_length_mm, 
               y = species,
               fill = species)) +
  geom_density_ridges() + # use hjust and vjust to position text
  scale_fill_manual(values = pal) +
  scale_colour_manual(values = pal)+
  theme(legend.position = "none")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-43-1.png" width="100%" style="display: block; margin: auto;" />

## Bump charts

A bump chart, also known as a line chart or path chart, is a data visualization technique used to show the ranking and changes in ranking of entities (such as teams, players, or products) over time or across different categories. Bump charts are especially useful for visualizing the rise and fall of ranked items, making it easy to identify trends and compare changes in relative position.


```r
library(ggbump)

penguin_summary <- penguins |> 
  mutate(date_egg = dmy(date_egg)) |> 
  filter(clutch_completion == "Yes") |> 
  mutate(year = year(date_egg)) |> 
  group_by(species, year) |> 
  summarise(n = n())

penguin_summary |>
  ggplot(aes(x = year, 
             y = n,
             colour = species))+
  geom_point(size = 7)+
  geom_bump()+
  geom_text(data = penguin_summary |> filter(year == max(year)),
                                             aes(x = year + 0.1,
                                                 label = species,
                                                  hjust = 0),
            size = 5)+
  scale_x_continuous(limits = c(2007, 2009.5),
                     breaks = (2007:2009))+
  labs(y = "Total number of complete clutches")+
  scale_fill_manual(values = pal) +
  scale_colour_manual(values = pal)+
  theme(legend.position = "none")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-44-1.png" width="100%" style="display: block; margin: auto;" />


## Dumbell charts

A dumbbell chart is a data visualization technique that is used to compare two data points for multiple categories or entities. It is called a "dumbbell" chart because it often resembles a pair of dumbbells, with circles or dots representing the data points at the ends of a line connecting them. Dumbbell charts are useful for comparing before-and-after values, two different groups, or any two related data points for different categories or entities.


```r
library(ggalt)

summary_counts <- penguins |> 
  group_by(sex, species) |> 
  summarise(mean = mean(body_mass_g, na.rm = T)) |> 
  pivot_wider(names_from = sex, values_from = mean)

ggplot(summary_counts, 
       aes(y=species, x=FEMALE, xend=MALE)) +
  geom_dumbbell(size=3, color="#e3e2e1",
                colour_x = "#5b8124", colour_xend = "#bad744") +
  geom_text( x=summary_counts[[3,2]], y=3, aes(label="Female"),
             color="#9fb059", size=3, vjust=-2, fontface="bold")+
  geom_text(x=summary_counts[[3,3]], y=3, aes(label="Male"),
             color="#bad744", size=3, vjust=-2, fontface="bold")+
  labs(x = "Body mass (g)",
       y = "")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-45-1.png" width="100%" style="display: block; margin: auto;" />

## Facets

The `facet_nested()` function in the `ggh4x` package is used for creating nested or hierarchical faceting in ggplot2 plots. Faceting is the process of breaking down a data visualization into multiple subplots or panels based on one or more categorical variables, allowing you to see how the data behaves within different categories. Nested faceting allows you to further subdivide these panels into smaller panels, creating a hierarchy of facets.


```r
library(ggh4x)

penguins |> 
  mutate(Nester = ifelse(species=="Gentoo", "Crustaceans", "Fish & Krill")) |> 
  ggplot(aes(x = culmen_length_mm,
             y = culmen_depth_mm,
             colour = species))+
  geom_point()+
  facet_nested(~ Nester + species)+
  scale_colour_manual(values = pal)+
  theme(legend.position = "none")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-46-1.png" width="100%" style="display: block; margin: auto;" />

## Highlighting

Using plot highlighting, such as the gghighlight package in R, can be beneficial in data visualization for several reasons:

- Emphasizing Key Information: Plot highlighting allows you to draw attention to specific data points or groups of interest. This can be helpful when you want to highlight outliers, key observations, or certain categories that are important in your data.

- Enhanced Interpretation: Highlighting specific elements in a plot can make it easier for viewers to interpret and understand the data. By reducing visual clutter and emphasizing relevant information, you can improve the effectiveness of your data visualization.

- Storytelling: Plot highlighting is a useful tool for storytelling in data visualization. You can use it to guide the viewer's attention and convey the main message or story behind the data.

- Comparative Analysis: Highlighting allows you to compare specific data points or groups more easily. For example, you can highlight one group against others to demonstrate differences or trends.


```r
library(gghighlight)

penguins |> 
  ggplot(aes(body_mass_g,
             fill = species),
         position = "identity")+
  geom_histogram()+
  gghighlight()+
  scale_fill_manual(values = pal)+
  facet_wrap(~ species)
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-47-1.png" width="100%" style="display: block; margin: auto;" />



```r
library(ggbeeswarm)
library(gghighlight)
penguins |> 
    ggplot(aes(x = species,
               y = body_mass_g,
               fill = species))+
    geom_beeswarm(shape = 21, 
                  colour = "white")+
    scale_fill_manual(values = pal)+
    gghighlight(body_mass_g > 4000)
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-48-1.png" width="100%" style="display: block; margin: auto;" />

## Text

Annotating a chart with text is a common and valuable practice in data visualization for several important reasons:

- Provide Context: Text annotations help to provide context and background information for the data. They explain what the chart represents, the variables involved, and the meaning of various data points or patterns. This context is crucial for viewers who may not be familiar with the data or the chart.

- Highlight Key Points: Text annotations can be used to emphasize and draw attention to important findings or insights in the data. You can use annotations to highlight specific data points, trends, outliers, or other notable features in the chart.

- Label Data: Annotating a chart with labels helps to identify individual data points, data series, or categories. This is especially useful in scatterplots, bar charts, and other types of visualizations where labeling individual elements is important.

- Clarify Relationships: Annotations can be used to clarify relationships between data points or groups. For example, you can add arrows and labels to indicate which data points are related or what causes certain patterns.

- Provide Sources and Citations: In cases where the data comes from external sources or studies, annotations can be used to provide proper attribution and citations to give credit to the data sources.

- Explain Methodology: Annotations can also explain the methodology or statistical techniques used to generate the chart, which is important for transparency and trust in data analysis.

Below I provide some packages that help with text annotation:

### ggforce


```r
penguins |> 
    ggplot(
        aes(x = culmen_length_mm,
            y= body_mass_g,
            colour = species)) +
    geom_point(aes(fill = species), shape = 21, colour = "white") +
    geom_smooth(method = "lm", se = FALSE,linetype = "dashed", alpha = .4)+
ggforce::geom_mark_ellipse(aes(
    label = species,
    filter = species == 'Adelie'),
    con.colour  = "#526A83",
    con.cap = 0,
    con.arrow = arrow(ends = "last",
                      length = unit(0.5, "cm")),
    show.legend = FALSE) +
    gghighlight(species == "Adelie")+
  scale_colour_manual(values = pal)+
  scale_fill_manual(values = pal)
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-49-1.png" width="100%" style="display: block; margin: auto;" />

### textpaths


```r
library(geomtextpath)

penguins |> 
    ggplot(aes(x = culmen_length_mm, 
               colour = species,
               label = species))+
  geom_textdensity( hjust = 0.35, vjust = .1)+ # use hjust and vjust to position text
  theme(legend.position = "none")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-50-1.png" width="100%" style="display: block; margin: auto;" />

### ggtext


```r
library(ggtext)


penguins |> 
  mutate(species = fct_relevel(species, "Chinstrap", "Gentoo", "Adelie")) |> 
  group_by(species) |> 
    summarise(n=n()) |> 
ggplot(aes(x = species,
           y = n,
           fill = species))+
        geom_col()+
  geom_label(aes(label = n),
            fill = "white",
            nudge_y = 1,
            colour = "black",
            fontface = "bold")+
  labs(x = "",
       y = "Count",
       title = paste(
         'There are almost half the observations on <br> <span style = "color:#A034F0">Chinstrap</span> penguins,  as there are <br> on <span style = "color:#FF8C00">Adelie</span> and <span style ="color:#159090">Gentoo</span>penguins'
       ))+
  scale_fill_manual(
    # when reordering levels - be careful about keeping colours consistent!!! May need manually sorting
    values = pal)+
  coord_flip()+
  scale_y_continuous(limits = c(0, 200))+
  theme(legend.position = "none",
        axis.text.y = element_text(
      color = c( "#A034F0", "#159090", "#FF8C00")),
      plot.title = element_markdown())
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-51-1.png" width="80%" style="display: block; margin: auto;" />


### scales

The `scales`package provides much of the infrastructure that underlies ggplot2’s scales, and using it allow you to customize the transformations, breaks, and labels used by ggplot2. It is particularly good at providing sensible labels apply transformations such as a log scale. 


```r
library(scales)

penguins |>  
    ggplot(aes(x = culmen_length_mm, 
               y = species,
               fill = species)) +
  geom_density_ridges() + # use hjust and vjust to position text
  scale_fill_manual(values = pal) +
  scale_colour_manual(values = pal)+
  theme(legend.position = "none") +
  scale_x_continuous(labels = label_number(
    scale_cut = cut_si("mm")))+
  labs( x = "Bill length",
        y = "Species")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-52-1.png" width="100%" style="display: block; margin: auto;" />

Here is a good example of the `scales` package in action.

The distribution of GDP per capita in the `gapminder` dataset is heavily skewed, with most countries reporting less than $10,000. As a result, the scatterplot makes an upside-down L shape. Try sticking a regression line on that and you’ll get in trouble.


```r
library(gapminder)
gapminder |> 
  filter(year == 2007) |> 
ggplot(aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point() +
  guides(color = "none") +
  labs(title = "GDP per capita",
       subtitle = "GDP per capita raw values")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-53-1.png" width="100%" style="display: block; margin: auto;" />

Fit this onto a log scale (R's standard log function is the natural log). And we get a straighter line but some ugly axis labels.


```r
gapminder |> 
  filter(year == 2007) |> 
ggplot(aes(x = log(gdpPercap), y = lifeExp, color = continent)) +
  geom_point() +
  guides(color = "none") +
  labs(title = "GDP per capita, natural log (base e)",
       subtitle = "GDP per capita logged manually")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-54-1.png" width="100%" style="display: block; margin: auto;" />

GGplot has a `scale_x/y_log10` scale but this applues the wrong transformation to our data - in this particular example there is little difference in the range of values when using a `log10` vs `log` transformation (as we will see in a moment).


```r
gapminder |> 
  filter(year == 2007) |> 
ggplot(aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point() +
  guides(color = "none") +
  labs(title = "GDP per capita, log (base 10)",
       subtitle = "GDP per capita logged with scale") +
  scale_x_log10()
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-55-1.png" width="100%" style="display: block; margin: auto;" />

But we can set whatever custom transformation we wish



```r
log_natural <- trans_new(
  name = "logn",
  transform = function(x) log(x),
  inverse = function(x) exp(x),
  breaks = log_breaks()
)

gapminder |> 
  filter(year == 2007) |> 
ggplot(aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point() +
  guides(color = "none") +
  labs(title = "GDP per capita, natural log (base e)",
       subtitle = "GDP per capita logged manually") +
  scale_x_continuous(trans = log_natural,
                     labels = label_dollar(accuracy = 1))
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-56-1.png" width="100%" style="display: block; margin: auto;" />



## Maps

Working with maps can be tricky. The `sf` package provides functions that work with ggplot2, such as `geom_sf()`. The `rnaturalearth` package provides high-quality mapping coordinates.


```r
library(sf)          # for mapping geoms
library(rnaturalearth) # for map data

# get and bind country data
uk_sf <- ne_states(country = "united kingdom", returnclass = "sf")
ireland_sf <- ne_states(country = "ireland", returnclass = "sf")
islands <- bind_rows(uk_sf, ireland_sf) %>%
  filter(!is.na(geonunit))

# set colours
country_colours <- c("Scotland" = "#0962BA",
                     "Wales" = "#00AC48",
                     "England" = "#FF0000",
                     "Northern Ireland" = "#FFCD2C",
                     "Ireland" = "#F77613")

ggplot() + 
  geom_sf(data = islands,
          mapping = aes(fill = geonunit),
          colour = NA,
          alpha = 0.75) +
  coord_sf(crs = sf::st_crs(4326),
           xlim = c(-10.7, 2.1), 
           ylim = c(49.7, 61)) +
  scale_fill_manual(name = "Country", 
                    values = country_colours)
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-57-1.png" width="100%" style="display: block; margin: auto;" />

## Layouts and compositions

Having control over layouts allow you to tailor the appearance of your plot to match your specific needs and preferences. You can control every aspect of the plot's design, including the arrangement of facets, legends, titles, and labels. When you need to create complex composite plots that combine multiple geoms and facets, custom layouts enable you to precisely position and arrange them. 





```r
library(patchwork)
library(png)
library(ggpubr)

penguin_pic <- png::readPNG("images/lter_penguins.png")

penguin_fig <- ggplot() +
  background_image(penguin_pic)
```


```r
text <- tibble(
  x = 0, y = 0, label = 'Simpsons Paradox is a statistical phenomenon where an association between two variables in a population emerges, disappears or reverses when the population is divided into subpopulations such as <span style = "color:#FF8C00">Adelie</span>, <span style ="color:#159090">Gentoo</span>, and <span style = "color:#A034F0">Chinstrap</span> penguin species'
)



pt <- ggplot(text, aes(x = x, y = y)) +
  ggtext::geom_textbox(
    aes(label = label),    # Map the 'label' column from the 'text' data to the text labels
    box.color = NA,         # Make the text box border color transparent
    width = unit(10, "lines"),  # Set the width of the text boxes to 15 lines
    color = "grey40",       # Set the text color to a light gray
    size = 3,             # Set the text size to 4 (adjust as needed)
    lineheight = 1.4        # Set the line height for text within the boxes
  ) +
  # Customize the plot coordinate system
  coord_cartesian(expand = FALSE, clip = "off") +

  # Apply a theme with a blank (void) background
  theme_void()

pt
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-60-1.png" width="100%" style="display: block; margin: auto;" />



```r
layout <- "
AACCC
AACCC
BBDDD
BBDDD
"

p1 <- ggplot(penguins, aes(x= culmen_length_mm, 
                     y= culmen_depth_mm)) +
    geom_point()+
  geom_smooth(method="lm",
              se=FALSE)+
  theme(legend.position="none")+
    labs(x="Bill length (mm)",
         y="Bill depth (mm)")

p2 <- ggplot(penguins, aes(x= culmen_length_mm, 
                     y= culmen_depth_mm,
                     colour=species)) +
    geom_point()+
  geom_smooth(method="lm",
              se=FALSE)+
  scale_colour_manual(values=pal)+
  theme(legend.position="none")+
    labs(x="Bill length (mm)",
         y="Bill depth (mm)")

p1 + p2 + 
  pt +  penguin_fig + 
  plot_layout(design = layout)
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-61-1.png" width="100%" style="display: block; margin: auto;" />


## Activity: Create a Publication-Style Multi-Panel Figure

Objective: Design and create a multi-panel data visualization figure in the style of a research publication. This exercise will challenge your skills in data visualization, data manipulation, and creating complex figures.

Steps:

- Choose a Dataset: Select a dataset that is suitable for creating a multi-panel figure. It could be related to a scientific research topic, public data (e.g., from government sources or data repositories), or any other dataset that interests you.

- Data Preprocessing: Use dplyr and tidyr to preprocess the data. You may need to aggregate, filter, or reshape the data to fit the structure you want for your figure.

- Design the Figure: Decide on the structure of your multi-panel figure. You could create subplots or facets to represent different aspects of the data. For example, you might have multiple box plots, scatter plots, or other visualizations arranged in a grid.

- Create the Plot: Use ggplot2 to create the individual panels or subplots. Customize the appearance of each panel, including labels, colors, and titles.

- Combine the Panels: Use the patchwork package or another method to arrange the individual panels into a single figure. This may involve adjusting the layout, labeling, and legends to make the figure coherent.

- Add Annotations: Add relevant annotations to the figure, such as titles, subtitles, captions, and any necessary notes to explain the data or results.

- Customize the Theme: Apply a custom theme to the entire figure. You can modify fonts, colors, grid lines, and other elements to match the style of a publication.


Tips:

Plan your figure carefully, considering what story or message you want to convey.
Experiment with different geoms, scales, and themes to achieve the desired visual effect.
Use effective data visualization principles, such as avoiding misleading scales, providing clear labels and legends, and ensuring that the figure is accessible to a wide audience.


# Custom ggplot themes

It is often the case that we start to default to a particular 'style' for our figures, or you may be making several similar figures within a research paper. Creating custom functions can extend to making our own custom ggplot themes. You have probably already used theme variants such as `theme_bw()`, `theme_void()`, `theme_minimal()` - these are incredibly useful, but you might find you still wish to make consistent changes. 



```r
plot <- penguins |> 
  drop_na(sex) |> 
ggplot(aes(x = species, y = culmen_length_mm, fill = species)) +
  geom_violin(width = .5,
              alpha = .4)+
  geom_boxplot(width = .2)+
  scale_fill_brewer(palette = "Dark2") 

plot
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-62-1.png" width="100%" style="display: block; margin: auto;" />

With the addition of a title and `theme_classic()` we can improve the style quickly


```r
plot+
  ggtitle("Comparison of bill lengths by species in Palmer Penguins")+
  labs(x = "",
       y = "Bill length (mm)")+
  theme_classic()
```

But I **still** want to make some more changes, rather than do this work for one figure, and potentially have to repeat this several times for subsequent figures, I can decide to make a new function instead. See [here](https://ggplot2.tidyverse.org/reference/theme.html) for a full breakdown of the arguments for the `theme()` function. 

<div class="info">
<p>Note when using a pre-set theme, and then modifying it further, it is
important to get the order of syntax correct e.g</p>
<p>theme_classic + theme() # is correct</p>
<p>theme() + theme_classic() # will not work as intended</p>
</div>


```r
# custom theme sets defaults for font and size, but these can be changed without changing the function
theme_custom <- function(base_size=12, base_family="serif"){
  theme_classic(base_size = base_size, 
                base_family = base_family,
                )  %+replace%
# update theme minimal 
theme(
  # specify default settings for plot titles - use rel to set titles relative to base size
  plot.title=element_text(size=rel(1.5),
      face="bold",
      family=base_family),
  #specify defaults for axis titles
  axis.title=element_text(
    size=rel(1),
    family=base_family),
  # specify position for y axis title
  axis.title.y=element_text(angle = 90,
                            margin = margin(r = 10, l= 10)),
  # specify position for x axis title
  axis.title.x = element_text(margin = margin(t = 10, b = 10)),
  # set major y grid lines
  panel.grid.major.y = element_line(colour="gray", size=0.5),
  # add axis lines
  axis.line=element_line(),
   # Adding a 0.5cm margin around the plot
  plot.margin = unit(c(0.2, 0.5, 0.5, 0.5), units = , "cm"),    
   # Setting the position for the legend
  legend.position = "none"             
)
  
}
```

With this function set, I can now use it for as many figures as I wish. To use it in the future I should probably save it in a unique script, with a clear title and comments for future use. 

I could then easily use `source("custom_theme_function.R")` to make this available to any scripts I was using. 


```r
plot+
  ggtitle("Comparison of bill lengths\n by species in Palmer Penguins")+
  labs(x = "",
       y = "Bill length (mm)")+
  theme_custom()
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-66-1.png" width="100%" style="display: block; margin: auto;" />


# Making tables with gt

In this chapter, we will accomplish two main objectives:

1. Acquire fundamental principles for creating improved tables.

2. Apply these principles using the `gt` package.
Naturally, to put these ideas into practice, we'll utilize the fantastic penguins dataset from `palmerpenguins` since I have a preference for penguins.

PROS: Why `gt`? Has a grammar of tables, like `ggplot2`, supports HTML, Latex and RTF, followstidyverse conventions.

CONS: Still quite new, syntax is changing and developing. 

For these tutorials we will use the `gt` package and helpers provided by `gtExtras`.

To follow along when you run a section of code, look for the output in the **Viewer Pane**




```r
library(gt)
library(gtExtras)
```

Let's use this dataset to tally the penguins. These counts will provide us with a straightforward dataset to use for practicing table construction. You will need your cleaned penguins dataframe from Day One.


```r
penguin_counts <- penguins |> 
  drop_na(sex) |> 
  mutate(year = as.character(year)) |> 
  mutate(sex = str_to_lower(sex)) |> 
  group_by(species, island, sex, year) |> 
  summarise(n = n(), .groups = "drop")

penguin_counts
```

<div class="kable-table">

|species   |island    |sex    |year |  n|
|:---------|:---------|:------|:----|--:|
|Adelie    |Biscoe    |female |2007 |  5|
|Adelie    |Biscoe    |female |2008 |  9|
|Adelie    |Biscoe    |female |2009 |  8|
|Adelie    |Biscoe    |male   |2007 |  5|
|Adelie    |Biscoe    |male   |2008 |  9|
|Adelie    |Biscoe    |male   |2009 |  8|
|Adelie    |Dream     |female |2007 |  9|
|Adelie    |Dream     |female |2008 |  8|
|Adelie    |Dream     |female |2009 | 10|
|Adelie    |Dream     |male   |2007 | 10|
|Adelie    |Dream     |male   |2008 |  8|
|Adelie    |Dream     |male   |2009 | 10|
|Adelie    |Torgersen |female |2007 |  8|
|Adelie    |Torgersen |female |2008 |  8|
|Adelie    |Torgersen |female |2009 |  8|
|Adelie    |Torgersen |male   |2007 |  7|
|Adelie    |Torgersen |male   |2008 |  8|
|Adelie    |Torgersen |male   |2009 |  8|
|Chinstrap |Dream     |female |2007 | 13|
|Chinstrap |Dream     |female |2008 |  9|
|Chinstrap |Dream     |female |2009 | 12|
|Chinstrap |Dream     |male   |2007 | 13|
|Chinstrap |Dream     |male   |2008 |  9|
|Chinstrap |Dream     |male   |2009 | 12|
|Gentoo    |Biscoe    |female |2007 | 16|
|Gentoo    |Biscoe    |female |2008 | 22|
|Gentoo    |Biscoe    |female |2009 | 20|
|Gentoo    |Biscoe    |male   |2007 | 17|
|Gentoo    |Biscoe    |male   |2008 | 23|
|Gentoo    |Biscoe    |male   |2009 | 21|

</div>

In a real table, the data might be restructured for better readability. While there's nothing inherently wrong with the long (i.e., containing many rows) data format, this format is excellent for data analysis. However, in a table intended for human readers, rather than machines, you'd likely opt for a wider format.


```r
penguin_counts_wider <- penguin_counts |> 
  pivot_wider(
    names_from = c(species, sex),
    values_from = n
  ) |> 
  # Make missing numbers (NAs) into zero
  mutate(across(.cols = -(1:2), ~replace_na(., replace = 0))) |> 
  arrange(island, year) 

penguin_counts_wider
```

<div class="kable-table">

|island    |year | Adelie_female| Adelie_male| Chinstrap_female| Chinstrap_male| Gentoo_female| Gentoo_male|
|:---------|:----|-------------:|-----------:|----------------:|--------------:|-------------:|-----------:|
|Biscoe    |2007 |             5|           5|                0|              0|            16|          17|
|Biscoe    |2008 |             9|           9|                0|              0|            22|          23|
|Biscoe    |2009 |             8|           8|                0|              0|            20|          21|
|Dream     |2007 |             9|          10|               13|             13|             0|           0|
|Dream     |2008 |             8|           8|                9|              9|             0|           0|
|Dream     |2009 |            10|          10|               12|             12|             0|           0|
|Torgersen |2007 |             8|           7|                0|              0|             0|           0|
|Torgersen |2008 |             8|           8|                0|              0|             0|           0|
|Torgersen |2009 |             8|           8|                0|              0|             0|           0|

</div>

Here are six guidelines that will guide us as we make tables:

1. Avoid gridlines

2. Use better column names

3. Align columns

4. Use groups instead of repetitive columns

5. Remove missing numbers

6. Add summaries

### Avoid vertical lines 


Vertical lines can make our data look cramped. Fortunately, it appears that `gt` adheres to this principle by default. Hence, all we need to do is supply our dataset, `penguin_counts_wider`, to the `gt()` function. 



```r
penguin_counts_wider |> 
  gt()
```

```{=html}
<div id="rlapcqcgsp" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#rlapcqcgsp table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#rlapcqcgsp thead, #rlapcqcgsp tbody, #rlapcqcgsp tfoot, #rlapcqcgsp tr, #rlapcqcgsp td, #rlapcqcgsp th {
  border-style: none;
}

#rlapcqcgsp p {
  margin: 0;
  padding: 0;
}

#rlapcqcgsp .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#rlapcqcgsp .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#rlapcqcgsp .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#rlapcqcgsp .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#rlapcqcgsp .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rlapcqcgsp .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rlapcqcgsp .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rlapcqcgsp .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#rlapcqcgsp .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#rlapcqcgsp .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#rlapcqcgsp .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#rlapcqcgsp .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#rlapcqcgsp .gt_spanner_row {
  border-bottom-style: hidden;
}

#rlapcqcgsp .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#rlapcqcgsp .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#rlapcqcgsp .gt_from_md > :first-child {
  margin-top: 0;
}

#rlapcqcgsp .gt_from_md > :last-child {
  margin-bottom: 0;
}

#rlapcqcgsp .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#rlapcqcgsp .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#rlapcqcgsp .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#rlapcqcgsp .gt_row_group_first td {
  border-top-width: 2px;
}

#rlapcqcgsp .gt_row_group_first th {
  border-top-width: 2px;
}

#rlapcqcgsp .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rlapcqcgsp .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#rlapcqcgsp .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#rlapcqcgsp .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rlapcqcgsp .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rlapcqcgsp .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#rlapcqcgsp .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#rlapcqcgsp .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#rlapcqcgsp .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rlapcqcgsp .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rlapcqcgsp .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#rlapcqcgsp .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rlapcqcgsp .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#rlapcqcgsp .gt_left {
  text-align: left;
}

#rlapcqcgsp .gt_center {
  text-align: center;
}

#rlapcqcgsp .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#rlapcqcgsp .gt_font_normal {
  font-weight: normal;
}

#rlapcqcgsp .gt_font_bold {
  font-weight: bold;
}

#rlapcqcgsp .gt_font_italic {
  font-style: italic;
}

#rlapcqcgsp .gt_super {
  font-size: 65%;
}

#rlapcqcgsp .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#rlapcqcgsp .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#rlapcqcgsp .gt_indent_1 {
  text-indent: 5px;
}

#rlapcqcgsp .gt_indent_2 {
  text-indent: 10px;
}

#rlapcqcgsp .gt_indent_3 {
  text-indent: 15px;
}

#rlapcqcgsp .gt_indent_4 {
  text-indent: 20px;
}

#rlapcqcgsp .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="island">island</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="year">year</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Adelie_female">Adelie_female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Adelie_male">Adelie_male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Chinstrap_female">Chinstrap_female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Chinstrap_male">Chinstrap_male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Gentoo_female">Gentoo_female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Gentoo_male">Gentoo_male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">5</td>
<td headers="Adelie_male" class="gt_row gt_right">5</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">9</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">10</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">7</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
  </tbody>
  
  
</table>
</div>
```


### Use better column names and make them stand out

The [`cols_*()` functions](https://gt.rstudio.com/reference/index.html#section-modify-columns) allow for modifications of entire columns.

We can control the column labels, cell alignment, column width and placement plus can combine multiple columns with `cols_*()` functions.

To modify the column names, you can employ the "layer" named `cols_layer()`. Similar to how {ggplot2} operates with layers, {gt} follows a similar approach. To make any adjustments to the table, you simply transfer it from one layer to the next, which can be done conveniently through piping. With this understanding, we can label the columns just as we did previously.


```r
penguin_counts_wider |> 
  gt() |> 
  cols_label(
    island = 'Island',
    year = 'Year',
    Adelie_female = 'Adelie (female)',
    Adelie_male = 'Adelie (male)',
    Chinstrap_female = 'Chinstrap (female)',
    Chinstrap_male = 'Chinstrap (male)',
    Gentoo_female = 'Gentoo (female)',
    Gentoo_male = 'Gentoo (male)',
  )
```

```{=html}
<div id="nrefitxwpz" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#nrefitxwpz table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#nrefitxwpz thead, #nrefitxwpz tbody, #nrefitxwpz tfoot, #nrefitxwpz tr, #nrefitxwpz td, #nrefitxwpz th {
  border-style: none;
}

#nrefitxwpz p {
  margin: 0;
  padding: 0;
}

#nrefitxwpz .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#nrefitxwpz .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#nrefitxwpz .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#nrefitxwpz .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#nrefitxwpz .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#nrefitxwpz .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nrefitxwpz .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#nrefitxwpz .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#nrefitxwpz .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#nrefitxwpz .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#nrefitxwpz .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#nrefitxwpz .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#nrefitxwpz .gt_spanner_row {
  border-bottom-style: hidden;
}

#nrefitxwpz .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#nrefitxwpz .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#nrefitxwpz .gt_from_md > :first-child {
  margin-top: 0;
}

#nrefitxwpz .gt_from_md > :last-child {
  margin-bottom: 0;
}

#nrefitxwpz .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#nrefitxwpz .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#nrefitxwpz .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#nrefitxwpz .gt_row_group_first td {
  border-top-width: 2px;
}

#nrefitxwpz .gt_row_group_first th {
  border-top-width: 2px;
}

#nrefitxwpz .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nrefitxwpz .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#nrefitxwpz .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#nrefitxwpz .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nrefitxwpz .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nrefitxwpz .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#nrefitxwpz .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#nrefitxwpz .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#nrefitxwpz .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nrefitxwpz .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#nrefitxwpz .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nrefitxwpz .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#nrefitxwpz .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nrefitxwpz .gt_left {
  text-align: left;
}

#nrefitxwpz .gt_center {
  text-align: center;
}

#nrefitxwpz .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#nrefitxwpz .gt_font_normal {
  font-weight: normal;
}

#nrefitxwpz .gt_font_bold {
  font-weight: bold;
}

#nrefitxwpz .gt_font_italic {
  font-style: italic;
}

#nrefitxwpz .gt_super {
  font-size: 65%;
}

#nrefitxwpz .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#nrefitxwpz .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#nrefitxwpz .gt_indent_1 {
  text-indent: 5px;
}

#nrefitxwpz .gt_indent_2 {
  text-indent: 10px;
}

#nrefitxwpz .gt_indent_3 {
  text-indent: 15px;
}

#nrefitxwpz .gt_indent_4 {
  text-indent: 20px;
}

#nrefitxwpz .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="Island">Island</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Year">Year</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Adelie (female)">Adelie (female)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Adelie (male)">Adelie (male)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Chinstrap (female)">Chinstrap (female)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Chinstrap (male)">Chinstrap (male)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Gentoo (female)">Gentoo (female)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Gentoo (male)">Gentoo (male)</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">5</td>
<td headers="Adelie_male" class="gt_row gt_right">5</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">9</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">10</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">7</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
  </tbody>
  
  
</table>
</div>
```

However, labeling the columns in this manner may not be the most effective approach. Let's explore an alternative method. First, we can create what are known as "spanners," which are merged columns. 

We can modify the look of table parts more generally with [tab_*()] functions 

Here we can generate column spanners with `tab_spanner()` layers, with one layer dedicated to each spanner. You can also control text formatting of labels with Markdown or HTML syntax. This can be used on any text in a **gt** table. Here I have applied some `md` to put my spanners in **bold**.


```r
penguin_counts_wider |> 
  gt() |> 
  cols_label(
    island = 'Island',
    year = 'Year',
    Adelie_female = 'Adelie (female)',
    Adelie_male = 'Adelie (male)',
    Chinstrap_female = 'Chinstrap (female)',
    Chinstrap_male = 'Chinstrap (male)',
    Gentoo_female = 'Gentoo (female)',
    Gentoo_male = 'Gentoo (male)',
  ) |> 
  # md() function applies markdown styling - we can make text bold
  tab_spanner(
    label = md('**Adelie**'),
    columns = 3:4
  ) |> 
  tab_spanner(
    label = md('**Chinstrap**'),
    columns = c('Chinstrap_female', 'Chinstrap_male')
  ) |> 
  tab_spanner(
    label =  md('**Gentoo**'),
    columns = contains('Gentoo')
  )
```

```{=html}
<div id="bbmxxawskz" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#bbmxxawskz table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#bbmxxawskz thead, #bbmxxawskz tbody, #bbmxxawskz tfoot, #bbmxxawskz tr, #bbmxxawskz td, #bbmxxawskz th {
  border-style: none;
}

#bbmxxawskz p {
  margin: 0;
  padding: 0;
}

#bbmxxawskz .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#bbmxxawskz .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#bbmxxawskz .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#bbmxxawskz .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#bbmxxawskz .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#bbmxxawskz .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bbmxxawskz .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#bbmxxawskz .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#bbmxxawskz .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#bbmxxawskz .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#bbmxxawskz .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#bbmxxawskz .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#bbmxxawskz .gt_spanner_row {
  border-bottom-style: hidden;
}

#bbmxxawskz .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#bbmxxawskz .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#bbmxxawskz .gt_from_md > :first-child {
  margin-top: 0;
}

#bbmxxawskz .gt_from_md > :last-child {
  margin-bottom: 0;
}

#bbmxxawskz .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#bbmxxawskz .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#bbmxxawskz .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#bbmxxawskz .gt_row_group_first td {
  border-top-width: 2px;
}

#bbmxxawskz .gt_row_group_first th {
  border-top-width: 2px;
}

#bbmxxawskz .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bbmxxawskz .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#bbmxxawskz .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#bbmxxawskz .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bbmxxawskz .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bbmxxawskz .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#bbmxxawskz .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#bbmxxawskz .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#bbmxxawskz .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bbmxxawskz .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#bbmxxawskz .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#bbmxxawskz .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#bbmxxawskz .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#bbmxxawskz .gt_left {
  text-align: left;
}

#bbmxxawskz .gt_center {
  text-align: center;
}

#bbmxxawskz .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#bbmxxawskz .gt_font_normal {
  font-weight: normal;
}

#bbmxxawskz .gt_font_bold {
  font-weight: bold;
}

#bbmxxawskz .gt_font_italic {
  font-style: italic;
}

#bbmxxawskz .gt_super {
  font-size: 65%;
}

#bbmxxawskz .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#bbmxxawskz .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#bbmxxawskz .gt_indent_1 {
  text-indent: 5px;
}

#bbmxxawskz .gt_indent_2 {
  text-indent: 10px;
}

#bbmxxawskz .gt_indent_3 {
  text-indent: 15px;
}

#bbmxxawskz .gt_indent_4 {
  text-indent: 20px;
}

#bbmxxawskz .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Island">Island</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="2" colspan="1" scope="col" id="Year">Year</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Adelie (female)">Adelie (female)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Adelie (male)">Adelie (male)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Chinstrap (female)">Chinstrap (female)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Chinstrap (male)">Chinstrap (male)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Gentoo (female)">Gentoo (female)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Gentoo (male)">Gentoo (male)</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">5</td>
<td headers="Adelie_male" class="gt_row gt_right">5</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">9</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">10</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">7</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
  </tbody>
  
  
</table>
</div>
```

As you can see, tab_spanner() always requires two arguments label and columns. For the columns argument I have shown you three ways to get the job done:

1. Vector of column numbers

2. Vector of column names

3. tidyselect helpers

First, we no longer need the species labels in the actual column names, as the spanners already provide that information. To update the column names, we can employ a handy trick that will save us from tedious typing.

Begin by creating a named vector that establishes a connection between the original column names, which include species labels, and the desired column names that exclude those labels. For example:


```r
desired_colnames <- colnames(penguin_counts_wider) |> 
  str_remove("(Adelie|Gentoo|Chinstrap)_") |> 
  str_to_title()

names(desired_colnames) <- names(penguin_counts_wider)
```

With this named vector in place, proceed to rename the columns using it in the .list argument in `cols_label()`


```r
penguin_counts_wider |> 
    gt() |> 
  cols_label(.list = desired_colnames) |> 
  # md() function applies markdown styling - we can make text bold
  tab_spanner(
    label = md('**Adelie**'),
    columns = 3:4
  ) |> 
  tab_spanner(
    label = md('**Chinstrap**'),
    columns = c('Chinstrap_female', 'Chinstrap_male')
  ) |> 
  tab_spanner(
    label =  md('**Gentoo**'),
    columns = contains('Gentoo')
  )
```

```{=html}
<div id="qxulfzahqz" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#qxulfzahqz table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#qxulfzahqz thead, #qxulfzahqz tbody, #qxulfzahqz tfoot, #qxulfzahqz tr, #qxulfzahqz td, #qxulfzahqz th {
  border-style: none;
}

#qxulfzahqz p {
  margin: 0;
  padding: 0;
}

#qxulfzahqz .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#qxulfzahqz .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#qxulfzahqz .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#qxulfzahqz .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#qxulfzahqz .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#qxulfzahqz .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qxulfzahqz .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#qxulfzahqz .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#qxulfzahqz .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#qxulfzahqz .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#qxulfzahqz .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#qxulfzahqz .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#qxulfzahqz .gt_spanner_row {
  border-bottom-style: hidden;
}

#qxulfzahqz .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#qxulfzahqz .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#qxulfzahqz .gt_from_md > :first-child {
  margin-top: 0;
}

#qxulfzahqz .gt_from_md > :last-child {
  margin-bottom: 0;
}

#qxulfzahqz .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#qxulfzahqz .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#qxulfzahqz .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#qxulfzahqz .gt_row_group_first td {
  border-top-width: 2px;
}

#qxulfzahqz .gt_row_group_first th {
  border-top-width: 2px;
}

#qxulfzahqz .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qxulfzahqz .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#qxulfzahqz .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#qxulfzahqz .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qxulfzahqz .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qxulfzahqz .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#qxulfzahqz .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#qxulfzahqz .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#qxulfzahqz .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qxulfzahqz .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#qxulfzahqz .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#qxulfzahqz .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#qxulfzahqz .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#qxulfzahqz .gt_left {
  text-align: left;
}

#qxulfzahqz .gt_center {
  text-align: center;
}

#qxulfzahqz .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#qxulfzahqz .gt_font_normal {
  font-weight: normal;
}

#qxulfzahqz .gt_font_bold {
  font-weight: bold;
}

#qxulfzahqz .gt_font_italic {
  font-style: italic;
}

#qxulfzahqz .gt_super {
  font-size: 65%;
}

#qxulfzahqz .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#qxulfzahqz .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#qxulfzahqz .gt_indent_1 {
  text-indent: 5px;
}

#qxulfzahqz .gt_indent_2 {
  text-indent: 10px;
}

#qxulfzahqz .gt_indent_3 {
  text-indent: 15px;
}

#qxulfzahqz .gt_indent_4 {
  text-indent: 20px;
}

#qxulfzahqz .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Island">Island</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="2" colspan="1" scope="col" id="Year">Year</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">5</td>
<td headers="Adelie_male" class="gt_row gt_right">5</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">9</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">10</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">7</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
  </tbody>
  
  
</table>
</div>
```


Finally we should add a title to our table. We can do this with `tab_header()`


```r
penguin_counts_wider |> 
    gt() |> 
  cols_label(.list = desired_colnames) |> 
  # md() function applies markdown styling - we can make text bold
  tab_spanner(
    label = md('**Adelie**'),
    columns = 3:4
  ) |> 
  tab_spanner(
    label = md('**Chinstrap**'),
    columns = c('Chinstrap_female', 'Chinstrap_male')
  ) |> 
  tab_spanner(
    label =  md('**Gentoo**'),
    columns = contains('Gentoo')
  ) |> 
   tab_header(
    title = 'Penguins of the Palmer Archipelago',
    subtitle = 'Data is courtesy of the palmerpenguins R package by Allison Horst'
  ) 
```

```{=html}
<div id="nrkpfirhqo" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#nrkpfirhqo table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#nrkpfirhqo thead, #nrkpfirhqo tbody, #nrkpfirhqo tfoot, #nrkpfirhqo tr, #nrkpfirhqo td, #nrkpfirhqo th {
  border-style: none;
}

#nrkpfirhqo p {
  margin: 0;
  padding: 0;
}

#nrkpfirhqo .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#nrkpfirhqo .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#nrkpfirhqo .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#nrkpfirhqo .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#nrkpfirhqo .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#nrkpfirhqo .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nrkpfirhqo .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#nrkpfirhqo .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#nrkpfirhqo .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#nrkpfirhqo .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#nrkpfirhqo .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#nrkpfirhqo .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#nrkpfirhqo .gt_spanner_row {
  border-bottom-style: hidden;
}

#nrkpfirhqo .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#nrkpfirhqo .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#nrkpfirhqo .gt_from_md > :first-child {
  margin-top: 0;
}

#nrkpfirhqo .gt_from_md > :last-child {
  margin-bottom: 0;
}

#nrkpfirhqo .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#nrkpfirhqo .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#nrkpfirhqo .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#nrkpfirhqo .gt_row_group_first td {
  border-top-width: 2px;
}

#nrkpfirhqo .gt_row_group_first th {
  border-top-width: 2px;
}

#nrkpfirhqo .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nrkpfirhqo .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#nrkpfirhqo .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#nrkpfirhqo .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nrkpfirhqo .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nrkpfirhqo .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#nrkpfirhqo .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#nrkpfirhqo .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#nrkpfirhqo .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nrkpfirhqo .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#nrkpfirhqo .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nrkpfirhqo .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#nrkpfirhqo .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nrkpfirhqo .gt_left {
  text-align: left;
}

#nrkpfirhqo .gt_center {
  text-align: center;
}

#nrkpfirhqo .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#nrkpfirhqo .gt_font_normal {
  font-weight: normal;
}

#nrkpfirhqo .gt_font_bold {
  font-weight: bold;
}

#nrkpfirhqo .gt_font_italic {
  font-style: italic;
}

#nrkpfirhqo .gt_super {
  font-size: 65%;
}

#nrkpfirhqo .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#nrkpfirhqo .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#nrkpfirhqo .gt_indent_1 {
  text-indent: 5px;
}

#nrkpfirhqo .gt_indent_2 {
  text-indent: 10px;
}

#nrkpfirhqo .gt_indent_3 {
  text-indent: 15px;
}

#nrkpfirhqo .gt_indent_4 {
  text-indent: 20px;
}

#nrkpfirhqo .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="8" class="gt_heading gt_title gt_font_normal" style>Penguins of the Palmer Archipelago</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="8" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Data is courtesy of the palmerpenguins R package by Allison Horst</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Island">Island</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="2" colspan="1" scope="col" id="Year">Year</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">5</td>
<td headers="Adelie_male" class="gt_row gt_right">5</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">9</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">10</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">7</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
  </tbody>
  
  
</table>
</div>
```

We could if we wanted wrap this into a simple function - as the headers and titles will not change across this tutorial:


```r
labels_and_title <- function(gt_tbl){
 gt_tbl |> 
  tab_spanner(
    label = md('**Adelie**'),
    columns = 3:4
  ) |> 
  tab_spanner(
    label = md('**Chinstrap**'),
    columns = c('Chinstrap_female', 'Chinstrap_male')
  ) |> 
  tab_spanner(
    label =  md('**Gentoo**'),
    columns = contains('Gentoo')
  ) |> 
   tab_header(
    title = 'Penguins of the Palmer Archipelago',
    subtitle = 'Data is courtesy of the palmerpenguins R package by Allison Horst'
  )
}

# This produces the same output
penguin_counts_wider |> 
  gt() |> 
  cols_label(.list = desired_colnames)  |> 
  labels_and_title() 
```

```{=html}
<div id="fmsajwubxi" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#fmsajwubxi table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#fmsajwubxi thead, #fmsajwubxi tbody, #fmsajwubxi tfoot, #fmsajwubxi tr, #fmsajwubxi td, #fmsajwubxi th {
  border-style: none;
}

#fmsajwubxi p {
  margin: 0;
  padding: 0;
}

#fmsajwubxi .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#fmsajwubxi .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#fmsajwubxi .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#fmsajwubxi .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#fmsajwubxi .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#fmsajwubxi .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fmsajwubxi .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#fmsajwubxi .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#fmsajwubxi .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#fmsajwubxi .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#fmsajwubxi .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#fmsajwubxi .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#fmsajwubxi .gt_spanner_row {
  border-bottom-style: hidden;
}

#fmsajwubxi .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#fmsajwubxi .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#fmsajwubxi .gt_from_md > :first-child {
  margin-top: 0;
}

#fmsajwubxi .gt_from_md > :last-child {
  margin-bottom: 0;
}

#fmsajwubxi .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#fmsajwubxi .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#fmsajwubxi .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#fmsajwubxi .gt_row_group_first td {
  border-top-width: 2px;
}

#fmsajwubxi .gt_row_group_first th {
  border-top-width: 2px;
}

#fmsajwubxi .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fmsajwubxi .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#fmsajwubxi .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#fmsajwubxi .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fmsajwubxi .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fmsajwubxi .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#fmsajwubxi .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#fmsajwubxi .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#fmsajwubxi .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fmsajwubxi .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#fmsajwubxi .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#fmsajwubxi .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#fmsajwubxi .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#fmsajwubxi .gt_left {
  text-align: left;
}

#fmsajwubxi .gt_center {
  text-align: center;
}

#fmsajwubxi .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#fmsajwubxi .gt_font_normal {
  font-weight: normal;
}

#fmsajwubxi .gt_font_bold {
  font-weight: bold;
}

#fmsajwubxi .gt_font_italic {
  font-style: italic;
}

#fmsajwubxi .gt_super {
  font-size: 65%;
}

#fmsajwubxi .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#fmsajwubxi .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#fmsajwubxi .gt_indent_1 {
  text-indent: 5px;
}

#fmsajwubxi .gt_indent_2 {
  text-indent: 10px;
}

#fmsajwubxi .gt_indent_3 {
  text-indent: 15px;
}

#fmsajwubxi .gt_indent_4 {
  text-indent: 20px;
}

#fmsajwubxi .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="8" class="gt_heading gt_title gt_font_normal" style>Penguins of the Palmer Archipelago</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="8" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Data is courtesy of the palmerpenguins R package by Allison Horst</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Island">Island</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="2" colspan="1" scope="col" id="Year">Year</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">5</td>
<td headers="Adelie_male" class="gt_row gt_right">5</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">9</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">10</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">7</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
  </tbody>
  
  
</table>
</div>
```

### Alignment

Align all text within a column using `cols_align()`. Most commonly we left-align text with varying length and right-align numbers.

Here's why these default alignments make sense:

- Numbers to the Right: Numeric values, such as counts, are usually aligned to the right because this aligns the decimal points and makes it easier to compare and perform calculations with numbers. It also allows for neat alignment of digits, which is particularly important when working with large datasets.

- Text to the Left: Text data, like character vectors, is aligned to the left by default. This is because text doesn't have decimal points or numeric values to compare, and left-aligning text provides a clean and uniform appearance. It makes the start of the text easily scannable and helps maintain readability, even for lengthy text entries.

- Center Alignment for Factors: Factors (categorical data) are aligned to the center by default. This is a compromise between left and right alignment. While the factor's entries are characters, they represent categories and are often used for grouping or sorting. Center alignment ensures that the category labels are visually centered in the available space, making it easier to identify the category while maintaining a visually appealing table.

These default alignments are well-established conventions in table formatting and help readers quickly interpret and work with tabular data. They follow a balance between readability, aesthetics, and the nature of the data being presented.

Island is currently coded as a factor, we could recode this in our data, or we can use the `cols_align()` layer:


```r
penguin_counts_wider |> 
  gt() |> 
  cols_label(.list = desired_colnames) |> 
  labels_and_title()  |> 
  cols_align(align = 'right', columns = 'year') |> 
  cols_align(
    align = 'left', 
    columns = where(is.factor)
  ) 
```

```{=html}
<div id="hvoadzmbgu" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#hvoadzmbgu table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#hvoadzmbgu thead, #hvoadzmbgu tbody, #hvoadzmbgu tfoot, #hvoadzmbgu tr, #hvoadzmbgu td, #hvoadzmbgu th {
  border-style: none;
}

#hvoadzmbgu p {
  margin: 0;
  padding: 0;
}

#hvoadzmbgu .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#hvoadzmbgu .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#hvoadzmbgu .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#hvoadzmbgu .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#hvoadzmbgu .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hvoadzmbgu .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hvoadzmbgu .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hvoadzmbgu .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#hvoadzmbgu .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#hvoadzmbgu .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#hvoadzmbgu .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#hvoadzmbgu .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#hvoadzmbgu .gt_spanner_row {
  border-bottom-style: hidden;
}

#hvoadzmbgu .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#hvoadzmbgu .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#hvoadzmbgu .gt_from_md > :first-child {
  margin-top: 0;
}

#hvoadzmbgu .gt_from_md > :last-child {
  margin-bottom: 0;
}

#hvoadzmbgu .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#hvoadzmbgu .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#hvoadzmbgu .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#hvoadzmbgu .gt_row_group_first td {
  border-top-width: 2px;
}

#hvoadzmbgu .gt_row_group_first th {
  border-top-width: 2px;
}

#hvoadzmbgu .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hvoadzmbgu .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#hvoadzmbgu .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#hvoadzmbgu .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hvoadzmbgu .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hvoadzmbgu .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#hvoadzmbgu .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#hvoadzmbgu .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#hvoadzmbgu .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hvoadzmbgu .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hvoadzmbgu .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hvoadzmbgu .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hvoadzmbgu .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hvoadzmbgu .gt_left {
  text-align: left;
}

#hvoadzmbgu .gt_center {
  text-align: center;
}

#hvoadzmbgu .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#hvoadzmbgu .gt_font_normal {
  font-weight: normal;
}

#hvoadzmbgu .gt_font_bold {
  font-weight: bold;
}

#hvoadzmbgu .gt_font_italic {
  font-style: italic;
}

#hvoadzmbgu .gt_super {
  font-size: 65%;
}

#hvoadzmbgu .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#hvoadzmbgu .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#hvoadzmbgu .gt_indent_1 {
  text-indent: 5px;
}

#hvoadzmbgu .gt_indent_2 {
  text-indent: 10px;
}

#hvoadzmbgu .gt_indent_3 {
  text-indent: 15px;
}

#hvoadzmbgu .gt_indent_4 {
  text-indent: 20px;
}

#hvoadzmbgu .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="8" class="gt_heading gt_title gt_font_normal" style>Penguins of the Palmer Archipelago</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="8" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Data is courtesy of the palmerpenguins R package by Allison Horst</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Island">Island</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="2" colspan="1" scope="col" id="Year">Year</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">5</td>
<td headers="Adelie_male" class="gt_row gt_right">5</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">9</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Dream</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">10</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2007</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">7</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2008</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="year" class="gt_row gt_right">2009</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
  </tbody>
  
  
</table>
</div>
```

### Move columns around

Move columns to the start or end or wherever you like with `cols_move_*()` functions


```r
penguin_counts_wider |> 
  gt() |> 
  cols_label(.list = desired_colnames) |> 
  labels_and_title()  |> 
  cols_align(align = 'right', columns = 'year') |> 
  cols_align(
    align = 'left', 
    columns = where(is.factor)
  ) |> 
  cols_move_to_start(columns = vars(year))
```

```{=html}
<div id="fmrnwnigzh" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#fmrnwnigzh table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#fmrnwnigzh thead, #fmrnwnigzh tbody, #fmrnwnigzh tfoot, #fmrnwnigzh tr, #fmrnwnigzh td, #fmrnwnigzh th {
  border-style: none;
}

#fmrnwnigzh p {
  margin: 0;
  padding: 0;
}

#fmrnwnigzh .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#fmrnwnigzh .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#fmrnwnigzh .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#fmrnwnigzh .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#fmrnwnigzh .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#fmrnwnigzh .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fmrnwnigzh .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#fmrnwnigzh .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#fmrnwnigzh .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#fmrnwnigzh .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#fmrnwnigzh .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#fmrnwnigzh .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#fmrnwnigzh .gt_spanner_row {
  border-bottom-style: hidden;
}

#fmrnwnigzh .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#fmrnwnigzh .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#fmrnwnigzh .gt_from_md > :first-child {
  margin-top: 0;
}

#fmrnwnigzh .gt_from_md > :last-child {
  margin-bottom: 0;
}

#fmrnwnigzh .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#fmrnwnigzh .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#fmrnwnigzh .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#fmrnwnigzh .gt_row_group_first td {
  border-top-width: 2px;
}

#fmrnwnigzh .gt_row_group_first th {
  border-top-width: 2px;
}

#fmrnwnigzh .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fmrnwnigzh .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#fmrnwnigzh .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#fmrnwnigzh .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fmrnwnigzh .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fmrnwnigzh .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#fmrnwnigzh .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#fmrnwnigzh .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#fmrnwnigzh .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fmrnwnigzh .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#fmrnwnigzh .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#fmrnwnigzh .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#fmrnwnigzh .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#fmrnwnigzh .gt_left {
  text-align: left;
}

#fmrnwnigzh .gt_center {
  text-align: center;
}

#fmrnwnigzh .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#fmrnwnigzh .gt_font_normal {
  font-weight: normal;
}

#fmrnwnigzh .gt_font_bold {
  font-weight: bold;
}

#fmrnwnigzh .gt_font_italic {
  font-style: italic;
}

#fmrnwnigzh .gt_super {
  font-size: 65%;
}

#fmrnwnigzh .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#fmrnwnigzh .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#fmrnwnigzh .gt_indent_1 {
  text-indent: 5px;
}

#fmrnwnigzh .gt_indent_2 {
  text-indent: 10px;
}

#fmrnwnigzh .gt_indent_3 {
  text-indent: 15px;
}

#fmrnwnigzh .gt_indent_4 {
  text-indent: 20px;
}

#fmrnwnigzh .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="8" class="gt_heading gt_title gt_font_normal" style>Penguins of the Palmer Archipelago</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="8" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Data is courtesy of the palmerpenguins R package by Allison Horst</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="2" colspan="1" scope="col" id="Year">Year</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Island">Island</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="year" class="gt_row gt_right">2007</td>
<td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="Adelie_female" class="gt_row gt_right">5</td>
<td headers="Adelie_male" class="gt_row gt_right">5</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><td headers="year" class="gt_row gt_right">2008</td>
<td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">9</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><td headers="year" class="gt_row gt_right">2009</td>
<td headers="island" class="gt_row gt_left">Biscoe</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr><td headers="year" class="gt_row gt_right">2007</td>
<td headers="island" class="gt_row gt_left">Dream</td>
<td headers="Adelie_female" class="gt_row gt_right">9</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="year" class="gt_row gt_right">2008</td>
<td headers="island" class="gt_row gt_left">Dream</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="year" class="gt_row gt_right">2009</td>
<td headers="island" class="gt_row gt_left">Dream</td>
<td headers="Adelie_female" class="gt_row gt_right">10</td>
<td headers="Adelie_male" class="gt_row gt_right">10</td>
<td headers="Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="year" class="gt_row gt_right">2007</td>
<td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">7</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="year" class="gt_row gt_right">2008</td>
<td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><td headers="year" class="gt_row gt_right">2009</td>
<td headers="island" class="gt_row gt_left">Torgersen</td>
<td headers="Adelie_female" class="gt_row gt_right">8</td>
<td headers="Adelie_male" class="gt_row gt_right">8</td>
<td headers="Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Gentoo_male" class="gt_row gt_right">0</td></tr>
  </tbody>
  
  
</table>
</div>
```


### Avoid repetitive information

Removing repetitive columns and using additional rows to group data can indeed enhance the readability of a table. In the context of the `gt` package, achieving this is straightforward. Here's how you can do it with `group_name_col()` Specifying which group to use and which columns to apply this grouping to:


```r
penguin_counts_wider |> 
  mutate(
    island = as.character(island), 
    year = as.numeric(year)
  ) |> 
  gt(groupname_col = 'island', rowname_col = 'year') |> 
  cols_label(.list = desired_colnames) |> 
  labels_and_title()  
```

```{=html}
<div id="pxcsyljqtv" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#pxcsyljqtv table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#pxcsyljqtv thead, #pxcsyljqtv tbody, #pxcsyljqtv tfoot, #pxcsyljqtv tr, #pxcsyljqtv td, #pxcsyljqtv th {
  border-style: none;
}

#pxcsyljqtv p {
  margin: 0;
  padding: 0;
}

#pxcsyljqtv .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#pxcsyljqtv .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#pxcsyljqtv .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#pxcsyljqtv .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#pxcsyljqtv .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#pxcsyljqtv .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pxcsyljqtv .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#pxcsyljqtv .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#pxcsyljqtv .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#pxcsyljqtv .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#pxcsyljqtv .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#pxcsyljqtv .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#pxcsyljqtv .gt_spanner_row {
  border-bottom-style: hidden;
}

#pxcsyljqtv .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#pxcsyljqtv .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#pxcsyljqtv .gt_from_md > :first-child {
  margin-top: 0;
}

#pxcsyljqtv .gt_from_md > :last-child {
  margin-bottom: 0;
}

#pxcsyljqtv .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#pxcsyljqtv .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#pxcsyljqtv .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#pxcsyljqtv .gt_row_group_first td {
  border-top-width: 2px;
}

#pxcsyljqtv .gt_row_group_first th {
  border-top-width: 2px;
}

#pxcsyljqtv .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#pxcsyljqtv .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#pxcsyljqtv .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#pxcsyljqtv .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pxcsyljqtv .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#pxcsyljqtv .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#pxcsyljqtv .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#pxcsyljqtv .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#pxcsyljqtv .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pxcsyljqtv .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#pxcsyljqtv .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#pxcsyljqtv .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#pxcsyljqtv .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#pxcsyljqtv .gt_left {
  text-align: left;
}

#pxcsyljqtv .gt_center {
  text-align: center;
}

#pxcsyljqtv .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#pxcsyljqtv .gt_font_normal {
  font-weight: normal;
}

#pxcsyljqtv .gt_font_bold {
  font-weight: bold;
}

#pxcsyljqtv .gt_font_italic {
  font-style: italic;
}

#pxcsyljqtv .gt_super {
  font-size: 65%;
}

#pxcsyljqtv .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#pxcsyljqtv .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#pxcsyljqtv .gt_indent_1 {
  text-indent: 5px;
}

#pxcsyljqtv .gt_indent_2 {
  text-indent: 10px;
}

#pxcsyljqtv .gt_indent_3 {
  text-indent: 15px;
}

#pxcsyljqtv .gt_indent_4 {
  text-indent: 20px;
}

#pxcsyljqtv .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_title gt_font_normal" style>Penguins of the Palmer Archipelago</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Data is courtesy of the palmerpenguins R package by Allison Horst</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=""></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Biscoe">Biscoe</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_1" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Biscoe stub_1_1 Adelie_female" class="gt_row gt_right">5</td>
<td headers="Biscoe stub_1_1 Adelie_male" class="gt_row gt_right">5</td>
<td headers="Biscoe stub_1_1 Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Biscoe stub_1_1 Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Biscoe stub_1_1 Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Biscoe stub_1_1 Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Biscoe stub_1_2 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Biscoe stub_1_2 Adelie_male" class="gt_row gt_right">9</td>
<td headers="Biscoe stub_1_2 Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Biscoe stub_1_2 Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Biscoe stub_1_2 Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Biscoe stub_1_2 Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Biscoe stub_1_3 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Biscoe stub_1_3 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Biscoe stub_1_3 Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Biscoe stub_1_3 Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Biscoe stub_1_3 Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Biscoe stub_1_3 Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Dream">Dream</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_4" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Dream stub_1_4 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Dream stub_1_4 Adelie_male" class="gt_row gt_right">10</td>
<td headers="Dream stub_1_4 Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Dream stub_1_4 Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Dream stub_1_4 Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Dream stub_1_4 Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Dream stub_1_5 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Dream stub_1_5 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Dream stub_1_5 Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Dream stub_1_5 Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Dream stub_1_5 Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Dream stub_1_5 Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Dream stub_1_6 Adelie_female" class="gt_row gt_right">10</td>
<td headers="Dream stub_1_6 Adelie_male" class="gt_row gt_right">10</td>
<td headers="Dream stub_1_6 Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Dream stub_1_6 Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Dream stub_1_6 Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Dream stub_1_6 Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Torgersen">Torgersen</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_7" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Torgersen stub_1_7 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Torgersen stub_1_7 Adelie_male" class="gt_row gt_right">7</td>
<td headers="Torgersen stub_1_7 Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Torgersen stub_1_7 Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Torgersen stub_1_7 Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Torgersen stub_1_7 Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><th id="stub_1_8" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Torgersen stub_1_8 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Torgersen stub_1_8 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Torgersen stub_1_8 Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Torgersen stub_1_8 Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Torgersen stub_1_8 Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Torgersen stub_1_8 Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><th id="stub_1_9" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Torgersen stub_1_9 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Torgersen stub_1_9 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Torgersen stub_1_9 Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Torgersen stub_1_9 Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Torgersen stub_1_9 Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Torgersen stub_1_9 Gentoo_male" class="gt_row gt_right">0</td></tr>
  </tbody>
  
  
</table>
</div>
```

But an island label could be nice. The easiest way to add that to the group names is via string manipulation before `gt()` is called.


```r
penguin_counts_wider |> 
  mutate(
    island = as.character(island), 
    year = as.numeric(year),
    island = paste0('Island: ', island)
  ) |> 
  gt(groupname_col = 'island', rowname_col = 'year') |> 
  cols_label(.list = desired_colnames) |> 
  labels_and_title() 
```

```{=html}
<div id="dsqrkmriuc" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#dsqrkmriuc table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#dsqrkmriuc thead, #dsqrkmriuc tbody, #dsqrkmriuc tfoot, #dsqrkmriuc tr, #dsqrkmriuc td, #dsqrkmriuc th {
  border-style: none;
}

#dsqrkmriuc p {
  margin: 0;
  padding: 0;
}

#dsqrkmriuc .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#dsqrkmriuc .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#dsqrkmriuc .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#dsqrkmriuc .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#dsqrkmriuc .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dsqrkmriuc .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dsqrkmriuc .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dsqrkmriuc .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#dsqrkmriuc .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#dsqrkmriuc .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#dsqrkmriuc .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#dsqrkmriuc .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#dsqrkmriuc .gt_spanner_row {
  border-bottom-style: hidden;
}

#dsqrkmriuc .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#dsqrkmriuc .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#dsqrkmriuc .gt_from_md > :first-child {
  margin-top: 0;
}

#dsqrkmriuc .gt_from_md > :last-child {
  margin-bottom: 0;
}

#dsqrkmriuc .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#dsqrkmriuc .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#dsqrkmriuc .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#dsqrkmriuc .gt_row_group_first td {
  border-top-width: 2px;
}

#dsqrkmriuc .gt_row_group_first th {
  border-top-width: 2px;
}

#dsqrkmriuc .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dsqrkmriuc .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#dsqrkmriuc .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#dsqrkmriuc .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dsqrkmriuc .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dsqrkmriuc .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#dsqrkmriuc .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#dsqrkmriuc .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#dsqrkmriuc .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dsqrkmriuc .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dsqrkmriuc .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dsqrkmriuc .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dsqrkmriuc .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dsqrkmriuc .gt_left {
  text-align: left;
}

#dsqrkmriuc .gt_center {
  text-align: center;
}

#dsqrkmriuc .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#dsqrkmriuc .gt_font_normal {
  font-weight: normal;
}

#dsqrkmriuc .gt_font_bold {
  font-weight: bold;
}

#dsqrkmriuc .gt_font_italic {
  font-style: italic;
}

#dsqrkmriuc .gt_super {
  font-size: 65%;
}

#dsqrkmriuc .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#dsqrkmriuc .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#dsqrkmriuc .gt_indent_1 {
  text-indent: 5px;
}

#dsqrkmriuc .gt_indent_2 {
  text-indent: 10px;
}

#dsqrkmriuc .gt_indent_3 {
  text-indent: 15px;
}

#dsqrkmriuc .gt_indent_4 {
  text-indent: 20px;
}

#dsqrkmriuc .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_title gt_font_normal" style>Penguins of the Palmer Archipelago</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Data is courtesy of the palmerpenguins R package by Allison Horst</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=""></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Biscoe">Island: Biscoe</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_1" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Biscoe stub_1_1 Adelie_female" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Adelie_male" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Biscoe stub_1_2 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Island: Biscoe stub_1_2 Adelie_male" class="gt_row gt_right">9</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Biscoe stub_1_3 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Dream">Island: Dream</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_4" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Dream stub_1_4 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_4 Adelie_male" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_4 Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Island: Dream stub_1_4 Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Island: Dream stub_1_4 Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Island: Dream stub_1_4 Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Dream stub_1_5 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Island: Dream stub_1_5 Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Dream stub_1_6 Adelie_female" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_6 Adelie_male" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_6 Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Island: Dream stub_1_6 Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Island: Dream stub_1_6 Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Island: Dream stub_1_6 Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Torgersen">Island: Torgersen</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_7" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Torgersen stub_1_7 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_7 Adelie_male" class="gt_row gt_right">7</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><th id="stub_1_8" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Torgersen stub_1_8 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_8 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_male" class="gt_row gt_right">0</td></tr>
    <tr><th id="stub_1_9" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Torgersen stub_1_9 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_female" class="gt_row gt_right">0</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_male" class="gt_row gt_right">0</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_female" class="gt_row gt_right">0</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_male" class="gt_row gt_right">0</td></tr>
  </tbody>
  
  
</table>
</div>
```

### Remove missing numbers

If we want to remove zeroes from our table, we could use `dplyr` functions


```r
penguin_counts_wider |> 
    mutate(
        island = as.character(island), 
        year = as.numeric(year),
        island = paste0('Island: ', island)
    ) |> 
    mutate(across(.cols = where(is.integer), .fns = ~ifelse(.x <= 0, "-", as.character(.) ))) |> 
  gt(groupname_col = 'island', rowname_col = 'year') |> 
  cols_label(.list = desired_colnames) |> 
  labels_and_title() 
```

```{=html}
<div id="qjdlwjsjhi" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#qjdlwjsjhi table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#qjdlwjsjhi thead, #qjdlwjsjhi tbody, #qjdlwjsjhi tfoot, #qjdlwjsjhi tr, #qjdlwjsjhi td, #qjdlwjsjhi th {
  border-style: none;
}

#qjdlwjsjhi p {
  margin: 0;
  padding: 0;
}

#qjdlwjsjhi .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#qjdlwjsjhi .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#qjdlwjsjhi .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#qjdlwjsjhi .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#qjdlwjsjhi .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#qjdlwjsjhi .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qjdlwjsjhi .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#qjdlwjsjhi .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#qjdlwjsjhi .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#qjdlwjsjhi .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#qjdlwjsjhi .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#qjdlwjsjhi .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#qjdlwjsjhi .gt_spanner_row {
  border-bottom-style: hidden;
}

#qjdlwjsjhi .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#qjdlwjsjhi .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#qjdlwjsjhi .gt_from_md > :first-child {
  margin-top: 0;
}

#qjdlwjsjhi .gt_from_md > :last-child {
  margin-bottom: 0;
}

#qjdlwjsjhi .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#qjdlwjsjhi .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#qjdlwjsjhi .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#qjdlwjsjhi .gt_row_group_first td {
  border-top-width: 2px;
}

#qjdlwjsjhi .gt_row_group_first th {
  border-top-width: 2px;
}

#qjdlwjsjhi .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qjdlwjsjhi .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#qjdlwjsjhi .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#qjdlwjsjhi .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qjdlwjsjhi .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qjdlwjsjhi .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#qjdlwjsjhi .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#qjdlwjsjhi .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#qjdlwjsjhi .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qjdlwjsjhi .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#qjdlwjsjhi .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#qjdlwjsjhi .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#qjdlwjsjhi .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#qjdlwjsjhi .gt_left {
  text-align: left;
}

#qjdlwjsjhi .gt_center {
  text-align: center;
}

#qjdlwjsjhi .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#qjdlwjsjhi .gt_font_normal {
  font-weight: normal;
}

#qjdlwjsjhi .gt_font_bold {
  font-weight: bold;
}

#qjdlwjsjhi .gt_font_italic {
  font-style: italic;
}

#qjdlwjsjhi .gt_super {
  font-size: 65%;
}

#qjdlwjsjhi .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#qjdlwjsjhi .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#qjdlwjsjhi .gt_indent_1 {
  text-indent: 5px;
}

#qjdlwjsjhi .gt_indent_2 {
  text-indent: 10px;
}

#qjdlwjsjhi .gt_indent_3 {
  text-indent: 15px;
}

#qjdlwjsjhi .gt_indent_4 {
  text-indent: 20px;
}

#qjdlwjsjhi .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_title gt_font_normal" style>Penguins of the Palmer Archipelago</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Data is courtesy of the palmerpenguins R package by Allison Horst</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=""></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Biscoe">Island: Biscoe</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_1" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Biscoe stub_1_1 Adelie_female" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Adelie_male" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Biscoe stub_1_2 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Island: Biscoe stub_1_2 Adelie_male" class="gt_row gt_right">9</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Biscoe stub_1_3 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Dream">Island: Dream</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_4" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Dream stub_1_4 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_4 Adelie_male" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_4 Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Island: Dream stub_1_4 Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Island: Dream stub_1_4 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_4 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Dream stub_1_5 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_5 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Dream stub_1_6 Adelie_female" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_6 Adelie_male" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_6 Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Island: Dream stub_1_6 Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Island: Dream stub_1_6 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_6 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Torgersen">Island: Torgersen</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_7" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Torgersen stub_1_7 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_7 Adelie_male" class="gt_row gt_right">7</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_8" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Torgersen stub_1_8 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_8 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_9" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Torgersen stub_1_9 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_male" class="gt_row gt_right">-</td></tr>
  </tbody>
  
  
</table>
</div>
```

Or we can accomplish the same thing by adding a `sub_zero()` layer


```r
penguin_counts_wider |> 
  mutate(
    island = as.character(island), 
    year = as.numeric(year),
    island = paste0('Island: ', island)
  ) |> 
  gt(groupname_col = 'island', rowname_col = 'year') |> 
  cols_label(.list = desired_colnames) |> 
  labels_and_title()  |> 
  sub_zero(zero_text = '-')
```

```{=html}
<div id="jcsnnxtqxz" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#jcsnnxtqxz table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#jcsnnxtqxz thead, #jcsnnxtqxz tbody, #jcsnnxtqxz tfoot, #jcsnnxtqxz tr, #jcsnnxtqxz td, #jcsnnxtqxz th {
  border-style: none;
}

#jcsnnxtqxz p {
  margin: 0;
  padding: 0;
}

#jcsnnxtqxz .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#jcsnnxtqxz .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#jcsnnxtqxz .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#jcsnnxtqxz .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#jcsnnxtqxz .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#jcsnnxtqxz .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#jcsnnxtqxz .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#jcsnnxtqxz .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#jcsnnxtqxz .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#jcsnnxtqxz .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#jcsnnxtqxz .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#jcsnnxtqxz .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#jcsnnxtqxz .gt_spanner_row {
  border-bottom-style: hidden;
}

#jcsnnxtqxz .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#jcsnnxtqxz .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#jcsnnxtqxz .gt_from_md > :first-child {
  margin-top: 0;
}

#jcsnnxtqxz .gt_from_md > :last-child {
  margin-bottom: 0;
}

#jcsnnxtqxz .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#jcsnnxtqxz .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#jcsnnxtqxz .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#jcsnnxtqxz .gt_row_group_first td {
  border-top-width: 2px;
}

#jcsnnxtqxz .gt_row_group_first th {
  border-top-width: 2px;
}

#jcsnnxtqxz .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#jcsnnxtqxz .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#jcsnnxtqxz .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#jcsnnxtqxz .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#jcsnnxtqxz .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#jcsnnxtqxz .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#jcsnnxtqxz .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#jcsnnxtqxz .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#jcsnnxtqxz .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#jcsnnxtqxz .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#jcsnnxtqxz .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#jcsnnxtqxz .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#jcsnnxtqxz .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#jcsnnxtqxz .gt_left {
  text-align: left;
}

#jcsnnxtqxz .gt_center {
  text-align: center;
}

#jcsnnxtqxz .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#jcsnnxtqxz .gt_font_normal {
  font-weight: normal;
}

#jcsnnxtqxz .gt_font_bold {
  font-weight: bold;
}

#jcsnnxtqxz .gt_font_italic {
  font-style: italic;
}

#jcsnnxtqxz .gt_super {
  font-size: 65%;
}

#jcsnnxtqxz .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#jcsnnxtqxz .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#jcsnnxtqxz .gt_indent_1 {
  text-indent: 5px;
}

#jcsnnxtqxz .gt_indent_2 {
  text-indent: 10px;
}

#jcsnnxtqxz .gt_indent_3 {
  text-indent: 15px;
}

#jcsnnxtqxz .gt_indent_4 {
  text-indent: 20px;
}

#jcsnnxtqxz .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_title gt_font_normal" style>Penguins of the Palmer Archipelago</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Data is courtesy of the palmerpenguins R package by Allison Horst</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=""></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Biscoe">Island: Biscoe</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_1" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Biscoe stub_1_1 Adelie_female" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Adelie_male" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Biscoe stub_1_2 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Island: Biscoe stub_1_2 Adelie_male" class="gt_row gt_right">9</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Biscoe stub_1_3 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Dream">Island: Dream</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_4" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Dream stub_1_4 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_4 Adelie_male" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_4 Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Island: Dream stub_1_4 Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Island: Dream stub_1_4 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_4 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Dream stub_1_5 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_5 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Dream stub_1_6 Adelie_female" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_6 Adelie_male" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_6 Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Island: Dream stub_1_6 Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Island: Dream stub_1_6 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_6 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Torgersen">Island: Torgersen</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_7" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Torgersen stub_1_7 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_7 Adelie_male" class="gt_row gt_right">7</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_8" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Torgersen stub_1_8 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_8 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_9" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Torgersen stub_1_9 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_male" class="gt_row gt_right">-</td></tr>
  </tbody>
  
  
</table>
</div>
```

### Add summaries

If we think it is necessary we could even add some summaries to the tables with `summary_rows()`.
Sub-zero doesn't seem to work in the summaries, so we have to include a workaround:


```r
penguin_counts_wider |> 
  mutate(
    island = as.character(island), 
    year = as.numeric(year),
    island = paste0('Island: ', island)
  ) |> 
  gt(groupname_col = 'island', rowname_col = 'year') |> 
  cols_label(.list = desired_colnames) |> 
  labels_and_title()  |> 
  sub_zero(zero_text = '-')|>
   summary_rows(
    groups = everything(),
   fns = list(
      "Mean" = ~na_if(mean(., na.rm = TRUE), 0),
      "Total" = ~na_if(sum(., na.rm = TRUE), 0)
    ),
    fmt = list(~fmt_number(., decimals = 0)),
    missing_text = "-")
```

```{=html}
<div id="kbabbxxsdl" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#kbabbxxsdl table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#kbabbxxsdl thead, #kbabbxxsdl tbody, #kbabbxxsdl tfoot, #kbabbxxsdl tr, #kbabbxxsdl td, #kbabbxxsdl th {
  border-style: none;
}

#kbabbxxsdl p {
  margin: 0;
  padding: 0;
}

#kbabbxxsdl .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#kbabbxxsdl .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#kbabbxxsdl .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#kbabbxxsdl .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#kbabbxxsdl .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#kbabbxxsdl .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kbabbxxsdl .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#kbabbxxsdl .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#kbabbxxsdl .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#kbabbxxsdl .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#kbabbxxsdl .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#kbabbxxsdl .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#kbabbxxsdl .gt_spanner_row {
  border-bottom-style: hidden;
}

#kbabbxxsdl .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#kbabbxxsdl .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#kbabbxxsdl .gt_from_md > :first-child {
  margin-top: 0;
}

#kbabbxxsdl .gt_from_md > :last-child {
  margin-bottom: 0;
}

#kbabbxxsdl .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#kbabbxxsdl .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#kbabbxxsdl .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#kbabbxxsdl .gt_row_group_first td {
  border-top-width: 2px;
}

#kbabbxxsdl .gt_row_group_first th {
  border-top-width: 2px;
}

#kbabbxxsdl .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kbabbxxsdl .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#kbabbxxsdl .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#kbabbxxsdl .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kbabbxxsdl .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kbabbxxsdl .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#kbabbxxsdl .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#kbabbxxsdl .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#kbabbxxsdl .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kbabbxxsdl .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#kbabbxxsdl .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kbabbxxsdl .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#kbabbxxsdl .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kbabbxxsdl .gt_left {
  text-align: left;
}

#kbabbxxsdl .gt_center {
  text-align: center;
}

#kbabbxxsdl .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#kbabbxxsdl .gt_font_normal {
  font-weight: normal;
}

#kbabbxxsdl .gt_font_bold {
  font-weight: bold;
}

#kbabbxxsdl .gt_font_italic {
  font-style: italic;
}

#kbabbxxsdl .gt_super {
  font-size: 65%;
}

#kbabbxxsdl .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#kbabbxxsdl .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#kbabbxxsdl .gt_indent_1 {
  text-indent: 5px;
}

#kbabbxxsdl .gt_indent_2 {
  text-indent: 10px;
}

#kbabbxxsdl .gt_indent_3 {
  text-indent: 15px;
}

#kbabbxxsdl .gt_indent_4 {
  text-indent: 20px;
}

#kbabbxxsdl .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_title gt_font_normal" style>Penguins of the Palmer Archipelago</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Data is courtesy of the palmerpenguins R package by Allison Horst</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=""></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Biscoe">Island: Biscoe</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_1" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Biscoe stub_1_1 Adelie_female" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Adelie_male" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Biscoe stub_1_2 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Island: Biscoe stub_1_2 Adelie_male" class="gt_row gt_right">9</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Biscoe stub_1_3 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr><th id="summary_stub_Island: Biscoe_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">7</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">7</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">19</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">20</td></tr>
    <tr><th id="summary_stub_Island: Biscoe_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">22</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">22</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">58</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">61</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Dream">Island: Dream</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_4" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Dream stub_1_4 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_4 Adelie_male" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_4 Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Island: Dream stub_1_4 Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Island: Dream stub_1_4 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_4 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Dream stub_1_5 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_5 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Dream stub_1_6 Adelie_female" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_6 Adelie_male" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_6 Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Island: Dream stub_1_6 Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Island: Dream stub_1_6 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_6 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="summary_stub_Island: Dream_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Dream summary_stub_Island: Dream_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">9</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">9</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">11</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">11</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td></tr>
    <tr><th id="summary_stub_Island: Dream_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Dream summary_stub_Island: Dream_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">27</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">28</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">34</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">34</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Torgersen">Island: Torgersen</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_7" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Torgersen stub_1_7 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_7 Adelie_male" class="gt_row gt_right">7</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_8" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Torgersen stub_1_8 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_8 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_9" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Torgersen stub_1_9 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="summary_stub_Island: Torgersen_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">8</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">8</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td></tr>
    <tr><th id="summary_stub_Island: Torgersen_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">24</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">23</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td></tr>
  </tbody>
  
  
</table>
</div>
```

### Stylise

With the additional information incorporated into the table, it has grown in length, which may not be ideal. To address this, we can make the table more concise by decreasing the row heights. 

To achieve this, we can adjust the so-called `data_row.padding` to 2 pixels. You can accomplish this using the `tab_options()` function, which is a central layer for styling the table. Similarly, there are padding options available for `summary_row` and `row_group`. While we're at it, it's a good idea to enhance the table's appearance by applying a predefined theme using `opt_stylize()`.


```r
penguin_counts_wider |> 
  mutate(
    island = as.character(island), 
    year = as.numeric(year),
    island = paste0('Island: ', island)
  ) |> 
  gt(groupname_col = 'island', rowname_col = 'year') |> 
  cols_label(.list = desired_colnames) |> 
  labels_and_title()  |> 
  sub_zero(zero_text = '-')|>
   summary_rows(
    groups = everything(),
   fns = list(
      "Mean" = ~na_if(mean(., na.rm = TRUE), 0),
      "Total" = ~na_if(sum(., na.rm = TRUE), 0)
    ),
    fmt = list(~fmt_number(., decimals = 0)),
    missing_text = "-") |> 
    tab_options(
    data_row.padding = px(2),
    summary_row.padding = px(3), # A bit more padding for summaries
    row_group.padding = px(4)    # And even more for our groups
  ) |> 
  opt_stylize(style = 6, color = 'gray')
```

```{=html}
<div id="lwflplsdtu" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#lwflplsdtu table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#lwflplsdtu thead, #lwflplsdtu tbody, #lwflplsdtu tfoot, #lwflplsdtu tr, #lwflplsdtu td, #lwflplsdtu th {
  border-style: none;
}

#lwflplsdtu p {
  margin: 0;
  padding: 0;
}

#lwflplsdtu .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #5F5F5F;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#lwflplsdtu .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#lwflplsdtu .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#lwflplsdtu .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#lwflplsdtu .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#lwflplsdtu .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
}

#lwflplsdtu .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #5F5F5F;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#lwflplsdtu .gt_col_heading {
  color: #FFFFFF;
  background-color: #5F5F5F;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#lwflplsdtu .gt_column_spanner_outer {
  color: #FFFFFF;
  background-color: #5F5F5F;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#lwflplsdtu .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#lwflplsdtu .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#lwflplsdtu .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#lwflplsdtu .gt_spanner_row {
  border-bottom-style: hidden;
}

#lwflplsdtu .gt_group_heading {
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #5F5F5F;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#lwflplsdtu .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #5F5F5F;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
  vertical-align: middle;
}

#lwflplsdtu .gt_from_md > :first-child {
  margin-top: 0;
}

#lwflplsdtu .gt_from_md > :last-child {
  margin-bottom: 0;
}

#lwflplsdtu .gt_row {
  padding-top: 2px;
  padding-bottom: 2px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: none;
  border-top-width: 1px;
  border-top-color: #D5D5D5;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D5D5D5;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D5D5D5;
  vertical-align: middle;
  overflow-x: hidden;
}

#lwflplsdtu .gt_stub {
  color: #333333;
  background-color: #D5D5D5;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D5D5D5;
  padding-left: 5px;
  padding-right: 5px;
}

#lwflplsdtu .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#lwflplsdtu .gt_row_group_first td {
  border-top-width: 2px;
}

#lwflplsdtu .gt_row_group_first th {
  border-top-width: 2px;
}

#lwflplsdtu .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 3px;
  padding-bottom: 3px;
  padding-left: 5px;
  padding-right: 5px;
}

#lwflplsdtu .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #5F5F5F;
}

#lwflplsdtu .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#lwflplsdtu .gt_last_summary_row {
  padding-top: 3px;
  padding-bottom: 3px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
}

#lwflplsdtu .gt_grand_summary_row {
  color: #333333;
  background-color: #D5D5D5;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#lwflplsdtu .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #5F5F5F;
}

#lwflplsdtu .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #5F5F5F;
}

#lwflplsdtu .gt_striped {
  background-color: #F4F4F4;
}

#lwflplsdtu .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #5F5F5F;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #5F5F5F;
}

#lwflplsdtu .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#lwflplsdtu .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#lwflplsdtu .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#lwflplsdtu .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#lwflplsdtu .gt_left {
  text-align: left;
}

#lwflplsdtu .gt_center {
  text-align: center;
}

#lwflplsdtu .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#lwflplsdtu .gt_font_normal {
  font-weight: normal;
}

#lwflplsdtu .gt_font_bold {
  font-weight: bold;
}

#lwflplsdtu .gt_font_italic {
  font-style: italic;
}

#lwflplsdtu .gt_super {
  font-size: 65%;
}

#lwflplsdtu .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#lwflplsdtu .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#lwflplsdtu .gt_indent_1 {
  text-indent: 5px;
}

#lwflplsdtu .gt_indent_2 {
  text-indent: 10px;
}

#lwflplsdtu .gt_indent_3 {
  text-indent: 15px;
}

#lwflplsdtu .gt_indent_4 {
  text-indent: 20px;
}

#lwflplsdtu .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_title gt_font_normal" style>Penguins of the Palmer Archipelago</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Data is courtesy of the palmerpenguins R package by Allison Horst</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=""></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Biscoe">Island: Biscoe</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_1" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Biscoe stub_1_1 Adelie_female" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Adelie_male" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Biscoe stub_1_2 Adelie_female" class="gt_row gt_right gt_striped">9</td>
<td headers="Island: Biscoe stub_1_2 Adelie_male" class="gt_row gt_right gt_striped">9</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_female" class="gt_row gt_right gt_striped">-</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_male" class="gt_row gt_right gt_striped">-</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_female" class="gt_row gt_right gt_striped">22</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_male" class="gt_row gt_right gt_striped">23</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Biscoe stub_1_3 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr><th id="summary_stub_Island: Biscoe_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">7</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">7</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">19</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">20</td></tr>
    <tr><th id="summary_stub_Island: Biscoe_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">22</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">22</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">58</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">61</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Dream">Island: Dream</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_4" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Dream stub_1_4 Adelie_female" class="gt_row gt_right gt_striped">9</td>
<td headers="Island: Dream stub_1_4 Adelie_male" class="gt_row gt_right gt_striped">10</td>
<td headers="Island: Dream stub_1_4 Chinstrap_female" class="gt_row gt_right gt_striped">13</td>
<td headers="Island: Dream stub_1_4 Chinstrap_male" class="gt_row gt_right gt_striped">13</td>
<td headers="Island: Dream stub_1_4 Gentoo_female" class="gt_row gt_right gt_striped">-</td>
<td headers="Island: Dream stub_1_4 Gentoo_male" class="gt_row gt_right gt_striped">-</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Dream stub_1_5 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_5 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Dream stub_1_6 Adelie_female" class="gt_row gt_right gt_striped">10</td>
<td headers="Island: Dream stub_1_6 Adelie_male" class="gt_row gt_right gt_striped">10</td>
<td headers="Island: Dream stub_1_6 Chinstrap_female" class="gt_row gt_right gt_striped">12</td>
<td headers="Island: Dream stub_1_6 Chinstrap_male" class="gt_row gt_right gt_striped">12</td>
<td headers="Island: Dream stub_1_6 Gentoo_female" class="gt_row gt_right gt_striped">-</td>
<td headers="Island: Dream stub_1_6 Gentoo_male" class="gt_row gt_right gt_striped">-</td></tr>
    <tr><th id="summary_stub_Island: Dream_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Dream summary_stub_Island: Dream_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">9</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">9</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">11</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">11</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td></tr>
    <tr><th id="summary_stub_Island: Dream_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Dream summary_stub_Island: Dream_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">27</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">28</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">34</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">34</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Torgersen">Island: Torgersen</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_7" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Torgersen stub_1_7 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_7 Adelie_male" class="gt_row gt_right">7</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_8" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Torgersen stub_1_8 Adelie_female" class="gt_row gt_right gt_striped">8</td>
<td headers="Island: Torgersen stub_1_8 Adelie_male" class="gt_row gt_right gt_striped">8</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_female" class="gt_row gt_right gt_striped">-</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_male" class="gt_row gt_right gt_striped">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_female" class="gt_row gt_right gt_striped">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_male" class="gt_row gt_right gt_striped">-</td></tr>
    <tr><th id="stub_1_9" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Torgersen stub_1_9 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="summary_stub_Island: Torgersen_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">8</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">8</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td></tr>
    <tr><th id="summary_stub_Island: Torgersen_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">24</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">23</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td></tr>
  </tbody>
  
  
</table>
</div>
```



### Use appropriate colour

So far, our table hasn’t used any color. We’ll add some now to highlight outlier values. 


```r
penguin_counts_wider |> 
  mutate(
    island = as.character(island), 
    year = as.numeric(year),
    island = paste0('Island: ', island)
  ) |> 
  gt(groupname_col = 'island', rowname_col = 'year') |> 
  cols_label(.list = desired_colnames) |> 
  labels_and_title()  |> 
  sub_zero(zero_text = '-')|>
   summary_rows(
    groups = everything(),
   fns = list(
      "Mean" = ~na_if(mean(., na.rm = TRUE), 0),
      "Total" = ~na_if(sum(., na.rm = TRUE), 0)
    ),
    fmt = list(~fmt_number(., decimals = 0)),
    missing_text = "-") |> 
    tab_options(
    data_row.padding = px(2),
    summary_row.padding = px(3), # A bit more padding for summaries
    row_group.padding = px(4)    # And even more for our groups
   )|> 
    tab_style(style = cell_text(color = "orange",
                              weight = "bold"),
            locations = cells_body(
              columns = 3,
             rows = which(penguin_counts_wider[,3] == max(penguin_counts_wider[,3])))
            ) 
```

```{=html}
<div id="krhfmehanl" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#krhfmehanl table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#krhfmehanl thead, #krhfmehanl tbody, #krhfmehanl tfoot, #krhfmehanl tr, #krhfmehanl td, #krhfmehanl th {
  border-style: none;
}

#krhfmehanl p {
  margin: 0;
  padding: 0;
}

#krhfmehanl .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#krhfmehanl .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#krhfmehanl .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#krhfmehanl .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#krhfmehanl .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#krhfmehanl .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#krhfmehanl .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#krhfmehanl .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#krhfmehanl .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#krhfmehanl .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#krhfmehanl .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#krhfmehanl .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#krhfmehanl .gt_spanner_row {
  border-bottom-style: hidden;
}

#krhfmehanl .gt_group_heading {
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#krhfmehanl .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#krhfmehanl .gt_from_md > :first-child {
  margin-top: 0;
}

#krhfmehanl .gt_from_md > :last-child {
  margin-bottom: 0;
}

#krhfmehanl .gt_row {
  padding-top: 2px;
  padding-bottom: 2px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#krhfmehanl .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#krhfmehanl .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#krhfmehanl .gt_row_group_first td {
  border-top-width: 2px;
}

#krhfmehanl .gt_row_group_first th {
  border-top-width: 2px;
}

#krhfmehanl .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 3px;
  padding-bottom: 3px;
  padding-left: 5px;
  padding-right: 5px;
}

#krhfmehanl .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#krhfmehanl .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#krhfmehanl .gt_last_summary_row {
  padding-top: 3px;
  padding-bottom: 3px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#krhfmehanl .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#krhfmehanl .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#krhfmehanl .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#krhfmehanl .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#krhfmehanl .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#krhfmehanl .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#krhfmehanl .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#krhfmehanl .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#krhfmehanl .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#krhfmehanl .gt_left {
  text-align: left;
}

#krhfmehanl .gt_center {
  text-align: center;
}

#krhfmehanl .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#krhfmehanl .gt_font_normal {
  font-weight: normal;
}

#krhfmehanl .gt_font_bold {
  font-weight: bold;
}

#krhfmehanl .gt_font_italic {
  font-style: italic;
}

#krhfmehanl .gt_super {
  font-size: 65%;
}

#krhfmehanl .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#krhfmehanl .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#krhfmehanl .gt_indent_1 {
  text-indent: 5px;
}

#krhfmehanl .gt_indent_2 {
  text-indent: 10px;
}

#krhfmehanl .gt_indent_3 {
  text-indent: 15px;
}

#krhfmehanl .gt_indent_4 {
  text-indent: 20px;
}

#krhfmehanl .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_title gt_font_normal" style>Penguins of the Palmer Archipelago</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Data is courtesy of the palmerpenguins R package by Allison Horst</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=""></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Biscoe">Island: Biscoe</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_1" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Biscoe stub_1_1 Adelie_female" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Adelie_male" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Biscoe stub_1_2 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Island: Biscoe stub_1_2 Adelie_male" class="gt_row gt_right">9</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_female" class="gt_row gt_right">22</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_male" class="gt_row gt_right">23</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Biscoe stub_1_3 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr><th id="summary_stub_Island: Biscoe_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">7</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">7</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">19</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">20</td></tr>
    <tr><th id="summary_stub_Island: Biscoe_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">22</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">22</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">58</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">61</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Dream">Island: Dream</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_4" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Dream stub_1_4 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_4 Adelie_male" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_4 Chinstrap_female" class="gt_row gt_right">13</td>
<td headers="Island: Dream stub_1_4 Chinstrap_male" class="gt_row gt_right">13</td>
<td headers="Island: Dream stub_1_4 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_4 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Dream stub_1_5 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_5 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Dream stub_1_6 Adelie_female" class="gt_row gt_right" style="color: #FFA500; font-weight: bold;">10</td>
<td headers="Island: Dream stub_1_6 Adelie_male" class="gt_row gt_right">10</td>
<td headers="Island: Dream stub_1_6 Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Island: Dream stub_1_6 Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Island: Dream stub_1_6 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_6 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="summary_stub_Island: Dream_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Dream summary_stub_Island: Dream_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">9</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">9</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">11</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">11</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td></tr>
    <tr><th id="summary_stub_Island: Dream_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Dream summary_stub_Island: Dream_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">27</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">28</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">34</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">34</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Torgersen">Island: Torgersen</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_7" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Torgersen stub_1_7 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_7 Adelie_male" class="gt_row gt_right">7</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_8" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Torgersen stub_1_8 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_8 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_9" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Torgersen stub_1_9 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="summary_stub_Island: Torgersen_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">8</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">8</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td></tr>
    <tr><th id="summary_stub_Island: Torgersen_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">24</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">23</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td></tr>
  </tbody>
  
  
</table>
</div>
```



If we repeat this code for each column, we generate the result shown below


```{=html}
<div id="wywjfszers" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#wywjfszers table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#wywjfszers thead, #wywjfszers tbody, #wywjfszers tfoot, #wywjfszers tr, #wywjfszers td, #wywjfszers th {
  border-style: none;
}

#wywjfszers p {
  margin: 0;
  padding: 0;
}

#wywjfszers .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#wywjfszers .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#wywjfszers .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#wywjfszers .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#wywjfszers .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#wywjfszers .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wywjfszers .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#wywjfszers .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#wywjfszers .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#wywjfszers .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#wywjfszers .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#wywjfszers .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#wywjfszers .gt_spanner_row {
  border-bottom-style: hidden;
}

#wywjfszers .gt_group_heading {
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#wywjfszers .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#wywjfszers .gt_from_md > :first-child {
  margin-top: 0;
}

#wywjfszers .gt_from_md > :last-child {
  margin-bottom: 0;
}

#wywjfszers .gt_row {
  padding-top: 2px;
  padding-bottom: 2px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#wywjfszers .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#wywjfszers .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#wywjfszers .gt_row_group_first td {
  border-top-width: 2px;
}

#wywjfszers .gt_row_group_first th {
  border-top-width: 2px;
}

#wywjfszers .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 3px;
  padding-bottom: 3px;
  padding-left: 5px;
  padding-right: 5px;
}

#wywjfszers .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#wywjfszers .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#wywjfszers .gt_last_summary_row {
  padding-top: 3px;
  padding-bottom: 3px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wywjfszers .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#wywjfszers .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#wywjfszers .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#wywjfszers .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#wywjfszers .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wywjfszers .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#wywjfszers .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#wywjfszers .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#wywjfszers .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#wywjfszers .gt_left {
  text-align: left;
}

#wywjfszers .gt_center {
  text-align: center;
}

#wywjfszers .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#wywjfszers .gt_font_normal {
  font-weight: normal;
}

#wywjfszers .gt_font_bold {
  font-weight: bold;
}

#wywjfszers .gt_font_italic {
  font-style: italic;
}

#wywjfszers .gt_super {
  font-size: 65%;
}

#wywjfszers .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#wywjfszers .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#wywjfszers .gt_indent_1 {
  text-indent: 5px;
}

#wywjfszers .gt_indent_2 {
  text-indent: 10px;
}

#wywjfszers .gt_indent_3 {
  text-indent: 15px;
}

#wywjfszers .gt_indent_4 {
  text-indent: 20px;
}

#wywjfszers .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_title gt_font_normal" style>Penguins of the Palmer Archipelago</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Data is courtesy of the palmerpenguins R package by Allison Horst</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=""></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Biscoe">Island: Biscoe</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_1" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Biscoe stub_1_1 Adelie_female" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Adelie_male" class="gt_row gt_right">5</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_female" class="gt_row gt_right">16</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_male" class="gt_row gt_right">17</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Biscoe stub_1_2 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Island: Biscoe stub_1_2 Adelie_male" class="gt_row gt_right">9</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_female" class="gt_row gt_right" style="color: #FFA500; font-weight: bold;">22</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_male" class="gt_row gt_right" style="color: #FFA500; font-weight: bold;">23</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Biscoe stub_1_3 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_female" class="gt_row gt_right">20</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_male" class="gt_row gt_right">21</td></tr>
    <tr><th id="summary_stub_Island: Biscoe_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">7</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">7</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">19</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">20</td></tr>
    <tr><th id="summary_stub_Island: Biscoe_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">22</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">22</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">58</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">61</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Dream">Island: Dream</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_4" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Dream stub_1_4 Adelie_female" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_4 Adelie_male" class="gt_row gt_right" style="color: #FFA500; font-weight: bold;">10</td>
<td headers="Island: Dream stub_1_4 Chinstrap_female" class="gt_row gt_right" style="color: #FFA500; font-weight: bold;">13</td>
<td headers="Island: Dream stub_1_4 Chinstrap_male" class="gt_row gt_right" style="color: #FFA500; font-weight: bold;">13</td>
<td headers="Island: Dream stub_1_4 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_4 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Dream stub_1_5 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Dream stub_1_5 Chinstrap_female" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Chinstrap_male" class="gt_row gt_right">9</td>
<td headers="Island: Dream stub_1_5 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_5 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Dream stub_1_6 Adelie_female" class="gt_row gt_right" style="color: #FFA500; font-weight: bold;">10</td>
<td headers="Island: Dream stub_1_6 Adelie_male" class="gt_row gt_right" style="color: #FFA500; font-weight: bold;">10</td>
<td headers="Island: Dream stub_1_6 Chinstrap_female" class="gt_row gt_right">12</td>
<td headers="Island: Dream stub_1_6 Chinstrap_male" class="gt_row gt_right">12</td>
<td headers="Island: Dream stub_1_6 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Dream stub_1_6 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="summary_stub_Island: Dream_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Dream summary_stub_Island: Dream_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">9</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">9</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">11</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">11</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td></tr>
    <tr><th id="summary_stub_Island: Dream_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Dream summary_stub_Island: Dream_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">27</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">28</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">34</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">34</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Torgersen">Island: Torgersen</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_7" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Torgersen stub_1_7 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_7 Adelie_male" class="gt_row gt_right">7</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_8" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Torgersen stub_1_8 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_8 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="stub_1_9" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Torgersen stub_1_9 Adelie_female" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Adelie_male" class="gt_row gt_right">8</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_male" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_female" class="gt_row gt_right">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_male" class="gt_row gt_right">-</td></tr>
    <tr><th id="summary_stub_Island: Torgersen_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">8</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">8</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td></tr>
    <tr><th id="summary_stub_Island: Torgersen_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">24</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">23</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td></tr>
  </tbody>
  
  
</table>
</div>
```


### Heatmap

We can add a heatmap to our cells to more clearly show the differences. This will require us to set a colour palette and apply a conditional colouring using `data_color()`


```r
penguin_counts_wider |> 
  mutate(
    island = as.character(island), 
    year = as.numeric(year),
    island = paste0('Island: ', island)
  ) |> 
  gt(groupname_col = 'island', rowname_col = 'year') |> 
  cols_label(.list = desired_colnames) |> 
  labels_and_title()  |> 
  sub_zero(zero_text = '-')|>
   summary_rows(
    groups = everything(),
   fns = list(
      "Mean" = ~na_if(mean(., na.rm = TRUE), 0),
      "Total" = ~na_if(sum(., na.rm = TRUE), 0)
    ),
    fmt = list(~fmt_number(., decimals = 0)),
    missing_text = "-") |> 
    tab_options(
    data_row.padding = px(2),
    summary_row.padding = px(3), # A bit more padding for summaries
    row_group.padding = px(4)    # And even more for our groups
   )|>  
data_color(palette = c("#FEF0D9", "#990000"), domain = c(0,30))
```

```{=html}
<div id="bjaptqorun" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#bjaptqorun table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#bjaptqorun thead, #bjaptqorun tbody, #bjaptqorun tfoot, #bjaptqorun tr, #bjaptqorun td, #bjaptqorun th {
  border-style: none;
}

#bjaptqorun p {
  margin: 0;
  padding: 0;
}

#bjaptqorun .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#bjaptqorun .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#bjaptqorun .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#bjaptqorun .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#bjaptqorun .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#bjaptqorun .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bjaptqorun .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#bjaptqorun .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#bjaptqorun .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#bjaptqorun .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#bjaptqorun .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#bjaptqorun .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#bjaptqorun .gt_spanner_row {
  border-bottom-style: hidden;
}

#bjaptqorun .gt_group_heading {
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#bjaptqorun .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#bjaptqorun .gt_from_md > :first-child {
  margin-top: 0;
}

#bjaptqorun .gt_from_md > :last-child {
  margin-bottom: 0;
}

#bjaptqorun .gt_row {
  padding-top: 2px;
  padding-bottom: 2px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#bjaptqorun .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#bjaptqorun .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#bjaptqorun .gt_row_group_first td {
  border-top-width: 2px;
}

#bjaptqorun .gt_row_group_first th {
  border-top-width: 2px;
}

#bjaptqorun .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 3px;
  padding-bottom: 3px;
  padding-left: 5px;
  padding-right: 5px;
}

#bjaptqorun .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#bjaptqorun .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#bjaptqorun .gt_last_summary_row {
  padding-top: 3px;
  padding-bottom: 3px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bjaptqorun .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bjaptqorun .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#bjaptqorun .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#bjaptqorun .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#bjaptqorun .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bjaptqorun .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#bjaptqorun .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#bjaptqorun .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#bjaptqorun .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#bjaptqorun .gt_left {
  text-align: left;
}

#bjaptqorun .gt_center {
  text-align: center;
}

#bjaptqorun .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#bjaptqorun .gt_font_normal {
  font-weight: normal;
}

#bjaptqorun .gt_font_bold {
  font-weight: bold;
}

#bjaptqorun .gt_font_italic {
  font-style: italic;
}

#bjaptqorun .gt_super {
  font-size: 65%;
}

#bjaptqorun .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#bjaptqorun .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#bjaptqorun .gt_indent_1 {
  text-indent: 5px;
}

#bjaptqorun .gt_indent_2 {
  text-indent: 10px;
}

#bjaptqorun .gt_indent_3 {
  text-indent: 15px;
}

#bjaptqorun .gt_indent_4 {
  text-indent: 20px;
}

#bjaptqorun .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_title gt_font_normal" style>Penguins of the Palmer Archipelago</td>
    </tr>
    <tr class="gt_heading">
      <td colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Data is courtesy of the palmerpenguins R package by Allison Horst</td>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=""></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Adelie&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Adelie</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Chinstrap&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Chinstrap</strong></span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="&lt;strong&gt;Gentoo&lt;/strong&gt;">
        <span class="gt_column_spanner"><strong>Gentoo</strong></span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Male">Male</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Biscoe">Island: Biscoe</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_1" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Biscoe stub_1_1 Adelie_female" class="gt_row gt_right" style="background-color: #F3CCB2; color: #000000;">5</td>
<td headers="Island: Biscoe stub_1_1 Adelie_male" class="gt_row gt_right" style="background-color: #F3CCB2; color: #000000;">5</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_female" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Biscoe stub_1_1 Chinstrap_male" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_female" class="gt_row gt_right" style="background-color: #D27E60; color: #FFFFFF;">16</td>
<td headers="Island: Biscoe stub_1_1 Gentoo_male" class="gt_row gt_right" style="background-color: #CF7759; color: #FFFFFF;">17</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Biscoe stub_1_2 Adelie_female" class="gt_row gt_right" style="background-color: #E8AF93; color: #000000;">9</td>
<td headers="Island: Biscoe stub_1_2 Adelie_male" class="gt_row gt_right" style="background-color: #E8AF93; color: #000000;">9</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_female" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Biscoe stub_1_2 Chinstrap_male" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_female" class="gt_row gt_right" style="background-color: #BC5337; color: #FFFFFF;">22</td>
<td headers="Island: Biscoe stub_1_2 Gentoo_male" class="gt_row gt_right" style="background-color: #B84B30; color: #FFFFFF;">23</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Biscoe stub_1_3 Adelie_female" class="gt_row gt_right" style="background-color: #EBB69B; color: #000000;">8</td>
<td headers="Island: Biscoe stub_1_3 Adelie_male" class="gt_row gt_right" style="background-color: #EBB69B; color: #000000;">8</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_female" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Biscoe stub_1_3 Chinstrap_male" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_female" class="gt_row gt_right" style="background-color: #C36144; color: #FFFFFF;">20</td>
<td headers="Island: Biscoe stub_1_3 Gentoo_male" class="gt_row gt_right" style="background-color: #C05A3E; color: #FFFFFF;">21</td></tr>
    <tr><th id="summary_stub_Island: Biscoe_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">7</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">7</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">19</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">20</td></tr>
    <tr><th id="summary_stub_Island: Biscoe_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">22</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">22</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">58</td>
<td headers="Island: Biscoe summary_stub_Island: Biscoe_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">61</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Dream">Island: Dream</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_4" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Dream stub_1_4 Adelie_female" class="gt_row gt_right" style="background-color: #E8AF93; color: #000000;">9</td>
<td headers="Island: Dream stub_1_4 Adelie_male" class="gt_row gt_right" style="background-color: #E5A88C; color: #000000;">10</td>
<td headers="Island: Dream stub_1_4 Chinstrap_female" class="gt_row gt_right" style="background-color: #DC9376; color: #000000;">13</td>
<td headers="Island: Dream stub_1_4 Chinstrap_male" class="gt_row gt_right" style="background-color: #DC9376; color: #000000;">13</td>
<td headers="Island: Dream stub_1_4 Gentoo_female" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Dream stub_1_4 Gentoo_male" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Dream stub_1_5 Adelie_female" class="gt_row gt_right" style="background-color: #EBB69B; color: #000000;">8</td>
<td headers="Island: Dream stub_1_5 Adelie_male" class="gt_row gt_right" style="background-color: #EBB69B; color: #000000;">8</td>
<td headers="Island: Dream stub_1_5 Chinstrap_female" class="gt_row gt_right" style="background-color: #E8AF93; color: #000000;">9</td>
<td headers="Island: Dream stub_1_5 Chinstrap_male" class="gt_row gt_right" style="background-color: #E8AF93; color: #000000;">9</td>
<td headers="Island: Dream stub_1_5 Gentoo_female" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Dream stub_1_5 Gentoo_male" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td></tr>
    <tr><th id="stub_1_6" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Dream stub_1_6 Adelie_female" class="gt_row gt_right" style="background-color: #E5A88C; color: #000000;">10</td>
<td headers="Island: Dream stub_1_6 Adelie_male" class="gt_row gt_right" style="background-color: #E5A88C; color: #000000;">10</td>
<td headers="Island: Dream stub_1_6 Chinstrap_female" class="gt_row gt_right" style="background-color: #DF9A7D; color: #000000;">12</td>
<td headers="Island: Dream stub_1_6 Chinstrap_male" class="gt_row gt_right" style="background-color: #DF9A7D; color: #000000;">12</td>
<td headers="Island: Dream stub_1_6 Gentoo_female" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Dream stub_1_6 Gentoo_male" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td></tr>
    <tr><th id="summary_stub_Island: Dream_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Dream summary_stub_Island: Dream_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">9</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">9</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">11</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">11</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Dream summary_stub_Island: Dream_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td></tr>
    <tr><th id="summary_stub_Island: Dream_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Dream summary_stub_Island: Dream_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">27</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">28</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">34</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">34</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Dream summary_stub_Island: Dream_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="7" class="gt_group_heading" scope="colgroup" id="Island: Torgersen">Island: Torgersen</th>
    </tr>
    <tr class="gt_row_group_first"><th id="stub_1_7" scope="row" class="gt_row gt_right gt_stub">2007</th>
<td headers="Island: Torgersen stub_1_7 Adelie_female" class="gt_row gt_right" style="background-color: #EBB69B; color: #000000;">8</td>
<td headers="Island: Torgersen stub_1_7 Adelie_male" class="gt_row gt_right" style="background-color: #EEBEA2; color: #000000;">7</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_female" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Torgersen stub_1_7 Chinstrap_male" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_female" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Torgersen stub_1_7 Gentoo_male" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td></tr>
    <tr><th id="stub_1_8" scope="row" class="gt_row gt_right gt_stub">2008</th>
<td headers="Island: Torgersen stub_1_8 Adelie_female" class="gt_row gt_right" style="background-color: #EBB69B; color: #000000;">8</td>
<td headers="Island: Torgersen stub_1_8 Adelie_male" class="gt_row gt_right" style="background-color: #EBB69B; color: #000000;">8</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_female" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Torgersen stub_1_8 Chinstrap_male" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_female" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Torgersen stub_1_8 Gentoo_male" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td></tr>
    <tr><th id="stub_1_9" scope="row" class="gt_row gt_right gt_stub">2009</th>
<td headers="Island: Torgersen stub_1_9 Adelie_female" class="gt_row gt_right" style="background-color: #EBB69B; color: #000000;">8</td>
<td headers="Island: Torgersen stub_1_9 Adelie_male" class="gt_row gt_right" style="background-color: #EBB69B; color: #000000;">8</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_female" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Torgersen stub_1_9 Chinstrap_male" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_female" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td>
<td headers="Island: Torgersen stub_1_9 Gentoo_male" class="gt_row gt_right" style="background-color: #FEF0D9; color: #000000;">-</td></tr>
    <tr><th id="summary_stub_Island: Torgersen_1" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_first_summary_row thick">Mean</th>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Adelie_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">8</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Adelie_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">8</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Gentoo_female" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_1 Gentoo_male" class="gt_row gt_right gt_summary_row gt_first_summary_row thick">-</td></tr>
    <tr><th id="summary_stub_Island: Torgersen_2" scope="row" class="gt_row gt_left gt_stub gt_summary_row gt_last_summary_row">Total</th>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Adelie_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">24</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Adelie_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">23</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Chinstrap_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Chinstrap_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Gentoo_female" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td>
<td headers="Island: Torgersen summary_stub_Island: Torgersen_2 Gentoo_male" class="gt_row gt_right gt_summary_row gt_last_summary_row">-</td></tr>
  </tbody>
  
  
</table>
</div>
```

### Data visualisations

In this chapter, we’re going to learn how to add fancy elements like plots, icon and images to `gt` tables. 


You can actually add any ggplot you want to your table. For example, we could look at our penguins from the last chapter again. Here’s a table about their weight and its distribution (visualized with a violin plot.)


```r
filtered_penguins <- palmerpenguins::penguins |>
    filter(!is.na(sex))

penguin_weights <- filtered_penguins |>
  group_by(species) |>
  summarise(
    Min = min(body_mass_g),
    Mean = mean(body_mass_g) |> round(digits = 2),
    Max = max(body_mass_g)
  ) |>
  mutate(species = as.character(species)) |>
  rename(Species = species)

penguin_weights |>
  gt() |>
  tab_spanner(
    label = 'Penguin\'s Weight',
    columns = -Species
  ) 
```

```{=html}
<div id="vzsegzgeag" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#vzsegzgeag table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#vzsegzgeag thead, #vzsegzgeag tbody, #vzsegzgeag tfoot, #vzsegzgeag tr, #vzsegzgeag td, #vzsegzgeag th {
  border-style: none;
}

#vzsegzgeag p {
  margin: 0;
  padding: 0;
}

#vzsegzgeag .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#vzsegzgeag .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#vzsegzgeag .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#vzsegzgeag .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#vzsegzgeag .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#vzsegzgeag .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#vzsegzgeag .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#vzsegzgeag .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#vzsegzgeag .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#vzsegzgeag .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#vzsegzgeag .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#vzsegzgeag .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#vzsegzgeag .gt_spanner_row {
  border-bottom-style: hidden;
}

#vzsegzgeag .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#vzsegzgeag .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#vzsegzgeag .gt_from_md > :first-child {
  margin-top: 0;
}

#vzsegzgeag .gt_from_md > :last-child {
  margin-bottom: 0;
}

#vzsegzgeag .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#vzsegzgeag .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#vzsegzgeag .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#vzsegzgeag .gt_row_group_first td {
  border-top-width: 2px;
}

#vzsegzgeag .gt_row_group_first th {
  border-top-width: 2px;
}

#vzsegzgeag .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#vzsegzgeag .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#vzsegzgeag .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#vzsegzgeag .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#vzsegzgeag .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#vzsegzgeag .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#vzsegzgeag .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#vzsegzgeag .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#vzsegzgeag .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#vzsegzgeag .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#vzsegzgeag .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#vzsegzgeag .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#vzsegzgeag .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#vzsegzgeag .gt_left {
  text-align: left;
}

#vzsegzgeag .gt_center {
  text-align: center;
}

#vzsegzgeag .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#vzsegzgeag .gt_font_normal {
  font-weight: normal;
}

#vzsegzgeag .gt_font_bold {
  font-weight: bold;
}

#vzsegzgeag .gt_font_italic {
  font-style: italic;
}

#vzsegzgeag .gt_super {
  font-size: 65%;
}

#vzsegzgeag .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#vzsegzgeag .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#vzsegzgeag .gt_indent_1 {
  text-indent: 5px;
}

#vzsegzgeag .gt_indent_2 {
  text-indent: 10px;
}

#vzsegzgeag .gt_indent_3 {
  text-indent: 15px;
}

#vzsegzgeag .gt_indent_4 {
  text-indent: 20px;
}

#vzsegzgeag .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Species">Species</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="3" scope="colgroup" id="Penguin's Weight">
        <span class="gt_column_spanner">Penguin's Weight</span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Min">Min</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean">Mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Max">Max</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="Species" class="gt_row gt_left">Adelie</td>
<td headers="Min" class="gt_row gt_right">2850</td>
<td headers="Mean" class="gt_row gt_right">3706.16</td>
<td headers="Max" class="gt_row gt_right">4775</td></tr>
    <tr><td headers="Species" class="gt_row gt_left">Chinstrap</td>
<td headers="Min" class="gt_row gt_right">2700</td>
<td headers="Mean" class="gt_row gt_right">3733.09</td>
<td headers="Max" class="gt_row gt_right">4800</td></tr>
    <tr><td headers="Species" class="gt_row gt_left">Gentoo</td>
<td headers="Min" class="gt_row gt_right">3950</td>
<td headers="Mean" class="gt_row gt_right">5092.44</td>
<td headers="Max" class="gt_row gt_right">6300</td></tr>
  </tbody>
  
  
</table>
</div>
```

To create this table, let us begin with the basics. Let’s compute the numeric values first.


```{=html}
<div id="vcvwvvyawo" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#vcvwvvyawo table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#vcvwvvyawo thead, #vcvwvvyawo tbody, #vcvwvvyawo tfoot, #vcvwvvyawo tr, #vcvwvvyawo td, #vcvwvvyawo th {
  border-style: none;
}

#vcvwvvyawo p {
  margin: 0;
  padding: 0;
}

#vcvwvvyawo .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#vcvwvvyawo .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#vcvwvvyawo .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#vcvwvvyawo .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#vcvwvvyawo .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#vcvwvvyawo .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#vcvwvvyawo .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#vcvwvvyawo .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#vcvwvvyawo .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#vcvwvvyawo .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#vcvwvvyawo .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#vcvwvvyawo .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#vcvwvvyawo .gt_spanner_row {
  border-bottom-style: hidden;
}

#vcvwvvyawo .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#vcvwvvyawo .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#vcvwvvyawo .gt_from_md > :first-child {
  margin-top: 0;
}

#vcvwvvyawo .gt_from_md > :last-child {
  margin-bottom: 0;
}

#vcvwvvyawo .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#vcvwvvyawo .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#vcvwvvyawo .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#vcvwvvyawo .gt_row_group_first td {
  border-top-width: 2px;
}

#vcvwvvyawo .gt_row_group_first th {
  border-top-width: 2px;
}

#vcvwvvyawo .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#vcvwvvyawo .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#vcvwvvyawo .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#vcvwvvyawo .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#vcvwvvyawo .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#vcvwvvyawo .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#vcvwvvyawo .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#vcvwvvyawo .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#vcvwvvyawo .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#vcvwvvyawo .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#vcvwvvyawo .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#vcvwvvyawo .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#vcvwvvyawo .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#vcvwvvyawo .gt_left {
  text-align: left;
}

#vcvwvvyawo .gt_center {
  text-align: center;
}

#vcvwvvyawo .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#vcvwvvyawo .gt_font_normal {
  font-weight: normal;
}

#vcvwvvyawo .gt_font_bold {
  font-weight: bold;
}

#vcvwvvyawo .gt_font_italic {
  font-style: italic;
}

#vcvwvvyawo .gt_super {
  font-size: 65%;
}

#vcvwvvyawo .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#vcvwvvyawo .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#vcvwvvyawo .gt_indent_1 {
  text-indent: 5px;
}

#vcvwvvyawo .gt_indent_2 {
  text-indent: 10px;
}

#vcvwvvyawo .gt_indent_3 {
  text-indent: 15px;
}

#vcvwvvyawo .gt_indent_4 {
  text-indent: 20px;
}

#vcvwvvyawo .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Species">Species</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="4" scope="colgroup" id="Penguin's Weight">
        <span class="gt_column_spanner">Penguin's Weight</span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Min">Min</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean">Mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Max">Max</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="Distribution">Distribution</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="Species" class="gt_row gt_left">Adelie</td>
<td headers="Min" class="gt_row gt_right">2850</td>
<td headers="Mean" class="gt_row gt_right">3706.16</td>
<td headers="Max" class="gt_row gt_right">4775</td>
<td headers="Distribution" class="gt_row gt_left"><img src="data:image/png;base64,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" style="height:50px;"></td></tr>
    <tr><td headers="Species" class="gt_row gt_left">Chinstrap</td>
<td headers="Min" class="gt_row gt_right">2700</td>
<td headers="Mean" class="gt_row gt_right">3733.09</td>
<td headers="Max" class="gt_row gt_right">4800</td>
<td headers="Distribution" class="gt_row gt_left"><img src="data:image/png;base64,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AAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAH8Pz+ganzjVgWLAAAAAElFTkSuQmCC" style="height:50px;"></td></tr>
    <tr><td headers="Species" class="gt_row gt_left">Gentoo</td>
<td headers="Min" class="gt_row gt_right">3950</td>
<td headers="Mean" class="gt_row gt_right">5092.44</td>
<td headers="Max" class="gt_row gt_right">6300</td>
<td headers="Distribution" class="gt_row gt_left"><img src="data:image/png;base64,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I5lIdIXqOsP1UjNUjwIAKOO2YkO6/+7NtB1/wgk/uO66/Px81YuA/oIoAwAAetPGjRt/9rOfv/vuOxl/WWtksukKq14EAFBPEzIvvqk4tiESicy54X+/8IUvqF4E9AtEGQAA0Dui0ei8efMef/xxx+VvDU2KB8qF4FpHAMC/eKxoWfff3JmO00477ZprrgmFQqoXAYoRZQAAwGflOM7TTz99+x13RqM93cGarkiDo7lUjwIA9EeadAri7xbE3i0pKbnpxjnTpk1TvQhQiSgDAAA+k02bNv3s5z9/5+23M77S1rzJpitP9SIAQH/nNTvLev7uMru/8pWvzJ492+/3q14EqEGUAQAAh+hf3ysZvtbwpHiggu+VAACfkiacwuiG/PjGYcOG/+THP5owYYLqRYACRBkAAHDQDryvdMedc2OxaHewpisy3tHcqkcBAAYen9k+tOdvhpW48Gtf++Y3v+nxeFQvAvoUUQYAABycd9555+c//8XGje9lfENaIk1ZN98rAQAOnSat4p51kcTmyqrqn/7kx2PHjlW9COg7RBkAAPBpdXZ23nXXXU8++aR0B1vDk+L+EXyvBADoFYHM/rKeNw07demll86aNcvl4sJ4DApEGQAA8Mls216yZMk998xLpdNdwbGd4TrJ+0oAgF6lO9nintXh5Lba2rE//vGPRo4cqXoRcNgRZQAAwCdYtWrVL375q+3btqb8w9oijVlXWPUiAEDOCqT2lEVXuUX2W9/61gUXXKDruupFwGFElAEAAB9p//79t91++0svvuh4Ii3hSUnfMNWLAAC5z3AyJT1vBZM7xzc0/OimmyoqKlQvAg4XogwAAPgQmUzm4Ycfnn///ZYt24P1PaEaqRmqRwEABpFQaueQ6Gq37lx91VVf+cpXODKDnESUAQAA/0ZK+fLLL//61tta9u+LByrbIxNtI6B6FABgMDKcdGn3m4HUnsampptuvHHYMA5sItcQZQAAwL9s3br15ptvfvPNN7Oegta8prSnRPUiAMAgJ8OpHUOiazyG9t3vfuess87SNB7+Q+4gygAAACGEiEaj991336JFi6XhaQ81RIMjJc9dAwD6B8NODul+05/eN3Xq1BtuuGHo0KGqFwG9gygDAMBg5zjO0qVL5951dywW7QmO6QyPd3SP6lEAAPwHGUluK4mu9bmNa6+95stf/jJHZpAD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" style="height:50px;"></td></tr>
  </tbody>
  
  
</table>
</div>
```


Next write a function `plot_violin_species(my_species)` that depends on a penguin species and creates one violin plot.

<button id="displayTextunnamed-chunk-91" onclick="javascript:toggle('unnamed-chunk-91');">Show Solution</button>

<div id="toggleTextunnamed-chunk-91" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
plot_density_species <- function(my_species) {
  full_range <- filtered_penguins |>
    pull(body_mass_g) |>
    range()

  filtered_penguins |>
    filter(species == my_species) |>
    ggplot(aes(x = body_mass_g, y = species)) +
    geom_violin(fill = 'dodgerblue4') +
    theme_minimal() +
    scale_y_discrete(breaks = NULL) +
    scale_x_continuous(breaks = NULL) +
    labs(x = element_blank(), y = element_blank()) +
    coord_cartesian(xlim = full_range)
}
plot_density_species("Adelie")
```

<img src="012-ggplot-principles_files/figure-html/unnamed-chunk-94-1.png" width="100%" style="display: block; margin: auto;" />
</div></div></div>

Notice that I have set the coordinate system of the plot to the full range of the data (regardless of the species). This part is important. Without this trick, the three plots would not share a common x-axis. 

Ok, so now we have a function that creates the desired plots. Time to apply it to our table. For this to work, we need an additional column that we can target. So we use `mutate()` to add a new column, then `text_transform()` to turn this column into images, and finally `.fn` argument can be supplied with our function iterated over each species with   `map()`.


```r
penguin_weights |>
  mutate(Distribution = Species) |> 
  gt() |>
  tab_spanner(
    label = 'Penguin\'s Weight',
    columns = -Species
  ) |>
  text_transform(
    locations = cells_body(columns = 'Distribution'),
    fn = function(column) {
      map(column, plot_density_species) |>
        ggplot_image(height = px(50), aspect_ratio = 3)
    }
  ) 
```

```{=html}
<div id="cdauoccayr" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#cdauoccayr table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#cdauoccayr thead, #cdauoccayr tbody, #cdauoccayr tfoot, #cdauoccayr tr, #cdauoccayr td, #cdauoccayr th {
  border-style: none;
}

#cdauoccayr p {
  margin: 0;
  padding: 0;
}

#cdauoccayr .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#cdauoccayr .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#cdauoccayr .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#cdauoccayr .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#cdauoccayr .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#cdauoccayr .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cdauoccayr .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#cdauoccayr .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#cdauoccayr .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#cdauoccayr .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#cdauoccayr .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#cdauoccayr .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#cdauoccayr .gt_spanner_row {
  border-bottom-style: hidden;
}

#cdauoccayr .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#cdauoccayr .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#cdauoccayr .gt_from_md > :first-child {
  margin-top: 0;
}

#cdauoccayr .gt_from_md > :last-child {
  margin-bottom: 0;
}

#cdauoccayr .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#cdauoccayr .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#cdauoccayr .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#cdauoccayr .gt_row_group_first td {
  border-top-width: 2px;
}

#cdauoccayr .gt_row_group_first th {
  border-top-width: 2px;
}

#cdauoccayr .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#cdauoccayr .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#cdauoccayr .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#cdauoccayr .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cdauoccayr .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#cdauoccayr .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#cdauoccayr .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#cdauoccayr .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#cdauoccayr .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cdauoccayr .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#cdauoccayr .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#cdauoccayr .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#cdauoccayr .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#cdauoccayr .gt_left {
  text-align: left;
}

#cdauoccayr .gt_center {
  text-align: center;
}

#cdauoccayr .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#cdauoccayr .gt_font_normal {
  font-weight: normal;
}

#cdauoccayr .gt_font_bold {
  font-weight: bold;
}

#cdauoccayr .gt_font_italic {
  font-style: italic;
}

#cdauoccayr .gt_super {
  font-size: 65%;
}

#cdauoccayr .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#cdauoccayr .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#cdauoccayr .gt_indent_1 {
  text-indent: 5px;
}

#cdauoccayr .gt_indent_2 {
  text-indent: 10px;
}

#cdauoccayr .gt_indent_3 {
  text-indent: 15px;
}

#cdauoccayr .gt_indent_4 {
  text-indent: 20px;
}

#cdauoccayr .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Species">Species</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="4" scope="colgroup" id="Penguin's Weight">
        <span class="gt_column_spanner">Penguin's Weight</span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Min">Min</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean">Mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Max">Max</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="Distribution">Distribution</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="Species" class="gt_row gt_left">Adelie</td>
<td headers="Min" class="gt_row gt_right">2850</td>
<td headers="Mean" class="gt_row gt_right">3706.16</td>
<td headers="Max" class="gt_row gt_right">4775</td>
<td headers="Distribution" class="gt_row gt_left"><img src="data:image/png;base64,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" style="height:50px;"></td></tr>
    <tr><td headers="Species" class="gt_row gt_left">Chinstrap</td>
<td headers="Min" class="gt_row gt_right">2700</td>
<td headers="Mean" class="gt_row gt_right">3733.09</td>
<td headers="Max" class="gt_row gt_right">4800</td>
<td headers="Distribution" class="gt_row gt_left"><img src="data:image/png;base64,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AAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAGIMgAAAAABiDIAAAAAAYgyAAAAAAH8Pz+ganzjVgWLAAAAAElFTkSuQmCC" style="height:50px;"></td></tr>
    <tr><td headers="Species" class="gt_row gt_left">Gentoo</td>
<td headers="Min" class="gt_row gt_right">3950</td>
<td headers="Mean" class="gt_row gt_right">5092.44</td>
<td headers="Max" class="gt_row gt_right">6300</td>
<td headers="Distribution" class="gt_row gt_left"><img src="data:image/png;base64,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I5lIdIXqOsP1UjNUjwIAKOO2YkO6/+7NtB1/wgk/uO66/Px81YuA/oIoAwAAetPGjRt/9rOfv/vuOxl/WWtksukKq14EAFBPEzIvvqk4tiESicy54X+/8IUvqF4E9AtEGQAA0Dui0ei8efMef/xxx+VvDU2KB8qF4FpHAMC/eKxoWfff3JmO00477ZprrgmFQqoXAYoRZQAAwGflOM7TTz99+x13RqM93cGarkiDo7lUjwIA9EeadAri7xbE3i0pKbnpxjnTpk1TvQhQiSgDAAA+k02bNv3s5z9/5+23M77S1rzJpitP9SIAQH/nNTvLev7uMru/8pWvzJ492+/3q14EqEGUAQAAh+hf3ysZvtbwpHiggu+VAACfkiacwuiG/PjGYcOG/+THP5owYYLqRYACRBkAAHDQDryvdMedc2OxaHewpisy3tHcqkcBAAYen9k+tOdvhpW48Gtf++Y3v+nxeFQvAvoUUQYAABycd9555+c//8XGje9lfENaIk1ZN98rAQAOnSat4p51kcTmyqrqn/7kx2PHjlW9COg7RBkAAPBpdXZ23nXXXU8++aR0B1vDk+L+EXyvBADoFYHM/rKeNw07demll86aNcvl4sJ4DApEGQAA8Mls216yZMk998xLpdNdwbGd4TrJ+0oAgF6lO9nintXh5Lba2rE//vGPRo4cqXoRcNgRZQAAwCdYtWrVL375q+3btqb8w9oijVlXWPUiAEDOCqT2lEVXuUX2W9/61gUXXKDruupFwGFElAEAAB9p//79t91++0svvuh4Ii3hSUnfMNWLAAC5z3AyJT1vBZM7xzc0/OimmyoqKlQvAg4XogwAAPgQmUzm4Ycfnn///ZYt24P1PaEaqRmqRwEABpFQaueQ6Gq37lx91VVf+cpXODKDnESUAQAA/0ZK+fLLL//61tta9u+LByrbIxNtI6B6FABgMDKcdGn3m4HUnsampptuvHHYMA5sItcQZQAAwL9s3br15ptvfvPNN7Oegta8prSnRPUiAMAgJ8OpHUOiazyG9t3vfuess87SNB7+Q+4gygAAACGEiEaj991336JFi6XhaQ81RIMjJc9dAwD6B8NODul+05/eN3Xq1BtuuGHo0KGqFwG9gygDAMBg5zjO0qVL5951dywW7QmO6QyPd3SP6lEAAPwHGUluK4mu9bmNa6+95stf/jJHZpAD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" style="height:50px;"></td></tr>
  </tbody>
  
  
</table>
</div>
```

## Conclusion

Many of the tweaks we made to our table are quite subtle. Changes like removing excess gridlines, bolding header text, right-aligning numeric values, and adjusting the level of precision can often go unnoticed, but if you skip them, your table will be far less effective. Our final product isn’t flashy, but it does communicate clearly.

We used the gt package to make our high-quality table, and as we’ve repeatedly seen, this package has good defaults built in. Often, you don’t need to change much in your code to make effective tables. But no matter which package you use, it’s essential to treat tables as worthy of just as much thought as other kinds of data visualization.

Later you’ll learn how to create reports using R Markdown, which can integrate your tables directly into the final document.

## Reading

Consult the following resources to learn about table design principles and how to make high-quality tables with the gt package:

["gt package intro"](https://gt.rstudio.com/articles/gt.html)

“Ten Guidelines for Better Tables” by Jon Schwabish (Journal of Benefit-Cost Analysis, 2020), https://doi.org/10.1017/bca.2020.11

“10+ Guidelines for Better Tables in R” by Tom Mock (2020), https://themockup.blog/posts/2020-09-04-10-table-rules-in-r/



