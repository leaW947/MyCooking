local ObjectManager={}

local gameplayService=nil

local inventory={}
local lstObject={}
local lstShadow={}

local currentObject=nil

function ObjectManager.addTrail(pObject)
  
  local myTrail={}
  
  if pObject.type=="pan" then
    
    myTrail.x=math.random(pObject.sprite.x+16,pObject.sprite.x+(pObject.sprite.width-32))
    myTrail.y=math.random((pObject.sprite.y+(pObject.sprite.height/2))-30,(pObject.sprite.y+(pObject.sprite.height/2)))
  
  elseif pObject.type=="saucepan" then 
    
    myTrail.x=math.random(pObject.sprite.x,pObject.sprite.x+(pObject.sprite.width-32))
    myTrail.y=math.random((pObject.sprite.y+(pObject.sprite.height/2))-20,(pObject.sprite.y+(pObject.sprite.height/2))-50)
  end
  
  myTrail.vx=0
  myTrail.vy=math.random(-0.5,-4)
  
  myTrail.nbLives=math.random(0.5,1)
  myTrail.maxLives=myTrail.nbLives
  
  myTrail.color={0.8,0.8,0.8}

  myTrail.radius=math.random(5,10)
  
  table.insert(pObject.lstTrail,myTrail)
  
end


local function addObject(pType,pSprite)
  
  local myObject={}
  myObject.sprite=pSprite
  myObject.type=pType
  
  myObject.initialX=0
  myObject.initialY=0
  
  myObject.food=nil
  
  myObject.timerSpeedAnimation=5
  myObject.timerSpeed=myObject.timerSpeedAnimation/10
  
  myObject.timerAnimation=0
  myObject.timer=0
  
  myObject.lstTrail={}
  
  myObject.state={}
  myObject.state.none="NONE"
  myObject.state.move="MOVE"
  myObject.state.cut="CUT"
  myObject.state.peel="PEEL"
  
  myObject.currentState="NONE"
  
  myObject.bInShadow=false

  table.insert(lstObject,myObject)
  
end


local function addObjectInv(pType,pSprite)
  
  local myObjectInv={}
  myObjectInv.currentState="no_select"
  myObjectInv.sprite=pSprite
  myObjectInv.type=pType

  
  table.insert(inventory,myObjectInv)
end


local function addShadow(pType,pSprite)
  
  local myShadow={}
  
  myShadow.sprite=pSprite
  myShadow.type=pType
  
  myShadow.bIsFull=false
  
  table.insert(lstShadow,myShadow)
end


local function getLstNameObject(pLevel)
  
  local lstNameObject={}
  
  if pLevel==1 then
    
    lstNameObject={"cutting_board","knife","bowl","peeler","saucepan"}
    
  elseif pLevel==2 then
    
    lstNameObject={"cutting_board","knife","bowl","peeler"}
    
  elseif pLevel==3 then
  
    lstNameObject={"cutting_board","knife","bowl","peeler","pan"}
  
  elseif pLevel==4 then
  
    lstNameObject={"plate","pan","cutting_board","knife"}
  
  elseif pLevel==5 then
  
    lstNameObject={"plate","pan","cutting_board","knife"}
  
  end
  
  return lstNameObject
end


