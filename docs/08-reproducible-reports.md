# (PART\*) Literate Programming and Reproducibility {.unnumbered}

# Quarto






<img src="images/rmarkdownoutputformats.png" width="100%" style="display: block; margin: auto;" />


Quarto is a new and improved version of RMarkdown that makes working with different formats and programming languages easier. If you have ever used RMarkdown, the transition is easy.

One of the main benefits of Quarto is that it uses a consistent set of rules across all types of output. In R Markdown, the way you format documents can change depending on what you are creating. For example, when making slides in R Markdown, the "xaringan" package uses three dashes to create new slides, but in other formats, three dashes create a horizontal line instead. Similarly, the "distill" package has its own unique layout options that don’t work with "xaringan." Quarto simplifies this by providing one standard way to format all types of documents.

Quarto also supports more programming languages than R Markdown and works with different code editors. While R Markdown is mainly designed to be used in the RStudio program, Quarto can be used not only in RStudio but also in other popular code editors, like Visual Studio (VS) Code and JupyterLab. This makes it easier for people to use Quarto with different languages and tools.

This chapter will show you the benefits of using Quarto if you are an R user. It will guide you on how to set up Quarto, explain the key differences between Quarto and R Markdown, and teach you how to use Quarto to create reports, presentations, and websites.

## Background

Quarto is a widely-used tool for creating automated, reproducible, and share-worthy outputs, such as reports. It can generate static or interactive outputs, in Word, pdf, html, Powerpoint slides, and many other formats.

A Quarto file combines R code (or other programming code) and text such that the script actually becomes your output document. You can create an entire formatted document, including narrative text (can be dynamic to change based on your data), tables, figures, bullets/numbers, bibliographies, etc.

Documents produced with Quarto, allow analyses to be included easily - and make the link between raw data, analysis & and a published report *completely reproducible*.

