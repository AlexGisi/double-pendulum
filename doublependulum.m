[t, y] = ode45(@f, [0 20], [pi-0.001; 0; 0; 0]);
plot(t, y);
xlabel('Time (s)');
ylabel('States');
legend('\theta_1', '\theta_2', '\omega_1', '\omega_2');

ty = [t y];
titles = {'time', 'theta1', 'theta2', 'omega1', 'omega2'};
T = array2table(ty, 'VariableNames', titles);
writetable(T, 'sim.csv')

function dydt = f(~, y)
    theta1 = y(1);
    theta2 = y(2);
    omega1 = y(3);
    omega2 = y(4);

    theta1_dot = omega1;
    theta2_dot = omega2;
    omega1_dot = ((981*sin(theta1 + theta2))/200 + (2943*sin(theta1))/200 - (omega2^2*sin(theta2))/2 - omega1*omega2*sin(theta2))/(3*(cos(theta2)^2/4 - 4/9)) - (((sin(theta2)*omega1^2)/2 + (981*sin(theta1 + theta2))/200)*(cos(theta2)/2 + 1/3))/(cos(theta2)^2/4 - 4/9);
    omega2_dot = ((cos(theta2) + 5/3)*((sin(theta2)*omega1^2)/2 + (981*sin(theta1 + theta2))/200))/(cos(theta2)^2/4 - 4/9) - ((cos(theta2)/2 + 1/3)*((981*sin(theta1 + theta2))/200 + (2943*sin(theta1))/200 - (omega2^2*sin(theta2))/2 - omega1*omega2*sin(theta2)))/(cos(theta2)^2/4 - 4/9);
        
    dydt = [theta1_dot; theta2_dot; omega1_dot; omega2_dot];
end

function dydt = f2(~, y)
    theta1 = y(1);
    theta2 = y(2);
    omega1 = y(3);
    omega2 = y(4);

    theta1_dot = omega1;
    theta2_dot = omega2;
    omega1_dot = (((981*sin(theta1 + theta2))/200 - (omega1^2*sin(theta2))/2)*(cos(theta2)/2 + 1/3))/(cos(theta2)^2/4 - 4/9) - ((sin(theta2)*omega2^2)/2 + omega1*sin(theta2)*omega2 + (981*sin(theta1 + theta2))/200 + (2943*sin(theta1))/200)/(3*(cos(theta2)^2/4 - 4/9));
    omega2_dot = ((cos(theta2)/2 + 1/3)*((sin(theta2)*omega2^2)/2 + omega1*sin(theta2)*omega2 + (981*sin(theta1 + theta2))/200 + (2943*sin(theta1))/200))/(cos(theta2)^2/4 - 4/9) - ((cos(theta2) + 5/3)*((981*sin(theta1 + theta2))/200 - (omega1^2*sin(theta2))/2))/(cos(theta2)^2/4 - 4/9);
        
    dydt = [theta1_dot; theta2_dot; omega1_dot; omega2_dot];
end
