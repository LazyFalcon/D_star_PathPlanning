function out = simplifyMap(map, scalling)
% rescale map

mapB = map;
[a,b] = size(mapB);
out = zeros(a/scalling,b/scalling);
[c,d] = size(out);

s = scalling;
a = floor((scalling-1)/2);
b = scalling - a;

for x=1:1:c-1
    for y=1:1:d-1
        tmp = sum( sum(  mapB( x*s-a:x*s+b, y*s-a:y*s+b  )   ));
        if tmp<12
            out(x,y) = 0;
        else
            out(x,y) = 1;
        end        
    end
end