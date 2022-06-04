--trace consol
io.stdout:setvbuf('no')

-- pixel art
love.graphics.setDefaultFilter("nearest")

--debug
if arg[#arg] == "-debug" then require("mobdebug").start() end

math.randomseed(love.timer.getTime())

local sceneLoader=require("sceneLoader")

function love.load()
  love.window.setMode(1000,600)
  
  love.graphics.setBackgroundColor(114/255,122/255,237/255)
  
  screenWidth=love.graphics.getWidth()
  screenHeight=love.graphics.getHeight()
  
  sceneLoader.load(screenWidth,screenHeight)
  sceneLoader.init("levels")
end

function love.update(dt)
  sceneLoader.update(dt)
end

function love.draw()
  sceneLoader.draw()
end

function love.keypressed(key)
  
  sceneLoader.keypressed(key)
end

function love.mousepressed(x,y,btn)
  sceneLoader.mousepressed(x,y,btn)
end


function love.mousemoved(x,y)
  sceneLoader.mousemoved(x,y)
end