function [P,scaleFactor] = loc_gravLegendre( phi, maxdeg )
% loc_GRAVLEGENDRE internal function computing normalized associated 
% legendre polynomials, P, via recursion relations for spherical harmonic
% gravity 

P = zeros(maxdeg+3, maxdeg+3, length(phi));
scaleFactor = zeros(maxdeg+3, maxdeg+3, length(phi));
cphi = cos(pi/2-phi);
sphi = sin(pi/2-phi);

% force numerically zero values to be exactly zero
cphi(abs(cphi)<=eps) = 0;
sphi(abs(sphi)<=eps) = 0;
 
% Seeds for recursion formula
P(1,1,:) = 1;            % n = 0, m = 0;
P(2,1,:) = sqrt(3)*cphi; % n = 1, m = 0;
scaleFactor(1,1,:) = 0;
scaleFactor(2,1,:) = 1;
P(2,2,:) = sqrt(3)*sphi; % n = 1, m = 1;
scaleFactor(2,2,:) = 0;

for n = 2:maxdeg+2
    k = n + 1;
    for m = 0:n
        p = m + 1;
        % Compute normalized associated legendre polynomials, P, via recursion relations 
        % Scale Factor needed for normalization of dUdphi partial derivative
                
        if (n == m)           
            P(k,k,:) = sqrt(2*n+1)/sqrt(2*n)*sphi.*reshape(P(k-1,k-1,:),size(phi));
            scaleFactor(k,k,:) = 0;
        elseif (m == 0)
            P(k,p,:) = (sqrt(2*n+1)/n)*(sqrt(2*n-1)*cphi.*reshape(P(k-1,p,:),size(phi)) - (n-1)/sqrt(2*n-3)*reshape(P(k-2,p,:),size(phi)));
            scaleFactor(k,p,:) = sqrt( (n+1)*(n)/2);
        else
            P(k,p,:) = sqrt(2*n+1)/(sqrt(n+m)*sqrt(n-m))*(sqrt(2*n-1)*cphi.*reshape(P(k-1,p,:),size(phi)) - sqrt(n+m-1)*sqrt(n-m-1)/sqrt(2*n-3)*reshape(P(k-2,p,:),size(phi)));
            scaleFactor(k,p,:) = sqrt( (n+m+1)*(n-m));
        end
    end
end
end