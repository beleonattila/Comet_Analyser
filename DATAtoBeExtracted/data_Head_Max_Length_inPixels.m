function OutValue = data_Head_Max_Length_inPixels(Maski_Origj, Maski_Cometj, Maski_Tailj, Maski_Headj, Intensity_MinMax_StretchedOrig)
% AUTHOR: Filippo Piccinini (E-mail: filippo.piccinini85@gmail.com)
% DATE: April 14, 2017
% NAME: TemplateFunction (version 1.0)
% 
% To extract data from masks.
% NOTE: the first four letters of the name of this function must be: data_.
%
% PARAMETERS:
% 	Maski_Origj         Mask of the original image.
%   Maski_Cometj        Mask of the Comet.
%   Maski_Tailj         Mask of the Tail
%   Maski_Headj         Mask of the Head.
%   Intensity_MinMax_StretchedOrig  Intesity values of the stretched and
%                       original images, in order min, max.
 
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

% Sphericity defined according to (ID000734):
% Jens M. Kelm and Nicholas E. Timmins and Catherine J. Brown and Martin
% Fussenegger and Lars K. Nielsen, "Method for generation of homogeneous
% multicellular tumor spheroids applicable to a wide variety of cell
% types". Biotechnology and Bioengineering, 2003.

Mask = Maski_Headj;
if sum(Mask(:))>1
    [AngleMaxDiameter, MaxDiameterLength, AnglePerpendicularDiameter, PerpendicularDiameterLength] = MaxDiameterThroughCentroid(Mask);
    OutValue = MaxDiameterLength;
else
    OutValue = 0;
end