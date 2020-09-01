function OutValue = data_Tail_Length_Max_Direction_Line_inPixels(Maski_Origj, Maski_Cometj, Maski_Tailj, Maski_Headj, Intensity_MinMax_StretchedOrig)
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

if sum(Maski_Cometj(:))>1 && sum(Maski_Tailj(:))>1     
    [MaskMaxTailj, RotationAngle, Comet_Centroid_yrow, Comet_Centroid_xcol] = ComputeMaskMaxTailj(Maski_Cometj, Maski_Tailj, Maski_Headj);
    MaskMaxTailj_Rotated = rotateAround(MaskMaxTailj, Comet_Centroid_yrow, Comet_Centroid_xcol, -RotationAngle);
    
    % Max direction line
    [Tail_yrow, Tail_xcol] = find(MaskMaxTailj_Rotated==1);
    Tail_yrowmin = round(min(Tail_yrow)); Tail_yrowmax = round(max(Tail_yrow));
    Tail_xcolmin = round(min(Tail_xcol)); Tail_xcolmax = round(max(Tail_xcol));
    lengthMaxDirection = 0;
    for i = Tail_yrowmin:Tail_yrowmax
        MaskMaxTailj_Rotated_Linei = MaskMaxTailj_Rotated(i,Tail_xcolmin:Tail_xcolmax);
        lengthMaxDirectioni = sum(MaskMaxTailj_Rotated_Linei);
        if lengthMaxDirectioni>lengthMaxDirection
            lengthMaxDirection = lengthMaxDirectioni;
        end
        clear lengthMaxDirectioni MaskMaxTailj_Rotated_Linei
    end
    
    OutValue = lengthMaxDirection;   
else
    OutValue = 0;
end