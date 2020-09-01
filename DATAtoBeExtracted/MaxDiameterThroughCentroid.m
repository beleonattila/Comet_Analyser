function [AngleMaxDiameter, MaxDiameterLength, AnglePerpendicularDiameter, PerpendicularDiameterLength] = MaxDiameterThroughCentroid(BWimage)
% AUTHOR: Filippo Piccinini (E-mail: f.piccinini@unibo.it)
% DATE: 11 December 2013
% NAME: MaxDiameterThroughCentroid (version 1.0)
% 
% To estimate the rotation angle and the dimension in pixels of the maximum
% diameter passing through the centre of mass of the object.
%
% PARAMETERS:
% 	BWinput         2D binary image (black and white) with values 0 for 
%                   the background pixels and values 1 for the foreground 
%                   pixels.
%
% OUTPUT:
%   AngleMaxDiameter   Angle of rotation of the maximum diameter respect to
%                   the ray passing through the centre of mass and being 
%                   parallel to the bottom of the image.
%   MaxDiameterLength  Dimension in pixels of the maximum diameter.
%   AnglePerpendicularDiameter   Angle of rotation of the diameter
%                   perpendiculat to the maximum diameter respect to
%                   the ray passing through the centre of mass and being 
%                   parallel to the bottom of the image.
%   MaxDiameterLength  Dimension in pixels of the perpendicular diameter.
%
% EXAMPLE OF USAGE: 
% [RotationAngle, MaxDiameterLength] = MaxDiameterThroughCentroid(BWimage);
 
% CVG (Computer Vision Group) Toolbox
% Copyright � 2012 Filippo Piccinini, Alessandro Bevilacqua, 
% Advanced Research Center on Electronic Systems (ARCES), 
% University of Bologna, Italy. All rights reserved.
%
% This program is free software; you can redistribute it and/or modify it 
% under the terms of the GNU General Public License version 2 (or higher) 
% as published by the Free Software Foundation. This program is 
% distributed WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
% General Public License for more details.

%% Settings
[row, col, ch] = size(BWimage);

% Pixels of the border
BWperimeter = bwperim(BWimage,8);
IndBWperimeter = find(BWperimeter==1);
[IndBWperimeter_yrow IndBWperimeter_xcol] = find(BWperimeter==1);
NumPixels = length(IndBWperimeter_yrow);

% Original centre of mass
CentroidOrig  = regionprops(BWimage, 'Centroid');
CentroidXYOrig = CentroidOrig(1).Centroid;
CentroidOrig_xcol = CentroidXYOrig(1,1);
CentroidOrig_yrow = CentroidXYOrig(1,2);

% Working matrices
MatAngles = NaN(row, col);
MatModules = NaN(row, col);
MatDiameterLength = NaN(row, col);

%% Computation of angles and modules for the different pixels of the border
Vector2xy = [0, 0];
for i = 1:NumPixels
    Vector1xy = [IndBWperimeter_xcol(i)-CentroidOrig_xcol, IndBWperimeter_yrow(i)-CentroidOrig_yrow];
    [VectorAngle, VectorModule, VectorXY] = AngleBetweenTwoVectors(Vector2xy, Vector1xy);
    MatAngles(IndBWperimeter_yrow(i), IndBWperimeter_xcol(i)) = VectorAngle;
    MatModules(IndBWperimeter_yrow(i), IndBWperimeter_xcol(i)) = VectorModule;
end
MatAngles = round(MatAngles);
MatAngles = 360-MatAngles;

