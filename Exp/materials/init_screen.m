function [w,wrect,hz,xc,yc]=init_screen(bgc,skip,exp_hz)

if nargin<3
    exp_hz=[];
end

Screen('CloseAll');
Screen('Preference','SuppressAllWarnings', 1);
Screen('Preference', 'SkipSyncTests', skip); 
screens=Screen('Screens');  
if max(screens)==2
    screen_num=1;
else
    screen_num=0;
end
[w,wrect]=Screen('OpenWindow',screen_num,bgc);
% [w,wrect]=PsychImaging('OpenWindow', 0, bgc, [], [], [], [], 16);
ListenChar(2) ;  %关闭编辑器对键盘监听
HideCursor;
hz=FrameRate(w);
hz=round(hz);

if ~isempty(exp_hz)
    if hz~=exp_hz
        sca;
        error('刷新率与设定值不符')
    end
end

[xc,yc]=WindowCenter(w);
AssertOpenGL;
Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Priority(MaxPriority(w));
KbName('UnifyKeyNames');
Screen('TextSize',w,25);
Screen('TextFont',w,'-:lang=zh-cn');
rng('Shuffle');