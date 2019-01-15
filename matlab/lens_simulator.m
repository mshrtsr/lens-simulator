clear all;

air_IOR = 1.0;

%% Lens setting
lens.EFL = 0.217; % effective focal length [mm]
lens.r1 = 0.1; % radius of curvature 1 [mm]
lens.r2 = 0.1;%Inf; % radius of curvature 2 [mm]
lens.thickness = 0.05; % thickness [mm]
lens.IOR = 1.43; % refractive index (index of refractive)

lens.radius = 0.1; % Radius of lens [mm]

%% Lenslet array setting

lens.m = 1;%0.5;%0.5;
lens.a = (lens.m+1)/lens.m*lens.EFL; % [mm];
lens.b = (lens.m+1)*lens.EFL; % [mm]

p_in = 1; % [mm]

%% Define the ray condition
ray_from_object.pos.x = -lens.a;
ray_from_object.pos.y = p_in;
ray_from_object.direction = -p_in/lens.a;

%% Calculate the intersection of line and circle1

% ax + by + c == 0
a = -ray_from_object.direction;
b = 1;
c = -a*ray_from_object.pos.x - ray_from_object.pos.y;

% position = (x_p, y_p) and radius = r
x_p = lens.r1 - lens.thickness/2;
y_p = 0;
r = lens.r1;

% calculate the intersection
[pos1, pos2] = calc_intersection_of_line_and_circle(a, b, c, x_p, y_p, r);

intersection1 = pos1;
if pos1.x > pos2.x
    intersection1 = pos2;
end

%% 交点における屈折角を計算
% the line perpendicular to the surface at the point of incidence, called the normal.
a1 = (0 - intersection1.y)/(lens.r1 - lens.thickness/2 - intersection1.x);
% Incident ray
a2 = ray_from_object.direction;

angle_of_incidence = calc_angle_of_2lines(a1, a2);
angle_of_refraction = calc_refraction_angle(angle_of_incidence, air_IOR, lens.IOR);

%% Calculate the ray condition in lens
ray_in_lens.pos = intersection1;
ray_in_lens.direction = tan(atan(a1) + angle_of_refraction);

%% Calculate the intersection of line and circle2

% y - y_1 = m(x - x_1) => -m*x + y + m*x_1 - y_1 == 0
% ax + by + c == 0
a = -ray_in_lens.direction;
b = 1;
c = -a*ray_in_lens.pos.x - ray_in_lens.pos.y;

% position = (x_p, y_p) and radius = r
x_p = - lens.r2 + lens.thickness/2;
y_p = 0;
r = lens.r2;

% calculate the intersection
[pos1, pos2] = calc_intersection_of_line_and_circle(a, b, c, x_p, y_p, r);

intersection2 = pos1;
if pos1.x < pos2.x
    intersection2 = pos2;
end

%% 交点における屈折角を計算
% the line perpendicular to the surface at the point of incidence, called the normal.
a1 = (intersection2.y - y_p)/(intersection2.x - x_p);
% Incident ray
a2 = ray_in_lens.direction;

angle_of_incidence2 = calc_angle_of_2lines(a1, a2);
angle_of_refraction2 = calc_refraction_angle(angle_of_incidence2, lens.IOR, air_IOR);

%% Calculate the ray condition in lens
ray_from_lens.pos = intersection2;
ray_from_lens.direction = tan(atan(a1) + angle_of_refraction2);

%% Calc y value @ x= lens_b
% y - y_1 = m(x - x_1) => y -m*x +m*x_1 - y_1
% ay + bx + c == 0
a = -ray_from_lens.direction;
b = 1;
c = -a*ray_from_lens.pos.x - ray_from_lens.pos.y;
m = ray_from_lens.direction;
x = lens.b;
y = m*(x - ray_from_lens.pos.x) + ray_from_lens.pos.y;

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