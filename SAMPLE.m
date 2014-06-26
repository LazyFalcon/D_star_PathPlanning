%% init java
% clear java
% javaclasspath(pwd)
%% load maps
mapsNames = {'a', 'e', 'b', 'c','map01'};
maps = {};
for i=1:1: length(mapsNames)
        tmp = LoadMap(  strcat(mapsNames{i}, '.png'), 4);
        start = tmp.start';
        goal = tmp.goal';
    maps{end+1} = tmp.map;
end

%% initial search
DSL = 0;
FDS = 1;
AS = 0;
clc
close all
tic 
    if DSL
        state = DSLInit(start, goal, maps{1}, 4);
        state = DSLComputePath(state);
    elseif FDS
        state = FDSInit(start, goal, maps{2}, 4);
        state = FDSComputePath(state);
    elseif AS
        state = ASInit(start, goal, maps{1}, 4);
        state = ASComputePath(state);
    end
    bool = 1;
toc
gah = state;
%% update map
state.kM = 50;
close all
tic
    if DSL
        if bool 
            bool = 0;
            state = DSLUpdateMap(state, maps{2});
        else
            state = DSLComputePath(state);
        end
    elseif FDS
        if bool 
            bool = 0;
            state = FDSUpdateMap(state, maps{1}); 
            state.kM = 50;
        else
            state = FDSComputePath(state);
        end
    end
toc
a = state.graph(:,:,1);
a(a(:,:)~=inf) = 0.3;
a(a(:,:)==inf) = 0;
a(state.map(:,:)==0) = 0.2;
b = state.graph(:,:,3);
b( state.map(:,:)==0 ) = 0;
b( state.graph(:,:,2)==inf ) = 0;
b = b*0.7;
imshow(b+a, 'Border', 'tight')
%% resolve path 
    state.path = ResolvePath(state);         
    resp = PlotPath(state, 4, 'a');

%% show A-star graph
a = state.graph(:,:,1);
a(a(:,:)==-1) = 0; % unvisited
a(state.map(:,:)==0) = 0.2; % obstacles
a(a(:,:)==inf) = 0;
a(a(:,:)>=1) = 0.3;
imshow(a)
%% show D-star graph
% figure
% obstacles 0.2
% visited : 0.3
% unavailble, unvisited: 0
% in queue: 1 
% in queue and g-val == inf: 0.7
a = state.graph(:,:,1);
a(a(:,:)~=inf) = 0.3;
a(a(:,:)==inf) = 0;
a(state.map(:,:)==0) = 0.2;
b = state.graph(:,:,3);
b( state.map(:,:)==0 ) = 0;
b( state.graph(:,:,2)==inf ) = 0;
b = b*0.7;
imshow(b+a, 'Border', 'tight')