%% Computation of the lenght of diameters analysing the different radii 
degree = 0:1:359;
FinalAngle = [];
FinalDiameterLength = 0;
AnglesValues = MatAngles(IndBWperimeter);
ModulesValues = MatModules(IndBWperimeter);
for j = 1:length(degree)
    
    CurrentAngle = degree(j);
    
    % Pi� punti possono avere lo stesso angolo se l'oggetto � fatto da insenature.
    IndsAngles = find(AnglesValues==CurrentAngle);
    if ~isempty(IndsAngles)
        ModulesIndsAngles = ModulesValues(IndsAngles);
        [sortValue, sortInd] = sort(ModulesIndsAngles);
        IndAngles = IndsAngles(sortInd(1));
        IndFirstPoint = IndBWperimeter(IndAngles);
        
        % Controllo sul prolungamento del raggio individuato
        if CurrentAngle<180
            IndsAngles = find(AnglesValues==(CurrentAngle+180));
        else
            IndsAngles = find(AnglesValues==(CurrentAngle-180));
        end
        if ~isempty(IndsAngles)
            % Se ci sono valori che corrispondono perfettamente
            ModulesIndsAngles = ModulesValues(IndsAngles);
            [sortValue, sortInd] = sort(ModulesIndsAngles);
            IndAngles = IndsAngles(sortInd(1));
            IndSecondPoint = IndBWperimeter(IndAngles);
        else
            % Se non ci sono valori che corrispondono perfettamente si
            % prosegue con una approssimazione al pi� vicino
            if CurrentAngle<180
                IndsAngles = AnglesValues-(CurrentAngle+180);
                [sortValueAngle, sortIndsAngle] = sort(abs(IndsAngles));
            else
                IndsAngles = AnglesValues-(CurrentAngle-180);
                [sortValueAngle, sortIndsAngle] = sort(abs(IndsAngles));
            end
            IndAngles = sortIndsAngle(1);
            IndSecondPoint = IndBWperimeter(IndAngles);
        end
        CurrentDiameter = MatModules(IndFirstPoint)+MatModules(IndSecondPoint);
        MatDiameterLength(IndSecondPoint)=CurrentDiameter;
        if CurrentDiameter>FinalDiameterLength
            FinalDiameterLength = CurrentDiameter;
            FinalAngle = CurrentAngle;
        end
    end
    
end

%% Perpendicular diameter
if FinalAngle<90
    PerpendicularAngleFirst = FinalAngle+90;
    PerpendicularAngleSecond = PerpendicularAngleFirst+180;
elseif FinalAngle>269
    PerpendicularAngleFirst = FinalAngle-90;
    PerpendicularAngleSecond = PerpendicularAngleFirst-180;
else
    PerpendicularAngleFirst = FinalAngle-90;
    PerpendicularAngleSecond = FinalAngle+90;
end

% First perpendicular diameter
FinalPerpendicularAngleFirstLength = [];
IndsAngles = find(AnglesValues==PerpendicularAngleFirst);
if ~isempty(IndsAngles)
    % Se ci sono valori che corrispondono perfettamente
    ModulesIndsAngles = ModulesValues(IndsAngles);
    [sortValue, sortInd] = sort(ModulesIndsAngles);
    IndAngles = IndsAngles(sortInd(1));
    IndFirstPoint = IndBWperimeter(IndAngles);
else
    % Se non ci sono valori che corrispondono perfettamente si
    % prosegue con una approssimazione al pi� vicino
    IndsAngles = AnglesValues-PerpendicularAngleFirst;
    [sortValueAngle, sortIndsAngle] = sort(abs(IndsAngles));
    IndAngles = sortIndsAngle(1);
    IndFirstPoint = IndBWperimeter(IndAngles);
end
% Controllo sul prolungamento del raggio individuato
if PerpendicularAngleFirst<180
    IndsAngles = find(AnglesValues==(PerpendicularAngleFirst+180));
else
    IndsAngles = find(AnglesValues==(PerpendicularAngleFirst-180));
end
if ~isempty(IndsAngles)
    % Se ci sono valori che corrispondono perfettamente
    ModulesIndsAngles = ModulesValues(IndsAngles);
    [sortValue, sortInd] = sort(ModulesIndsAngles);
    IndAngles = IndsAngles(sortInd(1));
    IndSecondPoint = IndBWperimeter(IndAngles);
