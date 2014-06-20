function outState = DSLComputePath(state, limit)
% D-star Lite implementation


        if nargin ==1
            limit = inf;
        end
        startPos = state.startPos;
        endPos =  state.endPos;
        map = state.map;
        pattern = state.pattern;
        ucc = state.ucc;
        graph = state.graph;
        kM = state.kM;
        SQRT2 = sqrt(2)-1;
        stack = state.stack;
       
        
        found = false;
        computeShortestPath();
        
        if found
            fprintf('znaleziono rozwi¹zanie!: %d\n', graph( startPos(1), startPos(2),2 ));
            setg(startPos, rhs(startPos));
        end

        outState = state;
        outState.goal = startPos;
        outState.start = endPos;
        outState.graph = graph;
        outState.stack = stack;
        outState.length = graph( startPos(1), startPos(2),2 );
       
       
    function plotPos(s)
        for n = pattern
            pos = s + n';
            if isInRange(pos)
                outImg(pos(1), pos(2)) = 1;
            end
        end
    end
    function out = inQ(s) 
        out = graph(s(1), s(2), 3);
    end
    function setQ(s) 
         graph(s(1), s(2), 3) = true;
    end
    function rsetQ(s) 
         graph(s(1), s(2), 3) = false;
    end
    function incr(s)
        graph(s(1), s(2), 4) = graph(s(1), s(2), 4)+1;
    end
    %-----------------------------------------------------------
    function out = heur(s) 
            s = abs(startPos - s);
            out = SQRT2*min(s(1:2)) + max(s(1:2));
    %         out = sqrt(s(1)^2 + s(2)^2);
    end
    function out = g(s) 
        out = graph(s(1), s(2),1);
    end
    function setg(s, val)
        graph(s(1), s(2),1) = val;
    end
    %-----------------------------------------------------------
    function out = rhs(s) % 2 
        out = graph(s(1), s(2), 2);
    end
    %-----------------------------------------------------------
    function setRhs(s, val)
        graph(s(1), s(2),2) = val;
    end
    function out = calculateKey(s) %key :3i4  
        out =  [ 
                min( g(s), rhs(s) ) + heur(s) + kM; 
                min( g(s), rhs(s) ) 
            ];
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
    function out = cmp(s1, s2)%compare keys s1 > s2
        out = s1(1) < s2(1) || ( s1(1) ==s2(1) && s1(2) < s2(2));

    end
    %-----------------------------------------------------------
    function updatevertex(u)
                if g(u) ~= rhs(u) 
                        u(3:4) = calculateKey(u);
                        add(stack, u);
                        setQ(u);
                else
                        rsetQ(u)
                end                
    end
    %-----------------------------------------------------------
    function computeShortestPath()
        terminate = false;
        count = 0;
        mindist = inf;

        while ~terminate && size(stack)> 0

            count = count +1;
            if count >= limit
                break
            end
            u = remove(stack);

            if ~(  cmp(  u(3:4), calculateKey(startPos))  || rhs(startPos) ~= g(startPos) )
                found = true;          
                break
            end
            if ~inQ(u)
    %             fprintf('END\n');
                continue
            end % if node should't be in queue

            if isequal(u(1:2), startPos(1:2)) 
                found = true;
    %             mindist = min(mindist, g(u))
            end
            rsetQ(u);
            gu = g(u);
            ru = rhs(u);
    %         update key, unused
    %         k_old = u(3:4);
    %         k_new = calculateKey(u);
    %         if cmp( k_old, k_new )
    %                         u(3:4) = k_new;
    %                         add(stack, u);
    %                         setQ(u);
            if gu > ru 
                        setg(u, ru); 
                        gu = ru;
                        for n = ucc
                            s = u+n;
                            if rhs(s) == inf % unvisited
                                 if testNode(s)
                                        setRhs(s,  1 + gu);
                                        updatevertex(s);
                                 else
                                        setg(s, -1);
                                        setRhs(s, -1)
                                 end
                            else % visited
                                if rhs(s) > 1+gu
                                        setRhs(s,  1 + gu);
                                        updatevertex(s);
                                end
                            end

                        end
            end
        end
            fprintf('count: %d\n', count);
    end
end