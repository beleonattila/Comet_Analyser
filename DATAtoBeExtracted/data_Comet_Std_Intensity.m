function OutValue = data_Comet_Std_Intensity(Maski_Origj, Maski_Cometj, Maski_Tailj, Maski_Headj, Intensity_MinMax_StretchedOrig)
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

Mask = Maski_Cometj;
Orig = Maski_Origj;
%To use the original values of the original input images
a = Intensity_MinMax_StretchedOrig(1);
b = Intensity_MinMax_StretchedOrig(2);
c = Intensity_MinMax_StretchedOrig(3);
d = Intensity_MinMax_StretchedOrig(4);
Orig = ((Orig-a).*((d-c)/(b-a)))+c;
if sum(Mask(:))>1 && sum(Orig(:))>1
    Inds = find(Mask>0);
    Values = Orig(Inds);
    OutValue = std(Values);
else
    OutValue = 0;
end
