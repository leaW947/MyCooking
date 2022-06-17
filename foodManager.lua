local FoodManager={}

local gameplayService=nil

local inventory={}
local lstFood={}

local currentFood=nil
local currentFoodCook=nil

local nbFood={}

local sndSaucepan=nil
local sndpan=nil

local nbFoodNum=0

local function addFoodInv(pType,pCategory,pSprite)
  
  local myFoodInv={}
  
  myFoodInv.type=pType
  myFoodInv.category=pCategory
  
  myFoodInv.currentState="no_select"
  myFoodInv.sprite=pSprite
  
  table.insert(inventory,myFoodInv)
  
end


local function addFood(pType,pCategory,pSprite,pNum)
  
  local myFood={}
  
  myFood.type=pType
  myFood.category=pCategory
  myFood.sprite=pSprite
  myFood.sprite.bIsVisible=false
  
  myFood.num=pNum
  
  myFood.timerSpeed=3
  myFood.timer=myFood.timerSpeed
  
  myFood.state={}
  myFood.state.none="NONE"
  myFood.state.none="MOVE"
  myFood.state.stop="STOP"
  myFood.state.cook="COOK"
  myFood.state.baked="BAKED"
  myFood.state.cut="CUT"
  myFood.state.peel="PEEL"
  
  myFood.currentState="NONE"
  myFood.oldCurrentState=""
  
  table.insert(lstFood,myFood)
  
end


local function getLstNameFood(pLevel)
  
  local lstNameFood={}
  
  if pLevel==1 then
    
    lstNameFood={"tomato","carrot","carrotPeel","onion","onionPeel","water","crouton"}
    
  elseif pLevel==2 then
    
    lstNameFood={"apple","applePeel","banana","bananaPeel","strawberries","pear","pearPeel","maple_syrup"}
    
  elseif pLevel==3 then
    
    lstNameFood={"salad","tomato","onion","onionPeel","chicken","saladCheese"}
    
  elseif pLevel==4 then
    
    lstNameFood={"hotdogBread","sausage","pepper","ketchup","mustard"}
    
  elseif pLevel==5 then
    
    lstNameFood={"burgerBread","steak","tomato","salad","burgerCheese"}
    
  end
  
  return lstNameFood
end


local function initCurrentFood(pType,pSprite,pNum)
  
  local myCurrentFood={}
  
  myCurrentFood.type=pType
  
  myCurrentFood.num=pNum
  
  myCurrentFood.bIsVisible=true
  
  myCurrentFood.x=pSprite.x
  myCurrentFood.y=pSprite.y
  
  myCurrentFood.width=pSprite.width
  myCurrentFood.height=pSprite.height
  
  myCurrentFood.scaleX=pSprite.scaleX
  myCurrentFood.scaleY=pSprite.scaleY
  
  myCurrentFood.img=pSprite.img
  
  myCurrentFood.lstImage=pSprite.lstImage
  myCurrentFood.currentFrame=pSprite.currentFrame
  
  return myCurrentFood
  
end


local function getFoodCategory(pType)
  
  local category=""
  
  ------------bread
  if pType=="burgerBread" or pType=="hotdogBread" or pType=="crouton" then          
    category="bread"
  
  -----raw_vegetable
  elseif pType=="tomato" or pType=="salad" or pType=="carrot" or 
        pType=="onion" or pType=="pepper" then

    category="raw_vegetable"
  
  ------------fruit
  elseif pType=="banana" or pType=="apple" or pType=="strawberries" or pType=="pear" then
    
    category="fruit"
  
  -----------meat
  elseif pType=="steak" or pType=="chicken" or pType=="sausage" then
    category="meat"
  
  
  ----------cheese
  elseif pType=="saladCheese" or pType=="burgerCheese" then
    category="cheese"
  
  
  ---------------sauce
  elseif pType=="maple_syrup" or pType=="ketchup" or pType=="mustard" then
    category="sauce"
    
  elseif pType=="water" then
    category="water"
  end
  
  return category
  
end

