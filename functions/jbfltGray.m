function B = jbfltGray( D, C, sigma_d, sigma_r, w )
% D should be a double precision matrix of size N*M*1£¨grayscale£©with
% normalized values in the closed interval [0,1].
% C should be similar to D, from which the weights are calculated, with
% normalized values in the closed interval[0,1].

% Pre-compute Gaussian distance weights.
[X, Y] = meshgrid ( -w:w, -w:w );
G = exp(-(X.^2+Y^2)/(2*sigma_d^2)); % spatial G
% Apply bilateral filter.
dim = size(D);
B = zeros(dim);
for i = 1:dim(1)
    for j = 1:dim(2)
        % extract local region from C & D.
        iMin = max(i-w, 1);
        iMax = min(i+w, dim(1));
        jMin = max(j-w, 1);
        jMax = min(j+w, dim(2));
        I = D(iMin : iMax, jMin : jMax );
        % to compute weights from the color image.
        J = C(iMin : iMax, jMin : jMax );
        % compute Gaussian intensity weights according to the color
        % image. 
        H = exp(-(J-C(i,j)).^2/(2*sigma_r^2));
        % calculate bilateral filter response.
        F = H.*G((iMin : iMax)-i+w+1, (jMin : jMax)-j+w+1);
        B(i,j) = sum ( F(:).*I(:) )/ sum( F(:) ) ;
    end
end
