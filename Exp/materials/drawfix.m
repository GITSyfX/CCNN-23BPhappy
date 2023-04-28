function drawfix(w,fix_size,xc,yc,fix_color)

if nargin<5
    fix_color=255;
end

Screen('DrawLine',w,fix_color,xc-fix_size/2,yc,xc+fix_size/2,yc,10);
Screen('DrawLine',w,fix_color,xc,yc-fix_size/2,xc,yc+fix_size/2,10);

