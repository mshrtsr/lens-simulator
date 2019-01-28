%% Calculate the angle of two lines
function angle = calc_angle_of_2lines(a1, a2)

% Reference: https://mathtrain.jp/nasukaku

angle1 = atan(a1); % create a vector based on the line equation
angle2 = atan(a2);

% obtain the angle of intersection in degrees
angle = angle2 - angle1;

end