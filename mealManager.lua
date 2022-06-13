local MealManager={}

local gameplayService=nil

local inventory={}
local lstTicket={}

local lstCurrentIngredient={}
local currentNameMeal=""

local bOnAnalyze=false
local bIsFinishMeal=false

local sndFinishMeal=nil

function MealManager.addIngredient(pIngredientType)
  table.insert(lstCurrentIngredient,pIngredientType)
  bOnAnalyze=true
end

function MealManager.deleteIngredient(pIngredientType)
  
  for n=#lstCurrentIngredient,1,-1 do
    local ingredient=lstCurrentIngredient[n]
  
    if ingredient==pIngredientType then
      table.remove(lstCurrentIngredient,n)
      return
    end
  
  end

end


local function getImgTicketMeal(pLevel)
  
  local imgTicketMeal=nil
  
  
  if pLevel==1 then
    
    imgTicketMeal=gameplayService.assetManager.getImage("images/food/soupsOrder.png")
    
  elseif pLevel==2 then
  
    imgTicketMeal=gameplayService.assetManager.getImage("images/food/fruitSaladsOrder.png")
  
  elseif pLevel==3 then
  
    imgTicketMeal=gameplayService.assetManager.getImage("images/food/saladsOrder.png")
  
  elseif pLevel==4 then
  
    imgTicketMeal=gameplayService.assetManager.getImage("images/food/hotdogsOrder.png")
  
  elseif pLevel==5 then
  
    imgTicketMeal=gameplayService.assetManager.getImage("images/food/burgersOrder.png")
  
  end
  
  
  return imgTicketMeal
end


