function params = lens_simulator(params)

    %% Setup
    lens = params.lens;
    screen = params.screen;
    render_area_right_border = params.render_area_right_border;
    ray_from_object = params.ray_from_object;

    %% Calculate the ray condition in lens
    ray_in_lens = calc_refraction_ray(ray_from_object, lens, 2, lens.IOR/1);

    %% Calculate the ray condition in lens
    ray_from_lens = calc_refraction_ray(ray_in_lens, lens, 1, 1/lens.IOR);

    %% Calc y value @ x= lens_b
    % y - y_1 = m(x - x_1) => y -m*x +m*x_1 - y_1
    m = ray_from_lens.direction;
    projected_p.pos.x = screen.pos.x;
    projected_p.pos.y = m*(projected_p.pos.x - ray_from_lens.pos.x) + ray_from_lens.pos.y;
    p_at_right_border.pos.x = render_area_right_border;
    p_at_right_border.pos.y = m*(p_at_right_border.pos.x - ray_from_lens.pos.x) + ray_from_lens.pos.y;
    
    
    %% Copy the reslut to struct params
    params.ray_in_lens = ray_in_lens;
    params.ray_from_lens = ray_from_lens;
    params.projected_p = projected_p;
    params.p_at_right_border = p_at_right_border;
    
end

%% Calculate the intersection of line and circle
function [position1, position2] = calc_intersection_of_line_and_circle(a, b, c, x_p, y_p, r)

% Reference: http://shogo82148.github.io/homepage/memo/geometry/line-circle.html
% ax + by + c == 0
% Circle: position = (x_p, y_p) and radius = r

% calculate the intersection
d = a*x_p + b*y_p + c;
position1.x = (-a*d + b*sqrt((a^2+b^2)*r^2 - d^2))/(a^2+b^2) + x_p;
position2.x = (-a*d - b*sqrt((a^2+b^2)*r^2 - d^2))/(a^2+b^2) + x_p;
position1.y = (-b*d - a*sqrt((a^2+b^2)*r^2 - d^2))/(a^2+b^2) + y_p;
position2.y = (-b*d + a*sqrt((a^2+b^2)*r^2 - d^2))/(a^2+b^2) + y_p;

end

%% Calculate the intersection of 2lines
function position = calc_intersection_of_2lines(a1, b1, c1, a2, b2, c2)

% Reference: https://mathwords.net/nityokusenkoten
% a1*x + b1*y + c1 == 0
% a2*x + b2*y + c2 == 0

% calculate the intersection

position.x = (b1*c2 - b2*c1)/(a1*b2 - a2*b1);
position.y = (a2*c1 - a1*c2)/(a1*b2 - a2*b1);

end

%% Calculate the angle of two lines
function angle = calc_angle_of_2lines(a1, a2)

% Reference: https://mathtrain.jp/nasukaku

angle1 = atan(a1); % create a vector based on the line equation
angle2 = atan(a2);

% obtain the angle of intersection in degrees
angle = angle2 - angle1;

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

    if r == Inf
        a2 = 1;
        b2 = 0;
        c2 = lens.thickness/2;
        if orthant == 1
            c2 = -lens.thickness/2;
        end
        intersection = calc_intersection_of_2lines(a, b, c, a2, b2, c2);
    else
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