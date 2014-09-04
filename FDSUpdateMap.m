function outState = FDSUpdateMap(state, newMap)
%         enums
        NEW = -1;
        OPEN = 1;
        CLOSED = 0;
    
        startPos = state.startPos;
        endPos =  state.endPos;
        pattern = state.pattern;
        ucc = state.ucc;
        graph = state.graph;
        kM = state.kM;
        SQRT2 = sqrt(2)-1;
        stack = state.stack;
        
        comparator = pcmp;
        stack2= java.util.PriorityQueue(180247, comparator);
        comparator = pcmp;
        stack3= java.util.PriorityQueue(180247, comparator);

        map = newMap;	
        difference = map - state.map;
        state.map = map;
        %% ---------------addObstacle
        [x, y] = find(difference == -1);
        indices = [x,y];
        indices(:,3:4) = 0;

        Ind = [indices'];

        for n=indices'
            for s=state.pattern
                Ind = [Ind, n+s];
            end
        end
        
        added = unique(Ind', 'rows')';
        %% ---------------rmvObstacle
        [x, y] = find(difference == 1);
        indices = [x,y];
        indices(:,3:4) = 0;

        Ind = [indices'];

        for n=indices'
            for s=state.pattern
                Ind = [Ind, n+s];
            end
        end
        
        removed = unique(Ind', 'rows')';
        %% ----------------- process
        for u = removed
             tmp = inf;
                for n = ucc
                       s = u+n;
                            insert(s, h(s))
                end
        end   
        for u = added
             tmp = inf;
                for n = ucc
                       s = u+n;
                        if t(s) == CLOSED && h(s) ~= inf
                            seth(s, inf);
                            s(3:4)  = [-k(s)+kM; k(s)+g(s)];
                            add(stack, s);
                            sett(s, OPEN);
                        end
                end
        end
        outState = state;
        outState.graph = graph;
        outState.map = map;
        outState.stack = stack;
%%
function out = inQ(s) 
    out = graph(s(1), s(2), 3);
end
function out = t(s) 
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
%-----------------------------------------------------------
function out = g(s) 
        s = abs(startPos - s);
%         s = abs(endPos - s);
%         out = SQRT2*min(s(1:2)) + max(s(1:2));
        out = sqrt(s(1)^2 + s(2)^2);
end
function out = h(s) 
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
%           min( h(x), k(x)+g(x));
          min(h(x), k(x))
        ];
end
function out = testNode(s) 
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
function out = cmp(s1, s2)
    out = s1(1) < s2(1) || ( s1(1) ==s2(1) && s1(2) < s2(2));
end
function insert(s, h_new)
        t = inQ(s);
        if t == NEW
            setk(s, h_new);
            seth(s, h_new);
        else
            if t == OPEN 
                setk(s, min(k(s), h_new) );
            else
                setk(s, min(h(s), h_new) );
                seth(s, h_new);
            end
            s(3:4)  = [k(s)+kM+g(s); k(s)+g(s)];
            add(stack, s);
            sett(s, OPEN);
        end
        
end

end