With Quarto we can make reproducible html, word, pdf, powerpoints or websites and dashboards^[(https://quarto.org/docs/gallery/)]



## How it works {-}


Starting from version 2022.07.1, RStudio comes with Quarto already installed.

To check which version of RStudio you have, go to the top menu and click on RStudio > About RStudio. If your version is older than 2022.07.1, you should update it by reinstalling RStudio. Instructions for updating RStudio can be found in Chapter 1. After updating, Quarto should be automatically installed.

Once Quarto is installed, you can create a new document by clicking **File > New File > Quarto Document**. This will bring up a menu similar to the one used to create an R Markdown document

Choose a title, author, as well as your default output format (HTML, PDF, or Word). These values can be changed later. Click OK, and RStudio will create a Quarto document with some placeholder content. 

<img src="images/quarto.png" width="80%" style="display: block; margin: auto;" />

This document contains several sections, each of which we will discuss below. First, though, let’s skip to the finish line by doing what’s called *rendering* our document. The **Render** button at the top of RStudio converts the Quarto document into whatever format we selected.

**To make your document publish - hit the render button at the top of the doc**



## Quarto parts {-}

As you can see, there are three basic components to any Quarto file: 

* YAML

* Markdown text

* R code chunks.


### YAML Metadata {-}

The YAML section is the very beginning of an R Markdown document. The name YAML comes from the recursive acronym YAML ain’t markup language, whose meaning isn’t important for our purposes. Three dashes indicate its beginning and end, and the text inside of it contains metadata about the R Markdown document. Here is my YAML:

````

---
title: "My Report"
output: html_document
---


````

As you can see, it provides the title, author, and output format. All elements of the YAML are given in `key: value` syntax, where each key is a label for a piece of metadata (for example, the title) followed by a value in quotes.

In the example above, because we clicked that our default output would be an html file, we can see that the YAML says output: `html`. However we can also change this to say `pptx` or `docx` or even `pdf_document`. (https://quarto.org/docs/output-formats/all-formats.html)

<div class="try">
<p>Can you edit the YAML in the Rmarkdown file in the markdown folder to
have your name as author? Try changing the output to a different file
type.</p>
</div>

### Code chunks {-}

Quarto documents have a different structure from the R script files you might be familiar with (those with the .R extension). R script files treat all content as code unless you comment out a line by putting a pound sign (#) in front of it. In the following code, the first line is a comment while the second line is code.

````

```{r}
# Import our data
data <- read_csv("data.csv")
```

````

In Quarto, the situation is reversed. Everything after the YAML is treated as text unless we specify otherwise by creating what are known as code chunks. Each chunk is opened with a line that starts with three back-ticks, and curly brackets that contain parameters for the chunk \{ \}. The chunk ends with three more back-ticks.

````md

```{r}
library(tidyverse)
```

````

Quarto treats anything in the code chunk as R code when we knit. For example, this code chunk will produce a histogram in the final document.


````md

```{r}

hist(cars$speed)
```

````


<div class="info">
<p>Some notes about the contents of the curly brackets { }:</p>
<p>They start with ‘r’ to indicate that the language name within this
chunk is <strong>R</strong>. It is possible to include other programming
language chunks here such as <strong>SQL</strong>,
<strong>Python</strong> or <strong>Bash</strong>.</p>
<p>After the r you can optionally write a chunk “name” – these are not
necessary but can help you organise your work. Note that if you name
your chunks, you should ALWAYS use unique names or else R will
<em>complain</em> when you try to render.</p>
<p>After the language name and optional chunk name put a comma, then you
can include other options too, written as <code>tag=value</code>, such
as:</p>
<ul>
<li><p>eval: false to not run the R code</p></li>
<li><p>echo: false to not print the chunk’s R source code in the output
document</p></li>
<li><p>warning: false to not print warnings produced by the R
code</p></li>
<li><p>message: false to not print any messages produced by the R
code</p></li>
<li><p>include: true/false whether to include chunk outputs (e.g. plots)
in the document</p></li>
<li><p>out-width and out-height = size of output in final document
e.g. out-width = “75%”</p></li>
<li><p>fig-width and fig-height: relative size of figure</p></li>
<li><p>fig-align = “center” adjust how a figure is aligned across the
page</p></li>
<li><p>fig-show=‘hold’ if your chunk prints multiple figures and you
want them printed next to each other (pair with out-width = c(“33%”,
“67%”).</p></li>
</ul>
</div>


**Question.** If we wanted to see the R code, but **not** its output we need to select what combo of code chunk options? <select class='webex-select'><option value='blank'></option><option value=''>echo = TRUE, eval = TRUE</option><option value=''>echo = FALSE, eval = FALSE</option><option value=''>echo = FALSE, eval = TRUE</option><option value='answer'>echo = TRUE, eval = FALSE</option></select>

Default options for showing code, charts, and other elements in the rendered versions of the document. In Quarto, these options are set in the execute field of the YAML. For example, the following would provide the outputs of code, but hide the code itself, as well as all warnings and messages, from the rendered document:

````
---
title: "My Report"
format: html
execute:
  echo: false
  warning: false
  message: false
---
````

In cases where you’re using Quarto to generate a report for a non-R user, you likely want to follow this setup of hiding the code, messages, and warnings but show the output (which would include any visualizations you generate). 

 **However, you can also override these global code chunk options on individual chunks**. If I wanted my document to show both the plot itself and the code used to make it, I could set `echo = TRUE` for that code chunk only:

````md

```{r}
#| echo = TRUE
hist(cars$speed)
```

````

The option is set within the code chunk itself. The characters #| (known as a hash pipe) at the start of a line indicate that you are setting options.

### Text {-}

This is the narrative of your document, including the titles and headings. It is written in the “markdown” language, which is used across many different software.

Below are the core ways to write this text. See more extensive documentation available on R Markdown “cheatsheets” at the RStudio website^[(https://www.rstudio.com/resources/cheatsheets/)].

#### New lines {-}

Uniquely in R Markdown, to initiate a new line, enter *two spaces** at the end of the previous line and then Enter/Return.

#### Text emphasis {-}

Surround your normal text with these characters to change how it appears in the output.

Underscores (\_text\_) or single asterisk (\*text\*) to *italicise*

Double asterisks (\*\*text\*\*) for **bold** text

Back-ticks  (\` text \`) to display text as `code`

The actual appearance of the font can be set by using specific templates (specified in the YAML metadata).

#### Titles and headings {-}

A hash symbol in a text portion of a R Markdown script creates a heading. This is different than in a chunk of R code in the script, in which a hash symbol is a mechanism to comment/annotate/de-activate, as in a normal R script.

Different heading levels are established with different numbers of hash symbols at the start of a new line. One hash symbol is a title or primary heading. Two hash symbols are a second-level heading. Third- and fourth-level headings can be made with successively more hash symbols.


```

# First-level heading / Title

## Second level heading  

### Third-level heading

```

#### Bullets and numbering {-}

Use asterisks (*) to created a bullets list. Finish the previous sentence, enter two spaces, Enter/Return twice, and then start your bullets. Include a space between the asterisk and your bullet text. After each bullet enter two spaces and then Enter/Return. Sub-bullets work the same way but are indented. Numbers work the same way but instead of an asterisk, write 1), 2), etc. Below is how your R Markdown script text might look.

Here are my bullets (there are two spaces after this colon):  

```
* Bullet 1 (followed by two spaces and Enter/Return)  
* Bullet 2 (followed by two spaces and Enter/Return)  
  * Sub-bullet 1 (followed by two spaces and Enter/Return)  
  * Sub-bullet 2 (followed by two spaces and Enter/Return)  
```

### In-text code {-}

You can also include minimal R code within back-ticks. Within the back-ticks, begin the code with “r” and a space, so RStudio knows to evaluate the code as R code. See the example below.

This book was printed on `` `r Sys.Date()` ``

When typed in-line within a section of what would otherwise be Markdown text, it knows to produce an r output instead: 

This book was printed on 2024-09-17

### Running code {-}

You can run the code in an R Markdown document in two ways. The first way is by rendering the entire document. The second way is to run code chunks manually (also known as interactively) by hitting the little green play button at the top-right of a code chunk. The down arrow next to the green play button will run all code until that point.

The one downside to running code interactively is that you can sometimes make mistakes that cause your Quarto document to fail to knit. That is because, in order to render, a Quarto document must *contain* all the code it uses. If you are working interactively and, say, load data from a separate file, you will be unable to knit your document. When working in R Markdown, always keep all code within a single document.

The code must also always appear in the right order. 



## Self contained Reports

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 

Generate a self-contained report from data
 </div></div>

For a relatively simple report, you may elect to organize your R Markdown script such that it is “self-contained” and does not involve any external scripts.

**Set up your Rmd file to 'read' the penguins data file.**

Everything you need to run the R markdown is imported or created within the Rmd file, including all the code chunks and package loading. This “self-contained” approach is appropriate when you do not need to do much data processing (e.g. it brings in a clean or semi-clean data file) and the rendering of the R Markdown will not take too long.

In this scenario, one logical organization of the R Markdown script might be:

* Set global knitr options

* Load packages

* Import data

* Process data

* Produce outputs (tables, plots, etc.)

* Save outputs, *if applicable* (.csv, .png, etc.)


## Exercise

Delete this content and replace it with your own. As an example, let’s create a report about penguins. Add the following content to a Quarto doc:

````md
---
title: "Penguins Report"
author: "Phil"
output: html
execute:
  echo: false
  warning: false
  message: false
---

```{r}

library(tidyverse)

```

```{r}

penguins_raw <- read_csv("https://raw.githubusercontent.com/UEABIO/data-sci-v1/main/book/files/penguins_raw.csv")

```

# Introduction

We are writing a report about the **Palmer Penguins**. These penguins are *really* amazing. There are three species:

- Adelie
- Gentoo
- Chinstrap

## Bill Length

We can make a histogram to see the distribution of bill lengths.

```{r}
penguins_raw |> 
  ggplot(aes(x = `Culmen Length (mm)`)) +
  geom_histogram() +
  theme_minimal()
```

```{r}
average_bill_length <- penguins_raw |> 
  summarize(avg_bill_length = mean(`Culmen Length (mm)`,
                                   na.rm = TRUE)) |> 
  pull(average_bill_length)
```

The chart shows the distribution of bill lengths. The average bill length is `` `r average_bill_length` ``.

````


## ggplot {-}

### Size options for figures {-}


- `fig.width` and `fig.height` enable to set width and height of R produced figures.
The default value is set to **7 (inches)**. When I play with these options, I prefer using only one of them (`fig.width`).

- `fig.asp` sets the *height-to-width* ratio of the figure. It’s easier in my mind to play with this ratio than to give a width and a height separately. The default value of fig.asp is NULL but I often set it to `(0.8)`, which often corresponds to the expected result.

Size options of figures produced by R have consequences on relative sizes of elements in this figures. For a `ggplot2` figure, these elements will remain to the size defined in the used theme, whatever the chosen size of the figure. Therefore a huge size can lead to a very small text and vice versa.


<div class="info">
<p>The base font size is 11 pts by default. You can change it with the
<code>base_size</code> argument in the theme you’re using.</p>
</div>





```r
penguin_colours <- c("darkolivegreen4", "darkorchid3", "goldenrod1")

plot <- penguins_raw |> 
  ggplot(aes(x=`Flipper Length (mm)`, 
             y = `Body Mass (g)`))+
  geom_point(aes(colour=`Species`))+
  scale_color_manual(values=penguin_colours)+
  theme_minimal(base_size = 11)
```


````md
```{r fig.asp = 0.8, fig.width = 3}
plot
# figure elements are too big
```
````
<img src="08-reproducible-reports_files/figure-html/unnamed-chunk-11-1.png" width="100%" style="display: block; margin: auto;" />

````md
```{r fig.asp = 0.8, fig.width = 10}
plot
# figure elements are too small
```
````

<img src="08-reproducible-reports_files/figure-html/unnamed-chunk-12-1.png" width="100%" style="display: block; margin: auto;" />

To find the result you like, you’ll need to combine sizes set in your theme and set in the chunk options. With my customised theme, the default size (`7`) looks good to me.

````md
```{r fig.asp = 0.8, fig.width = 7}
plot
```
````

<img src="08-reproducible-reports_files/figure-html/unnamed-chunk-13-1.png" width="100%" style="display: block; margin: auto;" />

When texts axis are longer or when figures is overloaded, you can choose bigger size (8 or 9) to relatively reduce the figure elements. it’s worth noting that for the text sizes, you can also modify the base size in your theme to obtain similar figures.

````md
```{r fig.asp = 0.8, fig.width = 7}
plot + theme(base_size = 14)
# figure width stays the same, but modify the text size in ggplot
```
````

<img src="08-reproducible-reports_files/figure-html/unnamed-chunk-14-1.png" width="100%" style="display: block; margin: auto;" />


### Size of final figure in document {-}

With the previous examples, you could see the relative size of the elements within the figures was changed - but the area occupied by the figures remained the same. In order to change this I need `out.width` or `out.height`

Figures made with R in a R Markdown document are exported (by default in png format) and then inserted into the final rendered document. Options `out.width` and `out.height` enable us to choose the size of the figure in the final document.

It is rare I need to re-scale height-to-width ratio after the figures were produced with R and this ratio is kept if you modify only one option therefore I only use `out.width`. i like to use percentage to define the size of output figures. For example hre with a size set to 50%

````md
```{r fig.asp = 0.8, fig.width = 7, out.width = "50%"}
plot 
# The final rendered size of the image changes according to out.width
```
````

<img src="08-reproducible-reports_files/figure-html/unnamed-chunk-15-1.png" width="50%" style="display: block; margin: auto;" />


## Static images {-}

You can include images in your R Markdown:

````md
```{r setup, include=FALSE}
knitr::include_graphics("path/to/image.png")
```
````

## Tables {-}

### Markdown tables {-}

```
| Syntax      | Description |
| ----------- | ----------- |
| Header      | Title       |
| Paragraph   | Text        |

```

Which will render as this

| Syntax      | Description |
| ----------- | ----------- |
| Header      | Title       |
| Paragraph   | Text        |


### gt() {-}

The `gt` @R-gt package is all about making it simple to produce nice-looking display tables. [It has a lot of customisation options.](https://gt.rstudio.com/index.html) 


```r
penguins_raw |>  
    group_by(`Species`) |>  
    summarise(`Body Mass (g)`= mean(`Body Mass (g)`, na.rm = T),
              `Flipper Length (mm)`= mean(`Flipper Length (mm)`, na.rm = T)) |>  
  gt::gt()
```

```{=html}
<div id="zmzsdfsuvy" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#zmzsdfsuvy table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#zmzsdfsuvy thead, #zmzsdfsuvy tbody, #zmzsdfsuvy tfoot, #zmzsdfsuvy tr, #zmzsdfsuvy td, #zmzsdfsuvy th {
  border-style: none;
}

#zmzsdfsuvy p {
  margin: 0;
  padding: 0;
}

#zmzsdfsuvy .gt_table {
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

#zmzsdfsuvy .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#zmzsdfsuvy .gt_title {
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

#zmzsdfsuvy .gt_subtitle {
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

#zmzsdfsuvy .gt_heading {
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

#zmzsdfsuvy .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zmzsdfsuvy .gt_col_headings {
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

#zmzsdfsuvy .gt_col_heading {
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

#zmzsdfsuvy .gt_column_spanner_outer {
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

#zmzsdfsuvy .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#zmzsdfsuvy .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#zmzsdfsuvy .gt_column_spanner {
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

#zmzsdfsuvy .gt_spanner_row {
  border-bottom-style: hidden;
}

#zmzsdfsuvy .gt_group_heading {
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

#zmzsdfsuvy .gt_empty_group_heading {
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

#zmzsdfsuvy .gt_from_md > :first-child {
  margin-top: 0;
}

#zmzsdfsuvy .gt_from_md > :last-child {
  margin-bottom: 0;
}

#zmzsdfsuvy .gt_row {
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

#zmzsdfsuvy .gt_stub {
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

#zmzsdfsuvy .gt_stub_row_group {
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

#zmzsdfsuvy .gt_row_group_first td {
  border-top-width: 2px;
}

#zmzsdfsuvy .gt_row_group_first th {
  border-top-width: 2px;
}

#zmzsdfsuvy .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#zmzsdfsuvy .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#zmzsdfsuvy .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#zmzsdfsuvy .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zmzsdfsuvy .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#zmzsdfsuvy .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#zmzsdfsuvy .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#zmzsdfsuvy .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#zmzsdfsuvy .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zmzsdfsuvy .gt_footnotes {
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

#zmzsdfsuvy .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#zmzsdfsuvy .gt_sourcenotes {
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

#zmzsdfsuvy .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#zmzsdfsuvy .gt_left {
  text-align: left;
}

