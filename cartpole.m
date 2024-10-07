[t, y] = ode45(@f, [0 40], [0; 0.3; 0; 0]);
plot(t, y);
xlabel('Time (s)');
ylabel('States');
legend('x', '\theta', 'v_x', 'v_\theta');

ty = [t y];
titles = {'time', 'x', 'theta', 'v_x', 'v_theta'};
T = array2table(ty, 'VariableNames', titles);
writetable(T, 'sim-test.csv')

function dydt = f(~, y) % Correct
    z_theta = 1.0;
    z_x = 1.0;
    m_p = 1.0;
    m_c = 1.0;
    g = 9.8;
    l = 1.0;

    x = y(1);
    theta = y(2);
    v_x = y(3);
    v_theta = y(4);

    % theta = theta - pi;

    x_dot = v_x;
    theta_dot = v_theta;
    v_x_dot = (-v_x * z_x + v_theta/l*cos(theta)*z_theta + m_p * sin(theta) * (l*v_theta^2 + g * cos(theta))) / (m_p * sin(theta)^2 + m_c);
    v_theta_dot = -(l*m_p*cos(theta)*sin(theta)*v_theta^2 + z_theta * v_theta * (m_c + m_p)/(m_p * l) - z_x *cos(theta)*v_theta + g * sin(theta) * (m_c + m_p)) / (l * (m_p * sin(theta)^2 + m_c));
        
    dydt = [x_dot; theta_dot; v_x_dot; v_theta_dot];
end

function dydt = f_u(~, y) % Correct
    z_theta = 1.0;
    z_x = 1.0;
    m_p = 1.0;
    m_c = 1.0;
    g = 9.8;
    l = 1.0;

    x = y(1);
    theta = y(2);
    v_x = y(3);
    v_theta = y(4);

    kd_theta = 1;
    kp_theta = 50;
    Fx = kd_theta * v_theta - kp_theta * (theta - pi);

    x_dot = v_x;
    theta_dot = v_theta;
    v_x_dot = (Fx-v_x * z_x + v_theta/l*cos(theta)*z_theta + m_p * sin(theta) * (l*v_theta^2 + g * cos(theta))) / (m_p * sin(theta)^2 + m_c);
    v_theta_dot = -(Fx * cos(theta) + l*m_p*cos(theta)*sin(theta)*v_theta^2 + z_theta * v_theta * (m_c + m_p)/(m_p * l) - z_x *cos(theta)*v_theta + g * sin(theta) * (m_c + m_p)) / (l * (m_p * sin(theta)^2 + m_c));
        
    dydt = [x_dot; theta_dot; v_x_dot; v_theta_dot];
end

function dydt = f_lqr(~, y) % Correct
    z_theta = 1.0;
    z_x = 1.0;
    m_p = 1.0;
    m_c = 1.0;
    g = 9.8;
    l = 1.0;

    x = y(1);
    theta = y(2);
    v_x = y(3);
    v_theta = y(4);

    kp_x = -1;
    kp_theta = 49.6818;
    kd_x = -2.4777;
    kd_theta = 12.345;

    Fx = -(kd_theta * v_theta + kp_theta * (theta - pi) + kp_x * x + kd_x * v_x);

    x_dot = v_x;
    theta_dot = v_theta;
    v_x_dot = (Fx-v_x * z_x + v_theta/l*cos(theta)*z_theta + m_p * sin(theta) * (l*v_theta^2 + g * cos(theta))) / (m_p * sin(theta)^2 + m_c);
    v_theta_dot = -(Fx * cos(theta) + l*m_p*cos(theta)*sin(theta)*v_theta^2 + z_theta * v_theta * (m_c + m_p)/(m_p * l) - z_x *cos(theta)*v_theta + g * sin(theta) * (m_c + m_p)) / (l * (m_p * sin(theta)^2 + m_c));
        
    dydt = [x_dot; theta_dot; v_x_dot; v_theta_dot];
end