local function initInventory(pLevel)
  
  local imgInv=gameplayService.assetManager.getImage("images/food/foodInv.png")
  local nbImgInv=(imgInv:getWidth()/32)*(imgInv:getHeight()/32)
  
  local lstNameFoodImg={"burgerBread","hotdogBread","crouton","steak","sausage","chicken","tomato","salad","onion","pepper","carrot","burgerCheese","saladCheese","","","banana","pear","apple","strawberries","","ketchup","mustard","maple_syrup","water",""}
  
  local lstNameFoodInv=getLstNameFood(pLevel)
  
  local x=20
  local y=gameplayService.screenHeight-((gameplayService.screenHeight/4))+5
  
  local nbSauce=0
  
  ---------------img inventory
  for n=1,nbImgInv do
    
    -------------name food inventory
    for i=1,#lstNameFoodInv do
      local nameFood=lstNameFoodInv[i]
      
      if lstNameFoodImg[n]==nameFood then
        
        local category=getFoodCategory(nameFood)
        local sprFoodInv=gameplayService.sprite.create(imgInv,x,y)
        
        if category=="sauce" or category=="water" then
          
          sprFoodInv.setScale(3,3)
          
          sprFoodInv.x=(gameplayService.screenWidth-(gameplayService.screenWidth/3))+(nbSauce*(32))
          sprFoodInv.y=gameplayService.screenHeight/2+(nbSauce*32)
          
          
          nbSauce=nbSauce+1
          
        else
          sprFoodInv.setScale(2.2,2.2)
        end
        
        sprFoodInv.addAnimation("",32,32,{n},0,false)
        sprFoodInv.startAnimation("")
        
        nbFood[nameFood]=1
        
        addFoodInv(nameFood,category,sprFoodInv)
        
        x=x+(32*sprFoodInv.scaleX)
        
      end
    
    end
  
  end
  
end


local function initFood(pType)
  
  local img=gameplayService.assetManager.getImage("images/food/food.png")
  local nbFoodImg=math.floor((img:getWidth()/30)*(img:getHeight()/25))
  
  local lstNameFoodImg={"burgerBread","hotdogBread","crouton","steak","chicken","sausage","burgerCheese","saladCheese","tomato","salad","pepper","onionPeel","onion","carrotPeel","carrot","bananaPeel","banana","pearPeel","pear","applePeel","apple","strawberries","ketchup","mustard","maple_syrup"}
  
  local numFood=nil
  
  ------------------img food
  for n=nbFoodImg,1,-1 do
  
    if lstNameFoodImg[n]==pType or lstNameFoodImg[n]==pType.."Peel" then
      
      local sprFood=gameplayService.sprite.create(img,0,0)
      sprFood.setScale(2,2)
        
      sprFood.addAnimation("",38,32,{n},0,false)
      sprFood.startAnimation("")
        
      local category=getFoodCategory(lstNameFoodImg[n])
      
      nbFoodNum=nbFoodNum+1
      addFood(lstNameFoodImg[n],category,sprFood,nbFoodNum)
      
      if lstNameFoodImg[n]==pType then
        numFood=nbFoodNum
      end
    
    end
    
  end
  
  return numFood
  
end




function FoodManager.load(pGameplayService)
  
  gameplayService=pGameplayService
  
  inventory={}
  lstFood={}

  currentFood=nil
  currentFoodCook=nil
  
  nbFoodNum=0
  nbFood={}
  
  initInventory(gameplayService.currentLevel)
  
  
  sndSaucepan=gameplayService.assetManager.getSound("sounds/eauQuiBout.wav")
  sndpan=gameplayService.assetManager.getSound("sounds/cuisson.wav")
  
end


function FoodManager.getFoodInv(pType)
  
  for n=1,#inventory do
    local myFoodInv=inventory[n]
    
    if myFoodInv.type==pType then
      return myFoodInv
    end
    
  end
  
  return nil
  
end


function FoodManager.getFood(pType,pCategory,pState,pNum)
  
  local food=nil
  
  for n=#lstFood,1,-1 do
    local myFood=lstFood[n]
    
    if pCategory=="" and pType~="" and pNum==nil then
      
      if pState=="" then
        
        ------------type------------
        if myFood.type==pType then
          food=myFood
        end
      
      else
        
        ------------type------------
        if myFood.type==pType and myFood.currentState==pState then
          food=myFood
        end
      
      end
      
    elseif pType=="" and pCategory~="" and pNum==nil then
      
      if pState=="" then
        
        ---------------category------------
        if myFood.category==pCategory then
          food=myFood
        end
      
      else
        
         ---------------category------------
        if myFood.category==pCategory and myFood.currentState==pState then
          food=myFood
        end
        
      end
  
    elseif pType=="" and pCategory=="" and pNum~=nil then
      
      if pState=="" then
        
        ------------num---------------
        if myFood.num==pNum then
          food=myFood
        end
        
      else
        
        ------------num---------------
        if myFood.num==pNum and myFood.currentState==pState then
          food=myFood
        end
        
      end
      
    end
    
  end
  
  
  return food
