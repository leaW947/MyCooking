local SceneGame={}

local gameplayService=nil
local sceneLoader=nil

local foodManager=require("foodManager")
local objectManager=require("objectManager")
local mealManager=require("mealManager")
local clientManager=require("clientManager")

local rectCancel={}
rectCancel.sprite=nil
rectCancel.bIsOpen=false
rectCancel.timerSpeed=0.2
rectCancel.timer=rectCancel.timerSpeed

local imgChrono=nil
local imgMoney=nil
local imgNbClientHappy=nil
local imgSymbol={}

local textGame={}
textGame.money=nil
textGame.timer=nil
textGame.level=nil
textGame.targetNbClientHappy=nil
textGame.nbClientHappy=nil
textGame.titleStartLevel=nil

local musicGame=nil

local BGgame=nil
local BGstartLevel=nil
local BGGameover=nil
local BGvictory=nil

local oldStateLevel=""
local stateLevel={"play","gameover","startLevel","victory"}

local function getValueLevel(pLevel)
  
  gameplayService.timerGame=60*5
  
  gameplayService.nbMoney=0
  gameplayService.targetNbClientHappy=0
  gameplayService.nbClientHappy=0
  
  gameplayService.price=0

  
  if pLevel==1 then
    
    gameplayService.targetNbClientHappy=5
    gameplayService.price=2.50
    
  elseif pLevel==2 then 
    
    gameplayService.targetNbClientHappy=7
    gameplayService.price=2.50
    
  elseif pLevel==3 then
    
    gameplayService.targetNbClientHappy=10
    gameplayService.price=3
     
  elseif pLevel==4 then
  
    gameplayService.targetNbClientHappy=12
    gameplayService.price=3
  
  elseif pLevel==5 then
    
    gameplayService.targetNbClientHappy=13
    gameplayService.price=3.50
    
  end
  
end

local function initGame(pLevel)
  
  if oldStateLevel~="gameover" then
    stateLevel="startLevel"
  end
  
  getValueLevel(gameplayService.currentLevel)
  
  ----------------------cancel--------------
  local imgRectCancel=gameplayService.assetManager.getImage("images/objects/poubelle.png")
  
  rectCancel.sprite=gameplayService.sprite.create(imgRectCancel,0,0)
  rectCancel.sprite.setScale(2.5,2.5)
  
  rectCancel.sprite.addAnimation("",23,35,{1,2},0,false)
  rectCancel.sprite.startAnimation("")
  rectCancel.sprite.currentFrame=1
  
  rectCancel.sprite.x=gameplayService.screenWidth-(rectCancel.sprite.width+30)
  rectCancel.sprite.y=gameplayService.screenHeight-(rectCancel.sprite.height+10)
  
  rectCancel.bIsOpen=false
  
  ---------------text--------------
  textGame.money=gameplayService.GUI.createText(gameplayService.nbMoney,gameplayService.screenWidth-95,gameplayService.screenHeight/2-10,"fonts/COASBL__.ttf",20,"","")
  textGame.money.color={0,0,0}
  
  textGame.timer=gameplayService.GUI.createText("0",gameplayService.screenWidth-70,5
  ,"fonts/COASBL__.ttf",40,"","")
  textGame.timer.color={0,0,0}
  
  textGame.level=gameplayService.GUI.createText("Level "..gameplayService.currentLevel,gameplayService.screenWidth/3+30,gameplayService.screenHeight/4,"fonts/COASBL__.ttf",70,"","")
  textGame.level.color={83/255,93/255,232/255,1}
  
  textGame.nbClientHappy=gameplayService.GUI.createText(gameplayService.nbClientHappy.." /",gameplayService.screenWidth-(gameplayService.screenWidth/4),5,"fonts/COASBL__.ttf",40,"","")
  textGame.nbClientHappy.color={0,0,0}
  
  textGame.targetNbClientHappy=gameplayService.GUI.createText(gameplayService.targetNbClientHappy,textGame.nbClientHappy.x+70,5,"fonts/COASBL__.ttf",40,"","")  
  textGame.targetNbClientHappy.color={0,0,0}
  
  
  textGame.titleStartLevel=gameplayService.GUI.createText("Vous voici au niveau "..gameplayService.currentLevel.." !",(gameplayService.screenWidth/3)+10,70,"fonts/COASBL__.ttf",30,"","")
  textGame.titleStartLevel.color={0,0,0}

  
  
  ---------img text-------
  imgChrono=gameplayService.assetManager.getImage("images/chrono.png")
  imgMoney=gameplayService.assetManager.getImage("images/cashRegister.png")
  imgNbClientHappy=gameplayService.assetManager.getImage("images/smiley.png")
  
  gameplayService.setGameValue(foodManager,objectManager,mealManager,clientManager,rectCancel)
  
  foodManager.load(gameplayService)
  objectManager.load(gameplayService)
  
  mealManager.load(gameplayService)
  clientManager.load(gameplayService)
  
