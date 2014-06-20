function out = PlotPath(state, scalling)
% uses B-spline interpolation    


    if nargin ==1
        scalling = 1;
    end

    path = state.path';
    path(:,3) = 1;
    path(:,4) = 1;
    if scalling ~= 1
        pathInterpolated = BSpline(path*scalling);
    %     pathInterpolated = BSpline(path);
    else
        pathInterpolated = path;
    end
    %%5
    imag = state.map;
    for it = pathInterpolated'
        a = round(it);
        imag(a(1), a(2)) = 0.6;
    end
    figure(100)
    out.handle = imshow(imag);
    out.path = pathInterpolated;
    
end