local ClientManager={}

local gameplayService=nil
local lstClient={}

local nbOrder=0

function addClient()
  
  local lstNumClient={1,2,3,4,5,6,7,8}
  local lstPosClient={}
  
  for n=1,8 do
    
    local posX=(gameplayService.screenWidth-(gameplayService.screenWidth/4))-((n-1)*100)
    table.insert(lstPosClient,posX)
    
  end
  
  for n=#lstNumClient,1,-1 do
    
    local rndClient=math.random(1,#lstNumClient)
    local numClient=lstNumClient[rndClient]
    
    table.remove(lstNumClient,rndClient)
    
    local myClient={}
    
    local img=gameplayService.assetManager.getImage("images/clients/client"..numClient..".png")
    
    myClient.sprite=gameplayService.sprite.create(img,0,0)
    myClient.sprite.addAnimation("",100,300,{1,2,3},2,true)
    myClient.sprite.currentFrame=2
    myClient.sprite.startAnimation("")
    
    myClient.sprite.x=0-(myClient.sprite.width*2)
    myClient.sprite.y=100
    
    myClient.speed=3
    
    myClient.vx=0
    myClient.vy=0
    
    myClient.numOrder=-1
    
    local rndPosX=math.random(1,#lstPosClient)
    local posX=lstPosClient[rndPosX]
    
    table.remove(lstPosClient,rndPosX)
    
    myClient.targetX=posX
    
    myClient.timerSpeed=(n-1)*15
    myClient.timer=myClient.timerSpeed
   
    myClient.timerSpeedOrder=120
    myClient.timerOrder=myClient.timerSpeedOrder
   
    myClient.bOnStart=false
    myClient.bOnOrderPreparation=false
    
    myClient.bIsOrderFinish=false
    myClient.bIsOrderGood=false
    
   
    local lstMeal=gameplayService.mealManager.getLstMeal()
    local nbMeal=#lstMeal
    local rndMeal=math.random(1,nbMeal)
    
    myClient.order={
      
      imgMeal=lstMeal[rndMeal].sprite.img,
      quadMealImg=lstMeal[rndMeal].sprite.lstImage[math.floor(lstMeal[rndMeal].sprite.currentFrame)],
      
      imgBubble=gameplayService.assetManager.getImage("images/order/bubble.png"),
      xBubble=0,
      yBubble=0,
      wBubble=0,
      hBubble=0,
      bOnDisplayBubble=false,
      
      nameMeal=lstMeal[rndMeal].name
    }
    
    myClient.order.wBubble=myClient.order.imgBubble:getWidth()*3
    myClient.order.hBubble=myClient.order.imgBubble:getHeight()*3
    
    table.insert(lstClient,myClient)
  end
  
end


function ClientManager.load(pGameplayService)
  gameplayService=pGameplayService
  
  lstClient={}
  nbOrder=0
  
  addClient()
end


function ClientManager.getClient(pNumOrder)
  
  for n=#lstClient,1,-1 do
    local myClient=lstClient[n]
    
    if myClient.numOrder==pNumOrder then
      return myClient
    end
    
  end
  
  return nil
end


function ClientManager.update(dt)
     
  for n=#lstClient,1,-1 do
    local myClient=lstClient[n]

    local animation=""
    
    myClient.sprite.x=myClient.sprite.x+myClient.vx*60*dt
    myClient.sprite.y=myClient.sprite.y+myClient.vy*60*dt
    
    local lstTicket=gameplayService.mealManager.getTicketList()
    
    if not myClient.bOnStart then
      
      if #lstTicket<5 then
        
        myClient.timer=myClient.timer-dt
        
        if myClient.timer<=0 then
          ------------------start client-----------
          myClient.timer=myClient.timerSpeed
          myClient.timerOrder=myClient.timerSpeedOrder/5
        
          myClient.bOnStart=true
        
        end
      
      end
    
    else
      
      if myClient.sprite.x<myClient.targetX then
        myClient.vx=myClient.speed
        animation="normal"
      
      else
        
        ------------------stop client-----------
        if not myClient.bOnOrderPreparation then
        
          ------------------order----------
         
          if myClient.timerOrder<=0 then
           
            ----------------angry client--------------
            animation="angry"
            myClient.vx=myClient.speed
            
            gameplayService.mealManager.deleteTicket(myClient.numOrder)
            myClient.order.bOnDisplayBubble=false
          
          else
            
            animation="normal"
            myClient.order.bOnDisplayBubble=true
        
            myClient.timerOrder=myClient.timerOrder-dt
            myClient.vx=0
            
            myClient.order.xBubble=myClient.sprite.x+(myClient.sprite.width-20)
            myClient.order.yBubble=myClient.sprite.y-(myClient.order.hBubble/2)
          
          end
        
        else
          --------------------order in preparation
    
          if myClient.timerOrder<=0 then
            ----------------angry client---------
            animation="angry"
            myClient.vx=myClient.speed
             
            gameplayService.mealManager.deleteTicket(myClient.numOrder)
            
          else
            
            if not myClient.bIsOrderFinish then
              animation="normal"
              myClient.timerOrder=myClient.timerOrder-dt
            
            else
              
              --------------------------order finish--------------
              if not myClient.bIsOrderGood then
                animation="angry"
              else
                animation="happy"
              end
            
              myClient.vx=myClient.speed
            end
          end
              
              
        end
          
          
      end
      
    end
    
    ----------------collide with the edge right screen
    if myClient.sprite.x>=gameplayService.screenWidth then
      table.remove(lstClient,n)
    end
    
      ------------animation-------
    if animation~="" then
      
      if animation=="normal" then
        myClient.sprite.currentFrame=2
      elseif animation=="happy" then
        myClient.sprite.currentFrame=1
      elseif animation=="angry" then 
        myClient.sprite.currentFrame=3
      end
    end
    
    
    
  end
  
  if #lstClient<=0 then
    addClient(8)
  end
  
end


function ClientManager.draw()
  
  for n=#lstClient,1,-1 do
    
    local myClient=lstClient[n]
    
    if myClient.order.bOnDisplayBubble then
      
      love.graphics.draw(myClient.order.imgBubble,myClient.order.xBubble,myClient.order.yBubble,0,3,3)
      love.graphics.draw(myClient.order.imgMeal,myClient.order.quadMealImg,myClient.order.xBubble+20,myClient.order.yBubble,0,2,2)
      
    end
    
    myClient.sprite.draw()
    
  end
  
end

function ClientManager.mousepressed(x,y,btn)
  
  if btn==1 then
    
    --------------------click order------------
    for n=#lstClient,1,-1 do
      local myClient=lstClient[n]
      
      local bCollide=gameplayService.utils.checkCollision(myClient.order.xBubble,myClient.order.yBubble,myClient.order.wBubble,myClient.order.hBubble,x,y,1,1)
      
      if bCollide then
        
        if not myClient.bOnOrderPreparation and myClient.sprite.x>=myClient.targetX then
            
          myClient.bOnOrderPreparation=true
          myClient.order.bOnDisplayBubble=false
          
          nbOrder=nbOrder+1
          myClient.numOrder=nbOrder
          
          gameplayService.mealManager.addTicket(myClient.order.nameMeal,myClient.numOrder,gameplayService.currentLevel)
          
          myClient.timerOrder=myClient.timerSpeedOrder
          
          return
        end
        
      end
      
    end
    
  end
  
end


return ClientManager