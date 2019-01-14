clear all;

air_IOR = 1.0;

%% Lens setting
lens_EFL = 0.217; % effective focal length [mm]
lens_r1 = 0.1; % radius of curvature 1 [mm]
lens_r2 = Inf; % radius of curvature 2 [mm]
lens_thickness = 0.05; % thickness [mm]
lens_IOR = 1.43; % refractive index (index of refractive)

lens_radius = 0.1; % Radius of lens [mm]

%% Lenslet array setting

lens_m = 1;%0.5;%0.5;
lens_a = (lens_m+1)/lens_m*lens_EFL; % [mm];
lens_b = (lens_m+1)*lens_EFL; % [mm]

p_in = 0.01; % [mm]


%% Calculate the intersection of line and circle

% ay + bx + c == 0
a = lens_a;
b = p_in;
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
disp(intersection1)

%% 交点における屈折角を計算
a1 = (0 - intersection1.y)/(lens_r1 - lens_thickness/2 - intersection1.x);
a2 = -p_in/lens_a;
angle_of_incidence = calc_angle_of_2lines(a1, a2);
angle_of_refraction = calc_refraction_angle(angle_of_incidence, air_IOR, lens_IOR);


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
    % Snells raw: n1 * sin(theta1) = n2 * sin(theta2)
    % sin(theta2) = n1/n2 * sin(theta1)
    angle_of_refraction = asin(n1/n2 * sin(angle_of_incidence));
end