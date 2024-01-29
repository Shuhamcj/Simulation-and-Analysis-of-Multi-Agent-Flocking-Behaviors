clc
clear all

% Parameters
num_agents = 200;             % Number of agents
space_width = 200;            % Width of the space
space_height = 300;           % Height of the space
cohesion_strength = 0.5;      % Cohesion strength
velocity_matching = 1.0;      % Velocity matching factor
noise_factor = 5.0;           % Noise factor

% Initialize agent positions and velocities randomly
positions = space_width * rand(num_agents, 2);    % Random positions in 2D space
velocities = rand(num_agents, 2) - 0.5;           % Random initial velocities

% Simulation parameters
time_steps = 100;   % Number of simulation steps
radius = 10;  % Adjust this value to define the interaction radius

% Initialize arrays to store metrics over time
avg_neighbor_distance = zeros(time_steps, 1);
velocity_alignment = zeros(time_steps, 1);
group_dispersion = zeros(time_steps, 1);

% Simulation loop
for t = 1:time_steps
    % Plot agents at each time step (optional)
    scatter(positions(:, 1), positions(:, 2));
    xlim([0, space_width]);
    ylim([0, space_height]);
    title(['Step ', num2str(t)]);
    drawnow;

    % Calculate agent velocities based on neighbors
    for i = 1:num_agents
        % Find neighbors within a certain radius (you can define a distance threshold)
        neighbor_indices = find(sqrt(sum((positions - positions(i, :)).^2, 2)) < radius);
        
        % Calculate average velocity of neighbors
        avg_velocity = mean(velocities(neighbor_indices, :), 1);
        
        % Update agent velocity based on alignment and noise
        velocities(i, :) = (1 - velocity_matching) * velocities(i, :) + ...
            velocity_matching * avg_velocity + noise_factor * randn(1, 2);
    end
    
    % Update agent positions based on velocities
    positions = positions + velocities;
    
    % Wrap-around boundary conditions (optional)
    positions(positions < 0) = positions(positions < 0) + space_width;
    positions(positions > space_width) = positions(positions > space_width) - space_width;
    
    % Calculate metrics
    distances = pdist2(positions, positions); % Calculate pairwise distances
    distances(logical(eye(size(distances)))) = NaN; % Set diagonal elements to NaN
    avg_neighbor_distance(t) = nanmean(min(distances,[],2)); % Calculate average minimum distance
    
    % Calculate velocity alignment
    unit_velocities = velocities ./ vecnorm(velocities, 2, 2); % Normalize velocities
    cosine_similarity = sum(unit_velocities .* unit_velocities, 2); % Cosine similarity
    velocity_alignment(t) = mean(cosine_similarity);
    
    % Calculate group spatial dispersion
    group_dispersion(t) = sqrt(var(positions(:,1)) + var(positions(:,2)));
end

% Plot metrics over time
figure;
subplot(3, 1, 1);
plot(avg_neighbor_distance);
title('Average Neighbor Distance');
xlabel('Time Step');
ylabel('Distance');

subplot(3, 1, 2);
plot(velocity_alignment);
title('Velocity Alignment');
xlabel('Time Step');
ylabel('Alignment');

subplot(3, 1, 3);
plot(group_dispersion);
title('Group Spatial Dispersion');
xlabel('Time Step');
ylabel('Dispersion');
