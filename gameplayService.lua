local GameplayService={}

GameplayService.screenWidth=0
GameplayService.screenHeight=0

GameplayService.assetManager=nil
GameplayService.utils=nil

GameplayService.GUI=nil
GameplayService.sprite=nil

GameplayService.foodManager=nil
GameplayService.objectManager=nil
GameplayService.mealManager=nil
GameplayService.clientManager=nil

GameplayService.rectCancel=nil

GameplayService.currentLevel=1
GameplayService.nbLevelUnlock=1

GameplayService.timerGame=0

GameplayService.nbMoney=0
GameplayService.price=0

GameplayService.targetNbClientHappy=0
GameplayService.nbClientHappy=0

GameplayService.nbStars=0

GameplayService.lstLevels={}

for n=1,5 do
  
  GameplayService.lstLevels[n]={}
  GameplayService.lstLevels[n].nbStars=0
  GameplayService.lstLevels[n].bIsPlay=false
  
  
  if n==1 then
    GameplayService.lstLevels[n].bIsUnlock=true
    GameplayService.lstLevels[n].nbStarsUnlock=0
  else
    
    GameplayService.lstLevels[n].bIsUnlock=false
    GameplayService.lstLevels[n].nbStarsUnlock=(n-1)
    
    if n==5 then
      GameplayService.lstLevels[n].nbStarsUnlock=6
    elseif n==4 then
      GameplayService.lstLevels[n].nbStarsUnlock=4
    end
    
  end
    
end

function GameplayService.setSizeScreen(pWidth,pHeight)
  GameplayService.screenWidth=pWidth
  GameplayService.screenHeight=pHeight
end

function GameplayService.setAssetManager(pAssetManager)
  GameplayService.assetManager=pAssetManager
end

function GameplayService.setUtils(pUtils)
  GameplayService.utils=pUtils
end

function GameplayService.setSprite(pSprite)
  GameplayService.sprite=pSprite
end

function GameplayService.setGUI(pGui)
  GameplayService.GUI=pGui
end

function GameplayService.setGameValue(pFoodManager,pObjectManager,pMealManager,pClientManager,pRectCancel)
  
  GameplayService.foodManager=pFoodManager
  GameplayService.objectManager=pObjectManager
  GameplayService.mealManager=pMealManager
  GameplayService.clientManager=pClientManager
  
  GameplayService.rectCancel=pRectCancel
end


return GameplayService