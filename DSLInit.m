function out = DSLInit(startPos, endPos, map, scalling)
    radius = 10/4;
%     radius = 10;
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
    
    out.map = map;
    
    out.startPos = [floor((startPos(2:-1:1)+[24;24])/scalling); 0; 0];
    startPos = [floor((startPos(2:-1:1)+[24;24])/scalling); 0; 0];
    out.endPos = [floor((endPos(2:-1:1)+[24;24])/scalling); 0; 0];
    
    out.pattern = shapePattern';
    out.ucc = neighbours;
    out.height = ceil(length(out.map(:,1)));
    out.width = ceil(length(out.map(1,:)));
    out.graph = zeros(out.height, out.width,5);
    out.graph(:,:,1:2) = inf;
    out.graph(:,:,3) = false;
    out.graph(:,:,5) = -1;
    out.kM = 0;
    SQRT2 = sqrt(2)-1;
    out.comparator = DStarcmp;
    out.stack = java.util.PriorityQueue(180247, out.comparator);

    setRhs(out.endPos, 0);
    setQ(out.endPos);
    out.endPos(3:4) = [heur(out.endPos); 0];
    add(out.stack, out.endPos);
    
    
    %-----------------------------------------------------------
    function setQ(s) 
         out.graph(s(1), s(2), 3) = true;
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