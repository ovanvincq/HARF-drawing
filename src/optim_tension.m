function x = optim_tension(param,Tmax,Pcore,precision)
%OPTIM_TENSION Summary of this function goes here
%   Detailed explanation goes here
lb=param.tension/2;
ub=param.tension*2;
func=@(x) compute_ecart_tension_RK(param,x,Tmax,Pcore);
options = optimset('TolX',precision);
x = fminbnd(func,lb,ub,options);

end

