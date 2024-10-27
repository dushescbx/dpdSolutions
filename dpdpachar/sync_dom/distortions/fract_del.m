function fract_del_symb_out = fract_del(fract_del_symb_in, del_val)
% строим символы с заданной скорректированной задержкой

x_mat = 1:(length(fract_del_symb_in));
xx_fixed_mat = x_mat + del_val;
yy_r_mat = spline(x_mat,real(fract_del_symb_in),xx_fixed_mat);
yy_i_mat = spline(x_mat,imag(fract_del_symb_in),xx_fixed_mat);
fract_del_symb_out = complex(yy_r_mat,yy_i_mat).';
% scatterplot(fract_del_symb_out);
% title(['after symbol sync known data delay vec =' num2str(del_val)]);