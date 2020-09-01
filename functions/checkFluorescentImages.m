function flagEstimated_FluorescenceImages = checkFluorescentImages(referenceFrame)
% AUTHOR: Filippo Piccinini (E-mail: f.piccinini@unibo.it)
% DATE: March 08, 2018
% NAME: checkFluorescentImages (version 1.0)
% 
% To check if the input images are fluorescent images or not.
%
% PARAMETERS:
%   referenceFrame      An image to be checked.
%
% OUTPUT:
%   flagEstimated_FluorescenceImages    Estimated flag: 1 if it is supposed
%                                       that the image is a fluorescent
%                                       one, 0 otherwise.
%
% EXAMPLE OF USAGE: 
 
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

[counts, binLocations] = imhist(referenceFrame);
HistoCountVector_Ori = counts;
%figure, plot(HistoCountVector_Ori);

windowSize = 5; 
coefb = (1/windowSize)*ones(1,windowSize);
coefa = 1;
HistoCountVector_Fil = filter(coefb,coefa,HistoCountVector_Ori);

[MaxPeak_Val, MaxPeak_Pos]  = max(HistoCountVector_Fil);
HistoCountVector_Fil_LeftTail = HistoCountVector_Fil(1:MaxPeak_Pos);
HistoCountVector_Fil_RightTail = HistoCountVector_Fil(MaxPeak_Pos:end);
[MinLeftTail_Val, MinLeftTail_Pos]  = min(HistoCountVector_Fil_LeftTail);
[MinRightTail_Val, MinRightTail_Pos]  = min(HistoCountVector_Fil_RightTail);

lengthLeftTail = MaxPeak_Pos-MinLeftTail_Pos;
lengthRightTail = (MinRightTail_Pos+MaxPeak_Pos)-MaxPeak_Pos;

if lengthLeftTail<lengthRightTail
    flagEstimated_FluorescenceImages = 1;
else
    flagEstimated_FluorescenceImages = 0;
end