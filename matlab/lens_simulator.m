clear all;

air_IOR = 1.0;

%% Lens setting
lens_EFL = 0.217; % effective focal length [mm]
lens_r1 = 0.1; % radius of curvature 1 [mm]
lens_r2 = 0.1;%Inf; % radius of curvature 2 [mm]
lens_thickness = 0.05; % thickness [mm]
lens_IOR = 1.43; % refractive index (index of refractive)

lens_radius = 0.1; % Radius of lens [mm]

%% Lenslet array setting

lens_m = 1;%0.5;%0.5;
lens_a = (lens_m+1)/lens_m*lens_EFL; % [mm];
lens_b = (lens_m+1)*lens_EFL; % [mm]

p_in = 0.1; % [mm]

%% Calculate the intersection of line and circle1

% ax + by + c == 0
a = p_in/lens_a;
b = 1;
c = 0;

% position = (x_p, y_p) and radius = r
x_p = lens_r1 - lens_thickness/2;
y_p = 0;
r = lens_r1;

% calculate the intersection
[pos1, pos2] = calc_intersection_of_line_and_circle(a, b, c, x_p, y_p, r);

intersection1 = pos1;
if pos1.x > pos2.x
    intersection1 = pos2;
end
intersection1

%% 交点における屈折角を計算
% the line perpendicular to the surface at the point of incidence, called the normal.
a1 = (0 - intersection1.y)/(lens_r1 - lens_thickness/2 - intersection1.x);
% Incident ray
a2 = -p_in/lens_a;

angle_of_incidence = calc_angle_of_2lines(a1, a2);
angle_of_refraction = calc_refraction_angle(angle_of_incidence, air_IOR, lens_IOR);

deg_a2 = atan(a2)*180/pi
deg_normal = atan(a1)*180/pi
deg_incidence = angle_of_incidence*180/pi
deg_refraction = angle_of_refraction*180/pi

%% Calculate the intersection of line and circle2

% y - y_1 = m(x - x_1) => -m*x + y + m*x_1 - y_1 == 0
% ax + by + c == 0
a = -tan(atan(a1) + angle_of_refraction);
b = 1;
c = -a*intersection1.x - intersection1.y;

% position = (x_p, y_p) and radius = r
x_p = - lens_r2 + lens_thickness/2;
y_p = 0;
r = lens_r2;

% calculate the intersection
[pos1, pos2] = calc_intersection_of_line_and_circle(a, b, c, x_p, y_p, r);

intersection2 = pos1;
if pos1.x < pos2.x
    intersection2 = pos2;
end
intersection2

%% 交点における屈折角を計算
% the line perpendicular to the surface at the point of incidence, called the normal.
a1 = (intersection2.y - y_p)/(intersection2.x - x_p);
% Incident ray
a2 = a/b;

angle_of_incidence2 = calc_angle_of_2lines(a1, a2);
angle_of_refraction2 = calc_refraction_angle(angle_of_incidence, air_IOR, lens_IOR);

%% Calc y value @ x= lens_b
% y - y_1 = m(x - x_1) => y -m*x +m*x_1 - y_1
% ay + bx + c == 0
a = -tan(atan(a1) + angle_of_refraction);
b = 1;
c = -a*intersection2.x - intersection2.y;
m = tan(atan(a1) + angle_of_refraction);
x = lens_b
y = m*(x - intersection2.x) + intersection2.y

%% Calculate the intersection of line and circle
function [position1, position2] = calc_intersection_of_line_and_circle(a, b, c, x_p, y_p, r)

% Reference: http://shogo82148.github.io/homepage/memo/geometry/line-circle.html
% ay + bx + c == 0
% Circle: position = (x_p, y_p) and radius = r

% calculate the intersection
d = a*x_p + b*y_p + c;
position1.x = (-a*d + b*sqrt((a^2+b^2)*r^2 - d^2))/(a^2+b^2) + x_p;
position2.x = (-a*d - b*sqrt((a^2+b^2)*r^2 - d^2))/(a^2+b^2) + x_p;
position1.y = (-b*d - a*sqrt((a^2+b^2)*r^2 - d^2))/(a^2+b^2) + y_p;
position2.y = (-b*d + a*sqrt((a^2+b^2)*r^2 - d^2))/(a^2+b^2) + y_p;

end

%% Calculate the angle of two lines
function angle = calc_angle_of_2lines(a1, a2)

% Reference: https://mathtrain.jp/nasukaku

angle1 = atan(a1); % create a vector based on the line equation
angle2 = atan(a2);

% obtain the angle of intersection in degrees
angle = angle2 - angle1;

end

function angle = calc_abs_angle_of_2lines(a1, a2)

% Reference: https://jp.mathworks.com/help/images/examples/measuring-angle-of-intersection.html

vect1 = [1 a1]; % create a vector based on the line equation
vect2 = [1 a2];
dp = dot(vect1, vect2);

% compute vector lengths
length1 = sqrt(sum(vect1.^2));
length2 = sqrt(sum(vect2.^2));

% obtain the smaller angle of intersection in degrees
angle = acos(dp/(length1*length2));

end

%% Calculate the angle of refraction
function angle_of_refraction = calc_refraction_angle(angle_of_incidence, n1, n2)
    % Snell's raw: n1 * sin(theta1) = n2 * sin(theta2)
    % sin(theta2) = n1/n2 * sin(theta1)
    angle_of_refraction = asin(n1/n2 * sin(angle_of_incidence));
end