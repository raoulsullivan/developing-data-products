library(shiny)
library(ggplot2)

iris <- iris

shinyUI(pageWithSidebar(
    
    headerPanel("Which iris is it?"),
    
    sidebarPanel(
        helpText("This shiny app predicts what kind of iris you have,",
                 "based on four variables. It uses Principal Components Analysis",
                 "on the iris dataset from R to determine two Principle Components",
                 "from these four variables. The caret package handles the machine",
                 "learning using a random forest."),
        
        helpText("To get started, just enter your variables on these sliders"),
        
        sliderInput('Sepal.Length', 'Sepal length (mm)', min=min(iris$Sepal.Length), 
                    max=max(iris$Sepal.Length),value=mean(iris$Sepal.Length),step=0.1),
        sliderInput('Sepal.Width', 'Sepal width (mm)', min=min(iris$Sepal.Width), 
                    max=max(iris$Sepal.Width),value=mean(iris$Sepal.Width),step=0.1),
        sliderInput('Petal.Length', 'Petal length (mm)', min=min(iris$Petal.Length), 
                    max=max(iris$Petal.Length),value=mean(iris$Petal.Length),step=0.1),
        sliderInput('Petal.Width', 'Petal width (mm)', min=min(iris$Petal.Width), 
                    max=max(iris$Petal.Width),value=mean(iris$Petal.Width),step=0.1),
        imageOutput("image", height = 300),
        textOutput('prediction')
    ),
    
    mainPanel(
        plotOutput('plot')
    )
))
