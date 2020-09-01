function [MaskBW, BWthreshold] = segmentHead(Img, MaskComet, ThreshAdditiveFactor, SizeDiskDilation, flag_ThresholdMode)
% AUTHOR: Filippo Piccinini (E-mail: filippo.piccinini85@gmail.com)
% DATE: March 21, 2017
% NAME: segmentHead (version 1.0)
% 
% To segment the comet region.
%
% PARAMETERS:
% 	Img                 Original image.
%   ManualSegmBW        FG manually segmented.
%   ThreshAdditiveFactor Input additive factor for threshold.
%   SizeDiskDilation    Size of the dilation.
%   flag_ThresholdMode  The decide which automatic threshold modality use.
%                       1=Otsu, 2=Triangle, 3=average between Otsu and
%                       Triangle.
%
% OUTPUT:
%   MaskBW              Output binary mask.
%
% EXAMPLE OF USAGE:
%   Mask = segmentHead(Img, MaskOri);
 
% Copyright � 2015 Filippo Piccinini 
% Istituto Scientifico Romagnolo per lo Studio e la Cura dei Tumori (IRST) 
% IRCCS, Meldola (FC), Italy. All rights reserved.
%
% This program is free software; you can redistribute it and/or modify it 
% under the terms of the GNU General Public License version 2 (or higher) 
% as published by the Free Software Foundation. This program is 
% distributed WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
% General Public License for more details.

if nargin<5
    flag_ThresholdMode = 1;
end
if nargin<4
    flag_ThresholdMode = 1;
    SeDiskDilation = 0;
end
if nargin<3
    flag_ThresholdMode = 1;
    SeDiskDilation = 0;
    ThreshAdditiveFactor = 0;
end

MaskComet = uint8(MaskComet);

[yrowOri, xcolOri, chsz] = size(Img);
imageComulative = Img(MaskComet>0);
%[n,xout] = hist(imageComulative(:),[0:1:255]); figure, bar(xout,n./sum(n)), grid, axis([0 255 0 0.1])


% Automatic threshold
if flag_ThresholdMode == 1
    % Otsu
    [BWthreshold, EffectivenessMetric] = graythresh(imageComulative);
    BinThresh = BWthreshold*255;
elseif flag_ThresholdMode == 2
    % Triangle
    [counts, binLocations] = imhist(imageComulative);
    HistoCountVector = counts;
    PeakRightOrLeft = 'Left';
    TailRightOrLeft = 'Right';
    version = 0;
    BinThresh = HistoTriangleThreshold(HistoCountVector, PeakRightOrLeft, TailRightOrLeft, version);
    BWthreshold = binLocations(BinThresh)/length(binLocations);
else
    % Average between Otsu and Triangle
    [BWthresholdOtsu, EffectivenessMetric] = graythresh(imageComulative);
    [counts, binLocations] = imhist(imageComulative);
    HistoCountVector = counts;
    PeakRightOrLeft = 'Left';
    TailRightOrLeft = 'Right';
    version = 0;
    BinThresh = HistoTriangleThreshold(HistoCountVector, PeakRightOrLeft, TailRightOrLeft, version);
    BWthresholdTriangle = binLocations(BinThresh)/length(binLocations);
    BWthreshold = (BWthresholdOtsu+BWthresholdTriangle)/2;
end

% Mask creation
BinThresh = BWthreshold*255;
BinThresh = BinThresh + ThreshAdditiveFactor;
if BinThresh<0
    BinThresh = 0;
end
if BinThresh>255
    BinThresh = 255;
end
BWthreshold = BinThresh/255;
if BWthreshold<0; BWthreshold=0; elseif BWthreshold>255; BWthreshold=255; end
MaskBW01 = uint8(im2bw(Img,BWthreshold));

% Pixels out of the original segmentation
MaskComet(MaskComet>0) = 1;
MaskBW01 = MaskBW01.*MaskComet;

% Dilation and hole filling.
SeDiskDefault = strel('disk', 5);
MaskBW01 = imdilate(MaskBW01,SeDiskDefault);
MaskBW01 = imfill(MaskBW01,'holes');
MaskBW01 = imerode(MaskBW01,SeDiskDefault);
if SizeDiskDilation>0
    SeDiskDilation = strel('disk', SizeDiskDilation);
    MaskBW01 = imdilate(MaskBW01,SeDiskDilation);
end

% Keep only the maximum object
[ImLabels, numObj] = bwlabel(MaskBW01);
Objs = regionprops(ImLabels,'Area');
Objs_Area = [Objs(:).Area]';
[AreaObjectsSort, AreaObjectsSortInd] = sort(Objs_Area);
if ~isempty(AreaObjectsSort)
    MaskBW01 = bwareaopen(MaskBW01,max(AreaObjectsSort));
end
MaskBW01 = uint8(MaskBW01);

% From input
if SizeDiskDilation>0
    SeDiskDefault = strel('disk', SizeDiskDilation);
    MaskBW01 = imdilate(MaskBW01,SeDiskDefault);
end

% Pixels out of the original segmentation
MaskBW01 = MaskBW01.*MaskComet;

MaskBW = MaskBW01;