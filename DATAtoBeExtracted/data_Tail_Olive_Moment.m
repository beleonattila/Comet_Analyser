function OutValue = data_Tail_Olive_Moment(Maski_Origj, Maski_Cometj, Maski_Tailj, Maski_Headj, Intensity_MinMax_StretchedOrig)
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

if sum(Maski_Cometj(:))>1 && sum(Maski_Tailj(:))>1 && sum(Maski_Origj(:))>1  && sum(Maski_Headj(:))>1
    TailPercentDNA = data_Tail_PercentDNA(Maski_Origj, Maski_Cometj, Maski_Tailj, Maski_Headj, Intensity_MinMax_StretchedOrig);
    
    %Compute distance between centroids
    [MaskMaxTailj, RotationAngle, Comet_Centroid_yrow, Comet_Centroid_xcol] = ComputeMaskMaxTailj(Maski_Cometj, Maski_Tailj, Maski_Headj);
    Tailj_Centroid  = regionprops(MaskMaxTailj, 'Centroid');
    Tailj_CentroidXY = Tailj_Centroid(1).Centroid;
    Tailj_Centroid_xcol = Tailj_CentroidXY(1,1);
    Tailj_Centroid_yrow = Tailj_CentroidXY(1,2);
    Head_Centroid  = regionprops(Maski_Headj, 'Centroid');
    Head_CentroidXY = Head_Centroid(1).Centroid;
    Head_Centroid_xcol = Head_CentroidXY(1,1);
    Head_Centroid_yrow = Head_CentroidXY(1,2);
    [RotationAngle, Module] = AngleBetweenTwoPoints([Tailj_Centroid_xcol, Tailj_Centroid_yrow], [Head_Centroid_xcol, Head_Centroid_yrow]);
    
    OutValue = TailPercentDNA*Module/100;
    
else
    OutValue = 0;
end