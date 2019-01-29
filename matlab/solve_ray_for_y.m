function y = solve_ray_for_y(ray, x)
    m = ray.direction;
    x1 = ray.pos.x;
    y1 = ray.pos.y;
    [a, b, c] = pointslope_to_general(m, x1, y1);
    y = solve_linear_for_y(a, b, c, x);
end
