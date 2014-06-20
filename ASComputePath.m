function outState = AStarNPQ(state, limit)
% heurestic A-star implementation
% heurestic function: euclidean distance to goal

% g(x): cost from start to x
% -1: unvisited node
% inf: not available


    if nargin ==1
        limit = inf;
    end
    startPos = state.startPos;
    endPos =  state.endPos;
    map = state.map;
    pattern = state.pattern;
    ucc = state.ucc;
    graph = state.graph;
    found = false;
    stack = state.stack;
    last = [];
    computeShortestPath();
    
    if found
        fprintf('znaleziono rozwi¹zanie!\n');
    end
    
    outState = state;
    outState.goal = endPos;
    outState.start = startPos;
    outState.graph = graph;
    outState.stack = stack;
    outState.length = graph( startPos(1), startPos(2),1 );
%-----------------------------------------------------
    function out = g(s)
        out = graph(s(1), s(2));
    end
    function setg(s, val)
        graph(s(1), s(2)) = val;
    end
    function out = heur(s)
            s = endPos - s;
            out = sqrt(s(1)^2 + s(2)^2);
    end
    function out = testNode(s) % true if available
        out = true;
        for n = pattern
            pos = s + n;
            if map(pos(1), pos(2)) == 0
                out = false;
                return
            end
        end
    end

    function computeShortestPath()
        terminate = false;
        count = 0;
        % minimal distance to goal
        mindist = inf;

        while ~terminate && size(stack)>0
            count = count +1;
            if count >=limit
                break
            end
            s = remove(stack);
            sval = g(s);
            % for each neighbor
            for n = ucc
                u = s+n;
                uval = g(u);
                if uval == -1 % unvisited point
                                if testNode(u)  && uval < mindist
                                        setg(u, sval+1); % increment g-value
                                        u(3) = sval+1 + heur(u);
                                        add(stack, u);
                                else
                                        setg(u, inf); % set as not available
                                end

                % if visited
                elseif uval > sval+1 && ~isinf(uval) && sval <= mindist
                                setg(u, sval+1)
                                u(3) = sval+1 + heur(u);
                                add(stack, u);
                end

                if isequal(u(1:2), endPos(1:2))
                    found = true;
                    mindist = min(mindist, uval);
                    last = u;
                end
            end
        end
        fprintf('count: %d\n', count);
    end
end