end


function SceneGame.load(pGameplayService,pSceneLoader)
  gameplayService=pGameplayService
  sceneLoader=pSceneLoader
  
  initGame(gameplayService.currentLevel)
  
  BGgame=gameplayService.assetManager.getImage("images/BG/BGgame.png")
  BGGameover=gameplayService.assetManager.getImage("images/BG/BGGameover.png")
  BGstartLevel=gameplayService.assetManager.getImage("images/BG/BGstartLevel.png")
  BGvictory=gameplayService.assetManager.getImage("images/BG/BGvictory.png")
  
  imgSymbol={}
  imgSymbol[1]=gameplayService.assetManager.getImage("images/symbole.png")
  imgSymbol[2]=gameplayService.assetManager.getImage("images/symbole2.png")
  
  musicGame=gameplayService.assetManager.getSound("sounds/musics/originals/Promenade.mp3")
  musicGame:setLooping(true)
  musicGame:setVolume(0.1)

end


local function updateGame(dt)
  
  --------timer
  if gameplayService.timerGame<=1 then
    love.audio.stop()
    ---------------victory---------
    if gameplayService.nbClientHappy>=gameplayService.targetNbClientHappy then
      
      local calculStar=gameplayService.targetNbClientHappy*gameplayService.price
      local nbStars=0
      
      if gameplayService.nbMoney>=calculStar then
        
        -----------1 star
        if gameplayService.nbMoney<=calculStar+gameplayService.price then
          
          nbStars=1
  
        ----------2 stars
        elseif gameplayService.nbMoney<=calculStar+(gameplayService.price*2) and gameplayService.nbMoney>calculStar+gameplayService.price then
        
          nbStars=2
          
        -----------3 stars
        elseif gameplayService.nbMoney>calculStar+(gameplayService.price*2) then
          
          nbStars=3
          
        end
        
      end
      
      gameplayService.lstLevels[gameplayService.currentLevel].bIsPlay=true
      
      if gameplayService.lstLevels[gameplayService.currentLevel].nbStars<=nbStars then
        gameplayService.lstLevels[gameplayService.currentLevel].nbStars=nbStars
      end

      
      love.audio.stop(musicGame)
      gameplayService.nbLevelUnlock=gameplayService.nbLevelUnlock+1
      stateLevel="victory"
      
    --------------------gameover----------
    elseif gameplayService.nbClientHappy<gameplayService.targetNbClientHappy then 
      
      love.audio.stop(musicGame)
      stateLevel="gameover"
      
    end
    
    oldStateLevel=stateLevel
    gameplayService.timerGame=0
    
  else
    gameplayService.timerGame=gameplayService.timerGame-dt
  end
  


  -------------rect cancel animation-----------
  if rectCancel.bIsOpen then
    
    rectCancel.timer=rectCancel.timer-dt
    
    if rectCancel.timer<=0 then
    
      rectCancel.timer=rectCancel.timerSpeed
      rectCancel.sprite.currentFrame=1
      rectCancel.bIsOpen=false
    
    end
  end
  

  -------------text----------
  textGame.timer.text=math.floor(gameplayService.timerGame)
  textGame.money.text=tostring(gameplayService.nbMoney).."$"
  textGame.nbClientHappy.text=math.floor(gameplayService.nbClientHappy).." / "

  foodManager.update(dt)
  objectManager.update(dt)
  mealManager.update(dt)
  clientManager.update(dt)