local function initShadow(pLevel)
  
  local imgShadow=gameplayService.assetManager.getImage("images/objects/shadowObject.png")
  local nbObjectImgShadow=(imgShadow:getWidth()/64)*(imgShadow:getHeight()/64)
  
  local lstNameObjectImgShadow={"plate","pan","cutting_board","bowl","saucepan"}
  
  local lstNameObject=getLstNameObject(pLevel)
  
  ---------img shadow
  for n=1,nbObjectImgShadow do
    
    for i=1,#lstNameObject do
      local nameShadow=lstNameObject[i]
      
      if nameShadow==lstNameObjectImgShadow[n] then
        
        local sprShadow=gameplayService.sprite.create(imgShadow,0,0)
        sprShadow.setScale(2,2)
        
        sprShadow.addAnimation("",64,64,{n},0,false)
        sprShadow.startAnimation("")
      
        ------------positions---------
        if nameShadow=="plate" or nameShadow=="bowl" then
          
          sprShadow.x=50
          sprShadow.y=(gameplayService.screenHeight/2)+15
          
        elseif nameShadow=="pan" or nameShadow=="saucepan" then
          
          sprShadow.x=(gameplayService.screenWidth/2)
          sprShadow.y=(gameplayService.screenHeight/2)+15
          
        elseif nameShadow=="cutting_board" then
          
          sprShadow.x=(gameplayService.screenWidth/4)+30
          sprShadow.y=(gameplayService.screenHeight/2)+15
          
        end
        
        addShadow(nameShadow,sprShadow)
        
      end
    end
    
  end
  
end


local function initObject(pLevel)
  
  local img=gameplayService.assetManager.getImage("images/objects/objects.png")
  local nbObjectImg=(img:getWidth()/64)*(img:getHeight()/64)

  local lstNameObjectImg={"plate","pan","cutting_board","knife","bowl","peeler"}
  
  local lstNameObject=getLstNameObject(pLevel)
  
  local x=(gameplayService.screenWidth/2)+(gameplayService.screenWidth/9)
  local y=gameplayService.screenHeight-(gameplayService.screenHeight/4)+40
  
  ------------------------img object
  for n=1,nbObjectImg do
  
    ---------------------name object
    for i=1,#lstNameObject do
      local nameObject=lstNameObject[i]
      
      if nameObject==lstNameObjectImg[n] then
        
        local sprObject=gameplayService.sprite.create(img,0,0)
        sprObject.setScale(2,2)
      
        sprObject.addAnimation("",64,64,{n},0,false)
        sprObject.startAnimation("")
      
        
        sprObject.bIsVisible=false
        
        addObject(nameObject,sprObject)
      
      elseif nameObject=="saucepan" then
        
        local imgSaucepan=gameplayService.assetManager.getImage("images/objects/saucepan.png")
        
        local sprObject=gameplayService.sprite.create(imgSaucepan,0,0)
        sprObject.setScale(2,2)
      
        sprObject.addAnimation("",64,64,{1,2,3,4,5},0,false)
        sprObject.startAnimation("")
        
        sprObject.currentFrame=5
        
        sprObject.bIsVisible=false
        
        addObject(nameObject,sprObject)
        
      
      end
      
    end
  end
  
end


local function initInventory(pLevel)
  
  local imgInv=gameplayService.assetManager.getImage("images/objects/objectsInv.png")
  local nbObjectImgInv=(imgInv:getWidth()/32)*(imgInv:getHeight()/32)

  local lstNameObjectImgInv={"plate","pan","knife","cutting_board","bowl","peeler","saucepan"}
  
  local lstNameObjectInv=getLstNameObject(pLevel)
  
  local x=(gameplayService.screenWidth/2)
  local y=gameplayService.screenHeight-(gameplayService.screenHeight/4)+65
  
  ------------------------img inventory
  for n=1,nbObjectImgInv do
  
    ---------------------name object
    for i=1,#lstNameObjectInv do
      local nameObjectInv=lstNameObjectInv[i]
      
      if lstNameObjectImgInv[n]==nameObjectInv then
        
        local sprObjectInv=gameplayService.sprite.create(imgInv,x,y)
        sprObjectInv.setScale(2,2)
        
        sprObjectInv.addAnimation("",32,32,{n},0,false)
        sprObjectInv.startAnimation("")
      
        addObjectInv(nameObjectInv,sprObjectInv)
        
        
        x=x+(32*2)
      end
      
    end
  
  end
  
end


function ObjectManager.load(pGameplayService)
  gameplayService=pGameplayService
  
  inventory={}
  lstObject={}
  lstShadow={}
  
  currentObject=nil
  
  initInventory(gameplayService.currentLevel)
  initObject(gameplayService.currentLevel)
  initShadow(gameplayService.currentLevel)

