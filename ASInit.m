function state = ASInit(startPos, endPos, map)
  
%% generate shape pattern
    radius = 10/scalling;
    mat = zeros(radius*2,radius*2);
    dista = @(a,b) sqrt(a*a+b*b);

    shapePattern = [];

    for x = 1:1:2*radius
        for y =1:1:2*radius
            if dista(x-radius-0.5,y-radius-0.5) > radius -1 && dista(x-radius-0.5,y-radius-0.5) < radius 
                mat(x,y) = 1;
                shapePattern = [shapePattern; floor(x-radius) floor(y-radius) 0 0];
            end
        end
    end
    
    neighbours = [
        0 1 0 0;
        -1 0 0 0;
        0 -1 0 0;
        1 1 0 0;
        -1 -1 0 0;
        1 0 0 0;
        1 -1 0 0;
        -1 1 0 0;
    ]';

%% prepare all data
    
	state.map = map;
    state.startPos = [startPos(2:-1:1); 0; 0];
    state.endPos = [endPos(2:-1:1); 0; 0];
    
    state.pattern = shapePattern';
    state.ucc = neighbours;
    state.height = ceil(length(state.map(:,1)));
    state.width = ceil(length(state.map(1,:)));
    state.graph = zeros(state.height, state.width,1);
    state.graph(:,:,1) = -1;
    
    % set comparator 
    state.comparator = pcmp;
    state.stack = java.util.PriorityQueue(180247, state.comparator);
     
    %insert first node
    setg(state.startPos, 0);
    state.startPos(3:4) = [heur(state.startPos); 0];
    add(state.stack, state.startPos);
    
%%
function out = heur(s)
        s = state.endPos - s;
        out = sqrt(s(1)^2 + s(2)^2);
end
function setg(s, val)
    state.graph(s(1), s(2)) = val;
end
    
end