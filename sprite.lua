local Sprite={}

local lstSprite={}

function Sprite.create(pImg,pX,pY)
  local mySprite={}
  
  mySprite.img=pImg
  
  mySprite.x=pX
  mySprite.y=pY
  
  mySprite.vx=0
  mySprite.vy=0
  
  mySprite.scaleX=1
  mySprite.scaleY=1
  
  if mySprite.img~=nil then
    mySprite.width=mySprite.img:getWidth()
    mySprite.height=mySprite.img:getHeight()
  end
  
  mySprite.rotation=0
  mySprite.bIsVisible=true
  
  mySprite.bIsTilesheet=false
  
  mySprite.lstAnimation={}
  mySprite.lstImage={}
  
  mySprite.currentAnimation=nil
  mySprite.currentFrame=1
  
  mySprite.timer=0
  mySprite.color={1,1,1,1}
  
  mySprite.setScale=function(pScaleX,pScaleY)
    mySprite.scaleX=pScaleX
    mySprite.scaleY=pScaleY
    
    if mySprite.img~=nil then
      mySprite.width=mySprite.img:getWidth()*mySprite.scaleX
      mySprite.height=mySprite.img:getHeight()*mySprite.scaleY
    end
    
  end
  
  mySprite.setRotation=function(pRotation)
    mySprite.rotation=pRotation
  end
  
  mySprite.addAnimation=function(pNameAnim,pWFrame,pHFrame,pLstFrame,pSpeed,pLoop)
    
    mySprite.bIsTilesheet=true

    mySprite.width=pWFrame*mySprite.scaleX
    mySprite.height=pHFrame*mySprite.scaleY
    
    local nbCol=math.floor(mySprite.img:getWidth()/pWFrame)
    
    for n=1,#pLstFrame do
      
      local l=math.floor((pLstFrame[n]-1)/nbCol)+1
      local c=math.floor(pLstFrame[n]-((l-1)*nbCol))
      
      local x=(c-1)*pWFrame
      local y=(l-1)*pHFrame
      
      mySprite.lstImage[n]=love.graphics.newQuad(x,y,pWFrame,pHFrame,mySprite.img:getWidth(),mySprite.img:getHeight())
    end

    local animation={}
    animation.name=pNameAnim
    animation.lstFrame=pLstFrame
    animation.bLoop=pLoop
    animation.speed=pSpeed
    animation.lstImage=mySprite.lstImage
    animation.bIsFinish=false
    
    table.insert(mySprite.lstAnimation,animation)
  end

  mySprite.startAnimation=function(pNameAnim)
    
    if mySprite.currentAnimation~=nil then
      if mySprite.currentAnimation.name==pNameAnim then
        return
      end
    end
    
    if mySprite.bIsTilesheet then
      
      for n=#mySprite.lstAnimation,1,-1 do
        local anim=mySprite.lstAnimation[n]
        
        if anim.name==pNameAnim then
          mySprite.currentAnimation=anim
          mySprite.currentFrame=1

          mySprite.currentAnimation.bIsFinish=false
        end
      end
    end
    
  end
  
  
  -------------draw--------------
  mySprite.draw=function()
    
    love.graphics.setColor(mySprite.color[1],mySprite.color[2],mySprite.color[3],mySprite.color[4])
    
    if mySprite.bIsVisible then
      
      if mySprite.bIsTilesheet then
        
        love.graphics.draw(mySprite.img,mySprite.currentAnimation.lstImage[math.floor(mySprite.currentFrame)],mySprite.x,mySprite.y,mySprite.rotation,mySprite.scaleX,mySprite.scaleY)      
      else
        love.graphics.draw(mySprite.img,mySprite.x,mySprite.y,mySprite.rotation,mySprite.scaleX,mySprite.scaleY)
      end
      
    end
  
    love.graphics.setColor(1,1,1,1)
    
  end
  
  table.insert(lstSprite,mySprite)
  return mySprite
end


function Sprite.totalDelete()
  
  for k,v in pairs(lstSprite) do
    table.remove(lstSprite,k)
  end
  
end


function Sprite.update(dt)
  
  for k,v in pairs(lstSprite) do
    
    if v.currentAnimation~=nil then
      v.timer=v.timer+dt
   
      if v.timer>=v.currentAnimation.speed then
        v.timer=0
        v.currentFrame=v.currentFrame+1
        
        if v.currentFrame>=#v.currentAnimation.lstFrame+1 then
        
          if v.currentAnimation.bLoop then
            v.currentFrame=1
          else
            v.currentFrame=#v.currentAnimation.lstFrame
            v.currentAnimation.bIsFinish=true
          end
        
        end
      end
    end
  
  end

end



return Sprite