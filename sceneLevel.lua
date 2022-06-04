local SceneLevel={}

local gameplayService=nil
local sceneLoader=nil

local imgLevel=nil

local lstLevel={}

local imgStar=nil
local textNbStars=nil

local truck={}
truck.rotate=0
truck.x=0
truck.y=0

truck.vx=0
truck.vy=0

truck.oldX=0
truck.oldY=0

truck.lstTrail={}

truck.img=nil
truck.sound=nil

local function addLevel(pNbLevel)
  
  local x=gameplayService.screenWidth/3
  local initialX=x
  
  local y=80
  
  for n=1,pNbLevel do
    local myLevel={}
    
    myLevel.num=n
    myLevel.imgStar=imgStar
    
    myLevel.sign={}
    myLevel.sign.img=gameplayService.assetManager.getImage("images/sign.png")
    myLevel.sign.scale=2
    myLevel.sign.x=0
    myLevel.sign.y=0
    
    myLevel.textNbStarsUnlock=nil
    myLevel.textError=nil
    
    myLevel.timerSpeed=0.5
    myLevel.timer=myLevel.timerSpeed
    
    myLevel.bOnAnimUnlock=false
    myLevel.bOnAnimError=false
     
    if n%2==0 then
      x=x+200
    else
      x=initialX
    end
    
    local img=gameplayService.assetManager.getImage("images/level.png")
    
    myLevel.spr=gameplayService.sprite.create(img,x,y)
    
    -----------------sprite
    myLevel.spr.setScale(2,2)
    myLevel.spr.addAnimation("",32,32,{1,2},0,false)
    myLevel.spr.startAnimation("")
    
    if gameplayService.lstLevels[myLevel.num].bIsUnlock then
      myLevel.spr.currentFrame=2
    else
      myLevel.spr.currentFrame=1
    end
    
  
    myLevel.sign.x=myLevel.spr.x-((myLevel.sign.img:getWidth()/2)*myLevel.sign.scale)
    myLevel.sign.y=myLevel.spr.y-(myLevel.sign.img:getHeight()* myLevel.sign.scale)
  
  
    ---------------sprite bubble
    local imgBubble=gameplayService.assetManager.getImage("images/bubble.png")
    
    myLevel.sprBubble=gameplayService.sprite.create(imgBubble,0,0)
    
    myLevel.sprBubble.x=myLevel.spr.x+10
    myLevel.sprBubble.y=myLevel.spr.y-(myLevel.spr.height/2)
    
    myLevel.sprBubble.setScale(2.5,2.5)
    myLevel.sprBubble.addAnimation("",32,32,{1,2,3,4,5},0,false)
    myLevel.sprBubble.startAnimation("")
    
    myLevel.sprBubble.currentFrame=1
    myLevel.sprBubble.bIsVisible=false
    
    ------------sprite stars------------
    local imgStars=gameplayService.assetManager.getImage("images/starsLevel.png")
    local nbStars=gameplayService.lstLevels[myLevel.num].nbStars
    
    myLevel.sprStars=gameplayService.sprite.create(imgStars,0,0)
    
    if not gameplayService.lstLevels[myLevel.num].bIsPlay then
      
      myLevel.sprStars.x=myLevel.sprBubble.x+8
      myLevel.sprStars.y=myLevel.sprBubble.y+43
      
      myLevel.sprStars.setScale(2,2)
      
    else
      
      myLevel.sprStars.x=myLevel.sprBubble.x
      myLevel.sprStars.y=myLevel.sprBubble.y+(myLevel.sprBubble.height/4)
      
      myLevel.sprStars.setScale(2.5,2.5)
      
    end
    
    myLevel.sprStars.addAnimation("",32,9,{1,2,3,4},0,false)
    myLevel.sprStars.startAnimation("")
    
    if nbStars==0 then
      myLevel.sprStars.currentFrame=1
    
    elseif nbStars==1 then
      myLevel.sprStars.currentFrame=4
    
    elseif nbStars==2 then
      myLevel.sprStars.currentFrame=3
    
    elseif nbStars==3 then
      myLevel.sprStars.currentFrame=2
    end
    
    if not gameplayService.lstLevels[myLevel.num].bIsUnlock then
      myLevel.sprStars.bIsVisible=false
      
      myLevel.textNbStarsUnlock=gameplayService.GUI.createText("",myLevel.sprBubble.x+(myLevel.sprBubble.width/2)+5,myLevel.sprBubble.y+(myLevel.sprBubble.height/3)+10,"fonts/COASBL__.ttf",20,"","")
      myLevel.textNbStarsUnlock.text=gameplayService.lstLevels[myLevel.num].nbStarsUnlock
      
    end
    
    ------------------text-----------
    myLevel.textError=gameplayService.GUI.createText("Désolé\npas assez\nd'étoiles",myLevel.sprBubble.x+5,myLevel.sprBubble.y,"fonts/COASBL__.ttf",15,"","")
    myLevel.textError.color={0,0,0}
    
    myLevel.text=gameplayService.GUI.createText("Level "..myLevel.num,myLevel.spr.x-30,myLevel.spr.y-60,"fonts/COASBL__.ttf",20,"","")
    myLevel.text.color={0,0,0}
  
    table.insert(lstLevel,myLevel)
    
    y=y+110
    
  end
  