end


function FoodManager.getListFood(pLevel,pState,pFutureState)
  
  local lstFood={}
  
  ------------------------------------------LEVEL1--------------
  -----------------------------------------------------------
  if pLevel==1 then
    
    --------------------CUT-------
    if pState=="CUT" then
      
      ----------------------FUTURE STATE==BAKED-------------------
      if pFutureState=="BAKED" then
        
        lstFood={"tomato","carrot","onion"}
      
      ----------------------FUTURE STATE==STOP-------------------
      elseif pFutureState=="STOP" then
        
        lstFood={"crouton"}
        
      end
    
    --------------------------BAKED--------------
    elseif pState=="BAKED" then
      
      ---------------FUTURE STATE==STOP-----------
      if pFutureState=="STOP" then
        lstFood={"tomato","carrot","onion"}
      end
      
    end
  
  ----------------------------LEVEL 2-------------------------
  ------------------------------------------------------------
  elseif pLevel==2 then
    
    ---------------------CUT---------
    if pState=="CUT" then
      
      ----------------FUTURE STATE==STOP-----------
      if pFutureState=="STOP" then
        lstFood={"banana","strawberries","apple","pear"}
      end
      
    end
  
  ---------------------------------LEVEL 3----------------
  --------------------------------------------------
  elseif pLevel==3 then
    
    --------------------------CUT---------------
    if pState=="CUT" then
      
      --------------------------FUTURE STATE==STOP-------------
      if pFutureState=="STOP" then
        lstFood={"tomato","salad","onion","saladCheese"}
      
      ------------------FUTURE STATE==BAKED-----------
      elseif pFutureState=="BAKED" then
        lstFood={"chicken"}
      end
      
    ----------------------------BAKED-------------
    elseif pState=="BAKED" then
    
      --------------------------------FUTURE STATE==STOP
      if pFutureState=="STOP" then
        lstFood={"chicken"}
      end
      
    end
  
  --------------------------------------------LEVEL 4---------------------
  --------------------------------------------------------------------------
  elseif pLevel==4 then
    
    -------------------------------CUT------------
    if pState=="CUT" then
      
      ---------------------------FUTURE STATE==STOP---------------
      if pFutureState=="BAKED" then
        lstFood={"pepper"}
      end
    
    -----------------------------BAKED-----------
    elseif pState=="BAKED" then
      
      -----------------------FUTURE STATE==STOP-----------
      if pFutureState=="STOP" then
        lstFood={"sausage","pepper"}
      end
    end
  
  
  -------------------------------------------LEVEL 5-------------------
  --------------------------------------------------------------------
  elseif pLevel==5 then
    
    ---------------------------------------CUT-------------
    if pState=="CUT" then
      
      --------------------------------FUTURE STATE==STOP-----------
      if pFutureState=="STOP" then
        lstFood={"salad","tomato"}
      end
    
    ---------------------------------BAKED-----------------
    elseif pState=="BAKED" then
      
      ---------------------------------FUTURE STATE==STOP--------------
      if pFutureState=="STOP" then
        lstFood={"steak"}
      end
      
    end
  
  end
  
  
  return lstFood
end


function FoodManager.deleteFood(pNumFood)
  
  for n=#lstFood,1,-1 do
    local myFood=lstFood[n]
    
    if myFood.num==pNumFood then
      table.remove(lstFood,n)
    end
    
  end

end


function FoodManager.resetVisible()
  
  for n=#lstFood,1,-1 do
    
    local myFood=lstFood[n]
    
    if myFood.currentState==" " or myFood.currentState=="STOP" then
      myFood.sprite.bIsVisible=false
    end
    
  end
  
end