#zmzsdfsuvy .gt_center {
  text-align: center;
}

#zmzsdfsuvy .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#zmzsdfsuvy .gt_font_normal {
  font-weight: normal;
}

#zmzsdfsuvy .gt_font_bold {
  font-weight: bold;
}

#zmzsdfsuvy .gt_font_italic {
  font-style: italic;
}

#zmzsdfsuvy .gt_super {
  font-size: 65%;
}

#zmzsdfsuvy .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#zmzsdfsuvy .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#zmzsdfsuvy .gt_indent_1 {
  text-indent: 5px;
}

#zmzsdfsuvy .gt_indent_2 {
  text-indent: 10px;
}

#zmzsdfsuvy .gt_indent_3 {
  text-indent: 15px;
}

#zmzsdfsuvy .gt_indent_4 {
  text-indent: 20px;
}

#zmzsdfsuvy .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="Species">Species</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Body Mass (g)">Body Mass (g)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Flipper Length (mm)">Flipper Length (mm)</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="Species" class="gt_row gt_left">Adelie Penguin (Pygoscelis adeliae)</td>
<td headers="Body Mass (g)" class="gt_row gt_right">3700.662</td>
<td headers="Flipper Length (mm)" class="gt_row gt_right">189.9536</td></tr>
    <tr><td headers="Species" class="gt_row gt_left">Chinstrap penguin (Pygoscelis antarctica)</td>