end

function ObjectManager.getShadow(pType)
  
  for n=1,#lstShadow do
    local myShadow=lstShadow[n]
  
    if myShadow.type==pType then
      return myShadow
    end
  
  end
  
  return nil
end

function ObjectManager.getObject(pType)
  
  for n=1,#lstObject do
    local myObject=lstObject[n]
    
    if myObject.type==pType then
      return myObject
    end
    
  end
  
  return nil
end


function ObjectManager.getObjectInv(pType)
  
  for n=1,#inventory do
    local myObjectInv=inventory[n]
  
    if myObjectInv.type==pType then
      return myObjectInv
    end
  
  end
  
  return nil
  
end


local function getShadow(pType)
  
  for n=1,#lstShadow do
    local myShadow=lstShadow[n]
    
    if myShadow.type==pType then
      return myShadow
    end
    
  end
  
  return nil
end


function ObjectManager.getCurrentObject()
  
  return currentObject
  
end


function ObjectManager.update(dt)
  
   
  for n=1,#lstObject do
    local myObject=lstObject[n]
    
    ----------------trail 
    if #myObject.lstTrail>0 then
      
      for i=#myObject.lstTrail,1,-1 do
        local myTrail=myObject.lstTrail[i]
        
        myTrail.x=myTrail.x+myTrail.vx*60*dt
        myTrail.y=myTrail.y+myTrail.vy*60*dt
        
        myTrail.nbLives=myTrail.nbLives-dt
      
        if myTrail.nbLives<=0 then
          table.remove(myObject.lstTrail,i)
        end
      
      end
      
    end
    
    -------------------------animation cut with the knife
    if myObject.type=="knife" and myObject.currentState=="CUT" then
      
      if myObject.timerAnimation<myObject.timerSpeedAnimation then
        
        myObject.timer=myObject.timer+dt
         
        if myObject.timer>=myObject.timerSpeed then
          myObject.timerAnimation=myObject.timerAnimation+myObject.timer
          myObject.timer=0
          
          
          if myObject.sprite.rotation==math.rad(-30) then
            myObject.sprite.rotation=0
          else
            myObject.sprite.rotation=math.rad(-30)
          end
        
        end
      end
      
      -------------------------animation finish--------------
      if myObject.timerAnimation>=myObject.timerSpeedAnimation then
        
        myObject.timer=0
        myObject.timerAnimation=0
        
        local objectInv=ObjectManager.getObjectInv(myObject.type)
        
        if objectInv~=nil then
          objectInv.currentState="no_select"
          
          myObject.currentState=myObject.state.none
          myObject.sprite.bIsVisible=false
          
          myObject.sprite.rotation=0
          
          myObject.sprite.x=0
          myObject.sprite.y=0
          
          local food=gameplayService.foodManager.getFood(myObject.food.type,"")
          
          if food~=nil then
            food.currentState=food.state.cut
          end
    
          myObject.food=nil
          
        end
        
      end
      
    -----------------------------animation peel with the peeler
    elseif myObject.type=="peeler" and myObject.currentState=="PEEL" then
      
      if myObject.timerAnimation<myObject.timerSpeedAnimation then
      
        myObject.timer=myObject.timer+dt
        
        if myObject.timer>=myObject.timerSpeed then
          
          myObject.timerAnimation=myObject.timerAnimation+myObject.timer
          myObject.timer=0
          
          if myObject.sprite.y==myObject.initialY then
            myObject.sprite.y=myObject.sprite.y+50
          else
            myObject.sprite.y=myObject.initialY
          end
          
        end
        
      end
      
      
      --------------------------finish animation-----------
      if myObject.timerAnimation>=myObject.timerSpeedAnimation then
        myObject.timer=0
        myObject.timerAnimation=0
        
        local objectInv=ObjectManager.getObjectInv(myObject.type)
        
        if objectInv~=nil then
       
          objectInv.currentState="no_select"
          
          myObject.currentState=myObject.state.none
          myObject.sprite.bIsVisible=false
          
          myObject.initialY=0
          myObject.initialX=0
          
          myObject.sprite.x=0
          myObject.sprite.y=0
          
          local food=gameplayService.foodManager.getFood(myObject.food.type,"")
          
          if food~=nil then
            food.currentState=food.state.peel
          end
          
          myObject.food=nil
        end
        
        
      end
      
    end
    
  end
  
  ------------------------------current object---------------
  if currentObject~=nil then 
    
    if currentObject.type~="knife" and currentObject.type~="peeler" then
      
      if currentObject.currentState~="NONE" and currentObject.food~=nil then
        
        local bCollideRectCancel=gameplayService.utils.checkCollision(gameplayService.rectCancel.sprite.x,gameplayService.rectCancel.sprite.y,gameplayService.rectCancel.sprite.width,gameplayService.rectCancel.sprite.height,currentObject.sprite.x,currentObject.sprite.y,currentObject.sprite.width,currentObject.sprite.height)
      
        if bCollideRectCancel then
          
          gameplayService.rectCancel.bIsOpen=true
          gameplayService.rectCancel.sprite.currentFrame=2
          
          ----delete food
          if currentObject.food~=nil then
            
            local food=gameplayService.foodManager.getFoodState(currentObject.food.currentState,currentObject.food.type,"")
          
            if food~=nil then
              gameplayService.foodManager.deleteFood(ingredient,currentObject.food.currentState)
            end
            
          end
          
          if currentObject.type=="saucepan" then
            
            currentObject.sprite.currentFrame=5
            gameplayService.mealManager.deleteIngredient("water")
          
          end
          
          gameplayService.foodManager.deleteFood(currentObject.food.type)
          currentObject.food=nil
          
          currentObject.currentState="NONE"
          
          currentObject.sprite.x=currentObject.initialX
          currentObject.sprite.y=currentObject.initialY
        
          currentObject=nil
          return
        end
        
      end
      
    end
    
  end
  
  
