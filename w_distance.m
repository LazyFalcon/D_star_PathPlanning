function dista=w_distance(p1, p2)
    vec = p1-p2;
    dista=sqrt(sum(vec.^2));
end