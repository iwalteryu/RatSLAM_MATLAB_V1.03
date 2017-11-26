function [vtrans, vrot] = rs_visual_odometry(raw_image)
%     [vtrans, vrot] = rs_visual_odometry(raw_image)

%     Copyright (C) 2008 David Ball (d.ball@uq.edu.au) (MATLAB version)
%     Michael Milford (m.milford1@uq.edu.au) & Gordon Wyeth (g.wyeth@uq.edu.au)
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

global prev_vrot_image_x_sums;
global prev_vtrans_image_x_sums;
global IMAGE_ODO_X_RANGE;
global IMAGE_VTRANS_Y_RANGE;
global IMAGE_VROT_Y_RANGE;

% Field of View (FOV), Degree (DEG) the horizontal, vertical, and diagonal
% degrees for all FOVs
FOV_DEG = 50;
% size (x,n) if n==1, return num of rows, if n==2, return num of column 
dpp = FOV_DEG / size(raw_image, 2);

% IMAGE_VTRANS_Y_RANGE = 75:240; % Row
% IMAGE_ODO_X_RANGE = 100:400; % Column

% vtrans 
sub_image = raw_image(IMAGE_VTRANS_Y_RANGE, IMAGE_ODO_X_RANGE); % not inlcude RGB

% sum(x) sum of every column
% sum(x,2) sum of every row
% sum(x(:)) sum of matrix

% why? 
image_x_sums = sum(sub_image);
avint = sum(image_x_sums) / size(image_x_sums, 2);
image_x_sums = image_x_sums/avint; 

% [offset, sdif] = rs_compare_segments(seg1, seg2, slen, cwl)
% [offset, sdif] = rs_compare_segments(seg1, seg2, slen, cwl)
% determine the best match between seg1 and seg2 of size cw1 allowing 
% for shifts of up to slen

% image_x_sums  is a 1 row* N Column  
% 140 shift range
% size(image_x_sums, 2) the number of Columns

[minoffset, mindiff] = rs_compare_segments(image_x_sums, prev_vtrans_image_x_sums, 140, size(image_x_sums, 2));
 
% https://github.com/vonscnhed/ROS_RatSLAM_with_viso2/blob/master/ratslam_ros/src/ratslam/visual_odometry.cpp
% double mindiff = 1e6;
%   double minoffset = 0;
%   double cdiff;
%   int offset;
% 
%   int cwl = width;
%   int slen = 40;
% 
%  //  data, olddata are 1D arrays of the intensity profiles  (current and previous);
%   // slen is the range of offsets in pixels to consider i.e. slen = 0 considers only the no offset case
%   // cwl is the length of the intensity profile to actually compare, and must be < than image width – 1 * slen
%   
  
% why?
vtrans = mindiff * 100;

% a hack to detect excessively large vtrans
if vtrans > 10
    vtrans = 0;
end
%  *vrot_rads = minoffset * CAMERA_FOV_DEG / IMAGE_WIDTH * CAMERA_HZ * M_PI / 180.0;
%   *vtrans_ms = mindiff * VTRANS_SCALING;
%   if (*vtrans_ms > VTRANS_MAX)
%     *vtrans_ms = VTRANS_MAX;

prev_vtrans_image_x_sums = image_x_sums;

% now do rotation
sub_image = raw_image(IMAGE_VROT_Y_RANGE, IMAGE_ODO_X_RANGE);

image_x_sums = sum(sub_image);
avint = sum(image_x_sums) / size(image_x_sums, 2);
image_x_sums = image_x_sums/avint;

[minoffset, mindiff] = rs_compare_segments(image_x_sums, prev_vrot_image_x_sums, 140, size(image_x_sums, 2)); %#ok<NASGU>

vrot = minoffset * dpp * pi / 180;

prev_vrot_image_x_sums = image_x_sums;

end






