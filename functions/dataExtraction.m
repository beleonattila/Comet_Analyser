function Table = dataExtraction(InImageFolder1, InFunctionFolder1)
% AUTHOR: Filippo Piccinini (E-mail: f.piccinini@unibo.it)
% DATE: April 14, 2017
% NAME: dataExtraction (version 1.0)
% 
% To extract data from binary masks of spheroids.
%
% PARAMETERS:
%
% OUTPUT:
%
% EXAMPLE OF USAGE: 
 
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


%% CHECK INPUT PARAMETERS

% Check slash
if ~strcmp(InFunctionFolder1(end), filesep)
    InFunctionFolder1 = strcat(InFunctionFolder1,filesep);
end

% Check functions
dirFunctionList = dir([InFunctionFolder1 'data*.m']);
if isempty(dirFunctionList)
    error(['In the folder "' InFunctionFolder1 '" there are not MATLAB files.'])
else
    dirFunctionList_length = length(dirFunctionList);
end
if dirFunctionList_length < 1
    error(['In the folder "' InFunctionFolder1 '" there are not MATLAB files.'])
end


%% INTERNAL PARAMETERS
BGvalue = 0;
currentFolder = pwd;

BarWaitWindows = msgbox(['Please wait... ' 'Folder analysed: ' InImageFolder1 ', Completed: ' num2str(0) '%.'], 'Message');

%% DATA EXTRACTION
dirList = dir([InImageFolder1, InImageType]);
dirList_length = length(dirList);
if dirList_length == 0
    error(['In the input folder "' InImageFolder1 '" there are not images of type "' InImageType '".'])
end

StartInd = 1;
CloseInd = dirList_length;
counterRow01 = StartInd;
for ImNum = StartInd:CloseInd

    % Read the current mask
    %disp(['Data extraction from mask: ' char(InImageFolder1) char(dirList(ImNum).name)])
    ImInp = imread([InImageFolder1 char(dirList(ImNum).name)]);
    NonNaNIndex = find(isnan(ImInp(:,:,1))==0);
    YesNaNIndex = find(isnan(ImInp(:,:,1))==1);
    [row, col, ch] = size(ImInp);
    if ch~=1
        error(['The mask: "' dirList(ImNum).name '" in the folder "' InImageFolder1 '" is not a binary mask.'])
    end
    Values = ImInp(NonNaNIndex);
    ValuesUnique = unique(Values);
    if length(ValuesUnique)>2
        error(['The mask: "' dirList(ImNum).name '" in the folder "' InImageFolder1 '" is not a binary mask.'])
    end
    if length(ValuesUnique)<1
        error(['The mask: "' dirList(ImNum).name '" in the folder "' InImageFolder1 '" is not a binary mask.'])
    end
    flag_DataExtraction = 1;
    if length(ValuesUnique)==1
        flag_DataExtraction = 0;
    end
    Servizio = zeros(row, col);
    Servizio(ImInp~=BGvalue) = 1;
    Servizio(YesNaNIndex) = 0;
    [ImLabels, numObj] = bwlabel(Servizio);
    Objs = regionprops(ImLabels,'Area');
    Objs_Area = [Objs(:).Area]';
    [AreaObjectsSort, AreaObjectsSortInd] = sort(Objs_Area);
    clear Servizio
    
    % Area sort
    MaxPercentageSmallObjects = 0.10; % with respect to the maximum object detected. % In a future version of the software insert this parameter as input parameter.
    ReferenceAreaObject = AreaObjectsSort(end);
    counterObj01 = 1;
    for o = numObj:-1:1
        if AreaObjectsSort(o) >= MaxPercentageSmallObjects*ReferenceAreaObject
    
            BWtemporanea = uint8(zeros(size(ImLabels)));
            BWtemporanea(ImLabels==AreaObjectsSortInd(o)) = 1; 
             
            % Data extracted
            MaskName = dirList(ImNum).name;
            if counterObj01 == 1
                Table.MaskName{counterRow01-StartInd+1,1} = [MaskName];
            else
                Table.MaskName{counterRow01-StartInd+1,1} = [MaskName ' Object: ' num2str(counterObj01)];
            end
            for FunNum = 1:dirFunctionList_length
                StringNameFunctioni = dirFunctionList(FunNum).name;
                PositionsPoints = strfind(StringNameFunctioni, '.');
                PositionLastPoint = PositionsPoints(end);
                functionNamei = StringNameFunctioni(1:PositionLastPoint-1); 
                functionNameiWoData = functionNamei(5:end); % From 5 to delete the word "data"
                if flag_DataExtraction == 1
                    functionDatai = str2func(functionNamei);
                    cd(InFunctionFolder1) 
                    Value = feval(functionDatai, BWtemporanea);
                    cd(currentFolder)
                else
                    Value = NaN;
                end
                Table.(functionNameiWoData){counterRow01-StartInd+1,1} = Value;
            end
            
            counterObj01 = counterObj01 + 1;
            counterRow01 = counterRow01 +1;
            
            clear BWtemporanea
            
        else
            break
        end
    end

end
