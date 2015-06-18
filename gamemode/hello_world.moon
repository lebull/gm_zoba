class Fruit
    
    new: =>
        @name = "Fruit"

    eat: => 
        print "Om nom nom on a:", @name

myFood = Fruit
myFood\eat!