local Utils={}

function Utils.dist(pX1,pY1,pX2,pY2)
  return ((pX2-pX1)^2+(pY2-pY1)^2)^0.5
end

function Utils.checkCollision(pX1,pY1,pW1,pH1,pX2,pY2,pW2,pH2)
  
  if pX1+pW1>=pX2 and pX1<=pX2+pW2 and 
    pY1+pH1>=pY2 and pY1<=pY2+pH2 then
      
    return true
  end
  
  return false
end


return Utils