function MealManager.addTicket(pNameMeal,pNumOrder,pLevel)
  
  for n=1,#inventory do
    local myMeal=inventory[n]
    
    if myMeal.name==pNameMeal then
      
      local imgMealTicket=getImgTicketMeal(pLevel)
      
      local myTicket={}
      
      myTicket.img=gameplayService.assetManager.getImage("images/order/ticket.png")
      
      myTicket.bIsSelect=false
      
      myTicket.width=myTicket.img:getWidth()
      myTicket.height=myTicket.img:getHeight()
      
      myTicket.x=50+(#lstTicket*(myTicket.width+10))
      myTicket.y=0
      
      myTicket.num=pNumOrder
      myTicket.id=#lstTicket+1
      
      myTicket.sprMeal=gameplayService.sprite.create(imgMealTicket,0,0)
      myTicket.sprMeal.setScale(2,2)
      myTicket.sprMeal.addAnimation("",32,32,{myMeal.num},0,false)
      myTicket.sprMeal.startAnimation("")
      
      myTicket.sprMeal.x=myTicket.x+((myTicket.width/2)-myTicket.sprMeal.width/2)
      myTicket.sprMeal.y=myTicket.y+((myTicket.height-myTicket.sprMeal.height)-5)
      
      
      myTicket.nameMeal=pNameMeal
      myTicket.lstIngredient=myMeal.lstIngredient
      
      
      table.insert(lstTicket,myTicket)
      return 
      
    end
    
  end
  
end


function MealManager.getTicketList()
  return lstTicket
end


local function getIngredientMeal(pLevel,pNameMeal)
  
  local ingredient={
    list={},
    str=""
  }
  
  if pLevel==1 then
    
    ----------------------------------------------SOUPS---------------------------------
    
    if pNameMeal=="soup_tomato" then
      
      ingredient.list={"water","tomato"}
      ingredient.str="water+tomato"
      
    elseif pNameMeal=="soup_carrot" then
      
      ingredient.list={"water","carrot"}
      ingredient.str="water+carrot"
      
    elseif pNameMeal=="soup_onion" then
      
      ingredient.list={"water","onion"}
      ingredient.str="water+onion"
      
    elseif pNameMeal=="soup_tomato&Crouton" then
      
      ingredient.list={"water","tomato","crouton"}
      ingredient.str="water+tomato+crouton"
      
    elseif pNameMeal=="soup_carrot&Crouton" then
      
      ingredient.list={"water","carrot","crouton"}
      ingredient.str="water+carrot+crouton"
      
    elseif pNameMeal=="soup_onion&Crouton" then
      
      ingredient.list={"water","onion","crouton"}
      ingredient.str="water+onion+crouton"
    end

  elseif pLevel==2 then
    
    ----------------------FRUITS SALADS---------------------
    
    if pNameMeal=="fruitSalad_NoMapleSyrup" then
      
      ingredient.list={"apple","banana","strawberries","pear"}
      ingredient.str="apple+banana+strawberries+pear"
      
    elseif pNameMeal=="fruitSalad_mapleSyrup" then
      
      ingredient.list={"apple","banana","strawberries","pear","maple_syrup"}
      ingredient.str="apple+banana+strawberries+pear+maple_syrup"
      
    elseif pNameMeal=="fruitSalad_NoMapleSyrup&NoStrawberries" then
      
      ingredient.list={"apple","banana","pear"}
      ingredient.str="apple+banana+pear"
      
    elseif pNameMeal=="fruitSalad_mapleSyrup&NoStrawberries" then
      
      ingredient.list={"apple","banana","pear","maple_syrup"}
      ingredient.str="apple+banana+pear+maple_syrup"
      
    elseif pNameMeal=="fruitSalad_NoMapleSyrup&NoBanana" then
      
      ingredient.list={"apple","strawberries","pear"}
      ingredient.str="apple+strawberries+pear"
    
    elseif pNameMeal=="fruitSalad_mapleSyrup&NoBanana" then
      
      ingredient.list={"apple","strawberries","pear","maple_syrup"}
      ingredient.str="apple+strawberries+pear+maple_syrup"
      
    elseif pNameMeal=="fruitSalad_NoMapleSyrup&NoApple&NoPear" then
    
      ingredient.list={"banana","strawberries"}
      ingredient.str="banana+strawberries"
    
    elseif pNameMeal=="fruitSalad_mapleSyrup&NoApple&NoPear" then
      
      ingredient.list={"banana","strawberries","maple_syrup"}
      ingredient.str="banana+strawberries+maple_syrup"
    
    elseif pNameMeal=="fruitSalad_NoMapleSyrup&NoBanana&NoStrawberries" then
    
      ingredient.list={"apple","pear"}
      ingredient.str="apple+pear"
    
    elseif pNameMeal=="fruitSalad_mapleSyrup&NoBanana&NoStrawberries" then 
      
      ingredient.list={"apple","pear","maple_syrup"}
      ingredient.str="apple+pear+maple_syrup"
    
    end
    
    
  elseif pLevel==3 then
    
    ------------------------------SALADS------------------------------

    if pNameMeal=="salad_chicken&Tomato" then
      
      ingredient.list={"salad","tomato","chicken"}
      ingredient.str="salad+tomato+chicken"
      
    elseif pNameMeal=="salad_cheese&Tomato" then
    
      ingredient.list={"salad","tomato","saladCheese"}
      ingredient.str="salad+tomato+saladCheese"
      
    elseif pNameMeal=="salad_cheese&Onion" then
    
      ingredient.list={"salad","onion","saladCheese"}
      ingredient.str="salad+onion+saladCheese"
    
    elseif pNameMeal=="salad_chicken&Onion" then 
    
      ingredient.list={"salad","onion","chicken"}
      ingredient.str="salad+onion+chicken"   
    
    elseif pNameMeal=="salad_cheese&Chicken&Onion" then
    
      ingredient.list={"salad","chicken","onion"}
      ingredient.str="salad+chicken+onion"    
    
    elseif pNameMeal=="salad_cheese&Chiken&Onion&Tomato" then
    
      ingredient.list={"salad","saladCheese","onion","tomato"}
      ingredient.str="salad+saladCheese+onion+tomato"
    
    elseif pNameMeal=="salad_chicken&Tomato&Onion" then
    
      ingredient.list={"salad","chicken","tomato","onion"}
      ingredient.str="salad+chicken+tomato+onion"    
    
    elseif pNameMeal=="salad_cheese&Tomato&Onion" then
    
      ingredient.list={"salad","saladCheese","tomato","onion"}
      ingredient.str="salad+saladCheese+tomato+onion"    
    
    elseif pNameMeal=="salad_cheese&Chicken&Tomato" then
    
      ingredient.list={"salad","saladCheese","chicken","tomato"}
      ingredient.str="salad+saladCheese+chicken+tomato"    
    
    elseif pNameMeal=="salad_tomato" then
      
      ingredient.list={"salad","tomato"}
      ingredient.str="salad+tomato"    
    
    elseif pNameMeal=="salad_cheese" then
      
      ingredient.list={"salad","cheese"}
      ingredient.str="salad+cheese"    
    
    elseif pNameMeal=="salad_chicken" then
      ingredient.list={"salad","chicken"}
      ingredient.str="salad+chicken"    
    
    end
    
    
  elseif pLevel==4 then
    
    ------------------------------------------HOTDOGS----------------------
     
    if pNameMeal=="hotdog_simple" then
      
      ingredient.list={"hotdogBread","sausage"}
      ingredient.str="hotdogBread+sausage"
      
    elseif pNameMeal=="hotdog_ketchup" then
      
      ingredient.list={"hotdogBread","sausage","ketchup"}
      ingredient.str="hotdogBread+sausage+ketchup"     
      
    elseif pNameMeal=="hotdog_mustard" then
      
      ingredient.list={"hotdogBread","sausage","mustard"}
      ingredient.str="hotdogBread+sausage+mustard"      
      
    elseif pNameMeal=="hotdog_ketchup&Mustard" then
      
      ingredient.list={"hotdogBread","sausage","ketchup","mustard"}
      ingredient.str="hotdogBread+sausage+ketchup+mustard"     
      
    elseif pNameMeal=="hotdog_ketchup&Mustard&Pepper" then
      
      ingredient.list={"hotdogBread","sausage","ketchup","mustard","pepper"}
      ingredient.str="hotdogBread+sausage+ketchup+mustard+pepper"
      
    elseif pNameMeal=="hotdog_ketchup&Pepper" then
      
      ingredient.list={"hotdogBread","sausage","ketchup","pepper"}
      ingredient.str="hotdogBread+sausage+ketchup+pepper"
      
    elseif pNameMeal=="hotdog_mustard&Pepper" then
      
      ingredient.list={"hotdogBread","sausage","mustard","pepper"}
      ingredient.str="hotdogBread+sausage+mustard+pepper"
      
    elseif pNameMeal=="hotdog_pepper" then
    
      ingredient.list={"hotdogBread","sausage","pepper"}
      ingredient.str="hotdogBread+sausage+pepper"
    
    end
    
    
  elseif pLevel==5 then
      
      --------------------------------------BURGERS--------------------------
      
    -------------------burger bread+steak
    if pNameMeal=="burger_NoRawVegetable&NoCheese" then
      
      ingredient.list={"burgerBread","steak"}
      ingredient.str="burgerBread+steak"
    
    ------------burger bread+steak+cheese
    elseif pNameMeal=="burger_NoRawVegetable&Cheese" then
      
      ingredient.list={"burgerBread","steak","burgerCheese"}
      ingredient.str="burgerBread+steak+burgerCheese"
    
    ---------burger bread+steak+tomato
    elseif pNameMeal=="burger_tomato" then
    
      ingredient.list={"burgerBread","steak","tomato"}
      ingredient.str="burgerBread+steak+tomato"
    
    -----------burger bread+steak+tomato+cheese
    elseif pNameMeal=="burger_tomato&Cheese" then
    
      ingredient.list={"burgerBread","steak","tomato","burgerCheese"}
      ingredient.str="burgerBread+steak+tomato+burgerCheese"
      
      
    -------------burger bread+steak+salad
    elseif pNameMeal=="burger_salad" then
      
      ingredient.list={"burgerBread","steak","salad"}
      ingredient.str="burgerBread+steak+salad"
      
    -------------burger bread+steak+salad+cheese
    elseif pNameMeal=="burger_salad&Cheese" then
    
      ingredient.list={"burgerBread","steak","salad","burgerCheese"}
      ingredient.str="burgerBread+steak+salad+burgerCheese"
      
    -----------burger bread+steak+salad+tomato
    elseif pNameMeal=="burger_noCheese" then
      ingredient.list={"burgerBread","steak","salad","tomato"}
      ingredient.str="burgerBread+steak+salad+tomato"
      
    -------------burger bread+steak+salad+tomato+cheese
    elseif pNameMeal=="burger_simple" then
    
      ingredient.list={"burgerBread","steak","salad","tomato","burgerCheese"}
      ingredient.str="burgerBread+steak+salad+tomato+burgerCheese"
    
    ---------------burger vegetarian
    elseif pNameMeal=="burger_vegetarian" then
      ingredient.list={"burgerBread","salad","tomato","burgerCheese"}
      ingredient.str="burgerBread+salad+tomato+burgerCheese"
    
    ----------------burger vegetrian no cheese
    elseif pNameMeal=="burger_vegetarianNoCheese" then
      ingredient.list={"burgerBread","salad","tomato"}
      ingredient.str="burgerBread+salad+tomato"
    
    
    --------------burger vegetarian no tomato
    elseif pNameMeal=="burger_vegetarianNoTomato" then
      ingredient.list={"burgerBread","salad","burgerCheese"}
      ingredient.str="burgerBread+salad+burgerCheese"
      
    --------------------burger vegetarian no salad
    elseif pNameMeal=="burger_vegetarianNoSalad" then
      ingredient.list={"burgerBread","tomato","burgerCheese"}
      ingredient.str="burgerBread+tomato+burgerCheese" 
    end
    
  end
  
  return ingredient
end


local function getImgMeal(pLevel)
  
  local imgMeal=nil
  
  if pLevel==1 then
    
    imgMeal=gameplayService.assetManager.getImage("images/food/soups.png")
    
  elseif pLevel==2 then
    
    imgMeal=gameplayService.assetManager.getImage("images/food/fruitSalads.png")
    
  elseif pLevel==3 then
    
    imgMeal=gameplayService.assetManager.getImage("images/food/salads.png")
    
  elseif pLevel==4 then 
    
    imgMeal=gameplayService.assetManager.getImage("images/food/hotdogs.png")
    
  elseif pLevel==5 then
    
    imgMeal=gameplayService.assetManager.getImage("images/food/burgers.png")
    
  end
  
  
  return imgMeal
end


local function getLstNameMeal(pLevel)
  
  local lstNameMeal={}
  
  if pLevel==1 then
    lstNameMeal={"soup_tomato","soup_carrot","soup_onion","soup_tomato&Crouton","soup_carrot&Crouton","soup_onion&Crouton"}
    
  elseif pLevel==2 then
    
    lstNameMeal={"fruitSalad_NoMapleSyrup","fruitSalad_mapleSyrup","fruitSalad_NoMapleSyrup&NoStrawberries","fruitSalad_mapleSyrup&NoStrawberries","fruitSalad_NoMapleSyrup&NoBanana","fruitSalad_mapleSyrup&NoBanana","fruitSalad_NoMapleSyrup&NoApple&NoPear","fruitSalad_mapleSyrup&NoApple&NoPear","fruitSalad_NoMapleSyrup&NoBanana&NoStrawberries","fruitSalad_mapleSyrup&NoBanana&NoStrawberries"}
    
  elseif pLevel==3 then
    
    lstNameMeal={"salad_chicken&Tomato","salad_cheese&Tomato","salad_cheese&Onion","salad_chicken&Onion","salad_cheese&Chicken&Onion","salad_cheese&Chiken&Onion&Tomato","salad_chicken&Tomato&Onion","salad_cheese&Tomato&Onion","salad_cheese&Chicken&Tomato","salad_tomato","salad_cheese","salad_chicken"}
    
  elseif pLevel==4 then
    
    lstNameMeal={"hotdog_simple","hotdog_ketchup","hotdog_mustard","hotdog_ketchup&Mustard","hotdog_ketchup&Mustard&Pepper","hotdog_ketchup&Pepper","hotdog_mustard&Pepper","hotdog_pepper"}
    
  elseif pLevel==5 then
    
    lstNameMeal={"burger_NoRawVegetable&NoCheese","burger_NoRawVegetable&Cheese","burger_tomato","burger_tomato&Cheese","burger_salad","burger_salad&Cheese","burger_noCheese","burger_simple","burger_vegetarian","burger_vegetarianNoCheese","burger_vegetarianNoTomato","burger_vegetarianNoSalad"}
    
  end
  
  return lstNameMeal
end



local function addMeal(pName,pNum,pSprite,pLevel)
  
  local myMeal={}
  myMeal.name=pName
  
  myMeal.sprite=pSprite
  myMeal.sprite.bIsVisible=false
  
  myMeal.num=pNum
  
  local ingredient=getIngredientMeal(pLevel,myMeal.name)
  
  myMeal.lstIngredient=ingredient.list
  myMeal.strIngredient=ingredient.str
  
  
  table.insert(inventory,myMeal)
end


local function initInventory(pLevel)
  
  local img=getImgMeal(pLevel)
  local lstNameMeal=getLstNameMeal(pLevel)
  
  local nbMealImg=(img:getWidth()/30)*(img:getHeight()/25)
  
  for n=1,nbMealImg do
    
    local sprMeal=gameplayService.sprite.create(img,0,0)
    
    local object=gameplayService.objectManager.getObject("bowl")
  
    if object~=nil then
      object.sprite.bIsVisible=false
    end
    
    if object~=nil then
     sprMeal.setScale(4,4)
     
    else
      sprMeal.setScale(2,2)
      
    end
    
    sprMeal.addAnimation("",30,25,{n},0,false)
    sprMeal.startAnimation("")
  
    addMeal(lstNameMeal[n],n,sprMeal,pLevel)
    
  end
  
end

function MealManager.load(pGameplayService)
  gameplayService=pGameplayService
  
  inventory={}
  lstTicket={}

  lstCurrentIngredient={} 
  currentNameMeal=""

  bOnAnalyze=false
  bIsFinishMeal=false
  
  sndFinishMeal=gameplayService.assetManager.getSound("sounds/sonnette.wav")
  
  initInventory(gameplayService.currentLevel)
end


local function resetVisible()
  
  for n=1,#inventory do
    local myMeal=inventory[n]

    myMeal.sprite.bIsVisible=false
  end
  
end


local function resetValueTicket()
     ----------------------ticket order----------
  for n=1,#lstTicket do
    local myTicket=lstTicket[n]
    
    myTicket.id=n

    myTicket.x=50+((myTicket.id-1)*(myTicket.width+10))
    myTicket.y=0
    
    myTicket.sprMeal.x=myTicket.x+((myTicket.width/2)-myTicket.sprMeal.width/2)
    myTicket.sprMeal.y=myTicket.y+((myTicket.height-myTicket.sprMeal.height)-5)
  end
  
end

function MealManager.deleteTicket(pNumOrder)
  
  for n=#lstTicket,1,-1 do
    local myTicket=lstTicket[n]
  
    if myTicket.num==pNumOrder then
      
      table.remove(lstTicket,n)
      resetValueTicket()
      
      return
    end
    
  end

end


function MealManager.getLstMeal()
  return inventory
end


function MealManager.update(dt)

  if #lstCurrentIngredient>1 and bOnAnalyze then
  
    -------------inventory
    for i=1,#inventory do
      local myMeal=inventory[i]
      
      local strIngredient=""
        
      if #lstCurrentIngredient==#myMeal.lstIngredient then
        
        -------------list ingredient meal
        for n=1,#myMeal.lstIngredient do
          local ingredient=myMeal.lstIngredient[n]
          
          local oldIngredient=""
    
          ---------------list ingredient in the plate
          for n=1,#lstCurrentIngredient do
            local currentIngredient=lstCurrentIngredient[n]
          
            if ingredient==currentIngredient and currentIngredient~=oldIngredient then
             
              oldIngredient=ingredient
              
              if strIngredient=="" then
                strIngredient=ingredient
              else
                strIngredient=strIngredient.."+"..ingredient
              end
            end
            
          end
          
        end
    
        if strIngredient==myMeal.strIngredient then
          
          local object=gameplayService.objectManager.getObject("plate")
          
          if object==nil then
            object=gameplayService.objectManager.getObject("bowl")
          end
          
          if object~=nil then
        
            myMeal.sprite.x=object.sprite.x+(object.sprite.width/2)-(myMeal.sprite.width/2)
            myMeal.sprite.y=object.sprite.y+((object.sprite.height/2)-(myMeal.sprite.height/2))-15
            
            resetVisible()
            myMeal.sprite.bIsVisible=true
            
            gameplayService.foodManager.resetVisible()
            
            local object=gameplayService.objectManager.getObject("bowl")
          
            if object~=nil then
              object.sprite.bIsVisible=false
            end
            
            bOnAnalyze=false
            currentNameMeal=myMeal.name
            
            return
          end
          
        end
      
      end
    end
    
  end
  
end


function MealManager.draw()
  
  for n=1,#inventory do
    local myMeal=inventory[n]
    
    if bIsFinishMeal and myMeal.sprite.bIsVisible then
      myMeal.sprite.color={0.5,0.5,0.5,1}
    else
      myMeal.sprite.color={1,1,1,1}
    end
    
    myMeal.sprite.draw()
    myMeal.sprite.color={1,1,1,1}
    
  end
  
    ----------------------ticket order----------
  for n=#lstTicket,1,-1 do
    local myTicket=lstTicket[n]
    
    if myTicket.bIsSelect then
      love.graphics.setColor(0.8,0.8,0.8,1)
    
    else
      love.graphics.setColor(1,1,1,1)
    end
    
    love.graphics.draw(myTicket.img,myTicket.x,myTicket.y)
    
    love.graphics.setColor(0.5,0.5,0.5)
    
    love.graphics.print("0"..myTicket.num,myTicket.x+5,myTicket.y+5)
    
    love.graphics.setColor(1,1,1)
    
    myTicket.sprMeal.draw()
  end
  
end


local function orderVerification(pTicket)

  local ticket=pTicket
  
  local client=gameplayService.clientManager.getClient(ticket.num)
  
  if client~=nil then
    
    if ticket.nameMeal==currentNameMeal then
      
      gameplayService.nbMoney=gameplayService.nbMoney+gameplayService.price
      gameplayService.nbClientHappy=gameplayService.nbClientHappy+1
      
      client.bIsOrderGood=true
      
    else
      
      gameplayService.nbMoney=gameplayService.nbMoney-gameplayService.price
      client.bIsOrderGood=false
    
    end
    
    
    client.bIsOrderFinish=true
  end
  
  local object=gameplayService.objectManager.getObject("bowl")
  
  if object==nil then
    object=gameplayService.objectManager.getObject("plate")
  end
  
  if object~=nil then
    
    local objectInv=gameplayService.objectManager.getObjectInv(object.type)
    local objectShadow=gameplayService.objectManager.getShadow(object.type)
    
    if objectInv~=nil and objectShadow~=nil then
      objectInv.currentState="no_select"
      
      objectShadow.bIsFull=false
      objectShadow.sprite.bIsVisible=true
    end
    
    -----delete food
    for n=#lstCurrentIngredient,1,-1 do
      local ingredient=lstCurrentIngredient[n]
      
      local food=gameplayService.foodManager.getFoodState(" ",ingredient,"")
      
      if food~=nil then
        gameplayService.foodManager.deleteFood(ingredient," ")
      end
      
    end
    
    object.bInShadow=false
    
    object.sprite.x=0
    object.sprite.y=0
    
    object.sprite.bIsVisible=false
  
  end
              
  resetVisible()
  lstCurrentIngredient={}
  
  bOnAnalyze=false
  bIsFinishMeal=false
  
  currentNameMeal=""
  
  table.remove(lstTicket,ticket.id)
  resetValueTicket()
  
  love.audio.play(sndFinishMeal)
  
  return
end


function MealManager.mousepressed(x,y,btn)
  
  
  if bIsFinishMeal then
    
      -------------------------------tickets-------------------
    for n=#lstTicket,1,-1 do
      local myTicket=lstTicket[n]
      
      local bCollideTicket=gameplayService.utils.checkCollision(myTicket.x,myTicket.y,myTicket.width,myTicket.height,x,y,1,1)
      
      if bCollideTicket then
        orderVerification(myTicket)
        return
      end
      
    end
  
  end
  
  
  if not bOnAnalyze then
    -------------------------------------click meal----------------
    for n=1,#inventory do
      local myMeal=inventory[n]
      
      if myMeal.sprite.bIsVisible  then
        
        local bCollideMeal=gameplayService.utils.checkCollision(myMeal.sprite.x,myMeal.sprite.y,myMeal.sprite.width,myMeal.sprite.height,x,y,1,1)
        
        local bCollideObject=false
        local bCollideFood=false
        
        local currentObject=gameplayService.objectManager.getCurrentObject()
        local currentFood=gameplayService.foodManager.getCurrentFood()
        
        if currentObject~=nil then
          
          bCollideObject=gameplayService.utils.checkCollision(myMeal.sprite.x,myMeal.sprite.y,myMeal.sprite.width,myMeal.sprite.height,currentObject.sprite.x,currentObject.sprite.y,currentObject.sprite.width,currentObject.sprite.height)
          
        end
          
        if currentFood~=nil then
          
          bCollideFood=gameplayService.utils.checkCollision(myMeal.sprite.x,myMeal.sprite.y,myMeal.sprite.width,myMeal.sprite.height,currentFood.x,currentFood.y,currentFood.width,currentFood.height)
          
        end
        
        if bCollideMeal then
        
          if not bCollideFood and not bCollideObject then
          
            if not bIsFinishMeal then
              bIsFinishMeal=true
            else
              bIsFinishMeal=false
            end
            
            return
          end
          
        end
        
      end
      
    end
  
  end
  
end


function MealManager.mousemoved(x,y)
  
  for n=#lstTicket,1,-1 do
    local myTicket=lstTicket[n]
    
    local bCollideTicket=gameplayService.utils.checkCollision(x,y,1,1,myTicket.x,myTicket.y,myTicket.width,myTicket.height)
    
    if bCollideTicket then
      myTicket.bIsSelect=true
    else
      myTicket.bIsSelect=false
    end
    
  end
  
end


return MealManager