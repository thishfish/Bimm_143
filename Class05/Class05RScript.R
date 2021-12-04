#' ---
#' title: "Class05 Lab Report"
#' author: "Thisha Thiagarajan, PID: A15474979"
#' date: "10/12/2021"
#' ---

# Class 05 Data Visualization 
#comments for packages that were installed 
  #install.packages("ggplot2")
  #install.packages("dplyr")
  #install.packages("gifski")
  #install.packages("patchwork")
  #install.packages("gganimate")
  #install.packages("gapminder") to access ALL the data
  #used url for genes and gapminder

#scatterplot 

# loading ggplot (install is done one time in console)
library(ggplot2)

#just sets up the plot, haven't added data + aes + geoms yet (plot = blank)
# ggplot(cars)

#data + aes + geom added, we can see scatterplot 
ggplot(data = cars)+
  aes(x = speed, y = dist)+
  geom_point()+
  geom_smooth()

#we can stack multiple geom layers, geom_smooth used for trendlines 

#change to linear model, add labels 

carsplot<- ggplot(data = cars)+
  aes(x = speed, y = dist)+
  geom_point()+
  geom_smooth(method = "lm")

carsplot
carsplot+ labs(title="My nice plot", x="speed (mph)", y="dist (km)")

url <- "https://bioboot.github.io/bimm143_S20/class-material/up_down_expression.txt"
genes <- read.delim(url)
head(genes)

#numgenes = 5196 
nrow(genes)

#numcolumns = 4
ncol(genes)

#names of columns = "Gene" "Condition1" "Condition2" "State"     
colnames(genes)

#how many genes are upregulated = 127
table(genes[,"State"])

#percentage of upregulated genes = 2.44%
percent <- table(genes[,"State"]) / nrow(genes) *100
round(percent, 2)


#scatterplot for this new data set 
genesplot <- ggplot(genes) + 
  aes(x=Condition1, y=Condition2, col= State) +
  geom_point()

genesplot

#change color scale and add labels

genesplot +
  scale_colour_manual( values=c("blue","gray","red") ) +
  labs(title= "gene expression", x= "control", y="treatment")

#new dataset = gapminder
url <- "https://raw.githubusercontent.com/jennybc/gapminder/master/inst/extdata/gapminder.tsv"
gapminder <- read.delim(url)

#will learn abt dplyr next class i believe 
library(dplyr)
gapminder_2007 <- gapminder %>% filter(year==2007)

# create a scatterplot (alpha controls transparency)
ggplot(gapminder_2007) +
  aes(x=gdpPercap, y=lifeExp) +
  geom_point(alpha = 0.5)

#add more aes, in this color is categorical value 

ggplot(gapminder_2007) +
  aes(x=gdpPercap, y=lifeExp, color=continent, size=pop) +
  geom_point(alpha = 0.5)

#try a new aes, making color a numerical value (continuous)
ggplot(gapminder_2007) +
  aes(x=gdpPercap, y=lifeExp, color=pop) +
  geom_point(alpha = 0.5)

#make sizes proportional to pop, size=pop does not make them proportional, can't
#compare two points accurately 
ggplot(gapminder_2007) +
  aes(x=gdpPercap, y=lifeExp, color=continent, size=pop) +
  geom_point(alpha = 0.5) +
  scale_size_area(max_size = 10)

#now do this for a diff year 1957 
gapminder_1957 <- gapminder %>% filter(year==1957)
ggplot(gapminder_1957) +
  aes(x=gdpPercap, y=lifeExp, color=continent, size=pop) +
  geom_point(alpha = 0.7) +
  scale_size_area(max_size = 15)

#now show both 2007 and 1957 side by side 
gapminder_both <- gapminder %>% filter(year==1957 | year==2007)
ggplot(gapminder_both) +
  aes(x=gdpPercap, y=lifeExp, color=continent, size=pop) +
  geom_point(alpha = 0.7) +
  scale_size_area(max_size = 15)+ 
  facet_wrap(~year)

#plot animation 
library(gganimate)
library(gapminder)

ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  # facet wrap separates into diff graphs by continent 
  facet_wrap(~continent) +
  # new layers from gganimate 
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  shadow_wake(wake_length = 0.1, alpha = FALSE)

#combining graphs

library(patchwork)

#plots 
p1 <- ggplot(mtcars) + geom_point(aes(mpg, disp))
p2 <- ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))
p3 <- ggplot(mtcars) + geom_smooth(aes(disp, qsec))
p4 <- ggplot(mtcars) + geom_bar(aes(carb))

# patchwork combines them
(p1 | p2 | p3) /
  p4









