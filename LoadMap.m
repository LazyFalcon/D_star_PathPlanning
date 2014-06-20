function out = LoadMap(name, scalling)
% returns structure:{map, start, goal}, rescale map
    if nargin ==1
        scalling = 1;
    end
    [robot_xy,target_xy,out.map] = segmentation(name,0.1,0.9,0.5);
    if scalling ~= 1
        out.map = simplifyMap(out.map, scalling);
    end
    out.start = robot_xy;
    out.goal = target_xy;
end



