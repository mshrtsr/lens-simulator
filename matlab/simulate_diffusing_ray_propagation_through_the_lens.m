function diffusing_rays = ...
    simulate_diffusing_ray_propagation_through_the_lens(params, ray, samples)

    %% Copy the params and ray info.
    ray_entering_lens = ray.ray_entering_lens;
    
    directions_rad = linspace(-pi/2, pi/2, samples);
    directions = tan(directions_rad);

    diffusing_rays = [];
    
    for direction = directions 
        ray_entering_lens.direction = direction;
        store.ray_entering_lens = ray_entering_lens;
        diffusing_rays = [diffusing_rays simulate_ray_propagation_through_the_lens(params, store)];
    end
end