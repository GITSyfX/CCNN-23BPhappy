function draw_text_dot(w,str,sx,sy,color,textsize)

str=double(str);
oldsize=Screen('TextSize',w,textsize);
Screen('DrawText',w,str,sx,sy,color);
Screen('TextSize',w,oldsize);