<td headers="Body Mass (g)" class="gt_row gt_right">3733.088</td>
<td headers="Flipper Length (mm)" class="gt_row gt_right">195.8235</td></tr>
    <tr><td headers="Species" class="gt_row gt_left">Gentoo penguin (Pygoscelis papua)</td>
<td headers="Body Mass (g)" class="gt_row gt_right">5076.016</td>
<td headers="Flipper Length (mm)" class="gt_row gt_right">217.1870</td></tr>
  </tbody>
  
  
</table>
</div>
```

<div class="try">
<p>You won’t be able to see these tables unless you try re-rendering
your .qmd file.</p>
</div>



## Source files {-}

One variation of the “self-contained” approach is to have Quarto “source” (run) other R scripts. 

This can make your Quarto file less cluttered, simpler, and easier to organize. It can also help if you want to display final figures at the beginning of the report. 

In this approach, the final Quarto doc simply combines pre-processed outputs into a document. We already used the `source()` function to feed R objects from one script to another, now we can do the same thing to our report. 

The advantage is all the data cleaning and organising happens "elsewhere" and we don't need to repeat our code. If you make any changes in your analysis scripts, these will be reflected by changes in your report the next time you compile (knit) it. 

```
source("scripts/your-script.R")
```

## Activity: Connecting scripts and reports {-}

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 

Create a separate R script for data import and quick cleaning save this and then source this into a new .qmd file.
 </div></div>

* Create a **new** Quarto doc.

* Create a new .R file

* Save this (without changes) to the same folder as your `.Rproj` file and call it `linked_report_penguins.Rmd`.

<div class="try">
<p>We will now source pre-written scripts for data loading and wrangling
in your R project, just use the source command to read in this script -
then you can call objects made externally - in this case a penguin plot
- put the code block in and hit knit.</p>
</div>


````md
```{r read-data}
#|include: false
# READ DATA ----

