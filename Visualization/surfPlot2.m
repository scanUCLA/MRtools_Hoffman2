function [h hh] = surfPlot2(obj)
%%% This function is for rendering FS surface data in matlab
%%%
%%% Written by Aaron P. Schultz - aschultz@martinos.org
%%%
%%% Copyright (C) 2014,  Aaron P. Schultz
%%%
%%% Supported in part by the NIH funded Harvard Aging Brain Study (P01AG036694) and NIH R01-AG027435 
%%%
%%% This program is free software: you can redistribute it and/or modify
%%% it under the terms of the GNU General Public License as published by
%%% the Free Software Foundation, either version 3 of the License, or
%%% any later version.
%%% 
%%% This program is distributed in the hope that it will be useful,
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%% GNU General Public License for more details.
%%%

pth = [fileparts(which('fsaverage.mat')) filesep];
load([pth obj.fsaverage '.mat']);

% load fsaverage_alt.mat

switch lower(obj.surface)
    case 'inflated'
        lVert = T.inflated.lVert;
        lFace = T.inflated.lFace;
        rVert = T.inflated.rVert;
        rFace = T.inflated.rFace;
        ucol = 'lightergray';
    case 'pial'
        lVert = T.pial.lVert;
        lFace = T.pial.lFace;
        rVert = T.pial.rVert;
        rFace = T.pial.rFace;
        ucol = 'gray';
    case 'white'
        lVert = T.white.lVert;
        lFace = T.white.lFace;
        rVert = T.white.rVert;
        rFace = T.white.rFace;
        ucol = 'lightgray';
    case 'pi'
        lVert = (T.inflated.lVert+T.pial.lVert)/2;
        lFace = (T.inflated.lFace+T.pial.lFace)/2;
        rVert = (T.inflated.rVert+T.pial.rVert)/2;
        rFace = (T.inflated.rFace+T.pial.rFace)/2;
        ucol = 'gray';
    otherwise
        error('Surface option Not Found:  Available options are inflated, pial, and white');
end

switch lower(obj.shading)
    case 'curv'
        lShade = -T.lCurv;
        rShade = -T.rCurv;
    case 'logcurv'
        lShade = -T.lCurv;
        sgn = sign(lShade); 
        if strcmpi('inflated',obj.surface)
            ind = abs(lShade)>0;
            lShade(ind) = lShade(ind)+(.15*sgn(ind));
        else
            ind = abs(lShade)>.1;
            lShade(ind) = lShade(ind)+(.05*sgn(ind));
        end
        
        
        rShade = -T.rCurv;
        sgn = sign(rShade); 
        if strcmpi('inflated',obj.surface)
            ind = abs(rShade)>0;
            rShade(ind) = rShade(ind)+(.15*sgn(ind));
        else
            ind = abs(rShade)>.1;
            rShade(ind) = rShade(ind)+(.05*sgn(ind));
        end
    case 'sulc'
        lShade = -(T.lSulc);
        rShade = -(T.rSulc);
    case 'thk'
        lShade = T.lThk;
        rShade = T.rThk;
    case 'mixed'
        lShade = -((1*(T.lSulc))+(4*(T.lCurv)));
        rShade = -((1*(T.rSulc))+(4*(T.rCurv)));
    otherwise
         error('Shading option Not Found:  Available options are curv, sulc, and thk');
end

