function new_store = simulate_ray_propagation_through_the_lens(params, store)
    
    %% Copy the params and store data.
    air = params.air;
    lens = params.lens;
    ray_entering_lens = store.ray_entering_lens;

    %% Calculate the ray condition in lens
    if isempty(ray_entering_lens)
        ray_inside_lens = [];
    else
        ray_inside_lens = calc_refraction_ray(ray_entering_lens, lens, air, 'front');
    end

    %% Calculate the ray condition in lens
    if isempty(ray_inside_lens)
        ray_leaving_lens = [];
    else
        ray_leaving_lens = calc_refraction_ray(ray_inside_lens, lens, air, 'back');
    end

    %% Copy the reslut to struct params
    new_store.ray_entering_lens = ray_entering_lens;
    new_store.ray_inside_lens = ray_inside_lens;
    new_store.ray_leaving_lens = ray_leaving_lens;
    
end

%% %% local functions %% %%
%% Calculate the angle of refraction
function angle_of_refraction = calc_refraction_angle(angle_of_incidence, n1, n2)
    % Snell's raw: n1 * sin(theta1) = n2 * sin(theta2)
    % sin(theta2) = n1/n2 * sin(theta1)
    % theta2 = asin( n1/n2 * sin(theta1) )
    angle_of_refraction = asin(n1/n2 * sin(angle_of_incidence));
end

%% Calculate refracted ray condition
function refracted_ray = calc_refraction_ray(incident_ray, lens, air, surface_side)

    m = incident_ray.direction;
    x1 = incident_ray.pos.x;
    y1 = incident_ray.pos.y;
    [a, b, c] = pointslope_to_general(m, x1, y1);

    % position = (x_p, y_p) and radius of curvature = r
    if strcmp(surface_side,'front')
        r = lens.r1;
        x_p = r - lens.thickness/2;
        y_p = 0;
        
        a2 = 1;
        b2 = 0;
        c2 = lens.thickness/2;
    else
        r = lens.r2;
        x_p = - r + lens.thickness/2;
        y_p = 0;
        
        a2 = 1;
        b2 = 0;
        c2 = -lens.thickness/2;
    end

    if r == Inf
        % Calculate the intersection of 2lines
        intersection = calc_intersection_of_2lines(a, b, c, a2, b2, c2);
    else
        % Calculate the intersection of line and circle
        [pos1, pos2] = calc_intersection_of_line_and_circle(a, b, c, x_p, y_p, r);

        intersection = pos1;
        if strcmp(surface_side,'front')
            if pos1.x > pos2.x
                intersection = pos2;
            end
        else
            if pos1.x < pos2.x
                intersection = pos2;
            end
        end
        
    end
    
    %% Check the intersection is exist
    if ~isreal(intersection.x)
        refracted_ray = [];
        return;
    elseif abs(intersection.y) > abs(lens.radius)
        refracted_ray = [];
        return;
    end
    
    %% 交点における屈折角を計算
    % the line perpendicular to the surface at the point of incidence, called the normal.
    a1 = (intersection.y - y_p)/(intersection.x - x_p);
    % Incident ray
    a2 = incident_ray.direction;

    angle_of_incidence = calc_angle_of_2lines(a1, a2);
    if strcmp(surface_side,'front')
        % from air to lens
        angle_of_refraction = calc_refraction_angle(angle_of_incidence, air.IOR, lens.IOR);
    else
        % from lens to air
        angle_of_refraction = calc_refraction_angle(angle_of_incidence, lens.IOR, air.IOR);
    end
    
    %% Calculate the ray condition in lens
    refracted_ray.pos = intersection;
    refracted_ray.direction = tan(atan(a1) + angle_of_refraction);

end