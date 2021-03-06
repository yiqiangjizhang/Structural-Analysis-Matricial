function [eps,sig] = computeStrainStressBar(n_d,n_el,u,Td,x,Tn,mat,Tmat)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d        Problem's dimensions
%                  n_el       Total number of elements
%   - u     Global displacement vector [n_dof x 1]
%            u(I) - Total displacement on global DOF I
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%            Td(e,i) - DOF i associated to element e
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%   - Tmat  Material connectivities table [n_el]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - eps   Strain vector [n_el x 1]
%            eps(e) - Strain of bar e
%   - sig   Stress vector [n_el x 1]
%            sig(e) - Stress of bar e
%--------------------------------------------------------------------------

n_nod = size(Tn,2); % Number of nodes for each element
eps = zeros(n_el, 1); 
sig = zeros(n_el, 1);

% For each element
for e = 1:n_el
    % Compute the rotation matrix
    Le = 0;
    Re = zeros(2, n_d * n_nod);
    for n = 1:n_d
        xi = x(Tn(e,1), n);
        xj = x(Tn(e,2), n);
        Le = Le + (xj - xi)^2;
        Re(1, n) = xj - xi;
        Re(2, n_d + n) = xj - xi;
    end
    Le = sqrt(Le);
    Re = Re / Le;
    % Obtain element displacement in global coordinates
    ue = zeros(n_nod*n_d, 1);
    for i = 1:n_nod*n_d
        I = Td(e,i);
        ue(i,1) = u(I,1);
    end
    % Obtain element displacement in local coordinates
    ue_local = Re * ue;
    % Obtain element strain
    eps(e,1) = ([-1 1] * ue_local) / Le;
    % Compute element stress
    sig(e,1) = mat(Tmat(e), 1) * eps(e,1);
end

end