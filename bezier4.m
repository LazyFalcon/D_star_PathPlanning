function out=bezier4(bez,t,n)
% bezier trzeciego stopnia, przez 4 punkty
% t=0:1
% bez:macierz 4 punktów, u³orzone wierszowo  
        len = length(t);
        out = zeros(len,length(bez(1,:)));
%         bez = ceil(bez);
        for i = 1:1:len
            k = bez(1,end)*(w_b(t(i),n,0));
            l = bez(2,end)*(w_b(t(i),n,1));
            m = bez(3,end)*(w_b(t(i),n,2));
            u = bez(4,end)*(w_b(t(i),n,3));
            
           
            
            out(i,:) = (k*bez(1,:)+l*bez(2,:)+m*bez(3,:)+u*bez(4,:))/(k+l+m+u);
        end

        
end