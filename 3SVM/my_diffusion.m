function Jd=my_diffusion(J,method,N,K,dt,sigma2)
% private function: diffusion (by Guy Gilboa):
% Jd=3Ddiffusion(J,method,N,K)
% Simulates N iterations of diffusion, parameters:
% J =  source image (2D gray-level matrix) for diffusio
% method =  'lin':  Linear diffusion (constant c=1).
%           'pm1': perona-malik, c=exp{-(|grad(J)|/K)^2} [PM90]
%           'pm2': perona-malik, c=1/{1+(|grad(J)|/K)^2} [PM90]
%           'rmp': complex valued - ramp preserving [GSZ01]
% K    edge threshold parameter
% N    number of iterations
% dt   time increment (0 &lt; dt &lt;= 0.25, default 0.2)
% sigma2 - if present, calculates gradients of diffusion coefficient
%          convolved with gaussian of var sigma2 (Catte et al [CLMC92])

if ~exist('N')
   N=1;
end
if ~exist('K')
   K=1;
end
if ~exist('dt')
   dt=0.2;
end
if ~exist('sigma2')
   sigma2=0;
end       

[Ny,Nx]=size(J);

if (nargin<3)
   error('not enough arguments (at least 3 should be given)');
end

for i=1:N  
   % gaussian filter with kernel 5x5 (Catte et al)
   if (sigma2>0)
      Jo = J;   % save J original
      J=gauss(J,5,sigma2); 
   end

	% calculate gradient in all directions (N,S,E,W)
	In=[J(1,:); J(1:Ny-1,:)]-J;
	Is=[J(2:Ny,:); J(Ny,:)]-J;
	Ie=[J(:,2:Nx) J(:,Nx)]-J;
   Iw=[J(:,1) J(:,1:Nx-1)]-J;
In=double(In);
Is=double(Is);
Ie=double(Ie);
Iw=double(Iw);
	% calculate diffusion coefficients in all directions according to =
%method
   if (method == 'lin')
	   Cn=K; Cs=K; Ce=K; Cw=K;
   elseif (method == 'pm1')
      Cn=exp(-(abs(In)/K).^2);
		Cs=exp(-(abs(Is)/K).^2);
		Ce=exp(-(abs(Ie)/K).^2);
		Cw=exp(-(abs(Iw)/K).^2);
   elseif (method == 'pm2')
 	   Cn=1./(1+(abs(In)/K).^2);
		Cs=1./(1+(abs(Is)/K).^2);
		Ce=1./(1+(abs(Ie)/K).^2);
      Cw=1./(1+(abs(Iw)/K).^2);
   elseif (method == 'rmp')  % complex - ramp preserving
      k=K(1); theta=K(2); j=sqrt(-1);
 	   Cn=exp(j*theta)./(1+(imag(In)/(k*theta)).^2);
 	   Cs=exp(j*theta)./(1+(imag(Is)/(k*theta)).^2);
 	   Ce=exp(j*theta)./(1+(imag(Ie)/(k*theta)).^2);
      Cw=exp(j*theta)./(1+(imag(Iw)/(k*theta)).^2);
	else
      error(['Unknown method "' method '"']);
   end
  
   if (sigma2>0)   % calculate real gradiants (not smoothed)
   	In=[Jo(1,:); Jo(1:Ny-1,:)]-Jo;
		Is=[Jo(2:Ny,:); Jo(Ny,:)]-Jo;
		Ie=[Jo(:,2:Nx) Jo(:,Nx)]-Jo;
      Iw=[Jo(:,1) Jo(:,1:Nx-1)]-Jo;
      J=Jo;
	end

   % Next Image J
   Cn=double(Cn);
   Cs=double(Cs);
   Ce=double(Ce);
   Cw=double(Cw);
   J=double(J);
   dt=double(dt);
   J=J+dt*(Cn.*In + Cs.*Is + Ce.*Ie + Cw.*Iw);
end; % for i

Jd =J;


% % % %%%% Refs:
% % % % [PM90] P. Perona, J. Malik, "Scale-space and edge detection using =
% % % anisotropic diffusion", PAMI 12(7), pp. 629-639, 1990.&nbsp;
% % % % [CLMC92] F. Catte, P. L. Lions, J. M. Morel and T. Coll, "Image =
% % % selective smoothing and edge detection by nonlinear diffusion", SIAM J. =
% % % Num. Anal., vol. 29, no. 1, pp. 182-193, 1992.
% % % % [GSZ01] G. Gilboa, N. Sochen, Y. Y. Zeevi, "Complex Diffusion =
% % % Processes for Image Filtering", Scale-Space 2001, LNCS 2106, pp. =
% % % 299-307, Springer-Verlag 2001.


