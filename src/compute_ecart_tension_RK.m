function result = compute_ecart_tension_RK(param,tau0,Tmax,Pcore)
    fct=@(t,y) RK_perso(param,t,y,Tmax,Pcore);
    options_ode = odeset('Reltol',1E-10);
    T0=Tmax*param.profil(0)+273-param.dT0;
    sol=ode45(fct,[0 param.Lfour],[tau0,param.w0,param.R0^2*param.w0,param.r0^2*param.w0,T0],options_ode);
    fct=@(t,y) RK_perso_293K(param,t,y,Pcore);
    sol=ode45(fct,[param.Lfour param.L],sol.y(:,end),options_ode);
    t=sol.y(1,end);
    result=abs(param.tension-t)/param.tension;
end