function FoodManager.setPosOnObject(pObject,pFood)
  
  if pFood~=nil and pObject~=nil then
    
    if pObject.type=="pan"then
      
      pFood.sprite.x=pObject.sprite.x+((pObject.sprite.width/2)-(pFood.sprite.width/2))-10
      pFood.sprite.y=pObject.sprite.y+((pObject.sprite.height/2)-(pFood.sprite.height/2))+5
      
    elseif pObject.type=="cutting_board" then
      
      pFood.sprite.x=pObject.sprite.x+((pObject.sprite.width/2)-(pFood.sprite.width/2))
      pFood.sprite.y=pObject.sprite.y+((pObject.sprite.height/2)-(pFood.sprite.height/2))
      
    elseif pObject.type=="plate" then
      
      pFood.sprite.x=pObject.sprite.x+((pObject.sprite.width/2)-(pFood.sprite.width/2))
      pFood.sprite.y=pObject.sprite.y+((pObject.sprite.height/2)-(pFood.sprite.height/2))
      
    elseif pObject.type=="bowl" then
      
      pFood.sprite.x=pObject.sprite.x+((pObject.sprite.width/2)-(pFood.sprite.width/2))
      pFood.sprite.y=pObject.sprite.y+((pObject.sprite.height/2)-(pFood.sprite.height/2))
      
    end
    
  end
  
end


function FoodManager.getCurrentFood()
  
  return currentFood
  
end

function FoodManager.getCurrentFoodCook()

  return currentFoodCook

end


function FoodManager.update(dt)
  
  -------------------------------food-----------------------
  for n=#lstFood,1,-1 do
    
    local myFood=lstFood[n]
    
    ------------------------------stop---------
    if myFood.currentState=="STOP" then
      gameplayService.mealManager.addIngredient(myFood.type)
      myFood.currentState=" "
      
      if myFood.category=="raw_vegetable" and gameplayService.currentLevel==1 then
        gameplayService.mealManager.addIngredient("water")
      end
      
    end
    
    if myFood.category=="meat" and myFood.currentState=="COOK" and myFood.sprite.bIsVisible then
      
      ----------------animation
      myFood.timer=myFood.timer-dt
      
      -------------trail object
      local object=gameplayService.objectManager.getObject("pan")
      
      if object~=nil then
        love.audio.play(sndpan)
        gameplayService.objectManager.addTrail(object)
      end
      
      
      if myFood.timer<=0 then
        
        love.audio.stop(sndpan)
        myFood.timer=myFood.timerSpeed
        myFood.currentState=myFood.state.baked
        
      end
    
    elseif myFood.category=="raw_vegetable" and myFood.currentState=="COOK" and (myFood.sprite.bIsVisible or myFood.oldCurrentState=="CUT") then
      
      myFood.timer=myFood.timer-dt
        
        -------------trail object
      local object=gameplayService.objectManager.getObject("saucepan")
      
      if object==nil then
        object=gameplayService.objectManager.getObject("pan")
      end
      
      if object~=nil then
        
        if object.type=="pan" then
          
          love.audio.play(sndpan)
        
        elseif object.type=="saucepan" then
          
          love.audio.play(sndSaucepan)
        
        end
        
        gameplayService.objectManager.addTrail(object)
      end
      
        
      if myFood.timer<=0 then
        myFood.timer=myFood.timerSpeed
        myFood.currentState=myFood.state.baked
        
        
        if object~=nil and object.type=="saucepan" then
          
          love.audio.stop(sndSaucepan)
          
          if myFood.type=="tomato" then
            object.sprite.currentFrame=2
          elseif myFood.type=="onion" then
            object.sprite.currentFrame=4
          elseif myFood.type=="carrot" then
            object.sprite.currentFrame=3
          end
        
        elseif object~=nil and object.type=="pan" then
          love.audio.stop(sndpan)
        end
        
      end
    
    end
  
    ---------------------------food cut-----------
    if myFood.currentState=="CUT" then
      
      local foodPeel=FoodManager.getFood(tostring(myFood.type).."Peel","","",nil)
    
      if foodPeel~=nil then
        foodPeel.sprite.bIsVisible=false
      end
      
      myFood.sprite.bIsVisible=true
      currentFoodCook=nil
    
    ----------------------food peel---------------
    elseif myFood.currentState=="PEEL" then
      
      local foodPeel=FoodManager.getFood(tostring(myFood.type).."Peel","","",nil)
    
      if foodPeel~=nil then
        foodPeel.sprite.x=myFood.sprite.x
        foodPeel.sprite.y=myFood.sprite.y
        
        foodPeel.sprite.bIsVisible=true
      end
      
      myFood.sprite.bIsVisible=false
      currentFoodCook.bIsVisible=false
      
    end
    
  end
  
  ---------------------------current food---------------
  if currentFood~=nil then
  
    local bCollideRectCancel=gameplayService.utils.checkCollision(gameplayService.rectCancel.sprite.x,gameplayService.rectCancel.sprite.y,gameplayService.rectCancel.sprite.width,gameplayService.rectCancel.sprite.height,currentFood.x+(currentFood.width/3),currentFood.y+(currentFood.height/3),currentFood.width/3,currentFood.height/3)
  
    if bCollideRectCancel then
      gameplayService.rectCancel.bIsOpen=true
      gameplayService.rectCancel.sprite.currentFrame=2
      
      local foodInv=FoodManager.getFoodInv(currentFood.type)
      
      if foodInv~=nil then
        foodInv.currentState="no_select"
      end
      
      FoodManager.deleteFood(currentFood.num)

      currentFood=nil
      
      return
      
    end
  
  end
  