end


function SceneGame.update(dt)
  
  if stateLevel=="play" then
    updateGame(dt)
  end
  
end


local function drawStateLevel()
  
  love.graphics.setColor(0,0,0,0.8)
  love.graphics.rectangle("fill",0,0,gameplayService.screenWidth,gameplayService.screenHeight)
  love.graphics.setColor(1,1,1)
  
  if stateLevel=="startLevel" then 
    love.graphics.draw(BGstartLevel,100,50)
  
    textGame.titleStartLevel.draw()
    love.graphics.draw(imgSymbol[1],100,70,0,5,5)
    
  elseif stateLevel=="victory" then
  
    love.graphics.draw(BGvictory,100,50)
    love.graphics.draw(imgSymbol[1],100,70,0,5,5)
  
  elseif stateLevel=="gameover" then
  
    love.graphics.draw(BGGameover,100,50)
    love.graphics.draw(imgSymbol[2],100,70,0,5,5)
  
  end
  
end


function SceneGame.draw()
  
  textGame.level.draw()
  ---------------------clients-------------
  clientManager.draw()
  
  ----------------BG
  love.graphics.draw(BGgame,0,gameplayService.screenHeight-BGgame:getHeight())
  
  -----------------------text------------
  textGame.timer.draw()
  textGame.targetNbClientHappy.draw()
  textGame.nbClientHappy.draw()
  
  love.graphics.draw(imgNbClientHappy,textGame.nbClientHappy.x-40,textGame.nbClientHappy.y)
  love.graphics.draw(imgChrono,textGame.timer.x-30,textGame.timer.y,0,2,2)
  
  love.graphics.draw(imgMoney,gameplayService.screenWidth-(imgMoney:getWidth()*5)-10,gameplayService.screenHeight/2-50,0,5,5)
  textGame.money.draw()
  
  
  -------------cancel
  rectCancel.sprite.draw()
  
  foodManager.drawFoodInventory()
  objectManager.draw()
  
  mealManager.draw()
  foodManager.draw()
  
  objectManager.drawKnifeAndPeeler()
  
  objectManager.drawObjectMove()
  foodManager.drawFoodMove()
  
  
  if stateLevel~="play" then
  
    drawStateLevel()
  end
  
  
end


local function mousepressedGame(x,y,btn)
  
  mealManager.mousepressed(x,y,btn)
  foodManager.mousepressed(x,y,btn)
  objectManager.mousepressed(x,y,btn)
  clientManager.mousepressed(x,y,btn)
  
end


function SceneGame.mousepressed(x,y,btn)
  
  if stateLevel=="play" then
    mousepressedGame(x,y,btn)
  end
  
end


local function mousemovedGame(x,y)
  
  foodManager.mousemoved(x,y)
  objectManager.mousemoved(x,y)
  mealManager.mousemoved(x,y)
  
end


function SceneGame.mousemoved(x,y)
  
  if stateLevel=="play" then
    mousemovedGame(x,y)    
  end

end


function SceneGame.keypressed(key)
  
  ---------------start level-----
  if stateLevel=="startLevel" then
  
    if key=="escape" then
      
      love.audio.stop(musicGame)
      sceneLoader.init("levels")
      
    elseif key=="return" then
      
      love.audio.play(musicGame)
      stateLevel="play"
      
      return
    end
  
  -----------victory--------
  elseif stateLevel=="victory" then
  
    if key=="escape" then
      sceneLoader.init("levels")
    end
  
  ---------------gameover
  elseif stateLevel=="gameover" then
  
    if key=="escape" then
      sceneLoader.init("levels")
      
    elseif key=="return" then
      
      love.audio.play(musicGame)
      initGame(gameplayService.currentLevel)
      stateLevel="play"
      
      return
    end
  
  end
  
end



return SceneGame