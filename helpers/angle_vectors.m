function angle = angle_vectors(v,u)
% Returns the angle between two vectors with high numerical precision. 
%
% Inputs:
% 	v      -  3 x 1 vector (works for vector of arbitrary size)
%   u      -  3 x 1 vector 
% Outputs: 
%   angle  -  angle between the vectors
%
% Notes:
%   Based on notes by Kahan: https://people.eecs.berkeley.edu/~wkahan/Triangle.pdf
%
% Copyright (c) 2019 Nikolas Lamb
%

a = norm(v);
b = norm(u);

if (norm(v) < norm(u))
    a = norm(u);
    b = norm(v);
end

c = norm(v-u);

if (b >= c)
    mu = c-(a-b);
else
    mu = b-(a-c); 
end

angle = 2*atand(sqrt((((a-b)+c)*mu)./((a+(b+c))*((a-c)+b))));

end