local GUI={}

local lstGUI={}



-------------------button------------------------
function GUI.createButton(pImgNormal,pImgHover,pImgPressed,pX,pY)
  local myButton={}
  
  myButton.img=pImgNormal
  myButton.imgHover=pImgHover
  myButton.imgPressed=pImgPressed
  
  myButton.bOnPressed=false
  myButton.bOnHover=false
  
  myButton.x=pY
  myButton.y=pY
  
  myButton.type="button"
  
  function myButton.update(dt)
    local mx,my=love.mouse.getPosition()
    
    if mx>=myButton.x and mx<=myButton.x+myButton.img:getWidth() then
      if my>=myButton.y and my<=myButton.y+myButton.img:getHeight() then
        
        --button hover
        if love.mouse.isDown(1)==false then
          if myButton.bOnHover==false then
            myButton.bOnHover=true
            myButton.bOnPressed=false
          end
          
        --button pressed
        elseif love.mouse.isDown(1) then
          
          if myButton.bOnHover and myButton.bOnPressed==false then
            myButton.bOnHover=false
            myButton.bOnPressed=true
          end
        end
        
      else
        myButton.bOnHover=false
        myButton.bOnPressed=false
      end
      
    else
      myButton.bOnHover=false
      myButton.bOnPressed=false
    end
    
  end

  function myButton.draw()
    
    if myButton.bOnHover then
      love.graphics.draw(myButton.imgHover,myButton.x,myButton.y)
      
    elseif myButton.bOnPressed then
       love.graphics.draw(myButton.imgPressed,myButton.x,myButton.y)
    else
      love.graphics.draw(myButton.img,myButton.x,myButton.y)
    end
    
  end
  
  table.insert(lstGUI,myButton)
  return myButton
end




-----------------progress bar---------------------
function GUI.createProgressBar(pImgBar,pImgProgress,pValueMax,pX,pY)
  local myProgressBar={}
  
  myProgressBar.imgBar=pImgBar
  myProgressBar.imgProgress=pImgProgress
  
  myProgressBar.valueMax=pValueMax
  
  myProgressBar.ratio=0
  
  myProgressBar.x=pX
  myProgressBar.y=pY
  
  function myProgressBar.progress(pValue)
    
    if pValue<=myProgressBar.valueMax then
      myProgressBar.ratio=pValue/myProgressBar.valueMax
    end
  end
  
  function myProgressBar.update(dt)
  end
  
  function myProgressBar.draw()
    love.graphics.draw(myProgressBar.imgBar,myProgressBar.x,myProgressBar.y)
    
    love.graphics.draw(myProgressBar.imgProgress,myProgressBar.x,myProgressBar.y,0,1*myProgressBar.ratio,1)
  end
  
  table.insert(lstGUI,myProgressBar)
  return myProgressBar
end



-------------------------check box--------------------
function GUI.createCheckBox(pImgNoCheck,pImgCheck,pX,pY)
  local myCheckBox={}
  
  myCheckBox.imgNoCheck=pImgNoCheck
  myCheckBox.imgCheck=pImgCheck
  
  myCheckBox.bOnCheck=false
  
  myCheckBox.x=pX
  myCheckBox.y=pY
  
  myCheckBox.bOnClick=false
  
  function myCheckBox.update(dt)
    local mx,my=love.mouse.getPosition()
    
    if mx>=myCheckBox.x and mx<=myCheckBox.x+myCheckBox.imgNoCheck:getWidth() then
      if my>=myCheckBox.y and my<=myCheckBox.y+myCheckBox.imgNoCheck:getHeight() then
        
        if love.mouse.isDown(1) and myCheckBox.bOnClick then
          
          if myCheckBox.bOnCheck==false then
            myCheckBox.bOnCheck=true
          
          elseif myCheckBox.bOnCheck then
            myCheckBox.bOnCheck=false
          end
          
          myCheckBox.bOnClick=false
        end
      end
    end
    
    if love.mouse.isDown(1)==false and myCheckBox.bOnClick==false then
      myCheckBox.bOnClick=true
    end
  
  end

  function myCheckBox.draw()
    
    if myCheckBox.bOnCheck then
      love.graphics.draw(myCheckBox.imgCheck,myCheckBox.x,myCheckBox.y)
    else
      love.graphics.draw(myCheckBox.imgNoCheck,myCheckBox.x,myCheckBox.y)
    end
    
  end
  
  table.insert(lstGUI,myCheckBox)
  return myCheckBox
end


-----------------------text------------------------------
function GUI.createText(pText,pX,pY,pFont,pSizeFont,pHAlign,pVAlign)
  local myText={}
  
  myText.text=pText
  myText.x=pX
  myText.y=pY
  
  myText.hAlign=pHAlign
  myText.vAlign=pVAlign
  
  myText.font=love.graphics.newFont(pFont,pSizeFont)
  myText.color={1,1,1,1}
  
  -------horizontal align
  if myText.hAlign~="" then
    
    if myText.hAlign=="left" then
      myText.x=myText.x
      
    elseif myText.hAlign=="right" then
      myText.x=myText.x-myText.font:getWidth(myText.text)
      
    elseif myText.hAlign=="middle" then
      myText.x=myText.x-(myText.font:getWidth(myText.text)/2)
    end
    
  end

  
  -------vertical align
  if myText.vAlign~="" then
    
    if myText.vAlign=="up" then
      myText.y=myText.y
    elseif myText.vAlign=="down" then
      myText.y=myText.y-myText.font:getHeight(myText.text)
    elseif myText.vAlign=="middle" then
      myText.y=myText.y-(myText.font:getHeight(myText.text)/2)
    end
  
  end
  
  function myText.update(dt)
  end

  function myText.draw()
    love.graphics.setFont(myText.font)
    
    love.graphics.setColor(myText.color[1],myText.color[2],myText.color[3],myText.color[4])
    love.graphics.print(myText.text,myText.x,myText.y)
    love.graphics.setColor(1,1,1,1)
    
  end
  
  table.insert(lstGUI,myText)
  return myText
end



-----------------------------------panel----------------------------------------
function GUI.createPanel(pImg,pX,pY)
  local myPanel={}
  
  myPanel.img=pImg
  
  myPanel.x=pX
  myPanel.y=pY
  
  function myPanel.update(dt)
  end
  
  function myPanel.draw()
    love.graphics.draw(myPanel.img,myPanel.x,myPanel.y)
  end
  
  table.insert(lstGUI,myPanel)
  return myPanel
end


function GUI.totalDelete()
  lstGUI={}
end

function GUI.update(dt)
   
  for k,v in pairs(lstGUI) do
    v.update(dt)
  end
  
end

function GUI.draw()
  
  for k,v in pairs(lstGUI) do
    v.draw()
  end
  
end

return GUI
