function [VectorAngle, VectorModule, Vector_xcol_yrow] = AngleBetweenTwoVectors(Vector1_xcol_yrow, Vector2_xcol_yrow)
% AUTHOR: Filippo Piccinini (E-mail: f.piccinini@unibo.it)
% DATE: 03 July 2013
% NAME: AngleBetweenTwoVectors
% 
% Given two input 2D vectors defined by their [x, y] = [col, row]
% coordinates, this function computes the angle, the module and the new [x,
% y] coordinates of the vector obtained performing the "vector product"
% operation (called also: cross product).
%
% PARAMETERS:
% 	Vector1_xcol_yrow    Input vector coordinates (in pixels) defined as: 
%                   [Vector1xcol, Vector1yrow];
% 	Vector2_xcol_yrow    Input vector coordinates (in pixels) defined as:
%                   [Vector2xcol, Vector2yrow];
%
% OUTPUT:
%   VectorAngle     Degrees of direction of the output vector.
%   VectorModule    Length (in pixels) of the output vector.
% 	Vector_xrow_ycol     Output vector coordinates (in pixels) defined as: 
%                   [VectorXcol, VectorYrow];
%
% EXAMPLE OF USAGE: 
% [VectorAngle, VectorModule, Vector_xrow_ycol] = AngleBetweenTwoVectors([2,0], [0,3]);

% CVG (Computer Vision Group) Toolbox
% Copyright © 2012 Filippo Piccinini, Alessandro Bevilacqua, 
% Advanced Research Center on Electronic Systems (ARCES), 
% University of Bologna, Italy. All rights reserved.
%
% This program is free software; you can redistribute it and/or modify it 
% under the terms of the GNU General Public License version 2 (or higher) 
% as published by the Free Software Foundation. This program is 
% distributed WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
% General Public License for more details.

Vector1x = Vector1_xcol_yrow(1);
Vector1y = Vector1_xcol_yrow(2);
Vector1abs = sqrt(Vector1_xcol_yrow.^2 + Vector1_xcol_yrow.^2);

Vector2x = Vector2_xcol_yrow(1);
Vector2y = Vector2_xcol_yrow(2);
Vector2abs = sqrt(Vector2_xcol_yrow.^2 + Vector2_xcol_yrow.^2);

VectorX = Vector1x + Vector2x;
VectorY = Vector1y + Vector2y;
Vector_xcol_yrow = [VectorX, VectorY];
VectorModule = sqrt(VectorX.^2 + VectorY.^2);

VectorAngleCos = acosd(VectorX/VectorModule);
if sign(VectorY)>=0
    VectorAngle = VectorAngleCos;
else
    VectorAngle = 360-VectorAngleCos;
end
