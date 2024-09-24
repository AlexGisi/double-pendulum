from time import sleep
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.animation as animation


# Constants
L = 1  # Length of pendulum arms
DT = 1 / 40  # Timestep of the animation.
        
df = pd.read_csv('sim.csv')

# Interpolate to a constant time step.
new_index = pd.Index(np.arange(0, df.at[len(df)-1, 'time'], DT))
df = df.set_index('time')
df = df.reindex(df.index.union(new_index))
df = df.interpolate(method='linear')
df = df.reindex(new_index)
df = df.reset_index(names='time')

time = df['time']
theta1 = df['theta1']
theta2 = df['theta2']

# Calculate positions of the pendulum arms
x1 = L * np.sin(theta1)
y1 = -L * np.cos(theta1)

x2 = x1 + L * np.sin(theta1+theta2)
y2 = y1 - L * np.cos(theta1+theta2)

# Set up the figure and axis
fig, ax = plt.subplots(figsize=(8, 8))
ax.set_xlim(-2*L, 2*L)
ax.set_ylim(-2*L, 2*L)
ax.set_aspect('equal')
ax.grid(True)

# Initialize the line objects
line, = ax.plot([], [], 'o-', lw=2, color='darkblue')
trace, = ax.plot([], [], '-', lw=1, color='skyblue', alpha=0.7)
time_text = ax.text(0.05, 0.95, '', transform=ax.transAxes, fontsize=12)

# For storing trace
history_x, history_y = [], []

# Initialization function
def init():
    sleep(10)
    line.set_data([], [])
    trace.set_data([], [])
    time_text.set_text('')
    return line, trace, time_text

# Animation function
def animate(i):
    # Update line (pendulum arms and bobs)
    thisx = [0, x1[i], x2[i]]
    thisy = [0, y1[i], y2[i]]
    line.set_data(thisx, thisy)
    
    # Update trace (path of the second bob)
    history_x.append(x2[i])
    history_y.append(y2[i])
    trace.set_data(history_x, history_y)
    
    # Update time text
    time_text.set_text('Time = {:.2f} s'.format(time[i]))
    
    return line, trace, time_text

# Create the animation
ani = animation.FuncAnimation(fig, animate, frames=len(time),
                              interval=50, blit=True, init_func=init)

plt.title('Double Pendulum Simulation')
plt.show()
