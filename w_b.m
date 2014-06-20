function out=w_b(t,n,i)
%     wielomian bazowy berensteina
%     nchoosek: dwumian newtona
    if i<0 || i>n
       out = -1;
    else
        out=nchoosek(n,i)*(t^i)*(1-t)^(n-i);
    end
end