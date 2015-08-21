table <- read.table("http://sebastien.ledien.free.fr/unofficial_factominer/livreR/decathlon.csv",sep=";",row.names=1, dec=".", header = TRUE)
table$name<-row.names(table)
row.names(table)<-NULL

shinyServer(
        function(input, output, session) {
                slidervalue <-reactive({
                        updateSliderInput(session, "svalue", min = 1, max = nrow(data()), step =1)
                })
                data <-reactive({ 
                        
                        if (input$id1 == "Olympic Games"){
                                dataset <-subset(table, table$Competition == "OlympicG" )      
                        }
                        else if (input$id1 == "Decastar"){
                                dataset <-subset(table, table$Competition == "Decastar" )      
                        }
                        else  {
                                dataset <-table
                        }
                        
                })
                
#                 doc <- tags$doc(
#                         tags$body(
#                                 a(href="http://www.lalala.com"))
#                 )
#                 cat(as.character(doc))
                
                
                list_select <-reactive({
                        
                        if (input$quateg == "Running"){
                                word<-"Running"
                                # print(word)
                        }
                        else if (input$quateg == "Throwing"){
                                word <-"Throwing"
                        }
                        else if (input$quateg == "Jumping"){
                                word <-"Jumping"
                        }
                        else if(input$quateg =="Pole vault"){
                                word <-"Pole vault"
                        }
                        
                        else {
                                word<-"nop"
                        }
                        
                })
                output$plotv <- renderPlot({
                        table<-data()
                        slidervalue()
                        if (list_select() == "Running"){
                                x1 <-1:nrow(table)
                                y1 <-table$X100m
                                x2 <-1:nrow(table)
                                y2 <-table$X400m
                                x3 <-1:nrow(table)
                                y3 <-table$X110m.H
                                svalue<-input$svalue
                                plot(x1,y1,ylim=range(c(y1,y2)),xlim=range(c(x1,x2)),  col="black")
                                lines(c(svalue, svalue), c(0, 100),col="red",lwd=5)
                                
                                points(x1,y2, col="blue")
                                points(x1,y3, col="green")
                                
                                text(10, 40, paste("400m: ",table[svalue,5]))
                                text(10, 35, paste("110 H/m: ",table[svalue,6]))
                                text(10, 30,paste("100 m: ", table[svalue,1]))
                                
                                
                        }
                        else if (list_select() == "Throwing"){
                                
                                x1 <-1:nrow(table)
                                y1 <-table$Disque
                                x2 <-1:nrow(table)
                                y2 <-table$Javelot
                                x3 <-1:nrow(table)
                                y3 <-table$Poids
                                svalue<-input$svalue     
                                plot(x1,y1,ylim=range(c(y3,y2)),xlim=range(c(x1,x2)),  col="black")
                                lines(c(svalue, svalue), c(0, 100),col="red",lwd=5)
                                points(x1,y2, col="blue",pch =15)
                                points(x1,y3, col="green",pch=19)
                                
                                text(10, 40, paste("Javelin Throw: ",table[svalue,9]))
                                text(10, 35,paste("Discus Throw: ", table[svalue,7]))
                                text(10, 30, paste(" Shot Throw: ",table[svalue,3]))
                        }
                        else if (list_select() == "Jumping"){
                                
                                x1 <-1:nrow(table)
                                y1 <-table$Longueur
                                x2 <-1:nrow(table)
                                y2 <-table$Hauteur
                                svalue<-input$svalue     
                                plot(x1,y1,ylim=range(c(y1,y2)),xlim=range(c(x1,x2)),  col="pink", pch=15)
                                lines(c(svalue, svalue), c(0, 100),col="red",lwd=2)
                                points(x1,y2, col="blue", pch =3)
                                text(10, 5,paste("Long Jump : ", table[svalue,2], "m"))
                                text(10, 6, paste("High Jump : ",table[svalue,4]," m"))
                                
                        }
                        else if (list_select() == "Pole vault"){
                                
                                x1 <-1:nrow(table)
                                y1 <-table$Perche
                                svalue<-input$svalue     
                                plot(x1,y1,  col="black", pch=15)
                                lines(c(svalue, svalue), c(0, 1000),col="red",lwd=2)
                                text(8, 5,paste("Pole vault : ", table[svalue,2], "m"))
                                
                        }
                        
                        
                        else {
                                x1 <-1:nrow(table)
                                y1 <-table$X1500m
                                svalue<-input$svalue   
                                plot(x1,y1,,  col="brown",pch = 17)
                                lines(c(svalue, svalue), c(0, 600),col="red",lwd=1,)
                                text(10, 1000,paste("1500 m: ", table[svalue,10]))
                                
                        }
                        
                        output$name <-renderPrint(paste("Name : ",table[svalue,14],"Ranking : ",table[svalue,11]  ))
                        
                        output$summary <- renderPrint({
                                test<-list_select()
                        })
                        
                        output$tablev <- renderDataTable({
                                print(data())
                        })
                        output$champion <- renderPrint({
                                print(paste("To be in the first three of the following disipline", input$quateg, "in",input$id1, " you have to do :") )
                                dataset<-data()
                                if (list_select() == "Running"){
                                        
                                        m100<-mean(head(sort(as.numeric(dataset$X100m))),n=3)
                                        print (paste("100m : ",m100))
                                        m110h<-mean(head(sort(as.numeric(dataset$X110m.H))),n=3)
                                        print (paste("110m/h : ",m110h))
                                        
                                        m400<-mean(head(sort(as.numeric(dataset$X400m))),n=3)
                                        print (paste("400m : ",m400))
                                }
                                else if (list_select() == "Throwing"){
                                        disque<-mean(head(sort(as.numeric(dataset$Disque))),n=3)
                                        print (paste("Discus : ",disque,"m"))
                                        javelin<-mean(head(sort(as.numeric(dataset$Javelot))),n=3)
                                        print (paste("Javelin Throw : ",javelin,"m"))
                                        
                                        shot<-mean(head(sort(as.numeric(dataset$Poids))),n=3)
                                        print (paste("Shot Throw : ",shot,"m"))
                                }
                                else if (list_select() == "Jumping"){
                                        
                                        longueur <-mean(head(sort(as.numeric(table$Longueur))),n=3)
                                        print (paste("Long jump : ",longueur, "m"))
                                        hauteur <-mean(head(sort(as.numeric(table$Hauteur))),n=3)
                                        print (paste("High Jump : ",hauteur,"m"))
                                }
                                else if (list_select() == "Pole vault"){
                                        pole <-mean(head(sort(as.numeric(table$Perche))),n=3)
                                        print (paste("Pole vault : ",pole,"m"))
                                }
                                else {
                                        m1500 <-mean(head(sort(as.numeric(table$X1500m))),n=3)
                                        print (paste("1500m : ",m1500))
                                        
                                }
                                
                        })
                        
                        
                })
        }
)