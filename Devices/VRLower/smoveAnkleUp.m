function smoveAnkleUp(world_handles) 
    J0 = 0;
    J1 = -0.1;
    J2 = -0.5;
    speed = 0.01;
    human_reset_right(world_handles);
    youjiao = world_handles.youjiao;
    youdatui = world_handles.youdatui;     youdatui.rotation   = [1 0 0 -1];
    youxiaotui = world_handles.youxiaotui; youxiaotui.rotation = [1 0 0 1];
    
    % - It is a STATE, rather than a on-going course.
    youjiao.rotation = [1 0 0 J2];
%     for i=J0:J1:J2
%         youjiao.rotation = [1 0 0 i];
%         pause(speed);
%     end 
end