source("scripts/penguins.R")

```
`````

### Useful tips {-}
 
<div class="info">
<p>The working directory for .qmd files is a little different to working
with scripts.</p>
<p>With a .qmd file, the <strong>working directory is wherever the qmd
file itself is saved</strong>.</p>
<p>For example if you have your .qmd file in a subfolder
~/outputfiles/markdown.qmd the code for read_csv(“data/data.csv”) within
the markdown will look for a <code>.csv</code> file in a subfolder
called data <em>inside</em> the ‘markdown’ folder and not the root
project folder where the <code>.RProj</code> file lives.</p>
<p>So we have two options when using .qmd files</p>
<ol style="list-style-type: decimal">
<li><p>Don’t put the .qmd file in a subfolder and make sure it lives in
the same directory as your .RProj file - that way relative filepaths are
the same between R scripts and quarto files</p></li>
<li><p>Use the <code>here</code> package to describe file locations -
more later</p></li>
</ol>
</div>



### Heuristic file paths with `here()` {-}

The package `here` @R-here and its function `here()` (`here::here()`), make it easy to tell R where to find and to save your files - in essence, it builds file paths. It becomes especially useful for dealing with the alternate filepaths generated by .Rmd files, but can be used for exporting/importing any scripts, functions or data. 

This is how `here()` works within an R project:

- When the `here` package is first loaded within the R project, it places a small file called “.here” in the root folder of your R project as a “benchmark” or “anchor”

- In your scripts, to reference a file in the R project’s sub-folders, you use the function `here()` to build the file path in relation to that anchor

- To build the file path, write the names of folders beyond the root, within quotes, separated by commas, finally ending with the file name and file extension as shown below

- `here()` file paths can be used for both importing and exporting

So when you use `here()` wrapped inside other functions for importing/exporting (like `read_csv()` or `ggsave()`) if you include `here()` you can still use the RProject location as the root directory when rendering Quarto files, even if your markdown is tidied away into a **separate sub-folder**.

This means your previous relative filepaths should be replaced with:


````md
```{r, include=FALSE}
# PACKAGES ----
library(tidyverse)
library(here)

```
````

````md
```{r}
#| include: false
# READ DATA ----

penguins <- read_csv(here("data", "penguins_raw.csv"))

head(penguins)

```
````


<div class="warning">
<p>You might want start using the <code>here()</code> from now on to
read in and export data from scripts. Make sure you are consistent in
whether you use <code>here()</code> heuristic file paths or relative
file paths across <strong>all .R and .Rmd files in a project</strong> -
otherwise you might encounter errors.</p>
</div>



## Activity: Test yourself {-}