end

function ObjectManager.drawKnifeAndPeeler()
  
  for n=1,#lstObject do
    local myObject=lstObject[n]
    
    if myObject.type=="knife" or myObject.type=="peeler" then
      myObject.sprite.draw()
    end
  end
  
end


function ObjectManager.drawObjectMove()
  
  for n=1,#lstObject do
    local myObject=lstObject[n]
  
    if myObject.currentState=="MOVE" then
      myObject.sprite.draw()
      
      if myObject.food~=nil then
        myObject.food.sprite.draw()
      end
      
    elseif currentObject~=nil and currentObject.type==myObject.type then
      myObject.sprite.draw()
    end
    
  end
  
end


function ObjectManager.draw()
  
  ---------------------inventory
  for n=1,#inventory do
    local myObjectInv=inventory[n]
    
    if myObjectInv.currentState=="select" then 
      myObjectInv.sprite.color={0.5,0.5,0.5}
    else
      myObjectInv.sprite.color={1,1,1,1}
    end
    
    myObjectInv.sprite.draw()
  end
  
  -------------------------shadow-----------
  for n=1,#lstShadow do
    local myShadowObject=lstShadow[n]
    
    myShadowObject.sprite.draw()
    
  end
  
  -----------------object
  for n=#lstObject,1,-1 do
    local myObject=lstObject[n]
    
    if myObject.currentState~="MOVE" and myObject.type~="knife" and myObject.type~="peeler" and (currentObject==nil or currentObject.type~=myObject.type) then
      
      myObject.sprite.draw()

      ----------------------trail object------------------
      if #myObject.lstTrail>0 then
        
        for i=#myObject.lstTrail,1,-1 do
          local myTrail=myObject.lstTrail[i]
          
          local ratio=myTrail.nbLives/myTrail.maxLives
          
          love.graphics.setColor(myTrail.color[1],myTrail.color[2],myTrail.color[3],ratio)
          
          love.graphics.circle("fill",myTrail.x,myTrail.y,myTrail.radius)
          
          love.graphics.setColor(1,1,1,1)
          
        end
        
      end
      
    end
    
  end
  
