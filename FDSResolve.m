function funOut = FDSResolve(state)
    
    funOut = resolve();
    
    
function out = b(x)
    out = x + [state.graph(x(1), x(2), 6); state.graph(x(1), x(2), 7);0;0];
end
function out = g(s) % 1 pozycja
    out = state.graph(s(1), s(2),1);
end % 3 pozycja

function out = resolve()
    s =state. startPos;
    out = [s];
    state.graph(s(1), s(2),1) = inf;
    uval = g(s);
        minval = inf;
    while ~isequal(s(1:2), state.endPos(1:2))
%         minval = inf;
%         it = [];
%         for n = state.ucc
%             u = s+n;
%                 uval  =  g(u);
%                 if uval < minval && ~isinf(uval) && uval > -1
%                         minval = uval;
%                         it = n;
%                 end
%         end
        
        s = b(s)
        out = [out, s];
        
    end
end


end 