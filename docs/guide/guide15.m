%% 15. Chebfun2: Vector Calculus
% Alex Townsend, March 2013, latest revision December 2014

%% 15.1 What is a chebfun2v? 
% Chebfun2 objects represent vector-valued functions. We use a lower case
% letter like $f$ for a chebfun2 and an upper case letter like $F$ for a
% chebfun2v. 

%%
% Chebfun2 represents a vector-valued function $F(x,y) = (f(x,y);g(x,y))$ 
% by approximating each component by a low rank approximant, as described
% in Section 12.8.
% There are two ways to form a chebfun2v: either by explicitly 
% calling the constructor, or by
% vertical concatenation of two chebfun2 objects. 
% Here are these two alternatives:
d = [0 1 0 2];
F = chebfun2v(@(x,y) sin(x.*y), @(x,y) cos(y), d);
f = chebfun2(@(x,y) sin(x.*y), d);
g = chebfun2(@(x,y) cos(y), d);
G = [f;g]      

%% 
% Note that displaying a chebfun2v shows that it is a vector of two chebfun2
% objects.

%% 15.2 Algebraic operations 
% Chebfun2 objects are useful for performing 2D vector
% calculus. The basic algebraic operations are scalar multiplication, 
% vector addition, dot product and cross product. 

%%
% Scalar multiplication is the product of a scalar function with a 
% vector function:
f = chebfun2(@(x,y) exp(-(x.*y).^2/20), d);
f*F

%%  
% Vector addition yields another chebfun2v and satisfies the 
% parallelogram law:
plaw = abs((2*norm(F)^2 + 2*norm(G)^2) - (norm(F+G)^2 + norm(F-G)^2));
fprintf('Parallelogram law holds with error = %10.5e\n',plaw)

%%
% The dot product combines two vector functions into a scalar function. 
% If the dot product of two chebfun2v objects takes the value 
% zero at some $(x,y)$, then the vector-valued functions are orthogonal 
% there.  For example, the following code segment determines a curve along
% which two vector-valued functions are orthogonal:
LW = 'linewidth';
F = chebfun2v(@(x,y) sin(x.*y), @(x,y) cos(y),d);
G = chebfun2v(@(x,y) cos(4*x.*y), @(x,y) x + x.*y.^2,d);
plot(roots(dot(F,G)),LW,1.6), axis equal, axis(d)

%% 
% The cross product for 2D vector fields works as follows.

help chebfun2v/cross 

%% 15.3 Differential operators
% Vector calculus also involves various differential operators defined 
% on scalar- or vector-valued functions such as gradient, 
% curl, divergence, and Laplacian.

%%
% The gradient of a chebfun2 representing a scalar function $f(x,y)$
% represents, geometrically, the direction and magnitude 
% of steepest ascent of $f$. If the gradient of $f$ is $0$ at
% $(x,y)$, then $f$ has a critical point at $(x,y)$. Here are the
% critical points of a sum of Gaussian bumps:
f = chebfun2(0);
rng('default')
for k = 1:10 
    x0 = 2*rand-1; y0 = 2*rand-1;
    f = f + chebfun2(@(x,y) exp(-10*((x-x0).^2 + (y-y0).^2)));
end
plot(f), hold on 
r = roots(gradient(f));
plot3(r(:,1),r(:,2),f(r(:,1),r(:,2)),'k.','markersize',20)
zlim([0 4]), hold off, colormap(pink)

%%
% The curl of 2D vector function is a scalar function defined as
% follows.
help chebfun2v/curl 

%%
% If the chebfun2v $F$ describes a vector velocity field of fluid flow, 
% for example, then |curl(F)| is the scalar function equal
% to twice the angular speed of a particle in the flow at each point. 
% A particle moving in a gradient field has zero angular speed and hence,
% the curl of the gradient is zero.  We can check this numerically:
norm(curl(gradient(f)))

%% 
% The divergence of a chebfun2v is defined as follows.
help chebfun2v/divergence

%%
% This measures a vector field's distribution of sources or sinks.  
% The Laplacian is closely related and is the divergence of the gradient,
norm(laplacian(f) - divergence(gradient(f)))

%% 15.4 Line integrals 
% Given a vector field $F$, we can compute the line integral along a curve
% with the command |integral|, defined as follows.
help chebfun2v/integral

%%
% The gradient theorem says that if $F$ is a gradient field, then the 
% line integral along a smooth curve only depends on the end points of that
% curve. We can check this numerically:
f = chebfun2(@(x,y) cos(10*x.*y.^2) + exp(-x.^2));  % chebfun2
F = gradient(f);                                    % gradient (chebfun2v)
C = chebfun(@(t) t.*exp(10i*t),[0 1]);              % spiral curve
v = integral(F,C);ends = f(cos(10),sin(10))-f(0,0); % line integral
abs(v-ends)                                         % gradient theorem

%% 15.5 Phase diagram
% A phase diagram is a graphical representation of a system of 
% trajectories for a two-variable autonomous dynamical system.
% Chebfun2 plots phase 
% diagrams with |quiver| command, which has been overloaded to 
% plot the vector field. 
% Note that there is a potential terminological ambiguity in that a
% "phase portrait" can also refer to a portrait 
% of a complex-valued function (see section 12.7).

%%
% In addition, Chebfun2 makes it easy to compute and plot individual 
% trajectories of a vector field. If $F$ is a chebfun2v, then 
% |ode45(F,tspan,y0)| computes a trajectory of the
% autonomous system $dx/dt=f(x,y)$, $dy/dt=g(x,y)$,
% where $f$ and $g$ are the first and second components of $F$. Given a 
% prescribed time interval and initial conditions, this command returns a 
% complex-valued chebfun representing the trajectory in the form 
% $x(t) + iy(t)$. For example:
d = 0.04; a = 1; b = -.75;
F = chebfun2v(@(x,y)y, @(x,y)-d*y - b*x - a*x.^3, [-2 2 -2 2]);
[t y] = ode45(F,[0 40],[0,.5]);
plot(y,'r',LW,1.6), hold on,
quiver(F,'b'), axis equal
title('The Duffing oscillator','FontSize',14), hold off
