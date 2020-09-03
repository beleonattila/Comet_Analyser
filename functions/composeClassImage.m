function classCatalog = composeClassImage(Classes, axesWidth)
% AUTHOR:	Attila Beleon
% DATE: 	Augustus 27, 2020
% NAME: 	composeClassCatalog
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
sepsize = 0.05 * axesWidth; %Distance Between thumbnails
classNames = fieldnames(Classes);
imSize = ceil(((axesWidth - (2*margin)) - ((cols-1)*sepsize))/cols); % Catalog image size
backGround = 240;

for cl = 1:numel(classNames)
    
    numimgs = Classes.(classNames{cl}).num_el;
    rows = ceil(numimgs / cols);
    height = rows * imSize + (rows+1) * sepsize;
    compImgs = uint8(zeros(height,axesWidth, 2));
    compImgs(:,:,1) = (compImgs(:,:,1)+1)*backGround;
    
    mapping = {};
    x = 1;
    y = 1;
    for i = 1:numimgs
        origSize = size(Classes.(classNames{cl}).Members(i).Thumbnail);
        maxOrigSize = max(origSize);
        scaleValue = imSize/maxOrigSize;
        resImg = imresize(Classes.(classNames{cl}).Members(i).Thumbnail, scaleValue);
        if x > cols
            x = 1;
            y = y + 1;
        end
        offsetw = imSize * (x-1) + sepsize * x;
        offseth = imSize * (y-1) + sepsize * y;
        if size(resImg,1) ~= size(resImg,2)
            minSizeOfImg = min(size(resImg));
            padSize = ceil((imSize-minSizeOfImg)/2);
            padDirection = size(resImg)== minSizeOfImg;
            paddedImage = padarray(resImg,(padDirection*padSize), backGround);
            compImgs(offseth:offseth+imSize-1,offsetw:offsetw+imSize-1,1) = paddedImage(1:imSize,1:imSize);
            compImgs(offseth:offseth+imSize-1,offsetw:offsetw+imSize-1,2) = i;
        else
            compImgs(offseth:offseth+imSize-1,offsetw:offsetw+imSize-1,1) = resImg;
            compImgs(offseth:offseth+imSize-1,offsetw:offsetw+imSize-1,2) = i;
        end
        subimgmeta.CellNumber = i;
        subimgmeta.ImageName = Classes.(classNames{cl}).Members(i).ImName;
        %         subimgmeta.OriginalImageName = classImg.OriginalImageName;
        mapping{y,x} = subimgmeta;
        x = x + 1;
    end
    classCatalog{cl,1} = classNames{cl};
    classCatalog{cl,2} = compImgs;
    classCatalog{cl,3} = mapping;
end
end