end

function SceneLevel.load(pGameplayService,pSceneLoader)
  gameplayService=pGameplayService
  sceneLoader=pSceneLoader
  
  lstLevel={}
  
  truck={}
  
  truck.rotate=0
  truck.x=50
  truck.y=gameplayService.screenHeight/2
  truck.oldX=0
  truck.oldY=0
  
  truck.vx=0
  truck.vy=0
  
  truck.scale=3
  
  truck.img=gameplayService.assetManager.getImage("images/truck.png")
  
  truck.sound=gameplayService.assetManager.getSound("sounds/truckEngine.wav")
  truck.sound:isLooping(true)
  
  truck.lstTrail={}
  
  love.audio.play(truck.sound)
  truck.sound:setVolume(0)
  
  imgStar=gameplayService.assetManager.getImage("images/star.png")
  imgLevel=gameplayService.assetManager.getImage("images/BG/BGLevel.png")
  
  
  ----nb stars-------
  for n=1,#gameplayService.lstLevels do
    
    local myLevel=gameplayService.lstLevels[n]
    
    gameplayService.nbStars=gameplayService.nbStars+myLevel.nbStars
  end
  
  
  textNbStars=gameplayService.GUI.createText(gameplayService.nbStars,gameplayService.screenWidth-50,5,"fonts/COASBL__.ttf",50,"","")
  
  -------------levels--------
  addLevel(5)
end

local function addTrail(pDir)
  
  ----------------add trail-------
  local myTrail={}
  myTrail.x=0
  myTrail.y=0
  
  if pDir=="right" then
    
    myTrail.x=truck.x-((truck.img:getWidth()/2)*truck.scale)
    myTrail.y=math.random(truck.y-5,truck.y+5)
    
  elseif pDir=="left" then
    
    myTrail.x=truck.x+((truck.img:getWidth()/2)*truck.scale)
    myTrail.y=math.random(truck.y-5,truck.y+5)
    
  elseif pDir=="up" then
    
    myTrail.x=math.random(truck.x-5,truck.x+5)
    myTrail.y=truck.y+((truck.img:getHeight()/2)*truck.scale)
    
  elseif pDir=="down" then
    
    myTrail.x=math.random(truck.x-5,truck.x+5)
    myTrail.y=truck.y-((truck.img:getHeight()/2)*truck.scale)
  
  end
  
  
  myTrail.radius=math.random(5,10)
  myTrail.nbLives=math.random(0.2,0.5)
  
  myTrail.maxLives=myTrail.nbLives
  
  table.insert(truck.lstTrail,myTrail)
  
end


function SceneLevel.update(dt)
  
  truck.oldX=truck.x
  truck.oldY=truck.y
  
  -------------------move truck-----------
  if love.keyboard.isDown("right") then
    truck.x=truck.x+5*60*dt
    truck.rotate=math.rad(90) 
    
    addTrail("right")
    
  elseif love.keyboard.isDown("left") then
    truck.x=truck.x-5*60*dt
    truck.rotate=math.rad(-90)
    
    addTrail("left")
  
  elseif love.keyboard.isDown("up") then
    truck.y=truck.y-5*60*dt
    truck.rotate=0
    
    addTrail("up")
  
  elseif love.keyboard.isDown("down") then
    truck.y=truck.y+5*60*dt
    truck.rotate=math.rad(180)
    
    addTrail("down")
    
  end
  
  -------------sound truck
  if love.keyboard.isDown("right","left","up","down") then
    
    truck.sound:setVolume(1)
    
  else
    
    if truck.sound:getVolume()>0 then
      
      truck.sound:setVolume(truck.sound:getVolume()-0.5)
      
    end
    
  end
  
  
  ---------------------collide truck with edges screen 
  if truck.x-(truck.img:getWidth()/2)<=0 then
    truck.x=truck.oldX
  end
  if truck.x+(truck.img:getWidth()/2)>=gameplayService.screenWidth then
    truck.x=truck.oldX
  end
  
  if truck.y-(truck.img:getHeight()/2)<=0 then
    truck.y=truck.oldY
  end
  if truck.y+(truck.img:getHeight()/2)>=gameplayService.screenHeight then
    truck.y=truck.oldY
  end
  
  --------------------trail list-----------
  for i=#truck.lstTrail,1,-1 do
    
    local myTrail=truck.lstTrail[i]
      
    myTrail.nbLives=myTrail.nbLives-dt
    
    if myTrail.nbLives<=0 then
      table.remove(truck.lstTrail,i)
    end
    
  end
  
  
  ----------------------------levels
  for n=1,#lstLevel do
    local myLevel=lstLevel[n]
    
    local distLevel=gameplayService.utils.dist(myLevel.spr.x+(myLevel.spr.width/2),myLevel.spr.y+(myLevel.spr.height/2),truck.x,truck.y)
    
    local bCollideSign=gameplayService.utils.checkCollision(truck.x,truck.y,truck.img:getWidth(),truck.img:getHeight(),myLevel.sign.x,myLevel.sign.y,(myLevel.sign.img:getWidth()*myLevel.sign.scale),(myLevel.sign.img:getHeight()*myLevel.sign.scale))
    
    if bCollideSign then
      truck.x=truck.oldX
      truck.y=truck.oldY
    end
    
    ------------distance
    if distLevel<=(32*3) then
      
      myLevel.sprBubble.bIsVisible=true
      
      if gameplayService.lstLevels[myLevel.num].bIsUnlock and not gameplayService.lstLevels[myLevel.num].bIsPlay then
        myLevel.sprBubble.currentFrame=1
      
      elseif gameplayService.lstLevels[myLevel.num].bIsPlay then
        
        myLevel.sprBubble.currentFrame=2
        
      elseif not gameplayService.lstLevels[myLevel.num].bIsUnlock then
      
        myLevel.sprBubble.currentFrame=3
      end

    else
      myLevel.sprBubble.bIsVisible=false
    end
  
    
    if myLevel.bOnAnimUnlock then
      myLevel.timer=myLevel.timer-dt
      
      myLevel.sprBubble.currentFrame=4
      
      if myLevel.timer<=0 then
        
        myLevel.timer=myLevel.timerSpeed
        myLevel.bOnAnimUnlock=false
        
        gameplayService.lstLevels[myLevel.num].bIsUnlock=true
        myLevel.sprStars.bIsVisible=true
        myLevel.sprBubble.currentFrame=1
      
      end
    
    elseif myLevel.bOnAnimError then
    
      myLevel.timer=myLevel.timer-dt
      
      myLevel.sprBubble.currentFrame=5
      
      if myLevel.timer<=0 then
        
        myLevel.timer=myLevel.timerSpeed
        myLevel.bOnAnimError=false
        
        myLevel.sprBubble.currentFrame=3
      
      end
    
    
    end
    
  end
  
  
