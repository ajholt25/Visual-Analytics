library(ggplot2)
library(lattice)


# load data
data("tips")
mytips <- tips
head(mytips)
nrow(mytips)
str(mytips)

# tip percentage
mytips$percent <-  mytips$tip / mytips$total_bill * 100

mytips <- mytips %>%  select(-tip) # remove tip column

# create a scatterplot matrix
plot(mytips)

# y = percent, x = size, z = day
ggplot(mytips, aes(x = size, y = percent, color = day)) +
  geom_point(aes(shape = sex), position = position_jitter(w= 0.1, h=0.05)) +
  scale_shape_manual(values = c(1, 4)) + 
  labs(title= "Tips by Party Size, Day of Week, and Sex of Diner",
       x = "Number of Diners", y="Tip as a Percent of Total Bill")  

# too much info. separate using lattice

# Load the lattice package
library(lattice)




mytips$day <- as.factor(mytips$day)
mytips$sex <- as.factor(mytips$sex)




# Create the plot
xyplot(percent ~ jitter(size, amount = 0.1) | day * sex, 
       data = mytips,
       panel = function(x, y) {
         panel.xyplot(x, y, pch = 4, col = "forestgreen", fill = NA) # Customize the points
      
       },
       xlab = "Number of Diners",
       ylab = "Tip as a Percent of Total Bill",
       main = "Tips by Party Size, Day of Week, and Sex of Diner",
       layout = c(4, 2), # Adjust layout as needed
       scales = list(relation = "free")) # Allows each panel to have its own scale

summary(mytips$percent)