* Make any summary figure you want from the penguins (or any other) data with `ggplot`

* Make a summary table with `summarise` and make it beautiful with `gt()`

* Write a few sentences explaining what you are presenting

* Knit the report to **html**

* Use chunk options to optimise your figure layout and text and make it so that raw code and rendered outputs are visible. An example of literate programming

### Hygiene tips {-}

I recommend having three chunks at the top of any document

* Global chunk options

* All packages

* Reading data

````md

```{r setup , include=FALSE}
knitr::opts_chunk$set(echo = TRUE, 
                      fig.align = "center",
                      fig.width = 6,
                      fig.asp = 0.8,
                      out.width = "80%
                      )
                      
```

```{r library}
library(tidyverse)
```

```{r read-data}
source("scripts/02_visualisation_penguins.R")
```

````

## Common knit issues {-}

Any of these issues will cause the Rmd document to fail to knit in its entirety. A failed knit is usually an easy fix, but needs you to READ the error message, and do a little detective work. 

### Duplication {-}

````md

```{r title-one}
```

```{r title-one}
```

````

### Not the right order {-}

```
plot(my_table)

my_table <- table(mtcars$cyl)
```

### Forgotten trails {-}

: Missing “,”, or “(”, “}”, or “’”


### Path not taken {-}

The Rmd document is in a different location the .Rproj file causing issues with relative filepaths

### Spolling {-}

* Incorrectly labelled chunk options

* Incorrectly evaluated R code


## Visual editor {-}