end


local function stateObject(mx,my,pObject)
  
  local food=nil
  local foodInv=nil
  
  local object=pObject
  
  --------------------------------------------STATE NONE-------------------
  -------------------------------------------------------------------------
  if object.currentState=="NONE" then
    
    -------------------PAN-----------
    if object.type=="pan" then
      
      food=gameplayService.foodManager.getFood("","meat")
      
      if food==nil or food.currentState~="BAKED" then
        
        food=gameplayService.foodManager.getFood("pepper","")
      
      end
      
      if food~=nil and food.currentState=="BAKED" then
        
        local bCollideObject=gameplayService.utils.checkCollision(mx,my,1,1,object.sprite.x,object.sprite.y,object.sprite.width,object.sprite.height)
        
        if bCollideObject then
          
          object.currentState="MOVE"
          object.food=food
          
          currentObject=object
          return
        end
        
      end
    
    ------------------------SAUCEPAN -----------------
    elseif object.type=="saucepan" then
      
      food=gameplayService.foodManager.getFoodState("BAKED","","raw_vegetable")
      
      if food~=nil and object.sprite.currentFrame~=1 and object.sprite.currentFrame~=5 then
        
        local bCollideObject=gameplayService.utils.checkCollision(mx,my,1,1,object.sprite.x,object.sprite.y,object.sprite.width,object.sprite.height)
      
        if bCollideObject then
          
          object.currentState="MOVE"
          object.food=food
          
          currentObject=object
          
          return
        end
        
        
      end
    
    ---------------------------CUTTING_BOARD------------------
    elseif object.type=="cutting_board" then
      
      local lstFood={"tomato","salad","onion","carrot","crouton","saladCheese","strawberries","banana","apple","pear","pepper","chicken"}
      
      for n=1,#lstFood do
        
        local nameFood=lstFood[n]
        food=gameplayService.foodManager.getFoodState("CUT",nameFood,"")
        
        if food~=nil then
          
          local bCollideObject=gameplayService.utils.checkCollision(mx,my,1,1,object.sprite.x,object.sprite.y,object.sprite.width,object.sprite.height)
        
          if bCollideObject then
          
            object.currentState="MOVE"
            object.food=food
            
            currentObject=object
            
            return
          end
          
          
        end
        
      end
    
    
    ---------------------------------------------KNIFE---------------------------
    elseif object.type=="knife" then
      
      local lstFoodCook={"salad","tomato","pepper","strawberries","saladCheese","crouton","chicken"}
      local lstFoodPeel={"banana","apple","pear","onion","carrot"}
      
      local bCollide=false
      
      if food==nil and object.food==nil then
        
        -----------------------------food cook list
        for n=1,#lstFoodCook do
          local nameFoodCook=lstFoodCook[n]
          food=gameplayService.foodManager.getFoodState("COOK",nameFoodCook,"")
          
          if food~=nil then
              
            bCollide=gameplayService.utils.checkCollision(object.sprite.x,object.sprite.y,object.sprite.width,object.sprite.height,food.sprite.x,food.sprite.y,food.sprite.width,food.sprite.height)
            
            if bCollide then
              
              object.currentState=object.state.cut
              object.food=food
              currentObject=nil
           
              return
              
            end
            
          end
          
        end
        
        -----------------------food peel list
        for n=1,#lstFoodPeel do
          local nameFoodPeel=lstFoodPeel[n]
          food=gameplayService.foodManager.getFoodState("PEEL",nameFoodPeel,"")
  
          if food~=nil and object.food==nil then
            
            bCollide=gameplayService.utils.checkCollision(object.sprite.x,object.sprite.y,object.sprite.width,object.sprite.height,food.sprite.x,food.sprite.y,food.sprite.width,food.sprite.height)
            
            if bCollide then
            
              object.currentState=object.state.cut
              object.food=food
              currentObject=nil
              
              return
              
            end
            
          end
          
        end
        
      end
      
    -----------------------------------------------PEELER----------------------
    elseif object.type=="peeler" then
      
      local lstFood={"onion","apple","pear","banana","carrot"}
    
      for n=1,#lstFood do
        
        local foodName=lstFood[n]
        food=gameplayService.foodManager.getFoodState("COOK",foodName,"")

        --------------------peeler the food-------------------
        if food~=nil then
        
          local bCollideObject=gameplayService.utils.checkCollision(food.sprite.x,food.sprite.y,food.sprite.width,food.sprite.height,object.sprite.x,object.sprite.y,object.sprite.width,object.sprite.height)
          
          if bCollideObject then
            
            object.currentState=object.state.peel
            object.food=food
            
            object.initialY=object.sprite.y
            object.initialX=object.sprite.x
            
            currentObject=nil
            return
          end
          
        end
        
      end
    
    end
  
  ------------------------------------------------STATE MOVE-----------------------
  elseif object.currentState=="MOVE" then
    
    local otherObject=nil
    local newFoodState=""
    
    ---------------------------------------------------PAN && SAUCEPAN-------------
    if object.type=="pan" or object.type=="saucepan" then
      
      local lstFood=gameplayService.foodManager.getListFood(gameplayService.currentLevel,"BAKED","STOP")
      
      for n=1,#lstFood do
        local nameFood=lstFood[n]
        
        food=gameplayService.foodManager.getFoodState("BAKED",nameFood,"")
        
        if food~=nil then
          
          otherObject=gameplayService.objectManager.getObject("plate")
          
          if otherObject==nil then
            otherObject=gameplayService.objectManager.getObject("bowl")
          end
          
          newFoodState=food.state.stop
          break
          
        end
      end
      
    ---------------------------------------CUTTING_BOARD-----------
    elseif object.type=="cutting_board" then
    
      local lstFood1=gameplayService.foodManager.getListFood(gameplayService.currentLevel,"CUT","STOP")
      local lstFood2=gameplayService.foodManager.getListFood(gameplayService.currentLevel,"CUT","BAKED")
      
      -------------------stop food
      for n=1,#lstFood1 do
        local nameFood1=lstFood1[n]
        
        food=gameplayService.foodManager.getFoodState("CUT",nameFood1,"")
      
        if food~=nil then
          
          otherObject=gameplayService.objectManager.getObject("plate")
          
          if otherObject==nil then
            otherObject=gameplayService.objectManager.getObject("bowl")
          end
          
          newFoodState=food.state.stop
          
          break
          
        else
          food=nil
        end
        
      end
    
      if food==nil then
        ---------------------------------baked food-----------
        for n=1,#lstFood2 do
          local nameFood2=lstFood2[n]
          food=gameplayService.foodManager.getFoodState("CUT",nameFood2,"")
          
          if food~=nil then
            
            otherObject=gameplayService.objectManager.getObject("pan")
            
            if otherObject==nil then
              otherObject=gameplayService.objectManager.getObject("saucepan")
              
              if otherObject~=nil and otherObject.sprite.currentFrame~=1 then
                otherObject=nil
              end
              
            end
            
            newFoodState=food.state.cook
            break
          
          end
          
        end
      
      end
    
    end
    
    local bCollide=false
    
    if otherObject~=nil then
      
      bCollide=gameplayService.utils.checkCollision(object.sprite.x,object.sprite.y,object.sprite.width,object.sprite.height,otherObject.sprite.x,otherObject.sprite.y,otherObject.sprite.width,otherObject.sprite.height)
      
      if bCollide then
        ----------------stop food
        if otherObject.type~="saucepan" or otherObject.sprite.currentFrame~=5 then
          
          object.currentState="NONE"
          
          object.sprite.x=object.initialX
          object.sprite.y=object.initialY
          
          if food~=nil then
              
            food.currentState=newFoodState
            gameplayService.foodManager.setPosOnObject(otherObject,food)
          
            if otherObject.type=="saucepan" and otherObject.sprite.currentFrame==1 then
              
              food.oldCurrentState="CUT"
              food.sprite.bIsVisible=false
              
            end
            
            if object.type=="saucepan" then
              object.sprite.currentFrame=5
            end
            
          end
          
          object.food=nil
          currentObject=nil
          
          return
          
        end
      
      end
    
    end
    
    ---------------------STOP object
    if otherObject==nil or not bCollide then
      
      object.currentState="STOP"
 
      object.sprite.x=object.initialX
      object.sprite.y=object.initialY
      
      if food~=nil then
        gameplayService.foodManager.setPosOnObject(object,food)
      end
      
      currentObject=nil
      
      return
      
    end
  
  elseif object.currentState=="STOP" then
  
    local bCollideObject=gameplayService.utils.checkCollision(object.sprite.x,object.sprite.y,object.sprite.width,object.sprite.height,mx,my,1,1)
    
    if bCollideObject then
      object.currentState=object.state.move
      currentObject=object
      
      return
    
    end
  
  end
  
