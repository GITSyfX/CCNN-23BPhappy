function drawcenteredtext(w,str,rect,color,textsize)

str=double(str);
oldsize=Screen('TextSize',w,textsize);
drect=Screen('TextBounds',w,str);
sx=(rect(3)-rect(1)-drect(3))/2+rect(1);
sy=(rect(4)-rect(2)-drect(4))/2+rect(2);
Screen('DrawText',w,str,sx,sy,color);
Screen('TextSize',w,oldsize);