RStudio comes with a pretty nifty [Visual Markdown Editor](https://www.rstudio.com/blog/exploring-rstudio-visual-markdown-editor/) which includes:

* Spellcheck

* Easy table & equation insertion

* Easy citations and reference list building

You can switch between modes with a button push, try it out! 



## Presentations

Quarto can also produce slideshow presentations. To make a presentation with Quarto, click File > New File > Quarto Presentation. Choose `Reveal JS` to make your slides and leave the Engine and Editor options untouched.

The slides you’ll make use the reveal.js JavaScript library under the hood, a technique. The following code makes a simple presentation:

````md
---
title: "My First Quarto Presentation"
format: revealjs
---

## Slide 1: Introduction

- Welcome to my presentation
- Made with Quarto and Reveal.js

## Slide 2: Incremental Bullet Points

"\u0060\u0060\u0060{r}"
#| include: false
library(tidyverse)
penguins_raw <- read_csv("https://raw.githubusercontent.com/UEABIO/data-sci-v1/main/book/files/penguins_raw.csv")
"\u0060\u0060\u0060"

We are writing a report about the **Palmer Penguins**. These penguins are *really* amazing. There are three species:

:::{.incremental}

- Adelie
- Gentoo
- Chinstrap
:::

## Slide 3: Columns

:::{.columns}
::: {.column width="70%"}
```{r}
#| fig-height: 9
#| out.width: "120%"
penguin_colours <- c("darkolivegreen4", "darkorchid3", "goldenrod1")

penguins_raw |> 
  ggplot(aes(x=`Flipper Length (mm)`, 
             y = `Body Mass (g)`))+
  geom_point(aes(colour=`Species`))+
  scale_color_manual(values=penguin_colours,
                      labels = c("Adelie", "Chinstrap", "Gentoo"))+
  theme_minimal(base_size = 20)+
  theme(legend.position = "bottom")
```

:::

::: {.column width="30%"}
```{r}
penguins_raw |>  
    group_by(`Species`) |>  
    summarise(`Body Mass (g)`= mean(`Body Mass (g)`, na.rm = T),
              `Flipper Length (mm)`= mean(`Flipper Length (mm)`, na.rm = T)) |>  
  gt::gt()
```
:::
:::

````

## Explanation of Key Features

- Basic Structure: The YAML header (--- at the top) defines the presentation title and the format (revealjs for Reveal.js presentations).

- Slides: Each slide starts with a new heading (e.g., ## Slide Title). Everything under that heading will appear on the same slide.

- Incremental Bullet Points: Use {.incremental} to reveal bullet points one by one.

- Columns: Use {.columns} to create multiple columns on a slide. Then, define each column with {.column} and set the width (e.g., "50%" for two equally sized columns).

## Parameters

Parameterized reporting is a technique that allows you to generate multiple reports simultaneously. By using parameterized reporting, you can follow the same process to make 3,000 reports as you would to make one report. The technique also makes your work more accurate, as it avoids copy-and-paste errors. 

Let's create a parameterized report using Quarto and the Palmer Penguins data. Parameterized reporting allows you to create dynamic reports that can change based on input parameters, such as species or island in this example.

We add parameters to the YAML header of your Quarto document. These parameters will control the species or island that the report focuses on:


### Defining Parameters

In R Markdown, *parameters* are variables that you set in the YAML to allow you to create multiple reports. Take a look at these two lines in the YAML:

````md
params:
  species: "Adelie Penguin (Pygoscelis adeliae)"
  island: "Biscoe"
````

This code defines variables called species and island. You can use these variable throughout the rest of the Quarto document with the `params$variable_name` syntax, replacing `variable_name` with species or any other name you set in the YAML. For example, consider this inline R code:

`params$species`

Any instance of the `params$species` parameter will be converted to "Adelie Penguin (Pygoscelis adeliae)" when you knit it. 


### Parameterised Report

````md
---
title: "Penguin Analysis Report"
format: html
params:
  species: "Adelie Penguin (Pygoscelis adeliae)"
  island: "Biscoe"
---


````

### Create a Parameterized Report

Now, let's add R code to use these parameters for filtering and visualizing the data:


````md
---
title: "Penguin Analysis Report"
format: html
params:
  species: "Adelie Penguin (Pygoscelis adeliae)"
  island: "Biscoe"
---

## Introduction

This report provides an analysis of the Palmer Penguins dataset. The current report focuses on the `` r "\u0060params$species\u0060"` `` species from "\u0060r params$island\u0060" island.

## Load and Filter Data

First, let's load the Palmer Penguins dataset and filter it based on the selected parameters.

```{r}
#| include: false
library(tidyverse)
library(gghighlight)
# Load the dataset
penguins_raw <- read_csv("https://raw.githubusercontent.com/UEABIO/data-sci-v1/main/book/files/penguins_raw.csv")

# Filter data based on parameters
filtered_data <- penguins_raw |> 
  filter(Island == params$island)

```

```{r}
# Display the first few rows of the filtered data
head(filtered_data)
```


## Now let's generate some summary statistics

```{r}
summary_stats <- filtered_data %>%
  summarise(
    mean_flipper_length = mean(`Culmen Length (mm)`, na.rm = TRUE),
    mean_body_mass = mean(`Body Mass (g)`, na.rm = TRUE)
  )

summary_stats

```

## Visualisations


```{r}
penguin_colours <- c("darkolivegreen4", "darkorchid3", "goldenrod1")

penguins_raw |> 
  ggplot(aes(x=`Flipper Length (mm)`, 
             y = `Body Mass (g)`))+
  geom_point(aes(colour=`Species`))+
  scale_color_manual(values=penguin_colours,
                      labels = c("Adelie", "Chinstrap", "Gentoo"))+
  theme_minimal(base_size = 20)+
  theme(legend.position = "bottom")+
  gghighlight(`Species` == params$species)
```

````

### Explanation of Key Elements

1. **YAML Header with Parameters**: The `params` field defines the parameters (`species` and `island`). These can be changed to generate different versions of the report.
2. **R Code Chunks Using Parameters**: The `params$` notation is used within R code chunks to access the parameter values and filter the dataset accordingly.
3. **Dynamic Text**: The inline R code (e.g.,`` `r params$species` ``) dynamically updates the text in the report to reflect the chosen parameters.


### Further Reading, Guides and tips {-}


* https://www.apreshill.com/blog/2022-04-we-dont-talk-about-quarto/

* https://www.njtierney.com/post/2022/04/11/rmd-to-qmd/

* https://www.jumpingrivers.com/blog/quarto-rmarkdown-comparison/


