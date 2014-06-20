function out = FDSInit(startPos, endPos, map, scalling)
   
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
    state.startPos = [startPos(2:-1:1) 0; 0];
    state.endPos = [endPos(2:-1:1); 0; 0];
    startPos = out.startPos;
    
		out.sacalling = scalling;
    out.pattern = shapePattern';
    out.ucc = neighbours;
    out.height = ceil(length(out.map(:,1)));
    out.width = ceil(length(out.map(1,:)));
    out.graph = zeros(out.height, out.width,7);
    out.graph(:,:,1:2) = inf;
    out.graph(:,:,3) = -1;
    out.graph(:,:,5) = -1;
    out.graph(:,:,6) = 0;
    out.graph(:,:,7) = 0;
    out.kM = 0;
    SQRT2 = sqrt(2)-1;
    out.comparator = DStarcmp;
    out.stack = java.util.PriorityQueue(180247, out.comparator);

    setRhs(out.endPos, 0);
    setg(out.endPos, 0);
    setQ(out.endPos);
    out.endPos(3:4) = [heur(out.endPos); 0];
    add(out.stack, out.endPos);
    
    
    %-----------------------------------------------------------
    function setQ(s)
         out.graph(s(1), s(2), 3) = 1;
    end
    function setg(s, val)
        out.graph(s(1), s(2),1) = val;
    end
    function setRhs(s, val)
        out.graph(s(1), s(2),2) = val;
    end
    function out = heur(s) 
        k = abs(startPos - s);
        out = SQRT2*min(k(1:2)) + max(k(1:2));
    end
    


end