else
    % Se non ci sono valori che corrispondono perfettamente si
    % prosegue con una approssimazione al pi� vicino
    if PerpendicularAngleFirst<180
        IndsAngles = AnglesValues-(PerpendicularAngleFirst+180);
        [sortValueAngle, sortIndsAngle] = sort(abs(IndsAngles));
    else
        IndsAngles = AnglesValues-(PerpendicularAngleFirst-180);
        [sortValueAngle, sortIndsAngle] = sort(abs(IndsAngles));
    end
    IndAngles = sortIndsAngle(1);
    IndSecondPoint = IndBWperimeter(IndAngles);
end
FinalPerpendicularAngleFirstLength = MatModules(IndFirstPoint)+MatModules(IndSecondPoint);

% Second perpendicular diameter
FinalPerpendicularAngleSecondLength = [];
IndsAngles = find(AnglesValues==PerpendicularAngleSecond);
if ~isempty(IndsAngles)
    % Se ci sono valori che corrispondono perfettamente
    ModulesIndsAngles = ModulesValues(IndsAngles);
    [sortValue, sortInd] = sort(ModulesIndsAngles);
    IndAngles = IndsAngles(sortInd(1));
    IndFirstPoint = IndBWperimeter(IndAngles);
else
    % Se non ci sono valori che corrispondono perfettamente si
    % prosegue con una approssimazione al pi� vicino
    IndsAngles = AnglesValues-PerpendicularAngleSecond;
    [sortValueAngle, sortIndsAngle] = sort(abs(IndsAngles));
    IndAngles = sortIndsAngle(1);
    IndFirstPoint = IndBWperimeter(IndAngles);
end
% Controllo sul prolungamento del raggio individuato
if PerpendicularAngleSecond<180
    IndsAngles = find(AnglesValues==(PerpendicularAngleSecond+180));
else
    IndsAngles = find(AnglesValues==(PerpendicularAngleSecond-180));
end
if ~isempty(IndsAngles)
    % Se ci sono valori che corrispondono perfettamente
    ModulesIndsAngles = ModulesValues(IndsAngles);
    [sortValue, sortInd] = sort(ModulesIndsAngles);
    IndAngles = IndsAngles(sortInd(1));
    IndSecondPoint = IndBWperimeter(IndAngles);
else
    % Se non ci sono valori che corrispondono perfettamente si
    % prosegue con una approssimazione al pi� vicino
    if PerpendicularAngleSecond<180
        IndsAngles = AnglesValues-(PerpendicularAngleSecond+180);
        [sortValueAngle, sortIndsAngle] = sort(abs(IndsAngles));
    else
        IndsAngles = AnglesValues-(PerpendicularAngleSecond-180);
        [sortValueAngle, sortIndsAngle] = sort(abs(IndsAngles));
    end
    IndAngles = sortIndsAngle(1);
    IndSecondPoint = IndBWperimeter(IndAngles);
end
FinalPerpendicularAngleSecondLength = MatModules(IndFirstPoint)+MatModules(IndSecondPoint);


%% Output

% Max diameter output
AngleMaxDiameter = FinalAngle;
MaxDiameterLength = FinalDiameterLength;

% Perpendicular diameter output
if isempty(FinalPerpendicularAngleSecondLength)
    if isempty(FinalPerpendicularAngleFirstLength)
        AnglePerpendicularDiameter = [];
        PerpendicularDiameterLength = [];
    else
        AnglePerpendicularDiameter = PerpendicularAngleFirst;
        PerpendicularDiameterLength = FinalPerpendicularAngleFirstLength;
    end
else
    if isempty(FinalPerpendicularAngleFirstLength)
        AnglePerpendicularDiameter = PerpendicularAngleSecond;
        PerpendicularDiameterLength = FinalPerpendicularAngleSecondLength;
    else
        if FinalPerpendicularAngleSecondLength>FinalPerpendicularAngleFirstLength
            AnglePerpendicularDiameter = PerpendicularAngleSecond;
            PerpendicularDiameterLength = FinalPerpendicularAngleSecondLength;
        else
            AnglePerpendicularDiameter = PerpendicularAngleFirst;
            PerpendicularDiameterLength = FinalPerpendicularAngleFirstLength;
        end
    end
end