if obj.newfig
    if obj.figno>0
        figure(obj.figno); clf;
        set(gcf,'color','k'); shg
    else
        figure; clf;
        set(gcf,'color','k'); shg
        obj.figno = gcf;
    end
    
    rang = obj.shadingrange;   
    [col1 cm cc] = cmap(zscore(lShade), rang, ucol);
        
    if obj.Nsurfs == 4;
        subplot(2,11,1:5);
        h(1) = patch('vertices',lVert,'faces', lFace,'FaceVertexCdata',col1);
        shading interp;
        axis equal; axis tight; axis off;
        view(270,0)
        
        subplot(2,11,12:16);
        h(2) = patch('vertices',lVert,'faces', lFace,'FaceVertexCdata',col1);
        shading interp;
        axis equal; axis tight; axis off;
        view(90,0)
    elseif obj.Nsurfs == 2;
        subplot(1,11,1:5);
        h(1) = patch('vertices',lVert,'faces', lFace,'FaceVertexCdata',col1);
        shading interp;
        axis equal; axis tight; axis off;
        view(270,0)
    elseif obj.Nsurfs == 1.9;
        subplot(2,11,1:10);
        h(1) = patch('vertices',lVert,'faces', lFace,'FaceVertexCdata',col1);
        shading interp;
        axis equal; axis tight; axis off;
        view(270,0)
        
        subplot(2,11,12:21);
        h(2) = patch('vertices',lVert,'faces', lFace,'FaceVertexCdata',col1);
        shading interp;
        axis equal; axis tight; axis off;
        view(90,0)
    elseif obj.Nsurfs == -1;    
        subplot(1,11,1:10);
        h(1) = patch('vertices',lVert,'faces', lFace,'FaceVertexCdata',col1);
        shading interp;
        axis equal; axis tight; axis off;
        view(270,0)
    end
    
    rang = obj.shadingrange;
    [col2 cm cc] = cmap(zscore(rShade), rang, ucol);
    
    if obj.Nsurfs == 4;
        subplot(2,11,6:10);
        h(3) = patch('vertices',rVert,'faces', rFace,'FaceVertexCdata',col2);
        shading interp;
        axis equal; axis tight; axis off
        view(90,0)
        
        subplot(2,11,17:21);
        h(4) = patch('vertices',rVert,'faces', rFace,'FaceVertexCdata',col2);
        shading interp;
        axis equal; axis tight; axis off
        view(270,0)
    elseif obj.Nsurfs == 2;
        subplot(1,11,6:10);
        h(2) = patch('vertices',rVert,'faces', rFace,'FaceVertexCdata',col2);
        shading interp;
        axis equal; axis tight; axis off
        view(90,0)
    elseif obj.Nsurfs == 2.1;
        subplot(2,11,1:10);
        h(3) = patch('vertices',rVert,'faces', rFace,'FaceVertexCdata',col2);
        shading interp;
        axis equal; axis tight; axis off
        view(90,0)
        
        subplot(2,11,12:21);
        h(4) = patch('vertices',rVert,'faces', rFace,'FaceVertexCdata',col2);
        shading interp;
        axis equal; axis tight; axis off
        view(270,0)
    elseif obj.Nsurfs == 1;
        subplot(1,11,1:10);
        h(1) = patch('vertices',rVert,'faces', rFace,'FaceVertexCdata',col2);
        shading interp;
        axis equal; axis tight; axis off
        view(90,0)
    end
        
else
    tmp = get(obj.figno,'UserData');
    col1 = tmp{1};
    col2 = tmp{2};
    h = tmp{3};
end

%%
if ischar(obj.input_lh);
    lVals = MRIread(obj.input_lh);
    lVals = lVals.vol(:)';
elseif isnumeric(obj.input_lh)
    lVals = obj.input_lh;
else
    lVals = zeros(1,numel(T.lSulc));    
end
lVals(~isfinite(lVals))=0;
try
    lVals(T.label.lh.unknown)=NaN;
catch end
try
    lVals(T.label.lh.corpuscallosum)=NaN;
catch end
try
    lVals(T.label.lh.undefined)=NaN;
catch end

if ischar(obj.input_rh);
    rVals = MRIread(obj.input_rh);
    rVals = rVals.vol(:)';
elseif isnumeric(obj.input_lh)
    rVals = obj.input_rh;
else
    rVals = zeros(1,numel(T.rSulc));
end
rVals(~isfinite(rVals))=0;
try
    rVals(T.label.rh.unknown)=NaN;
catch end
try
    rVals(T.label.rh.corpuscallosum)=NaN;
catch end
try
    rVals(T.label.rh.undefined)=NaN;
catch end

    
lVals = lVals(:);
rVals = rVals(:);

if obj.reverse==1
    lVals = lVals*-1;
    rVals = rVals*-1;
end

if isfield(obj,'round') && obj.round == 1;
    lVals = round(lVals);
    rVals = round(rVals);
end
%%%

if numel(obj.overlaythresh) == 1;
    if obj.direction == '+'
        ind1 = find(lVals>obj.overlaythresh);
        ind2 = find(rVals>obj.overlaythresh);
    elseif obj.direction == '-'
        ind1 = find(lVals<obj.overlaythresh);
        ind2 = find(rVals<obj.overlaythresh);
    end
else
    ind1 = find(lVals<=obj.overlaythresh(1) | lVals>=obj.overlaythresh(2));
    ind2 = find(rVals<=obj.overlaythresh(1) | rVals>=obj.overlaythresh(2));
