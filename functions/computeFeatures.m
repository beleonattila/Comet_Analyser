function  Table = computeFeatures(Maski_Origj, Maski_Cometj, Maski_Tailj, Maski_Headj, Maski_Classj, Imgi_Name, Intensity_MinMax_StretchedOrig, Cellj)
% AUTHOR: Filippo Piccinini (E-mail: filippo.piccinini85@gmail.com)
% DATE: April 14, 2017
% NAME: ComputeFeatures (version 1.0)
% 
% To compute features starting from the mask of comet, head, ...
%
% PARAMETERS:
% 	Maski_Origj         Mask of the original image.
%   Maski_Cometj        Mask of the Comet.
%   Maski_Headj         Mask of the Head.
%   Maski_Classj        Class of the Comet.
%   Imgi_Name           Name of the original image.
%   Cellj               ID of the Comet analysed.
%   Intensity_MinMax_StretchedOrig  Intesity values of the stretched and
%                       original images, in order min, max.
%
%
% OUTPUT:
%   parameters          Output features.
%
% EXAMPLE OF USAGE:
%   parameters = computeFeatures(Maski_Origj, Maski_Cometj, Maski_Tailj, Maski_Headj, Maski_Classj, Imgi_Name, [0, 255, 0, 255], Cellj)
 
% Copyright © 2015 Filippo Piccinini 
% Istituto Scientifico Romagnolo per lo Studio e la Cura dei Tumori (IRST) 
% IRCCS, Meldola (FC), Italy. All rights reserved.
%
% This program is free software; you can redistribute it and/or modify it 
% under the terms of the GNU General Public License version 2 (or higher) 
% as published by the Free Software Foundation. This program is 
% distributed WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
% General Public License for more details.

% Check if there are functions
Table.ImageName{1,1}  = char(Imgi_Name);
Table.CometID{1,1}    = Cellj;
Table.CometClass{1,1} = Maski_Classj;

currentFolder = pwd;
InFunctionFolder1 = 'DATAtoBeExtracted';   
dirFunctionList = dir([InFunctionFolder1 filesep 'data_*.m']);

if isempty(dirFunctionList)
    errorString = ['Error in image: ' char(Imgi_Name) ', comet: ' num2str(Cellj) '\n\nPlease, copy in the root folder the folder called: "DATAtoBeExtracted", that must contain ".m" files named as: "data_".'];
    msgbox(sprintf(errorString));
    return
else
    dirFunctionList_length = length(dirFunctionList);
end
if dirFunctionList_length < 1
    errorString = ['Error in image: ' char(Imgi_Name) ', comet: ' num2str(Cellj) '\n\nPlease, copy in the root folder the folder called: "DATAtoBeExtracted", that must contain ".m" files named as: "data_".'];
    msgbox(sprintf(errorString));
    return
end

for FunNum = 1:dirFunctionList_length
    try
        StringNameFunctioni = dirFunctionList(FunNum).name;
        PositionsPoints = strfind(StringNameFunctioni, '.');
        PositionLastPoint = PositionsPoints(end);
        functionNamei = StringNameFunctioni(1:PositionLastPoint-1); 
        functionNameiWoData = functionNamei(6:end); % From 5 to delete the word "data_"
        functionDatai = str2func(functionNamei);
        cd(InFunctionFolder1)
        Value = feval(functionDatai, Maski_Origj, Maski_Cometj, Maski_Tailj, Maski_Headj, Intensity_MinMax_StretchedOrig);
        cd(currentFolder)
        Table.(functionNameiWoData){1,1} = Value;
    catch ME
        errorString = [ME.message];
        msgbox(sprintf(errorString));
        return
    end
end