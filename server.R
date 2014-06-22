library(shiny)
library(caret)
library(randomForest)
library(e1071)
iris <- iris

shinyServer(function(input, output) {
    #build a simple model
    
    
    preProc <- preProcess(iris[,-5], method = 'pca', thresh=0.9)
    trainingPCA <- predict(preProc, iris[,-5])
    trainingPCA$Species <- iris$Species
    model <- train(Species ~ ., data=trainingPCA,method='rf')
    
    inputPCA = data.frame()
    inputPCA2 = data.frame()
    allforgraph = data.frame()
    
    preparedinput <- reactive(function() {
        input <- data.frame(Sepal.Length = input$Sepal.Length,
                            Sepal.Width = input$Sepal.Width,
                            Petal.Length = input$Petal.Length,
                            Petal.Width = input$Petal.Width)
        return(input)
    })
    
    performprediction <- reactive(function(){
        input <- preparedinput()
        inputPCA <- predict(preProc,input)
        inputPCA$Species <- predict(model,inputPCA)
        return(inputPCA)
    })
    
    output$image <- renderImage({
        sp <- performprediction()$Species
        if (sp == 'virginica') {
            return(list(
                src = "virginica.jpg",
                width = 300,
                contentType = "image/jpg",
                alt = "virginica"))
            }
        else if (sp == 'setosa') {
            return(list(
                src = "setosa.jpg",
                width = 300,
                contentType = "image/jpg",
                alt = "setosa"))
        }
        
        else {
            return(list(
                src = "versicolour.jpg",
                width = 300,
                contentType = "image/jpg",
                alt = "versicolour"))
        }
        
    }, deleteFile = FALSE)
    
    output$prediction <- renderText({
        return(paste('I think it\'s a ',performprediction()$Species,'!',sep=""))
    })
    
    output$plot <- renderPlot(function() {
        input <- performprediction()
        input$Species <- 'Your iris'
        #allforgraph <- rbind(trainingPCA,input)
        palette(value=c('blue','black','green'))
        plot(trainingPCA$PC1,trainingPCA$PC2,col=trainingPCA$Species,main="Compare your iris!", 
             xlab="Principle Component 1", ylab="Principle Component 2")
        points(input$PC1,input$PC2,pch=4,cex=5,col='red')
        legend("topright",
               legend=c('setosa','versicolor','virginica','Your iris'),
               col=c('blue','black','green','red'),
               pch=c(1,1,1,4))
        
    }, height=700)
    
})