end
%%%


val = max([abs(min([lVals; rVals])) abs(max([lVals; rVals]))]);
if obj.colorlims(1) == -inf
    obj.colorlims(1)=-val;
end
if obj.colorlims(2) == inf
    obj.colorlims(2)=val;
end


[cols CD] = cmap(lVals(ind1), obj.colorlims, obj.colomap);
% col1(lv(ind1)+1,:) = cols;
% set(h(1),'FaceVertexCdata',col1);
% set(h(2),'FaceVertexCdata',col1);

col = nan(size(col1));
col(ind1,:) = cols;
if obj.Nsurfs == 4;
    subplot(2,11,1:5);
    hh(1) = patch('vertices',lVert,'faces', lFace,'FaceVertexCdata',col);
    shading interp
    subplot(2,11,12:16);
    hh(2) = patch('vertices',lVert,'faces', lFace,'FaceVertexCdata',col);
    shading interp;
elseif obj.Nsurfs == 1.9;
    subplot(2,11,1:10);
    hh(1) = patch('vertices',lVert,'faces', lFace,'FaceVertexCdata',col);
    shading interp
    subplot(2,11,12:21);
    hh(2) = patch('vertices',lVert,'faces', lFace,'FaceVertexCdata',col);
    shading interp;    
elseif obj.Nsurfs == 2;
    subplot(1,11,1:5);
    hh(1) = patch('vertices',lVert,'faces', lFace,'FaceVertexCdata',col);
    shading interp
elseif obj.Nsurfs == -1;
    subplot(1,11,1:10);
    hh(1) = patch('vertices',lVert,'faces', lFace,'FaceVertexCdata',col);
    shading interp
end


[cols CD] = cmap(rVals(ind2), obj.colorlims ,obj.colomap);
% col2(rv(ind2)+1,:) = cols;
% set(h(3),'FaceVertexCdata',col2);
% set(h(4),'FaceVertexCdata',col2);

col = nan(size(col2));
col(ind2,:) = cols;
if obj.Nsurfs == 4;
    subplot(2,11,6:10);
    hh(3) = patch('vertices',rVert,'faces', rFace,'FaceVertexCdata',col);
    shading interp
    subplot(2,11,17:21);
    hh(4) = patch('vertices',rVert,'faces', rFace,'FaceVertexCdata',col);
    shading interp;
elseif obj.Nsurfs == 2.1;
    subplot(2,11,1:10);
    hh(3) = patch('vertices',rVert,'faces', rFace,'FaceVertexCdata',col);
    shading interp
    subplot(2,11,12:21);
    hh(4) = patch('vertices',rVert,'faces', rFace,'FaceVertexCdata',col);
    shading interp;    
elseif obj.Nsurfs == 2;
    subplot(1,11,6:10);
    hh(2) = patch('vertices',rVert,'faces', rFace,'FaceVertexCdata',col);
    shading interp
elseif obj.Nsurfs == 1;
    subplot(1,11,1:10);
    hh(1) = patch('vertices',rVert,'faces', rFace,'FaceVertexCdata',col);
    shading interp
end

set(gcf,'UserData',{col1 col2,h});

% drawnow;

if obj.Nsurfs == 4 || obj.Nsurfs == 1.9 || obj.Nsurfs == 2.1;
    subplot(2,11,[11 22]);
else 
    subplot(1,11,[11]);
end
% return;
% cla
% keyboard;
mp = [];
mp(1:256,1,1:3) = CD;
ch = imagesc((1:256)');
set(ch,'CData',mp)

% keyboard
% cb = colorbar(CD);

try
[cl trash indice] = cmap(obj.overlaythresh,obj.colorlims,obj.colomap);
catch
    keyboard;  
end
% keyboard;
tickmark = unique(sort([1 122 255 indice(:)']));
ticklabel = round(unique(sort([obj.colorlims(1) mean(obj.colorlims) obj.colorlims(2) obj.overlaythresh])')*100)/100;

% tickmark = [1 122 255]';
% ticklabel = [obj.colorlims(1) mean(obj.colorlims) obj.colorlims(2)]';
set(gca,'YDir','normal','YAxisLocation','right','XTick',[],'YTick',(tickmark),'YTickLabel',(ticklabel),'fontsize',14,'YColor','w');
shading interp