end

function FoodManager.drawFoodInventory()
  
  ----------------------inventory
  for n=1,#inventory do
    local myFoodInv=inventory[n]
    
    if myFoodInv.currentState=="select" then
      myFoodInv.sprite.color={0.5,0.5,0.5}
    else
      myFoodInv.sprite.color={1,1,1,1}
    end
    
    myFoodInv.sprite.draw()
  end
  
end

function FoodManager.drawFoodMove()
    
    ----------------------------current food--------------  
  if currentFood~=nil then
    love.graphics.draw(currentFood.img,currentFood.lstImage[math.floor(currentFood.currentFrame)],currentFood.x,currentFood.y,0,currentFood.scaleX,currentFood.scaleY)
  end
        
  
end

function FoodManager.draw()
  
  -----------------food------------
  for n=1,#lstFood do
    local myFood=lstFood[n]
    
    if (myFood.category=="meat" or myFood.type=="pepper") and myFood.currentState=="COOK" then

      local color=(myFood.timer/myFood.timerSpeed)
      
      if color<0.8 then
        color=0.8
      end
      
      myFood.sprite.color={color,color,color}
  
    end
  
    myFood.sprite.draw()
  
  end
  
  --------------------------currentFoodCook-----------
  if currentFoodCook~=nil then
      
    if currentFoodCook.bIsVisible then
      
      love.graphics.draw(currentFoodCook.img,currentFoodCook.lstImage[math.floor(currentFoodCook.currentFrame)],currentFoodCook.x,currentFoodCook.y,0,currentFoodCook.scaleX,currentFoodCook.scaleY)
      
    end
    
  end
  
end


