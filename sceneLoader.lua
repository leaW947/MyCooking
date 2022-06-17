local SceneLoader={}

local gameplayService=require("gameplayService")
local assetManager=require("assetManager")
local utils=require("utils")

local sprite=require("sprite")
local GUI=require("GUI")

local sceneLevel=require("sceneLevel")
local sceneGame=require("sceneGame")

local gameState=""

function SceneLoader.load(pScreenWidth,pScreenHeight)
  
  gameplayService.setSizeScreen(pScreenWidth,pScreenHeight)
  
  ---add images
  assetManager.addImage("images/food/foodInv.png")
  assetManager.addImage("images/food/food.png")
  
  assetManager.addImage("images/food/burgers.png")
  assetManager.addImage("images/food/burgersOrder.png")
  
  assetManager.addImage("images/food/fruitSalads.png")
  assetManager.addImage("images/food/fruitSaladsOrder.png")
  
  assetManager.addImage("images/food/salads.png")
  assetManager.addImage("images/food/saladsOrder.png")
    
  assetManager.addImage("images/food/hotdogs.png")
  assetManager.addImage("images/food/hotdogsOrder.png")
  
  assetManager.addImage("images/food/soups.png")
  assetManager.addImage("images/food/soupsOrder.png")
  
  assetManager.addImage("images/objects/objectsInv.png")
  assetManager.addImage("images/objects/objects.png")
  assetManager.addImage("images/objects/shadowObject.png")
  assetManager.addImage("images/objects/saucepan.png")
  
  assetManager.addImage("images/objects/poubelle.png")
  
  assetManager.addImage("images/order/bubble.png")
  assetManager.addImage("images/order/ticket.png")
  
  assetManager.addImage("images/level.png")
  assetManager.addImage("images/truck.png")
  assetManager.addImage("images/star.png")
  assetManager.addImage("images/starsLevel.png")
  assetManager.addImage("images/bubble.png")
  assetManager.addImage("images/sign.png")
  
  assetManager.addImage("images/symbole.png")
  assetManager.addImage("images/symbole2.png")
  
  assetManager.addImage("images/cashRegister.png")
  
  assetManager.addImage("images/BG/BGLevel.png")
  assetManager.addImage("images/BG/BGgame.png")
  assetManager.addImage("images/BG/BGGameover.png")
  assetManager.addImage("images/BG/BGstartLevel.png")
  assetManager.addImage("images/BG/BGvictory.png")
  
  assetManager.addImage("images/chrono.png")
  assetManager.addImage("images/smiley.png")
  
  assetManager.addImage("images/mealExplanation/burger.png")
  assetManager.addImage("images/mealExplanation/fruitSalad.png")
  assetManager.addImage("images/mealExplanation/hotdog.png")
  assetManager.addImage("images/mealExplanation/soup.png")
  assetManager.addImage("images/mealExplanation/salad.png")
  
      ---------clients
  for n=1,8 do
    assetManager.addImage("images/clients/client"..n..".png")
  end
  
  
  ------add sounds
  assetManager.addSound("sounds/truckEngine.wav","sound")
  assetManager.addSound("sounds/musics/originals/Promenade.mp3","music")
  
  assetManager.addSound("sounds/cuisson.wav","sound")
  assetManager.addSound("sounds/eauQuiBout.wav","sound")
  assetManager.addSound("sounds/sonnette.wav","sound")
  
  gameplayService.setAssetManager(assetManager)
  gameplayService.setUtils(utils)
  
  gameplayService.setGUI(GUI)
  gameplayService.setSprite(sprite)
end

function SceneLoader.init(pGameState)
  gameState=pGameState
  
  sprite.totalDelete()
  GUI.totalDelete()
  
  if gameState=="menu" then 
  elseif gameState=="gameplay" then
    sceneGame.load(gameplayService,SceneLoader)
  elseif gameState=="levels" then
    sceneLevel.load(gameplayService,SceneLoader)
  elseif gameState=="gameover" then
  end
  
end

function SceneLoader.update(dt)
  
  if gameState=="menu" then
  elseif gameState=="gameplay" then
    sceneGame.update(dt)
  elseif gameState=="levels" then
    sceneLevel.update(dt)
  elseif gameState=="gameover" then
  end

end

function SceneLoader.draw()
  
  if gameState=="menu" then
  elseif gameState=="gameplay" then
    sceneGame.draw()
  elseif gameState=="levels" then
    sceneLevel.draw()
  elseif gameState=="gameover" then
  end

end


function SceneLoader.keypressed(key)
  
  if gameState=="menu" then
  elseif gameState=="gameplay" then
    sceneGame.keypressed(key)
  elseif gameState=="levels" then
    sceneLevel.keypressed(key)
  elseif gameState=="gameover" then
  end

end

function SceneLoader.mousepressed(x,y,btn)
  
  if gameState=="menu" then
  elseif gameState=="gameplay" then
    sceneGame.mousepressed(x,y,btn)
  elseif gameState=="gameover" then
  end

end

function SceneLoader.mousemoved(x,y)
  
  if gameState=="menu" then
  elseif gameState=="gameplay" then
    sceneGame.mousemoved(x,y)
  elseif gameState=="gameover" then
  end

end

return SceneLoader