end

local function drawBubble()
  
  for n=1,#lstLevel do
    local myLevel=lstLevel[n]
    
    if myLevel.sprBubble.bIsVisible then
      myLevel.sprBubble.draw()
      myLevel.sprStars.draw()
      
      if not gameplayService.lstLevels[myLevel.num].bIsUnlock and myLevel.sprBubble.currentFrame==3 then 
        
        love.graphics.draw(myLevel.imgStar,myLevel.sprBubble.x+(myLevel.sprBubble.width/4)-5,myLevel.sprBubble.y+(myLevel.sprBubble.height/2)-5,0,0.8,0.8)
        myLevel.textNbStarsUnlock.draw()
      end
      
      if myLevel.bOnAnimError then
        myLevel.textError.draw()
      end
      
    end
    
  end
  
end


function SceneLevel.draw()
  
  love.graphics.draw(imgLevel,0,0)
  
  for n=1,#lstLevel do
    local myLevel=lstLevel[n]
    
    myLevel.spr.draw()
    
    love.graphics.draw(myLevel.sign.img,myLevel.sign.x,myLevel.sign.y,0,myLevel.sign.scale,myLevel.sign.scale)
    myLevel.text.draw()
    
  end
  
  
  -------------trail----
  for i=1,#truck.lstTrail do
    local myTrail=truck.lstTrail[i]
    
    local ratio=myTrail.nbLives/myTrail.maxLives
    love.graphics.setColor(209/255,209/255,209/255,1*ratio)
    
    love.graphics.circle("fill",myTrail.x,myTrail.y,myTrail.radius)
    
    love.graphics.setColor(1,1,1,1)
  end
  
  love.graphics.draw(truck.img,truck.x,truck.y,truck.rotate,truck.scale,truck.scale,truck.img:getWidth()/2,truck.img:getHeight()/2)
  
  drawBubble()
  
  love.graphics.draw(imgStar,gameplayService.screenWidth-110,10,0,1.5,1.5)
  textNbStars.draw()
end


function SceneLevel.keypressed(key)
  
  if key=="return" then
    
    for n=1,#lstLevel do
      local myLevel=lstLevel[n]
      
      if myLevel.sprBubble.bIsVisible then 
        
        -------------------play level-----------
        if gameplayService.lstLevels[myLevel.num].bIsUnlock then
          
          if myLevel.num<=gameplayService.nbLevelUnlock then
            gameplayService.currentLevel=myLevel.num
            love.audio.stop(truck.sound)
            sceneLoader.init("gameplay")
            
          end
        
        else
        
          if myLevel.num<=gameplayService.nbLevelUnlock then
            
            ---------------unlock level-----------
            if gameplayService.nbStars>=gameplayService.lstLevels[myLevel.num].nbStarsUnlock then
              myLevel.bOnAnimUnlock=true
              return
              
            else
              myLevel.timer=myLevel.timerSpeed*5
              myLevel.bOnAnimError=true
              
              return
            end
            
          end
        
        end
      
      end
      
    end
    
  end
  
end


return SceneLevel