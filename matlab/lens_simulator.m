clear all;

%% Lens setting
lens.r1 = 0.1; % radius of curvature 1 [mm]
lens.r2 = 0.1;%Inf; % radius of curvature 2 [mm]
lens.thickness = 0.05; % thickness [mm]
lens.radius = 0.1; % Radius of lens [mm]
lens.IOR = 1.43; % refractive index (index of refractive)
lens.EFL = 0.217; % effective focal length [mm]

%% Lenslet array setting

lens.m = 1;%0.5;%0.5;
lens.a = (lens.m+1)/lens.m*lens.EFL; % [mm];
lens.b = (lens.m+1)*lens.EFL; % [mm]

p_in = 1; % [mm]

screen.pos.x = lens.b;
screen.pos.y = 0;

%% Define the ray condition
ray_from_object.pos.x = -lens.a;
ray_from_object.pos.y = p_in;
ray_from_object.direction = -p_in/lens.a;

%% Calculate the ray condition in lens

ray_in_lens = calc_refraction_ray(ray_from_object, lens, 2, lens.IOR/1);

%% Calculate the ray condition in lens

ray_from_lens = calc_refraction_ray(ray_in_lens, lens, 1, 1/lens.IOR);

%% Calc y value @ x= lens_b
% y - y_1 = m(x - x_1) => y -m*x +m*x_1 - y_1
% ay + bx + c == 0
a = -ray_from_lens.direction;
b = 1;
c = -a*ray_from_lens.pos.x - ray_from_lens.pos.y;
m = ray_from_lens.direction;
x = screen.pos.x;
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

%% Calculate refracted ray condition
function refracted_ray = calc_refraction_ray(incident_ray, lens, orthant, sign_of_relative_IOR)
    air_IOR = 1.0;

    %% Calculate the intersection of line and circle2

    % y - y_1 = m(x - x_1) => -m*x + y + m*x_1 - y_1 == 0
    % ax + by + c == 0
    a = -incident_ray.direction;
    b = 1;
    c = -a*incident_ray.pos.x - incident_ray.pos.y;

    % position = (x_p, y_p) and radius = r
    surface.r = lens.r1;
    surface.pos.x = surface.r - lens.thickness/2;
    surface.pos.y = 0;
    if orthant == 1
        surface.r = lens.r2;
        surface.pos.x = - surface.r + lens.thickness/2;
    end
    x_p = surface.pos.x;
    y_p = surface.pos.y;
    r = surface.r;

    % calculate the intersection
    [pos1, pos2] = calc_intersection_of_line_and_circle(a, b, c, x_p, y_p, r);

    intersection = pos1;
    if pos1.x < pos2.x
        if orthant == 1
            intersection = pos2;
        end
    else
        if orthant == 2
            intersection = pos2;
        end
    end

    %% 交点における屈折角を計算
    % the line perpendicular to the surface at the point of incidence, called the normal.
    a1 = (intersection.y - y_p)/(intersection.x - x_p);
    % Incident ray
    a2 = incident_ray.direction;

    angle_of_incidence = calc_angle_of_2lines(a1, a2);
    if sign_of_relative_IOR > 1 % from air to lens
        angle_of_refraction = calc_refraction_angle(angle_of_incidence, air_IOR, lens.IOR);
    else % from lens to air
        angle_of_refraction = calc_refraction_angle(angle_of_incidence, lens.IOR, air_IOR);
    end
    
    %% Calculate the ray condition in lens
    refracted_ray.pos = intersection;
    refracted_ray.direction = tan(atan(a1) + angle_of_refraction);

end