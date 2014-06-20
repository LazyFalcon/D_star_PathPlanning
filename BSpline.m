function out = BSpline(points)
% p=(i,4)
% na wyjœciu wygenerowan¹ trasê
% stopnia
    %% DEBUG draw points
%      for i = 1:1:length(points)
%          hold on
%          drawPoint3d(points(i,:), 'ko');
%      end
%%
    n = 3;
    len = length(points(:,1));
    m = len-n;
    f = zeros(m,4);
    g = zeros(m,4);
    e = zeros(m+1,4);
    
    f(1,:) = points(2,:);
    g(1,:) = (points(2,:)+points(3,:))/2;
    
    for i = 2:m-1
       f(i,:) = (2*points(i+1,:) +points(i+2,:))/3;
       g(i,:) = (points(i+1,:) +2*points(i+2,:))/3;
    end
   
    f(m,:) = (points(m+3,:)+points(m+2,:))/2;
    g(m,:) = points(m+2,:);
    
    
    e(1,:) = points(1,:);
    for i = 2:1:m
        e(i,:) = (g(i-1,:)+f(i,:))/2;
    end
    e(m+1,:) = points(m+3,:);
    
    for i = 1:1:m
       BSpline{i} =  [e(i,:); f(i,:); g(i,:); e(i+1,:)];
%        DEBUG draw control points of bezier curves
%        drawPoint3d(e(i,:),'k+');
%        hold on
%        drawPoint3d(f(i,:),'b+');
%        drawPoint3d(g(i,:),'r+');
%        hold off
    end
    %% generate spline
    spline = [];
    t = 0:0.2:1;
% t = [0 0.5 1];
    for i = 1:1:length(BSpline)
        spline = [spline; bezier4(BSpline{i}, t, 3)];
    end
    
    out = Interpolate(round(spline),1, 'linear');
%     out = spline;
    
end



