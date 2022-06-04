local AssetManager={}

local lstImages={}
local lstSounds={}

function AssetManager.addImage(pPath)
  local image=love.graphics.newImage(pPath)
  
  lstImages[pPath]=image
end

function AssetManager.addSound(pPath,pType)
  local sound
  
  if pType=="sound" then
    sound=love.audio.newSource(pPath,"static")
  elseif pType=="music" then
    sound=love.audio.newSource(pPath,"stream")
  end
  
  lstSounds[pPath]=sound
end

function AssetManager.getImage(pPath)
  return lstImages[pPath]
end

function AssetManager.getSound(pPath)
  return lstSounds[pPath]
end

return AssetManager