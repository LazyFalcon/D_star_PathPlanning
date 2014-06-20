function outState = DSLUpdateMap(state, newMap)
    
        startPos = state.startPos;
        endPos =  state.endPos;
        pattern = state.pattern;
        ucc = state.ucc;
        graph = state.graph;
        kM = state.kM;
        SQRT2 = sqrt(2)-1;
        stack = state.stack;
        imag = map;
        i1 = map;
        i2 = map;
            
        
        comparator = pcmp;
        stack2= java.util.PriorityQueue(180247, comparator);
        comparator = pcmp;
        stack3= java.util.PriorityQueue(180247, comparator);
        
				map = newMap;
							
        difference = map - state.map;
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
                        k = u+n;
                        if map(k(1), k(2)) ~= 0 && rhs(k) ~=-1 && test(k)
                            tmp = min(tmp, 1+rhs(k));
                        end
                end
                     setRhs(u, tmp);
                    setg(u, inf);
                    u(3:4) = [heur(u),0];
                    add(stack, u);
                    setQ(u);
        end
        if ~isempty(removed)
%                 setRhs(state.startPos, inf);
%                 setg(state.startPos, inf);
%                 rsetQ(state.startPos);
        end
        if ~isempty(added)
            a =  graph(:,:,1);
            b =  graph(:,:,2);
            c =  graph(:,:,3);
            d = c;
            d(:,:) = 0;

            a(sub2ind(size(a), added(1,:), added(2,:))) = inf;
            b(sub2ind(size(a), added(1,:), added(2,:))) = inf;
            c(sub2ind(size(a), added(1,:), added(2,:))) = 0;

            graph(:,:,1) = a;
            graph(:,:,2) = b;

            cnt = [];
            for u = added
                 for n = ucc 
                            s = u+n;
                            if  rhs(s) < rhs(u) && ~isinf(rhs(s))
                                cnt = [cnt, s];
                            end
                 end
            end

            c(sub2ind(size(c), cnt(1,:), cnt(2,:))) = 1;

            % w tej pêtli nalezy wybraæ komórki które straci³y kontakt z reszt¹
            toClear = [];
            for u = cnt
                hasNbr  = false;

                % szukamy s¹siadów
                 for n = ucc 
                            s = u+n;
                            if  ~inQ(s) && g(s)<g(u) && ~isinf(rhs(s))
                                hasNbr = true;
                            end
                 end
                 % jesli jego poprzednik ma niezmieony koszt to zostawamy w
                 % spokoju, jesli jego poprzednik ma zmieniony koszt to
                 % propagujemy zmianê
                 if ~hasNbr
                    u(3:4) = [ g(u),0];
                    add(stack3, u);
                 else
    %                 u(3:4) = [ g(u),0];
    %                 setQ(u);
    %                  add(stack, u);
                 end

            end

            clearChilds()



    %         graph(:,:,3) = c;


            a = graph(:,:,1);
            b = graph(:,:,2);
            c = graph(:,:,3);

            a(a(:,:)~=inf) = 1;
            a(a(:,:)==inf) = 0;
            b(b(:,:)~=inf) = 1;
            b(b(:,:)==inf) = 0;
            dif = b-a;
    %         figure
    %         imshow(dif)
    %         c(dif(:,:)>0) = 1;
    %         figure
    %         imshow(c)
    %         figure
    %         imshow(c+dif)
            graph(:,:,3) = graph(:,:,3)+dif;
        end
        outState = state;
        outState.graph = graph;
        outState.map = map;
        outState.stack = stack;
%%
    function out = inQ(s) 
        out = graph(s(1), s(2), 3);
    end
    function setQ(s) 
         graph(s(1), s(2), 3) = true;
    end
    function rsetQ(s) 
         graph(s(1), s(2), 3) = false;
    end
    function out = heur(s)
            k = abs(startPos - s);
            out = SQRT2*min(k(1:2)) + max(k(1:2));
    end
    function out = g(s) 
        out = graph(s(1), s(2),1);
    end 
    function setg(s, val)
        graph(s(1), s(2),1) = val;
    end
    function out = rhs(s) 
        out = graph(s(1), s(2), 2);
    end
    function setRhs(s, val)
        graph(s(1), s(2),2) = val;
    end
    function out = calculateKey(s) 
        out =  [ 
                min( g(s), rhs(s) ) + heur(s) + kM; 
                min( g(s), rhs(s) ) 
            ];
    end

    function clearChilds()
        while size(stack3)>0
            u = remove(stack3);
            g_old = g(u);
            setg(u, inf)
            setRhs(u, inf)
            rsetQ(u);
             for n = ucc 
                                s = u+n;
                                if  d(s(1), s(2)) == 0 && ~isinf(rhs(s)) && rhs(s) > g_old  &&map(s(1), s(2)) ~= 0 
                                        d(s(1), s(2)) = 1;
                                        s(3:4) = [ g(s),0];
                                        add(stack3, s);
                                        rsetQ(s);
                                elseif ~isinf(g(s)) && g(s) == g_old-1 && map(s(1), s(2)) ~= 0 
                                        add(stack2, s);
                                        setg(s, inf)
                                end
             end
        end
        %--------------------------------
        while size(stack2)>0
            u = remove(stack2);
                for n = ucc 
                        s = u+n;
                        if ~isinf(g(s))
                            u(3:4) = [ rhs(u),0];
                            add(stack, u);
                            setQ(u);
                            break    
                        end
                end
        end
    end


end