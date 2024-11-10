function [d_out] = iq_dist_theory(d_in,param)

I = real(d_in);
Q = imag(d_in);
phi = param.phi_tx;
g = param.g_tx;
d_out_I = 1/2*(I-g*Q*sin(phi));
d_out_Q = 1/2*(g*Q*cos(phi));
d_out = complex(d_out_I, d_out_Q);
