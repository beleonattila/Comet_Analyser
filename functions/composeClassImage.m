function [compImg, className, mapping] = composeClassImage(thumbnailSet, axesWidth)
% AUTHOR:	Attila Beleon
% DATE: 	Augustus 27, 2020
% NAME: 	composeClassImage
%
% To create the table-like image containing the thumbnails of a class of
% annotated comets.
%
% INPUT:
%   thumbnailSet         Identification number assigned to the class.
%
% OUTPUT:
%   compImg          Contain the table for containing the "icon images".
%   className       Name of the class.
%   mapping         Contains PlateName, ImageName, OriginalImageName and
%                   CellNumber for each cell shown.
%


cols = 4;
margin = 0.05 * axesWidth;
sepsize = 0.05 * axesWidth; %Distance Between Images
imSize = ((axesWidth - (2*margin)) - ((cols-1)*sepsize))/cols; % image size in percentage

numimgs = size(thumbnailSet,4);
rows = ceil(numimgs / cols);
height = rows * imSize + (rows+1) * sepsize;
compImg = uint8(zeros(height,axesWidth));
compImg(:,:,:) = 255;

mapping = {};
x = 1;
y = 1;
for i = 1:numimgs
    resImg = im2uint8(imresize(thumbnailSet{i}, imSize));
    if x > cols
        x = 1;
        y = y + 1;
    end
    offsetw = imSize * (x-1) + sepsize * x;
    offseth = imSize * (y-1) + sepsize * y;
    compImg(offseth:offseth+imSize-1,offsetw:offsetw+imSize-1,:) = resImg;
    subimgmeta.CellNumber = i;
%     subimgmeta.ImageName = classImg.ImageName;
    subimgmeta.OriginalImageName = classImg.OriginalImageName;
    subimgmeta.PlateName = classImg.PlateName;
    mapping{y,x} = subimgmeta;
    x = x + 1;
end
end