function funOut = ResolvePath(state)
    
    funOut = resolve();
    
    
    
    function out = g(s) % 1 pozycja
        out = state.graph(s(1), s(2),1);
    end % 3 pozycja

    function out = resolve()
    s =state.goal;
    out = [s];
    state.graph(s(1), s(2),1) = inf;
    uval = g(s);
    minval = inf;
    while ~isequal(s(1:2), state.start(1:2))
        minval = inf;
        it = [];
        for n = state.ucc
            u = s+n;
                uval  =  g(u);
                if uval < minval && ~isinf(uval) && uval > -1
                        minval = uval;
                        it = n;
                end
        end
        
        if isempty(it)
            fprintf('there is no valid path\n');
            return
        end
        s = s + it;
        state.graph(s(1), s(2),1) = inf;
        out = [out, s];
        
    end
    end


end 