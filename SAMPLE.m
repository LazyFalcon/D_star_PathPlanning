%% init java, run at begin, once
% necessary to  load java files
% clear java
% javaclasspath(pwd)
%% steps:
% - load maps
% - choose algorithm (DSL: D*Lite; FDS: Focussed D*, AS: A*)
% - do initial search
% -(optional) resolve path
% - update map
% - search in updated map
% - resolve path

%% load maps
mapsNames = {'a', 'e', 'b', 'c','map01'};
maps = {};
%scalling should be 1(original map) or 4(downscalled map for better performance)
scalling = 4;
for i=1:1: length(mapsNames)
        tmp = LoadMap(  strcat(mapsNames{i}, '.png'), scalling);
        start = tmp.start';
        goal = tmp.goal';
    maps{end+1} = tmp.map;
end

%% initial search
DSL = 0;
FDS = 1;
AS = 0;
bool = 0;
clc
close all
tic 
    if DSL
        state = DSLInit(start, goal, maps{1}, scalling);
        state = DSLComputePath(state);
    elseif FDS
        state = FDSInit(start, goal, maps{1}, scalling);
        state = FDSComputePath(state);
    elseif AS
        state = ASInit(start, goal, maps{1}, scalling);
        state = ASComputePath(state);
    end
    bool = 1;
toc
gah = state;
%% update map, search in update map, run twice
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
            state = FDSUpdateMap(state, maps{2}); 
            state.kM = 50;
        else
            state = FDSComputePath(state);
        end
    end
toc
%% resolve path, insert map name here if you want to get image in original size when map was downscalled
    state.path = ResolvePath(state);         
    resp = PlotPath(state, scalling, 'e');

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




