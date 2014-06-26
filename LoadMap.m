function out = LoadMap(name, scalling)
% returns structure:{map, start, goal}, rescale map
    if nargin ==1
        scalling = 1;
    end
    [robot_xy,target_xy,map] = segmentation(name,0.1,0.9,0.5);
    if scalling ~= 1
        map = simplifyMap(map, scalling);
    end
		
		[a,b] = size(map);
		out.map = zeros(a+10, b+10);
		out.map(5:end-6, 5:end-6) = map;
		
    out.start = floor(robot_xy/scalling) + [5,5];
    out.goal = floor(target_xy/scalling) + [5,5];
end



