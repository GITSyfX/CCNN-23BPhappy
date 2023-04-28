
all_gif=dir(['*.gif']);
for i=1:length(all_gif)
    thisname=all_gif(i).name;
    info=imfinfo([thisname]);
    this_array={};
    for g=1:length(info)
        [A,map] = imread([thisname],'Frames',g);
        this_array{1,g}=A;
        this_array{2,g}=map;
%         img = ind2rgb(A,map);
    end
    all_gif(i).this_array=this_array;
    
    disp(i);
end

save('all_gif','all_gif');