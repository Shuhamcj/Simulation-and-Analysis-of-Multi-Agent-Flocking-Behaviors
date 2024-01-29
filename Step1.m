clc
clear all

% Parameters
num_agents = 100;             % Number of agents
space_width = 100;            % Width of the space
space_height = 100;           % Height of the space
cohesion_strength = 0.1;      % Cohesion strength
velocity_matching = 0.5;      % Velocity matching factor
noise_factor = 0.1;           % Noise factor

% Initialize agent positions and velocities randomly
positions = space_width * rand(num_agents, 2);    % Random positions in 2D space
velocities = rand(num_agents, 2) - 0.5;           % Random initial velocities

% Simulation parameters
time_steps = 100;   % Number of simulation steps
radius = 10;  % Adjust this value to define the interaction radius

% Simulation loop
for t = 1:time_steps
    % Plot agents at each time step 
    scatter(positions(:, 1), positions(:, 2));
    xlim([0, space_width]);
    ylim([0, space_height]);
    title(['Step ', num2str(t)]);
    drawnow;

    % Calculate agent velocities based on neighbors
    for i = 1:num_agents
        % Find neighbors within a certain radius
        neighbor_indices = find(sqrt(sum((positions - positions(i, :)).^2, 2)) < radius);
        
        % Calculate average velocity of neighbors
        avg_velocity = mean(velocities(neighbor_indices, :), 1);
        
        % Update agent velocity based on alignment and noise
        velocities(i, :) = (1 - velocity_matching) * velocities(i, :) + ...
            velocity_matching * avg_velocity + noise_factor * randn(1, 2);
    end
    
    % Update agent positions based on velocities
    positions = positions + velocities;
    
    % Wrap-around boundary conditions 
    positions(positions < 0) = positions(positions < 0) + space_width;
    positions(positions > space_width) = positions(positions > space_width) - space_width;
end