end


function ObjectManager.mousepressed(x,y,btn)
  
  if btn==1 then
    
      ------------------------inventory click-------------
      for n=1,#inventory do
        local myObjectInv=inventory[n]
        
        local object=ObjectManager.getObject(myObjectInv.type)
        
        if object~=nil then
          
          local bCollideInventory=gameplayService.utils.checkCollision(x,y,1,1,myObjectInv.sprite.x,myObjectInv.sprite.y,myObjectInv.sprite.width,myObjectInv.sprite.height)
          
          if bCollideInventory then
          
            if currentObject==nil  then
              
              if not object.bInShadow then
                myObjectInv.currentState="select"
                  
                currentObject=object
                
                currentObject.sprite.bIsVisible=true
                
                currentObject.sprite.x=x-(currentObject.sprite.width/2)
                currentObject.sprite.y=y-(currentObject.sprite.height/2)
                
                return
              end
              
            else
                
              if object.type=="knife" or object.type=="peeler" then
                
                if currentObject.type==object.type then
                  
                  currentObject=nil
                  
                  object.sprite.x=0
                  object.sprite.y=0
                  object.sprite.bIsVisible=false
                  
                  myObjectInv.currentState="no_select"
                  
                  return
                end
                
              end
                
            end
              
          end
          
          stateObject(x,y,object)
    
        end
        
      end
    
    
    --------------------------current object---------------
    
    if currentObject~=nil then
    -------------------------stop current object
      local shadow=getShadow(currentObject.type)
      
      if shadow~=nil then
        
        if not shadow.bIsFull then
          
          local bCollideShadow=gameplayService.utils.checkCollision(shadow.sprite.x,shadow.sprite.y,shadow.sprite.width,shadow.sprite.height,currentObject.sprite.x,currentObject.sprite.y,currentObject.sprite.width,currentObject.sprite.height)
          
          if bCollideShadow then
            
            currentObject.bInShadow=true
            
            currentObject.sprite.x=shadow.sprite.x
            currentObject.sprite.y=shadow.sprite.y
            
            currentObject.initialX=currentObject.sprite.x
            currentObject.initialY=currentObject.sprite.y
            
            shadow.bIsFull=true
            shadow.sprite.bIsVisible=false
            
            currentObject=nil
            return
          end
        
        end
        
      end
    end
    
  end
 
end


function ObjectManager.mousemoved(x,y)
  
  if currentObject~=nil then
    currentObject.sprite.x=x-(currentObject.sprite.width/2)
    currentObject.sprite.y=y-(currentObject.sprite.height/2)
    
    
    if currentObject.food~=nil then
      gameplayService.foodManager.setPosOnObject(currentObject,currentObject.food)
    end
    
  end
  
end


return ObjectManager