local function stateFood()
 
  local food=FoodManager.getFood("","","",currentFood.num)
  local foodInv=FoodManager.getFoodInv(currentFood.type)
  local newCurrentState=""
  local object=nil
  
  if food~=nil then
    --------------------------------------------STATE NONE----------------------
    if food.currentState=="NONE" then
      
      --------------------------------BREAD---------------------
      if food.category=="bread" then
        
        if food.type~="crouton" then
          
          newCurrentState=food.state.stop
          object=gameplayService.objectManager.getObject("plate")
          
        else
          
          newCurrentState=food.state.cook
          object=gameplayService.objectManager.getObject("cutting_board")
        end
      
      -------------------------------------RAW_VEGETABLE-----------------
      elseif food.category=="raw_vegetable" then
        
        newCurrentState=food.state.cook
        object=gameplayService.objectManager.getObject("cutting_board")
      
      -------------------------------------------FRUIT-------------------
      elseif food.category=="fruit" then
        
        newCurrentState=food.state.cook
        object=gameplayService.objectManager.getObject("cutting_board")
      
      -----------------------------------MEAT--------------------------
      elseif food.category=="meat" then
        
        newCurrentState=food.state.cook
        
        if food.type~="chicken" then
          object=gameplayService.objectManager.getObject("pan")
        else
          object=gameplayService.objectManager.getObject("cutting_board")
        end
  
      -------------------------------------CHEESE-----------------------
      elseif food.category=="cheese" then
        
        if food.type=="burgerCheese" then
          
          newCurrentState=food.state.stop
          object=gameplayService.objectManager.getObject("plate")
          
        else
        
          newCurrentState=food.state.cook
          object=gameplayService.objectManager.getObject("cutting_board")
        end
      
      elseif food.category=="sauce" then
        
        newCurrentState=food.state.stop
        
        if food.type=="ketchup" or food.type=="mustard" then
          object=gameplayService.objectManager.getObject("plate")
          
        elseif food.type=="maple_syrup" then
          object=gameplayService.objectManager.getObject("bowl")
        end
        
      end
  
    end

  end
  
  ------------------------------------WATER----------------------
  if food==nil then
    
    newCurrentState="STOP"
    
    if currentFood.type=="water" then
      object=gameplayService.objectManager.getObject("saucepan")
    end
    
  end
  

  ------------------------------collide with the object
  if object~=nil and object.food==nil and newCurrentState~="" then
 
    local bCollideObject=gameplayService.utils.checkCollision(currentFood.x,currentFood.y,currentFood.width,currentFood.height,object.sprite.x,object.sprite.y,object.sprite.width,object.sprite.height)
    
    if bCollideObject and object.bInShadow then
      
      local ingredient=gameplayService.mealManager.getIngredient(currentFood.type)
      
      if food==nil then
      
        -------------------------add water------------
        if currentFood.type=="water" then
          
          if object.sprite.currentFrame==5 then
            
            ----------------water in the saucepan
            object.sprite.currentFrame=1
            currentFood=nil
            
            if foodInv~=nil then
              foodInv.currentState="no_select"
            end
            
            return
          end
      
        end
      end
      
      if food~=nil then
        
        ----------------food visible
        if food.category~="raw_vegetable" and 
          food.type~="crouton" and 
          food.type~="chicken" and 
          food.type~="saladCheese" and
          food.category~="fruit" then
          
          
          if ingredient~=nil and (object.type=="plate" or object.type=="bowl") then
            
            if food.category~="meat" and food.type~="pepper" then
              return
            end
           
          end
          
          ----------------------food on object-------------------
          if food.category=="sauce" and ingredient~=nil then
            currentFood=nil
            return
          end
          
          if food.category=="meat" or food.type=="pepper" then
            object.food=food
          end
        
          food.currentState=newCurrentState
          FoodManager.setPosOnObject(object,food)
          
          food.sprite.bIsVisible=true
          currentFood=nil
          
          if foodInv~=nil then
            foodInv.currentState="no_select"
          end
          
          return
        
        else
         
          if foodInv~=nil then
            foodInv.currentState="no_select"
          end
         
          if currentFoodCook==nil then
            
            object.food=food
            
            ----------------------food on object-------------------
            food.currentState=newCurrentState
            FoodManager.setPosOnObject(object,food)
          
            currentFoodCook=currentFood
            
            currentFoodCook.x=object.sprite.x+((object.sprite.width/2)-(currentFoodCook.width/2))
            currentFoodCook.y=object.sprite.y+((object.sprite.height/2)-(currentFoodCook.height/2))
            
           
            currentFood=nil
            
            return
          end
  
        end
        
      end
  

    end
  
  end
  
end


function FoodManager.mousepressed(x,y,btn)
  
  if btn==1 then
    
    local currentObject=gameplayService.objectManager.getCurrentObject()
    
    ----------------inventory---------------
    for n=1,#inventory do
      local myFoodInv=inventory[n]
      
      local bCollideInventory=false
      
      if myFoodInv.type~="ketchup" and myFoodInv.type~="mustard"  then
        
        bCollideInventory=gameplayService.utils.checkCollision(x,y,1,1,myFoodInv.sprite.x,myFoodInv.sprite.y,myFoodInv.sprite.width,myFoodInv.sprite.height)
        
      else
        
        bCollideInventory=gameplayService.utils.checkCollision(x,y,1,1,myFoodInv.sprite.x+(myFoodInv.sprite.width/5),myFoodInv.sprite.y+5,myFoodInv.sprite.width/3,myFoodInv.sprite.height)
        
      end
      
      if bCollideInventory and currentObject==nil then
        
        if myFoodInv.currentState=="no_select" and currentFood==nil then
          myFoodInv.currentState="select"
    
          local numFood=initFood(myFoodInv.type)
          currentFood=initCurrentFood(myFoodInv.type,myFoodInv.sprite,numFood)
          
        else
          
          -----------------reset select-----
          if (myFoodInv.category=="sauce" or myFoodInv.category=="water") and currentObject==nil then
            
            if myFoodInv.type==currentFood.type then
              
              myFoodInv.currentState="no_select"
              currentFood=nil
              return
              
            end
            
          end
        
        end
        
      end
      
    end
    
    
    ----------------------------currentFood------------
    if currentFood~=nil and currentObject==nil then
      stateFood()
    end
    
  end
  
end

function FoodManager.mousemoved(x,y)
  
  if currentFood~=nil then
    
    currentFood.x=x-(currentFood.width/2)
    currentFood.y=y-(currentFood.height/2)
    
  end
  
end


return FoodManager