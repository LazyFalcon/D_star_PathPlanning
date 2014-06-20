function outState = FDSComputePath(state, limit)
% Focussed D-star implementation
    if nargin ==1
        limit = inf;
    end

%         enums
        NEW = -1;
        OPEN = 1;
        CLOSED = 0;
        
        
        startPos = state.startPos;
        endPos =  state.endPos;
        map = state.map;
        pattern = state.pattern;
        ucc = state.ucc;
        graph = state.graph;
        template  = zeros(state.height, state.width);
        outImg = zeros(state.height, state.width);
        outImg(:,:) = 0;
        kM = state.kM;
        SQRT2 = sqrt(2)-1;
        stack = state.stack;
        mindist = inf;  
        
        vis = zeros(size(map));
        
        last = [];
        found = false;
        computeShortestPath();
         state.exist = found;
        if found
            fprintf('znaleziono rozwi¹zanie!: %d\n', graph( startPos(1), startPos(2),2 ));
            seth(startPos, k(startPos));
        end

        outState = state;
        outState.goal = startPos;
        outState.start = endPos;
        outState.graph = graph;
        outState.stack = stack;
        outState.length = graph( startPos(1), startPos(2),2 );


%-----------------------------------------------------------
function out = inQ(s) 
    out = graph(s(1), s(2), 3);
end
function out = t(s) % node state(open, closed etc) 
    out = graph(s(1), s(2), 3);
end
function sett(s, val) 
    graph(s(1), s(2), 3) = val;
end
function setQ(s) 
     graph(s(1), s(2), 3) = 1;
end
function rsetQ(s) 
     graph(s(1), s(2), 3) = 0;
end
function incr(s)
    graph(s(1), s(2), 4) = graph(s(1), s(2), 4)+1;
end
function out = b(x)
    out = x + [graph(x(1), x(2), 6);graph(x(1), x(2), 7);0;0];
end
function setb(x, y)
    graph(x(1), x(2), 6:7) = y(1:2) - x(1:2);
end
%-----------------------------------------------------------
function out = g(s) % heurestic
        s = abs(startPos - s);
%         s = abs(endPos - s);
%         out = SQRT2*min(s(1:2)) + max(s(1:2));
        out = sqrt(s(1)^2 + s(2)^2);
end
function out = h(s)% distance from start 
    out = graph(s(1), s(2),1);
end 
function seth(s, val)
    graph(s(1), s(2),1) = val;
end
%-----------------------------------------------------------
function out = k(s) 
    out = graph(s(1), s(2), 2);
end
function setk(s, val)
    graph(s(1), s(2),2) = val;
end
%-----------------------------------------------------------
function out = calculateKey(x)
    out =  [ 
          h(x)+g(x)+kM;
          min(h(x), k(x))
        ];
end
function out = calculateKey2(x) 
    out =  [ 
           k(x)+kM
          min(h(x), k(x))
        ];
end
function out = testNode(s) % true
    out = true;
    if template(s(1), s(2)) == 1
        out = false;
        return
    end
    for n = pattern
        pos = s + n;
        if map(pos(1), pos(2)) == 0
            out = false;
            template(s(1), s(2)) = 1;
%             graph(s(1), s(1), 5) = 0;
%             setg(s, -1) 
            return
        end
    end
end
function out = cmp(s1, s2)% s1 > s2
    out = s1(1) < s2(1) || ( s1(1) ==s2(1) && s1(2) < s2(2));
end
%-----------------------------------------------------------
function insert(s, h_new)
        % aktualizuje g(s), iweijgrijgiiEGWNAGRKEPORORPO
        t = inQ(s);
        if t == NEW && h_new < mindist
            setk(s, h_new);
        else
            if t == OPEN && h_new < mindist
                setk(s, min(k(s), h_new) );
            elseif h_new < mindist
                setk(s, min(h(s), h_new) );
            end
        end
        seth(s, h_new);
        s(3:4)  = calculateKey(s);
        add(stack, s);
        sett(s, OPEN);
        
end
function insert2(s, h_new)
        % aktualizuje g(s), iweijgrijgiiEGWNAGRKEPORORPO
        t = inQ(s);
        if t == NEW && h_new < mindist
            setk(s, h_new);
        else
            if t == OPEN && h_new < mindist
                setk(s, min(k(s), h_new) );
            elseif h_new < mindist
                setk(s, min(h(s), h_new) );
            end
        end
        seth(s, h_new);
        s(3:4)  = calculateKey2(s);
        add(stack, s);
        sett(s, OPEN);
        
end
%-----------------------------------------------------------
function computeShortestPath()
    terminate = false;
    count = 0;
    c1 = 0;
    c2 = 0;
    c3 = 0;

    while ~terminate && size(stack)> 0
        
        if count > limit
            terminate = true;
        end
        count = count +1;
        x = remove(stack);
        if t(x) == CLOSED
            continue
        end
        
        val = x(3:4);
        k_val = k(x);
        h_val = h(x);
        rsetQ(x); 
        
    if testNode(x)
       if h_val > k_val% && h(x) < mindist % RAISE
                        for n = ucc
                                y = x+n;
                                if t(y) ~= NEW  &&  k(x)== k(y) + 1
                                    seth(x, h(y)+1);
                                    h_val = h(x);
                                    setb(x,y)
                                    c1 = c1+1;
                                end
                        end
       end
        if k_val == h(x) && h(x) < mindist % LOWER
                        c2 = c2+1;
                        for n = ucc
                                y = x+n;
                                if t(y) == NEW || h(y) > h_val+1%(isequal(b(y),x) && h(y) ~= h_val+1 ) || (~isequal(b(y),x)  && h(y) > h_val+1)
                                    insert(y, h_val+1);
                                    setb(y,x)
                                end
                        end
                        if isequal(x(1:2), startPos(1:2))    
                            found = true;
                            mindist = min(mindist, h(x))+1;
                            break
                        end
        elseif h_val < mindist || isinf(h_val) % propagate RAISE state
                        for n = ucc
                                y = x+n;
                                if t(y) == NEW || (  h(y) ~= h_val+1) && vis(y(1), y(2))~=1
                                    c3 = c3+1;
                                    vis(y(1), y(2))=1;
                                    insert2(y, h_val+1);
                                    setb(y,x);
                                else
                                    if ~isequal(b(y),x)  && h(y) > h_val+1 && t(x) == CLOSED
                                        insert2(x, h_val);
                                    elseif  ~isequal(b(y),x)  &&   h_val > h(y)+1 && t(y) == CLOSED && cmp(calculateKey(y), val)
                                        insert2(y, h(y));
                                    end
                                end
                        end
        end    
    else
        sett(x, CLOSED);
        setk(x, inf)
        seth(x, inf)
    end   


    end
        fprintf('count: %d\n', count);
        fprintf(' %d   %d   %d\n', c1,c2,c3);
end
end